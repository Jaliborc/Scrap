local Replace = WoWTest.Replace
local Tests = WoWTest('Scrap')

local function NotJunk(id)
	Replace('Scrap_Junk', Scrap_BaseList)
	Replace('Scrap_LowConsume', true)
	Replace('Scrap_LowEquip', true)

	return WoWTest.IsFalse(
		Scrap:IsJunk(id))
end

function Tests:ChefHat()
	NotJunk(46349)
end

function Tests:Fishing()
	NotJunk(33820)
	NotJunk(19969)
end

function Tests:VanityUsable()
	NotJunk(50471)
end