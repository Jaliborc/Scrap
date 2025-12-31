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
		button.IconGlow[mode](button.IconGlow, icon)
		button.Icon[mode](button.Icon, icon)
		button.Checked:SetShown(checked)
	end)

	local itemGrid = CreateScrollBoxListGridView(3, 6,6,10,10, 5,5)
	itemGrid:SetElementInitializer('Scrap2ItemButtonTemplate', function(button, id)
		button.Icon:SetTexture(C.Item.GetItemIconByID(id))
		button:SetText(Scrap2:GetItemName(id))
		button.id = id
	end)

	self.activeTag = 1
	self.searchCondition = self.Yup
	self.ItemsPriority = TableUtil.CreatePriorityTable(function(a,b)
		if a.quality ~= b.quality then
			return a.quality > b.quality
		elseif a.class ~= b.class then
			return a.class > b.class
		elseif a.subclass ~= b.subclass then
			return a.subclass > b.subclass
		end
		return a.name < b.name
	end, true)

	self:SetScript('OnShow', self.OnShow)
	self:SetScript('OnHide', self.UnregisterAll)
	self.SearchBox:HookScript('OnTextChanged', self.OnSearchChanged)
	self.OptionsWheel.tooltipTitle = 'General Options'
	self.OptionsDropdown:SetupMenu(self.Editor.SmartFilters)
	self.OptionsDropdown:SetText('Item Filters')
	self.TagsBox:Init(tagList)

	ScrollUtil.InitScrollBoxListWithScrollBar(self.ItemsBox, self.ScrollBar, itemGrid)
	RegisterUIPanel(self, {area = 'left', pushable = 3,	whileDead = 1})
end


--[[ Toggle ]]--

function Frame:Toggle()
	if self:IsShown() then
		HideUIPanel(self)
	else
		ShowUIPanel(self)
	end
end

function Frame:OnShow()
	self:RegisterEvent('ITEM_DATA_LOAD_RESULT', 'OnItemData')
	self:RegisterSignal('LIST_CHANGED', 'UpdateItems')
	self:RegisterSignal('TAGS_CHANGED', 'UpdateTags')
	self:UpdateTags()
end


--[[ Events ]]--

function Frame:OnItemData(id, success)
	if success then
		self:Delay(0.5, 'UpdateItems', true)
		self:CacheItem(id)
	end
end

function Frame.OnSearchChanged()
	Frame.searchCondition = Search:Compile(Frame.SearchBox:GetText())
	Frame:Delay(0.1, 'UpdateItems', true)
end

function Frame.OnTagClick(region, button)
	if button == 'LeftButton' then
		PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN)
		Frame.activeTag = region.tag.id
		Frame:UpdateTags()
	elseif region.tag.id > 0 then
		MenuUtil.CreateContextMenu(region, Frame.Editor:TagOptions(region.tag))
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
	local items = CreateDataProvider()

	for id, tag in pairs(Scrap2.List) do
		if tag == self.activeTag then
			if not C.Item.IsItemDataCachedByID(id) then
				C.Item.RequestLoadItemDataByID(id)
			else
				self:CacheItem(id)
			end
		end
	end

	self.ItemsPriority:Iterate(function(id, info)
		local tag = Scrap2.List[id]
		if tag == self.activeTag and C.Item.IsItemDataCachedByID(id) and self.searchCondition(info.link) then
			items:InsertInternal(id)
		end
	end)
	self.ItemsBox:SetDataProvider(items, not resetScroll)
end

function Frame:CacheItem(id)
	if not self.ItemsPriority[id] then
		local name, link , quality, _,_,_,_,_,_,_,_, class, subclass = C.Item.GetItemInfo(id)
		self.ItemsPriority[id] = {name = name, link = link, quality = quality, class = class, subclass = subclass}
	end
end