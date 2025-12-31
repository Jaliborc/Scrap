--[[
    Copyright 2008-2025 João Cardoso, All Rights Reserved
    Shows tag icons in the default bags.
--]]

local C = LibStub('C_Everywhere')
local Spotlight = Scrap2:NewModule('Spotlight')


--[[ Hook UI ]]--

function Spotlight:OnLoad()
	self.Buttons = {}
	self:RegisterSignal('LIST_CHANGED', 'UpdateAll')
	self:RegisterSignal('LOOK_CHANGED', 'UpdateAll')

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
	local tag = Scrap2:GetTagInfo(id, location)

	local icon = self.Buttons[button] or self:CreateTextures(button)
    icon[tag.icon and 'SetTexture' or 'SetAtlas'](icon, tag.icon or tag.atlas)
	icon:SetShown(tag.stamp)

	local glow = icon.Glow
	glow:SetVertexColor(ColorMixin.GetRGBA(tag.color or PURE_RED_COLOR))
	glow:SetShown(tag.glow)
	
	if button.IconQuestTexture then
		button.IconQuestTexture:SetAlpha(tag.glow and 0 or 1)
	end
	if button.IconBorder then
		button.IconBorder:SetAlpha(tag.glow and 0 or 1)
	end
	if button.JunkIcon then
		button.JunkIcon:SetAlpha(0)
	end
end

function Spotlight:CreateTextures(button)
	local icon = button:CreateTexture(nil, 'OVERLAY')
	icon:SetPoint('TOPLEFT', 1, 0)
	icon:SetSize(16,16)

	local glow = button:CreateTexture(nil, 'OVERLAY')
	glow:SetTexture('Interface/Buttons/UI-ActionButton-Border')
	glow:SetBlendMode('ADD')
	glow:SetPoint('CENTER')
	glow:SetSize(67, 67)

	icon.Glow = glow
	self.Buttons[button] = icon
	return icon
end