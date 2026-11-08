local _, addon = ...

local MEDIA_FOLDER = "Interface\\AddOns\\ClassicFriends\\Media\\"

local probeTexture
local function TextureFileExists(path)
	if not probeTexture then
		probeTexture = UIParent:CreateTexture()
		probeTexture:Hide()
	end
	local exists = probeTexture:SetTexture(path) ~= false
	probeTexture:SetTexture(nil)
	return exists
end

-- Window frame ------------------------------------------------------------------------------

local function CreateAtlasTexture(parent, layer, atlasName)
	local texture = parent:CreateTexture(nil, layer)
	local firstCharacter = atlasName:sub(1, 1)
	local tilesAcross, tilesDown = firstCharacter == "_", firstCharacter == "!"
	texture:SetAtlas(atlasName, not tilesAcross and not tilesDown)
	texture:SetHorizTile(tilesAcross)
	texture:SetVertTile(tilesDown)
	return texture
end

local function CreateFileTexture(parent, filePath, left, right, top, bottom, width, height)
	local texture = parent:CreateTexture(nil, "BORDER", nil, 1)
	texture:SetTexture(filePath)
	texture:SetTexCoord(left, right, top, bottom)
	texture:SetSize(width, height)
	return texture
end

local function SkinWindowFrame(window)
	window.NineSlice:SetAlpha(0)
	local borderFrame = CreateFrame("Frame", nil, window)
	borderFrame:SetAllPoints()
	borderFrame:SetFrameLevel(window.NineSlice:GetFrameLevel())

	local titleBackground = CreateAtlasTexture(window, "BACKGROUND", "_UI-Frame-TitleTileBg")
	titleBackground:SetPoint("TOPLEFT", 2, -3)
	titleBackground:SetPoint("TOPRIGHT", -25, -3)
	titleBackground:SetHeight(18)

	local portraitRing = CreateAtlasTexture(borderFrame, "OVERLAY", "UI-Frame-Portrait")
	portraitRing:SetPoint("TOPLEFT", -14, 11)

	local topRightCorner = CreateAtlasTexture(borderFrame, "OVERLAY", "UI-Frame-TopCornerRight")
	topRightCorner:SetPoint("TOPRIGHT", 0, 1)

	local topEdge = CreateAtlasTexture(borderFrame, "OVERLAY", "_UI-Frame-TitleTile")
	topEdge:SetHeight(28)
	topEdge:SetPoint("TOPLEFT", portraitRing, "TOPRIGHT", 0, -10)
	topEdge:SetPoint("TOPRIGHT", topRightCorner, "TOPLEFT")

	local bottomLeftCorner = CreateAtlasTexture(borderFrame, "BORDER", "UI-Frame-BotCornerLeft")
	bottomLeftCorner:SetPoint("BOTTOMLEFT", -6, -5)

	local bottomRightCorner = CreateAtlasTexture(borderFrame, "BORDER", "UI-Frame-BotCornerRight")
	bottomRightCorner:SetPoint("BOTTOMRIGHT", 0, -5)

	local bottomEdge = CreateAtlasTexture(borderFrame, "BORDER", "_UI-Frame-Bot")
	bottomEdge:SetHeight(9)
	bottomEdge:SetPoint("BOTTOMLEFT", bottomLeftCorner, "BOTTOMRIGHT")
	bottomEdge:SetPoint("BOTTOMRIGHT", bottomRightCorner, "BOTTOMLEFT")

	local leftEdge = CreateAtlasTexture(borderFrame, "BORDER", "!UI-Frame-LeftTile")
	leftEdge:SetWidth(16)
	leftEdge:SetPoint("TOPLEFT", portraitRing, "BOTTOMLEFT", 8, 0)
	leftEdge:SetPoint("BOTTOMLEFT", bottomLeftCorner, "TOPLEFT")

	local rightEdge = CreateAtlasTexture(borderFrame, "BORDER", "!UI-Frame-RightTile")
	rightEdge:SetWidth(10)
	rightEdge:SetPoint("TOPRIGHT", topRightCorner, "BOTTOMRIGHT", 1, 0)
	rightEdge:SetPoint("BOTTOMRIGHT", bottomRightCorner, "TOPRIGHT")

	local buttonBarLeft = CreateFileTexture(borderFrame, "Interface\\FrameGeneral\\UI-Frame", 0.8984375, 0.9921875, 0.28125, 0.53125, 12, 32)
	buttonBarLeft:SetPoint("BOTTOMLEFT", -2, -1)
	local buttonBarRight = CreateFileTexture(borderFrame, "Interface\\FrameGeneral\\UI-Frame", 0.1328125, 0.2265625, 0.6328125, 0.8828125, 12, 32)
	buttonBarRight:SetPoint("BOTTOMRIGHT", 0, -1)
	local buttonBarStrip = CreateFileTexture(borderFrame, "Interface\\FrameGeneral\\_UI-Frame", 0, 1, 0.046875, 0.0703125, 1, 3)
	buttonBarStrip:SetPoint("BOTTOMLEFT", buttonBarLeft, "BOTTOMRIGHT", 0, 3)
	buttonBarStrip:SetPoint("BOTTOMRIGHT", buttonBarRight, "BOTTOMLEFT", 0, 3)

	local rockBackground = MEDIA_FOLDER .. "UI-Background-Rock"
	if TextureFileExists(rockBackground) then
		window.Bg:SetTexture(rockBackground, "REPEAT", "REPEAT")
		window.Bg:SetHorizTile(true)
		window.Bg:SetVertTile(true)
	end

	return borderFrame
end

local function SkinCloseButton(closeButton, frameLevel)
	local artPath = "Interface\\Buttons\\UI-Panel-MinimizeButton-"
	closeButton:SetNormalTexture(artPath .. "Up")
	closeButton:SetPushedTexture(artPath .. "Down")
	closeButton:SetDisabledTexture(artPath .. "Disabled")
	closeButton:SetHighlightTexture(artPath .. "Highlight", "ADD")
	closeButton:SetSize(32, 32)
	closeButton:ClearAllPoints()
	closeButton:SetPoint("TOPRIGHT", 4, 5)
	closeButton:SetFrameLevel(frameLevel)
end

-- Tabs --------------------------------------------------------------------------------------

local TAB_HEIGHT = 32

local BOTTOM_TAB_ART = {
	piecesAnchoredAt = "TOP",
	sideWidth = 20,
	sideTexCoordWidth = 0.15625,
	unselected = { file = "Interface\\PaperDollInfoFrame\\UI-Character-InActiveTab", offsetY = -1 },
	selected = { file = "Interface\\PaperDollInfoFrame\\UI-Character-ActiveTab", texCoordBottom = 0.546875, height = 35 },
}
local TOP_TAB_ART = {
	piecesAnchoredAt = "BOTTOM",
	sideWidth = 16,
	sideTexCoordWidth = 0.25,
	unselected = { file = "Interface\\HelpFrame\\HelpFrameTab-Inactive" },
	selected = { file = "Interface\\HelpFrame\\HelpFrameTab-Active", offsetY = -3 },
}

local function SkinTabPieces(tab, tabArt)
	local edge = tabArt.piecesAnchoredAt
	local sideCoord = tabArt.sideTexCoordWidth
	local looks = {
		{ suffix = "", art = tabArt.unselected },
		{ suffix = "Active", art = tabArt.selected },
	}
	for _, look in ipairs(looks) do
		local leftPiece = tab["Left" .. look.suffix]
		local middlePiece = tab["Middle" .. look.suffix]
		local rightPiece = tab["Right" .. look.suffix]
		local pieces = {
			{ texture = leftPiece, texCoordLeft = 0, texCoordRight = sideCoord },
			{ texture = middlePiece, texCoordLeft = sideCoord, texCoordRight = 1 - sideCoord },
			{ texture = rightPiece, texCoordLeft = 1 - sideCoord, texCoordRight = 1 },
		}
		for _, piece in ipairs(pieces) do
			piece.texture:SetTexture(look.art.file)
			piece.texture:SetRotation(0)
			piece.texture:SetTexCoord(piece.texCoordLeft, piece.texCoordRight, 0, look.art.texCoordBottom or 1)
			piece.texture:SetHorizTile(false)
			piece.texture:SetHeight(look.art.height or TAB_HEIGHT)
			piece.texture:ClearAllPoints()
		end
		local offsetY = look.art.offsetY or 0
		leftPiece:SetWidth(tabArt.sideWidth)
		leftPiece:SetPoint(edge .. "LEFT", 0, offsetY)
		rightPiece:SetWidth(tabArt.sideWidth)
		rightPiece:SetPoint(edge .. "RIGHT", 0, offsetY)
		middlePiece:SetPoint(edge .. "LEFT", leftPiece, edge .. "RIGHT")
		middlePiece:SetPoint(edge .. "RIGHT", rightPiece, edge .. "LEFT")
	end
	tab.LeftHighlight:SetAlpha(0)
	tab.MiddleHighlight:SetAlpha(0)
	tab.RightHighlight:SetAlpha(0)
end

function addon.SkinBottomTab(tab)
	SkinTabPieces(tab, BOTTOM_TAB_ART)
	tab:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-RealHighlight", "ADD")
	local hoverGlow = tab:GetHighlightTexture()
	hoverGlow:ClearAllPoints()
	hoverGlow:SetPoint("TOPLEFT", 3, 5)
	hoverGlow:SetPoint("BOTTOMRIGHT", -3, 0)
end

local function PlaceTopTabLabel(tab, isSelected)
	tab.Text:SetPoint("CENTER", tab, "CENTER", 0, isSelected and -3 or -2)
end

local function SkinTopTabs()
	local tabSystem = FriendsTabHeader.TabSystem
	for _, tab in ipairs(tabSystem.tabs) do
		SkinTabPieces(tab, TOP_TAB_ART)
		tab:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight", "ADD")
		local hoverGlow = tab:GetHighlightTexture()
		hoverGlow:ClearAllPoints()
		hoverGlow:SetPoint("BOTTOMLEFT", 2, -8)
		hoverGlow:SetPoint("BOTTOMRIGHT", 2, -8)
		hoverGlow:SetHeight(TAB_HEIGHT)
		tab.Text:SetWidth(0)
		tab:SetWidth(tab.Text:GetStringWidth() + 2 * TOP_TAB_ART.sideWidth)
		hooksecurefunc(tab, "SetTabSelected", PlaceTopTabLabel)
		PlaceTopTabLabel(tab, tab.isSelected)
	end
	tabSystem:ClearAllPoints()
	tabSystem:SetPoint("TOPLEFT", FriendsTabHeader, "TOPLEFT", 18, -59)
	tabSystem:MarkDirty()
end

-- Battle.net bar and status button ----------------------------------------------------------

local function PlaceBattlenetBar()
	local tabHeader = FriendsTabHeader
	local battlenetBar = tabHeader.BattlenetFrame
	battlenetBar:ClearAllPoints()
	battlenetBar:SetPoint("TOPLEFT", tabHeader, "TOPLEFT", 109, -27)
	battlenetBar:SetPoint("TOPRIGHT", FriendsFrame.TitleContainer, "TOP", 135, -26)
	tabHeader.StatusDropdown:ClearAllPoints()
	tabHeader.StatusDropdown:SetPoint("RIGHT", battlenetBar, "LEFT", -2, 0)
	battlenetBar.BroadcastFrame:ClearAllPoints()
	battlenetBar.BroadcastFrame:SetPoint("TOPRIGHT", battlenetBar, "TOPRIGHT", 38, -24)
end

local STATUS_BUTTON_ART = MEDIA_FOLDER .. "StatusDropdown"
local STATUS_BOX_TEXCOORDS = { 0, 0.421875, 0, 0.640625 }
local STATUS_ARROW_TEXCOORDS = {
	normal = { 0.4375, 0.6171875, 0, 0.34375 },
	hover = { 0.625, 0.8046875, 0, 0.34375 },
	pressed = { 0.8125, 0.9921875, 0, 0.34375 },
	pressedHover = { 0.4375, 0.6171875, 0.375, 0.71875 },
	disabled = { 0.625, 0.8046875, 0.375, 0.71875 },
}

local function UpdateStatusArrow(statusButton)
	local arrowState = "normal"
	if not statusButton:IsEnabled() then
		arrowState = "disabled"
	elseif statusButton:IsDownOver() then
		arrowState = "pressedHover"
	elseif statusButton:IsOver() then
		arrowState = "hover"
	elseif statusButton:IsDown() then
		arrowState = "pressed"
	end
	statusButton.Arrow:SetTexture(STATUS_BUTTON_ART)
	statusButton.Arrow:SetTexCoord(unpack(STATUS_ARROW_TEXCOORDS[arrowState]))
	statusButton.Arrow:SetSize(23, 22)
end

local function SkinStatusButton()
	if not TextureFileExists(STATUS_BUTTON_ART) then
		return
	end
	local statusButton = FriendsTabHeader.StatusDropdown
	statusButton.Background:SetTexture(STATUS_BUTTON_ART)
	statusButton.Background:SetTexCoord(unpack(STATUS_BOX_TEXCOORDS))
	statusButton.Background:ClearAllPoints()
	statusButton.Background:SetPoint("TOPLEFT", -9, 8)
	statusButton.Background:SetPoint("BOTTOMRIGHT", 8, -9)
	statusButton.Arrow:ClearAllPoints()
	statusButton.Arrow:SetPoint("RIGHT", -1, 0)
	hooksecurefunc(statusButton, "OnButtonStateChanged", UpdateStatusArrow)
	UpdateStatusArrow(statusButton)
end

-- Scroll bars -------------------------------------------------------------------------------

local SCROLL_BAR_ART = "Interface\\Buttons\\UI-ScrollBar-"

local function SkinScrollArrow(arrowButton, artName)
	local arrowTexture = arrowButton.Texture
	arrowButton:SetSize(18, 16)

	local function ApplyClassicArrowArt(button)
		local buttonState = (not button:IsEnabled() and "Disabled") or (button.down and "Down") or "Up"
		arrowTexture:SetTexture(SCROLL_BAR_ART .. artName .. "-" .. buttonState)
		arrowTexture:SetTexCoord(0.20, 0.80, 0.25, 0.75)
		arrowTexture:SetSize(18, 16)
	end
	hooksecurefunc(arrowButton, "OnButtonStateChanged", ApplyClassicArrowArt)
	ApplyClassicArrowArt(arrowButton)

	local hoverGlow = arrowButton:CreateTexture(nil, "HIGHLIGHT")
	hoverGlow:SetTexture(SCROLL_BAR_ART .. artName .. "-Highlight")
	hoverGlow:SetTexCoord(0.20, 0.80, 0.25, 0.75)
	hoverGlow:SetBlendMode("ADD")
	hoverGlow:SetAllPoints(arrowTexture)
end

local function SkinScrollBar(scrollBar)
	SkinScrollArrow(scrollBar.Back, "ScrollUpButton")
	SkinScrollArrow(scrollBar.Forward, "ScrollDownButton")

	local track = scrollBar.Track
	track.Begin:SetAlpha(0)
	track.Middle:SetAlpha(0)
	track.End:SetAlpha(0)
	track:ClearAllPoints()
	track:SetPoint("TOP", scrollBar, "TOP", 0, -16)
	track:SetPoint("BOTTOM", scrollBar, "BOTTOM", 0, 16)
	local groove = track:CreateTexture(nil, "BACKGROUND")
	groove:SetPoint("TOPLEFT", -5, 0)
	groove:SetPoint("BOTTOMRIGHT", 5, 0)
	groove:SetColorTexture(0, 0, 0, 0.45)

	local thumb = track.Thumb
	thumb.Begin:SetAlpha(0)
	thumb.Middle:SetAlpha(0)
	thumb.End:SetAlpha(0)
	local knob = thumb:CreateTexture(nil, "OVERLAY")
	knob:SetTexture(SCROLL_BAR_ART .. "Knob")
	knob:SetTexCoord(0.20, 0.80, 0.125, 0.875)
	knob:SetSize(18, 24)
	knob:SetPoint("CENTER")

	scrollBar.minThumbExtent = 16
	scrollBar.fixedThumbExtent = 16
end

function addon.SkinFriendsFrame()
	local borderFrame = SkinWindowFrame(FriendsFrame)
	SkinCloseButton(FriendsFrame.CloseButton, borderFrame:GetFrameLevel() + 5)
	SkinTopTabs()
	PlaceBattlenetBar()
	SkinStatusButton()
	SkinScrollBar(FriendsListFrame.ScrollBar)
	SkinScrollBar(FriendsFrame.IgnoreListWindow.ScrollBar)
	SkinScrollBar(RecentAlliesFrame.List.ScrollBar)
end
