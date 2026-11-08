local _, addon = ...

local FRIENDS_KEY_BINDINGS = { "TOGGLESOCIAL", "TOGGLEFRIENDSTAB" }

local bindingButton, escapeFrame
local bindingsNeedUpdate = false

local function IsFriendsListBlocked()
	return Kiosk.IsEnabled() or C_GameRules.IsGameRuleActive(Enum.GameRule.IngameFriendsListDisabled)
end

local function HideNewSocialWindow()
	if not (SocialUIFrame and SocialUIFrame:IsShown()) then
		return
	end
	if InCombatLockdown() then
		SocialUIFrame:Hide()
	else
		HideUIPanel(SocialUIFrame)
	end
end

function addon.ShowClassicWindow()
	if FriendsFrame:IsShown() or IsFriendsListBlocked() then
		return
	end
	PanelTemplates_SetTab(FriendsFrame, FRIEND_TAB_FRIENDS)
	HideNewSocialWindow()
	if InCombatLockdown() then
		if FriendsFrame:GetNumPoints() == 0 then
			FriendsFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 16, -116)
		end
		FriendsFrame:Show()
		escapeFrame:Show()
	else
		ShowUIPanel(FriendsFrame)
	end
end

function addon.HideClassicWindow()
	if not FriendsFrame:IsShown() then
		return
	end
	if InCombatLockdown() then
		FriendsFrame:Hide()
	else
		HideUIPanel(FriendsFrame)
	end
end

function addon.ToggleClassicWindow()
	if FriendsFrame:IsShown() then
		addon.HideClassicWindow()
	else
		addon.ShowClassicWindow()
	end
end

function addon.ToggleFriendsList()
	if addon.IsEnabled() then
		addon.ToggleClassicWindow()
	else
		ToggleFriendsFrame()
	end
end

local function CreateEscapeFrame()
	escapeFrame = CreateFrame("Frame", "ClassicFriendsEscapeFrame", UIParent)
	escapeFrame:Hide()
	escapeFrame:SetScript("OnHide", function()
		if FriendsFrame:IsShown() then
			FriendsFrame:Hide()
		end
	end)
	table.insert(UISpecialFrames, escapeFrame:GetName())
	FriendsFrame:HookScript("OnHide", function()
		escapeFrame:Hide()
	end)
end

-- Friends keys ------------------------------------------------------------------------------

local function ApplyKeyBindings()
	if InCombatLockdown() then
		bindingsNeedUpdate = true
		return
	end
	bindingsNeedUpdate = false
	ClearOverrideBindings(bindingButton)
	if not addon.IsEnabled() then
		return
	end
	for _, bindingName in ipairs(FRIENDS_KEY_BINDINGS) do
		for _, key in ipairs({ GetBindingKey(bindingName) }) do
			SetOverrideBindingClick(bindingButton, false, key, bindingButton:GetName())
		end
	end
end

local function CreateBindingButton()
	bindingButton = CreateFrame("Button", "ClassicFriendsBindingButton", UIParent)
	bindingButton:SetSize(1, 1)
	bindingButton:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -100, 100)
	bindingButton:EnableMouse(false)
	bindingButton:RegisterForClicks("AnyUp")
	bindingButton:SetScript("OnClick", addon.ToggleFriendsList)
end

-- Chat button, /friends and /ignore ---------------------------------------------------------

local function HookChatFriendsButton()
	local chatFriendsButton = QuickJoinToastButton
	local blizzardOnClick = chatFriendsButton:GetScript("OnClick")
	chatFriendsButton:SetScript("OnClick", function(self, mouseButton, isDown)
		local isShowingRecruitTip = C_RecruitAFriend.IsSystemEnabled() and HelpTip:IsShowing(self, RAF_REWARD_TUTORIAL_TEXT)
		if addon.IsEnabled() and addon.settings.chatButton and not self.displayedToast and not isShowingRecruitTip
			and not KeybindFrames_InQuickKeybindMode() then
			addon.ToggleClassicWindow()
		else
			blizzardOnClick(self, mouseButton, isDown)
		end
	end)
end

local function HookSlashCommands()
	local blizzardToggleFriendsPanel = ToggleFriendsPanel
	ToggleFriendsPanel = function(...)
		if not addon.IsEnabled() then
			return blizzardToggleFriendsPanel(...)
		end
		addon.ToggleClassicWindow()
	end

	local blizzardToggleIgnorePanel = ToggleIgnorePanel
	ToggleIgnorePanel = function(...)
		if not addon.IsEnabled() then
			return blizzardToggleIgnorePanel(...)
		end
		local ignoreList = FriendsFrame.IgnoreListWindow
		if not FriendsFrame:IsShown() then
			addon.ShowClassicWindow()
			if FriendsFrame:IsShown() then
				ignoreList:Show()
			end
		elseif ignoreList:IsShown() then
			addon.HideClassicWindow()
		else
			ignoreList:Show()
		end
	end
end

-- Recent Allies -----------------------------------------------------------------------------

local function IsFriendsFrameRestricted()
	return addon.IsEnabled() and C_SocialUI.IsSystemEnabled()
end

local function HideRecruitAFriendTab(tabHeader)
	if IsFriendsFrameRestricted() then
		tabHeader.TabSystem:SetTabShown(tabHeader.recruitAFriendTabID, false)
	end
end

local function UpdateRecentAlliesList()
	if not IsFriendsFrameRestricted() then
		return
	end
	local tabHeader = FriendsTabHeader
	local isRecentAlliesTabSelected = PanelTemplates_GetSelectedTab(FriendsFrame) == FRIEND_TAB_FRIENDS
		and tabHeader:GetTab() == tabHeader.recentAlliesTabID
	RecentAlliesFrame:SetShown(isRecentAlliesTabSelected)
end

local function SetUpRecentAllies()
	hooksecurefunc(FriendsTabHeader, "RefreshTabVisibility", HideRecruitAFriendTab)
	hooksecurefunc("FriendsFrame_Update", UpdateRecentAlliesList)
	FriendsFrame:HookScript("OnHide", function()
		if IsFriendsFrameRestricted() then
			RecentAlliesFrame:Hide()
		end
	end)
end

function addon.SetUpWindow()
	CreateBindingButton()
	CreateEscapeFrame()
	HookChatFriendsButton()
	HookSlashCommands()
	SetUpRecentAllies()
	ApplyKeyBindings()

	local eventFrame = CreateFrame("Frame")
	eventFrame:RegisterEvent("UPDATE_BINDINGS")
	eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	eventFrame:SetScript("OnEvent", function(_, event)
		if event == "UPDATE_BINDINGS" or bindingsNeedUpdate then
			ApplyKeyBindings()
		end
	end)

	addon.OnOptionChanged("enabled", function()
		addon.HideClassicWindow()
		HideNewSocialWindow()
		ApplyKeyBindings()
	end)
end
