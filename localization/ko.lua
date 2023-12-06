local L = LibStub('AceLocale-3.0'):NewLocale('Scrap', 'koKR') -- by Jaliborc, 강남쌍칼(GangnamDualblade)
if not L then return end

-- main
L.Add = '잡템으로 설정'
L.DestroyCheapest = '가장 싼 잡템 파괴'
L.DestroyJunk = '모든 잡템 파괴'
L.Forget = '잊어버리다'
L.Junk = '잡템'
L.NotJunk = '예외 아이템'
L.SellJunk = '잡템 판매'
L.Remove = '예외 아이템으로 설정'
L.ToggleMousehover = '커서 아래의 아이템을 잡템으로 온/오프'

-- chat
L.Added = '잡템으로 설정: %s'
L.Destroyed = '파괴됨: %s x %s'
L.Forgotten = '잡템 상태를 잊어버림: %s'
L.SoldJunk = '잡템을 판매하고 %s를 획득하였습니다.'
L.Repaired = '장비를 수리하는데 %s를 소모하였습니다.'
L.Removed = '예외 아이템으로 설정: %s'

-- dialogs
L.ConfirmDelete = '모든 잡템을 파괴하시겠습니까? 이 작업은 취소할 수 없습니다.'

-- options
L.GeneralDescription = '이러한 일반적인 기능들은 당신의 선호도에 따라 활성화/비활성화할 수 있습니다. 잡템은 잡템일 뿐!'
L.ListDescription = '이러한 옵션을 통해 잡템 목록 및 자동 잡템 탐지를 더욱 구성할 수 있습니다.'

L.AutoSell = '자동 판매'
L.AutoSellTip = '활성화된 경우, 상점을 방문하면 자동으로 잡템을 판매합니다.'
L.AutoRepair = '자동 수리'
L.AutoRepairTip = '활성화된 경우, 상점을 방문하면 자동으로 장비를 수리합니다.'
L.CharSpecific = '캐릭터 별'
L.DestroyWorthless = '가치없는 것 파괴'
L.DestroyWorthlessTip = '활성화하면, 판매 가치가 없는 잡템은 파괴됩니다.'
L.GuildRepair = '길드 자금 사용'
L.GuildRepairTip = '활성화된 경우, 수리에 길드 자금을 사용합니다.'
L.Glow = '테두리 강조'
L.GlowTip = '활성화된 경우. 잡템에 |cffBBBBBB회색|r으로 강조된 테두리가 표시됩니다.'
L.Icons = '동전 아이콘'
L.IconsTip = '활성화된 경우, 잡템 위에 작은 금화 아이콘이 표시됩니다.'
L.SellPrices = '툴팁에 가격 표시'
L.SellPricesTip = '활성화된 경우, 상점에서 아닌 상태에서도 아이템의 판매 가격이 툴팁에 표시됩니다.'
L.Learning = '지능형 학습'
L.LearningTip = '활성화된 경우, 자주 상인에게 판매되는 아이템을 Scrap이 자동으로 잡템으로 인식할 수 있도록 학습합니다.'
L.LowConsume = '저 레벨용 소모품'
L.LowConsumeTip = '활성화된 경우, 현재 캐릭터의 레벨보다 현저히 낮은 레벨의 소모품은 |cffff2020모두|r 판매합니다.'
L.LowEquip = '저 레벨용 장비'
L.LowEquipTip = '활성화된 경우, 현재 착용 중인 장비보다 현저히 낮은 가치의 귀속 아이템은 |cffff2020모두|r 판매합니다.'
L.SafeMode = '안전 모드'
L.SafeModeTip = '활성화된 경우, 항상 재매입이 가능하도록 한번에 12개 이상의 아이템은 판매하지 않습니다.'
L.Unusable = '사용 불가 장비'
L.UnusableTip = '활성화된 경우, 당신의 캐릭터가 절대로 사용할 수 없는 귀속 장비를 판매합니다.'

-- tutorials
L.Tutorial_Welcome = '|cffffd200Scrap|r(제작자 |cffffd200Jaliborc|r), 지능형 잡템 판매 솔루션에 오신 것을 환영합니다. 이 짧은 튜토리얼은 잡템 판매를 시작하는 데 도움을 드리게 될 것입니다. |n|n당신의 시간을 절약하고 가방 관리가 한결 편해질 겁니다. 자 시작해 볼까요?'
L.Tutorial_Button = 'Scrap은 당신이 상점을 방문할 때 모든 잡템을 자동으로 판매합니다. 하지만 수동으로 판매할 수도 있습니다: Scrap 버튼을 간단히 |cffffd200Left-Click|r 하십시요.|n|n|cffffd200Right-Click|r 하시면 추가적인 옵션을 보실 수 있습니다.'
L.Tutorial_Drag = '어떤 아이템을 판매하고 어떤 아이템은 판매하면 안 되는지를 Scrap에게 알려주려면 어떻게 할까요? 가방에 있는 아이템을 Scrap 버튼 위로 간단히 |cffffd200드래그|r하세요.|n|n또는, |cffffd200게임 메뉴|r 옵션에서 |cffffd200키 설정|r을 하시면 됩니다. 아이템 위에 마우스를 올리고 설정된 키를 누르세요.'
L.Tutorial_Visualizer = '어떤 아이템이 잡템으로 등록되었는지 확인하려면, |cffffd200잡템 목록|r 탭을 열어 보세요.|n|n게임 내의 모든 잡템이 아니라 당신이 |cffffd200지정한|r 아이템들만 표시한다는 점을 명심하세요.'
L.Tutorial_Bye = '당신의 여정에 행운과 |cffb400ff에픽 아이템|r이 늘 함께하길 바랍니다. 잡템은 잡템일 뿐!'
