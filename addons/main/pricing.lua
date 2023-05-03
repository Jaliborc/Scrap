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

if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then return end
local Prices = Scrap:NewModule('TooltipPrices')


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
    local _, count, _,_,_,_,_,_,_, id = GetContainerItemInfo(bag, slot)
    Prices:AddLine(tip, id, count, true)
end

function Prices.OnInventory(tip, unit, slot)
    local count = GetInventoryItemCount(unit, slot)
    local id = GetInventoryItemID(unit, slot)
    Prices:AddLine(tip, id, count)
end

function Prices.OnQuest(tip, type, index)
    local _,_, count, _,_, id = (type == 'reward' and GetQuestLogRewardInfo or GetQuestLogChoiceInfo)(index)
    Prices:AddLine(tip, id, count)
end

function Prices.OnLoot(tip, slot)
    Prices:AddLine(tip, GetLootSlotLink(slot), GetLootInfo()[slot].quantity)
end

function Prices.OnMail(tip, message, slot)
    local _, id, _, count = GetInboxItem(message, slot)
    Prices:AddLine(tip, id, count)
end

function Prices.OnSetTradeSkillItem(tip, skill, index)
	if index then
		Prices:AddLine(tip, GetTradeSkillReagentItemLink(skill, index))
	else
		Prices:AddLine(tip, GetTradeSkillItemLink(skill))
	end
end

function Prices.OnSetCraftItem(tip, ...)
	Prices:AddLine(tip, GetCraftReagentItemLink(...))
end

function Prices.OnLink(tip, link)
    Prices:AddLine(tip, link)
end