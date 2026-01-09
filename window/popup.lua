--[[
	Copyright 2008-2025 João Cardoso, All Rights Reserved
	Popup window for custom tag options.
--]]

local Popup = Scrap2.Frame.EditPopup

function Popup:Display(tag)
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

	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		self:SetHeight(508)
	end

	select(_, icon)
	self.tag = tag
	self:Show()
end

function Popup:OkayButton_OnClick()
	self.tag.id = self.tag.id or self:NextAvailableID()
	self.tag.name = self.BorderBox.IconSelectorEditBox:GetText()
	self.tag.atlas = self.BorderBox.SelectedIconArea.SelectedIconButton.Icon:GetAtlas()
	self:SaveTag(self.tag.id, self.tag)
	self:Hide()
end

function Popup:SaveTag(id, tag)
	Scrap2.Tags[id] = tag
	Scrap2:SendSignal('TAGS_CHANGED')
end

function Popup:NextAvailableID()
	local id = 50
	while Scrap2.Tags[id] do
		id = id + 1
	end
	return id
end