function TabAppender_New(window)
	local id = window.numTabs + 1
	local tab = CreateFrame('Button', '$parentTab' .. id, window, 'CharacterFrameTabButtonTemplate', id)
	tab:SetPoint('LEFT', window:GetName() .. 'Tab' .. (id - 1), 'RIGHT', -16, 0)
	tab:SetScript('OnClick', function()
		PlaySound('igCharacterInfoTab')
		PanelTemplates_SetTab(window, id)
		tab.OnClick()
	end)
	
	window.numTabs = id
	PanelTemplates_UpdateTabs(window)
	
	return tab
end