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

function Learn:OnItemSold(...)
	local id = C.GetContainerItemID(...)
	if id and Scrap.junk[id] == nil and not Scrap:IsFiltered(id, ...) then
  	local rate = self:GetDecay(id, C.GetContainerItemInfo(...).stackCount)
    local old = Scrap.charsets.auto[id] or 0
    local new = old + (1 - old) * rate

  	Scrap.charsets.auto[id] = new
    if old <= .5 and new > .5 then
      Scrap:Print(L.Added, C.GetContainerItemLink(...), 'LOOT')
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
      Scrap:Print(L.Removed, link, 'LOOT')
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
