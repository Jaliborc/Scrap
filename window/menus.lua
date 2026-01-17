--[[
	Copyright 2008-2025 João Cardoso, All Rights Reserved
	Context menus for addon configuration.
--]]

local Menus = Scrap2:NewModule('Menus')
local Sushi = LibStub('Sushi-3.2')

local EDIT =  '|TInterface/Addons/Scrap/art/t:14:14:0:0:32:32:0:32:0:32:255:209:0|t ' .. EDIT
local DELETE = '|TInterface/Addons/Scrap/art/bin:14|t ' .. DELETE
local NONE = Menus.None


--[[ Utils ]]--

local function bright(v)
	return min(sqrt(v), 1)
end

local function signal(call)
	return function(...)
		call(...)
		Menus:SendSignal('TAGS_CHANGED')
	end
end

local function toggle(table, key)
	return function() return table[key] end,
		signal(function() table[key] = not table[key] end)
end

local function colorpicker(color)
	local r,g,b,a = ColorMixin.GetRGBA(color)
	local info = {
		hasOpacity = 1,
		r = r, g = g, b = b, opacity = a or 1,
		swatchFunc = signal(function() color.r, color.g, color.b = ColorPickerFrame:GetColorRGB() end),
		opacityFunc = signal(function() color.a = ColorPickerFrame:GetColorAlpha() end),
		cancelFunc = signal(function(v) ColorMixin.SetRGBA(color, ColorMixin.GetRGBA(v)) end)
	}

	return function() ColorPickerFrame:SetupColorPickerAndShow(info) end, info
end

local function taglist(parent, key, incompatible)
	for id, tag in pairs(tFilter(Scrap2.Tags, function(tag) return not tContains(incompatible or NONE, tag.id) end)) do
		if tag then
			local hex = tag.color and RGBToColorCode(bright(tag.color.r), bright(tag.color.g), bright(tag.color.b)) or WHITE_FONT_COLOR_CODE
			local get = function() return (Scrap2.Classifier[key] or 0) == tag.id end
			local set = function()
				Scrap2.Classifier[key] = tag.id
				Scrap2:SendSignal('LIST_CHANGED')
			end

			parent:CreateRadio(format('%s%s|r' .. Scrap2.MENU_SUFFIX, hex, tag.name), get, set)
			      :AddInitializer(Scrap2.Picker:Initializer(tag))
		end
	end
end

local function slider(parent, table, key)
	local proxy = parent:CreateTemplate('Scrap2SliderTemplate')
	proxy:AddResetter(function(f) f.Edit:Release() end)
	proxy:AddInitializer(function(f)
		local v = (table[key] or 0.7) * 100
		local mutator = function(v)
			v = min(max(tonumber(v) or 100, 1), 100)
			table[key] = v / 100

			f.Slider:SetValue(v)
			f.Edit:SetValue(Round(v))
			Menus:SendSignal('LIST_CHANGED')
		end

		f.Slider:SetMutatorFunction(mutator)
		f.Edit = Sushi.DarkEdit(f, nil, '%s%')
		f.Edit:SetCall('OnText', function(_,v) mutator(v) end)
		f.Edit:SetPoint('RIGHT', -8,0)
		f.Edit:SetNumeric(true)

		mutator(v)
	end)
end


--[[ API ]]--

function Menus:ItemFilters(drop)
	drop:SetTag('Scrap2_ItemFilters')
	drop:CreateTitle('Equipment')

	taglist(drop:CreateButton('Uncollected'), 'uncollected')
	taglist(drop:CreateButton('Unusable'), 'unusable', {4,5})

	local lowLevel = drop:CreateButton('Low Level')
	taglist(lowLevel:CreateButton('Soulbound'), 'soulboundGear', {4,5})

	if Scrap2.Tags[4] then
		taglist(lowLevel:CreateButton('Warbound'), 'warboundGear', {5})
	end
	
	taglist(lowLevel:CreateButton('Other'), 'otherGear')
	slider(lowLevel, Scrap2.Classifier, 'gearLvl')

	drop:CreateDivider()
	drop:CreateTitle('Consumables')

	taglist(drop:CreateButton('Low Level'), 'consumables', {2})
	slider(drop, Scrap2.Classifier, 'iLvl')

	drop:CreateDivider()
	drop:CreateTitle('Other')

	taglist(drop:CreateButton('Reagents'), 'reagents', {2})

	if Scrap2.Tags[4] then
		taglist(drop:CreateButton('Warbound'), 'warbound', {2,5})
	end
end

function Menus:TagOptions(tag)
	return function(_, drop)
		drop:SetTag('Scrap2_TagOptions')
		drop:CreateTitle(tag.name)
		drop:CreateCheckbox('Show Icon', toggle(tag, 'stamp'))
		drop:CreateCheckbox('Glow', toggle(tag, 'glow')):CreateColorSwatch('Color', colorpicker(tag.color))
		drop:QueueDivider()

		if tag.id == 1 then
			drop:CreateCheckbox('Auto Sell', toggle(tag, 'sell'))
			drop:CreateCheckbox('Safe Sell', toggle(tag, 'safe'))
		elseif tag.id >= 3 and tag.id <= 5 then
			drop:CreateCheckbox('Auto Deposit', toggle(tag, 'deposit'))
		elseif tag.id >= 50 then
			drop:CreateButton(EDIT, function() Scrap2.Frame.EditPopup:Display(tag) end)
			drop:CreateButton(DELETE, function()
				Sushi.Popup {
					text = format('Are you sure you want to delete |cnNORMAL_FONT_COLOR:|A:%s:14:14|a %s|r across all lists?\nThis action cannot be undone.', tag.atlas, tag.name), button1 = OKAY, button2 = CANCEL,
					OnAccept = function() Scrap2.Frame.EditPopup:SaveTag(tag.id, nil) end,
					whileDead = 1, exclusive = 1, hideOnEscape = 1
				}
			end)
		end
	end
end