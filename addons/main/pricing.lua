--[[
Copyright 2008-2024 João Cardoso
All Rights Reserved
--]]

if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then return end
local Prices = Scrap:NewModule('TooltipPrices')
local C = LibStub('C_Everywhere').Container


--[[ Main ]]--

function Prices:OnEnable()
    local meta = getmetatable(GameTooltip).__index
    hooksecurefunc(meta, 'SetBagItem', self.OnBag)
    hooksecurefunc(meta, 'SetLootItem', self.OnLoot)
    hooksecurefunc(meta, 'SetHyperlink', self.OnLink)
    hooksecurefunc(meta, 'SetQuestItem', self.OnQuest)
    hooksecurefunc(meta, 'SetQuestLogItem', self.OnQuest)
    hooksecurefunc(meta, 'SetInventoryItem', self.OnInventory)
    hooksecurefunc(meta, 'SetTradeSkillItem', self.OnSetTradeSkillItem)
    hooksecurefunc(meta, 'SetCraftItem', self.OnSetCraftItem)
    hooksecurefunc(meta, 'SetInboxItem', self.OnMail)
end

function Prices:AddLine(tip, item, count, silent)
    if item and Scrap.sets.prices and (not silent or not MerchantFrame:IsVisible()) and not tip:IsForbidden() then
        local price = select(11, GetItemInfo(item))
        if price and price > 0 then
            tip.__hasPrice = true
            tip:AddLine(GetCoinTextureString(price * max(1, count or 1)), 1,1,1)
            tip:Show()
        end
    end
end


--[[ Events ]]--

function Prices.OnBag(tip, bag, slot)
    if bag and slot then
        local info = C.GetContainerItemInfo(bag, slot)
        if info then
            Prices:AddLine(tip, info.itemID, info.stackCount, true)
        end
    end
end

function Prices.OnInventory(tip, unit, slot)
    if unit and slot then
        local count = GetInventoryItemCount(unit, slot)
        local id = GetInventoryItemID(unit, slot)
        Prices:AddLine(tip, id, count)
    end
end

function Prices.OnQuest(tip, type, index)
    if index then
        local _,_, count, _,_, id = (type == 'reward' and GetQuestLogRewardInfo or GetQuestLogChoiceInfo)(index)
        Prices:AddLine(tip, id, count)
    end
end

function Prices.OnLoot(tip, slot)
    if slot then
        Prices:AddLine(tip, GetLootSlotLink(slot), GetLootInfo()[slot].quantity)
    end
end

function Prices.OnMail(tip, message, slot)
    if message and slot then
        local _, id, _, count = GetInboxItem(message, slot)
        Prices:AddLine(tip, id, count)
    end
end

function Prices.OnSetTradeSkillItem(tip, skill, index)
	if index then
		Prices:AddLine(tip, GetTradeSkillReagentItemLink(skill, index))
    elseif skill then
		Prices:AddLine(tip, GetTradeSkillItemLink(skill))
	end
end

function Prices.OnSetCraftItem(tip, ...)
    if ... then
	    Prices:AddLine(tip, GetCraftReagentItemLink(...))
    end
end

function Prices.OnLink(tip, link)
    if link then
        Prices:AddLine(tip, link)
    end
end