local WoWTest = LibStub('WoWTest-1.0')
local Replace = WoWTest.Replace
local Tests = WoWTest:New()

local function NotJunk(id)
	Replace('Scrap_LowConsume', true)
	Replace('Scrap_LowEquip', true)

	return WoWTest.IsFalse(
		Scrap:CheckFilters(id))
end

function Tests:ChefHat()
	NotJunk(46349)
end

function Tests:VanityUsable()
	NotJunk(50471)
end