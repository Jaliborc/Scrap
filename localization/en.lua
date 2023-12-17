local L = LibStub('AceLocale-3.0'):NewLocale('Scrap', 'enUS', true, true)

-- general
L.Add = 'Set as Junk'
L.DestroyCheapest = 'Destroy Cheapest Junk Item'
L.DestroyJunk = 'Destroy Junk'
L.Forget = 'Forget'
L.Junk = 'Junk'
L.JunkList = 'Junk List'
L.NotJunk = 'Useful'
L.SellJunk = 'Sell Junk'
L.Remove = 'Set as Useful'
L.ToggleMousehover = 'Toggle Item Under Mouse'

-- chat
L.Added = 'Set as junk: %s'
L.Destroyed = 'You destroyed: %s x %s'
L.Forgotten = 'Forgot junk status of: %s'
L.SoldJunk = 'You sold your junk for %s'
L.Repaired = 'You repaired your armor for %s'
L.Removed = 'Set as useful: %s'

-- dialogs
L.ConfirmDelete = 'Are you sure you want to destroy all your junk items? You cannot undo this action.'

-- options
L.GeneralDescription = 'These are general features that can be toggled depending on your preferences. The trash shall not pass!'
L.ListDescription = 'These options allow you to configure your junk list and automatic junk detection further.'

L.AutoSell = 'Automatically Sell'
L.AutoSellTip = 'If enabled, Scrap will automatically sell your junk when you visit a merchant.'
L.AutoRepair = 'Automatically Repair'
L.AutoRepairTip = 'If enabled, Scrap will automatically repair your armor when you visit a merchant.'
L.DestroyWorthless = 'Destroy Worthless'
L.DestroyWorthlessTip = 'If enabled, Scrap will destroy junk items with no vendor sale value.'
L.GuildRepair = 'Use Guild Funds'
L.GuildRepairTip = 'If enabled, Scrap will use available guild funds for repairs before your own money.'
L.SafeMode = 'Safe Mode'
L.SafeModeTip = 'If enabled, Scrap will not sell more than 12 items at once, so that you may always buy them back.'

L.Glow = 'Glowing Borders'
L.GlowTip = 'If enabled, |cffBBBBBBgray|r glowing borders will appear on your Scrap items.'
L.Icons = 'Coin Icons'
L.IconsTip = 'If enabled, small gold coins will appear on your Scrap items.'
L.SellPrices = 'Tooltip Prices'
L.SellPricesTip = 'If enabled, item sale prices will be shown in tooltips even when not at a merchant.'

L.CharSpecific = 'Character Specific'
L.Learning = 'Automatic Optimization'
L.LearningTip = 'If enabled, Scrap will watch and learn which items you usually sell to the merchant and |cffff2020automatically|r mark them junk.'
L.LowConsume = 'Low Consumables'
L.LowConsumeTip = 'If enabled, Scrap will sell |cffff2020any|r consumable which is too low for your level.'
L.LowEquip = 'Low Equipment'
L.LowEquipTip = 'If enabled, Scrap will sell |cffff2020any|r soulbound equipment which has a much lower value than the one you are wearing.'
L.Unusable = 'Unusable Equipment'
L.UnusableTip = 'If enabled, Scrap will sell |cffff2020any|r soulbound equipment that could never be used by your character.'
L.iLevelTreshold = 'Item Level Threshold'

-- help
L.PatronsDescription = 'Scrap is distributed for free and supported trough donations. A massive thank you to all the supporters on Patreon and Paypal who keep development alive. You can become a patron too at |cFFF96854patreon.com/jaliborc|r.'
L.HelpDescription = 'Here we provide answers to the most frequently asked questions. We also recommend following the ingame tutorial. If neither solve your problem, you might consider asking for help on the Scrap user community on discord.'

L.FAQ = {
    'How to add/remove an item from the junk list?',
    'There are multiple ways:|n1) The simplest is to drag the item into the Scrap button while at a merchant (next to the armour repair buttons).|n2) You can set up a keybinding under Game -> Keybindings -> Scrap -> "Toggle Item Under Mouse". You can then mouse over items in the inventory and press your keybind to toggle them as junk.|n3) You can manage the items you have added or removed to the list on the Scrap tab at the bottom of the merchant panel (next to the Buyback tab).',
    'The Scrap icon is not showing over items in Bagnon!',
    'That functionallity is not part of core Scrap, it is part of a separate plugin. Try installing or updating |cffffd200Bagnon Scrap Support|r.'
}

L.Tutorial_Welcome = 'Welcome to |cffffd200Scrap|r, the intelligent junk vending solution by |cffffd200Jaliborc|r.|n|nPlease start this short tutorial by |cffffd200visiting a merchant|r. It will save you time, and your pockets will certainly appreciate. Shall we get started?'
L.Tutorial_Button = 'Scrap will automatically sell all your junk whenever you visit a merchant. But you can manually sell it: simply |cffffd200Left-Click|r on the Scrap button.|n|n|cffffd200Right-Click|r on the button to bring extra options.'
L.Tutorial_Drag = 'What if you want to tell Scrap which items to sell or not? Simply |cffffd200Drag|r it from your bags into the Scrap button.|n|nAlternatively, you may set a |cffffd200Keybinding|r at the |cffffd200Game Menu|r options. Press it while hovering the item.'
L.Tutorial_Visualizer = 'To see what items you have specified as junk or not, open the |cffffd200Scrap Visualizer|r tab.|n|nNotice it will only display items which you have |cffffd200specified|r, not every single item in-game.'
L.Tutorial_Bye = 'Good luck on your journeys, and may the |cffb400ffEpics|r be with you. The trash shall not pass!'
