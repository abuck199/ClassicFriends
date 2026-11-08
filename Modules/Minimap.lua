local ADDON_NAME, addon = ...
local L = addon.L

local function UpdateMinimapButton(minimapIcon)
	addon.settings.minimap.hide = not addon.settings.minimapButton
	if addon.settings.minimapButton then
		minimapIcon:Show(ADDON_NAME)
	else
		minimapIcon:Hide(ADDON_NAME)
	end
end

function addon.CreateMinimapButton()
	local dataBroker = LibStub("LibDataBroker-1.1")
	local minimapIcon = LibStub("LibDBIcon-1.0")

	local launcher = dataBroker:NewDataObject(ADDON_NAME, {
		type = "launcher",
		label = L.ADDON_TITLE,
		icon = "Interface\\FriendsFrame\\Battlenet-Portrait",
		OnClick = function(_, mouseButton)
			if mouseButton == "RightButton" then
				addon.ToggleFriendsList()
			else
				addon.TogglePanel()
			end
		end,
		OnTooltipShow = function(tooltip)
			tooltip:AddLine(L.ADDON_TITLE, 1, 1, 1)
			tooltip:AddLine(L.MINIMAP_TIP_LEFT, NORMAL_FONT_COLOR:GetRGB())
			tooltip:AddLine(L.MINIMAP_TIP_RIGHT, NORMAL_FONT_COLOR:GetRGB())
			tooltip:AddLine(L.MINIMAP_TIP_DRAG, 0.7, 0.7, 0.7)
		end,
	})

	addon.settings.minimap = addon.settings.minimap or {}
	addon.settings.minimap.hide = not addon.settings.minimapButton
	minimapIcon:Register(ADDON_NAME, launcher, addon.settings.minimap)

	addon.OnOptionChanged("minimapButton", function()
		UpdateMinimapButton(minimapIcon)
	end)
end
