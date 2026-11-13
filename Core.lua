local ADDON_NAME, addon = ...
local L = addon.L

addon.version = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Version") or ""

local DEFAULT_SETTINGS = {
	enabled = true,
	windowScale = 1,
	chatButton = true,
	bottomTabs = true,
	minimapButton = true,
	factionColors = true,
	classColors = true,
	levels = true,
	search = true,
}

function addon.Print(message)
	DEFAULT_CHAT_FRAME:AddMessage("|cff00b4ff" .. L.CHAT_PREFIX .. "|r " .. message)
end

function addon.IsEnabled()
	return addon.settings.enabled
end

function addon.IsFriend(listItem)
	return listItem.buttonType == FRIENDS_BUTTON_TYPE_BNET or listItem.buttonType == FRIENDS_BUTTON_TYPE_WOW
end

-- Settings ----------------------------------------------------------------------------------

local function DefineOption(key, textKey, requiredOption)
	return {
		key = key,
		requires = requiredOption,
		label = L[textKey .. "_PANEL"],
		description = L[textKey .. "_DESC"],
		tooltip = L[textKey .. "_TOOLTIP"],
	}
end

local function DefineSlider(key, textKey, requiredOption, minimum, maximum, step)
	local option = DefineOption(key, textKey, requiredOption)
	option.minimum, option.maximum, option.step = minimum, maximum, step
	return option
end

addon.options = {
	{ header = L.SECTION_GENERAL },
	DefineOption("enabled", "ENABLED"),
	DefineSlider("windowScale", "WINDOWSCALE", "enabled", 0.75, 1.5, 0.05),
	DefineOption("chatButton", "CHATBUTTON", "enabled"),
	DefineOption("bottomTabs", "BOTTOMTABS", "enabled"),
	DefineOption("minimapButton", "MINIMAPBUTTON"),

	{ header = L.SECTION_LIST },
	DefineOption("factionColors", "FACTIONCOLORS", "enabled"),
	DefineOption("classColors", "CLASSCOLORS", "enabled"),
	DefineOption("levels", "LEVELS", "enabled"),
	DefineOption("search", "SEARCH", "enabled"),
}

addon.optionsByKey = {}
for _, option in ipairs(addon.options) do
	if option.key then
		addon.optionsByKey[option.key] = option
	end
end

local optionCallbacks = {}

function addon.OnOptionChanged(key, callback)
	optionCallbacks[key] = optionCallbacks[key] or {}
	table.insert(optionCallbacks[key], callback)
end

local enabledAtLogin
local reloadDialog = {
	referenceKey = "ClassicFriendsReload",
	text = L.RELOAD_PROMPT,
	acceptText = RELOADUI,
	cancelText = L.RELOAD_LATER,
	callback = ReloadUI,
}

local function UpdateReloadDialog()
	local isShown = StaticPopup_IsCustomGenericConfirmationShown(reloadDialog.referenceKey)
	if addon.settings.enabled ~= enabledAtLogin then
		if not isShown then
			StaticPopup_ShowCustomGenericConfirmation(reloadDialog)
		end
	elseif isShown then
		StaticPopup_Hide("GENERIC_CONFIRMATION", reloadDialog)
	end
end

function addon.SetOption(key, value)
	addon.settings[key] = value
	for _, callback in ipairs(optionCallbacks[key] or {}) do
		callback()
	end
	if key == "enabled" then
		UpdateReloadDialog()
	end
	addon.RefreshPanel()
end

-- Startup -----------------------------------------------------------------------------------

local isInitialized = false

local function LoadSettings()
	ClassicFriendsDB = ClassicFriendsDB or {}
	for key, defaultValue in pairs(DEFAULT_SETTINGS) do
		if ClassicFriendsDB[key] == nil then
			ClassicFriendsDB[key] = defaultValue
		end
	end
	addon.settings = ClassicFriendsDB
	enabledAtLogin = addon.settings.enabled
end

local function Initialize()
	if not FriendsFrame then
		addon.Print(L.NO_FRIENDS_FRAME)
		return
	end

	addon.SetUpWindow()
	addon.SetUpSearch()
	addon.SetUpFriendRows()
	addon.SkinFriendsFrame()
	addon.CreateBottomTabs()
	addon.CreateSettingsButton()
	addon.CreateMinimapButton()
	isInitialized = true

	if C_AddOns.IsAddOnLoaded("ClassicUIForever") then
		addon.Print(L.CONFLICT_WARNING)
	end

	if not addon.settings.firstRunShown then
		addon.settings.firstRunShown = true
		addon.Print(L.FIRST_RUN_HINT)
	end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(self, event, loadedAddonName)
	if event == "ADDON_LOADED" and loadedAddonName == ADDON_NAME then
		LoadSettings()
		self:UnregisterEvent("ADDON_LOADED")
	elseif event == "PLAYER_LOGIN" then
		Initialize()
	end
end)

-- Slash command -----------------------------------------------------------------------------

SLASH_CLASSICFRIENDS1 = "/cfriends"
SLASH_CLASSICFRIENDS2 = "/classicfriends"
SlashCmdList.CLASSICFRIENDS = function(input)
	if not isInitialized then
		return
	end
	local command = strtrim(input:lower())
	if command == "" then
		if not addon.IsPanelShown() and addon.IsEnabled() then
			addon.ShowClassicWindow()
		end
		addon.TogglePanel()
	elseif command == "new" then
		addon.OpenNewSocialWindow()
	else
		addon.Print(L.HELP_HEADER)
		for _, helpLine in ipairs(L.HELP_LINES) do
			addon.Print(helpLine)
		end
	end
end
