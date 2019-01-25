local L = Scrap_Locals
local Locale = GetLocale()
if Locale ~= 'zhTW' and Locale ~= 'zhCN' then return end

L.Add = "添加到垃圾清單"
L.Added = "%s 已添加到垃圾清單"
L.AdvancedOptions = "進階設定"

L.AutoSell = "自動出售"
L.AutoSellTip = "開啟此功能，Scrap 會在你訪問商人時自動出售所有垃圾。"
L.AutoRepair = "自動修理"
L.AutoRepairTip = "開啟此功能，Scrap 會在你訪問商人時自動修理裝備。"
L.GuildRepair = "公會修理"

L.Junk = "垃圾"
L.Learn = "智能學習"
L.LearnTip = "開啟此功能，Scrap 會學習哪些物品經常被你出售，而將該物分類為垃圾。"
L.Loading = "載入中..."
L.LowConsume = "低等級消耗品"
L.LowConsumeTip = "開啟此功能，Scrap 會自動出售|cffff2020任何|r等級較你人物低的消耗品。"
L.LowEquip = "低等裝備"
L.LowEquipTip = "開啟此功能，Scrap 會自動出售|cffff2020任何|r等級較你人物身上裝備低的已綁定裝備。"
L.MissingOptions = "由於插件%s導致\"Scrap Options\" 無法載入"
L.NotJunk = "非垃圾"
L.Description = "這些選項讓你可更詳盡的設定 Scrap。\n不留垃圾！"

L.Glow = "泛光邊框"
L.GlowTip = "開啟此功能，垃圾物品上會有|cffBBBBBB灰色的|r泛光邊框。"
L.Icons = "金幣圖示"
L.IconsTip = "開啟此功能，垃圾物品上會有金幣的小圖示。"

L.Remove = "從垃圾清單移除"
L.Removed = "%s 已從垃圾清單移除"
L.SafeMode = "安全模式"
L.SafeModeTip = "開啟此功能，Scrap 一次最多只會賣出 12 項物品，讓你能再度買回。"
L.SellJunk = "出售垃圾"
L.ShowTutorials = "顯示教學"
L.SoldJunk = "出售垃圾獲得 %s"
L.Repaired = "修理裝備花費 %s"
L.ToggleJunk = "切換物品是否為垃圾"

L.Tutorial_Welcome = "歡迎使用 |cffffd200Scrap|r，這是一個聰明的垃圾出售插件，由 |cffffd200Jaliborc|r 製作。這個簡短的教學讓你知道如何出售垃圾物品。|n|n它能節省你的時間，而且你的背包一定會很喜歡它的，讓我們開始吧！"
L.Tutorial_Button = "當你訪問商人的時候，Scrap 會自動出售你的垃圾，但你也能手動出售。|n|cffffd200左鍵點擊|r Scrap 按鈕出售垃圾。|n|cffffd200右鍵點擊|r Scrap 按鈕開啟下拉選單。"
L.Tutorial_Drag = "如果你想教 Scrap 知道哪些該賣、哪些不該賣的話，怎麼辦呢？只需要|cffffd200拖曳|r該項物品到 Scrap 按鈕上。|n|n或者，你可以到|cffffd200按鈕設定|r裡面，指定一個快捷鍵，切換游標下的物品是否該視為垃圾"
L.Tutorial_Visualizer = "要檢視有哪些物品被分類為垃圾，開啟 |cffffd200Scrap 檢視器|r 頁面。|n|n請注意這裡只會列出被你|cffffd200手動分類|r的物品，而不是遊戲中的每一項物品。"
L.Tutorial_Bye = "祝福你旅程愉快、|cffb400ff紫|r氣逼人。不留垃圾！"
