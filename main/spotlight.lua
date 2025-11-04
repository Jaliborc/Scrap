--[[
    Copyright 2008-2025 João Cardoso, All Rights Reserved
    Shows tag icons in the default bags.
--]]

if Bagnon or Bagnonium then
    return
end

local C = LibStub('C_Everywhere')
local Spotlight = Scrap2:NewModule('Spotlight')


--[[ Hook UI ]]--

function Spotlight:OnLoad()
	self.Buttons = {}
	self:RegisterSignal('LIST_CHANGED', 'UpdateAll')

	hooksecurefunc(ItemButtonMixin.SetItemButtonQuality and ItemButtonMixin or _G, 'SetItemButtonQuality',
				   GenerateClosure(self.UpdateButton, self))
end

function Spotlight:UpdateAll()
	for button in pairs(self.Buttons) do
		self:UpdateButton(button)
	end
end


--[[ Draw ]]--

function Spotlight:UpdateButton(button)
	local location = button.GetItemLocation and button:GetItemLocation() or ItemLocation:CreateFromBagAndSlot(button:GetParent():GetID(), button:GetID())
	local id = C.Item.DoesItemExist(location) and C.Item.GetItemID(location)
	local info = Scrap2:GetTagInfo(id, location)

	local icon = self.Buttons[button] or self:CreateTextures(button)
	icon:SetSize(16 * info.iconScale, 16 * info.iconScale)
	icon:SetAtlas(info.icon)

	local glow = icon.Glow
	glow:SetVertexColor((info.color or PURE_RED_COLOR):GetRGBA())
	glow:SetShown(info.color)

	if button.IconQuestTexture then
		button.IconQuestTexture:SetAlpha(info.color and 0 or 1)
	end
	if button.IconBorder then
		button.IconBorder:SetAlpha(info.color and 0 or 1)
	end
	if button.JunkIcon then
		button.JunkIcon:SetAlpha(0)
	end
end

function Spotlight:CreateTextures(button)
	local icon = button:CreateTexture(nil, 'OVERLAY')
	icon:SetPoint('TOPLEFT', 2, -1)

	local glow = button:CreateTexture(nil, 'OVERLAY')
	glow:SetTexture('Interface/Buttons/UI-ActionButton-Border')
	glow:SetBlendMode('ADD')
	glow:SetPoint('CENTER')
	glow:SetSize(67, 67)

	icon.Glow = glow
	self.Buttons[button] = icon
	return icon
end