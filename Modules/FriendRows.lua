local _, addon = ...
local L = addon.L

local FACTION_TINT_ALPHA_LEFT, FACTION_TINT_ALPHA_RIGHT = 0.30, 0.03

local function CreateFactionGradient(r, g, b)
	return {
		left = CreateColor(r, g, b, FACTION_TINT_ALPHA_LEFT),
		right = CreateColor(r, g, b, FACTION_TINT_ALPHA_RIGHT),
	}
end

local FACTION_GRADIENTS = {
	Horde = CreateFactionGradient(0.80, 0.12, 0.12),
	Alliance = CreateFactionGradient(0.15, 0.40, 0.95),
}
local DETAILS_COLOR_CODE = "|cffb4b4b4"
local ZONE_TEXT_COLOR = FRIENDS_GRAY_COLOR
local SAME_ZONE_TEXT_COLOR = GREEN_FONT_COLOR
local FOREVER_GAME_ICON = "WoWF"

local GAME_VERSION_NAMES = {
	[1] = L.VERSION_RETAIL,
	[2] = L.VERSION_CLASSIC,
	[3] = L.VERSION_PLUNDERSTORM,
	[5] = L.VERSION_TBC,
	[11] = L.VERSION_WRATH,
	[14] = L.VERSION_CATA,
	[18] = L.VERSION_FOREVER,
	[19] = L.VERSION_MISTS,
}

local friendWasClicked = false
local playerRuleset

local function GetClassColorCode(classFile)
	if not classFile or issecretvalue(classFile) then
		return nil
	end
	local classColor = C_ClassColor.GetClassColor(classFile)
	return classColor and classColor:GenerateHexColorMarkup()
end

local function GetCharacterFriendClass(friendInfo)
	if not friendInfo.guid or issecretvalue(friendInfo.guid) then
		return nil
	end
	local _, classFile = GetPlayerInfoByGUID(friendInfo.guid)
	if classFile and not issecretvalue(classFile) then
		return classFile
	end
end

local function GetRuleset(gameInfo)
	local richPresence = gameInfo and gameInfo.richPresence
	if issecretvalue(richPresence) or not richPresence then
		return nil
	end
	return richPresence:match("^.- %- (.-) %- ")
end

local function GetPlayerRuleset()
	if not playerRuleset then
		playerRuleset = GetRuleset(C_BattleNet.GetGameAccountInfoByGUID(UnitGUID("player")))
	end
	return playerRuleset
end

local function GetOtherRuleset(gameInfo)
	local friendRuleset = GetRuleset(gameInfo)
	local ownRuleset = GetPlayerRuleset()
	if friendRuleset and ownRuleset and friendRuleset ~= ownRuleset then
		return friendRuleset
	end
end

function addon.IsOnPlayerRuleset(gameInfo)
	return GetOtherRuleset(gameInfo) == nil
end

local function GetLevelText(level)
	if level and not issecretvalue(level) and level > 0 then
		return L.LEVEL_SHORT:format(level)
	end
end

local function GetBattleNetFriendName(accountInfo, gameInfo)
	local characterName = FriendsFrame_GetFormattedCharacterName(gameInfo.characterName, nil, gameInfo.clientProgram, gameInfo.timerunningSeasonID)
	if not characterName or characterName == "" or issecretvalue(characterName) then
		return nil
	end
	local bracketColorCode = CanCooperateWithGameAccount(accountInfo) and FRIENDS_WOW_NAME_COLOR_CODE or FRIENDS_OTHER_NAME_COLOR_CODE
	local nameColorCode = GetClassColorCode(gameInfo.classFilename) or bracketColorCode
	return BNet_GetBNetAccountName(accountInfo) .. " "
		.. bracketColorCode .. "(|r" .. nameColorCode .. characterName .. "|r" .. bracketColorCode .. ")|r"
end

local function GetBattleNetFriendDetails(gameInfo)
	local details = { GetLevelText(gameInfo.characterLevel) }
	if gameInfo.wowProjectID ~= WOW_PROJECT_ID then
		table.insert(details, GAME_VERSION_NAMES[gameInfo.wowProjectID] or L.VERSION_OTHER)
	end
	return details
end

local function GetCharacterFriendName(friendInfo, settings)
	if not friendInfo.name or issecretvalue(friendInfo.name) then
		return nil
	end
	local classColorCode = settings.classColors and GetClassColorCode(GetCharacterFriendClass(friendInfo))
	local name = classColorCode and classColorCode .. friendInfo.name .. "|r" or friendInfo.name
	if settings.levels then
		return name
	end
	return name .. ", " .. FRIENDS_LEVEL_TEMPLATE:format(friendInfo.level, friendInfo.className)
end

local function ShowDetailsAfterZone(row, details)
	local detailsText = table.concat(details, L.VERSION_SEPARATOR)
	local infoText = row.info:GetText()
	if issecretvalue(infoText) or (infoText and infoText ~= "") then
		row.info:SetText(infoText .. DETAILS_COLOR_CODE .. L.VERSION_SEPARATOR .. detailsText .. "|r")
	else
		row.info:SetText(DETAILS_COLOR_CODE .. detailsText .. "|r")
	end
end

local function IsInPlayerZone(zoneName)
	if not zoneName or zoneName == "" or issecretvalue(zoneName) then
		return false
	end
	return zoneName == GetRealZoneText()
end

local function TintRowForFaction(row, faction)
	local gradient = FACTION_GRADIENTS[faction]
	row.background:SetColorTexture(1, 1, 1, 1)
	row.background:SetGradient("HORIZONTAL", gradient.left, gradient.right)
end

-- Selection ---------------------------------------------------------------------------------

local function HideAutomaticSelection()
	if friendWasClicked or not addon.IsEnabled() then
		return
	end
	FriendsListFrame.ScrollBox:ForEachFrame(function(row)
		if addon.IsFriend(row) then
			row:UnlockHighlight()
		end
	end)
	FriendsFrameSendMessageButton:Disable()
end

local function FriendRow_OnClick(row, mouseButton)
	if mouseButton ~= "LeftButton" or not addon.IsEnabled() then
		return
	end
	friendWasClicked = true
	row:LockHighlight()
	FriendsFrameSendMessageButton:SetEnabled(FriendsList_CanWhisperFriend(row.buttonType, row.id))
end

local function FriendRow_OnDoubleClick(row, mouseButton)
	if mouseButton ~= "LeftButton" or not addon.IsEnabled() or not addon.IsFriend(row) then
		return
	end
	if FriendsList_CanWhisperFriend(row.buttonType, row.id) then
		FriendsFrame_SelectFriend(row.buttonType, row.id)
		FriendsFrameSendMessageButton_OnClick(FriendsFrameSendMessageButton)
	end
end

-- Rows --------------------------------------------------------------------------------------

local function FriendRow_OnEnter(row)
	if not addon.IsEnabled() or row.buttonType ~= FRIENDS_BUTTON_TYPE_BNET then
		return
	end
	local accountInfo = C_BattleNet.GetFriendAccountInfo(row.id)
	local gameInfo = accountInfo and accountInfo.gameAccountInfo
	if not (gameInfo and gameInfo.wowProjectID == WOW_PROJECT_ID and gameInfo.isInCurrentRegion) then
		return
	end
	local zoneName, ruleset = gameInfo.areaName, GetRuleset(gameInfo)
	if issecretvalue(zoneName) or not zoneName or not ruleset or gameInfo.realmDisplayName then
		return
	end
	FriendsTooltipGameAccount1Info:SetText(BNET_FRIEND_TOOLTIP_ZONE_AND_REALM:format(zoneName, ruleset))
end

local function InviteButton_OnEnter(inviteButton)
	if inviteButton.classicFriendsRuleset then
		local text = L.OTHER_RULESET_INVITE:format(inviteButton.classicFriendsRuleset)
		GameTooltip:AddLine(text, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true)
		GameTooltip:Show()
	end
end

local function UseDefaultInviteButton(inviteButton)
	inviteButton.NormalTexture:SetAtlas("friendslist-invitebutton-default-normal")
	inviteButton.PushedTexture:SetAtlas("friendslist-invitebutton-default-pressed")
	inviteButton.DisabledTexture:SetAtlas("friendslist-invitebutton-default-disabled")
end

local function StyleFriendRow(_, row, friendData)
	if not friendData or not addon.IsFriend(friendData) then
		return
	end
	if not row.classicFriendsHooked then
		row:HookScript("OnClick", FriendRow_OnClick)
		row:HookScript("OnDoubleClick", FriendRow_OnDoubleClick)
		row:HookScript("OnEnter", FriendRow_OnEnter)
		hooksecurefunc(row, "OnEnter", FriendRow_OnEnter)
		row.travelPassButton:HookScript("OnEnter", InviteButton_OnEnter)
		row.classicFriendsHooked = true
	end
	row.travelPassButton.classicFriendsRuleset = nil
	row.background:SetVertexColor(1, 1, 1, 1)
	row.info:SetTextColor(ZONE_TEXT_COLOR:GetRGB())
	if not addon.IsEnabled() then
		return
	end
	if not friendWasClicked then
		row:UnlockHighlight()
	end
	UseDefaultInviteButton(row.travelPassButton)

	local settings = addon.settings
	local nameText, faction, zoneName, otherRuleset
	local details = {}
	local isInSameGame = true
	if friendData.buttonType == FRIENDS_BUTTON_TYPE_BNET then
		local accountInfo = C_BattleNet.GetFriendAccountInfo(friendData.id)
		local gameInfo = accountInfo and accountInfo.gameAccountInfo
		if not (gameInfo and gameInfo.isOnline and gameInfo.clientProgram == BNET_CLIENT_WOW) then
			return
		end
		faction, zoneName = gameInfo.factionName, gameInfo.areaName
		isInSameGame = gameInfo.wowProjectID == WOW_PROJECT_ID
		otherRuleset = isInSameGame and GetOtherRuleset(gameInfo)
		nameText = settings.classColors and GetBattleNetFriendName(accountInfo, gameInfo)
		if settings.levels then
			details = GetBattleNetFriendDetails(gameInfo)
		end
		if otherRuleset then
			table.insert(details, otherRuleset)
		end
		if isInSameGame and not gameInfo.subIcon then
			C_Texture.SetTitleIconTexture(row.gameIcon, BNET_CLIENT_WOW, Enum.TitleIconVersion.Medium, FOREVER_GAME_ICON)
		end
	else
		local friendInfo = C_FriendList.GetFriendInfoByIndex(friendData.id)
		if not (friendInfo and friendInfo.connected) then
			return
		end
		faction, zoneName = UnitFactionGroup("player"), friendInfo.area
		nameText = GetCharacterFriendName(friendInfo, settings)
		if settings.levels then
			details = { GetLevelText(friendInfo.level) }
		end
	end

	if nameText then
		row.name:SetText(nameText)
	end
	if #details > 0 then
		ShowDetailsAfterZone(row, details)
	end
	if otherRuleset then
		row.travelPassButton:Disable()
		row.travelPassButton.classicFriendsRuleset = otherRuleset
	end
	if settings.classColors and isInSameGame and IsInPlayerZone(zoneName) then
		row.info:SetTextColor(SAME_ZONE_TEXT_COLOR:GetRGB())
	end
	if settings.factionColors and isInSameGame and faction and not issecretvalue(faction) and FACTION_GRADIENTS[faction] then
		TintRowForFaction(row, faction)
	end

	if row.Favorite:IsShown() then
		row.Favorite:ClearAllPoints()
		row.Favorite:SetPoint("TOPLEFT", row.name, "TOPLEFT", row.name:GetStringWidth(), 0)
	end
end

local function RefreshFriendRows()
	if FriendsListFrame:IsShown() then
		FriendsList_Update(true)
	end
end

function addon.SetUpFriendRows()
	ScrollUtil.AddInitializedFrameCallback(FriendsListFrame.ScrollBox, StyleFriendRow, StyleFriendRow)

	hooksecurefunc("FriendsFrame_SelectFriend", HideAutomaticSelection)
	FriendsFrame:HookScript("OnShow", HideAutomaticSelection)
	FriendsFrame:HookScript("OnHide", function()
		friendWasClicked = false
	end)

	addon.OnOptionChanged("factionColors", RefreshFriendRows)
	addon.OnOptionChanged("classColors", RefreshFriendRows)
	addon.OnOptionChanged("levels", RefreshFriendRows)

	local eventFrame = CreateFrame("Frame")
	eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	eventFrame:SetScript("OnEvent", RefreshFriendRows)
end
