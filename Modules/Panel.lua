local _, addon = ...
local L = addon.L

local LINKS = {
	{
		logo = "Interface\\AddOns\\ClassicFriends\\Media\\GitHub",
		url = "https://github.com/abuck199/ClassicFriends/issues",
		label = "GitHub",
		title = L.GITHUB_TITLE,
		tooltip = L.GITHUB_TOOLTIP,
	},
	{
		logo = "Interface\\AddOns\\ClassicFriends\\Media\\CurseForge",
		logoColor = { 0.945, 0.392, 0.212 },
		logoHoverColor = { 1, 0.55, 0.38 },
		url = "https://www.curseforge.com/wow/addons/classic-friends",
		label = "CurseForge",
		title = L.CURSEFORGE_TITLE,
		tooltip = L.CURSEFORGE_TOOLTIP,
	},
}
local CHECKBOX_ART = "Interface\\Buttons\\UI-CheckBox-"
local CLOSE_BUTTON_ART = "Interface\\Buttons\\UI-Panel-MinimizeButton-"

local DRAWER_WIDTH = 300
local DRAWER_OFFSET_Y = 0
local PADDING = 20
local CHECK_ROW_HEIGHT = 22
local SLIDER_ROW_HEIGHT = 38
local SECTION_GAP = 8
local SECTION_TITLE_HEIGHT = 18
local CHECKBOX_SIZE = 24
local SLIDER_THUMB_INSET = 8
local SETTINGS_BUTTON_SCALE = 0.8

local DIALOG_BACKDROP = {
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true,
	tileSize = 32,
	edgeSize = 32,
	insets = { left = 11, right = 12, top = 12, bottom = 11 },
}

local SLIDER_BACKDROP = {
	bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
	edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
	tile = true,
	tileSize = 8,
	edgeSize = 8,
	insets = { left = 3, right = 3, top = 6, bottom = 6 },
}

local LINK_WINDOW_BACKDROP = {
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true,
	tileSize = 16,
	edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4 },
}

local drawer, settingsButton
local isDrawerDocked, isDrawerOnRight = false, false
local optionRows = {}

local function SkinClassicCloseButton(closeButton)
	closeButton:SetNormalTexture(CLOSE_BUTTON_ART .. "Up")
	closeButton:SetPushedTexture(CLOSE_BUTTON_ART .. "Down")
	closeButton:SetHighlightTexture(CLOSE_BUTTON_ART .. "Highlight", "ADD")
	closeButton:SetSize(32, 32)
end

local function ShowNewBadge(row)
	if row.newBadge then
		row.newBadge:SetShown(not addon.settings[row.option.key .. "Tried"])
	end
end

local function MarkOptionTried(option)
	if option.isNew then
		addon.settings[option.key .. "Tried"] = true
	end
end

-- Option rows -------------------------------------------------------------------------------

local function IsOptionAvailable(option)
	local requiredKey = option.requires
	while requiredKey do
		if not addon.settings[requiredKey] then
			return false
		end
		requiredKey = addon.optionsByKey[requiredKey].requires
	end
	return true
end

local function ShowOptionTooltip(owner, row)
	local option = row.option
	GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
	GameTooltip:SetText(option.label, 1, 1, 1)
	GameTooltip:AddLine(option.tooltip, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
	if not row.isAvailable then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L.REQUIRES:format(addon.optionsByKey[option.requires].label), RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, true)
	end
	GameTooltip:Show()
end

local function CheckRow_OnEnter(row)
	ShowOptionTooltip(row, row)
end

local function CheckRow_OnClick(row)
	local isChecked = row:GetChecked()
	PlaySound(isChecked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
	if isChecked then
		MarkOptionTried(row.option)
	end
	addon.SetOption(row.option.key, isChecked)
end

local function RefreshCheckRow(row)
	row:SetChecked(addon.settings[row.option.key])
	row:SetEnabled(row.isAvailable)
	row.label:SetFontObject(row.isAvailable and GameFontHighlight or GameFontDisable)
	ShowNewBadge(row)
end

local function SetCheckboxTexture(texture)
	texture:ClearAllPoints()
	texture:SetPoint("LEFT")
	texture:SetSize(CHECKBOX_SIZE, CHECKBOX_SIZE)
end

local function CreateNewBadge(row)
	local badge = row:CreateFontString(nil, "ARTWORK", "GameFontGreenSmall")
	badge:SetPoint("LEFT", row.label, "RIGHT", 6, 0)
	badge:SetText(L.NEW_BADGE)
	return badge
end

local function CreateCheckRow(option, offsetY)
	local row = CreateFrame("CheckButton", nil, drawer)
	row:SetPoint("TOPLEFT", PADDING, offsetY)
	row:SetPoint("TOPRIGHT", -PADDING, offsetY)
	row:SetHeight(CHECK_ROW_HEIGHT)
	row:SetMotionScriptsWhileDisabled(true)
	row.option = option
	row.Refresh = RefreshCheckRow

	row:SetNormalTexture(CHECKBOX_ART .. "Up")
	row:SetPushedTexture(CHECKBOX_ART .. "Down")
	row:SetHighlightTexture(CHECKBOX_ART .. "Highlight", "ADD")
	row:SetCheckedTexture(CHECKBOX_ART .. "Check")
	row:SetDisabledCheckedTexture(CHECKBOX_ART .. "Check-Disabled")
	SetCheckboxTexture(row:GetNormalTexture())
	SetCheckboxTexture(row:GetPushedTexture())
	SetCheckboxTexture(row:GetHighlightTexture())
	SetCheckboxTexture(row:GetCheckedTexture())
	SetCheckboxTexture(row:GetDisabledCheckedTexture())

	row.label = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	row.label:SetPoint("LEFT", CHECKBOX_SIZE + 4, 0)
	row.label:SetText(option.label)
	if option.isNew then
		row.newBadge = CreateNewBadge(row)
	end

	row:SetScript("OnClick", CheckRow_OnClick)
	row:SetScript("OnEnter", CheckRow_OnEnter)
	row:SetScript("OnLeave", GameTooltip_Hide)
	table.insert(optionRows, row)
end

local function CreateSectionTitle(text, offsetY)
	local title = drawer:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	title:SetPoint("TOPLEFT", PADDING, offsetY)
	title:SetText(text)
end

-- Sliders -----------------------------------------------------------------------------------

local function FormatPercent(value)
	return ("%d%%"):format(math.floor(value * 100 + 0.5))
end

local function GetThumbTravel(row)
	return row.track:GetWidth() - SLIDER_THUMB_INSET * 2
end

local function MoveThumb(row, value)
	local option = row.option
	local progress = (value - option.minimum) / (option.maximum - option.minimum)
	row.thumb:ClearAllPoints()
	row.thumb:SetPoint("CENTER", row.track, "LEFT", SLIDER_THUMB_INSET + progress * GetThumbTravel(row), 0)
	row.valueText:SetText(FormatPercent(value))
end

local function RefreshSliderRow(row)
	MoveThumb(row, addon.settings[row.option.key])
	row.track:EnableMouse(row.isAvailable)
	row.track:SetAlpha(row.isAvailable and 1 or 0.5)
	row.label:SetFontObject(row.isAvailable and GameFontHighlight or GameFontDisable)
	ShowNewBadge(row)
end

local function MovesDrawer(option)
	return option.key == "windowScale" and isDrawerDocked and isDrawerOnRight
end

local function RoundToStep(option, value)
	local steps = math.floor((value - option.minimum) / option.step + 0.5)
	local rounded = math.max(option.minimum, math.min(option.maximum, option.minimum + steps * option.step))
	return math.floor(rounded * 100 + 0.5) / 100
end

local function Track_OnUpdate(track)
	if not IsMouseButtonDown("LeftButton") then
		track:SetScript("OnUpdate", nil)
		return
	end
	local row = track:GetParent()
	local option = row.option
	local cursorX = GetCursorPosition() / drawer:GetEffectiveScale()
	local value = RoundToStep(option, (cursorX - row.dragOrigin) / row.dragSlope)
	if value ~= addon.settings[option.key] then
		MarkOptionTried(option)
		addon.SetOption(option.key, value)
	end
end

local function Track_OnMouseDown(track)
	local row = track:GetParent()
	local option = row.option
	local slope = GetThumbTravel(row) / (option.maximum - option.minimum)
	if MovesDrawer(option) then
		slope = slope + FriendsFrame:GetWidth()
	end
	row.dragSlope = slope
	row.dragOrigin = row.thumb:GetCenter() - addon.settings[option.key] * slope
	track:SetScript("OnUpdate", Track_OnUpdate)
	Track_OnUpdate(track)
end

local function Track_OnMouseUp(track)
	track:SetScript("OnUpdate", nil)
end

local function Track_OnEnter(track)
	ShowOptionTooltip(track, track:GetParent())
end

local function CreateSliderRow(option, offsetY)
	local row = CreateFrame("Frame", nil, drawer)
	row:SetPoint("TOPLEFT", PADDING, offsetY)
	row:SetPoint("TOPRIGHT", -PADDING, offsetY)
	row:SetHeight(SLIDER_ROW_HEIGHT)
	row.option = option
	row.Refresh = RefreshSliderRow

	row.label = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	row.label:SetPoint("TOPLEFT", 4, -2)
	row.label:SetText(option.label)
	if option.isNew then
		row.newBadge = CreateNewBadge(row)
	end

	row.valueText = row:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	row.valueText:SetPoint("TOPRIGHT", -4, -3)

	local track = CreateFrame("Frame", nil, row, "BackdropTemplate")
	track:SetPoint("BOTTOMLEFT", 4, 4)
	track:SetPoint("BOTTOMRIGHT", -4, 4)
	track:SetHeight(17)
	track:SetBackdrop(SLIDER_BACKDROP)
	track:SetScript("OnMouseDown", Track_OnMouseDown)
	track:SetScript("OnMouseUp", Track_OnMouseUp)
	track:SetScript("OnEnter", Track_OnEnter)
	track:SetScript("OnLeave", GameTooltip_Hide)
	row.track = track

	row.thumb = track:CreateTexture(nil, "OVERLAY")
	row.thumb:SetTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
	row.thumb:SetSize(32, 32)

	table.insert(optionRows, row)
end

-- Links -------------------------------------------------------------------------------------

local linkOverlay, linkLogo, linkTitle
local shownLink

local DEFAULT_LOGO_COLOR = { 0.75, 0.75, 0.75 }
local DEFAULT_LOGO_HOVER_COLOR = { 1, 1, 1 }

local function GetLogoColor(link, isHovered)
	if isHovered then
		return unpack(link.logoHoverColor or DEFAULT_LOGO_HOVER_COLOR)
	end
	return unpack(link.logoColor or DEFAULT_LOGO_COLOR)
end

local function SelectLink(linkBox)
	linkBox:SetText(shownLink.url)
	linkBox:SetFocus()
	linkBox:HighlightText()
end

local function CloseLinkWindow()
	linkOverlay:Hide()
end

local function CreateLinkWindow()
	linkOverlay = CreateFrame("Button", nil, drawer)
	linkOverlay:SetAllPoints()
	linkOverlay:SetFrameStrata("FULLSCREEN_DIALOG")
	linkOverlay:Hide()
	local darkening = linkOverlay:CreateTexture(nil, "BACKGROUND")
	darkening:SetPoint("TOPLEFT", 11, -12)
	darkening:SetPoint("BOTTOMRIGHT", -12, 11)
	darkening:SetColorTexture(0, 0, 0, 0.75)
	linkOverlay:SetScript("OnClick", CloseLinkWindow)

	local linkWindow = CreateFrame("Frame", "ClassicFriendsLinkWindow", linkOverlay, "BackdropTemplate")
	linkWindow:SetSize(DRAWER_WIDTH - 40, 120)
	linkWindow:SetPoint("CENTER")
	linkWindow:EnableMouse(true)
	linkWindow:SetBackdrop(LINK_WINDOW_BACKDROP)

	linkLogo = linkWindow:CreateTexture(nil, "ARTWORK")
	linkLogo:SetSize(16, 16)
	linkLogo:SetPoint("TOPLEFT", 14, -14)

	linkTitle = linkWindow:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	linkTitle:SetPoint("LEFT", linkLogo, "RIGHT", 6, 0)

	local closeButton = CreateFrame("Button", nil, linkWindow, "UIPanelCloseButton")
	SkinClassicCloseButton(closeButton)
	closeButton:SetPoint("TOPRIGHT", 2, 2)
	closeButton:SetScript("OnClick", CloseLinkWindow)

	local instructions = linkWindow:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	instructions:SetPoint("TOPLEFT", 14, -40)
	instructions:SetPoint("TOPRIGHT", -14, -40)
	instructions:SetJustifyH("LEFT")

	local linkBox = CreateFrame("EditBox", nil, linkWindow, "InputBoxTemplate")
	linkBox:SetPoint("BOTTOMLEFT", 20, 16)
	linkBox:SetPoint("BOTTOMRIGHT", -16, 16)
	linkBox:SetHeight(24)
	linkBox:SetFontObject(GameFontHighlightSmall)
	linkBox:SetAutoFocus(false)

	linkBox:SetScript("OnTextChanged", function(self, isUserInput)
		if isUserInput then
			SelectLink(self)
		end
	end)
	linkBox:SetScript("OnMouseUp", function(self)
		self:HighlightText()
	end)
	linkBox:SetScript("OnEscapePressed", CloseLinkWindow)
	linkBox:SetScript("OnEnterPressed", CloseLinkWindow)
	linkBox:SetScript("OnKeyDown", function(_, key)
		if key == "C" and IsControlKeyDown() then
			instructions:SetText(L.GITHUB_COPIED)
			instructions:SetTextColor(GREEN_FONT_COLOR:GetRGB())
			C_Timer.After(1, function()
				if instructions:GetText() == L.GITHUB_COPIED then
					CloseLinkWindow()
				end
			end)
		end
	end)

	linkOverlay:SetScript("OnShow", function()
		linkLogo:SetTexture(shownLink.logo)
		linkLogo:SetVertexColor(GetLogoColor(shownLink, true))
		linkTitle:SetText(shownLink.title)
		instructions:SetText(L.GITHUB_COPY)
		instructions:SetTextColor(HIGHLIGHT_FONT_COLOR:GetRGB())
		SelectLink(linkBox)
	end)
	linkOverlay:SetScript("OnHide", function()
		linkBox:ClearFocus()
	end)
end

local function ShowLinkWindow(link)
	if not linkOverlay then
		CreateLinkWindow()
	end
	shownLink = link
	linkOverlay:Hide()
	linkOverlay:Show()
end

local function CreateLinkButton(link, parent)
	local linkButton = CreateFrame("Button", nil, parent)
	linkButton:SetHeight(22)

	local logo = linkButton:CreateTexture(nil, "ARTWORK")
	logo:SetTexture(link.logo)
	logo:SetSize(14, 14)
	logo:SetPoint("LEFT")
	logo:SetVertexColor(GetLogoColor(link, false))

	local linkText = linkButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	linkText:SetPoint("LEFT", logo, "RIGHT", 5, 0)
	linkText:SetText(link.label)
	linkButton:SetWidth(logo:GetWidth() + 5 + linkText:GetStringWidth())

	linkButton:SetScript("OnEnter", function(self)
		logo:SetVertexColor(GetLogoColor(link, true))
		linkText:SetTextColor(HIGHLIGHT_FONT_COLOR:GetRGB())
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(link.title, 1, 1, 1)
		GameTooltip:AddLine(link.tooltip, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
		GameTooltip:Show()
	end)
	linkButton:SetScript("OnLeave", function()
		logo:SetVertexColor(GetLogoColor(link, false))
		linkText:SetTextColor(NORMAL_FONT_COLOR:GetRGB())
		GameTooltip:Hide()
	end)
	linkButton:SetScript("OnClick", function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		ShowLinkWindow(link)
	end)

	return linkButton
end

local function CreateLinksFooter(offsetY)
	local footer = CreateFrame("Frame", nil, drawer)
	footer:SetHeight(22)
	local footerWidth = 0
	local previousRegion
	for _, link in ipairs(LINKS) do
		if previousRegion then
			local separator = footer:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
			separator:SetPoint("LEFT", previousRegion, "RIGHT", 10, 0)
			separator:SetText("||")
			footerWidth = footerWidth + 10 + separator:GetStringWidth() + 10
			previousRegion = separator
		end
		local linkButton = CreateLinkButton(link, footer)
		if previousRegion then
			linkButton:SetPoint("LEFT", previousRegion, "RIGHT", 10, 0)
		else
			linkButton:SetPoint("LEFT")
		end
		footerWidth = footerWidth + linkButton:GetWidth()
		previousRegion = linkButton
	end
	footer:SetWidth(footerWidth)
	footer:SetPoint("TOPLEFT", drawer, "TOPLEFT", PADDING + 4, offsetY)
	return offsetY - 24
end

-- Smart sorting tip -------------------------------------------------------------------------

local function MarkSmartSortingTipSeen()
	addon.settings.smartSortingTipSeen = true
end

local smartSortingTip = {
	text = L.SMARTSORT_TIP,
	buttonStyle = HelpTip.ButtonStyle.Close,
	targetPoint = HelpTip.Point.RightEdgeCenter,
	offsetX = 4,
	system = "ClassicFriends",
	onAcknowledgeCallback = MarkSmartSortingTipSeen,
}

local function ShowSmartSortingTip()
	local settings = addon.settings
	if settings.smartSortingTipSeen or settings.smartSorting or not addon.IsEnabled() then
		return
	end
	HelpTip:Show(FriendsFrame, smartSortingTip, settingsButton)
end

local function HideSmartSortingTip()
	MarkSmartSortingTipSeen()
	HelpTip:Hide(FriendsFrame, smartSortingTip.text)
end

-- New options -------------------------------------------------------------------------------

local function HasUnseenNewOptions()
	for _, option in ipairs(addon.options) do
		if option.isNew and not addon.settings[option.key .. "Seen"] then
			return true
		end
	end
	return false
end

function addon.MarkNewOptionsSeen()
	for _, option in ipairs(addon.options) do
		if option.isNew then
			addon.settings[option.key .. "Seen"] = true
		end
	end
end

-- Drawer ------------------------------------------------------------------------------------

function addon.RefreshPanel()
	if not addon.IsPanelShown() then
		return
	end
	for _, row in ipairs(optionRows) do
		row.isAvailable = IsOptionAvailable(row.option)
		row:Refresh()
	end
end

local function HasRoomOnRight()
	local windowRight = FriendsFrame:GetRight()
	if not windowRight then
		return true
	end
	local screenRight = UIParent:GetRight() * UIParent:GetEffectiveScale()
	local roomOnRight = screenRight - windowRight * FriendsFrame:GetEffectiveScale()
	return roomOnRight >= DRAWER_WIDTH * drawer:GetEffectiveScale()
end

local function PlaceDrawer()
	drawer:ClearAllPoints()
	isDrawerDocked = addon.IsEnabled() and FriendsFrame:IsShown()
	isDrawerOnRight = isDrawerDocked and HasRoomOnRight()
	if not isDrawerDocked then
		drawer:SetPoint("CENTER", 0, 60)
	elseif isDrawerOnRight then
		drawer:SetPoint("TOPLEFT", FriendsFrame, "TOPRIGHT", -2, DRAWER_OFFSET_Y)
	else
		drawer:SetPoint("TOPRIGHT", FriendsFrame, "TOPLEFT", 2, DRAWER_OFFSET_Y)
	end
end

local function ShowVersionTooltip(owner)
	if addon.version == "" then
		return
	end
	GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
	GameTooltip:SetText(L.ADDON_TITLE, 1, 1, 1)
	GameTooltip:AddLine(L.VERSION:format(addon.version), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	GameTooltip:Show()
end

local function CreateDrawer()
	drawer = CreateFrame("Frame", "ClassicFriendsOptions", UIParent, "BackdropTemplate")
	drawer:SetWidth(DRAWER_WIDTH)
	drawer:SetFrameStrata("HIGH")
	drawer:EnableMouse(true)
	drawer:SetBackdrop(DIALOG_BACKDROP)
	drawer:Hide()
	table.insert(UISpecialFrames, drawer:GetName())

	local title = drawer:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", PADDING, -18)
	title:SetText(L.ADDON_TITLE)

	local titleHoverArea = CreateFrame("Frame", nil, drawer)
	titleHoverArea:SetAllPoints(title)
	titleHoverArea:EnableMouse(true)
	titleHoverArea:SetScript("OnEnter", ShowVersionTooltip)
	titleHoverArea:SetScript("OnLeave", GameTooltip_Hide)

	local closeButton = CreateFrame("Button", nil, drawer, "UIPanelCloseButton")
	SkinClassicCloseButton(closeButton)
	closeButton:SetPoint("TOPRIGHT", -6, -6)
	closeButton:SetScript("OnClick", function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
		drawer:Hide()
	end)

	local offsetY = -34
	for _, option in ipairs(addon.options) do
		if option.header then
			offsetY = offsetY - SECTION_GAP
			CreateSectionTitle(option.header, offsetY)
			offsetY = offsetY - SECTION_TITLE_HEIGHT
		elseif option.step then
			CreateSliderRow(option, offsetY)
			offsetY = offsetY - SLIDER_ROW_HEIGHT
		else
			CreateCheckRow(option, offsetY)
			offsetY = offsetY - CHECK_ROW_HEIGHT
		end
	end
	offsetY = CreateLinksFooter(offsetY - 4)
	drawer:SetHeight(-offsetY + 12)

	drawer:SetScript("OnShow", function()
		HideSmartSortingTip()
		addon.MarkNewOptionsSeen()
		addon.RefreshPanel()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
	end)
	drawer:SetScript("OnHide", function()
		GameTooltip:Hide()
	end)
end

local function ShowDrawer()
	if not drawer then
		CreateDrawer()
	end
	PlaceDrawer()
	drawer:Show()
end

function addon.IsPanelShown()
	return drawer ~= nil and drawer:IsShown()
end

function addon.TogglePanel()
	if addon.IsPanelShown() then
		drawer:Hide()
		return
	end
	if addon.IsEnabled() then
		addon.ShowClassicWindow()
	end
	ShowDrawer()
end

function ClassicFriends_OnAddonCompartmentClick()
	addon.TogglePanel()
end

-- Settings button ---------------------------------------------------------------------------

local function FriendsFrame_OnShow()
	if addon.IsEnabled() and HasUnseenNewOptions() and not addon.IsPanelShown() then
		ShowDrawer()
	else
		ShowSmartSortingTip()
	end
end

local function FriendsFrame_OnHide()
	if addon.IsPanelShown() and isDrawerDocked then
		drawer:Hide()
	end
end

function addon.CreateSettingsButton()
	settingsButton = CreateFrame("Button", "ClassicFriendsSettingsButton", FriendsFrame)
	settingsButton:SetSize(32, 32)
	settingsButton:SetScale(SETTINGS_BUTTON_SCALE)
	settingsButton:SetPoint("CENTER", FriendsTabHeader.BattlenetFrame.ContactsMenuButton, "BOTTOM", 0, -12 / SETTINGS_BUTTON_SCALE)
	settingsButton:SetFrameLevel(FriendsFrame:GetFrameLevel() + 10)
	settingsButton:SetNormalTexture("Interface\\Buttons\\UI-SquareButton-Up")
	settingsButton:SetPushedTexture("Interface\\Buttons\\UI-SquareButton-Down")
	settingsButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")

	local gearIcon = settingsButton:CreateTexture(nil, "OVERLAY")
	gearIcon:SetAtlas("questlog-icon-setting")
	gearIcon:SetSize(18, 18)
	gearIcon:SetVertexColor(1, 0.9, 0.5)
	gearIcon:SetPoint("CENTER")

	local gearShine = settingsButton:CreateTexture(nil, "OVERLAY", nil, 1)
	gearShine:SetAtlas("questlog-icon-setting")
	gearShine:SetAllPoints(gearIcon)
	gearShine:SetVertexColor(1, 0.85, 0.3)
	gearShine:SetBlendMode("ADD")
	gearShine:SetAlpha(0.7)

	settingsButton:SetScript("OnMouseDown", function()
		gearIcon:SetPoint("CENTER", -1, -1)
	end)
	settingsButton:SetScript("OnMouseUp", function()
		gearIcon:SetPoint("CENTER")
	end)
	settingsButton:SetScript("OnClick", function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		addon.TogglePanel()
	end)
	settingsButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(L.SETTINGS_BUTTON_TOOLTIP, 1, 1, 1)
		GameTooltip:Show()
	end)
	settingsButton:SetScript("OnLeave", GameTooltip_Hide)

	FriendsFrame:HookScript("OnShow", FriendsFrame_OnShow)
	FriendsFrame:HookScript("OnHide", FriendsFrame_OnHide)
end
