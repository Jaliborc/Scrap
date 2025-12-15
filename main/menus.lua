--[[
	Copyright 2008-2025 João Cardoso, All Rights Reserved
	Context menus for addon configuration.
--]]

local Menus = Scrap2:NewModule('Menus')
dump = DevTools_Dump


--[[ Utils ]]--

local function toggle(table, key)
	return function() return table[key] end,
		function() table[key] = not table[key] end
end

local function colorpicker(color)
	local r,g,b,a = ColorMixin.GetRGBA(color)
	local info = {
		hasOpacity = 1,
		r = r, g = g, b = b, opacity = a or 1,
		swatchFunc = function() color.r, color.g, color.b = ColorPickerFrame:GetColorRGB() end,
		opacityFunc = function() color.a = 1 - ColorPickerFrame:GetColorAlpha() end,
		cancelFunc = function(v)
			color.r, color.g, color.b = ColorMixin.GetRGBA(v)
			color.a = 1 - v.a
		end
	}

	return function() ColorPickerFrame:SetupColorPickerAndShow(info) end, info
end

local function bright(v)
	return min(sqrt(v), 1)
end

local function taglist(parent, key, ids)
	for _, id in ipairs(ids) do
		local tag = Scrap2.Tags[id]
		if tag then
			local hex = tag.color and RGBToColorCode(bright(tag.color.r), bright(tag.color.g), bright(tag.color.b)) or WHITE_FONT_COLOR_CODE
			local get = function() return (Scrap2.Sets[key] or 0) == tag.id end
			local set = function() Scrap2.Sets[key] = tag.id end

			parent:CreateRadio(format('%s%s|r', hex, tag.name), get, set)
			      :AddInitializer(Scrap2:TagMenuInitializer(tag))
		end
	end
end


--[[ ]]--

function Menus:RenameTag(tag)

end

function Menus:EditTag(tag)
	return function(_, drop)
		drop:SetTag('Scrap2_EditTag')
		drop:CreateTitle(tag.name)
		drop:CreateCheckbox('Show Icon', toggle(tag, 'stamp'))
		drop:CreateCheckbox('Glow', toggle(tag, 'glow')):CreateColorSwatch('Color', colorpicker(getmetatable(tag.color)))
		drop:QueueDivider()

		if tag.id == 1 then
			drop:CreateCheckbox('Auto Sell', toggle(tag, 'sell'))
			drop:CreateCheckbox('Safe Sell', toggle(tag, 'safe'))
		elseif tag.id >= 3 and tag.id <= 5 then
			drop:CreateCheckbox('Auto Deposit', toggle(tag, 'deposit'))
		end
	end
end

function Menus:SmartFilters(drop)
	drop:SetTag('Scrap2_SmartFilters')
	drop:CreateTitle('Equipment')

	taglist(drop:CreateButton('Unusable'), 'unusable', {1,2,0})

	local lowLevel = drop:CreateButton('Low Level')
	taglist(lowLevel:CreateButton('Soulbound'), 'equipSoulbound', {1,2,0})
	taglist(lowLevel:CreateButton('Warbound'), 'equipWarbound', {1,2,4,0})
	taglist(lowLevel:CreateButton('Other'), 'equipOther', {1,2,4,5,0})

	drop:CreateDivider()
	drop:CreateTitle('Consumables')

	taglist(drop:CreateButton('Low Level'), 'lowUsable', {1,4,5,0})

	drop:CreateDivider()
	drop:CreateTitle('Other')

	taglist(drop:CreateButton('Reagents'), 'reagents', {3,4,5,0})
	taglist(drop:CreateButton('Warbound'), 'warbound', {4,0})
end
