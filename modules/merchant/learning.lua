--[[
Copyright 2008-2019 João Cardoso
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

hooksecurefunc('UseContainerItem', function(...)
  self:OnItemSold(...)
end)

local buyBack = BuybackItem
BuybackItem = function(...)
  self:OnItemRefund(...)
  return buyBack(...)
end


--[[ AI ]]--

function Button:OnItemSold (...)
	if Scrap.sets.learn and self:IsVisible() and not self.selling then
		local id = GetContainerItemID(...)
		if not id or self.Junk[id] ~= nil or self:CheckFilters(id, ...) then
			return
		end

		local stack = select(2, GetContainerItemInfo(...))
		if GetItemCount(id, true) == stack then
			local link = GetContainerItemLink(...)
			local maxStack = select(8, GetItemInfo(id))
			local stack = self:GetBuypackStack(link) + stack

			local old = Scrap.charsets.ml[id] or 0
			local new = old + stack / maxStack

			if old < 2 and new >= 2 then
				self:Print(L.Added, link, 'LOOT')
			end

			Scrap.charsets.ml[id] = new
		end
	end
end

function Button:OnItemRefund (index)
	if Scrap.sets.learn then
		local link = GetBuybackItemLink(index)
		local id = ink and tonumber(link:match('item:(%d+)'))
		local old = Scrap.charsets.ml[id]

		if old then
			local maxStack = select(8, GetItemInfo(id))
			local stack = self:GetBuypackStack(link)

			local new = old - stack / maxStack
			if old >= 2 and new < 2 then
				self:Print(L.Removed, link, 'LOOT')
			end

			if new <= 0 then
				Scrap.charsets.ml[id] = nil
			else
				Scrap.charsets.ml[id] = new
			end
		end
	end
end

function Button:GetBuypackStack (link)
	local stack = 0
	for i = 1, GetNumBuybackItems() do
		if GetBuybackItemLink(i) == link then
			stack = stack + select(4, GetBuybackItemInfo(i))
		end
	end
	return stack
end
