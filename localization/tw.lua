local L = LibStub('AceLocale-3.0'):NewLocale('Scrap', 'zhTW')
if not L then return end

-- general
L.Add = '添加到垃圾清單'
L.DestroyCheapest = '摧毀最便宜的垃圾物品'
L.DestroyJunk = '摧毀所有垃圾'
L.Forget = '忘記'
L.Junk = '垃圾'
L.JunkList = '垃圾清單'
L.NotJunk = '非垃圾'
L.SellJunk = '出售垃圾'
L.Remove = '從垃圾清單移除'
L.ToggleMousehover = '切換物品是否為垃圾'

-- chat
L.Added = '%s 已添加到垃圾清單'
L.Destroyed = '你摧毀了: %s x %s'
L.Forgotten = '忘記了垃圾狀態: %s'
L.GuildRepaired = '公會已為你支付了 %s 的修理費。'
L.SoldJunk = '出售垃圾獲得 %s'
L.Repaired = '修理裝備花費 %s'
L.Removed = '%s 已從垃圾清單移除'

-- dialogs
L.ConfirmDelete = '你確實要摧毀所有垃圾物品嗎？此動作無法撤銷。'

-- options
L.GeneralDescription = '這些選項讓你可更詳盡的設定 Scrap。\n不留垃圾！'
L.ListDescription = '這些選項讓你可更進一步的設定垃圾清單和自動垃圾檢測。'

L.Behaviour = '行為'
L.AutoSell = '自動出售'
L.AutoSellTip = '開啟此功能，Scrap 會在你訪問商人時自動出售所有垃圾。'
L.AutoRepair = '自動修理'
L.AutoRepairTip = '開啟此功能，Scrap 會在你訪問商人時自動修理裝備。'
L.DestroyWorthless = '摧毀無價值的物品'
L.DestroyWorthlessTip = '開啟此功能，Scrap 會摧毀沒有商人售價的垃圾物品。'
L.GuildRepair = '公會修理'
L.GuildRepairTip = '開啟此功能，Scrap 會使用公會基金進行修理，優先於你的個人資金。'
L.SafeMode = '安全模式'
L.SafeModeTip = '開啟此功能，Scrap 一次最多只會賣出 12 項物品，讓你能再度買回。'

L.Visuals = '視覺'
L.Glow = '泛光邊框'
L.GlowTip = '開啟此功能，垃圾物品上會有|cffBBBBBB灰色的|r泛光邊框。'
L.Icons = '金幣圖示'
L.IconsTip = '開啟此功能，垃圾物品上會有金幣的小圖示。'
L.SellPrices = '工具提示價格'
L.SellPricesTip = '開啟此功能，即使不在商人那裡也會在工具提示中顯示物品的售價。'

L.CharSpecific = '角色專屬'
L.Learning = '智能學習'
L.LearningTip = '開啟此功能，Scrap 會學習哪些物品經常被你出售，而將該物分類為垃圾。'
L.LowConsumable = '低等級消耗品'
L.LowConsumableTip = '開啟此功能，Scrap 會自動出售|cffff2020任何|r等級較你人物低的消耗品。'
L.LowEquip = '低等裝備'
L.LowEquipTip = '開啟此功能，Scrap 會自動出售|cffff2020任何|r等級較你人物身上裝備低的已綁定裝備。'
L.Unusable = '不能使用的裝備'
L.UnusableTip = '開啟此功能，Scrap 會自動出售|cffff2020任何|r不能由你的角色使用的已綁定裝備。'
L.iLevelTreshold = '物品等級門檻'
L.EquipLevelTip = '控制物品被視為垃圾的物品等級門檻，基於你當前裝備等級的百分比。|n|n例如：100% 時，低於你所穿裝備等級的任何物品都為垃圾；50% 時，只有低於該等級一半的物品才為垃圾。'
L.ConsumableLevelTip = '控制消耗品被視為垃圾的物品等級門檻，按你的角色等級百分比計算。'

-- help
L.PatronsDescription = 'Scrap 是免費發布的，並透過贊助支持。非常感謝 Patreon 和 Paypal 上的所有贊助者，是你們讓開發持續進行。你也可以在 |cFFF96854patreon.com/jaliborc|r 成為贊助者。'
L.HelpDescription = '這裡提供了最常見問題的解答。我們也建議體驗遊戲內教學。如果都無法解決你的問題，可以考慮在 Discord 上的 Scrap 用戶社群尋求幫助。'

L.FAQ = {
	'如何從垃圾清單中添加/移除物品？',
	'有幾種方式：|n1) 最簡單的方法是在拜訪商人時將物品拖曳至 Scrap 按鈕（位於裝備修理按鈕旁）。|n2) 可以在 遊戲選單 -> 按鍵設定 -> Scrap -> "切換物品是否為垃圾" 中設定快捷鍵。將游標移至物品上方並按下快捷鍵即可切換。|n3) 可以在商人介面底部的 Scrap 分頁（位於買回分頁旁）中管理已添加或移除的物品。',
	'Bagnon 物品上沒有顯示 Scrap 圖示！',
	'該功能並非 Scrap 核心的一部分，而是一個獨立的插件。嘗試安裝或更新 |cffffd200Bagnon Scrap Support|r。'
}

-- tutorials
L.Tutorial_Welcome = '歡迎使用 |cffffd200Scrap|r，這是一個聰明的垃圾出售插件，由 |cffffd200Jaliborc|r 製作。這個簡短的教學讓你知道如何出售垃圾物品。|n|n它能節省你的時間，而且你的背包一定會很喜歡它的，讓我們開始吧！'
L.Tutorial_Button = '當你訪問商人的時候，Scrap 會自動出售你的垃圾，但你也能手動出售。|n|cffffd200左鍵點擊|r Scrap 按鈕出售垃圾。|n|cffffd200右鍵點擊|r Scrap 按鈕開啟下拉選單。'
L.Tutorial_Drag = '如果你想教 Scrap 知道哪些該賣、哪些不該賣的話，怎麼辦呢？只需要|cffffd200拖曳|r該項物品到 Scrap 按鈕上。|n|n或者，你可以到|cffffd200按鈕設定|r裡面，指定一個快捷鍵，切換游標下的物品是否該視為垃圾'
L.Tutorial_Visualizer = '要檢視有哪些物品被分類為垃圾，開啟 |cffffd200Scrap 檢視器|r 頁面。|n|n請注意這裡只會列出被你|cffffd200手動分類|r的物品，而不是遊戲中的每一項物品。'
L.Tutorial_Bye = '祝福你旅程愉快、|cffb400ff紫|r氣逼人。不留垃圾！'
