--[[
	Copyright 2008-2025 João Cardoso, All Rights Reserved
	Initalization of tags, lists and general settings.
--]]

local Sets = Scrap2:NewModule('Settings')
local L = LibStub('AceLocale-3.0'):GetLocale('Scrap2')
local C = LibStub('C_Everywhere')


--[[ Defaults ]]--

Sets.BaseTags = {
	[0] = {name = L.None, color = {1,1,1,0}, enabled = true},
	[1] = {name = L.Junk, icon = 'Interface/Addons/Scrap2/art/coin', color = {ITEM_QUALITY_COLORS[0].color:GetRGB()}, limit = 12, safe = true, enabled = true},
	[2] = {name = L.Disenchant, icon = 'Interface/Addons/Scrap2/art/disenchant', color = {0.67, 0.439, 0.89}, event = 'SKILL_LINES_CHANGED', callback = function(tag) tag.enabled = Sets:IsPlayerEnchanter() end},
	[3] = {name = L.Mail, atlas = 'mailbox', color = {0.64, 0.54, 0.43}, enabled = WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE},
	[4] = {name = L.Bank, icon = 'Interface/Addons/Scrap2/art/crate', color = {0.45, 0.32, 0.15}, type = 0, enabled = true}
}

if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
	Sets.BaseTags[5] = {name = L.Warband, atlas = 'warbands-icon', color = {0.45, 0.32, 0.15}, type = 2, enabled = true}
end

if GuildBankFrame_LoadUI then
	Sets.BaseTags[6] = {name = L.Guild, icon = 'Interface/Addons/Scrap2/art/banner', color = {0.13, 0.18, 0.32}, limit = 1, type = 1,
						  event = 'PLAYER_GUILD_UPDATE', callback = function(tag) tag.enabled = C.GuildInfo.IsGuildOfficer() end}
end

Sets.BaseList = {
	[90561] = 0,
	[12709] = 0,
	[2459] = 0,
	[29532] = 0,
	[29530] = 0,
	[39878] = 0,
	[40586] = 0,
	[48954] = 0,
	[48955] = 0,
	[48956] = 0,
	[48957] = 0,
	[45688] = 0,
	[45689] = 0,
	[45690] = 0,
	[45691] = 0,
	[44934] = 0,
	[44935] = 0,
	[51560] = 0,
	[51558] = 0,
	[51559] = 0,
	[51557] = 0,
	[40585] = 0,
	[43157] = 0,
	[63206] = 0,
	[63207] = 0,
	[65274] = 0,
	[63353] = 0,
	[64402] = 0,
	[64401] = 0,
	[64400] = 0,
	[63352] = 0,
	[86143] = 0,
	[92742] = 0,
	[92741] = 0,
	[92665] = 0,
	[92675] = 0,
	[92676] = 0,
	[92677] = 0,
	[92678] = 0,
	[92679] = 0,
	[92680] = 0,
	[92681] = 0,
	[92682] = 0,
	[92683] = 0,
	[33820] = 0,
	[19969] = 0,
	[89124] = 0,
	[114131] = 0,
	[114808] = 0,
	[114129] = 0,
	[114745] = 0,
	[114128] = 0,
	[120301] = 0,
	[120302] = 0,
	[114002] = 0,
	[156631] = 0,
	[24368] = 0,
	[40772] = 0,
	[114943] = 0,
	[109253] = 0,
	[67410] = 0,
	[11406] = 0,
	[11944] = 0,
	[25402] = 0,
	[3300] = 0,
	[3670] = 0,
	[6150] = 0,
	[36812] = 0,
	[62072] = 0,
	[87216] = 0,
	[6529] = 0,
	[136377] = 0,
	[160705] = 0,
}

Sets.Defaults = {
	reagents = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE and 4 or 0,
	warbound = 5,
	gearLvl = 0.9,
	iLvl = 0.9
}


--[[ Startup ]]--

function Sets:OnLoad()
	for id, tag in pairs(self.BaseTags) do
		local r,g,b,a = unpack(tag.color)

		tag.id, tag.color = id, {r=r, g=g, b=b, a=a or 1}
		tag.glow, tag.stamp, tag.auto = true, true, true, true
		tag.limit = tag.limit or math.huge

		if tag.event then
			self:RegisterEvent(tag.event, function() tag:callback() end)
			tag:callback()
		end
	end

	Scrap2Character = self:SetDefaults(Scrap2Character or {}, self.Defaults)
	Scrap2Account = self:SetDefaults(Scrap2Account or {}, {
		tags = self.BaseTags,
		list = self.BaseList
	})

	Scrap2.Filters = Scrap2Character
	Scrap2.Tags = Scrap2Account.tags
    Scrap2.List = Scrap2Account.list

	--[[for i = 1,10000 do
		local k = 0
		while not C_Item.GetItemInfoInstant(k) do
			k = fastrandom(1, 50000)
		end

		Scrap2.List[k] = fastrandom(0,3)
	end]]--
end

function Sets:IsPlayerEnchanter()
	for i, profession in ipairs{ GetProfessions() } do
		local lineID = profession and select(7, GetProfessionInfo(profession))
		local info = lineID and C.TradeSkillUI.GetProfessionInfoBySkillLineID(lineID)
		if info and info.profession == Enum.Profession.Enchanting then
			return true
		end
	end
end