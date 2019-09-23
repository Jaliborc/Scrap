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

local MONEY_TYPES = {'Gold', 'Silver', 'Copper'}
local Background, Icon, Border
local L = Scrap_Locals


--[[ Startup ]]--

function Scrap:StartupMerchant()
	-- Regions --
	Background = self:CreateTexture(nil, 'BORDER')
	Background:SetHeight(27) Background:SetWidth(27)
	Background:SetPoint('CENTER', -0.5, -1.2)
	Background:SetColorTexture(0, 0, 0)

	Icon = self:CreateTexture(self:GetName()..'Icon')
	Icon:SetTexture('Interface\\Addons\\Scrap\\art\\enabled-box')
	Icon:SetPoint('CENTER')
	Icon:SetSize(33, 33)

	Border = self:CreateTexture(self:GetName() .. 'Border', 'OVERLAY')
	Border:SetTexture('Interface\\Addons\\Scrap\\art\\merchant-border')
	Border:SetSize(35.9, 35.9)
	Border:SetPoint('CENTER')

	-- Appearance --
	self:SetHighlightTexture('Interface/Buttons/ButtonHilight-Square', 'ADD')
	self:SetPushedTexture('Interface/Buttons/UI-Quickslot-Depress')
	self:SetSize(37, 37)

	-- Scripts --
	self:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
	self:SetScript('OnReceiveDrag', function() self:OnReceiveDrag() end)
	self:SetScript('OnEnter', self.OnEnter)
	self:SetScript('OnLeave', self.OnLeave)
	self:SetScript('OnClick', self.OnClick)

	-- Misc --
	self:RegisterEvent('MERCHANT_CLOSED')
	self:UpdateButtonPosition()

	-- Hooks --
	hooksecurefunc('MerchantFrame_UpdateRepairButtons', function()
		self:UpdateButtonPosition()
	end)

	hooksecurefunc(Scrap, 'ToggleJunk', function()
   		self:UpdateButtonState()
  	end)

	hooksecurefunc('UseContainerItem', function(...)
		self:OnItemSold(...)
	end)

	local buyBack = BuybackItem
	BuybackItem = function(...)
		self:OnItemRefund(...)
		return buyBack(...)
	end

	-- Visualizer Tab
	local tab = LibStub('SecureTabs-2.0'):Add(MerchantFrame)
	tab.frame = Scrap.visualizer
	tab:SetText('Scrap')
end


--[[ Events ]]--

function Scrap:MERCHANT_SHOW()
	if MerchantFrame:IsShown() then
		self:SetScript('OnUpdate', nil)
		self:OnMerchant()
	else
		self:SetScript('OnUpdate', self.MERCHANT_SHOW) -- Keep trying
	end
end

function Scrap:OnMerchant()
	if Scrap.sets.sell then
		self:SellJunk()
	end

	if Scrap.sets.repair then
		self:Repair()
	end

	if not Scrap.sets.tutorial or Scrap.sets.tutorial < 5 then
		if LoadAddOn('Scrap_Config') then
			self:BlastTutorials()
		end
	end

	self:RegisterEvent('BAG_UPDATE_DELAYED')
	self:UpdateButtonState()
end

function Scrap:MERCHANT_CLOSED()
	self:UnregisterEvent('BAG_UPDATE_DELAYED')
	self:SetScript('OnUpdate', nil)
end

function Scrap:BAG_UPDATE_DELAYED()
	self:UpdateButtonState()
end


--[[ Tooltip ]]--

function Scrap:OnEnter()
	GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	self:ShowTooltip(GameTooltip, L.SellJunk)
	GameTooltip:Show()
end

function Scrap:ShowTooltip(tooltip, title)
	local infoType, itemID = GetCursorInfo()
	if infoType == 'item' then
		if self:IsJunk(itemID) then
			tooltip:SetText(L.Remove, 1, 1, 1)
		else
			tooltip:SetText(L.Add, 1, 1, 1)
		end
	else
		local value = self:GetJunkValue()
		local counters = {}

		for bag, slot in self:IterateJunk() do
			local _, count, _, quality = GetContainerItemInfo(bag, slot)
			counters[quality] = (counters[quality] or 0) + count
		end

		tooltip:SetText(title)
		for qual, count in pairs(counters) do
			local r,g,b = GetItemQualityColor(qual)
			tooltip:AddDoubleLine(_G['ITEM_QUALITY' .. qual .. '_DESC'], count, r,g,b, r,g,b)
		end
		tooltip:AddLine(value > 0 and (SELL_PRICE .. ':  ' .. GetCoinTextureString(value)) or ITEM_UNSELLABLE, 1,1,1)
	end
end

function Scrap:OnLeave()
	GameTooltip:Hide()
end


--[[ Interaction ]]--

function Scrap:OnClick(button, ...)
	if button == 'LeftButton' then
		if not self:ToggleCursorJunk() then
			self:SellJunk()
		end
	elseif button == 'RightButton' then
		Scrap.Dropdown:Toggle(...)
	end

	self:GetScript('OnLeave')()
end

function Scrap:OnReceiveDrag()
	self:ToggleCursorJunk()
end


--[[ Button ]]--

function Scrap:UpdateButtonState()
	local disabled = not self:AnyJunk()
	Border:SetDesaturated(disabled)
	Icon:SetDesaturated(disabled)
end

function Scrap:UpdateButtonPosition()
	if CanMerchantRepair() then
		local off, scale
		if CanGuildBankRepair and CanGuildBankRepair() then
			off, scale = -3.5, 0.9
			MerchantRepairAllButton:SetPoint('BOTTOMRIGHT', MerchantFrame, 'BOTTOMLEFT', 120, 35)
		else
			off, scale = -1.5, 1
		end

		self:SetPoint('RIGHT', MerchantRepairItemButton, 'LEFT', off, 0)
		self:SetScale(scale)
	else
		self:SetPoint('RIGHT', MerchantBuyBackItem, 'LEFT', -17, 0.5)
		self:SetScale(1.1)
	end
end


--[[ Junk ]]--

function Scrap:SellJunk ()
	self.selling = true

	local value = self:GetJunkValue()
	local count = 0

	for bag, slot, id in self:IterateJunk() do
		if Scrap.sets.safe and count == 12 then
			break
		end

		local value = select(11, GetItemInfo(id)) or 0
		if value > 0 then
			UseContainerItem(bag, slot)
		else
			PickupContainerItem(bag, slot)
			DeleteCursorItem()
		end

		count = count + 1
	end

	value = value - self:GetJunkValue()
	if count > 0 then
		self:PrintMoney(L.SoldJunk, value)
	end

	self:UpdateButtonState()
	self.selling = nil
end

function Scrap:ToggleCursorJunk ()
	local type, id = GetCursorInfo()

	if type == 'item' then
		GameTooltip:Hide()
		ClearCursor()

		self:ToggleJunk(id)
		return true
	end
end

function Scrap:GetJunkValue ()
	local value = 0

	for bag, slot, id in self:IterateJunk() do
		local stack, locked = select(2, GetContainerItemInfo(bag, slot))
		local itemValue = select(11, GetItemInfo(id))

		if not locked and itemValue then
			value = value + itemValue * stack
		end
	end

	return value
end

function Scrap:AnyJunk()
	return self:IterateJunk()()
end


--[[ Repair ]]--

function Scrap:Repair()
	local cost = GetRepairAllCost()
	if cost > 0 then
		local guildMoney = GetGuildBankWithdrawMoney and GetGuildBankWithdrawMoney() or -1
		local useGuild = self:CanGuildRepair() and (guildMoney == -1 or guildMoney >= cost)

		if useGuild or GetMoney() >= cost then
			RepairAllItems(useGuild)
			self:PrintMoney(L.Repaired, cost)
		end
	end
end

function Scrap:CanGuildRepair()
	return Scrap.sets.guild and CanGuildBankRepair() and not GetGuildInfoText():find('%[noautorepair%]')
end


--[[ AI ]]--

function Scrap:OnItemSold (...)
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

function Scrap:OnItemRefund (index)
	if Scrap.sets.learn then
		local link = GetBuybackItemLink(index)
		local id = self:GetID(link)
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

function Scrap:GetBuypackStack (link)
	local stack = 0
	for i = 1, GetNumBuybackItems() do
		if GetBuybackItemLink(i) == link then
			stack = stack + select(4, GetBuybackItemInfo(i))
		end
	end
	return stack
end

MerchantRepairText:SetAlpha(0)
Scrap:StartupMerchant()
