--[[
	Copyright 2008-2025 João Cardoso, All Rights Reserved
	Context menus for addon configuration.
--]]

local Menus = Scrap2:NewModule('Menus', 'MutexDelay-1.0')
local Sushi = LibStub('Sushi-3.2')

local EDIT =  '|TInterface/Addons/Scrap2/art/t:14:14:0:0:32:32:0:32:0:32:255:209:0|t ' .. EDIT
local DELETE = '|TInterface/Addons/Scrap2/art/bin:14|t ' .. DELETE
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

local function tagSwitch(row, key, incompatible)
	row:SetResponse(MenuResponse.Open)
	row:AddInitializer(function(row)
		local marker = row:AttachTexture()
		marker:SetAtlas('common-dropdown-tickradial')
		marker:SetDrawLayer('OVERLAY')
		marker:SetSize(10, 10)

		local fill = row:AttachTexture()
		fill:SetAtlas('common-dropdown-icon-radialtick-yellow')
		fill:SetDrawLayer('OVERLAY', 1)
		fill:SetAllPoints(marker)

		local text = row.fontString
		local offset = 4

		local function selected(option, color)
			text:SetTextColor(bright(color.r), bright(color.g), bright(color.b))
			marker:SetPoint('BOTTOMRIGHT', option, 'BOTTOMRIGHT', 2, -2)
			marker:SetParent(option)
			fill:SetParent(option)
		end

		for id, tag in pairs(Scrap2.Tags) do
			if tag.enabled and not tContains(incompatible or NONE, tag.id) then
				local color = tag.color
				local hex = color and RGBToColorCode(bright(color.r), bright(color.g), bright(color.b))
				local icon = tag.icon or tag.atlas or 'capacitance-general-workordercheckmark'

				local option = MenuTemplates.AttachBasicButton(row, 16, 16)
				option:SetHighlightTexture(icon, 'ADD')
				option:SetPoint('RIGHT', -offset, 0)
				option:RegisterForClicks('AnyUp')
				option:SetNormalTexture(icon)
				option:SetScript('OnClick', function(option)
					if (Scrap2.Filters[key] or 0) ~= tag.id then
						selected(option, tag.color)
						
						PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
						Scrap2.Filters[key] = tag.id
						Scrap2:SendSignal('LIST_CHANGED')
					end
				end)

				MenuTemplates.SetUtilityButtonTooltipText(option, hex .. tag.name .. '|r')
				if (Scrap2.Filters[key] or 0) == tag.id then
					selected(option, tag.color)
				end

				offset = offset + 20
			end
		end

		return math.ceil(text:GetStringWidth()) + offset + 4, math.max(text:GetHeight(), 16)
	end)
end

local function slider(parent, key)
	local proxy = parent:CreateTemplate('Scrap2SliderTemplate')
	proxy:AddResetter(function(f) f.Edit:Release() end)
	proxy:AddInitializer(function(f)
		local v = (Scrap2.Filters[key] or 0.7) * 100
		local mutator = function(v)
			v = min(max(tonumber(v) or 100, 1), 100)
			Scrap2.Filters[key] = v / 100

			f.Slider:SetValue(v)
			f.Edit:SetValue(Round(v))
			Menus:Delay(0.1, 'SendSignal', 'LIST_CHANGED')
		end

		f.Slider:SetMutatorFunction(mutator)
		f.Edit = Sushi.DarkEdit(f, nil, '%s%')
		f.Edit:SetCall('OnText', function(_,v) mutator(v) end)
		f.Edit:SetPoint('RIGHT', -8,0)
		f.Edit:SetNumeric(true)

		mutator(v)
	end)
	return proxy
end


--[[ API ]]--

function Menus:ItemFilters(drop)
	drop:SetTag('Scrap2_ItemFilters')
	drop:CreateTitle('Equipment')

	local lowLevel = drop:CreateButton('Low Level')
	tagSwitch(lowLevel:CreateButton('Soulbound'), 'soulboundGear', {4,5})

	if Scrap2.Tags[5] then
		tagSwitch(lowLevel:CreateButton('Warbound'), 'warboundGear', {5})
	end
	
	tagSwitch(lowLevel:CreateButton('Other'), 'otherGear')
	slider(lowLevel, 'gearLvl'):SetTooltip(function(tip)
		GameTooltip_SetTitle(tip, 'Item Level Threshold')
		GameTooltip_AddNormalLine(tip, 'Controls how low item level needs to be considered low-level. For example, a 50% means the item needs to be half the level of the item you have equipped on that slot.')
	end)

	tagSwitch(drop:CreateButton('Unusable'), 'unusable', {4,5})
	tagSwitch(drop:CreateButton('Uncollected'), 'uncollected')

	drop:CreateDivider()
	drop:CreateTitle('Consumables')

	tagSwitch(drop:CreateButton('Low Level'), 'consumables', {2})
	slider(drop, 'iLvl'):SetTooltip(function(tip)
		GameTooltip_SetTitle(tip, 'Item Level Threshold')
		GameTooltip_AddNormalLine(tip, 'Controls how low an item requirement needs to be considered low-level. For example, a 50% means the item needs to be half your character level.')
	end)

	drop:CreateDivider()
	drop:CreateTitle('Other')

	tagSwitch(drop:CreateButton('Reagents'), 'reagents', {2})

	if Scrap2.Tags[5] then
		tagSwitch(drop:CreateButton('Warbound'), 'warbound', {2,5})
	end
end

function Menus:TagOptions(tag)
	return function(_, drop)
		drop:SetTag('Scrap2_TagOptions')
		drop:CreateTitle(tag.name)
		drop:CreateCheckbox('Enabled', toggle(tag, 'enabled'))
		drop:CreateCheckbox('Show Icon', toggle(tag, 'stamp'))
		drop:CreateCheckbox('Glow', toggle(tag, 'glow')):CreateColorSwatch('Color', colorpicker(tag.color))
		drop:QueueDivider()

		if tag.id == 1 then
			drop:CreateCheckbox('Auto Sell', toggle(tag, 'sell'))
			drop:CreateCheckbox('Safe Sell', toggle(tag, 'safe'))
		elseif tag.id >= 4 and tag.id <= 6 then
			drop:CreateCheckbox('Auto Deposit', toggle(tag, 'deposit'))
		elseif tag.id >= 50 then
			drop:CreateButton(EDIT, function() Scrap2.Frame.EditPopup:Display(tag) end)
			drop:CreateButton(DELETE, function()
				Sushi.Popup {
					text = format('Are you sure you want to delete |cnNORMAL_FONT_COLOR:|A:%s:14:14|a %s|r across all lists?\nThis action cannot be undone.', tag.atlas, tag.name), button1 = OKAY, button2 = CANCEL,
					OnAccept = function() Scrap2.Frame.EditPopup:SaveTag(tag.id, nil) end,
					whileDead = 1, exclusive = 1, hideOnEscape = 1 }
			end)
		end
	end
end