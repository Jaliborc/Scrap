--[[
	Copyright 2008-2025 João Cardoso, All Rights Reserved
	Panel for list visualization and configuration.
--]]

local Visualizer = Scrap2:NewModule('Visualizer', Scrap2Visualizer)

function Visualizer:OnLoad()
	local title = self.TitleText or self.TitleContainer.TitleText
	title:SetText('Scrap2')

	local portrait = self.portrait or self.PortraitContainer.portrait
	portrait:SetTexture('Interface/Addons/Scrap/art/scrap-big')

	local backdrop = portrait:GetParent():CreateTexture(nil, 'BORDER')
	backdrop:SetColorTexture(0, 0, 0)
	backdrop:SetAllPoints(portrait)

	local mask = portrait:GetParent():CreateMaskTexture()
	mask:SetTexture('Interface/CharacterFrame/TempPortraitAlphaMask')
	mask:SetAllPoints(backdrop)
	backdrop:AddMaskTexture(mask)
	portrait:AddMaskTexture(mask)

	self.OptionsWheel.tooltipTitle = 'General Options'
	self.TagOptions:SetText('More')
	self:SetSize(702, 534)

	for x = 0,2 do
		for y = 0,7 do
			--[[local test = self.RightInset:CreateTexture()
			test:SetAtlas('transmog-wardrobe-border-collected', true)
			test:SetRotation(math.pi/2)
			test:SetPoint('TOPLEFT', (test:GetHeight()+5)*x+50, -(test:GetWidth()+5)*y)
			test:SetTextureSliceMargins(10, 10, 10, 10)
			test:SetScale(0.7)
			test:SetDesaturated(true)]]--

			local test = CreateFrame('Button', nil, self.RightInset, 'Scrap2ItemButtonTemplate')
			test:SetPoint('TOPLEFT', 10+182*x, -15 - y*55)
			test.Icon:SetTexture(GetRandomArrayEntry({133970, 646324, 135157, 134937, 628647, 237395}))
			test:SetText('Heavy Windwool Bandage')
		end
	end

	for i, tag in pairs(Scrap2.Tags) do
		local checked = i == 1
		local b = CreateFrame('Button', nil, self.LeftInset, 'Scrap2TagButtonTemplate')
		b:SetNormalFontObject(checked and 'GameFontHighlightLeft' or 'GameFontNormalLeft')
		b:SetPoint('TOP', -1, -32*i-5)
		b:SetText(tag.name)

		--b.Border:SetAtlas('CovenantChoice-Offering-Ability-Ring-Necrolord')
		b.IconHighlight[tag.hasAtlas and 'SetAtlas' or 'SetTexture'](b.IconHighlight, tag.icon)
		b.Icon[tag.hasAtlas and 'SetAtlas' or 'SetTexture'](b.Icon, tag.icon)
		b.Icon:SetScale(tag.iconScale)
	end
	
	RegisterUIPanel(self, {area = 'left', pushable = 3,	whileDead = 1})
	C_Timer.After(1, function()
		ShowUIPanel(self)
	end)
end