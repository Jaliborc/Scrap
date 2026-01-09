--[[
	Copyright 2008-2025 João Cardoso, All Rights Reserved
	Adds or modifies buttons on the base UI.
--]]


local C = LibStub('C_Everywhere')
local Buttons = Scrap2:NewModule('Buttons')

local DEPOSIT = 'Deposit Items'
local DEPOSIT_BANK = DEPOSIT .. ' |TInterface/Addons/Scrap/art/crate:20:20|t'
local DEPOSIT_WARBAND = DEPOSIT .. ' |A:warbands-icon:20:20|a'


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

		self:Setup(deposit, 3)
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
		hooksecurefunc('MerchantFrame_UpdateMerchantInfo', function() button:Show() end)
	else
		button:SetHighlightTexture('Interface/Buttons/ButtonHilight-Square', 'ADD')
		button:SetPushedTexture('Interface/Buttons/UI-Quickslot-Depress')
		button:SetSize(37, 37)

		button.Bg = sell:CreateTexture(nil, 'BACKGROUND')
		button.Bg:SetPoint('CENTER', -0.5, -1.2)
		button.Bg:SetColorTexture(0, 0, 0)
		button.Bg:SetSize(27, 27)

		button.Border = sell:CreateTexture(nil, 'OVERLAY')
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

	self:Setup(button, 1, 'Sell Junk')
end

function Buttons:Setup(button, tag, title)
	button.tag, button.title = tag, title or DEPOSIT
	button:SetScript('OnClick', self.OnClick)
	button:SetScript('OnEnter', self.OnEnter)
	button:SetScript('OnLeave', MenuUtil.HideTooltip)
	button:SetScript('OnReceiveDrag', self.OnReceiveDrag)
	button:RegisterForClicks('anyUp')
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
	local type, id = GetCursorInfo()

	if type == 'item' then
		tip:SetOwner(self, 'ANCHOR_RIGHT')
		tip:SetText(Scrap2:GetTag(id) == self.tag and 'Remove from TAG' or 'Set as TAG', 1,1,1)
	else
		tip:SetOwner(self, 'ANCHOR_RIGHT')
		tip:SetText(self.title)

		local count, qualities, value = Buttons:Preview(self.tag)
		for i, count in pairs(qualities) do
			local r,g,b = ITEM_QUALITY_COLORS[i].color:GetRGB()
			tip:AddDoubleLine(_G['ITEM_QUALITY' .. i .. '_DESC'], count, r,g,b, r,g,b)
		end

		if tag == 1 and value > 0 then
			tip:AddLine(GetCoinTextureString(value), 1,1,1)
		end
	end

	tip:Show()
end

function Buttons:OnReceiveDrag()
	local type, id = GetCursorInfo()
	if type == 'item' then
		Scrap2:SetTag(id, Scrap2:GetTag(id) ~= self.tag and self.tag or 0)
		ClearCursor()
	end
end


--[[ API ]]--

function Buttons:Preview(tag)
	local count, value = 0, 0
	local qualities = {}

	for bag, slot, item in Scrap2:IterateInventory(tag) do
		if not item.isLocked and item.quality then
			count = count + item.stackCount
			value = value + item.stackCount * (select(11, C.Item.GetItemInfo(item.itemID)) or 0)
			qualities[item.quality] = (qualities[item.quality] or 0) + item.stackCount
		end
	end

	return count, qualities, value
end