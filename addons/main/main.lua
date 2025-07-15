--[[
Copyright 2008-2025 João Cardoso
All Rights Reserved
--]]

local ADDON, Addon = ...
local Scrap = LibStub('WildAddon-1.1'):NewAddon(ADDON, Addon, 'StaleCheck-1.0')

local Search = LibStub('ItemSearch-1.3')
local L = LibStub('AceLocale-3.0'):GetLocale('Scrap')
local C = LibStub('C_Everywhere')

local NUM_BAGS = NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS
local WEAPON, ARMOR, CONSUMABLES, MISC = Enum.ItemClass.Weapon, Enum.ItemClass.Armor, Enum.ItemClass.Consumable, Enum.ItemClass.Miscellaneous
local COMPANION, MOUNT = Enum.ItemMiscellaneousSubclass.CompanionPet, Enum.ItemMiscellaneousSubclass.Mount
local FISHING_POLE = Enum.ItemWeaponSubclass.Fishingpole
local BIND_EQUIP = Enum.ItemBind.OnEquip

local POOR, COMMON, UNCOMMON, RARE, EPIC = 0,1,2,3,4
local ACTUAL_SLOTS = {
	ROBE = 'CHEST', CLOAK = 'BACK',
	RANGEDRIGHT = 'RANGED', THROWN = 'RANGED', RELIC = 'RANGED',
	WEAPONMAINHAND = 'MAINHAND', WEAPONOFFHAND = 'OFFHAND', HOLDABLE = 'OFFHAND', SHIELD = 'OFFHAND'}

local SHOULDER_BREAKPOINT = LE_EXPANSION_LEVEL_CURRENT > 2 and 15 or 25
local INTRO_BREAKPOINT = LE_EXPANSION_LEVEL_CURRENT > 2 and 5 or 15

BINDING_NAME_SCRAP_TOGGLE = L.ToggleMousehover
BINDING_NAME_SCRAP_DESTROY_ONE = L.DestroyCheapest
BINDING_NAME_SCRAP_DESTROY_ALL = L.DestroyJunk
BINDING_NAME_SCRAP_SELL = L.SellJunk
SCRAP = 'Scrap'


--[[ Startup ]]--

function Scrap:OnLoad()
	self:OnSettings()
	self:RegisterSignal('SETS_CHANGED', 'OnSettings')
	self:RegisterEvent('MERCHANT_SHOW', function() C.AddOns.LoadAddOn('Scrap_Merchant'); self:SendSignal('MERCHANT_SHOW') end)
	self:CheckForUpdates(ADDON, self.sets, 'interface/addons/scrap/art/scrap-big')

	Scrap_Sets, Scrap_CharSets = self.sets, self.charsets
	if (Scrap_Sets.tutorial or 0) > 0 then
		SettingsPanel.CategoryList:HookScript('OnShow', function() C.AddOns.LoadAddOn('Scrap_Config') end)
	else
		C.AddOns.LoadAddOn('Scrap_Config')
	end

	if AddonCompartmentFrame then
		AddonCompartmentFrame:RegisterAddon {
			text = 'Scrap', keepShownOnClick = true, notCheckable = true,
			icon = 'interface/addons/scrap/art/scrap-small',
			func = function()
				if C.AddOns.LoadAddOn('Scrap_Config') then
					self.Options:Open()
				end
			end
		}
	end
end

function Scrap:OnSettings()
	self.sets, self.charsets = self:SetDefaults(Scrap_Sets or {}, self.Defaults), self:SetDefaults(Scrap_CharSets or {}, self.CharDefaults)
	self.junk = self:SetDefaults(self.charsets.share and self.sets.list or self.charsets.list, self.BaseList)
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
	self:Print(format(junk and L.Removed or L.Added, select(2, C.Item.GetItemInfo(id))), 'LOOT')
	self:SendSignal('LIST_CHANGED', id)
end

function Scrap:IterateJunk()
	local numSlots = C.Container.GetContainerNumSlots(BACKPACK_CONTAINER)
	local bag, slot = BACKPACK_CONTAINER, 0

	return function()
		while true do
			if slot < numSlots then
				slot = slot + 1
			elseif bag < NUM_BAGS then
				bag, slot = bag + 1, 1
				numSlots = C.Container.GetContainerNumSlots(bag)
			else
				return
			end

			local id = C.Container.GetContainerItemID(bag, slot)
			if self:IsJunk(id, bag, slot) then
				return bag, slot, id
			end
		end
	end
end

function Scrap:DestroyCheapest()
	local best = {value = 2^128}

	for bag, slot in self:IterateJunk() do
		local _, family = C.Container.GetContainerNumFreeSlots(bag)
		if family == 0 then
			local item = C.Container.GetContainerItemInfo(bag, slot)
			local _,_,_,_,_,_,_, maxStack, _,_, price = C.Item.GetItemInfo(item.itemID) 

			local value = price * (item.stackCount + sqrt(maxStack - item.stackCount) * 0.5)
			if value < best.value then
				best.bag, best.slot, best.item, best.value = bag, slot, item, value
			end
		end
	end

	if best.item then
		C.Container.PickupContainerItem(best.bag, best.slot)
		DeleteCursorItem()
		self:Print(L.Destroyed:format(best.item.hyperlink, best.item.stackCount), 'LOOT')
	end
end

function Scrap:DestroyJunk()
	LibStub('Sushi-3.2').Popup {
		text = L.ConfirmDelete, showAlert = true, button1 = OKAY, button2 = CANCEL,
		OnAccept = function()
			for bag, slot in self:IterateJunk() do
				C.Container.PickupContainerItem(bag, slot)
				DeleteCursorItem()
			end
		end
	}
end


--[[ Filters ]]--

function Scrap:IsFiltered(id, ...)
	local location = self:GuessLocation(id, ...)
	local _, link, quality, level,_,_,_,_, slot, _, value, class, subclass, bind = C.Item.GetItemInfo(id)
	local level = location and C.Item.GetCurrentItemLevel(location) or level or 0
	local bound = location and C.Item.IsBound(location)

	if class == MISC and bound then
		if subclass == MOUNT then
			return self:IsOwnedMount(id)
		elseif subclass == COMPANION then
			return self:IsOwnedCompanion(id)
		elseif (C.ToyBox.GetToyInfo or nop)(id) then
			return PlayerHasToy(id)
		end

	elseif not value or value == 0 then
		return

	elseif class == ARMOR or class == WEAPON then
		if value and slot ~= 'INVTYPE_TABARD' and slot ~= 'INVTYPE_BODY' and subclass ~= FISHING_POLE then
			if self.charsets.uncollected or link and not Search:IsUncollected(id, link) then
				if quality == POOR then
					return bind ~= BIND_EQUIP and ((slot ~= 'INVTYPE_SHOULDER' and level > INTRO_BREAKPOINT) or level > SHOULDER_BREAKPOINT)
				elseif quality >= UNCOMMON and quality <= EPIC and bound then
					if C.Item.IsEquippableItem(id) and not Search:BelongsToSet(id) then
						return self:IsLowEquip(slot, level) or self.charsets.unusable and Search:IsUnusable(id)
					end
				end
			end
		end

	elseif quality == POOR then
		return bound ~= LE_ITEM_BIND_ON_EQUIP
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

		return self:IsBelowEquipped(slot1, level) and (not slot2 or self:IsBelowEquipped(slot2, level, double))
	end
end

function Scrap:IsBelowEquipped(slot, level, canEmpty)
	local item = ItemLocation:CreateFromEquipmentSlot(_G['INVSLOT_' .. slot])
	if C.Item.DoesItemExist(item) then
		return level < (C.Item.GetCurrentItemLevel(item) or 0) * self.charsets.equipLvl
	end
	return canEmpty
end

function Scrap:IsLowConsumable(level)
	return level > 1 and level < UnitLevel('player')  * self.charsets.consumableLvl
end

function Scrap:IsOwnedMount(id)
	local mount = (C.MountJournal.GetMountFromItem or nop)(id)
	return mount and select(11, C.MountJournal.GetMountInfoByID(mount))
end

function Scrap:IsOwnedCompanion(id)
	local species = select(13, (C.PetJournal.GetPetInfoByItemID or nop)(id))
	if species then
		local numCollected, limit = C.PetJournal.GetNumCollectedInfo(species)
		return numCollected == limit
	end
end


--[[ Guessing ]]--

function Scrap:GuessLocation(...)
	local bag, slot = self:GuessBagSlot(...)
	if bag and slot then
		local location = ItemLocation:CreateFromBagAndSlot(bag, slot)
		return C.Item.DoesItemExist(location) and location
	end
end

function Scrap:GuessBagSlot(id, bag, slot)
	if bag and slot then
		return bag, slot
	elseif C.Item.GetItemCount(id) > 0 then
		for bag = BACKPACK_CONTAINER, NUM_BAGS do
		  	 for slot = 1, C.Container.GetContainerNumSlots(bag) do
		  	 	if id == C.Container.GetContainerItemID(bag, slot) then
		  	 		return bag, slot
		  	 	end
			end
		end
	end
end


--[[ Chat ]]--

function Scrap:PrintMoney(pattern, value)
	self:Print(pattern:format(GetMoneyString(value, true)), 'MONEY')
end

function Scrap:Print(text, channel)
	local i = 1
	local frame = _G['ChatFrame' .. i]
 	local channel = 'CHAT_MSG_' .. channel

	while frame do
		if frame:IsEventRegistered(channel) then
			ChatFrame_MessageEventHandler(frame, channel, text, '', nil, '')
		end

		i = i + 1
		frame = _G['ChatFrame' .. i]
	end
end
