--[[
	Copyright 2008-2025 João Cardoso, All Rights Reserved
	Panel for list visualization and configuration.
--]]

local Frame = Scrap2:NewModule('Frame', Scrap2Frame, 'MutexDelay-1.0')
local Search = LibStub('ItemSearch-1.3')
local C = LibStub('C_Everywhere')


--[[ Startup ]]--

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
		button.RingGlow:SetShown(checked)
	end)

	local itemGrid = CreateScrollBoxListGridView(3, 6,6,10,10, 5,5)
	itemGrid:SetElementInitializer('Scrap2ItemButtonTemplate', function(button, id)
		button.Icon:SetTexture(C.Item.GetItemIconByID(id))
		button:SetText(Scrap2:GetItemName(id))
		button.id = id
	end)

	self.activeTag = 1
	self.searchCondition = self.Yup
	self.OptionsWheel.tooltipTitle = 'General Options'
	self.OptionsDropdown:SetupMenu(self.Editor.SmartFilters)
	self.OptionsDropdown:SetText('Item Filters')
	self.TagsBox:Init(tagList)

	self.SearchBox:HookScript('OnTextChanged', self.OnSearchChanged)
	self:SetScript('OnHide', self.UnregisterAll)
	self:SetScript('OnShow', self.OnShow)

	ScrollUtil.InitScrollBoxListWithScrollBar(self.ItemsBox, self.ScrollBar, itemGrid)
	RegisterUIPanel(self, {area = 'left', pushable = 3,	whileDead = 1})
	RunNextFrame(function() ShowUIPanel(self) end)
end

function Frame:OnShow()
	self:RegisterSignal('LIST_CHANGED', 'UpdateItems')
	self:RegisterSignal('TAGS_CHANGED', 'UpdateTags')
	self:RegisterEvent('ITEM_DATA_LOAD_RESULT')
	self:UpdateTags()
end

function Frame:ITEM_DATA_LOAD_RESULT(_, success)
	if success then
		self:Delay(0.5, 'UpdateItems', true)
	end
end


--[[ User Events ]]--

function Frame:OnSearchChanged()
	Frame.searchCondition = Search:Compile(Frame.SearchBox:GetText())
	Frame:Delay(0.1, 'UpdateItems', true)
end

function Frame:OnTagClick(button)
	if button == 'LeftButton' then
		Frame.activeTag = self.tag.id
		Frame:UpdateTags()
	elseif self.tag.id > 0 then
		MenuUtil.CreateContextMenu(self, Frame.Editor:TagOptions(self.tag))
	else
		PlaySound(GetRandomArrayEntry({1024, 3037, 6820}))
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
		if tonumber(id) and tag == self.activeTag then
			if C.Item.IsItemDataCachedByID(id) then
				local _, link = C.Item.GetItemInfo(id)
				if self.searchCondition(link) then
					tinsert(items, id)
				end
			else
				C.Item.RequestLoadItemDataByID(id)
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