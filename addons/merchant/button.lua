--[[
Copyright 2008-2024 João Cardoso
All Rights Reserved
--]]

local Button = Scrap:NewModule('Merchant', CreateFrame('Button', nil, MerchantBuyBackItem), 'MutexDelay-1.0')
local L = LibStub('AceLocale-3.0'):GetLocale('Scrap')
local C = LibStub('C_Everywhere').Container


--[[ Events ]]--

function Button:OnEnable()
	local icon = self:CreateTexture()
	icon:SetTexture(MerchantSellAllJunkButton and 'Interface/Addons/Scrap/Art/Scrap-Big' or 'Interface/Addons/Scrap/Art/Scrap-Small')
	icon:SetPoint('CENTER')
	icon:SetSize(33, 33)

	self.icon, self.border = icon, self:CreateTexture(nil, 'OVERLAY')
	self:SetHighlightTexture('Interface/Buttons/ButtonHilight-Square', 'ADD')
	self:SetPushedTexture('Interface/Buttons/UI-Quickslot-Depress')
	self:RegisterForClicks('AnyUp')
	self:SetSize(37, 37)

	self:RegisterSignal('MERCHANT_SHOW', 'OnMerchant')
	self:RegisterEvent('MERCHANT_CLOSED', 'OnClose')
	self:SetScript('OnReceiveDrag', self.OnReceiveDrag)
	self:SetScript('OnEnter', self.OnEnter)
	self:SetScript('OnLeave', self.OnLeave)
	self:SetScript('OnClick', self.OnClick)

	if MerchantSellAllJunkButton then
		hooksecurefunc('MerchantFrame_UpdateMerchantInfo', function() MerchantSellAllJunkButton:Show() end)
		self:SetAllPoints(MerchantSellAllJunkButton)
	else
		local background = self:CreateTexture(nil, 'BACKGROUND')
		background:SetPoint('CENTER', -0.5, -1.2)
		background:SetColorTexture(0, 0, 0)
		background:SetSize(27, 27)

		self.border:SetTexture('Interface/Addons/Scrap/art/merchant-border')
		self.border:SetSize(35.9, 35.9)
		self.border:SetPoint('CENTER')

		hooksecurefunc('MerchantFrame_UpdateRepairButtons', function() self:UpdatePosition() end)
	end
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

	self:RegisterSignal('LIST_CHANGED', 'UpdateState')
	self:RegisterEvent('BAG_UPDATE', 'OnBagUpdate')
	self:UpdatePosition()
	self:UpdateState()
end

function Button:OnBagUpdate()
	if self.saleTotal then
		self:Delay(0.5, 'Sell')
	else
		self:Delay(0, 'UpdateState')
	end
end

function Button:OnClose()
	self:UnregisterSignal('LIST_CHANGED')
	self:UnregisterEvent('BAG_UPDATE')
end


--[[ Interaction ]]--

function Button:OnClick(button)
	if GetCursorInfo() then
		self:OnReceiveDrag()
	elseif button == 'LeftButton' then
		self:Sell()
		self:UpdateTip(GameTooltip)
	elseif button == 'RightButton' and LoadAddOn('Scrap_Config') then
		local drop = LibStub('Sushi-3.2').Dropdown:Toggle(self)
		if drop then
			drop:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -12)
			drop:SetChildren {
				{ text = 'Scrap', isTitle = 1 },
				{
					text = OPTIONS ..'  |A:worldquest-icon-engineering:12:12|a',
					func = function() Scrap.Options:Open() end,
					notCheckable = 1
				},
				{
					text = HELP_LABEL .. '  |T516770:12:12:0:0:64:64:14:50:14:50|t',
					func = function() Scrap.Options.Help:Open() end,
					notCheckable = 1
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

if MerchantSellAllJunkButton then
	function Button:UpdatePosition() end
else
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
end


--[[ Actions ]]--

function Button:Sell()
	self.saleTotal = self.saleTotal or self:GetReport()

	local count = 0
	for bag, slot, id in Scrap:IterateJunk() do
		if not C.GetContainerItemInfo(bag, slot).isLocked then
			local value = select(11, GetItemInfo(id)) or 0
			if value > 0 then
				C.UseContainerItem(bag, slot)
			elseif Scrap.sets.destroy then
				C.PickupContainerItem(bag, slot)
				DeleteCursorItem()
			end

			if count < 11 then
				count = count + 1
			else
				break
			end
		end
	end

	local remaining = self:GetReport()
	if remaining == 0 or Scrap.sets.safe then
		if count > 0 then
			Scrap:PrintMoney(L.SoldJunk, self.saleTotal - remaining)
		end

		self.saleTotal = nil
	end
end

function Button:GetReport()
	local qualities = {}
	local total = 0

	for bag, slot in Scrap:IterateJunk() do
		local item = C.GetContainerItemInfo(bag, slot)
		if not item.isLocked and item.quality then
			qualities[item.quality] = (qualities[item.quality] or 0) + item.stackCount
			total = total + item.stackCount * (select(11, GetItemInfo(item.itemID)) or 0)
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
