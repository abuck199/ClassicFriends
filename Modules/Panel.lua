local _, addon = ...
local L = addon.L

local WHITE_TEXTURE = "Interface\\Buttons\\WHITE8x8"
local CIRCLE_MASK = "Interface\\CharacterFrame\\TempPortraitAlphaMask"
local GITHUB_LOGO = "Interface\\AddOns\\ClassicFriends\\Media\\GitHub"
local ISSUES_URL = "https://github.com/abuck199/ClassicFriends/issues"

local PANEL_WIDTH = 330
local PADDING = 16
local ROW_INSET = 8
local ROW_HEIGHT = 42
local SECTION_GAP = 10
local SECTION_TITLE_HEIGHT = 18
local SWITCH_WIDTH, SWITCH_HEIGHT, KNOB_SIZE = 34, 18, 14
local SLIDER_TRACK_HEIGHT, SLIDER_THUMB_SIZE = 4, 14
local DISABLED_TEXT_ALPHA = 0.4

local COLORS = {
	background = { 0.05, 0.05, 0.06, 0.96 },
	border = { 1, 1, 1, 0.10 },
	accent = { 0.345, 0.667, 0.867 },
	sectionTitle = { 1, 0.82, 0 },
	divider = { 1, 1, 1, 0.08 },
	hover = { 1, 1, 1, 0.045 },
	trackOff = { 0.24, 0.24, 0.27 },
	knobOff = { 0.68, 0.68, 0.72 },
	knobOn = { 1, 1, 1 },
}

local panel
local optionRows = {}

local function CreateSolidTexture(parent, layer, color)
	local texture = parent:CreateTexture(nil, layer)
	texture:SetTexture(WHITE_TEXTURE)
	texture:SetVertexColor(color[1], color[2], color[3], color[4] or 1)
	return texture
end

local function CreateCircleTexture(parent, layer, size)
	local texture = parent:CreateTexture(nil, layer)
	texture:SetTexture(WHITE_TEXTURE)
	texture:SetSize(size, size)
	local circleMask = parent:CreateMaskTexture()
	circleMask:SetTexture(CIRCLE_MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
	circleMask:SetAllPoints(texture)
	texture:AddMaskTexture(circleMask)
	return texture
end

local function ToUppercase(text)
	text = text:upper()
	text = text:gsub("\195([\160-\190])", function(secondByte)
		if secondByte == "\183" then
			return "\195" .. secondByte
		end
		return "\195" .. string.char(secondByte:byte() - 32)
	end)
	text = text:gsub("\208([\176-\191])", function(secondByte)
		return "\208" .. string.char(secondByte:byte() - 32)
	end)
	text = text:gsub("\209([\128-\143])", function(secondByte)
		return "\208" .. string.char(secondByte:byte() + 32)
	end)
	return (text:gsub("\209\145", "\208\129"))
end

local function Interpolate(fromValue, toValue, progress)
	return fromValue + (toValue - fromValue) * progress
end

-- Switches ----------------------------------------------------------------------------------

local KNOB_LEFT_X = SWITCH_HEIGHT / 2
local KNOB_RIGHT_X = SWITCH_WIDTH - SWITCH_HEIGHT / 2
local DIMMED_BLEND = 0.6

local function GetControlColor(red, green, blue, isDimmed)
	if isDimmed then
		local background = COLORS.background
		return Interpolate(red, background[1], DIMMED_BLEND), Interpolate(green, background[2], DIMMED_BLEND), Interpolate(blue, background[3], DIMMED_BLEND)
	end
	return red, green, blue
end

local function DrawSwitch(switch)
	local progress = switch.position
	switch.knob:SetPoint("CENTER", switch, "LEFT", Interpolate(KNOB_LEFT_X, KNOB_RIGHT_X, progress), 0)

	local trackRed, trackGreen, trackBlue = GetControlColor(
		Interpolate(COLORS.trackOff[1], COLORS.accent[1], progress),
		Interpolate(COLORS.trackOff[2], COLORS.accent[2], progress),
		Interpolate(COLORS.trackOff[3], COLORS.accent[3], progress),
		switch.isDimmed)
	for _, trackPiece in ipairs(switch.trackPieces) do
		trackPiece:SetVertexColor(trackRed, trackGreen, trackBlue, 1)
	end

	switch.knob:SetVertexColor(GetControlColor(
		Interpolate(COLORS.knobOff[1], COLORS.knobOn[1], progress),
		Interpolate(COLORS.knobOff[2], COLORS.knobOn[2], progress),
		Interpolate(COLORS.knobOff[3], COLORS.knobOn[3], progress),
		switch.isDimmed))
end

local function Switch_OnUpdate(switch, elapsed)
	local remaining = switch.targetPosition - switch.position
	if math.abs(remaining) < 0.01 then
		switch.position = switch.targetPosition
		switch:SetScript("OnUpdate", nil)
	else
		switch.position = switch.position + remaining * math.min(1, elapsed * 16)
	end
	DrawSwitch(switch)
end

local function SetSwitchState(switch, isOn, skipAnimation)
	switch.targetPosition = isOn and 1 or 0
	if skipAnimation then
		switch.position = switch.targetPosition
		switch:SetScript("OnUpdate", nil)
	elseif switch.position ~= switch.targetPosition then
		switch:SetScript("OnUpdate", Switch_OnUpdate)
	end
	DrawSwitch(switch)
end

local function CreateSwitch(parent)
	local switch = CreateFrame("Frame", nil, parent)
	switch:SetSize(SWITCH_WIDTH, SWITCH_HEIGHT)

	local leftEnd = CreateCircleTexture(switch, "BACKGROUND", SWITCH_HEIGHT)
	leftEnd:SetPoint("LEFT")
	local rightEnd = CreateCircleTexture(switch, "BACKGROUND", SWITCH_HEIGHT)
	rightEnd:SetPoint("RIGHT")
	local middle = switch:CreateTexture(nil, "BACKGROUND")
	middle:SetTexture(WHITE_TEXTURE)
	middle:SetPoint("TOPLEFT", leftEnd, "TOP")
	middle:SetPoint("BOTTOMRIGHT", rightEnd, "BOTTOM")
	switch.trackPieces = { leftEnd, rightEnd, middle }

	switch.knob = CreateCircleTexture(switch, "ARTWORK", KNOB_SIZE)
	switch.position, switch.targetPosition = 0, 0
	DrawSwitch(switch)
	return switch
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

local function OptionRow_OnEnter(row)
	if row.isAvailable then
		row.hoverHighlight:Show()
	end
	local option = row.option
	GameTooltip:SetOwner(row, "ANCHOR_RIGHT", 6, 0)
	GameTooltip:SetText(option.label, 1, 1, 1)
	GameTooltip:AddLine(option.tooltip, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
	if not row.isAvailable then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L.REQUIRES:format(addon.optionsByKey[option.requires].label), 1, 0.3, 0.3, true)
	end
	GameTooltip:Show()
end

local function OptionRow_OnLeave(row)
	row.hoverHighlight:Hide()
	GameTooltip:Hide()
end

local function OptionRow_OnClick(row)
	if not row.isAvailable then
		return
	end
	local newValue = not addon.settings[row.option.key]
	PlaySound(newValue and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
	addon.SetOption(row.option.key, newValue)
end

local function RefreshSwitchRow(row, skipAnimation)
	local textAlpha = row.isAvailable and 1 or DISABLED_TEXT_ALPHA
	row.label:SetAlpha(textAlpha)
	row.description:SetAlpha(textAlpha)
	row.switch.isDimmed = not row.isAvailable
	SetSwitchState(row.switch, addon.settings[row.option.key], skipAnimation)
end

local function CreateRow(frameType, option, offsetY)
	local row = CreateFrame(frameType, nil, panel)
	row:SetPoint("TOPLEFT", ROW_INSET, offsetY)
	row:SetPoint("TOPRIGHT", -ROW_INSET, offsetY)
	row:SetHeight(ROW_HEIGHT)
	row.option = option

	row.hoverHighlight = CreateSolidTexture(row, "BACKGROUND", COLORS.hover)
	row.hoverHighlight:SetAllPoints()
	row.hoverHighlight:Hide()

	row.label = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	row.label:SetPoint("TOPLEFT", PADDING - ROW_INSET, -7)
	row.label:SetJustifyH("LEFT")
	row.label:SetText(option.label)

	row:SetScript("OnEnter", OptionRow_OnEnter)
	row:SetScript("OnLeave", OptionRow_OnLeave)
	table.insert(optionRows, row)
	return row
end

local function CreateOptionRow(option, offsetY)
	local row = CreateRow("Button", option, offsetY)
	row.Refresh = RefreshSwitchRow

	row.description = row:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	row.description:SetPoint("TOPLEFT", row.label, "BOTTOMLEFT", 0, -4)
	row.description:SetWidth(PANEL_WIDTH - PADDING * 2 - SWITCH_WIDTH - 12)
	row.description:SetJustifyH("LEFT")
	row.description:SetWordWrap(false)
	row.description:SetText(option.description)

	row.switch = CreateSwitch(row)
	row.switch:SetPoint("RIGHT", -(PADDING - ROW_INSET), 0)

	row:SetScript("OnClick", OptionRow_OnClick)
end

local function CreateSectionTitle(text, offsetY)
	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	title:SetPoint("TOPLEFT", PADDING, offsetY)
	title:SetText(ToUppercase(text))
	title:SetTextColor(COLORS.sectionTitle[1], COLORS.sectionTitle[2], COLORS.sectionTitle[3], 0.9)

	local divider = CreateSolidTexture(panel, "ARTWORK", COLORS.divider)
	divider:SetHeight(1)
	divider:SetPoint("LEFT", title, "RIGHT", 8, 0)
	divider:SetWidth(math.max(10, PANEL_WIDTH - PADDING * 2 - title:GetStringWidth() - 8))
end

-- Sliders -----------------------------------------------------------------------------------

local function FormatPercent(value)
	return ("%d%%"):format(math.floor(value * 100 + 0.5))
end

local function DrawSlider(row)
	local isDimmed = not row.isAvailable
	row.sliderTrack:SetVertexColor(GetControlColor(COLORS.trackOff[1], COLORS.trackOff[2], COLORS.trackOff[3], isDimmed))
	row.sliderFill:SetVertexColor(GetControlColor(COLORS.accent[1], COLORS.accent[2], COLORS.accent[3], isDimmed))
	row.sliderThumb:SetVertexColor(GetControlColor(COLORS.knobOn[1], COLORS.knobOn[2], COLORS.knobOn[3], isDimmed))
	row.valueText:SetText(FormatPercent(row.slider:GetValue()))
end

local function RefreshSliderRow(row)
	local textAlpha = row.isAvailable and 1 or DISABLED_TEXT_ALPHA
	row.label:SetAlpha(textAlpha)
	row.valueText:SetAlpha(textAlpha)
	row.slider:SetEnabled(row.isAvailable)
	row.slider:SetValue(addon.settings[row.option.key])
	DrawSlider(row)
end

local function Slider_OnValueChanged(slider, value, isUserInput)
	local row = slider:GetParent()
	if isUserInput then
		addon.SetOption(row.option.key, math.floor(value * 100 + 0.5) / 100)
	end
	DrawSlider(row)
end

local function Slider_OnEnter(slider)
	OptionRow_OnEnter(slider:GetParent())
end

local function Slider_OnLeave(slider)
	OptionRow_OnLeave(slider:GetParent())
end

local function CreateSliderRow(option, offsetY)
	local row = CreateRow("Frame", option, offsetY)
	row.Refresh = RefreshSliderRow
	row:EnableMouse(true)

	row.valueText = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	row.valueText:SetPoint("TOPRIGHT", -(PADDING - ROW_INSET), -9)

	local slider = CreateFrame("Slider", nil, row)
	slider:SetPoint("BOTTOMLEFT", PADDING - ROW_INSET, 6)
	slider:SetPoint("BOTTOMRIGHT", -(PADDING - ROW_INSET), 6)
	slider:SetHeight(SLIDER_THUMB_SIZE)
	slider:SetOrientation("HORIZONTAL")
	slider:SetMinMaxValues(option.minimum, option.maximum)
	slider:SetValueStep(option.step)
	slider:SetObeyStepOnDrag(true)
	slider:SetHitRectInsets(0, 0, -4, -4)
	row.slider = slider

	row.sliderThumb = CreateCircleTexture(slider, "OVERLAY", SLIDER_THUMB_SIZE)
	slider:SetThumbTexture(row.sliderThumb)

	row.sliderTrack = CreateSolidTexture(slider, "BACKGROUND", COLORS.trackOff)
	row.sliderTrack:SetHeight(SLIDER_TRACK_HEIGHT)
	row.sliderTrack:SetPoint("LEFT")
	row.sliderTrack:SetPoint("RIGHT")

	row.sliderFill = CreateSolidTexture(slider, "ARTWORK", COLORS.accent)
	row.sliderFill:SetHeight(SLIDER_TRACK_HEIGHT)
	row.sliderFill:SetPoint("LEFT")
	row.sliderFill:SetPoint("RIGHT", row.sliderThumb, "CENTER")

	slider:SetScript("OnValueChanged", Slider_OnValueChanged)
	slider:SetScript("OnEnter", Slider_OnEnter)
	slider:SetScript("OnLeave", Slider_OnLeave)
end

-- GitHub link -------------------------------------------------------------------------------

local linkOverlay, linkWindow

local function SelectLink(linkBox)
	linkBox:SetText(ISSUES_URL)
	linkBox:SetFocus()
	linkBox:HighlightText()
end

local function CloseLinkWindow()
	linkOverlay:Hide()
end

local function CreateLinkWindow()
	linkOverlay = CreateFrame("Button", nil, panel)
	linkOverlay:SetAllPoints()
	linkOverlay:SetFrameStrata("FULLSCREEN_DIALOG")
	linkOverlay:Hide()
	local darkening = linkOverlay:CreateTexture(nil, "BACKGROUND")
	darkening:SetAllPoints()
	darkening:SetColorTexture(0, 0, 0, 0.7)
	linkOverlay:SetScript("OnClick", CloseLinkWindow)

	linkWindow = CreateFrame("Frame", "ClassicFriendsLinkWindow", linkOverlay, "BackdropTemplate")
	linkWindow:SetSize(300, 116)
	linkWindow:SetPoint("CENTER")
	linkWindow:EnableMouse(true)
	linkWindow:SetBackdrop({ bgFile = WHITE_TEXTURE, edgeFile = WHITE_TEXTURE, edgeSize = 1 })
	linkWindow:SetBackdropColor(0.09, 0.09, 0.11, 1)
	linkWindow:SetBackdropBorderColor(unpack(COLORS.accent))

	local accentLine = CreateSolidTexture(linkWindow, "ARTWORK", COLORS.accent)
	accentLine:SetPoint("TOPLEFT", 1, -1)
	accentLine:SetPoint("TOPRIGHT", -1, -1)
	accentLine:SetHeight(2)

	local githubLogo = linkWindow:CreateTexture(nil, "ARTWORK")
	githubLogo:SetTexture(GITHUB_LOGO)
	githubLogo:SetSize(18, 18)
	githubLogo:SetPoint("TOPLEFT", PADDING, -14)

	local title = linkWindow:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	title:SetPoint("LEFT", githubLogo, "RIGHT", 8, 0)
	title:SetText(L.GITHUB_TITLE)

	local closeButton = CreateFrame("Button", nil, linkWindow, "UIPanelCloseButton")
	closeButton:SetPoint("TOPRIGHT", -4, -4)
	closeButton:SetScript("OnClick", CloseLinkWindow)

	local instructions = linkWindow:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	instructions:SetPoint("TOPLEFT", PADDING, -44)
	instructions:SetPoint("TOPRIGHT", -PADDING, -44)
	instructions:SetJustifyH("LEFT")

	local linkBox = CreateFrame("EditBox", nil, linkWindow, "BackdropTemplate")
	linkBox:SetPoint("BOTTOMLEFT", PADDING, 16)
	linkBox:SetPoint("BOTTOMRIGHT", -PADDING, 16)
	linkBox:SetHeight(24)
	linkBox:SetBackdrop({ bgFile = WHITE_TEXTURE, edgeFile = WHITE_TEXTURE, edgeSize = 1 })
	linkBox:SetBackdropColor(0, 0, 0, 0.5)
	linkBox:SetBackdropBorderColor(unpack(COLORS.accent))
	linkBox:SetTextInsets(8, 8, 0, 0)
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
		instructions:SetText(L.GITHUB_COPY)
		instructions:SetTextColor(HIGHLIGHT_FONT_COLOR:GetRGB())
		SelectLink(linkBox)
	end)
	linkOverlay:SetScript("OnHide", function()
		linkBox:ClearFocus()
	end)
end

local function ShowLinkWindow()
	if not linkOverlay then
		CreateLinkWindow()
	end
	linkOverlay:Show()
end

local function CreateGitHubLink(offsetY)
	local divider = CreateSolidTexture(panel, "ARTWORK", COLORS.divider)
	divider:SetHeight(1)
	divider:SetPoint("TOPLEFT", PADDING, offsetY)
	divider:SetPoint("TOPRIGHT", -PADDING, offsetY)

	local linkButton = CreateFrame("Button", nil, panel)
	linkButton:SetPoint("TOPLEFT", ROW_INSET, offsetY - 4)
	linkButton:SetPoint("TOPRIGHT", -ROW_INSET, offsetY - 4)
	linkButton:SetHeight(28)

	local hoverHighlight = CreateSolidTexture(linkButton, "BACKGROUND", COLORS.hover)
	hoverHighlight:SetAllPoints()
	hoverHighlight:Hide()

	local githubLogo = linkButton:CreateTexture(nil, "ARTWORK")
	githubLogo:SetTexture(GITHUB_LOGO)
	githubLogo:SetSize(16, 16)
	githubLogo:SetPoint("LEFT", PADDING - ROW_INSET, 0)
	githubLogo:SetVertexColor(0.75, 0.75, 0.75)

	local linkText = linkButton:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	linkText:SetPoint("LEFT", githubLogo, "RIGHT", 8, 0)
	linkText:SetText(L.GITHUB_LINK)
	linkText:SetTextColor(unpack(COLORS.accent))

	linkButton:SetScript("OnEnter", function(self)
		hoverHighlight:Show()
		githubLogo:SetVertexColor(1, 1, 1)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 6, 0)
		GameTooltip:SetText(L.GITHUB_TITLE, 1, 1, 1)
		GameTooltip:AddLine(L.GITHUB_TOOLTIP, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
		GameTooltip:Show()
	end)
	linkButton:SetScript("OnLeave", function()
		hoverHighlight:Hide()
		githubLogo:SetVertexColor(0.75, 0.75, 0.75)
		GameTooltip:Hide()
	end)
	linkButton:SetScript("OnClick", function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		ShowLinkWindow()
	end)

	return offsetY - 36
end

-- Panel -------------------------------------------------------------------------------------

function addon.RefreshPanel(skipAnimation)
	if not addon.IsPanelShown() then
		return
	end
	for _, row in ipairs(optionRows) do
		row.isAvailable = IsOptionAvailable(row.option)
		row:Refresh(skipAnimation)
		if not row.isAvailable then
			row.hoverHighlight:Hide()
		end
	end
end

local function RestorePanelPosition()
	local savedPosition = addon.settings.panelPosition
	panel:ClearAllPoints()
	if savedPosition then
		panel:SetPoint(savedPosition.point, UIParent, savedPosition.relativePoint, savedPosition.x, savedPosition.y)
	else
		panel:SetPoint("CENTER", 0, 60)
	end
end

local function StartMovingPanel()
	panel:StartMoving()
end

local function StopMovingPanel()
	panel:StopMovingOrSizing()
	local point, _, relativePoint, x, y = panel:GetPoint(1)
	addon.settings.panelPosition = { point = point, relativePoint = relativePoint, x = x, y = y }
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

local function CreatePanel()
	panel = CreateFrame("Frame", "ClassicFriendsPanel", UIParent, "BackdropTemplate")
	panel:SetWidth(PANEL_WIDTH)
	panel:SetFrameStrata("DIALOG")
	panel:SetToplevel(true)
	panel:SetClampedToScreen(true)
	panel:EnableMouse(true)
	panel:SetMovable(true)
	panel:RegisterForDrag("LeftButton")
	panel:SetScript("OnDragStart", StartMovingPanel)
	panel:SetScript("OnDragStop", StopMovingPanel)
	RestorePanelPosition()
	panel:Hide()
	table.insert(UISpecialFrames, panel:GetName())

	panel:SetBackdrop({ bgFile = WHITE_TEXTURE, edgeFile = WHITE_TEXTURE, edgeSize = 1 })
	panel:SetBackdropColor(unpack(COLORS.background))
	panel:SetBackdropBorderColor(unpack(COLORS.border))

	local accentLine = CreateSolidTexture(panel, "ARTWORK", COLORS.accent)
	accentLine:SetPoint("TOPLEFT", 1, -1)
	accentLine:SetPoint("TOPRIGHT", -1, -1)
	accentLine:SetHeight(2)

	local addonIcon = panel:CreateTexture(nil, "ARTWORK")
	addonIcon:SetTexture("Interface\\FriendsFrame\\Battlenet-Portrait")
	addonIcon:SetSize(30, 30)
	addonIcon:SetPoint("TOPLEFT", PADDING, -14)

	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("LEFT", addonIcon, "RIGHT", 10, 0)
	title:SetText(L.ADDON_TITLE)

	local titleHoverArea = CreateFrame("Frame", nil, panel)
	titleHoverArea:SetPoint("TOPLEFT", addonIcon)
	titleHoverArea:SetPoint("BOTTOMRIGHT", title, "BOTTOMRIGHT", 0, -6)
	titleHoverArea:EnableMouse(true)
	titleHoverArea:RegisterForDrag("LeftButton")
	titleHoverArea:SetScript("OnDragStart", StartMovingPanel)
	titleHoverArea:SetScript("OnDragStop", StopMovingPanel)
	titleHoverArea:SetScript("OnEnter", ShowVersionTooltip)
	titleHoverArea:SetScript("OnLeave", GameTooltip_Hide)

	local closeButton = CreateFrame("Button", nil, panel, "UIPanelCloseButton")
	closeButton:SetPoint("TOPRIGHT", -4, -4)
	closeButton:SetScript("OnClick", function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
		panel:Hide()
	end)

	local headerDivider = CreateSolidTexture(panel, "ARTWORK", COLORS.divider)
	headerDivider:SetHeight(1)
	headerDivider:SetPoint("TOPLEFT", PADDING, -56)
	headerDivider:SetPoint("TOPRIGHT", -PADDING, -56)

	local offsetY = -60
	for _, option in ipairs(addon.options) do
		if option.header then
			offsetY = offsetY - SECTION_GAP
			CreateSectionTitle(option.header, offsetY)
			offsetY = offsetY - SECTION_TITLE_HEIGHT
		elseif option.step then
			CreateSliderRow(option, offsetY)
			offsetY = offsetY - ROW_HEIGHT
		else
			CreateOptionRow(option, offsetY)
			offsetY = offsetY - ROW_HEIGHT
		end
	end
	offsetY = CreateGitHubLink(offsetY - 6)
	panel:SetHeight(-offsetY + 4)

	local fadeIn = panel:CreateAnimationGroup()
	local fadeInAlpha = fadeIn:CreateAnimation("Alpha")
	fadeInAlpha:SetFromAlpha(0)
	fadeInAlpha:SetToAlpha(1)
	fadeInAlpha:SetDuration(0.15)
	fadeInAlpha:SetSmoothing("OUT")

	panel:SetScript("OnShow", function()
		addon.RefreshPanel(true)
		fadeIn:Play()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
	end)
	panel:SetScript("OnHide", function()
		GameTooltip:Hide()
	end)
end

function addon.IsPanelShown()
	return panel ~= nil and panel:IsShown()
end

function addon.TogglePanel()
	if not panel then
		CreatePanel()
	end
	panel:SetShown(not panel:IsShown())
end

function ClassicFriends_OnAddonCompartmentClick()
	addon.TogglePanel()
end

function addon.CreateSettingsButton()
	local settingsButton = CreateFrame("Button", "ClassicFriendsSettingsButton", FriendsFrame)
	settingsButton:SetSize(15, 16)
	settingsButton:SetPoint("CENTER", FriendsTabHeader.BattlenetFrame.ContactsMenuButton, "BOTTOM", 0, -12)
	settingsButton:SetFrameLevel(FriendsFrame:GetFrameLevel() + 10)

	local gearIcon = settingsButton:CreateTexture(nil, "ARTWORK")
	gearIcon:SetAtlas("questlog-icon-setting", true)
	gearIcon:SetPoint("CENTER")
	local gearGlow = settingsButton:CreateTexture(nil, "HIGHLIGHT")
	gearGlow:SetAtlas("questlog-icon-setting", true)
	gearGlow:SetPoint("CENTER")
	gearGlow:SetBlendMode("ADD")
	gearGlow:SetAlpha(0.4)

	settingsButton:SetScript("OnMouseDown", function()
		gearIcon:SetPoint("CENTER", 1, -1)
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
end
