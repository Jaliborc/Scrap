--[[
	Copyright 2008-2025 João Cardoso, All Rights Reserved
	Popup window and context menus for addon configuration.
--]]

local Editor = Scrap2.Frame.Editor
local Sushi = LibStub('Sushi-3.2')


--[[ Utils ]]--

local function bright(v)
	return min(sqrt(v), 1)
end

local function looks(call)
	return function(...)
		call(...)
		Scrap2:SendSignal('LOOK_CHANGED')
	end
end

local function toggle(table, key)
	return function() return table[key] end,
		looks(function() table[key] = not table[key] end)
end

local function colorpicker(color)
	local r,g,b,a = ColorMixin.GetRGBA(color)
	local info = {
		hasOpacity = 1,
		r = r, g = g, b = b, opacity = a or 1,
		swatchFunc = looks(function() color.r, color.g, color.b = ColorPickerFrame:GetColorRGB() end),
		opacityFunc = looks(function() color.a = ColorPickerFrame:GetColorAlpha() end),
		cancelFunc = looks(function(v) ColorMixin.SetRGBA(color, ColorMixin.GetRGBA(v)) end)
	}

	return function() ColorPickerFrame:SetupColorPickerAndShow(info) end, info
end

local function taglist(parent, key, ids)
	for _, id in ipairs(ids) do
		local tag = Scrap2.Tags[id]
		if tag then
			local hex = tag.color and RGBToColorCode(bright(tag.color.r), bright(tag.color.g), bright(tag.color.b)) or WHITE_FONT_COLOR_CODE
			local get = function() return (Scrap2.List[key] or 0) == tag.id end
			local set = function() Scrap2.List[key] = tag.id end

			parent:CreateRadio(format('%s%s|r', hex, tag.name), get, set)
			      :AddInitializer(Scrap2:TagInitializer(tag))
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

			f.Edit:SetValue(Round(v))
			f.Slider:SetValue(v)
		end

		f.Slider:SetMutatorFunction(mutator)
		f.Edit = Sushi.DarkEdit(f, nil, '%s%')
		f.Edit:SetCall('OnText', function(_,v) mutator(v) end)
		f.Edit:SetPoint('RIGHT', -8,0)
		f.Edit:SetNumeric(true)

		mutator(v)
	end)
end


--[[ Main API ]]--

function Editor:Popup(tag)
	local tag = tag or {name = 'New Tag', color = {r=1,g=1,b=1}, stamp = true}
	local icon = tag.atlas or GetRandomArrayEntry(Scrap2.IconChoices)
	local select = function(_, icon)
		self.BorderBox.SelectedIconArea.SelectedIconButton.Icon:SetAtlas(icon)
	end

	self.BorderBox.EditBoxHeaderText:SetText('Enter Tag Name:')
	self.BorderBox.IconTypeDropdown:SetScript('OnShow', self.Hide)
	self.BorderBox.IconSelectorEditBox:SetText(tag.name)

	self.IconSelector:SetSelectedCallback(select)
	self.IconSelector:SetSetupCallback(function(button, _, icon) button.Icon:SetAtlas(icon) end)
	self.IconSelector:SetSelectionsDataProvider(function(i) return Scrap2.IconChoices[i] end, function() return #Scrap2.IconChoices end)
	self.IconSelector:SetSelectedIndex(tIndexOf(Scrap2.IconChoices, icon))
	self.IconSelector:ScrollToSelectedIndex()

	select(_, icon)
	self.tag = tag
	self:Show()
end

function Editor:TagOptions(tag)
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
			drop:CreateButton('|A:AnimCreate_Icon_Text:14:14:0:0:255:209:0|a ' .. EDIT, function() self:Popup(tag) end)
			drop:CreateButton('|TInterface/Addons/Scrap/art/bin:14:14|t ' .. DELETE, function()
				Sushi.Popup {
					text = format('Are you sure you want to delete |cnNORMAL_FONT_COLOR:|A:%s:14:14|a %s|r across all lists?\nThis action cannot be undone.', tag.atlas, tag.name), button1 = OKAY, button2 = CANCEL,
					whileDead = 1, exclusive = 1, hideOnEscape = 1,
					OnAccept = function() self:SetTag(tag.id) end
				}
			end)
		end
	end
end

function Editor:SmartFilters(drop)
	drop:SetTag('Scrap2_SmartFilters')
	drop:CreateTitle('Equipment')

	taglist(drop:CreateButton('Unusable'), 'unusable', {1,2,0})

	local lowLevel = drop:CreateButton('Low Level')
	taglist(lowLevel:CreateButton('Soulbound'), 'soulboundGear', {1,2,0})
	taglist(lowLevel:CreateButton('Warbound'), 'warboundGear', {1,2,4,0})
	taglist(lowLevel:CreateButton('Other'), 'otherGear', {1,2,4,5,0})
	slider(lowLevel, Scrap2.List, 'gearLvl')

	drop:CreateDivider()
	drop:CreateTitle('Consumables')

	taglist(drop:CreateButton('Low Level'), 'lowUsable', {1,4,5,0})
	slider(drop, Scrap2.List, 'iLvl')

	drop:CreateDivider()
	drop:CreateTitle('Other')

	taglist(drop:CreateButton('Reagents'), 'reagents', {3,4,5,0})
	taglist(drop:CreateButton('Warbound'), 'warbound', {4,0})
end


--[[ UI Events ]]--

function Editor:OkayButton_OnClick()
	self.tag.id = self.tag.id or self:NextAvailableID()
	self.tag.name = self.BorderBox.IconSelectorEditBox:GetText()
	self.tag.atlas = self.BorderBox.SelectedIconArea.SelectedIconButton.Icon:GetAtlas()
	self:SetTag(self.tag.id, self.tag)
	self:Hide()
end

function Editor:SetTag(id, tag)
	Scrap2.Tags[id] = tag
	Scrap2:SendSignal('TAGS_CHANGED')
	Scrap2:SendSignal('LOOK_CHANGED')
end

function Editor:NextAvailableID()
	local id = 50
	while Scrap2.Tags[id] do
		id = id + 1
	end
	return id
end