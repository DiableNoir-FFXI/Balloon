Balloon – Windower4 Addon

NPC dialogue balloons for Final Fantasy XI.

Addon Windower4 qui affiche les dialogues des NPC sous forme de bulles, inspiré des interfaces modernes de JRPG.

Ce projet est un fork amélioré du projet original avec des fonctionnalités supplémentaires pour améliorer la traduction et les performances.

🇫🇷 Version Française
Fonctionnalités

Affichage des dialogues NPC en bulles

Thèmes personnalisables

Animation du texte

Portraits de personnages

Traduction automatique

Support multilingue

Bulles spécifiques par personnage

Mise à l’échelle de l’interface

Système de cache de traduction (ajouté dans ce fork)

Commandes

Commande principale :

 //Bl
Modes d'affichage
 //Bl 0

Mode normal (sans bulles, affichage dans le log)

 //Bl 1

Bulles uniquement

 //Bl 2

Bulles + log

Réglages
 //Bl reset

Réinitialise la position des bulles.

 //Bl theme <theme>

Charge un thème depuis le dossier themes/.

 //Bl scale <valeur>

Change la taille de l’interface (ex : 1.5).

 //Bl delay <secondes>

Délai avant fermeture des bulles sans prompt.

 //Bl move_closes

Active/Désactive la fermeture des bulles lors du déplacement.

 //Bl animate

Active/Désactive l’animation du prompt.

 //Bl portrait

Active/Désactive les portraits.

Traduction
 //Bl translate

Active/Désactive la traduction automatique.

 //Bl language <langue>

Change la langue de traduction (voir languages.lua).

Modifications de ce Fork

Ce fork inclut plusieurs améliorations.

Ajout du Français

Support de la langue française dans le système de traduction.

Exemple :

 //Bl language french
Système de cache de traduction

Un système de cache interne a été ajouté pour améliorer les performances.

Les traductions sont sauvegardées dans :

translation_cache.json

Fonctionnement :

L’addon vérifie si une traduction existe dans le cache.

Si oui → elle est utilisée immédiatement.

Sinon → l’API de traduction est utilisée.

La traduction est ensuite sauvegardée dans le cache.

Cela permet de :

réduire les appels API

éviter les micro-freeze

accélérer les dialogues déjà traduits

Thèmes

Les thèmes se trouvent dans :

themes/

Chaque thème peut contenir :

images des bulles

configuration du thème

portraits de personnages

Bulles spécifiques à certains NPC :

themes/<theme>/characters/

Exemple :

themes/ffxi/characters/Iroha.png
Notes

La position des bulles peut être ajustée avec la souris.

Certaines lignes système peuvent apparaître très brièvement selon le fonctionnement interne du jeu.

La touche Scroll Lock permet de masquer les bulles.

🇬🇧 English Version
Features

NPC dialogue displayed as speech bubbles

Custom themes

Animated text display

Character portraits

Automatic translation

Multi-language support

Per-character balloons

Interface scaling

Translation cache system (added in this fork)

Commands

Main command:

 //Bl
Display Modes
 //Bl 0

Normal mode (log only)

 //Bl 1

Balloon display only

 //Bl 2

Balloon display + log

Settings
 //Bl reset

Reset balloon position.

 //Bl theme <theme>

Load a theme from the themes/ folder.

 //Bl scale <value>

Scale the interface (example: 1.5).

 //Bl delay <seconds>

Delay before promptless balloons close.

 //Bl move_closes

Toggle closing balloons when moving.

 //Bl animate

Toggle prompt animation.

 //Bl portrait

Toggle character portraits.

Translation
 //Bl translate

Toggle automatic translation.

 //Bl language <language>

Change translation language (see languages.lua).

Fork Improvements

This fork includes several improvements.

French Language Support

Added French translation support.

Example:

 //Bl language french
Translation Cache System

A local translation cache has been implemented to improve performance.

Translations are stored in:

translation_cache.json

Workflow:

The addon checks if a translation exists in the cache.

If found → it is used instantly.

If not → the translation API is called.

The result is saved in the cache.

This helps:

reduce API calls

prevent micro-freezes

speed up repeated dialogue translations

Credits

Original addon

Hando

Major modifications

Yuki

Ghosty

Additional improvements in this fork

DiableNoir

French language support

Translation cache system

Original repository

https://github.com/StarlitGhost/Balloon
