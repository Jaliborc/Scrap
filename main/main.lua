--[[
	Copyright 2008-2025 João Cardoso, All Rights Reserved
	Addon main API.
--]]

local _, Addon = ...
local C = LibStub('C_Everywhere')
local Scrap2 = LibStub('WildAddon-1.1'):NewAddon('Scrap2', Addon, 'StaleCheck-1.0')

Scrap2.MENU_SUFFIX = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and '   ' or ''
Scrap2.NUM_BAGS = NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS

function Scrap2:OnLoad()
	SlashCmdList.Scrap = function() self:ToggleWindow() end
	SLASH_Scrap1 = '/scrap'
	SLASH_Scrap2 = '/scrap2'

	if AddonCompartmentFrame then
		AddonCompartmentFrame:RegisterAddon {
			text = 'Scrap2', keepShownOnClick = true, notCheckable = true,
			icon = 'Interface/Addons/Scrap/art/scrap-small',
			func = SlashCmdList.Scrap
		}
	end
end


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

function Scrap2:UseItems(tag)
	local tag = self.Tags[tag]
	local used = 0

	for bag, slot, item in self:IterateInventory(tag.id) do
		if not item.isLocked and used < (tag.limit or math.huge) then
			C.Container.UseContainerItem(bag, slot, nil, tag.type)
			used = used + 1
		end
	end
end

function Scrap2:IterateInventory(tag)
	local numSlots = C.Container.GetContainerNumSlots(BACKPACK_CONTAINER)
	local bag, slot = BACKPACK_CONTAINER, 0

	return function()
		while true do
			if slot < numSlots then
				slot = slot + 1
			elseif bag < self.NUM_BAGS then
				bag, slot = bag + 1, 1
				numSlots = C.Container.GetContainerNumSlots(bag)
			else
				return
			end
			
			local item = C.Container.GetContainerItemInfo(bag, slot)
			if item and self:GetTag(item.itemID, bag, slot) == tag then
				return bag, slot, item
			end
		end
	end
end


--[[ UI Essentials ]]--

function Scrap2:ToggleWindow()
	if C.AddOns.LoadAddOn('Scrap_Window') then
		self.Frame:Toggle()
	end
end

function Scrap2:TagMenu()
	local id = GameTooltip:IsVisible() and self:GetTooltipItem()
	if id then
		MenuUtil.CreateContextMenu(UIParent, function(_, drop)
			drop:SetTag('Scrap2_TagMenu')
			drop:CreateTitle(self:GetItemName(id))

			for i, tag in pairs(Scrap2.Tags) do
				drop:CreateRadio(tag.name .. self.MENU_SUFFIX, function() return self:GetTag(id) == i end, function() self:SetTag(id, i) end)
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
	return name and format('|cnIQ%s:%s|r', quality, name)
end

function Scrap2:GetTooltipItem()
	if GameTooltip.GetPrimaryTooltipData then -- GameTooltip:GetItem() is bugged on retail, avoid at all costs
		local data = GameTooltip:GetPrimaryTooltipData()
		return data and ((data.guid and data.guid:find('^Item')) or (data.hyperlink and data.hyperlink:find('Hitem'))) and tonumber(data.id)
	end
	local link = select(2, GameTooltip:GetItem())
	return link and tonumber(link:match('item:(%d+)'))
end