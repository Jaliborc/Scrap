--[[
Copyright 2008-2023 João Cardoso
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
local C = LibStub('C_Everywhere').Container
local Search = LibStub('ItemSearch-1.3')

local NUM_BAGS = NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS
local WEAPON, ARMOR, CONSUMABLES = Enum.ItemClass.Weapon, Enum.ItemClass.Armor, Enum.ItemClass.Consumable
local FISHING_POLE = Enum.ItemWeaponSubclass.Fishingpole

local POOR, COMMON, UNCOMMON, RARE, EPIC = 0,1,2,3,4
local ACTUAL_SLOTS = {
	ROBE = 'CHEST', CLOAK = 'BACK',
	RANGEDRIGHT = 'RANGED', THROWN = 'RANGED', RELIC = 'RANGED',
	WEAPONMAINHAND = 'MAINHAND', WEAPONOFFHAND = 'OFFHAND', HOLDABLE = 'OFFHAND', SHIELD = 'OFFHAND'}

local SHOULDER_BREAKPOINT = LE_EXPANSION_LEVEL_CURRENT > 2 and 15 or 25
local INTRO_BREAKPOINT = LE_EXPANSION_LEVEL_CURRENT > 2 and 5 or 15

BINDING_NAME_SCRAP_TOGGLE = L.ToggleMousehover
BINDING_NAME_SCRAP_DESTROY = L.DestroyJunk
BINDING_NAME_SCRAP_SELL = L.SellJunk
BINDING_HEADER_SCRAP = 'Scrap'


--[[ Startup ]]--

function Scrap:OnEnable()
	self.Tip = CreateFrame('GameTooltip', 'ScrapTooltip', nil, 'GameTooltipTemplate')
	self:RegisterEvent('MERCHANT_SHOW', function() LoadAddOn('Scrap_Merchant'); self:SendSignal('MERCHANT_SHOW') end)
	self:RegisterSignal('SETS_CHANGED', 'OnSettings')
	self:OnSettings()

	CreateFrame('Frame', nil, InterfaceOptionsFrame or SettingsPanel):SetScript('OnShow', function()
		LoadAddOn('Scrap_Config')
	end)
end

function Scrap:OnSettings()
	Scrap_Sets = Scrap_Sets or {list = {}, sell = true, repair = true, safe = true, destroy = true, glow = true, icons = true}
	Scrap_CharSets = Scrap_CharSets or {list = {}, auto = {}}

	self.sets, self.charsets = Scrap_Sets, Scrap_CharSets
	self.junk = setmetatable(self.charsets.share and self.sets.list or self.charsets.list, self.BaseList)

	-- removes deprecated data. keep until next major game update
	self.charsets.ml = nil
	self.charsets.auto = self.charsets.auto or {}
	--

	self:SendSignal('LIST_CHANGED')
end


--[[ Public API ]]--

function Scrap:IsJunk(id, ...)
	if id and self.junk and self.junk[id] ~= false then
		return self.junk[id] or (self.sets.learn and (self.charsets.auto[id] or 0) > .5) or self:IsFiltered(id, ...)
	end
end

function Scrap:ToggleJunk(id)
	local junk = self:IsJunk(id)

	self.junk[id] = not junk
	self:Print(junk and L.Removed or L.Added, select(2, GetItemInfo(id)), 'LOOT')
	self:SendSignal('LIST_CHANGED', id)
end

function Scrap:IterateJunk()
	local numSlots = C.GetContainerNumSlots(BACKPACK_CONTAINER)
	local bag, slot = BACKPACK_CONTAINER, 0

	return function()
		while true do
			if slot < numSlots then
				slot = slot + 1
			elseif bag < NUM_BAGS then
				bag, slot = bag + 1, 1
				numSlots = C.GetContainerNumSlots(bag)
			else
				return
			end

			local id = C.GetContainerItemID(bag, slot)
			if self:IsJunk(id, bag, slot) then
				return bag, slot, id
			end
		end
	end
end

function Scrap:DestroyJunk()
	LibStub('Sushi-3.1').Popup {
		id = 'DeleteScrap',
		text = L.ConfirmDelete, button1 = OKAY, button2 = CANCEL,
		hideOnEscape = 1, showAlert = 1, whileDead = 1,
		OnAccept = function()
			for bag, slot in self:IterateJunk() do
				C.PickupContainerItem(bag, slot)
				DeleteCursorItem()
			end
		end
	}
end


--[[ Filters ]]--

function Scrap:IsFiltered(id, ...)
	local location = self:GuessLocation(id, ...)
	local _, link, quality, level,_,_,_,_, slot, _, value, class, subclass = GetItemInfo(id)
	local level = location and C_Item.GetCurrentItemLevel(location) or level or 0

	if not value or value == 0 then
		return

	elseif class == ARMOR or class == WEAPON then
		if value and slot ~= 'INVTYPE_TABARD' and slot ~= 'INVTYPE_BODY' and subclass ~= FISHING_POLE then
			if quality == POOR then
				return (slot ~= 'INVTYPE_SHOULDER' and level > INTRO_BREAKPOINT) or level > SHOULDER_BREAKPOINT
			elseif quality >= UNCOMMON and quality <= EPIC and location and C_Item.IsBound(location) then
				if IsEquippableItem(id) and not Search:BelongsToSet(id) then
					return self:IsLowEquip(slot, level) or self.charsets.unusable and Search:IsUnusable(id)
				end
			end
		end

	elseif quality == POOR then
		return true
	elseif class == CONSUMABLES then
		return self.charsets.consumable and quality < RARE and self:IsLowConsumable(level)
	end
end

function Scrap:IsLowEquip(slot, level)
	if self.charsets.equip and slot ~= ''  then
		local slot1 = slot:sub(9)
		local slot2, double

		if slot1 == 'WEAPON' or slot1 == '2HWEAPON' then
			if slot1 == '2HWEAPON' then
				double = true
			end

			slot1, slot2 = 'MAINHAND', 'OFFHAND'
		elseif slot1 == 'FINGER' then
			slot1, slot2 = 'FINGER1', 'FINGER2'
		elseif slot1 == 'TRINKET' then
			slot1, slot2 = 'TRINKET1', 'TRINKET2'
		else
			slot1 = ACTUAL_SLOTS[slot1] or slot1
		end

		return self:IsBetterEquip(slot1, level) and (not slot2 or self:IsBetterEquip(slot2, level, double))
	end
end

function Scrap:IsBetterEquip(slot, level, canEmpty)
	local item = ItemLocation:CreateFromEquipmentSlot(_G['INVSLOT_' .. slot])
	if C_Item.DoesItemExist(item) then
		return (C_Item.GetCurrentItemLevel(item) or 0) >= (level * 1.3)
	end
	return canEmpty
end

function Scrap:IsLowConsumable(level)
	return level > 1 and (level * 1.3) < UnitLevel('player')
end


--[[ Guessing ]]--

function Scrap:GuessLocation(...)
	local bag, slot = self:GuessBagSlot(...)
	if bag and slot then
		local location = ItemLocation:CreateFromBagAndSlot(bag, slot)
		return C_Item.DoesItemExist(location) and location
	end
end

function Scrap:GuessBagSlot(id, bag, slot)
	if bag and slot then
		return bag, slot
	elseif GetItemCount(id) > 0 then
		for bag = BACKPACK_CONTAINER, NUM_BAGS do
		  	 for slot = 1, C.GetContainerNumSlots(bag) do
		  	 	if id == C.GetContainerItemID(bag, slot) then
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
