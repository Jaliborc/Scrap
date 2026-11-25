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

local SHOULDER_BREAKPOINT = LE_EXPANSION_LEVEL_CURRENT > 2 and 15 or 20
local INTRO_BREAKPOINT = LE_EXPANSION_LEVEL_CURRENT > 2 and 5 or 10

local POOR, COMMON, EPIC = 0,1,4 -- game constants inconsistent between game versions
local ACTUAL_SLOTS = {
	ROBE = 'CHEST', CLOAK = 'BACK',
	RANGEDRIGHT = 'RANGED', THROWN = 'RANGED', RELIC = 'RANGED',
	WEAPONMAINHAND = 'MAINHAND', WEAPONOFFHAND = 'OFFHANwD', HOLDABLE = 'OFFHAND', SHIELD = 'OFFHAND'}


--[[ Public API ]]--

function Classifier:Run(id, location)
	local _, link, quality, level,_,_,_,_, slot, _, value, class, subclass, bindType, _,_, isReagent = C.Item.GetItemInfo(id)
	if isReagent and Scrap2.Filters.reagents then
		return Scrap2.Filters.reagents
	elseif Search:IsQuestItem(id) then
		return
	end

	local location = location or self:GuessLocation(id)
	local bound = location and C.Item.IsBound(location)

	if class == MISC and bound then
		if subclass == MOUNT then
			return self:IsOwnedMount(id) and 1
		elseif subclass == COMPANION then
			return self:IsOwnedCompanion(id) and 1
		elseif (C.ToyBox.GetToyInfo or nop)(id) then
			return PlayerHasToy(id) and 1
		end
	end

	local warbound = bound and C.Bank.IsItemAllowedInBankType(Enum.BankType.Account, location)
	local level = location and C.Item.GetCurrentItemLevel(location) or level or 0
	local valuable = (value or 0) > 0

	if class == ARMOR or class == WEAPON then
		if slot ~= 'INVTYPE_TABARD' and slot ~= 'INVTYPE_BODY' and subclass ~= FISHING_POLE then
			if C.Item.IsEquippableItem(id) and C.Item.GetItemFamily(id) == 0 then
				local unusable = Search:IsUnusable(id)
				local lowLevel = self:IsLowEquip(slot, level)
				local useless = valuable and (lowLevel or unusable)

				if link and Search:IsUncollected(id, link) then
					return Scrap2.Filters.uncollected
				elseif quality == POOR then
					return valuable and bind ~= BIND_EQUIP and
						(useless or level > SHOULDER_BREAKPOINT or (slot ~= 'INVTYPE_SHOULDER' and level > INTRO_BREAKPOINT)) and 1
				elseif quality <= EPIC and not Search:BelongsToSet(id) then
					if quality == COMMON then
						return useless and 1
					elseif unusable then
						return Scrap2.Filters.unusable
					elseif lowLevel then
						return (warbound and Scrap2.Filters.warboundGear) or (bound and Scrap2.Filters.soulboundGear) or Scrap2.Filters.otherGear
					end
				end
			end
		end
	elseif warbound then
		return Scrap2.Filters.warbound
	elseif class == CONSUMABLES then
		return quality < EPIC and self:IsLowConsumable(level) and Scrap2.Filters.consumables
	elseif quality == POOR then
		return valuable and bindType ~= BIND_EQUIP and 1
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
		return level < (C.Item.GetCurrentItemLevel(item) or 0) * Scrap2.Filters.gearLvl
	end
	return canEmpty
end

function Classifier:IsLowConsumable(level)
	return level > 1 and level < UnitLevel('player') * Scrap2.Filters.iLvl
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