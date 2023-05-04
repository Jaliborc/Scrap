local Tests = WoWUnit and WoWUnit('Scrap')
if not Tests then return end
local Replace, IsFalse = WoWUnit.Replace, WoWUnit.IsFalse

local function NotJunk(id)
	Replace(Scrap, 'junk', Scrap.BaseList.__index)
	Replace(Scrap, 'charsets', {consumable = true, equip = true, auto={}})

	return IsFalse(Scrap:IsJunk(id))
end

function Tests:GrayShoulders()
	NotJunk(1769)
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
