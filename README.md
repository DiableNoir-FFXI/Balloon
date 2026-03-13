# 🎈 Balloon – Windower4 Addon

**NPC dialogue balloons for Final Fantasy XI**  
Addon Windower4 qui affiche les dialogues des NPC sous forme de bulles, inspiré des interfaces modernes de JRPG.  
Ce projet est un fork amélioré du projet original avec des fonctionnalités supplémentaires pour améliorer la traduction et les performances.

---

## 🇫🇷 Version Française

### ✨ Fonctionnalités
- Affichage des dialogues NPC en bulles
- Thèmes personnalisables
- Animation du texte
- Portraits de personnages
- Traduction automatique
- Support multilingue
- Bulles spécifiques par personnage
- Mise à l’échelle de l’interface
- Système de cache de traduction (ajouté dans ce fork)

### ⚙️ Commandes Principales
```text
//Bl             → Commande principale
//Bl 0           → Mode normal (log seulement)
//Bl 1           → Bulles uniquement
//Bl 2           → Bulles + log
//Bl reset       → Réinitialise la position des bulles
//Bl theme <theme> → Charge un thème depuis le dossier themes/
//Bl scale <valeur> → Change la taille de l’interface (ex : 1.5)
//Bl delay <secondes> → Délai avant fermeture des bulles sans prompt
//Bl move_closes → Active/Désactive la fermeture des bulles lors du déplacement
//Bl animate     → Active/Désactive l’animation du prompt
//Bl portrait    → Active/Désactive les portraits
//Bl translate   → Active/Désactive la traduction automatique
//Bl language <langue> → Change la langue de traduction (voir languages.lua)
```
Pour la traduction française avec ce fork :
```text
//Bl translate
//Bl language french
```
La première bulle peut mettre un court instant à s’afficher à cause du cache, puis ce sera instantané.
Si l’ordre n’est pas respecté, un reload de l’addon sera nécessaire.

⚠️ Attention : certains addons Windower comme Eternity (et probablement FastCS) ne sont pas compatibles avec cette version de Balloon.

###🎨 Thèmes et Bulles

Les thèmes se trouvent dans themes/

Chaque thème peut contenir :
Images des bulles
Configuration du thème
Portraits de personnages

Bulles spécifiques à certains NPC :
themes/<theme>/characters/<npc>.png

Exemple : themes/ffxi/characters/Iroha.png

La position des bulles peut être ajustée avec la souris.
La touche Scroll Lock permet de masquer les bulles.

###🌐 Ajouter une nouvelle langue

Dans languages.lua, ajoutez une entrée pour votre langue. Exemple :

return {
    ["french"] = {name = "Français", code = "fr"}
}

##🇬🇧 English Version

###✨ Features

NPC dialogue displayed as speech bubbles
Custom themes
Animated text display
Character portraits
Automatic translation
Multi-language support
Per-character balloons
Interface scaling
Translation cache system (added in this fork)

###⚙️ Main Commands
```text
//Bl             → Main command
//Bl 0           → Normal mode (log only)
//Bl 1           → Balloon display only
//Bl 2           → Balloon display + log
//Bl reset       → Reset balloon position
//Bl theme <theme> → Load a theme from themes/ folder
//Bl scale <value> → Scale interface (example: 1.5)
//Bl delay <seconds> → Delay before promptless balloons close
//Bl move_closes → Toggle closing balloons when moving
//Bl animate     → Toggle prompt animation
//Bl portrait    → Toggle character portraits
//Bl translate   → Toggle automatic translation
//Bl language <language> → Change translation language (see languages.lua)
```
To use French translation with this fork:
```text
//Bl translate
//Bl language french
```
The first balloon may take a very short moment due to caching, then it will be instant.
Reload the addon if the order is not respected.

⚠️ Warning: some Windower addons like Eternity (and probably FastCS) are not compatible with this version.

###🎨 Themes & Balloons

Themes are located in themes/

Each theme can contain:
Bubble images
Theme configuration
Character portraits

Per-NPC balloons:
themes/<theme>/characters/<npc>.png

Example: themes/ffxi/characters/Iroha.png

Bubble position adjustable with the mouse
Scroll Lock hides bubbles

###🌐 Adding a New Language

Add an entry in languages.lua. Example:

return {
    ["french"] = {name = "Français", code = "fr"}
}

###📜 Crédits / Credits

Original addon: Hando
Major modifications: Yuki and Ghosty
Improvements from fork: KenshiDRK
Additional improvements in this fork: DiableNoir

Original repository: https://github.com/StarlitGhost/Balloon.git
