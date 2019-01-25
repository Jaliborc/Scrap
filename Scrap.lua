--[[
Copyright 2008-2018 João Cardoso
Scrap is distributed under the terms of the GNU General Public License (Version 3).
As a special exception, the copyright holders of this addon do not give permission to
redistribute and/or modify it.

This addon is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with the addon. If not, see <http://www.gnu.org/licenses/gpl-3.0.txt>.

This file is part of Scrap.
--]]

local Tooltip = CreateFrame('GameTooltip', 'ScrapTooltip', nil, 'GameTooltipTemplate')
local Scrap = CreateFrame('Button', 'Scrap', MerchantBuyBackItem)
local Unfit = LibStub('Unfit-1.0')
local L = Scrap_Locals


--[[ Constants ]]--

local CLASS_NAME = LOCALIZED_CLASS_NAMES_MALE[select(2, UnitClass('player'))]
local WEAPON, ARMOR, CONSUMABLES = LE_ITEM_CLASS_WEAPON, LE_ITEM_CLASS_ARMOR, LE_ITEM_CLASS_CONSUMABLE
local FISHING_POLE = LE_ITEM_WEAPON_FISHINGPOLE

local CAN_TRADE = BIND_TRADE_TIME_REMAINING:format('.*')
local CAN_REFUND = REFUND_TIME_REMAINING:format('.*')
local MATCH_CLASS = ITEM_CLASSES_ALLOWED:format('')
local IN_SET = EQUIPMENT_SETS:format('.*')
local SLOT_SLICE = ('INVTYPE_'):len() + 1

local ACTUAL_SLOTS = {
	INVTYPE_ROBE = 'INVTYPE_CHEST',
	INVTYPE_CLOAK = 'INVTYPE_BACK',
	INVTYPE_RANGEDRIGHT = 'INVTYPE_RANGED',
	INVTYPE_THROWN = 'INVTYPE_RANGED',
	INVTYPE_WEAPONMAINHAND = 'INVTYPE_MAINHAND',
	INVTYPE_WEAPONOFFHAND = 'INVTYPE_OFFHAND',
	INVTYPE_HOLDABLE = 'INVTYPE_OFFHAND',
	INVTYPE_SHIELD = 'INVTYPE_OFFHAND',
}

BINDING_NAME_SCRAP_TOGGLE = L.ToggleJunk
BINDING_NAME_SCRAP_SELL = L.SellJunk
BINDING_HEADER_SCRAP = 'Scrap'

Scrap_SharedJunk = Scrap_SharedJunk or {}
Scrap_Junk = Scrap_Junk or {}
Scrap_AI = Scrap_AI or {}


--[[ Locals ]]

local function GetLine(i)
	local line = _G['ScrapTooltipTextLeft'..i]
	return line and line:GetText() or ''
end

local function GetValue(level, quality)
	if quality == LE_LE_ITEM_QUALITY_EPIC then
		return (level + 344.36) / 106.29
	elseif quality == LE_ITEM_QUALITY_RARE then
		return (level + 287.14) / 97.632
	else
		return (level + 292.23) / 101.18
	end
end


--[[ Events ]]--

function Scrap:Startup()
	self:SetScript('OnEvent', function(self, event) self[event](self) end)
	self:RegisterEvent('VARIABLES_LOADED')
	self:RegisterEvent('MERCHANT_SHOW')
end

function Scrap:SettingsUpdated()
	self.Junk = setmetatable(Scrap_ShareList and Scrap_SharedJunk or Scrap_Junk, Scrap_BaseList)
end

function Scrap:VARIABLES_LOADED()
	self.Startup, self.VARIABLES_LOADED = nil
	self:SettingsUpdated()

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
	if id and self.Junk[id] ~= false then
		return self.Junk[id] or (Scrap_Learn and Scrap_AI[id] and Scrap_AI[id] > 2) or self:CheckFilters(id, ...)
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
	local message

	if self:IsJunk(id) then
	   	self.Junk[id] = false
		message = L.Removed
	else
	   	self.Junk[id] = true
		message = L.Added
  	end

	self:Print(message, select(2, GetItemInfo(id)), 'LOOT')
end


--[[ Filters ]]--

function Scrap:CheckFilters(...)
	local _, link, quality, level, minLevel, _,_,_, equipSlot, _, value, class, subclass = GetItemInfo(...)
	local level = max(level or 0, minLevel or 0)
	local gray = quality == LE_ITEM_QUALITY_POOR
	local value = value and value > 0

	local equipment = class == ARMOR or class == WEAPON
	local consumable = class == CONSUMABLES

	if gray then
		return not equipment or self:HighLevel(level)

	elseif equipment then
		if value and self:StandardQuality(quality) and self:CombatItem(class, subclass, equipSlot) then
			local bag, slot = self:GetSlot(...)
			self:LoadTooltip(link, bag, slot)

			if not self:BelongsToSet() and self:IsSoulbound(bag, slot) then
				local unusable = Scrap_Unusable and (Unfit:IsClassUnusable(class, subclass, equipSlot) or self:IsOtherClass())
				return unusable or self:IsLowEquip(equipSlot, level, quality)
			end
		end

	elseif consumable then
		return value and Scrap_LowConsume and quality < LE_ITEM_QUALITY_RARE and self:LowLevel(level)
	end
end

function Scrap:HighLevel(level)
	return level > 10 or UnitLevel('player') > 8
end

function Scrap:LowLevel(level)
	return level ~= 0 and level < (UnitLevel('player') - 10)
end

function Scrap:StandardQuality(quality)
	return quality >= LE_ITEM_QUALITY_UNCOMMON and quality <= LE_ITEM_QUALITY_EPIC
end

function Scrap:CombatItem(class, subclass, slot)
	return slot ~= 'INVTYPE_TABARD' and slot ~= 'INVTYPE_BODY' and subclass ~= FISHING_POLE
end

function Scrap:IsLowEquip(slot, level, quality)
	if Scrap_LowEquip and slot ~= ''  then
		local slot1, slot2 = ACTUAL_SLOTS[slot] or slot
		local value = GetValue(level or 0, quality)
		local double

		if slot1 == 'INVTYPE_WEAPON' or slot1 == 'INVTYPE_2HWEAPON' then
			if slot1 == 'INVTYPE_2HWEAPON' then
				double = true
			end

			slot1, slot2 = 'INVTYPE_MAINHAND', 'INVTYPE_OFFHAND'
		elseif slot1 == 'INVTYPE_FINGER' then
			slot1, slot2 = 'INVTYPE_FINGER1', 'INVTYPE_FINGER2'
		end

		return self:IsBetterEquip(slot1, value) and (not slot2 or self:IsBetterEquip(slot2, value, double))
	end
end

function Scrap:IsBetterEquip(slot, value, empty)
	local item = GetInventoryItemID('player', slot)
	if item then
		local _,_, quality, level = GetItemInfo(item)
		return GetValue(level or 0, quality) / value > 1.1
	elseif empty then
		return true
	end
end


--[[ Data Retrieval ]]--

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

function Scrap:BelongsToSet()
	return C_EquipmentSet.CanUseEquipmentSets() and GetLine(self.numLines - 1):find(IN_SET)
end

function Scrap:IsSoulbound(bag, slot)
	local lastLine = GetLine(self.numLines)
	local soulbound = bag and slot and ITEM_SOULBOUND or ITEM_BIND_ON_PICKUP

	if not lastLine:find(CAN_TRADE) and not lastLine:find(CAN_REFUND) then
		for i = 2,7 do
			if GetLine(i) == soulbound then
				self.limit = i
				return true
			end
		end
	end
end

function Scrap:IsOtherClass()
	for i = self.numLines, self.limit, -1 do
		local text = GetLine(i)
		if text:find(MATCH_CLASS) then
			return not text:find(CLASS_NAME)
		end
	end
end


--[[ Utility ]]--

function Scrap:PrintMoney(pattern, value)
	self:Print(pattern, GetMoneyString(value, true), 'MONEY')
end

function Scrap:Print (pattern, value, channel)
 	local channel = 'CHAT_MSG_'..channel
 	for i = 1, 10 do
		local frame = _G['ChatFrame'..i]
		if frame:IsEventRegistered(channel) then
			ChatFrame_MessageEventHandler(frame, channel, pattern:format(value), '', nil, '')
		end
	end
end

function Scrap:GetID (link)
	return link and tonumber(link:match('item:(%d+)'))
end

Scrap:Startup()
