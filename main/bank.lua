local DEPOSIT_BANK = 'Deposit Items |TInterface/Addons/Scrap/art/crate:20:20|t'
local DEPOSIT_WARBAND = 'Deposit Items |A:warbands-icon:20:20|a'

local function setupButton(button, tag, tooltip)
	MenuUtil.HookTooltipScripts(button, function(tip)
		tip:AddLine(tooltip or '|TInterface/Addons/Scrap/art/scrap-small:20:20|t Scrap2', 1,1,1)
		tip:AddLine('|A:NPE_RightClick:14:14|a Menu')
	end)

	button:RegisterForClicks('anyUp')
	button:SetScript('OnClick', function(_, mouse)
		if mouse == 'RightButton' then
			return Scrap2:ToggleWindow()
		end

		print('Scrap2:UseItems(tag)')
	end)
end

if BankPanel and BankPanel.AutoDepositFrame then
	function BankPanel.AutoDepositFrame:SetEnabled()
		self.IncludeReagentsCheckbox:Hide()
		self.DepositButton:SetText(self.DepositButton:GetActiveBankType() == 2 and DEPOSIT_WARBAND or DEPOSIT_BANK)
		self.DepositButton:Show()
	end

	setupButton(BankPanel.AutoDepositFrame.DepositButton, 3)
else
	local deposit = CreateFrame('Button', nil, BankFrame, 'UIPanelSquareButton')
	deposit.icon:SetTexture('Interface/Addons/Scrap/art/scrap-small')
	deposit.icon:SetTexCoord(0.1,0.9,0.1,0.9)
	deposit:SetPoint('TOPRIGHT', -50,-40)

	setupButton(deposit, 3, 'Deposit Items')
end

EventUtil.ContinueOnAddOnLoaded('Blizzard_GuildBankUI', function()
	local deposit = CreateFrame('Button', nil, GuildBankFrame, 'UIPanelButtonTemplate')
	deposit:SetText('Deposit Items |TInterface/Addons/Scrap/art/banner:18:18|t')
	deposit:SetPoint('BOTTOMLEFT', 10,30)
	deposit:SetSize(150, 21)

	setupButton(deposit, 5)
end)