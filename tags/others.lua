Scrap2:NewTag {id = 2, name = 'Disenchant', icon = 'lootroll-toast-icon-disenchant-up', color = CreateColor(0.67, 0.439, 0.89)}
Scrap2:NewTag {id = 3, name = 'Bank', icon = 'GarrMission_CurrencyIcon-Material', iconScale = 0.8}
Scrap2:NewTag {id = 0, name = 'None'}

if Constants.InventoryConstants.NumAccountBankSlots then
    Scrap2:NewTag {id = 4, name = 'Warband', icon = 'warbands-icon', iconScale = 1.2}
end

if GuildBankFrame_LoadUI then
    Scrap2:NewTag {id = 5, name = 'Guild', icon = 'Interface/Addons/Scrap/art/banner'}
end