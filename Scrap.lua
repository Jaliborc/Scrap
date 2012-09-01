--[[
Copyright 2008-2012 João Cardoso
Scrap is distributed under the terms of the GNU General Public License (or the Lesser GPL).
This file is part of Scrap.

Scrap is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Scrap is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Scrap. If not, see <http://www.gnu.org/licenses/>.
--]]

local Tooltip = CreateFrame('GameTooltip', 'ScrapTooltip', nil, 'GameTooltipTemplate')
local Scrap = CreateFrame('Button', 'Scrap', MerchantBuyBackItem)
local Unfit = LibStub('Unfit-1.0')
local L = Scrap_Locals


--[[ Constants ]]--

local CLASS_NAME = LOCALIZED_CLASS_NAMES_MALE[select(2, UnitClass('player'))]
local WEAPON, ARMOR, _, CONSUMABLES = GetAuctionItemClasses()
local FISHING_ROD = select(17 , GetAuctionItemSubClasses(1))

local CAN_TRADE = BIND_TRADE_TIME_REMAINING:format('.*')
local CAN_REFUND = REFUND_TIME_REMAINING:format('.*')
local MATCH_CLASS = ITEM_CLASSES_ALLOWED:format('')
local IN_SET = EQUIPMENT_SETS:format('.*')
local SLOT_SLICE = ('INVTYPE_'):len() + 1

local ACTUAL_SLOTS = {
	ROBE = 'CHEST',
	CLOAK = 'BACK',
	RANGEDRIGHT = 'RANGED',
	THROWN = 'RANGED',
	WEAPONMAINHAND = 'MAINHAND',
	WEAPONOFFHAND = 'OFFHAND',
	HOLDABLE = 'OFFHAND',
	SHIELD = 'OFFHAND',
}

BINDING_NAME_SCRAP_TOGGLE = L.ToggleJunk
BINDING_NAME_SCRAP_SELL = L.SellJunk
BINDING_HEADER_SCRAP = 'Scrap'

Scrap_Junk = Scrap_Junk or {}
Scrap_AI = Scrap_AI or {}


--[[ Locals ]]

local function GetLine(i)
	local line = _G['ScrapTooltipTextLeft'..i]
	return line and line:GetText() or ''
end

local function GetValue(level, quality)
	if quality == ITEM_QUALITY_EPIC then
		return (level + 344.36) / 106.29
	elseif quality == ITEM_QUALITY_RARE then
		return (level + 287.14) / 97.632
	else
		return (level + 292.23) / 101.18
	end
end


--[[ Events ]]--

function Scrap:Startup()
	self.SettingsUpdated = function() end
	self:SetScript('OnEvent', function(self, event) self[event](self) end)
	self:RegisterEvent('VARIABLES_LOADED')
	self:RegisterEvent('MERCHANT_SHOW')
end

function Scrap:VARIABLES_LOADED()
	setmetatable(Scrap_Junk, Scrap_BaseList)
	self.Startup, self.VARIABLES_LOADED = nil
	
	-------- TEMP FIX. REMOVE AFTER MISTS OF PANDARIA -------
	if Scrap_NotJunk then
		for item in pairs(Scrap_NotJunk) do
			Scrap_Junk[item] = false
		end
		
		Scrap_NotJunk = nil
	end
	---------------------------------------------------------
	
	if not Scrap_Tut then
		Scrap_AutoSell, Scrap_Safe = true, true
	end
	
	if not Scrap_Version then	
		Scrap_Icons = true
	end
	
	Scrap_Version = 11
end

function Scrap:MERCHANT_SHOW()
	self.MERCHANT_SHOW = nil
	
	if LoadAddOn('Scrap_Merchant') then
		self:MERCHANT_SHOW()
	else
		self:UnregisterEvent('MERCHANT_SHOW')
	end
end


--[[ Junk Public Methods ]]--

function Scrap:IsJunk(id, ...)
	if id and Scrap_Junk[id] ~= false then
		return Scrap_Junk[id] or (Scrap_AI[id] and Scrap_AI[id] > 3) or self:CheckFilters(id, ...)
	end
end

function Scrap:IterateJunk()
	local bagNumSlots, bag, slot = GetContainerNumSlots(BACKPACK_CONTAINER), BACKPACK_CONTAINER, 0
	local match, id
	
	return function()
		match = nil
		
		while not match do
			if slot < bagNumSlots then
				slot = slot + 1
			elseif bag < NUM_BAG_FRAMES then
				bag = bag + 1
				bagNumSlots = GetContainerNumSlots(bag)
				slot = 1
			else
				bag, slot = nil
				break
			end
			
			id = GetContainerItemID(bag, slot)
			match = self:IsJunk(id, bag, slot)
		end
		
		return bag, slot, id
	end
end

function Scrap:ToggleJunk(id)
	if id and self:HasPrice(id) then
		local message

		if self:IsJunk(id) then
		   	Scrap_Junk[id] = false
			message = L.Removed
		else
		   	Scrap_Junk[id] = true
			message = L.Added
	  	end

		self:Print(message, select(2, GetItemInfo(id)), 'LOOT')
  	end
end


--[[ Filters ]]--

function Scrap:CheckFilters(id, ...)
	local _, link, quality, level, minLevel, class, subClass, _, equipSlot, _, price = GetItemInfo(id)
	if price and price > 0 then
		local isGray = quality == ITEM_QUALITY_POOR
		level = level > minLevel and level or minLevel
		
		-- Equipment
		if class == ARMOR or class == WEAPON then
				
			-- "Gray" Equipment
			if isGray then
				return level > 10 or UnitLevel('player') > 20
			
			else
				local slotID = equipSlot:sub(SLOT_SLICE)
				
				-- Tabards, Shirts, Fishing Poles...
				if slotID == 'TABARD' or slotID == 'BODY' or subClass == FISHING_ROD then
					return nil
				
				-- "Green, Blue and Epic" Equipment
				elseif quality >= ITEM_QUALITY_UNCOMMON and quality <= ITEM_QUALITY_EPIC then
					local bag, slot = self:GetSlot(id, ...)
					self:LoadTooltip(link, bag, slot)
				
					if not self:BelongsToSet() and self:IsSoulbound(bag, slot) then
						local unusable = not self:IsEnchanter() and (Unfit:IsClassUnusable(subClass, equipSlot) or self:IsOtherClass())
						return unusable or self:IsLowEquip(id, subClass, slotID, level, quality)
					end
				end
			end
			
		-- "Grays"
		elseif isGray then
			return true
			
		-- Consumables
		elseif Scrap_LowConsume and class == CONSUMABLES then
			return level ~= 0 and (UnitLevel('player') - level) > 10
		end
	end
end

function Scrap:BelongsToSet()
	if CanUseEquipmentSets() then
		return GetLine(self.numLines - 1):find(IN_SET)
	end
end

function Scrap:IsSoulbound(bag, slot)
	local lastLine = GetLine(self.numLines)
	local soulbound = bag and slot and ITEM_SOULBOUND or ITEM_BIND_ON_PICKUP

	if not lastLine:find(CAN_TRADE) and not lastLine:find(CAN_REFUND) then
		for i = 2,4 do
			if GetLine(i) == soulbound then
				self.limit = i
				return true
			end
		end
	end
end

function Scrap:IsEnchanter()
    local prof1, prof2 = GetProfessions()
    return not prof1 or not prof2 or select(7, GetProfessionInfo(prof1)) == 333 or select(7, GetProfessionInfo(prof2)) == 333
end

function Scrap:IsOtherClass()
	for i = self.numLines, self.limit, -1 do
		local text = GetLine(i)
		if text:find(MATCH_CLASS) then
			return not text:find(CLASS_NAME)
		end
	end
end

function Scrap:IsLowEquip(id, subClass, slot, ...)
	if slot ~= '' and slot ~= 'TRINKET' then
		return self:HasBetterEquip(id, slot, ...)
	end
end

function Scrap:HasBetterEquip(id, slot, level, quality)
	if Scrap_LowEquip then
		local slot1, slot2 = ACTUAL_SLOTS[slot] or slot
		local value = GetValue(level, quality)
		local double
		
		if slot1 == 'WEAPON' or slot1 == '2HWEAPON' then
			if slot1 == '2HWEAPON' then
				double = true
			end
			
			slot1, slot2 = 'MAINHAND', 'OFFHAND'
		elseif slot1 == 'FINGER' then
			slot1, slot2 = 'FINGER1', 'FINGER2'
		end
		
		return self:IsBetterEquip(slot1, value) and (not slot2 or self:IsBetterEquip(slot2, value, double))
	end
end

function Scrap:IsBetterEquip(slot, value, empty)
	local item = GetInventoryItemID('player', _G['INVSLOT_'..slot])
	if item then
		local _,_, quality, level = GetItemInfo(item)
		return GetValue(level, quality) / value > 1.1
	elseif empty then
		return true
	end
end

function Scrap:HasPrice(id)
	local price = select(11, GetItemInfo(id))
	return price and price > 0
end


--[[ Data Mining ]]--

function Scrap:GetSlot(id, bag, slot)
	if bag and slot then
		return bag, slot
	elseif GetItemCount(id) > 0 then
		for bag = 0, NUM_BAG_FRAMES do
		  	 for slot = 1, GetContainerNumSlots(bag) do
		  	 	if id == GetContainerItemID(bag, slot) then
		  	 		return bag, slot
		  	 	end
			end
		end
	end
end

function Scrap:LoadTooltip(link, bag, slot)
	Tooltip:SetOwner(UIParent, 'ANCHOR_NONE')

	if bag and slot then
		if bag ~= BANK_CONTAINER then
			Tooltip:SetBagItem(bag, slot)
		else
			Tooltip:SetInventoryItem('player', BankButtonIDToInvSlotID(slot))
		end
	else
		Tooltip:SetHyperlink(link)
	end
	
	self.numLines = Tooltip:NumLines()
end


--[[ Utility ]]--

function Scrap:Print (pattern, value, channel)
 	local channel = 'CHAT_MSG_'..channel
 	for i = 1, 10 do
		local frame = _G['ChatFrame'..i]
		if frame:IsEventRegistered(channel) then
			ChatFrame_MessageEventHandler(frame, channel, pattern:format(value), nil, nil, '', nil, nil, nil, nil, nil, nil, nil, '')
		end
	end
end

function Scrap:GetID (link)
	return link and tonumber(link:match('item:(%d+)'))
end

Scrap:Startup()