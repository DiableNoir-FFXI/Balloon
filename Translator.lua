local json = require("json")
local https = require("ssl.https")
local ltn12 = require("ltn12")
local url = require("socket.url")
local glossary = require("glossary")
local res = require("resources")
local plurals_list = res.items_grammar
https.TIMEOUT = 0.5
local adaptive_timeout = 0.3
local MAX_TIMEOUT = 5
local MARGIN = 0.2
local MAX_RETRIES = 3

local function get_zone_path(language_code, zone)
    return windower.addon_path .. "translations/" .. language_code .. "/" .. zone .. "/"
end

local function get_npc_folder(language_code, zone)
    return get_zone_path(language_code, zone) .. "npc/"
end

local function get_npc_cache_file(language_code, zone, npc)
    return get_npc_folder(language_code, zone) .. npc .. ".json"
end

local function ensure_folders(language_code, zone)
    local base = windower.addon_path .. "translations/"
    windower.create_dir(base)
    windower.create_dir(base .. language_code)
    windower.create_dir(base .. language_code .. "/" .. zone)
    windower.create_dir(base .. language_code .. "/" .. zone .. "/npc")
end

local translation_cache = {}
local translation_queue = {}
local queue_running = false
local function load_npc_cache(language_code, zone, npc)

    local file = get_npc_cache_file(language_code, zone, npc)

    local f = io.open(file, "r")

    if not f then
        return {}
    end

    local content = f:read("*all")
    f:close()

    if content and content ~= "" then
        local ok, data = pcall(json.decode, content)
        if ok and data then
            return data
        end
    end

    return {}
end

local inverted_glossary = {}
for original, replacement in pairs(glossary) do
    inverted_glossary[replacement] = original
end

local plurals_dict = {}
for _, item in pairs(plurals_list) do
    plurals_dict[item.plural] = true
end

local function escape_special_characters(phrase)
    local special_characters = "%%%^%$%(%)%.%[%]%*%+%-%?%'/%-"
    return (phrase:gsub("([" .. special_characters .. "])", "%%%1"))
end

local function apply_glossary(text, glossary)
    for phrase, replacement in pairs(glossary) do
        local escaped_phrase = escape_special_characters(phrase)
        text = text:gsub(escaped_phrase, replacement)
    end
    return text
end

local function restore_glossary(text, inverted_glossary)
    for replacement, original in pairs(inverted_glossary) do
        local escaped_replacement = escape_special_characters(replacement)
        text = string.gsub(text, escaped_replacement, original)
    end
    return text
end

local function apply_colored_text(text)
    local no_translate = {}
    local count = 0
    local modified_text = text

    for word in string.gmatch(text, "@%d+.-@93537") do
        count = count + 1
        local escaped_word = escape_special_characters(word)
        table.insert(no_translate, word)
        modified_text = string.gsub(modified_text, escaped_word, "__CT_" .. count .. "__", 1)
    end

    return modified_text, no_translate
end

local function restore_colored_text(text, no_translate)
    for k = 1, #no_translate do
        text = string.gsub(text, "__CT_" .. k .. "__", no_translate[k])
    end
    return text
end

local function adjust_articles_for_plurals(text, language)
    if language then
        local singular_articles = language.singular
        local plural_articles = language.plural
        for plural in pairs(plurals_dict) do
            local escaped_plural = escape_special_characters(plural)
            text = text:gsub(" " .. singular_articles.masc .. "%s+(@%d%d%d%d" .. escaped_plural .. "@93537)", " " .. plural_articles.masc .. " %1")
            text = text:gsub(" " .. singular_articles.fem .. "%s+(@%d%d%d%d" .. escaped_plural .. "@93537)", " " .. plural_articles.fem .. " %1")
        end
    end
    return text
end

local function save_npc_cache(language_code, zone, npc, cache)
    ensure_folders(language_code, zone)
    local file = get_npc_cache_file(language_code, zone, npc)
    local f = io.open(file, "w+")
    if not f then return end

    f:write("{\"_last_updated\":\"", os.date("!%Y-%m-%dT%H:%M:%SZ"), "\",\"translations\":{\n")

    local first = true
    for k, v in pairs(cache) do
        if k ~= "_last_updated" then
            if not first then
                f:write(",\n")
            end
            first = false
            local key = k:gsub('"', '\\"')
            local val = v:gsub('"', '\\"')
            f:write('  "', key, '":"', val, '"')
        end
    end

    f:write("\n}}\n")
    f:close()
end

local function adaptive_request(request_url)
    local tries = 0
    while tries < MAX_RETRIES do
        local start_time = os.clock()
        local response_body = {}
        https.TIMEOUT = adaptive_timeout

        local success, status_code = https.request{
            url = request_url,
            sink = ltn12.sink.table(response_body)
        }

        local elapsed = os.clock() - start_time

        local body = table.concat(response_body)

        if success and status_code == 200 and body ~= "" then
            adaptive_timeout = math.max(0.2, math.min(elapsed + MARGIN, MAX_TIMEOUT))
            return table.concat(response_body)
        else
            adaptive_timeout = math.min(adaptive_timeout * (1.3 + math.random() * 0.4), MAX_TIMEOUT)
            tries = tries + 1
            coroutine.yield()
        end
    end
    return nil
end

local function make_url(text, language)
    local modified_text, colored_words = apply_colored_text(text)
    modified_text = apply_glossary(modified_text, glossary)

    local GOOGLE_URL =
    "https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&dt=t&tl="
    local request_url = GOOGLE_URL .. language .. "&q=" .. url.escape(modified_text)
    return request_url, colored_words
end

function get_translation(text, language, npc_name, zone)

    if not language or not language.code then
        return nil
    end

    local lang_cache = translation_cache[language.code]
    if not lang_cache then
        lang_cache = {}
        translation_cache[language.code] = lang_cache
    end

    local zone_cache = lang_cache[zone]
    if not zone_cache then
        zone_cache = {}
        lang_cache[zone] = zone_cache
    end

    local npc_cache = zone_cache[npc_name]
    if not npc_cache then
        npc_cache = load_npc_cache(language.code, zone, npc_name)
        zone_cache[npc_name] = npc_cache
    end

    if npc_cache[text] then
        return npc_cache[text]
    end

    local request_url, colored_words = make_url(text, language.code)
    local reply = adaptive_request(request_url)

    if not reply then
        return nil
    end

    local ok, data = pcall(json.decode, reply)
    if not ok or not data then
        return nil
    end

    local output_table = {}
    for _, v in ipairs(data[1] or {}) do
        table.insert(output_table, v[1])
    end

    local final_text = restore_glossary(table.concat(output_table), inverted_glossary)
    final_text = restore_colored_text(final_text, colored_words)
    final_text = adjust_articles_for_plurals(final_text, language.articles)

    npc_cache[text] = final_text
    save_npc_cache(language.code, zone, npc_name, npc_cache)

    return final_text
end

local function process_translation_queue()
    if queue_running then
        return
    end

    queue_running = true

    coroutine.wrap(function()
        while #translation_queue > 0 do
            local task = table.remove(translation_queue, 1)

            local result = get_translation(
                task.text,
                task.language,
                task.npc_name,
                task.zone
            )

            if task.callback then
                task.callback(result)
            end
            coroutine.yield()
        end

        queue_running = false
    end)()
end

function get_translation_async(text, language, npc_name, zone, callback)

    table.insert(translation_queue, {
        text = text,
        language = language,
        npc_name = npc_name,
        zone = zone,
        callback = callback
    })

    process_translation_queue()
end
