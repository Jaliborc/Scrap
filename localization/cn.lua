local L = LibStub('AceLocale-3.0'):NewLocale('Scrap', 'zhCN')
if not L then return end

-- general
L.Add = '添加到垃圾列表'
L.DestroyCheapest = '摧毁最便宜的垃圾物品'
L.DestroyJunk = '摧毁所有垃圾'
L.Forget = '忘记'
L.Junk = '垃圾'
L.JunkList = '垃圾列表'
L.NotJunk = '非垃圾'
L.SellJunk = '出售垃圾'
L.Remove = '从垃圾列表移除'
L.ToggleMousehover = '切换鼠标所指物品是否为垃圾'

-- chat
L.Added = '%s 已添加到垃圾列表'
L.Destroyed = '你摧毁了: %s x %s'
L.Forgotten = '忘记垃圾状态: %s'
L.GuildRepaired = '公会已为你支付了 %s 的修理费。'
L.SoldJunk = '出售垃圾获得 %s'
L.Repaired = '修理装备花费 %s'
L.Removed = '%s 已从垃圾列表移除'

-- dialogs
L.ConfirmDelete = '你确定要摧毁所有垃圾物品吗？此操作无法撤销。'

-- options
L.GeneralDescription = '这些选项让你可以更详尽地设置 Scrap。\n不留垃圾！'
L.ListDescription = '这些选项允许你进一步配置你的垃圾列表和自动垃圾检测。'

L.Behaviour = '行为'
L.AutoSell = '自动出售'
L.AutoSellTip = '开启此功能，Scrap 会在你访问商人时自动出售所有垃圾。'
L.AutoRepair = '自动修理'
L.AutoRepairTip = '开启此功能，Scrap 会在你访问商人时自动修理装备。'
L.DestroyWorthless = '摧毁无价值垃圾'
L.DestroyWorthlessTip = '开启此功能，Scrap 会自动摧毁商人不要的垃圾。'
L.GuildRepair = '公会修理'
L.GuildRepairTip = '开启此功能，Scrap 会优先使用公会资金进行修理。'
L.SafeMode = '安全模式'
L.SafeModeTip = '开启此功能，Scrap 一次最多只会卖出 12 件物品，让你能再度买回。'

L.Visuals = '视觉'
L.Glow = '高亮边框'
L.GlowTip = '开启此功能，垃圾物品上会有|cffBBBBBB灰色的|r高亮边框。'
L.Icons = '金币图标'
L.IconsTip = '开启此功能，垃圾物品上会有金币的小图标。'
L.SellPrices = '提示售价'
L.SellPricesTip = '开启此功能，即使不在商人那里也会在提示中显示物品的售价。'

L.CharSpecific = '角色特定'
L.Learning = '智能学习'
L.LearningTip = '开启此功能，Scrap 会学习哪些物品经常被你出售，而将该物品分类为垃圾。'
L.LowConsumable = '低等级消耗品'
L.LowConsumableTip = '开启此功能，Scrap 会自动出售|cffff2020任何|r等级较你人物低的消耗品。'
L.LowEquip = '低等级装备'
L.LowEquipTip = '开启此功能，Scrap 会自动出售|cffff2020任何|r等级较你人物身上装备低的已绑定装备。'
L.Unusable = '无法装备的装备'
L.UnusableTip = '开启此功能，Scrap 会自动出售|cffff2020任何|r你人物无法装备的已绑定装备。'
L.iLevelTreshold = '物品等级阈值'
L.EquipLevelTip = '控制物品被视为垃圾的物品等级阈值，基于你当前装备等级的百分比。|n|n例如：100% 时，低于你所穿装备等级的任何物品都为垃圾；50% 时，只有低于该等级一半的物品才为垃圾。'
L.ConsumableLevelTip = '控制消耗品被视为垃圾的物品等级阈值，按你的角色等级百分比计算。'

-- help
L.PatronsDescription = 'Scrap 是免费发布的，并通过赞助支持。非常感谢 Patreon 和 Paypal 上的所有赞助者，是你们让开发持续进行。你也可以在 |cFFF96854patreon.com/jaliborc|r 成为赞助者。'
L.HelpDescription = '这里提供了最常见问题的解答。我们也建议体验游戏内教程。如果都无法解决你的问题，可以考虑在 Discord 上的 Scrap 用户社区寻求帮助。'

L.FAQ = {
	'如何从垃圾列表中添加/移除物品？',
	'有多种方法：|n1) 最简单的方法是在拜访商人时将物品拖入 Scrap 按钮（位于装备修理按钮旁边）。|n2) 可以在 游戏 -> 按键设置 -> Scrap -> "切换鼠标所指物品是否为垃圾" 中设置快捷键。将鼠标悬停在物品上并按下快捷键即可切换。|n3) 可以在商人面板底部的 Scrap 标签页（位于回购标签页旁边）中管理已添加或移除的物品。',
	'Bagnon 物品上没有显示 Scrap 图标！',
	'该功能不是 Scrap 核心的一部分，而是一个独立的插件。尝试安装或更新 |cffffd200Bagnon Scrap Support|r。'
}

-- tutorials
L.Tutorial_Welcome = '欢迎使用 |cffffd200Scrap|r，这是一个智能的垃圾出售插件，由 |cffffd200Jaliborc|r 制作。这个简短的教程教你如何出售垃圾物品。|n|n它能节省你的时间，而且你的背包一定会很喜欢它，让我们开始吧！'
L.Tutorial_Button = '当你访问商人的时候，Scrap 会自动出售你的垃圾，但你也能手动出售。|n|cffffd200左键点击|r Scrap 按钮出售垃圾。|n|cffffd200右键点击|r Scrap 按钮开启下拉菜单。'
L.Tutorial_Drag = '如果你想教 Scrap 哪些该卖、哪些不该卖的话，怎么办呢？只需要|cffffd200拖曳|r该项物品 Scrap 按钮上。|n|n或者，你可以到|cffffd200按钮设置|r里，指定一个快捷键，切换鼠标所指的物品是否该是为垃圾'
L.Tutorial_Visualizer = '要查看有哪些物品被分类为垃圾，开启 |cffffd200Scrap 查看器|r 页面。|n|n请注意这里只会列出被你|cffffd200手动分类|r的物品，而不是游戏中的每一项物品。'
L.Tutorial_Bye = '祝你旅程愉快、|cffb400ff欧|r气逼人。不留垃圾！'
