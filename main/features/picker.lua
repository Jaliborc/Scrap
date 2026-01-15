--[[
	Copyright 2008-2025 João Cardoso, All Rights Reserved
	Context menu for changing an item tag anywhere.
--]]

local Picker = Scrap2:NewModule('Picker')
local C = LibStub('C_Everywhere')

function Picker:Open()
	local id = GameTooltip:IsVisible() and self:GetTooltipItem()
	if id then
		MenuUtil.CreateContextMenu(UIParent, function(_, drop)
			drop:SetTag('Scrap2_Picker')
			drop:CreateTitle(Scrap2:GetItemName(id))

			for i, tag in pairs(Scrap2.Tags) do
				drop:CreateRadio(tag.name .. Scrap2.MENU_SUFFIX, function() return Scrap2:GetTag(id) == i end, function() Scrap2:SetTag(id, i) end)
					:AddInitializer(self:Initializer(tag))
			end
		end)
	end
end

function Picker:Initializer(tag)
	return function(button)
		local icon = button:AttachTexture()
		icon[tag.icon and 'SetTexture' or 'SetAtlas'](icon, tag.icon or tag.atlas)
		icon:SetPoint('RIGHT')
		icon:SetSize(18, 18)
	end
end

function Picker:GetTooltipItem()
	if GameTooltip.GetPrimaryTooltipData then -- GameTooltip:GetItem() is bugged on retail, avoid at all costs
		local data = GameTooltip:GetPrimaryTooltipData()
		return data and ((data.guid and data.guid:find('^Item')) or (data.hyperlink and data.hyperlink:find('Hitem'))) and tonumber(data.id)
	end
	local link = select(2, GameTooltip:GetItem())
	return link and tonumber(link:match('item:(%d+)'))
end