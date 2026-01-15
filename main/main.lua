--[[
	Copyright 2008-2025 João Cardoso, All Rights Reserved
	Addon main API.
--]]

local _, Addon = ...
local C = LibStub('C_Everywhere')
local Scrap2 = LibStub('WildAddon-1.1'):NewAddon('Scrap2', Addon, 'StaleCheck-1.0', 'MutexDelay-1.0')

Scrap2.MENU_SUFFIX = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and '   ' or ''
Scrap2.NUM_BAGS = NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS


--[[ Startup ]]--

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

function Scrap2:ToggleWindow()
	if C.AddOns.LoadAddOn('Scrap_Window') then
		self.Frame:Toggle()
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


--[[ Inventory ]]--

function Scrap2:UseItems(tag, done)
	local tag = self.Tags[tag]
	local count = 0

	for bag, slot, item in self:IterateInventory(tag.id) do
		if count < tag.limit then
			C.Container.UseContainerItem(bag, slot, nil, tag.type)
			count = count + 1
		end
	end

	if not tag.safe and count >= tag.limit then
		self:Delay(0.05, 'UseItems', tag.id, done)
	elseif done then
		done()
	end
end

function Scrap2:PreviewItems(tag)
	local total, price = 0, 0
	local qualities = {}

	for bag, slot, item in self:IterateInventory(tag) do
		if item.quality then
			total = total + item.stackCount
			price = price + item.stackCount * (select(11, C.Item.GetItemInfo(item.itemID)) or 0)
			qualities[item.quality] = (qualities[item.quality] or 0) + item.stackCount
		end
	end

	return {total = total, price = price, qualities = qualities}
end

function Scrap2:IterateInventory(tag)
	local numSlots = C.Container.GetContainerNumSlots(BACKPACK_CONTAINER)
	local bag, slot = BACKPACK_CONTAINER, 1

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
			if item and not item.isLocked and self:GetTag(item.itemID, bag, slot) == tag then
				return bag, slot, item
			end
		end
	end
end


--[[ Utils ]]--

function Scrap2:GetItemName(id)
	local name, _, quality = C.Item.GetItemInfo(id)
	return name and format('|cnIQ%s:%s|r', quality, name)
end