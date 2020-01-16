local L = LibStub('AceLocale-3.0'):NewLocale('Scrap', 'enUS', true, true)

-- main
L.Add = 'Set as Junk'
L.Added = 'Set as junk: %s'
L.DestroyJunk = 'Destroy Junk'
L.SellJunk = 'Sell Junk'
L.SoldJunk = 'You sold your junk for %s'
L.Remove = 'Set as Useful'
L.Removed = 'Set as useful: %s'
L.Repaired = 'You repaired your armor for %s'
L.ToggleMousehover = 'Toggle Item Under Cursor'

-- dialogs
L.ConfirmDelete = 'Are you sure you want to destroy all your junk items? You cannot undo this action.'

-- visualizer
L.Junk = 'Junk'
L.NotJunk = 'Useful'

-- options
L.CharSpecific = 'Character Specific Junk List'
L.Description = 'These options allow you to configure Scrap even further. The trash shall not pass!'

L.AutoSell = 'Automatically Sell'
L.AutoSellTip = 'If enabled, Scrap will automatically sell your junk when you visit a merchant.'
L.AutoRepair = 'Automatically Repair'
L.AutoRepairTip = 'If enabled, Scrap will automatically repair your armor when you visit a merchant.'
L.DestroyWorthless = 'Destroy Worthless'
L.DestroyWorthlessTip = 'If enabled, Scrap will destroy junk items with no vendor sale value.'
L.GuildRepair = 'Use Guild Funds'
L.GuildRepairTip = 'If enabled, Scrap will use available guild funds for repairs before your own money.'
L.Glow = 'Glowing Borders'
L.GlowTip = 'If enabled, |cffBBBBBBgray|r glowing borders will appear on your Scrap items.'
L.Icons = 'Coin Icons'
L.IconsTip = 'If enabled, small gold coins will appear on your Scrap items.'
L.Learning = 'Usage Learning'
L.LearningTip = 'If enabled, Scrap will learn which items you usually sell to the merchant and |cffff2020automatically|r consider them junk.'
L.LowConsume = 'Low Consumables'
L.LowConsumeTip = 'If enabled, Scrap will sell |cffff2020any|r consumable which is too low for your level.'
L.LowEquip = 'Low Equipment'
L.LowEquipTip = 'If enabled, Scrap will sell |cffff2020any|r soulbound equipment which has a much lower value than the one you are wearing.'
L.SafeMode = 'Safe Mode'
L.SafeModeTip = 'If enabled, Scrap will not sell more than 12 items at once, so that you may always buy them back.'
L.Unusable = 'Unusable Equipment'
L.UnusableTip = 'If enabled, Scrap will sell |cffff2020any|r soulbound equipment that could never be used by your character.'

-- tutorials
L.Tutorial_Welcome = 'Welcome to |cffffd200Scrap|r, the intelligent junk vending solution by |cffffd200Jaliborc|r. This short tutorial will help you to get started selling your junk items.|n|nIt will save you time, and your pockets will certainly appreciate. Shall we get started?'
L.Tutorial_Button = 'Scrap will automatically sell all your junk whenever you visit a merchant. But you can manually sell it: simply |cffffd200Left-Click|r on the Scrap button.|n|n|cffffd200Right-Click|r on the button to bring extra options.'
L.Tutorial_Drag = 'What if you want to tell Scrap which items to sell or not? Simply |cffffd200Drag|r it from your bags into the Scrap button.|n|nAlternatively, you may set a |cffffd200Keybinding|r at the |cffffd200Game Menu|r options. Press it while hovering the item.'
L.Tutorial_Visualizer = 'To see what items you have specified as junk or not, open the |cffffd200Scrap Visualizer|r tab.|n|nNotice it will only display items which you have |cffffd200specified|r, not every single item in-game.'
L.Tutorial_Bye = 'Good luck on your journeys, and may |cffb400ffthe epics|r be with you. The trash shall not pass!'
