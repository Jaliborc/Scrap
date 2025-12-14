--[[
	Copyright 2008-2025 João Cardoso, All Rights Reserved
	Panel for list visualization and configuration.
--]]

local Frame = Scrap2:NewModule('Frame', Scrap2Frame)
local C = LibStub('C_Everywhere')


--[[ Events ]]--

function Frame:OnLoad()
	local title = self.TitleText or self.TitleContainer.TitleText
	title:SetText('Scrap2')

	local portrait = self.portrait or self.PortraitContainer.portrait
	portrait:SetTexture('Interface/Addons/Scrap/art/scrap-big')

	local backdrop = portrait:GetParent():CreateTexture(nil, 'BORDER')
	backdrop:SetColorTexture(0, 0, 0)
	backdrop:SetAllPoints(portrait)

	local mask = portrait:GetParent():CreateMaskTexture()
	mask:SetTexture('Interface/CharacterFrame/TempPortraitAlphaMask')
	mask:SetAllPoints(backdrop)
	backdrop:AddMaskTexture(mask)
	portrait:AddMaskTexture(mask)

	local tagList = CreateScrollBoxListLinearView()
	tagList:SetElementInitializer('Scrap2TagButtonTemplate', function(button, tag)
		local icon = tag.icon or tag.atlas or 'capacitance-general-workordercheckmark'
		local mode = tag.icon and 'SetTexture' or 'SetAtlas'
		local checked = tag.id == self.activeTag

		button.tag = tag
		button:SetText(tag.name)
		button:SetNormalFontObject(checked and 'GameFontHighlightLeft' or 'GameFontNormalLeft')
		button.IconHighlight[mode](button.IconHighlight, icon)
		button.Icon[mode](button.Icon, icon)
	end)

	local itemGrid = CreateScrollBoxListGridView(3, 6,6,10,10, 5,5)
	itemGrid:SetElementInitializer('Scrap2ItemButtonTemplate', function(button, id)
		button.Icon:SetTexture(C.Item.GetItemIconByID(id))
		button:SetText(Scrap2:GetItemName(id))
		button.id = id
	end)

	self.activeTag = 1
	self.OptionsWheel.tooltipTitle = 'General Options'

	self.TagsBox:Init(tagList)
	self.OptionsDropdown:SetText(FILTERS)
	self.SearchBox:HookScript('OnTextChanged', function() self:UpdateItems(true) end)
	self:SetScript('OnHide', self.UnregisterAll)
	self:SetScript('OnShow', self.OnShow)

	ScrollUtil.InitScrollBoxListWithScrollBar(self.ItemsBox, self.ScrollBar, itemGrid)
	RegisterUIPanel(self, {area = 'left', pushable = 3,	whileDead = 1})
	RunNextFrame(function() ShowUIPanel(self) end)
end

function Frame:OnShow()
	self:RegisterSignal('LIST_CHANGED', 'UpdateItems')
	self:RegisterSignal('TAGS_CHANGED', 'UpdateTags')
	self:UpdateTags()
end

function Frame:OnTagClick(button)
	if button == 'LeftButton' then
		Frame.activeTag = self.tag.id
		Frame:UpdateTags()
	elseif self.tag.id > 0 then
		MenuUtil.CreateContextMenu(self, function(_, drop)
            drop:SetTag('Scrap2_EditTag')
			drop:CreateTitle(self.tag.name)
			drop:CreateCheckbox('Show Icon', nop, nop)
			drop:CreateCheckbox('Glow', nop, nop):CreateColorSwatch('Color', nop, self.tag.color)
			drop:QueueDivider()

			if self.tag.id == 1 then
				drop:CreateCheckbox('Auto Sell', nop, nop)
				drop:CreateCheckbox('Safe Sell', nop, nop)
			elseif self.tag.id >= 3 and self.tag.id <= 5 then
				drop:CreateCheckbox('Auto Deposit', nop, nop)
			end
		end)
	end
end


--[[ Update ]]--

function Frame:UpdateTags()
	self.TagsBox:SetDataProvider(CreateDataProvider(GetValuesArray(Scrap2.Tags)))
	self:UpdateItems(true)
end

function Frame:UpdateItems(resetScroll)
	local items = {}
	for id, tag in pairs(Scrap2.List) do
		if tag == self.activeTag then
			local name = C.Item.GetItemInfo(id)
			if name and name:find(self.SearchBox:GetText()) then
				tinsert(items, id)
			end
		end
	end

	sort(items, function(A, B)
		if not A then
			return true
		elseif not B or A == B then
			return nil
		end

		local nameA, _ , qualityA, _,_,_,_,_,_,_,_, classA = C.Item.GetItemInfo(A)
		local nameB, _ , qualityB, _,_,_,_,_,_,_,_, classB = C.Item.GetItemInfo(B)
		if qualityA == qualityB then
			return (classA == classB and nameA < nameB) or classA > classB
		else
			return qualityA > qualityB
		end
	end)

	self.ItemsBox:SetDataProvider(CreateDataProvider(items), not resetScroll)
end