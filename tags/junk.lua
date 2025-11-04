--[[
    Copyright 2008-2025 João Cardoso, All Rights Reserved
    Behaviour specific to the junk tag.
--]]

local C = LibStub('C_Everywhere')
local Junk = Scrap2:NewTag {
    id = 1, name = 'Junk',
    icon = 'lootroll-toast-icon-greed-up',
    color = ITEM_QUALITY_COLORS[0].color,
}

function Junk:Filter(id, location)
    local _, link, quality, level,_,_,_,_, slot, _, value, class, subclass, bind = C.Item.GetItemInfo(id)
    if quality == Enum.ItemQuality.Poor then
		return bind ~= Enum.ItemBind.OnEquip
    end
end