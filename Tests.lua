if not WoWUnit then
	return
end

local Replace, IsFalse = WoWUnit.Replace, WoWUnit.IsFalse
local Tests = WoWUnit('Scrap')

local function NotJunk(id)
	Replace(Scrap, 'Junk', Scrap_BaseList)
	Replace('Scrap_LowConsume', true)
	Replace('Scrap_LowEquip', true)

	return IsFalse(Scrap:IsJunk(id))
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