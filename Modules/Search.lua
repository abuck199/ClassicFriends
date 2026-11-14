local _, addon = ...
local L = addon.L

local LIST_TOP_OFFSET = -87
local SEARCH_BAR_HEIGHT = 30
local SEARCH_BAR_GAP = 3
local SEARCH_DELAY = 0.15

local searchBar, searchBox, noResultsText
local searchWords, searchTimer

local function AddSearchableText(searchableTexts, text)
	if type(text) ~= "string" or text == "" or issecretvalue(text) then
		return
	end
	if text:find("|K", 1, true) then
		return
	end
	table.insert(searchableTexts, CaseAccentInsensitiveParse(text))
end

local function GetSearchableTexts(friendData)
	local searchableTexts = {}
	if friendData.buttonType == FRIENDS_BUTTON_TYPE_BNET then
		local accountInfo = C_BattleNet.GetFriendAccountInfo(friendData.id)
		if accountInfo then
			AddSearchableText(searchableTexts, accountInfo.battleTag)
			AddSearchableText(searchableTexts, accountInfo.accountName)
			local gameInfo = accountInfo.gameAccountInfo
			if gameInfo then
				AddSearchableText(searchableTexts, gameInfo.characterName)
				AddSearchableText(searchableTexts, gameInfo.className)
				AddSearchableText(searchableTexts, gameInfo.raceName)
				AddSearchableText(searchableTexts, gameInfo.areaName)
				AddSearchableText(searchableTexts, gameInfo.realmName)
			end
		end
	else
		local friendInfo = C_FriendList.GetFriendInfoByIndex(friendData.id)
		if friendInfo then
			AddSearchableText(searchableTexts, friendInfo.name)
			AddSearchableText(searchableTexts, friendInfo.className)
			AddSearchableText(searchableTexts, friendInfo.area)
		end
	end
	return searchableTexts
end

local function MatchesSearch(friendData)
	local searchableTexts = GetSearchableTexts(friendData)
	for _, word in ipairs(searchWords) do
		local isWordFound = false
		for _, text in ipairs(searchableTexts) do
			if text:find(word, 1, true) then
				isWordFound = true
				break
			end
		end
		if not isWordFound then
			return false
		end
	end
	return true
end

-- Order -------------------------------------------------------------------------------------

local CAN_INVITE, SAME_GAME, OTHER_GAME = 1, 2, 3

local function IsOnPlayerFaction(gameInfo)
	if C_PartyInfo.CanFormCrossFactionParties() then
		return true
	end
	local faction = gameInfo.factionName
	return faction ~= nil and not issecretvalue(faction) and faction == UnitFactionGroup("player")
end

local function GetInvitePriority(friendData)
	if friendData.buttonType == FRIENDS_BUTTON_TYPE_WOW then
		local friendInfo = C_FriendList.GetFriendInfoByIndex(friendData.id)
		return friendInfo and friendInfo.connected and CAN_INVITE or OTHER_GAME
	end
	local accountInfo = C_BattleNet.GetFriendAccountInfo(friendData.id)
	local gameInfo = accountInfo and accountInfo.gameAccountInfo
	if not (gameInfo and gameInfo.isOnline and gameInfo.clientProgram == BNET_CLIENT_WOW and gameInfo.wowProjectID == WOW_PROJECT_ID) then
		return OTHER_GAME
	end
	if IsOnPlayerFaction(gameInfo) and addon.IsOnPlayerRuleset(gameInfo) then
		return CAN_INVITE
	end
	return SAME_GAME
end

local function InsertFriends(dataProvider, friends, smartSorting)
	if not smartSorting then
		dataProvider:InsertTable(friends)
		return
	end
	local friendsByPriority = { {}, {}, {} }
	for _, friendData in ipairs(friends) do
		table.insert(friendsByPriority[GetInvitePriority(friendData)], friendData)
	end
	for _, priorityGroup in ipairs(friendsByPriority) do
		dataProvider:InsertTable(priorityGroup)
	end
end

local function UpdateDisplayedFriends()
	local isSearching = searchWords ~= nil
	local smartSorting = addon.IsEnabled() and addon.settings.smartSorting
	if not FriendsListFrame:IsShown() or not (isSearching or smartSorting) then
		noResultsText:Hide()
		return
	end
	local scrollBox = FriendsListFrame.ScrollBox
	local allEntries = scrollBox:GetDataProvider()
	if not allEntries then
		return
	end
	local displayedEntries = CreateDataProvider()
	local friendGroup = {}
	for _, entry in allEntries:EnumerateEntireRange() do
		if addon.IsFriend(entry) then
			if not isSearching or MatchesSearch(entry) then
				table.insert(friendGroup, entry)
			end
		elseif not isSearching then
			InsertFriends(displayedEntries, friendGroup, smartSorting)
			friendGroup = {}
			displayedEntries:Insert(entry)
		end
	end
	InsertFriends(displayedEntries, friendGroup, smartSorting)
	scrollBox:SetDataProvider(displayedEntries, ScrollBoxConstants.RetainScrollPosition)
	noResultsText:SetShown(isSearching and displayedEntries:IsEmpty())
end

local function RefreshFriendsList()
	if FriendsListFrame:IsShown() then
		FriendsList_Update(true)
	end
end

-- Search box --------------------------------------------------------------------------------

local function SetSearchText(text)
	searchWords = nil
	text = strtrim(text)
	if text ~= "" then
		searchWords = {}
		for word in CaseAccentInsensitiveParse(text):gmatch("%S+") do
			table.insert(searchWords, word)
		end
	end
	RefreshFriendsList()
end

local function SearchBox_OnTextChanged(editBox)
	if searchTimer then
		searchTimer:Cancel()
		searchTimer = nil
	end
	local text = editBox:GetText()
	if text == "" then
		SetSearchText(text)
		return
	end
	searchTimer = C_Timer.NewTimer(SEARCH_DELAY, function()
		searchTimer = nil
		SetSearchText(text)
	end)
end

local function ClearSearch()
	if searchBox:GetText() ~= "" then
		searchBox:SetText("")
	end
end

local function PlaceFriendsList(isBelowSearchBar)
	local topOffset = LIST_TOP_OFFSET
	if isBelowSearchBar then
		topOffset = topOffset - SEARCH_BAR_HEIGHT - SEARCH_BAR_GAP
	end
	local scrollBox = FriendsListFrame.ScrollBox
	scrollBox:ClearAllPoints()
	scrollBox:SetPoint("TOPLEFT", FriendsListFrame, "TOPLEFT", 8, topOffset)
	scrollBox:SetPoint("BOTTOMRIGHT", FriendsFrame.Inset, "BOTTOMRIGHT", -22, 2)
end

local function UpdateSearchBar()
	local showSearchBar = addon.IsEnabled() and addon.settings.search
	searchBar:SetShown(showSearchBar)
	PlaceFriendsList(showSearchBar)
	if not showSearchBar then
		ClearSearch()
	end
end

local function ShowSearchTooltip(editBox)
	GameTooltip:SetOwner(editBox, "ANCHOR_BOTTOMRIGHT")
	GameTooltip:SetText(SEARCH, 1, 1, 1)
	GameTooltip:AddLine(L.SEARCH_TOOLTIP_HEADER, NORMAL_FONT_COLOR:GetRGB())
	for _, searchField in ipairs(L.SEARCH_FIELDS) do
		GameTooltip:AddLine("  " .. searchField, 1, 1, 1)
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(L.SEARCH_TIP, 0.7, 0.7, 0.7, true)
	GameTooltip:Show()
end

local function CreateSearchBar()
	local listInset = FriendsFrame.Inset
	searchBar = CreateFrame("Frame", "ClassicFriendsSearchBar", FriendsListFrame)
	searchBar:SetPoint("TOPLEFT", listInset, "TOPLEFT", 3, -3)
	searchBar:SetPoint("TOPRIGHT", listInset, "TOPRIGHT", -3, -3)
	searchBar:SetHeight(SEARCH_BAR_HEIGHT)

	local background = searchBar:CreateTexture(nil, "BACKGROUND")
	background:SetAllPoints()
	background:SetColorTexture(0, 0, 0, 0.3)

	local bottomLine = searchBar:CreateTexture(nil, "BORDER")
	bottomLine:SetPoint("BOTTOMLEFT")
	bottomLine:SetPoint("BOTTOMRIGHT")
	bottomLine:SetHeight(1)
	bottomLine:SetColorTexture(1, 1, 1, 0.12)

	searchBox = CreateFrame("EditBox", "ClassicFriendsSearchBox", searchBar, "SearchBoxTemplate")
	searchBox:SetHeight(20)
	searchBox:SetPoint("LEFT", 12, 0)
	searchBox:SetPoint("RIGHT", -8, 0)
	searchBox:SetMaxLetters(40)
	searchBox.instructionText = L.SEARCH_PLACEHOLDER
	searchBox.Instructions:SetText(L.SEARCH_PLACEHOLDER)
	searchBox:HookScript("OnEnter", ShowSearchTooltip)
	searchBox:HookScript("OnLeave", GameTooltip_Hide)
	searchBox:HookScript("OnTextChanged", SearchBox_OnTextChanged)
	searchBox:HookScript("OnEnterPressed", function(editBox)
		editBox:ClearFocus()
	end)

	noResultsText = FriendsListFrame:CreateFontString(nil, "ARTWORK", "GameFontDisable")
	noResultsText:SetPoint("TOP", FriendsListFrame.ScrollBox, "TOP", 0, -40)
	noResultsText:SetText(L.SEARCH_NO_RESULTS)
	noResultsText:Hide()
end

function addon.SetUpSearch()
	CreateSearchBar()
	hooksecurefunc("FriendsList_Update", UpdateDisplayedFriends)

	FriendsFrame:HookScript("OnHide", function()
		ClearSearch()
		searchBox:ClearFocus()
	end)

	addon.OnOptionChanged("enabled", UpdateSearchBar)
	addon.OnOptionChanged("search", UpdateSearchBar)
	addon.OnOptionChanged("smartSorting", RefreshFriendsList)
	UpdateSearchBar()
end
