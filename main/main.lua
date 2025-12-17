--[[
	Copyright 2008-2025 João Cardoso, All Rights Reserved
	Addon main API.
--]]

local _, Addon = ...
local C = LibStub('C_Everywhere')
local Scrap2 = LibStub('WildAddon-1.1'):NewAddon('Scrap2', Addon, 'StaleCheck-1.0')


--[[ Tagging ]]--

function Scrap2:SetTag(id, tag)
	self.List[id] = tag
	self:SendSignal('LIST_CHANGED')
end

function Scrap2:GetTag(id, bag, slot)
	if id then
		local tagID = self.List[id]
		if tagID then
			return tagID
		end
	end

	return 0
end

function Scrap2:GetTagInfo(...)
	return self.Tags[self:GetTag(...)]
end


--[[ UI ]]--

function Scrap2:TagMenu()
	local data = GameTooltip:IsVisible() and GameTooltip:GetPrimaryTooltipData() -- GameTooltip:GetItem() is bugged
	if data and data.id and ((data.guid and data.guid:find('^Item')) or (data.hyperlink and data.hyperlink:find('Hitem'))) then
		MenuUtil.CreateContextMenu(UIParent, function(_, drop)
			drop:SetTag('Scrap2_TagMenu')
			drop:CreateTitle(self:GetItemName(data.id))

			for i, tag in pairs(Scrap2.Tags) do
				drop:CreateRadio(tag.name, function() return self:GetTag(data.id) == i end, function() self:SetTag(data.id, i) end)
					:AddInitializer(self:TagInitializer(tag))
			end
		end)
	end
end

function Scrap2:TagInitializer(tag)
	return function(button)
		local icon = button:AttachTexture()
		icon[tag.icon and 'SetTexture' or 'SetAtlas'](icon, tag.icon or tag.atlas)
		icon:SetPoint('RIGHT')
		icon:SetSize(18, 18)
	end
end

function Scrap2:GetItemName(id)
	local name, _, quality = C.Item.GetItemInfo(id)
	return format('|cnIQ%s:%s|r', quality, name)
end