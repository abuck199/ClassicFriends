local _, addon = ...
local L = addon.L

local FACTION_COLORS = {
	Horde = { 0.80, 0.12, 0.12 },
	Alliance = { 0.15, 0.40, 0.95 },
}
local FACTION_TINT_ALPHA_LEFT, FACTION_TINT_ALPHA_RIGHT = 0.30, 0.03
local DETAILS_COLOR_CODE = "|cffb4b4b4"
local ZONE_TEXT_COLOR = FRIENDS_GRAY_COLOR
local SAME_ZONE_TEXT_COLOR = GREEN_FONT_COLOR

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

local function GetBattleNetFriendText(accountInfo, gameInfo)
	local characterName = FriendsFrame_GetFormattedCharacterName(gameInfo.characterName, nil, gameInfo.clientProgram, gameInfo.timerunningSeasonID)
	if not characterName or characterName == "" or issecretvalue(characterName) then
		return nil
	end
	local bracketColorCode = CanCooperateWithGameAccount(accountInfo) and FRIENDS_WOW_NAME_COLOR_CODE or FRIENDS_OTHER_NAME_COLOR_CODE
	local nameColorCode = GetClassColorCode(gameInfo.classFilename) or bracketColorCode
	local friendText = BNet_GetBNetAccountName(accountInfo) .. " "
		.. bracketColorCode .. "(|r" .. nameColorCode .. characterName .. "|r" .. bracketColorCode .. ")|r"

	local details = {}
	local level = gameInfo.characterLevel
	if level and not issecretvalue(level) and level > 0 then
		table.insert(details, L.LEVEL_SHORT:format(level))
	end
	if gameInfo.wowProjectID ~= WOW_PROJECT_ID then
		table.insert(details, GAME_VERSION_NAMES[gameInfo.wowProjectID] or L.VERSION_OTHER)
	end
	if #details > 0 then
		friendText = friendText .. " " .. DETAILS_COLOR_CODE .. table.concat(details, L.VERSION_SEPARATOR) .. "|r"
	end
	return friendText
end

local function GetCharacterFriendText(friendInfo)
	local classColorCode = GetClassColorCode(GetCharacterFriendClass(friendInfo))
	if not classColorCode or not friendInfo.name or issecretvalue(friendInfo.name) then
		return nil
	end
	return classColorCode .. friendInfo.name .. "|r, " .. FRIENDS_LEVEL_TEMPLATE:format(friendInfo.level, friendInfo.className)
end

local function IsInPlayerZone(zoneName)
	if not zoneName or zoneName == "" or issecretvalue(zoneName) then
		return false
	end
	return zoneName == GetRealZoneText()
end

local function TintRowForFaction(row, faction)
	local r, g, b = unpack(FACTION_COLORS[faction])
	row.background:SetColorTexture(1, 1, 1, 1)
	row.background:SetGradient("HORIZONTAL", CreateColor(r, g, b, FACTION_TINT_ALPHA_LEFT), CreateColor(r, g, b, FACTION_TINT_ALPHA_RIGHT))
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

local function StyleFriendRow(_, row, friendData)
	if not friendData or not addon.IsFriend(friendData) then
		return
	end
	if not row.classicFriendsHooked then
		row:HookScript("OnClick", FriendRow_OnClick)
		row:HookScript("OnDoubleClick", FriendRow_OnDoubleClick)
		row.classicFriendsHooked = true
	end
	row.background:SetVertexColor(1, 1, 1, 1)
	row.info:SetTextColor(ZONE_TEXT_COLOR:GetRGB())
	if not addon.IsEnabled() then
		return
	end
	if not friendWasClicked then
		row:UnlockHighlight()
	end

	local settings = addon.settings
	local nameText, faction, zoneName
	local isInSameGame = true
	if friendData.buttonType == FRIENDS_BUTTON_TYPE_BNET then
		local accountInfo = C_BattleNet.GetFriendAccountInfo(friendData.id)
		local gameInfo = accountInfo and accountInfo.gameAccountInfo
		if not (gameInfo and gameInfo.isOnline and gameInfo.clientProgram == BNET_CLIENT_WOW) then
			return
		end
		faction, zoneName = gameInfo.factionName, gameInfo.areaName
		isInSameGame = gameInfo.wowProjectID == WOW_PROJECT_ID
		nameText = settings.classColors and GetBattleNetFriendText(accountInfo, gameInfo)
	else
		local friendInfo = C_FriendList.GetFriendInfoByIndex(friendData.id)
		if not (friendInfo and friendInfo.connected) then
			return
		end
		faction, zoneName = UnitFactionGroup("player"), friendInfo.area
		nameText = settings.classColors and GetCharacterFriendText(friendInfo)
	end

	if nameText then
		row.name:SetText(nameText)
	end
	if settings.classColors and isInSameGame and IsInPlayerZone(zoneName) then
		row.info:SetTextColor(SAME_ZONE_TEXT_COLOR:GetRGB())
	end
	if settings.factionColors and isInSameGame and faction and not issecretvalue(faction) and FACTION_COLORS[faction] then
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

	local eventFrame = CreateFrame("Frame")
	eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	eventFrame:SetScript("OnEvent", RefreshFriendRows)
end
