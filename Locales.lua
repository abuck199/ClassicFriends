local _, addon = ...

local L = {}
addon.L = L

L.ADDON_TITLE = "Classic Friends"
L.VERSION = "Version %s"

-- Chat messages -----------------------------------------------------------------------------
L.CHAT_PREFIX = "Classic Friends:"
L.NO_FRIENDS_FRAME = "the friends window wasn't found, so the addon is inactive."
L.CONFLICT_WARNING = "ClassicUI Forever is also enabled and changes the same friends window. Disable one of them to avoid conflicts."
L.HELP_HEADER = "commands:"
L.HELP_LINES = {
	"  /cfriends           - open the friends list and the settings",
	"  /cfriends new       - open Forever's new social window once",
}

-- Minimap button ----------------------------------------------------------------------------
L.MINIMAP_TIP_LEFT = "Left-click: settings"
L.MINIMAP_TIP_RIGHT = "Right-click: friends list"
L.MINIMAP_TIP_DRAG = "Drag to move around the minimap"

-- Friends window ----------------------------------------------------------------------------
L.SETTINGS_BUTTON_TOOLTIP = "Classic Friends settings"
L.SEARCH_PLACEHOLDER = "BattleTag, name, class, zone"
L.SEARCH_TOOLTIP_HEADER = "Find friends by:"
L.SEARCH_FIELDS = {
	"BattleTag (Battle.net friends)",
	"Character name",
	"Class or race",
	"Zone",
	"Realm",
}
L.SEARCH_TIP = "Type several words to narrow it down, e.g. \"warrior desolace\"."
L.SEARCH_NO_RESULTS = "No results"
L.NOT_IN_GUILD = "You are not in a guild."

-- Friend rows -------------------------------------------------------------------------------
L.LEVEL_SHORT = "Lvl %d"
L.VERSION_SEPARATOR = " · "
L.VERSION_RETAIL = "Retail"
L.VERSION_CLASSIC = "Classic"
L.VERSION_PLUNDERSTORM = "Plunderstorm"
L.VERSION_TBC = "TBC Classic"
L.VERSION_WRATH = "Wrath Classic"
L.VERSION_CATA = "Cata Classic"
L.VERSION_MISTS = "Mists Classic"
L.VERSION_FOREVER = "Forever"
L.VERSION_OTHER = "Other version"
L.RULESET_PVP = "PvP"
L.RULESET_PVE = "PvE"
L.OTHER_RULESET_INVITE = "%s realm: you can't group with this friend."

-- Settings panel ----------------------------------------------------------------------------
L.SECTION_GENERAL = "General"
L.SECTION_LIST = "Friends List"

L.ENABLED_PANEL = "Classic friends window"
L.ENABLED_DESC = "Replaces Forever's new social window"
L.ENABLED_TOOLTIP = "Open the classic friends list instead of Forever's new social window.\n\nTurn off to get Forever's window back without disabling the addon."

L.CHATBUTTON_PANEL = "Chat friends button"
L.CHATBUTTON_DESC = "The button next to chat opens it too"
L.CHATBUTTON_TOOLTIP = "The friends button next to the chat box opens the classic window.\n\nQuick-join notifications on that button always open Forever's Quick Join list."

L.BOTTOMTABS_PANEL = "Classic bottom tabs"
L.BOTTOMTABS_DESC = "Friends, Who, Guild, Raid under the list"
L.BOTTOMTABS_TOOLTIP = "Classic Era's tabs under the window. Who, Guild and Raid open their own windows."

L.MINIMAPBUTTON_PANEL = "Minimap button"
L.MINIMAPBUTTON_DESC = "Opens these settings and the friends list"
L.MINIMAPBUTTON_TOOLTIP = "A button on the edge of the minimap.\n\nLeft-click opens these settings, right-click opens the friends list. Drag it to move it around the minimap."

L.FACTIONCOLORS_PANEL = "Faction colors"
L.FACTIONCOLORS_DESC = "Red for Horde, blue for Alliance"
L.FACTIONCOLORS_TOOLTIP = "Tint the rows of friends playing Forever red for Horde or blue for Alliance.\n\nFriends in another WoW version (Retail, Classic...) keep the normal row, since you can't play with them."

L.CLASSCOLORS_PANEL = "Class colors"
L.CLASSCOLORS_DESC = "Class colors, your zone in green"
L.CLASSCOLORS_TOOLTIP = "Show online friends' character names in their class color.\n\nFriends in the zone you're in have their zone shown in green."
L.LEVELS_PANEL = "Level"
L.LEVELS_DESC = "Level and WoW version under the name"
L.LEVELS_TOOLTIP = "Show the character's level under each online friend's name, after their zone.\n\nFriends in another WoW version also show which one, e.g. \"Lvl 80 · Retail\"."

L.SEARCH_PANEL = "Search box"
L.SEARCH_DESC = "Search by BattleTag, name, class, zone"
L.SEARCH_TOOLTIP = "A search box above the list. Searches BattleTag, character name, class, race, zone and realm."

L.REQUIRES = "Needs \"%s\" turned on."

L.RELOAD_PROMPT = "Reload the interface to finish switching the friends window?"
L.RELOAD_LATER = "Later"

L.GITHUB_TITLE = "Bugs and suggestions"
L.GITHUB_LINK = "Report a bug or suggest an idea"
L.GITHUB_TOOLTIP = "Found a bug, or have an idea to make the addon better? Click to get the link to its GitHub page."
L.GITHUB_COPY = "Press Ctrl+C to copy the link, then paste it into your browser."
L.GITHUB_COPIED = "Copied!"

local locale = GetLocale()

-- French ------------------------------------------------------------------------------------
if locale == "frFR" then
	L.ADDON_TITLE = "Classic Friends"
	L.VERSION = "Version %s"

	L.CHAT_PREFIX = "Classic Friends :"
	L.NO_FRIENDS_FRAME = "la fenêtre d'amis est introuvable, l'addon est désactivé."
	L.CONFLICT_WARNING = "ClassicUI Forever est aussi activé et modifie la même fenêtre d'amis. Désactivez l'un des deux pour éviter les conflits."
	L.HELP_HEADER = "commandes :"
	L.HELP_LINES = {
		"  /cfriends           - ouvrir la liste d'amis et les options",
		"  /cfriends new       - ouvrir une fois la nouvelle fenêtre sociale de Forever",
	}

	L.MINIMAP_TIP_LEFT = "Clic gauche : options"
	L.MINIMAP_TIP_RIGHT = "Clic droit : liste d'amis"
	L.MINIMAP_TIP_DRAG = "Glisser pour le déplacer autour de la minicarte"

	L.SETTINGS_BUTTON_TOOLTIP = "Options de Classic Friends"
	L.SEARCH_PLACEHOLDER = "BattleTag, nom, classe, zone"
	L.SEARCH_TOOLTIP_HEADER = "Rechercher des amis par :"
	L.SEARCH_FIELDS = {
		"BattleTag (amis Battle.net)",
		"Nom du personnage",
		"Classe ou race",
		"Zone",
		"Royaume",
	}
	L.SEARCH_TIP = "Tapez plusieurs mots pour affiner, par ex. \"guerrier désolace\"."
	L.SEARCH_NO_RESULTS = "Aucun résultat"
	L.NOT_IN_GUILD = "Vous n'êtes pas dans une guilde."

	L.LEVEL_SHORT = "Niv. %d"
	L.VERSION_RETAIL = "Retail"
	L.VERSION_CLASSIC = "Classic"
	L.VERSION_PLUNDERSTORM = "Plunderstorm"
	L.VERSION_TBC = "TBC Classic"
	L.VERSION_WRATH = "Wrath Classic"
	L.VERSION_CATA = "Cata Classic"
	L.VERSION_MISTS = "Mists Classic"
	L.VERSION_FOREVER = "Forever"
	L.VERSION_OTHER = "Autre version"
	L.RULESET_PVP = "JcJ"
	L.RULESET_PVE = "JcE"
	L.OTHER_RULESET_INVITE = "Royaume %s : vous ne pouvez pas grouper avec cet ami."

	L.SECTION_GENERAL = "Général"
	L.SECTION_LIST = "Liste d'amis"

	L.ENABLED_PANEL = "Fenêtre d'amis classique"
	L.ENABLED_DESC = "Remplace la nouvelle fenêtre de Forever"
	L.ENABLED_TOOLTIP = "Ouvre la liste d'amis classique au lieu de la nouvelle fenêtre sociale de Forever.\n\nDésactivez pour retrouver la fenêtre de Forever sans désactiver l'addon."

	L.CHATBUTTON_PANEL = "Bouton d'amis du chat"
	L.CHATBUTTON_DESC = "Le bouton à côté du chat l'ouvre aussi"
	L.CHATBUTTON_TOOLTIP = "Le bouton d'amis à côté du chat ouvre la fenêtre classique.\n\nLes notifications de groupe rapide sur ce bouton ouvrent toujours la liste de Forever."

	L.BOTTOMTABS_PANEL = "Onglets classiques en bas"
	L.BOTTOMTABS_DESC = "Amis, Qui, Guilde et Raid sous la liste"
	L.BOTTOMTABS_TOOLTIP = "Les onglets de Classic Era sous la fenêtre. Qui, Guilde et Raid ouvrent leur propre fenêtre."

	L.MINIMAPBUTTON_PANEL = "Bouton de la minicarte"
	L.MINIMAPBUTTON_DESC = "Ouvre ces options et la liste d'amis"
	L.MINIMAPBUTTON_TOOLTIP = "Un bouton au bord de la minicarte.\n\nClic gauche : ces options, clic droit : la liste d'amis. Glissez-le pour le déplacer autour de la minicarte."

	L.FACTIONCOLORS_PANEL = "Couleurs de faction"
	L.FACTIONCOLORS_DESC = "Rouge pour la Horde, bleu pour l'Alliance"
	L.FACTIONCOLORS_TOOLTIP = "Colore les lignes des amis qui jouent à Forever : rouge pour la Horde, bleu pour l'Alliance.\n\nLes amis sur une autre version de WoW (Retail, Classic...) gardent la ligne normale, car vous ne pouvez pas jouer avec eux."

	L.CLASSCOLORS_PANEL = "Couleurs de classe"
	L.CLASSCOLORS_DESC = "Couleurs de classe, zone en vert"
	L.CLASSCOLORS_TOOLTIP = "Affiche le nom des personnages de vos amis en ligne dans la couleur de leur classe.\n\nLes amis dans votre zone ont leur zone affichée en vert."
	L.LEVELS_PANEL = "Niveau"
	L.LEVELS_DESC = "Niveau et version de WoW sous le nom"
	L.LEVELS_TOOLTIP = "Affiche le niveau du personnage sous le nom de vos amis en ligne, après leur zone.\n\nLes amis sur une autre version de WoW indiquent laquelle, par ex. \"Niv. 80 · Retail\"."

	L.SEARCH_PANEL = "Champ de recherche"
	L.SEARCH_DESC = "Chercher par BattleTag, nom, classe, zone"
	L.SEARCH_TOOLTIP = "Un champ de recherche au-dessus de la liste. Cherche dans le BattleTag, le nom du personnage, la classe, la race, la zone et le royaume."

	L.REQUIRES = "Nécessite d'activer \"%s\"."

	L.RELOAD_PROMPT = "Recharger l'interface pour terminer le changement de fenêtre d'amis ?"
	L.RELOAD_LATER = "Plus tard"

	L.GITHUB_TITLE = "Bugs et suggestions"
	L.GITHUB_LINK = "Signaler un bug ou proposer une idée"
	L.GITHUB_TOOLTIP = "Un bug, ou une idée pour améliorer l'addon ? Clique pour obtenir le lien de sa page GitHub."
	L.GITHUB_COPY = "Fais Ctrl+C pour copier le lien, puis colle-le dans ton navigateur."
	L.GITHUB_COPIED = "Copié !"
end

-- German ------------------------------------------------------------------------------------
if locale == "deDE" then
	L.NO_FRIENDS_FRAME = "das Freundesfenster wurde nicht gefunden, das Addon ist inaktiv."
	L.CONFLICT_WARNING = "ClassicUI Forever ist ebenfalls aktiviert und verändert dasselbe Freundesfenster. Deaktiviere eines der beiden, um Konflikte zu vermeiden."
	L.HELP_HEADER = "Befehle:"
	L.HELP_LINES = {
		"  /cfriends           - Freundesliste und Optionen öffnen",
		"  /cfriends new       - Forevers neues Sozialfenster einmal öffnen",
	}

	L.MINIMAP_TIP_LEFT = "Linksklick: Optionen"
	L.MINIMAP_TIP_RIGHT = "Rechtsklick: Freundesliste"
	L.MINIMAP_TIP_DRAG = "Ziehen, um ihn um die Minikarte zu bewegen"

	L.SETTINGS_BUTTON_TOOLTIP = "Classic Friends-Optionen"
	L.SEARCH_PLACEHOLDER = "BattleTag, Name, Klasse, Zone"
	L.SEARCH_TOOLTIP_HEADER = "Freunde finden nach:"
	L.SEARCH_FIELDS = {
		"BattleTag (Battle.net-Freunde)",
		"Charaktername",
		"Klasse oder Volk",
		"Zone",
		"Realm",
	}
	L.SEARCH_TIP = "Mehrere Wörter grenzen die Suche ein, z. B. \"krieger desolace\"."
	L.SEARCH_NO_RESULTS = "Keine Ergebnisse"
	L.NOT_IN_GUILD = "Du bist in keiner Gilde."

	L.LEVEL_SHORT = "Stufe %d"
	L.VERSION_OTHER = "Andere Version"
	L.OTHER_RULESET_INVITE = "%s-Realm: Ihr könnt mit diesem Freund keine Gruppe bilden."

	L.SECTION_GENERAL = "Allgemein"
	L.SECTION_LIST = "Freundesliste"

	L.ENABLED_PANEL = "Klassisches Freundesfenster"
	L.ENABLED_DESC = "Ersetzt Forevers neues Sozialfenster"
	L.ENABLED_TOOLTIP = "Öffnet die klassische Freundesliste statt Forevers neuem Sozialfenster.\n\nAusschalten, um Forevers Fenster zurückzubekommen, ohne das Addon zu deaktivieren."

	L.CHATBUTTON_PANEL = "Freunde-Knopf am Chat"
	L.CHATBUTTON_DESC = "Der Knopf neben dem Chat öffnet es auch"
	L.CHATBUTTON_TOOLTIP = "Der Freunde-Knopf neben dem Chatfenster öffnet das klassische Fenster.\n\nSchnellbeitritt-Hinweise auf diesem Knopf öffnen weiterhin Forevers Liste."

	L.BOTTOMTABS_PANEL = "Klassische Reiter unten"
	L.BOTTOMTABS_DESC = "Freunde, Wer, Gilde, Schlachtzug unten"
	L.BOTTOMTABS_TOOLTIP = "Die Reiter aus Classic Era unter dem Fenster. Wer, Gilde und Schlachtzug öffnen ihr eigenes Fenster."

	L.MINIMAPBUTTON_PANEL = "Minikarten-Knopf"
	L.MINIMAPBUTTON_DESC = "Öffnet Optionen und Freundesliste"
	L.MINIMAPBUTTON_TOOLTIP = "Ein Knopf am Rand der Minikarte.\n\nLinksklick öffnet diese Optionen, Rechtsklick die Freundesliste. Ziehen, um ihn um die Minikarte zu bewegen."

	L.FACTIONCOLORS_PANEL = "Fraktionsfarben"
	L.FACTIONCOLORS_DESC = "Rot für die Horde, Blau für die Allianz"
	L.FACTIONCOLORS_TOOLTIP = "Färbt die Zeilen von Freunden in Forever rot für die Horde und blau für die Allianz.\n\nFreunde in einer anderen WoW-Version (Retail, Classic...) behalten die normale Zeile, da ihr nicht zusammen spielen könnt."

	L.CLASSCOLORS_PANEL = "Klassenfarben"
	L.CLASSCOLORS_DESC = "Klassenfarben, deine Zone in Grün"
	L.CLASSCOLORS_TOOLTIP = "Zeigt die Charakternamen deiner Freunde in ihrer Klassenfarbe.\n\nBei Freunden in deiner Zone wird die Zone grün angezeigt."
	L.LEVELS_PANEL = "Stufe"
	L.LEVELS_DESC = "Stufe und WoW-Version unter dem Namen"
	L.LEVELS_TOOLTIP = "Zeigt die Stufe des Charakters unter dem Namen deiner Freunde, nach ihrer Zone.\n\nFreunde in einer anderen WoW-Version zeigen auch welche, z. B. \"Stufe 80 · Retail\"."

	L.SEARCH_PANEL = "Suchfeld"
	L.SEARCH_DESC = "Suche nach BattleTag, Name, Klasse, Zone"
	L.SEARCH_TOOLTIP = "Ein Suchfeld über der Liste. Durchsucht BattleTag, Charaktername, Klasse, Volk, Zone und Realm."

	L.REQUIRES = "Benötigt \"%s\"."

	L.RELOAD_PROMPT = "Interface neu laden, um den Wechsel des Freundesfensters abzuschließen?"
	L.RELOAD_LATER = "Später"

	L.GITHUB_TITLE = "Fehler und Vorschläge"
	L.GITHUB_LINK = "Fehler melden oder Idee vorschlagen"
	L.GITHUB_TOOLTIP = "Einen Fehler gefunden oder eine Idee, wie das Addon besser wird? Klicke, um den Link zur GitHub-Seite zu erhalten."
	L.GITHUB_COPY = "Drücke Strg+C, um den Link zu kopieren, und füge ihn dann in deinen Browser ein."
	L.GITHUB_COPIED = "Kopiert!"
end

-- Spanish -----------------------------------------------------------------------------------
if locale == "esES" or locale == "esMX" then
	L.NO_FRIENDS_FRAME = "no se encontró la ventana de amigos, el addon está inactivo."
	L.CONFLICT_WARNING = "ClassicUI Forever también está activado y modifica la misma ventana de amigos. Desactiva uno de los dos para evitar conflictos."
	L.HELP_HEADER = "comandos:"
	L.HELP_LINES = {
		"  /cfriends           - abrir la lista de amigos y las opciones",
		"  /cfriends new       - abrir una vez la nueva ventana social de Forever",
	}

	L.MINIMAP_TIP_LEFT = "Clic izquierdo: opciones"
	L.MINIMAP_TIP_RIGHT = "Clic derecho: lista de amigos"
	L.MINIMAP_TIP_DRAG = "Arrastra para moverlo alrededor del minimapa"

	L.SETTINGS_BUTTON_TOOLTIP = "Opciones de Classic Friends"
	L.SEARCH_PLACEHOLDER = "BattleTag, nombre, clase, zona"
	L.SEARCH_TOOLTIP_HEADER = "Buscar amigos por:"
	L.SEARCH_FIELDS = {
		"BattleTag (amigos de Battle.net)",
		"Nombre del personaje",
		"Clase o raza",
		"Zona",
		"Reino",
	}
	L.SEARCH_TIP = "Escribe varias palabras para afinar, p. ej. \"guerrero desolace\"."
	L.SEARCH_NO_RESULTS = "Sin resultados"
	L.NOT_IN_GUILD = "No estás en una hermandad."

	L.LEVEL_SHORT = "Nv. %d"
	L.VERSION_OTHER = "Otra versión"
	L.RULESET_PVP = "JcJ"
	L.RULESET_PVE = "JcE"
	L.OTHER_RULESET_INVITE = "Reino %s: no puedes agruparte con este amigo."

	L.SECTION_GENERAL = "General"
	L.SECTION_LIST = "Lista de amigos"

	L.ENABLED_PANEL = "Ventana de amigos clásica"
	L.ENABLED_DESC = "Sustituye la nueva ventana de Forever"
	L.ENABLED_TOOLTIP = "Abre la lista de amigos clásica en lugar de la nueva ventana social de Forever.\n\nDesactívalo para recuperar la ventana de Forever sin desactivar el addon."

	L.CHATBUTTON_PANEL = "Botón de amigos del chat"
	L.CHATBUTTON_DESC = "El botón junto al chat también la abre"
	L.CHATBUTTON_TOOLTIP = "El botón de amigos junto al chat abre la ventana clásica.\n\nLos avisos de unión rápida en ese botón siguen abriendo la lista de Forever."

	L.BOTTOMTABS_PANEL = "Pestañas clásicas abajo"
	L.BOTTOMTABS_DESC = "Amigos, Quién, Hermandad, Banda abajo"
	L.BOTTOMTABS_TOOLTIP = "Las pestañas de Classic Era bajo la ventana. Quién, Hermandad y Banda abren su propia ventana."

	L.MINIMAPBUTTON_PANEL = "Botón del minimapa"
	L.MINIMAPBUTTON_DESC = "Abre estas opciones y la lista de amigos"
	L.MINIMAPBUTTON_TOOLTIP = "Un botón en el borde del minimapa.\n\nClic izquierdo abre estas opciones, clic derecho la lista de amigos. Arrástralo para moverlo alrededor del minimapa."

	L.FACTIONCOLORS_PANEL = "Colores de facción"
	L.FACTIONCOLORS_DESC = "Rojo para la Horda, azul para la Alianza"
	L.FACTIONCOLORS_TOOLTIP = "Colorea las filas de los amigos que juegan a Forever: rojo para la Horda, azul para la Alianza.\n\nLos amigos en otra versión de WoW (Retail, Classic...) mantienen la fila normal, ya que no puedes jugar con ellos."

	L.CLASSCOLORS_PANEL = "Colores de clase"
	L.CLASSCOLORS_DESC = "Color de clase, tu zona en verde"
	L.CLASSCOLORS_TOOLTIP = "Muestra el nombre del personaje de tus amigos en línea en el color de su clase.\n\nLos amigos en tu zona muestran su zona en verde."
	L.LEVELS_PANEL = "Nivel"
	L.LEVELS_DESC = "Nivel y versión de WoW bajo el nombre"
	L.LEVELS_TOOLTIP = "Muestra el nivel del personaje bajo el nombre de tus amigos en línea, después de su zona.\n\nLos amigos en otra versión de WoW indican cuál, p. ej. \"Nv. 80 · Retail\"."

	L.SEARCH_PANEL = "Campo de búsqueda"
	L.SEARCH_DESC = "Busca por BattleTag, nombre, clase, zona"
	L.SEARCH_TOOLTIP = "Un campo de búsqueda sobre la lista. Busca en BattleTag, nombre del personaje, clase, raza, zona y reino."

	L.REQUIRES = "Requiere activar \"%s\"."

	L.RELOAD_PROMPT = "¿Recargar la interfaz para terminar de cambiar la ventana de amigos?"
	L.RELOAD_LATER = "Más tarde"

	L.GITHUB_TITLE = "Errores y sugerencias"
	L.GITHUB_LINK = "Informar de un error o sugerir una idea"
	L.GITHUB_TOOLTIP = "¿Has encontrado un error o tienes una idea para mejorar el addon? Haz clic para obtener el enlace a su página de GitHub."
	L.GITHUB_COPY = "Pulsa Ctrl+C para copiar el enlace y pégalo en tu navegador."
	L.GITHUB_COPIED = "¡Copiado!"
end

-- Italian -----------------------------------------------------------------------------------
if locale == "itIT" then
	L.NO_FRIENDS_FRAME = "la finestra degli amici non è stata trovata, l'addon è inattivo."
	L.CONFLICT_WARNING = "Anche ClassicUI Forever è attivo e modifica la stessa finestra degli amici. Disattivane uno per evitare conflitti."
	L.HELP_HEADER = "comandi:"
	L.HELP_LINES = {
		"  /cfriends           - apri la lista amici e le opzioni",
		"  /cfriends new       - apri una volta la nuova finestra social di Forever",
	}

	L.MINIMAP_TIP_LEFT = "Clic sinistro: opzioni"
	L.MINIMAP_TIP_RIGHT = "Clic destro: lista amici"
	L.MINIMAP_TIP_DRAG = "Trascina per spostarlo intorno alla minimappa"

	L.SETTINGS_BUTTON_TOOLTIP = "Opzioni di Classic Friends"
	L.SEARCH_PLACEHOLDER = "BattleTag, nome, classe, zona"
	L.SEARCH_TOOLTIP_HEADER = "Trova amici per:"
	L.SEARCH_FIELDS = {
		"BattleTag (amici Battle.net)",
		"Nome del personaggio",
		"Classe o razza",
		"Zona",
		"Reame",
	}
	L.SEARCH_TIP = "Scrivi più parole per restringere, ad es. \"guerriero desolace\"."
	L.SEARCH_NO_RESULTS = "Nessun risultato"
	L.NOT_IN_GUILD = "Non sei in una gilda."

	L.LEVEL_SHORT = "Liv. %d"
	L.VERSION_OTHER = "Altra versione"
	L.OTHER_RULESET_INVITE = "Reame %s: non puoi formare un gruppo con questo amico."

	L.SECTION_GENERAL = "Generale"
	L.SECTION_LIST = "Lista amici"

	L.ENABLED_PANEL = "Finestra amici classica"
	L.ENABLED_DESC = "Sostituisce la nuova finestra di Forever"
	L.ENABLED_TOOLTIP = "Apre la lista amici classica al posto della nuova finestra social di Forever.\n\nDisattivala per riavere la finestra di Forever senza disattivare l'addon."

	L.CHATBUTTON_PANEL = "Pulsante amici della chat"
	L.CHATBUTTON_DESC = "Anche il pulsante della chat la apre"
	L.CHATBUTTON_TOOLTIP = "Il pulsante amici accanto alla chat apre la finestra classica.\n\nGli avvisi di partecipazione rapida su quel pulsante aprono sempre la lista di Forever."

	L.BOTTOMTABS_PANEL = "Schede classiche in basso"
	L.BOTTOMTABS_DESC = "Amici, Chi, Gilda, Incursione in basso"
	L.BOTTOMTABS_TOOLTIP = "Le schede di Classic Era sotto la finestra. Chi, Gilda e Incursione aprono la propria finestra."

	L.MINIMAPBUTTON_PANEL = "Pulsante della minimappa"
	L.MINIMAPBUTTON_DESC = "Apre queste opzioni e la lista amici"
	L.MINIMAPBUTTON_TOOLTIP = "Un pulsante sul bordo della minimappa.\n\nClic sinistro apre queste opzioni, clic destro la lista amici. Trascinalo per spostarlo intorno alla minimappa."

	L.FACTIONCOLORS_PANEL = "Colori di fazione"
	L.FACTIONCOLORS_DESC = "Rosso per l'Orda, blu per l'Alleanza"
	L.FACTIONCOLORS_TOOLTIP = "Colora le righe degli amici che giocano a Forever: rosso per l'Orda, blu per l'Alleanza.\n\nGli amici su un'altra versione di WoW (Retail, Classic...) mantengono la riga normale, perché non puoi giocare con loro."

	L.CLASSCOLORS_PANEL = "Colori di classe"
	L.CLASSCOLORS_DESC = "Colori di classe, zona in verde"
	L.CLASSCOLORS_TOOLTIP = "Mostra il nome del personaggio dei tuoi amici online nel colore della sua classe.\n\nGli amici nella tua zona hanno la zona in verde."
	L.LEVELS_PANEL = "Livello"
	L.LEVELS_DESC = "Livello e versione di WoW sotto il nome"
	L.LEVELS_TOOLTIP = "Mostra il livello del personaggio sotto il nome dei tuoi amici online, dopo la zona.\n\nGli amici su un'altra versione di WoW indicano quale, ad es. \"Liv. 80 · Retail\"."

	L.SEARCH_PANEL = "Campo di ricerca"
	L.SEARCH_DESC = "Cerca per BattleTag, nome, classe, zona"
	L.SEARCH_TOOLTIP = "Un campo di ricerca sopra la lista. Cerca in BattleTag, nome del personaggio, classe, razza, zona e reame."

	L.REQUIRES = "Richiede di attivare \"%s\"."

	L.RELOAD_PROMPT = "Ricaricare l'interfaccia per completare il cambio della finestra degli amici?"
	L.RELOAD_LATER = "Più tardi"

	L.GITHUB_TITLE = "Bug e suggerimenti"
	L.GITHUB_LINK = "Segnala un bug o proponi un'idea"
	L.GITHUB_TOOLTIP = "Hai trovato un bug o hai un'idea per migliorare l'addon? Clicca per ottenere il link alla sua pagina GitHub."
	L.GITHUB_COPY = "Premi Ctrl+C per copiare il link, poi incollalo nel browser."
	L.GITHUB_COPIED = "Copiato!"
end

-- Brazilian Portuguese ----------------------------------------------------------------------
if locale == "ptBR" then
	L.NO_FRIENDS_FRAME = "a janela de amigos não foi encontrada, o addon está inativo."
	L.CONFLICT_WARNING = "O ClassicUI Forever também está ativado e altera a mesma janela de amigos. Desative um dos dois para evitar conflitos."
	L.HELP_HEADER = "comandos:"
	L.HELP_LINES = {
		"  /cfriends           - abrir a lista de amigos e as opções",
		"  /cfriends new       - abrir uma vez a nova janela social do Forever",
	}

	L.MINIMAP_TIP_LEFT = "Clique esquerdo: opções"
	L.MINIMAP_TIP_RIGHT = "Clique direito: lista de amigos"
	L.MINIMAP_TIP_DRAG = "Arraste para movê-lo ao redor do minimapa"

	L.SETTINGS_BUTTON_TOOLTIP = "Opções do Classic Friends"
	L.SEARCH_PLACEHOLDER = "BattleTag, nome, classe, zona"
	L.SEARCH_TOOLTIP_HEADER = "Encontrar amigos por:"
	L.SEARCH_FIELDS = {
		"BattleTag (amigos Battle.net)",
		"Nome do personagem",
		"Classe ou raça",
		"Zona",
		"Reino",
	}
	L.SEARCH_TIP = "Digite várias palavras para refinar, ex.: \"guerreiro desolação\"."
	L.SEARCH_NO_RESULTS = "Nenhum resultado"
	L.NOT_IN_GUILD = "Você não está em uma guilda."

	L.LEVEL_SHORT = "Nv. %d"
	L.VERSION_OTHER = "Outra versão"
	L.RULESET_PVP = "JxJ"
	L.RULESET_PVE = "JxA"
	L.OTHER_RULESET_INVITE = "Reino %s: você não pode formar grupo com este amigo."

	L.SECTION_GENERAL = "Geral"
	L.SECTION_LIST = "Lista de amigos"

	L.ENABLED_PANEL = "Janela de amigos clássica"
	L.ENABLED_DESC = "Substitui a nova janela do Forever"
	L.ENABLED_TOOLTIP = "Abre a lista de amigos clássica no lugar da nova janela social do Forever.\n\nDesative para ter a janela do Forever de volta sem desativar o addon."

	L.CHATBUTTON_PANEL = "Botão de amigos do chat"
	L.CHATBUTTON_DESC = "O botão ao lado do chat também a abre"
	L.CHATBUTTON_TOOLTIP = "O botão de amigos ao lado do chat abre a janela clássica.\n\nOs avisos de entrada rápida nesse botão continuam abrindo a lista do Forever."

	L.BOTTOMTABS_PANEL = "Abas clássicas embaixo"
	L.BOTTOMTABS_DESC = "Amigos, Quem, Guilda, Raide embaixo"
	L.BOTTOMTABS_TOOLTIP = "As abas do Classic Era embaixo da janela. Quem, Guilda e Raide abrem a própria janela."

	L.MINIMAPBUTTON_PANEL = "Botão do minimapa"
	L.MINIMAPBUTTON_DESC = "Abre estas opções e a lista de amigos"
	L.MINIMAPBUTTON_TOOLTIP = "Um botão na borda do minimapa.\n\nClique esquerdo abre estas opções, clique direito a lista de amigos. Arraste para movê-lo ao redor do minimapa."

	L.FACTIONCOLORS_PANEL = "Cores de facção"
	L.FACTIONCOLORS_DESC = "Vermelho: Horda, azul: Aliança"
	L.FACTIONCOLORS_TOOLTIP = "Colore as linhas dos amigos que jogam Forever: vermelho para a Horda, azul para a Aliança.\n\nAmigos em outra versão do WoW (Retail, Classic...) mantêm a linha normal, pois você não pode jogar com eles."

	L.CLASSCOLORS_PANEL = "Cores de classe"
	L.CLASSCOLORS_DESC = "Cor da classe, sua zona em verde"
	L.CLASSCOLORS_TOOLTIP = "Mostra o nome do personagem dos seus amigos online na cor da classe.\n\nAmigos na sua zona têm a zona em verde."
	L.LEVELS_PANEL = "Nível"
	L.LEVELS_DESC = "Nível e versão do WoW abaixo do nome"
	L.LEVELS_TOOLTIP = "Mostra o nível do personagem abaixo do nome dos seus amigos online, depois da zona.\n\nAmigos em outra versão do WoW mostram qual, ex.: \"Nv. 80 · Retail\"."

	L.SEARCH_PANEL = "Campo de busca"
	L.SEARCH_DESC = "Busca por BattleTag, nome, classe, zona"
	L.SEARCH_TOOLTIP = "Um campo de busca acima da lista. Busca em BattleTag, nome do personagem, classe, raça, zona e reino."

	L.REQUIRES = "Requer \"%s\" ativado."

	L.RELOAD_PROMPT = "Recarregar a interface para concluir a troca da janela de amigos?"
	L.RELOAD_LATER = "Mais tarde"

	L.GITHUB_TITLE = "Bugs e sugestões"
	L.GITHUB_LINK = "Relatar um bug ou sugerir uma ideia"
	L.GITHUB_TOOLTIP = "Encontrou um bug ou tem uma ideia para melhorar o addon? Clique para obter o link da página no GitHub."
	L.GITHUB_COPY = "Pressione Ctrl+C para copiar o link e cole-o no navegador."
	L.GITHUB_COPIED = "Copiado!"
end

-- Russian -----------------------------------------------------------------------------------
if locale == "ruRU" then
	L.NO_FRIENDS_FRAME = "окно друзей не найдено, аддон отключён."
	L.CONFLICT_WARNING = "ClassicUI Forever тоже включён и изменяет то же окно друзей. Отключите один из них, чтобы избежать конфликтов."
	L.HELP_HEADER = "команды:"
	L.HELP_LINES = {
		"  /cfriends           - открыть список друзей и настройки",
		"  /cfriends new       - один раз открыть новое окно Forever",
	}

	L.MINIMAP_TIP_LEFT = "ЛКМ: настройки"
	L.MINIMAP_TIP_RIGHT = "ПКМ: список друзей"
	L.MINIMAP_TIP_DRAG = "Перетащите, чтобы переместить вокруг миникарты"

	L.SETTINGS_BUTTON_TOOLTIP = "Настройки Classic Friends"
	L.SEARCH_PLACEHOLDER = "BattleTag, имя, класс, зона"
	L.SEARCH_TOOLTIP_HEADER = "Искать друзей по:"
	L.SEARCH_FIELDS = {
		"BattleTag (друзья Battle.net)",
		"Имя персонажа",
		"Класс или раса",
		"Зона",
		"Игровой мир",
	}
	L.SEARCH_TIP = "Введите несколько слов, чтобы уточнить, например \"воин пустоши\"."
	L.SEARCH_NO_RESULTS = "Ничего не найдено"
	L.NOT_IN_GUILD = "Вы не состоите в гильдии."

	L.LEVEL_SHORT = "Ур. %d"
	L.VERSION_OTHER = "Другая версия"
	L.OTHER_RULESET_INVITE = "Игровой мир %s: нельзя собрать группу с этим другом."

	L.SECTION_GENERAL = "Общие"
	L.SECTION_LIST = "Список друзей"

	L.ENABLED_PANEL = "Классическое окно друзей"
	L.ENABLED_DESC = "Заменяет новое окно Forever"
	L.ENABLED_TOOLTIP = "Открывает классический список друзей вместо нового социального окна Forever.\n\nВыключите, чтобы вернуть окно Forever, не отключая аддон."

	L.CHATBUTTON_PANEL = "Кнопка друзей у чата"
	L.CHATBUTTON_DESC = "Кнопка у чата тоже открывает его"
	L.CHATBUTTON_TOOLTIP = "Кнопка друзей рядом с чатом открывает классическое окно.\n\nУведомления о быстром присоединении на этой кнопке по-прежнему открывают список Forever."

	L.BOTTOMTABS_PANEL = "Классические нижние вкладки"
	L.BOTTOMTABS_DESC = "Друзья, Кто, Гильдия, Рейд внизу"
	L.BOTTOMTABS_TOOLTIP = "Вкладки Classic Era под окном. Кто, Гильдия и Рейд открывают собственные окна."

	L.MINIMAPBUTTON_PANEL = "Кнопка у миникарты"
	L.MINIMAPBUTTON_DESC = "Открывает настройки и список друзей"
	L.MINIMAPBUTTON_TOOLTIP = "Кнопка на краю миникарты.\n\nЛКМ открывает эти настройки, ПКМ — список друзей. Перетащите, чтобы переместить её вокруг миникарты."

	L.FACTIONCOLORS_PANEL = "Цвета фракций"
	L.FACTIONCOLORS_DESC = "Красный — Орда, синий — Альянс"
	L.FACTIONCOLORS_TOOLTIP = "Окрашивает строки друзей, играющих в Forever: красный для Орды, синий для Альянса.\n\nДрузья в другой версии WoW (Retail, Classic...) остаются с обычной строкой, так как играть с ними нельзя."

	L.CLASSCOLORS_PANEL = "Цвета классов"
	L.CLASSCOLORS_DESC = "Цвет класса, зона зелёным"
	L.CLASSCOLORS_TOOLTIP = "Показывает имена персонажей друзей в сети цветом их класса.\n\nУ друзей в вашей зоне зона показана зелёным."
	L.LEVELS_PANEL = "Уровень"
	L.LEVELS_DESC = "Уровень и версия WoW под именем"
	L.LEVELS_TOOLTIP = "Показывает уровень персонажа под именем друзей в сети, после их зоны.\n\nДрузья в другой версии WoW показывают, в какой, например \"Ур. 80 · Retail\"."

	L.SEARCH_PANEL = "Поле поиска"
	L.SEARCH_DESC = "Поиск по BattleTag, имени, классу, зоне"
	L.SEARCH_TOOLTIP = "Поле поиска над списком. Ищет по BattleTag, имени персонажа, классу, расе, зоне и игровому миру."

	L.REQUIRES = "Требуется включить \"%s\"."

	L.RELOAD_PROMPT = "Перезагрузить интерфейс, чтобы завершить смену окна друзей?"
	L.RELOAD_LATER = "Позже"

	L.GITHUB_TITLE = "Ошибки и предложения"
	L.GITHUB_LINK = "Сообщить об ошибке или предложить идею"
	L.GITHUB_TOOLTIP = "Нашли ошибку или есть идея, как улучшить аддон? Нажмите, чтобы получить ссылку на его страницу GitHub."
	L.GITHUB_COPY = "Нажмите Ctrl+C, чтобы скопировать ссылку, затем вставьте её в браузер."
	L.GITHUB_COPIED = "Скопировано!"
end

-- Korean ------------------------------------------------------------------------------------
if locale == "koKR" then
	L.NO_FRIENDS_FRAME = "친구 창을 찾을 수 없어 애드온이 비활성화되었습니다."
	L.CONFLICT_WARNING = "ClassicUI Forever도 활성화되어 있으며 같은 친구 창을 변경합니다. 충돌을 피하려면 둘 중 하나를 비활성화하세요."
	L.HELP_HEADER = "명령어:"
	L.HELP_LINES = {
		"  /cfriends           - 친구 목록과 설정 열기",
		"  /cfriends new       - Forever의 새 소셜 창을 한 번 열기",
	}

	L.MINIMAP_TIP_LEFT = "왼쪽 클릭: 설정"
	L.MINIMAP_TIP_RIGHT = "오른쪽 클릭: 친구 목록"
	L.MINIMAP_TIP_DRAG = "드래그하여 미니맵 주위로 이동"

	L.SETTINGS_BUTTON_TOOLTIP = "Classic Friends 설정"
	L.SEARCH_PLACEHOLDER = "배틀태그, 이름, 직업, 지역"
	L.SEARCH_TOOLTIP_HEADER = "친구 검색 기준:"
	L.SEARCH_FIELDS = {
		"배틀태그 (Battle.net 친구)",
		"캐릭터 이름",
		"직업 또는 종족",
		"지역",
		"서버",
	}
	L.SEARCH_TIP = "여러 단어를 입력해 범위를 좁힐 수 있습니다. 예: \"전사 잊혀진\""
	L.SEARCH_NO_RESULTS = "결과 없음"
	L.NOT_IN_GUILD = "길드에 가입되어 있지 않습니다."

	L.LEVEL_SHORT = "%d레벨"
	L.VERSION_OTHER = "다른 버전"
	L.OTHER_RULESET_INVITE = "%s 서버: 이 친구와 파티를 맺을 수 없습니다."

	L.SECTION_GENERAL = "일반"
	L.SECTION_LIST = "친구 목록"

	L.ENABLED_PANEL = "클래식 친구 창"
	L.ENABLED_DESC = "Forever의 새 소셜 창을 대체"
	L.ENABLED_TOOLTIP = "Forever의 새 소셜 창 대신 클래식 친구 목록을 엽니다.\n\n애드온을 끄지 않고 Forever 창으로 돌아가려면 해제하세요."

	L.CHATBUTTON_PANEL = "채팅 친구 버튼"
	L.CHATBUTTON_DESC = "채팅 옆 버튼으로도 열기"
	L.CHATBUTTON_TOOLTIP = "채팅창 옆의 친구 버튼이 클래식 창을 엽니다.\n\n이 버튼의 빠른 참여 알림은 계속 Forever 목록을 엽니다."

	L.BOTTOMTABS_PANEL = "클래식 하단 탭"
	L.BOTTOMTABS_DESC = "목록 아래 친구, 누구, 길드, 공격대"
	L.BOTTOMTABS_TOOLTIP = "창 아래의 Classic Era 탭입니다. 누구, 길드, 공격대는 각자의 창을 엽니다."

	L.MINIMAPBUTTON_PANEL = "미니맵 버튼"
	L.MINIMAPBUTTON_DESC = "설정과 친구 목록 열기"
	L.MINIMAPBUTTON_TOOLTIP = "미니맵 가장자리의 버튼입니다.\n\n왼쪽 클릭은 이 설정을, 오른쪽 클릭은 친구 목록을 엽니다. 드래그하여 미니맵 주위로 옮길 수 있습니다."

	L.FACTIONCOLORS_PANEL = "진영 색상"
	L.FACTIONCOLORS_DESC = "호드는 빨강, 얼라이언스는 파랑"
	L.FACTIONCOLORS_TOOLTIP = "Forever를 플레이 중인 친구의 줄을 호드는 빨강, 얼라이언스는 파랑으로 칠합니다.\n\n다른 WoW 버전(Retail, Classic...)의 친구는 함께 플레이할 수 없으므로 기본 줄을 유지합니다."

	L.CLASSCOLORS_PANEL = "직업 색상"
	L.CLASSCOLORS_DESC = "직업 색상, 내 지역은 녹색"
	L.CLASSCOLORS_TOOLTIP = "접속 중인 친구의 캐릭터 이름을 직업 색상으로 표시합니다.\n\n내 지역에 있는 친구는 지역이 녹색으로 표시됩니다."
	L.LEVELS_PANEL = "레벨"
	L.LEVELS_DESC = "이름 아래에 레벨과 WoW 버전"
	L.LEVELS_TOOLTIP = "접속 중인 친구의 이름 아래, 지역 뒤에 캐릭터 레벨을 표시합니다.\n\n다른 WoW 버전의 친구는 버전도 표시합니다. 예: \"80레벨 · Retail\"."

	L.SEARCH_PANEL = "검색창"
	L.SEARCH_DESC = "배틀태그, 이름, 직업, 지역으로 검색"
	L.SEARCH_TOOLTIP = "목록 위의 검색창입니다. 배틀태그, 캐릭터 이름, 직업, 종족, 지역, 서버를 검색합니다."

	L.REQUIRES = "\"%s\" 설정이 필요합니다."

	L.RELOAD_PROMPT = "친구 창 전환을 마치려면 인터페이스를 다시 불러올까요?"
	L.RELOAD_LATER = "나중에"

	L.GITHUB_TITLE = "버그 및 제안"
	L.GITHUB_LINK = "버그 신고 또는 아이디어 제안"
	L.GITHUB_TOOLTIP = "버그를 발견했거나 애드온 개선 아이디어가 있나요? 클릭하면 GitHub 페이지 링크가 나타납니다."
	L.GITHUB_COPY = "Ctrl+C를 눌러 링크를 복사한 뒤 브라우저에 붙여 넣으세요."
	L.GITHUB_COPIED = "복사했습니다!"
end

-- Simplified Chinese ------------------------------------------------------------------------
if locale == "zhCN" then
	L.NO_FRIENDS_FRAME = "未找到好友窗口，插件已停用。"
	L.CONFLICT_WARNING = "ClassicUI Forever 也已启用，并且会修改同一个好友窗口。请禁用其中一个以避免冲突。"
	L.HELP_HEADER = "命令："
	L.HELP_LINES = {
		"  /cfriends           - 打开好友列表和设置",
		"  /cfriends new       - 打开一次 Forever 的新社交窗口",
	}

	L.MINIMAP_TIP_LEFT = "左键：设置"
	L.MINIMAP_TIP_RIGHT = "右键：好友列表"
	L.MINIMAP_TIP_DRAG = "拖动可沿小地图移动"

	L.SETTINGS_BUTTON_TOOLTIP = "Classic Friends 设置"
	L.SEARCH_PLACEHOLDER = "战网昵称、名字、职业、区域"
	L.SEARCH_TOOLTIP_HEADER = "按以下内容查找好友："
	L.SEARCH_FIELDS = {
		"战网昵称（战网好友）",
		"角色名",
		"职业或种族",
		"区域",
		"服务器",
	}
	L.SEARCH_TIP = "输入多个词以缩小范围，例如“战士 凄凉之地”。"
	L.SEARCH_NO_RESULTS = "没有结果"
	L.NOT_IN_GUILD = "你不在公会中。"

	L.LEVEL_SHORT = "%d级"
	L.VERSION_OTHER = "其他版本"
	L.OTHER_RULESET_INVITE = "%s服务器：无法与该好友组队。"

	L.SECTION_GENERAL = "常规"
	L.SECTION_LIST = "好友列表"

	L.ENABLED_PANEL = "经典好友窗口"
	L.ENABLED_DESC = "替换 Forever 的新社交窗口"
	L.ENABLED_TOOLTIP = "打开经典好友列表，而不是 Forever 的新社交窗口。\n\n关闭此项可恢复 Forever 的窗口，而无需禁用插件。"

	L.CHATBUTTON_PANEL = "聊天好友按钮"
	L.CHATBUTTON_DESC = "聊天旁的按钮也能打开"
	L.CHATBUTTON_TOOLTIP = "聊天框旁的好友按钮会打开经典窗口。\n\n该按钮上的快速加入提示仍会打开 Forever 的列表。"

	L.BOTTOMTABS_PANEL = "经典底部标签"
	L.BOTTOMTABS_DESC = "列表下方的好友、查询、公会、团队"
	L.BOTTOMTABS_TOOLTIP = "窗口下方的经典时代标签。查询、公会和团队会打开各自的窗口。"

	L.MINIMAPBUTTON_PANEL = "小地图按钮"
	L.MINIMAPBUTTON_DESC = "打开设置和好友列表"
	L.MINIMAPBUTTON_TOOLTIP = "小地图边缘的按钮。\n\n左键打开这些设置，右键打开好友列表。拖动可沿小地图移动。"

	L.FACTIONCOLORS_PANEL = "阵营颜色"
	L.FACTIONCOLORS_DESC = "部落为红色，联盟为蓝色"
	L.FACTIONCOLORS_TOOLTIP = "为正在玩 Forever 的好友的行着色：部落为红色，联盟为蓝色。\n\n其他 WoW 版本（Retail、Classic……）的好友保持普通行，因为你无法与他们一起游戏。"

	L.CLASSCOLORS_PANEL = "职业颜色"
	L.CLASSCOLORS_DESC = "职业颜色、同区域显示绿色"
	L.CLASSCOLORS_TOOLTIP = "以职业颜色显示在线好友的角色名。\n\n与你在同一区域的好友，其区域显示为绿色。"
	L.LEVELS_PANEL = "等级"
	L.LEVELS_DESC = "在名字下方显示等级和 WoW 版本"
	L.LEVELS_TOOLTIP = "好友在线时，在其名字下方、区域之后显示角色等级。\n\n其他 WoW 版本的好友会显示所在版本，例如“80级 · Retail”。"

	L.SEARCH_PANEL = "搜索框"
	L.SEARCH_DESC = "按战网昵称、名字、职业、区域搜索"
	L.SEARCH_TOOLTIP = "列表上方的搜索框。可搜索战网昵称、角色名、职业、种族、区域和服务器。"

	L.REQUIRES = "需要开启“%s”。"

	L.RELOAD_PROMPT = "重新加载界面以完成好友窗口的切换？"
	L.RELOAD_LATER = "稍后"

	L.GITHUB_TITLE = "问题与建议"
	L.GITHUB_LINK = "报告问题或提出建议"
	L.GITHUB_TOOLTIP = "发现问题或有改进插件的想法？点击获取其 GitHub 页面的链接。"
	L.GITHUB_COPY = "按 Ctrl+C 复制链接，然后粘贴到浏览器中。"
	L.GITHUB_COPIED = "已复制！"
end

-- Traditional Chinese -----------------------------------------------------------------------
if locale == "zhTW" then
	L.NO_FRIENDS_FRAME = "找不到好友視窗，插件已停用。"
	L.CONFLICT_WARNING = "ClassicUI Forever 也已啟用，且會修改同一個好友視窗。請停用其中一個以避免衝突。"
	L.HELP_HEADER = "指令："
	L.HELP_LINES = {
		"  /cfriends           - 開啟好友名單和設定",
		"  /cfriends new       - 開啟一次 Forever 的新社交視窗",
	}

	L.MINIMAP_TIP_LEFT = "左鍵：設定"
	L.MINIMAP_TIP_RIGHT = "右鍵：好友名單"
	L.MINIMAP_TIP_DRAG = "拖曳可沿小地圖移動"

	L.SETTINGS_BUTTON_TOOLTIP = "Classic Friends 設定"
	L.SEARCH_PLACEHOLDER = "BattleTag、名字、職業、區域"
	L.SEARCH_TOOLTIP_HEADER = "依下列內容搜尋好友："
	L.SEARCH_FIELDS = {
		"BattleTag（Battle.net 好友）",
		"角色名稱",
		"職業或種族",
		"區域",
		"伺服器",
	}
	L.SEARCH_TIP = "輸入多個詞來縮小範圍，例如「戰士 淒涼之地」。"
	L.SEARCH_NO_RESULTS = "沒有結果"
	L.NOT_IN_GUILD = "你不在公會中。"

	L.LEVEL_SHORT = "%d級"
	L.VERSION_OTHER = "其他版本"
	L.OTHER_RULESET_INVITE = "%s伺服器：無法與該好友組隊。"

	L.SECTION_GENERAL = "一般"
	L.SECTION_LIST = "好友名單"

	L.ENABLED_PANEL = "經典好友視窗"
	L.ENABLED_DESC = "取代 Forever 的新社交視窗"
	L.ENABLED_TOOLTIP = "開啟經典好友名單，而不是 Forever 的新社交視窗。\n\n關閉此項可恢復 Forever 的視窗，而不需停用插件。"

	L.CHATBUTTON_PANEL = "聊天好友按鈕"
	L.CHATBUTTON_DESC = "聊天旁的按鈕也能開啟"
	L.CHATBUTTON_TOOLTIP = "聊天框旁的好友按鈕會開啟經典視窗。\n\n該按鈕上的快速加入提示仍會開啟 Forever 的名單。"

	L.BOTTOMTABS_PANEL = "經典底部標籤"
	L.BOTTOMTABS_DESC = "名單下方的好友、搜尋、公會、團隊"
	L.BOTTOMTABS_TOOLTIP = "視窗下方的經典時代標籤。搜尋、公會與團隊會開啟各自的視窗。"

	L.MINIMAPBUTTON_PANEL = "小地圖按鈕"
	L.MINIMAPBUTTON_DESC = "開啟設定和好友名單"
	L.MINIMAPBUTTON_TOOLTIP = "小地圖邊緣的按鈕。\n\n左鍵開啟這些設定，右鍵開啟好友名單。拖曳可沿小地圖移動。"

	L.FACTIONCOLORS_PANEL = "陣營顏色"
	L.FACTIONCOLORS_DESC = "部落為紅色，聯盟為藍色"
	L.FACTIONCOLORS_TOOLTIP = "為正在玩 Forever 的好友的列著色：部落為紅色，聯盟為藍色。\n\n其他 WoW 版本（Retail、Classic……）的好友維持一般的列，因為你無法與他們一起遊戲。"

	L.CLASSCOLORS_PANEL = "職業顏色"
	L.CLASSCOLORS_DESC = "職業顏色、同區域顯示綠色"
	L.CLASSCOLORS_TOOLTIP = "以職業顏色顯示上線好友的角色名稱。\n\n與你在同一區域的好友，其區域會顯示為綠色。"
	L.LEVELS_PANEL = "等級"
	L.LEVELS_DESC = "在名稱下方顯示等級和 WoW 版本"
	L.LEVELS_TOOLTIP = "好友上線時，在其名稱下方、區域之後顯示角色等級。\n\n其他 WoW 版本的好友會顯示所在版本，例如「80級 · Retail」。"

	L.SEARCH_PANEL = "搜尋框"
	L.SEARCH_DESC = "依 BattleTag、名字、職業、區域搜尋"
	L.SEARCH_TOOLTIP = "名單上方的搜尋框。可搜尋 BattleTag、角色名稱、職業、種族、區域與伺服器。"

	L.REQUIRES = "需要開啟「%s」。"

	L.RELOAD_PROMPT = "重新載入介面以完成好友視窗的切換？"
	L.RELOAD_LATER = "稍後"

	L.GITHUB_TITLE = "問題與建議"
	L.GITHUB_LINK = "回報問題或提出建議"
	L.GITHUB_TOOLTIP = "發現問題或有改進插件的想法？點擊取得其 GitHub 頁面的連結。"
	L.GITHUB_COPY = "按 Ctrl+C 複製連結，然後貼到瀏覽器中。"
	L.GITHUB_COPIED = "已複製！"
end
