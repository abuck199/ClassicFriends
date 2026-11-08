local _, addon = ...
local L = addon.L

local FRIENDS_TAB, GUILD_TAB, RAID_TAB = 1, 3, 4

local tabContainer

local function OpenWhoList()
	if not LFGVanilla_ToggleFrame then
		C_AddOns.LoadAddOn("Blizzard_GroupFinder_VanillaStyle")
	end
	if LFGVanilla_ToggleFrame then
		LFGVanilla_ToggleFrame(LFG_TAB_WHO)
	else
		ShowWhoPanel()
	end
end

local TAB_DEFINITIONS = {
	{ label = FRIENDS, keyBinding = "TOGGLEFRIENDSTAB" },
	{ label = WHO, keyBinding = "TOGGLEWHOTAB", openWindow = OpenWhoList },
	{ label = GUILD, keyBinding = "TOGGLEGUILDTAB", openWindow = function() ToggleGuildFrame() end },
	{ label = RAID, keyBinding = "TOGGLERAIDTAB", openWindow = function() ToggleRaidFrame() end },
}

local function IsRaidAvailable()
	return UnitFactionGroup("player") ~= "Neutral"
		and not C_GameRules.IsGameRuleActive(Enum.GameRule.DisableRaidGroups)
end

local function UpdateBottomTabs()
	local showTabs = addon.IsEnabled() and addon.settings.bottomTabs and not FriendsFrameTab1:IsShown()
	tabContainer:SetShown(showTabs)
	if showTabs then
		tabContainer.Tabs[GUILD_TAB].isDisabled = not IsInGuild() or nil
		tabContainer.Tabs[RAID_TAB].isDisabled = not IsRaidAvailable() or nil
		PanelTemplates_SetTab(tabContainer, FRIENDS_TAB)
	end
end

local function BottomTab_OnClick(tab)
	local openWindow = TAB_DEFINITIONS[tab:GetID()].openWindow
	if not openWindow then
		return
	end
	if InCombatLockdown() then
		UIErrorsFrame:AddMessage(ERR_NOT_IN_COMBAT, RED_FONT_COLOR:GetRGB())
		return
	end
	PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
	addon.HideClassicWindow()
	openWindow()
end

local function BottomTab_OnEnter(tab)
	local tabDefinition = TAB_DEFINITIONS[tab:GetID()]
	GameTooltip:SetOwner(tab, "ANCHOR_RIGHT")
	GameTooltip:SetText(MicroButtonTooltipText(tabDefinition.label, tabDefinition.keyBinding), 1, 1, 1)
	if tab:GetID() == GUILD_TAB and not IsInGuild() then
		GameTooltip:AddLine(L.NOT_IN_GUILD, RED_FONT_COLOR:GetRGB())
	end
	GameTooltip:Show()
end

function addon.CreateBottomTabs()
	tabContainer = CreateFrame("Frame", "ClassicFriendsTabContainer", FriendsFrame)
	tabContainer:SetAllPoints()
	tabContainer.tabPadding = 20

	for tabIndex, tabDefinition in ipairs(TAB_DEFINITIONS) do
		local tab = CreateFrame("Button", "ClassicFriendsTab" .. tabIndex, tabContainer, "PanelTabButtonTemplate")
		tab:SetID(tabIndex)
		tab:SetText(tabDefinition.label)
		tab:SetScript("OnClick", BottomTab_OnClick)
		tab:SetScript("OnEnter", BottomTab_OnEnter)
		tab:SetScript("OnLeave", GameTooltip_Hide)
		addon.SkinBottomTab(tab)
	end
	PanelTemplates_SetNumTabs(tabContainer, #TAB_DEFINITIONS)

	local tabs = tabContainer.Tabs
	tabs[1]:SetPoint("TOPLEFT", FriendsFrame, "BOTTOMLEFT", 0, 2)
	for tabIndex = 2, #tabs do
		tabs[tabIndex]:ClearAllPoints()
		tabs[tabIndex]:SetPoint("LEFT", tabs[tabIndex - 1], "RIGHT", -14, 0)
	end

	FriendsFrame:HookScript("OnShow", UpdateBottomTabs)
	addon.OnOptionChanged("enabled", UpdateBottomTabs)
	addon.OnOptionChanged("bottomTabs", UpdateBottomTabs)

	local eventFrame = CreateFrame("Frame")
	eventFrame:RegisterEvent("PLAYER_GUILD_UPDATE")
	eventFrame:SetScript("OnEvent", function()
		if FriendsFrame:IsShown() then
			UpdateBottomTabs()
		end
	end)

	UpdateBottomTabs()
end
