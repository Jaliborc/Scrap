--[[
	Copyright 2008-2025 João Cardoso, All Rights Reserved
	
--]]

local Classifier = Scrap2:NewModule('Classifier')
local Search = LibStub('ItemSearch-1.3')
local C = LibStub('C_Everywhere')

local WEAPON, ARMOR, CONSUMABLES, MISC = Enum.ItemClass.Weapon, Enum.ItemClass.Armor, Enum.ItemClass.Consumable, Enum.ItemClass.Miscellaneous
local COMPANION, MOUNT = Enum.ItemMiscellaneousSubclass.CompanionPet, Enum.ItemMiscellaneousSubclass.Mount
local FISHING_POLE = Enum.ItemWeaponSubclass.Fishingpole
local BIND_EQUIP = Enum.ItemBind.OnEquip

local SHOULDER_BREAKPOINT = LE_EXPANSION_LEVEL_CURRENT > 2 and 15 or 25
local INTRO_BREAKPOINT = LE_EXPANSION_LEVEL_CURRENT > 2 and 5 or 15

local ItemQuality = Enum.ItemQuality
local POOR, UNCOMMON = ItemQuality.Poor, ItemQuality.Poor + 2 -- inconsistent between game versions
local ACTUAL_SLOTS = {
	ROBE = 'CHEST', CLOAK = 'BACK',
	RANGEDRIGHT = 'RANGED', THROWN = 'RANGED', RELIC = 'RANGED',
	WEAPONMAINHAND = 'MAINHAND', WEAPONOFFHAND = 'OFFHANwD', HOLDABLE = 'OFFHAND', SHIELD = 'OFFHAND'}


--[[ Public API ]]--

Classifier.reagents = 3 -- temp
Classifier.warbound = 4
Classifier.soulboundGear = 2
Classifier.warboundGear = 2
Classifier.otherGear = 2
Classifier.gearLvl = 0.7
Classifier.iLvl = 0.7

function Classifier:Run(id, location)
	local _, link, quality, level,_,_,_,_, slot, _, value, class, subclass, bindType, _,_, isReagent = C.Item.GetItemInfo(id)
	if isReagent then
		return self.reagents
	end

	local location = location or self:GuessLocation(id)
	local level = location and C.Item.GetCurrentItemLevel(location) or level or 0
	local bound = location and C.Item.IsBound(location)
	local warbound = bound and C.Bank.IsItemAllowedInBankType(Enum.BankType.Account, location)

	if class == MISC and bound then
		if subclass == MOUNT then
			return self:IsOwnedMount(id) and 1
		elseif subclass == COMPANION then
			return self:IsOwnedCompanion(id) and 1
		elseif (C.ToyBox.GetToyInfo or nop)(id) then
			return PlayerHasToy(id) and 1
		end
	end

	if class == ARMOR or class == WEAPON then
		if value and slot ~= 'INVTYPE_TABARD' and slot ~= 'INVTYPE_BODY' and subclass ~= FISHING_POLE and C.Item.IsEquippableItem(id) then
			if link and Search:IsUncollected(id, link) then
				return self.uncollected
			elseif quality >= UNCOMMON and quality ~= ItemQuality.Legendary and not Search:BelongsToSet(id) then
				if bound and Search:IsUnusable(id) then
					return self.unusable
				elseif self:IsLowEquip(slot, level) then
					return (warbound and self.warboundGear) or (bound and self.soulboundGear) or self.otherGear
				end
			elseif quality == POOR then
				return bindType ~= BIND_EQUIP and ((slot ~= 'INVTYPE_SHOULDER' and level > INTRO_BREAKPOINT) or level > SHOULDER_BREAKPOINT) and 1
			end
		end
	elseif warbound then
		return self.warbound
	elseif class == CONSUMABLES then
		return quality < ItemQuality.Rare and self:IsLowConsumable(level) and self.consumables
	elseif quality == POOR and value and value > 0 then
		return bindType ~= BIND_EQUIP and 1
	end
end

function Classifier:GuessLocation(id)
	if C.Item.GetItemCount(id) > 0 then
		for bag = BACKPACK_CONTAINER, Scrap2.NUM_BAGS do
		  	 for slot = 1, C.Container.GetContainerNumSlots(bag) do
		  	 	if id == C.Container.GetContainerItemID(bag, slot) then
		  	 		return ItemLocation:CreateFromBagAndSlot(bag, slot)
		  	 	end
			end
		end
	end
end


--[[ Low Level ]]--

function Classifier:IsLowEquip(slot, level)
	if slot == ''  then
		return
	end

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

function Classifier:IsBelowEquipped(slot, level, canEmpty)
	local item = ItemLocation:CreateFromEquipmentSlot(_G['INVSLOT_' .. slot])
	if C.Item.DoesItemExist(item) then
		return level < (C.Item.GetCurrentItemLevel(item) or 0) * self.gearLvl
	end
	return canEmpty
end

function Classifier:IsLowConsumable(level)
	return level > 1 and level < UnitLevel('player')  * self.iLvl
end


--[[ Collections ]]--

function Classifier:IsOwnedMount(id)
	local mount = (C.MountJournal.GetMountFromItem or nop)(id)
	return mount and select(11, C.MountJournal.GetMountInfoByID(mount))
end

function Classifier:IsOwnedCompanion(id)
	local species = select(13, (C.PetJournal.GetPetInfoByItemID or nop)(id))
	if species then
		local numCollected, limit = C.PetJournal.GetNumCollectedInfo(species)
		return numCollected == limit
	end
end