--[[
	Copyright 2008-2025 João Cardoso, All Rights Reserved
	Automatic performs interface actions according to settings.
--]]

local Automation = Scrap2:NewModule('Automation')
local C = LibStub('C_Everywhere')


--[[ Events ]]--

function Automation:OnLoad()
	self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_SHOW')
	self:RegisterEvent('BANKFRAME_OPENED')
	self:RegisterEvent('MERCHANT_SHOW')
end

function Automation:MERCHANT_SHOW()
	self:Run(1)
	self:Repair()
end

function Automation:BANKFRAME_OPENED()
	if C.Bank.CanUseBank(Enum.BankType.Character) then
		self:Run(3)
	end
	if C.Bank.CanUseBank(Enum.BankType.Account) then
		self:Run(4)
	end
end

function Automation:PLAYER_INTERACTION_MANAGER_FRAME_SHOW(npc)
	if npc == Enum.PlayerInteractionType.GuildBanker then
		self:ContinueOn('GUILDBANKBAGSLOTS_CHANGED', 'Run', 5)
	end
end


--[[ API ]]--

function Automation:Run(tag)
	local tag = Scrap2.Tags[tag]
	if tag.auto then
		Scrap2:UseItems(tag.id)
	end
end

function Automation:Repair()
	local cost = GetRepairAllCost()
	local sets = Scrap2.Tags[0]

	if sets.repair and cost > 0 then
		local allowance = GetGuildBankWithdrawMoney() or -1
		local canGuild = CanGuildBankRepair and CanGuildBankRepair() and not GetGuildInfoText():find('%[noautorepair%]')
		local useGuild = sets.guildRepair and canGuild and (allowance < 0 or allowance >= cost)

		if useGuild or GetMoney() >= cost then
			RepairAllItems(useGuild)
			Scrap2:Print(useGuild and L.GuildRepaired or L.Repaired, GetMoneyString(cost, true))
		end
	end
end