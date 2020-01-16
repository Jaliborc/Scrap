--[[
Copyright 2008-2020 João Cardoso
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

local Button = Scrap:NewModule('Merchant', CreateFrame('Button', nil, MerchantBuyBackItem))
local L = LibStub('AceLocale-3.0'):GetLocale('Scrap')


--[[ Events ]]--

function Button:OnEnable()
	local background = self:CreateTexture(nil, 'BACKGROUND')
	background:SetPoint('CENTER', -0.5, -1.2)
	background:SetColorTexture(0, 0, 0)
	background:SetSize(27, 27)

	local icon = self:CreateTexture()
	icon:SetTexture('Interface/Addons/Scrap/art/enabled-box')
	icon:SetPoint('CENTER')
	icon:SetSize(33, 33)

	local border = self:CreateTexture(nil, 'OVERLAY')
	border:SetTexture('Interface/Addons/Scrap/art/merchant-border')
	border:SetSize(35.9, 35.9)
	border:SetPoint('CENTER')

	self.background, self.icon, self.border, self.tab = background, icon, border, tab
	self:SetHighlightTexture('Interface/Buttons/ButtonHilight-Square', 'ADD')
	self:SetPushedTexture('Interface/Buttons/UI-Quickslot-Depress')
	self:RegisterForClicks('AnyUp')
	self:SetSize(37, 37)
	self:OnMerchant()

	self:SetScript('OnReceiveDrag', self.OnReceiveDrag)
	self:SetScript('OnEnter', self.OnEnter)
	self:SetScript('OnLeave', self.OnLeave)
	self:SetScript('OnClick', self.OnClick)

	self:RegisterEvent('MERCHANT_SHOW', 'OnMerchant')
	self:RegisterEvent('MERCHANT_CLOSED', 'OnClose')

	hooksecurefunc('MerchantFrame_UpdateRepairButtons', function()
		self:UpdatePosition()
	end)
end

function Button:OnMerchant()
	if Scrap.sets.sell then
		self:Sell()
	end

	if Scrap.sets.repair then
		self:Repair()
	end

	if (Scrap.sets.tutorial or 0) < 5 and LoadAddOn('Scrap_Config') then
		Scrap.Tutorials:Start()
	end

	self:RegisterEvent('BAG_UPDATE_DELAYED', 'UpdateState')
	self:RegisterSignal('LIST_CHANGED', 'UpdateState')
	self:UpdatePosition()
	self:UpdateState()
end

function Button:OnClose()
	self:UnregisterEvent('BAG_UPDATE_DELAYED')
	self:UnregisterSignal('LIST_CHANGED')
end


--[[ Interaction ]]--

function Button:OnClick(button)
	if GetCursorInfo() then
		self:OnReceiveDrag()
	elseif button == 'LeftButton' then
		self:Sell()
	elseif button == 'RightButton' and LoadAddOn('Scrap_Config') then
		local drop = LibStub('Sushi-3.1').Dropdown:Toggle(self)
		if drop then
			drop:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -12)
			drop:SetChildren {
				{ text = 'Scrap', isTitle = 1 },
				{
					text = OPTIONS, notCheckable = 1,
					func = function()
						Scrap.Options:Open()
					end
				},
				{
					text = SHOW_TUTORIALS, notCheckable = 1,
					func = function()
						Scrap.Tutorials:Reset()
					end
				},
				{ text = CANCEL, notCheckable = 1 }
			}
		end
	end
end

function Button:OnReceiveDrag()
	local type, id = GetCursorInfo()
	if type == 'item' then
		Scrap:ToggleJunk(id)
		ClearCursor()
	end
end

function Button:OnEnter()
	GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	self:UpdateTip(GameTooltip)
end

function Button:OnLeave()
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end


--[[ Update ]]--

function Button:UpdateState()
	local disabled = not self:AnyJunk()
	self.border:SetDesaturated(disabled)
	self.icon:SetDesaturated(disabled)
end

function Button:UpdatePosition()
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

	MerchantRepairText:Hide()
end

function Button:UpdateTip(tooltip)
	local type, id = GetCursorInfo()
	if type == 'item' then
		tooltip:SetText(Scrap:IsJunk(id) and L.Remove or L.Add, 1, 1, 1)
	else
		tooltip:SetText(MerchantFrame:IsShown() and L.SellJunk or L.DestroyJunk)

		local value, qualities = self:GetReport()
		for quality, count in pairs(qualities) do
			local r,g,b = GetItemQualityColor(quality)
			tooltip:AddDoubleLine(_G['ITEM_QUALITY' .. quality .. '_DESC'], count, r,g,b, r,g,b)
		end

		tooltip:AddLine(value > 0 and GetCoinTextureString(value) or ITEM_UNSELLABLE, 1,1,1)
	end

	tooltip:Show()
end


--[[ Actions ]]--

function Button:Sell()
	local total = self:GetReport()
	local count = 0

	for bag, slot, id in Scrap:IterateJunk() do
		if not Scrap.sets.safe or count < 12 then
			count = count + 1
		else
			break
		end

		local value = select(11, GetItemInfo(id)) or 0
		if value > 0 then
			UseContainerItem(bag, slot)
		elseif Scrap.sets.destroy then
			PickupContainerItem(bag, slot)
			DeleteCursorItem()
		end
	end

	if count > 0 then
		Scrap:PrintMoney(L.SoldJunk, total - self:GetReport())
	end
end

function Button:GetReport()
	local qualities = {}
	local total = 0

	for bag, slot, id in Scrap:IterateJunk() do
		local _, count, locked, quality = GetContainerItemInfo(bag, slot)
		local value = select(11, GetItemInfo(id)) or 0

		if not locked then
			qualities[quality] = (qualities[quality] or 0) + count
			total = total + value * count
		end
	end

	return total, qualities
end

function Button:AnyJunk()
	return Scrap:IterateJunk()()
end

function Button:Repair()
	local cost = GetRepairAllCost()
	if cost > 0 then
		local guild = self:CanGuildRepair(cost)
		if guild or GetMoney() >= cost then
			Scrap:PrintMoney(L.Repaired, cost)
			RepairAllItems(guild)
		end
	end
end

function Button:CanGuildRepair(cost)
	if Scrap.sets.guild and CanGuildBankRepair and CanGuildBankRepair() and not GetGuildInfoText():find('%[noautorepair%]') then
		local money = GetGuildBankWithdrawMoney() or -1
		return money < 0 or money >= cost
	end
end
