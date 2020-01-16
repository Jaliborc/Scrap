--[[
Copyright 2008-2020 João Cardoso
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

local Scrap = LibStub('WildAddon-1.0'):NewAddon(...)
local L = LibStub('AceLocale-3.0'):GetLocale('Scrap')
local Unfit = LibStub('Unfit-1.0')

local CLASS_NAME = LOCALIZED_CLASS_NAMES_MALE[select(2, UnitClass('player'))]
local WEAPON, ARMOR, CONSUMABLES = LE_ITEM_CLASS_WEAPON, LE_ITEM_CLASS_ARMOR, LE_ITEM_CLASS_CONSUMABLE
local FISHING_POLE = LE_ITEM_WEAPON_FISHINGPOLE

local CAN_TRADE = BIND_TRADE_TIME_REMAINING:format('.*')
local CAN_REFUND = REFUND_TIME_REMAINING:format('.*')
local MATCH_CLASS = ITEM_CLASSES_ALLOWED:format('')
local IN_SET = EQUIPMENT_SETS:format('.*')

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

BINDING_NAME_SCRAP_TOGGLE = L.ToggleMousehover
BINDING_NAME_SCRAP_DESTROY = L.DestroyJunk
BINDING_NAME_SCRAP_SELL = L.SellJunk
BINDING_HEADER_SCRAP = 'Scrap'


--[[ Startup ]]--

function Scrap:OnEnable()
	self.tip = CreateFrame('GameTooltip', 'ScrapTooltip', nil, 'GameTooltipTemplate')
	self:RegisterEvent('MERCHANT_SHOW', function() LoadAddOn('Scrap_Merchant') end)
	self:RegisterSignal('SETS_CHANGED', 'OnSettings')
	self:OnSettings()

	CreateFrame('Frame', nil, InterfaceOptionsFrame):SetScript('OnShow', function()
		LoadAddOn('Scrap_Config')
	end)
end

function Scrap:OnSettings()
	Scrap_Sets = Scrap_Sets or {list = {}, sell = true, repair = true, safe = true, destroy = true, glow = true, icons = true}
	Scrap_CharSets = Scrap_CharSets or {list = {}, ml = {}}

	self.sets, self.charsets = Scrap_Sets, Scrap_CharSets
	self.junk = setmetatable(self.charsets.share and self.sets.list or self.charsets.list, self.baseList)

	if Scrap_Version then -- remove in a couple of versions
		self.sets.list = Scrap_SharedJunk
		self.sets.sell = Scrap_Sell
		self.sets.repair = Scrap_AutoRepair
		self.sets.guild = Scrap_GuildRepair
		self.sets.learn = Scrap_Learn
		self.sets.safe = Scrap_Safe
		self.sets.icons = Scrap_Icons
		self.sets.glow = Scrap_Glow
		self.sets.tutorial = Scrap_Tut

		self.charsets.list = Scrap_Junk
		self.charsets.ml = Scrap_AI
		self.charsets.equip = Scrap_LowEquip
		self.charsets.consumable = Scrap_LowConsume
		self.charsets.unusable = Scrap_Unusable
		self.charsets.share = Scrap_ShareList
	end

	self:SendSignal('LIST_CHANGED')
end


--[[ Public API ]]--

function Scrap:IsJunk(id, ...)
	if id and self.junk and self.junk[id] ~= false then
		return self.junk[id] or (self.sets.learn and self.charsets.ml[id] and self.charsets.ml[id] >= 1) or self:IsFiltered(id, ...)
	end
end

function Scrap:ToggleJunk(id)
	local junk = self:IsJunk(id)

	self.junk[id] = not junk
	self:Print(junk and L.Removed or L.Added, select(2, GetItemInfo(id)), 'LOOT')
	self:SendSignal('LIST_CHANGED', id)
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

function Scrap:DestroyJunk()
	LibStub('Sushi-3.1').Popup {
		id = 'DeleteScrap',
		text = L.ConfirmDelete, button1 = OKAY, button2 = CANCEL,
		hideOnEscape = 1, showAlert = 1, whileDead = 1,
		OnAccept = function()
			for bag, slot in self:IterateJunk() do
				PickupContainerItem(bag, slot)
				DeleteCursorItem()
			end
		end
	}
end


--[[ Filters ]]--

function Scrap:IsFiltered(...)
	local _, link, quality, _,_,_,_,_, slot, _, value, class, subclass = GetItemInfo(...)
	local level = GetDetailedItemLevelInfo(...) or 0

	if not value or value == 0 then
		return

	elseif class == ARMOR or class == WEAPON then
		if value and self:IsCombatItem(class, subclass, slot) then
			if self:IsGray(quality) then
				return (slot ~= 'INVTYPE_SHOULDER' and level > 15) or level > 25
			elseif self:IsStandardQuality(quality) then
				local bag, position = self:ScanBagSlot(...)
				self:LoadTip(link, bag, position)

				if not self:BelongsToSet() and self:IsSoulbound(bag, position) then
					local unusable = self.charsets.unusable and (Unfit:IsClassUnusable(class, subclass, slot) or self:IsOtherClass())
					return unusable or self:IsLowEquip(slot, level, quality)
				end
			end
		end

	elseif self:IsGray(quality) then
		return true
	elseif class == CONSUMABLES then
		return self.charsets.consumable and quality < LE_ITEM_QUALITY_RARE and self:IsLowLevel(level)
	end
end

function Scrap:IsGray(quality)
	return quality == LE_ITEM_QUALITY_POOR
end

function Scrap:IsLowLevel(level)
	return level ~= 0 and level < (UnitLevel('player') - 10)
end

function Scrap:IsStandardQuality(quality)
	return quality >= LE_ITEM_QUALITY_UNCOMMON and quality <= LE_ITEM_QUALITY_EPIC
end

function Scrap:IsCombatItem(class, subclass, slot)
	return slot ~= 'INVTYPE_TABARD' and slot ~= 'INVTYPE_BODY' and subclass ~= FISHING_POLE
end

function Scrap:IsLowEquip(slot, level, quality)
	if self.charsets.equip and slot ~= ''  then
		local slot1, slot2 = gsub(ACTUAL_SLOTS[slot] or slot, 'INVTYPE', 'INVSLOT')
		local value = self:GetEquipValue(level or 0, quality)
		local double

		if slot1 == 'INVSLOT_WEAPON' or slot1 == 'INVSLOT_2HWEAPON' then
			if slot1 == 'INVSLOT_2HWEAPON' then
				double = true
			end

			slot1, slot2 = 'INVSLOT_MAINHAND', 'INVSLOT_OFFHAND'
		elseif slot1 == 'INVSLOT_FINGER' then
			slot1, slot2 = 'INVSLOT_FINGER1', 'INVSLOT_FINGER2'
		end

		return self:IsBetterEquip(slot1, value) and (not slot2 or self:IsBetterEquip(slot2, value, double))
	end
end

function Scrap:IsBetterEquip(slot, value, empty)
	local item = GetInventoryItemID('player', _G[slot])
	if item then
		local level = GetDetailedItemLevelInfo(item) or 0
		local _,_, quality = GetItemInfo(item)
		return self:GetEquipValue(level, quality) / value > 1.1
	elseif empty then
		return true
	end
end

function Scrap:GetEquipValue(level, quality)
	if quality == LE_LE_ITEM_QUALITY_EPIC then
		return (level + 344.36) / 106.29
	elseif quality == LE_ITEM_QUALITY_RARE then
		return (level + 287.14) / 97.632
	else
		return (level + 292.23) / 101.18
	end
end


--[[ Data Retrieval ]]--

function Scrap:IsSoulbound(bag, slot)
	local lastLine = self:ScanLine(self.numLines)
	local soulbound = bag and slot and ITEM_SOULBOUND or ITEM_BIND_ON_PICKUP

	if not lastLine:find(CAN_TRADE) and not lastLine:find(CAN_REFUND) then
		for i = 2,7 do
			if self:ScanLine(i) == soulbound then
				self.limit = i
				return true
			end
		end
	end
end

function Scrap:IsOtherClass()
	for i = self.numLines, self.limit, -1 do
		local text = self:ScanLine(i)
		if text:find(MATCH_CLASS) then
			return not text:find(CLASS_NAME)
		end
	end
end

function Scrap:BelongsToSet()
	return C_EquipmentSet and C_EquipmentSet.CanUseEquipmentSets() and self:ScanLine(self.numLines - 1):find(IN_SET)
end

function Scrap:LoadTip(link, bag, slot)
	self.tip:SetOwner(UIParent, 'ANCHOR_NONE')

	if bag and slot then
		if bag ~= BANK_CONTAINER then
			self.tip:SetBagItem(bag, slot)
		else
			self.tip:SetInventoryItem('player', BankButtonIDToInvSlotID(slot))
		end
	else
		self.tip:SetHyperlink(link)
	end

	self.limit = 2
	self.numLines = self.tip:NumLines()
end

function Scrap:ScanLine(i)
	local line = _G[self.tip:GetName() .. 'TextLeft' .. i]
	return line and line:GetText() or ''
end

function Scrap:ScanBagSlot(id, bag, slot)
	if bag and slot then
		return bag, slot
	elseif GetItemCount(id) > 0 then
		for bag = BACKPACK_CONTAINER, NUM_BAG_FRAMES do
		  	 for slot = 1, GetContainerNumSlots(bag) do
		  	 	if id == GetContainerItemID(bag, slot) then
		  	 		return bag, slot
		  	 	end
			end
		end
	end
end


--[[ Chat ]]--

function Scrap:PrintMoney(pattern, value)
	self:Print(pattern, GetMoneyString(value, true), 'MONEY')
end

function Scrap:Print(pattern, value, channel)
	local i = 1
	local frame = _G['ChatFrame' .. i]
 	local channel = 'CHAT_MSG_' .. channel

	while frame do
		if frame:IsEventRegistered(channel) then
			ChatFrame_MessageEventHandler(frame, channel, pattern:format(value), '', nil, '')
		end

		i = i + 1
		frame = _G['ChatFrame' .. i]
	end
end
