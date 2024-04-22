--[[
Copyright 2008-2024 João Cardoso
All Rights Reserved
--]]

local Learn = Scrap:NewModule('Learning') -- dumb ml algortihm using exponential mean average
local L = LibStub('AceLocale-3.0'):GetLocale('Scrap')
local C = LibStub('C_Everywhere').Container


--[[ Events ]] --

function Learn:OnEnable()
  C.hooksecurefunc('UseContainerItem', function(...)
    if self:IsActive() then
      self:OnItemSold(...)
    end
  end)

  local buyBack = BuybackItem
  BuybackItem = function(...)
    if self:IsActive() then
      self:OnItemRefund(...)
    end
    return buyBack(...)
  end
end

function Learn:OnItemSold(bag, slot)
	local id = C.GetContainerItemID(bag, slot)
	if id and Scrap.junk[id] == nil and not Scrap:IsFiltered(id, bag, slot) then
  	local rate = self:GetDecay(id, C.GetContainerItemInfo(bag, slot).stackCount)
    local old = Scrap.charsets.auto[id] or 0
    local new = old + (1 - old) * rate

  	Scrap.charsets.auto[id] = new
    if old <= .5 and new > .5 then
      Scrap:Print(L.Added:format(C.GetContainerItemLink(bag, slot)), 'LOOT')
      Scrap:SendSignal('LIST_CHANGED', id)
    end
  end
end

function Learn:OnItemRefund(index)
	local link = GetBuybackItemLink(index)
	local id = link and tonumber(link:match('item:(%d+)'))
  local old = Scrap.charsets.auto[id]
	if old then
    local rate = self:GetDecay(id, select(4, GetBuybackItemInfo(index)))
    local new = (1 - rate * 2) * old

  	Scrap.charsets.auto[id] = new > 0.1 and new or nil
    if old > .5 and new <= .5 then
      Scrap:Print(L.Removed:format(link), 'LOOT')
      Scrap:SendSignal('LIST_CHANGED', id)
    end
  end
end


--[[ API ]]--

function Learn:IsActive()
  return Scrap.sets.learn and MerchantFrame:IsVisible()
end

function Learn:GetDecay(id, stack)
  local maxStack = select(8, GetItemInfo(id))
  return 0.382 * stack / maxStack
end
