--[[
	Copyright 2008-2025 João Cardoso, All Rights Reserved
	Initalization of tags, lists and other settings.
--]]

local Sets = Scrap2:NewModule('Settings')
local L = LibStub('AceLocale-3.0'):GetLocale('Scrap2')

function Sets:OnLoad()
	for id, tag in ipairs(Scrap2.BaseTags) do
		local r,g,b = unpack(tag.color)

		tag.id, tag.color = id, {r=r, g=g, b=b}
		tag.glow, tag.stamp, tag.auto = true, true, true
		tag.limit = tag.limit or math.huge
	end

	Scrap2.Tags = self:SetDefaults({}, Scrap2.BaseTags)
    Scrap2.List = self:SetDefaults({}, Scrap2.BaseList)
	--Scrap2.Filters = self:SetDefaults({}, {})

	--[[for i = 1,10000 do
		local k = 0
		while not C_Item.GetItemInfoInstant(k) do
			k = fastrandom(1, 50000)
		end

		Scrap2.List[k] = fastrandom(0,3)
	end]]--
end

Scrap2.BaseTags = {
	[0] = {name = L.None, id=0},
	[1] = {name = L.Junk, icon = 'Interface/Addons/Scrap/art/coin', color = {ITEM_QUALITY_COLORS[0].color:GetRGB()}, limit = 12, safe = true},
	[2] = {name = L.Disenchant, icon = 'Interface/Addons/Scrap/art/disenchant', color = {0.67, 0.439, 0.89}},
	[3] = {name = L.Bank, icon = 'Interface/Addons/Scrap/art/crate', color = {0.45, 0.32, 0.15}, type = 0}
}

if Constants.InventoryConstants.NumAccountBankSlots then
	Scrap2.BaseTags[4] = {name = L.Warband, atlas = 'warbands-icon', color = {0.45, 0.32, 0.15}, type = 2}
end

if GuildBankFrame_LoadUI then
	Scrap2.BaseTags[5] = {name = L.Guild, icon = 'Interface/Addons/Scrap/art/banner', color = {0.13, 0.18, 0.32}, limit = 1, type = 1}
end

Scrap2.BaseList = {
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