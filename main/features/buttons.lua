--[[
	Copyright 2008-2025 João Cardoso, All Rights Reserved
	Adds or modifies buttons on the base UI.
--]]

local Buttons = Scrap2:NewModule('Buttons')
local L = LibStub('AceLocale-3.0'):GetLocale('Scrap2')
local C = LibStub('C_Everywhere')

local DEPOSIT_BANK = L.Deposit .. ' |TInterface/Addons/Scrap/art/crate:20:20|t'
local DEPOSIT_WARBAND = L.Deposit .. ' |A:warbands-icon:20:20|a'


--[[ Startup ]]--

function Buttons:OnLoad()
	-- bank
	if BankPanel and BankPanel.AutoDepositFrame then
		function BankPanel.AutoDepositFrame:SetEnabled()
			local isWarband = self.DepositButton:GetActiveBankType() == Enum.BankType.Account
			Buttons:Setup(self.DepositButton, isWarband and 4 or 3)
			
			self.IncludeReagentsCheckbox:Hide()
			self.DepositButton:SetText(isWarband and DEPOSIT_WARBAND or DEPOSIT_BANK)
			self.DepositButton:Show()
		end
	else
		local deposit = CreateFrame('Button', nil, BankFrame, 'UIPanelSquareButton')
		deposit.icon:SetTexture('Interface/Addons/Scrap/art/scrap-small')
		deposit.icon:SetTexCoord(0.1,0.9,0.1,0.9)
		deposit:SetPoint('TOPRIGHT', -50,-40)

		self:Setup(deposit, 3, function(active)
			deposit.icon:SetDesaturated(not active)
		end)
	end

	EventUtil.ContinueOnAddOnLoaded('Blizzard_GuildBankUI', function()
		local deposit = CreateFrame('Button', nil, GuildBankFrame, 'UIPanelButtonTemplate')
		deposit:SetText('Deposit Items |TInterface/Addons/Scrap/art/banner:18:18|t')
		deposit:SetPoint('BOTTOMLEFT', 10,30)
		deposit:SetSize(150, 21)

		self:Setup(deposit, 5)
	end)

	-- merchant 
	local button = MerchantSellAllJunkButton or CreateFrame('Button', nil, MerchantBuyBackItem)
	button.Icon = button:CreateTexture()
	button.Icon:SetTexture('Interface/Addons/Scrap/Art/Scrap-Big')
	button.Icon:SetPoint('CENTER')
	button.Icon:SetSize(33, 33)

	if MerchantSellAllJunkButton then
		hooksecurefunc('MerchantFrame_Update', function() button:Update(); button:Enable() end)
		hooksecurefunc('MerchantFrame_UpdateMerchantInfo', function() button:Show() end)
	else
		button:SetHighlightTexture('Interface/Buttons/ButtonHilight-Square', 'ADD')
		button:SetPushedTexture('Interface/Buttons/UI-Quickslot-Depress')
		button:SetSize(37, 37)

		button.Bg = button:CreateTexture(nil, 'BACKGROUND')
		button.Bg:SetPoint('CENTER', -0.5, -1.2)
		button.Bg:SetColorTexture(0, 0, 0)
		button.Bg:SetSize(27, 27)

		button.Border = button:CreateTexture(nil, 'OVERLAY')
		button.Border:SetTexture('Interface/Addons/Scrap/art/merchant-border')
		button.Border:SetSize(35.9, 35.9)
		button.Border:SetPoint('CENTER')

		hooksecurefunc('MerchantFrame_UpdateRepairButtons', function()
			if CanMerchantRepair() then
				local off, scale
				if CanGuildBankRepair and CanGuildBankRepair() then
					MerchantRepairAllButton:SetPoint('BOTTOMRIGHT', MerchantFrame, 'BOTTOMLEFT', 120, 35)
					off, scale = -3.5, 0.9
				else
					off, scale = -1.5, 1
				end

				button:SetPoint('RIGHT', MerchantRepairItemButton, 'LEFT', off, 0)
				button:SetScale(scale)
			else
				button:SetPoint('RIGHT', MerchantBuyBackItem, 'LEFT', -17, 0.5)
				button:SetScale(1.1)
			end

			MerchantRepairText:Hide()
		end)
	end

	self:Setup(button, 1, function(active) button.Icon:SetDesaturated(not active) end)
	self:RegisterEvent('BAG_UPDATE_DELAYED', 'UpdateAll')
	self:RegisterSignal('LIST_CHANGED', 'UpdateAll')
end

function Buttons:Setup(button, tag, refresh)
	button.tag = tag
	button.Update = function() (refresh or nop)(Scrap2:PreviewItems(tag).total > 0) end

	button:SetScript('OnShow', button.Update)
	button:SetScript('OnClick', self.OnClick)
	button:SetScript('OnEnter', self.OnEnter)
	button:SetScript('OnLeave', MenuUtil.HideTooltip)
	button:SetScript('OnReceiveDrag', self.OnReceiveDrag)
	button:RegisterForClicks('anyUp')

	tinsert(GetOrCreateTableEntry(self, 'buttons'), button)
end

function Buttons:UpdateAll()
	for _, button in pairs(self.buttons) do
		if button:IsVisible() then
			button.Update()

			if tContains(GetMouseFoci(), button) then
				Buttons.OnEnter(button)
			end
		end
	end
end


--[[ User Events ]]--

function Buttons:OnClick(mouse)
	if mouse ~= 'RightButton' then
		Scrap2:UseItems(self.tag)
	else
		Scrap2:ToggleWindow()
	end
end

function Buttons:OnEnter()
	local tip = GameTooltip
	local tag = Scrap2.Tags[self.tag]

	local held, id = GetCursorInfo()
	local stats = Scrap2:PreviewItems(tag.id)
	local active = held == 'item' or stats.total > 0

	if active then
		tip:SetOwner(self, 'ANCHOR_RIGHT')

		if held == 'item' then
			tip:SetText(format(Scrap2:GetTag(id) == tag.id and L.RemoveItem or L.AddItem, Scrap2:GetItemName(id), tag.name))
		else
			tip:SetOwner(self, 'ANCHOR_RIGHT')
			tip:SetText(tag.id == 1 and L.SellJunk or L.Deposit)

			for i, count in pairs(stats.qualities) do
				local r,g,b = ITEM_QUALITY_COLORS[i].color:GetRGB()
				tip:AddDoubleLine(_G['ITEM_QUALITY' .. i .. '_DESC'], count, r,g,b, r,g,b)
			end

			if tag.id == 1 and value > 0 then
				tip:AddLine(GetMoneyString(stats.price, true), 1,1,1)
			end
		end
		
		PlaySound(286132)
	end

	tip:SetShown(active)
end

function Buttons:OnReceiveDrag()
	local held, id = GetCursorInfo()
	if held == 'item' then
		ClearCursor()
		Scrap2:SetTag(id, Scrap2:GetTag(id) ~= self.tag and self.tag or 0)
	end
end