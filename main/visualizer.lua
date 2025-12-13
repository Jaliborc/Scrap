--[[
	Copyright 2008-2025 João Cardoso, All Rights Reserved
	Panel for list visualization and configuration.
--]]

local Visualizer = Scrap2:NewModule('Visualizer', Scrap2Visualizer)
local C = LibStub('C_Everywhere')


--[[ Startup ]]--

function Visualizer:OnLoad()
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
		local icon = tag.icon or 'capacitance-general-workordercheckmark'
		local hasAtlas = tag.hasAtlas or not tag.icon
		local checked = tag.id == self.activeTag

		button:SetText(tag.name)
		button:SetNormalFontObject(checked and 'GameFontHighlightLeft' or 'GameFontNormalLeft')
		button.IconHighlight[hasAtlas and 'SetAtlas' or 'SetTexture'](button.IconHighlight, icon)
		button.Icon[hasAtlas and 'SetAtlas' or 'SetTexture'](button.Icon, icon)
	end)

	local itemGrid = CreateScrollBoxListGridView(3, 6,6,10,10, 5,5)
	itemGrid:SetElementInitializer('Scrap2ItemButtonTemplate', function(button, i)
		button.Icon:SetTexture(GetRandomArrayEntry({133970, 646324, 135157, 134937, 628647, 237395}))
		button:SetText('Heavy Windwool Bandage')
	end)

	self.activeTag = 1
	self.TagsBox:Init(tagList)
	self.OptionsWheel.tooltipTitle = 'General Options'
	self:SetScript('OnHide', self.UnregisterAll)
	self:SetScript('OnShow', self.OnShow)

	ScrollUtil.InitScrollBoxListWithScrollBar(self.ItemsBox, self.ScrollBar, itemGrid)
	RegisterUIPanel(self, {area = 'left', pushable = 3,	whileDead = 1})

	C_Timer.After(1, function()
		ShowUIPanel(self)
	end)
end

function Visualizer:OnShow()
	self:RegisterSignal('LIST_CHANGED', 'UpdateItems')
	self:RegisterSignal('TAGS_CHANGED', 'UpdateTags')
	self:UpdateTags()
end


--[[ Update ]]--

function Visualizer:UpdateTags()
	self.TagsBox:SetDataProvider(CreateDataProvider(GetValuesArray(Scrap2.Tags)))
	self:UpdateItems()
end

function Visualizer:UpdateItems()
	self.items = {}

	for id, classification in pairs(Scrap2.FakeList) do
		if C.Item.GetItemInfo(id) then
			tinsert(self.items, id)
		end
	end

	sort(self.items, function(A, B)
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

	self.ItemsBox:SetDataProvider(CreateIndexRangeDataProvider(#self.items + 50))
end