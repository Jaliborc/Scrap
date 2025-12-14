Scrap2:NewTag {id = 0, name = 'None'}
Scrap2:NewTag {id = 1, name = 'Junk', icon = 'Interface/Addons/Scrap/art/coin', color = ITEM_QUALITY_COLORS[0].color}
Scrap2:NewTag {id = 2, name = 'Disenchant', icon = 'Interface/Addons/Scrap/art/disenchant', color = CreateColor(0.67, 0.439, 0.89)}
Scrap2:NewTag {id = 3, name = 'Bank', icon = 'Interface/Addons/Scrap/art/crate', color = CreateColor(0.45, 0.32, 0.15)}

if Constants.InventoryConstants.NumAccountBankSlots then
    Scrap2:NewTag {id = 4, name = 'Warband', atlas = 'warbands-icon', color = CreateColor(0.45, 0.32, 0.15)}
end

if GuildBankFrame_LoadUI then
    Scrap2:NewTag {id = 5, name = 'Guild', icon = 'Interface/Addons/Scrap/art/banner', color = CreateColor(0.13, 0.18, 0.32)}
end