--[[
Copyright 2008-2024 João Cardoso
All Rights Reserved
--]]

local Visualizer = Scrap:NewModule('Visualizer', ScrapVisualizer, 'MutexDelay-1.0')
local L = LibStub('AceLocale-3.0'):GetLocale('Scrap')


--[[ Startup ]]--

function Visualizer:OnEnable()
	local title = self.TitleText or self.TitleContainer.TitleText
	title:SetText('Scrap')

	local portrait = self.portrait or self.PortraitContainer.portrait
	portrait:SetTexture('Interface/Addons/Scrap/Art/Scrap-Big')

	local backdrop = portrait:GetParent():CreateTexture(nil, 'BORDER')
	backdrop:SetColorTexture(0, 0, 0)
	backdrop:SetAllPoints(portrait)

	local mask = portrait:GetParent():CreateMaskTexture()
	mask:SetTexture('Interface/CharacterFrame/TempPortraitAlphaMask')
	mask:SetAllPoints(backdrop)
	backdrop:AddMaskTexture(mask)
	portrait:AddMaskTexture(mask)

	local tab = LibStub('SecureTabs-2.0'):Add(MerchantFrame)
	tab:SetText('Scrap')
	tab.frame = self

	self.numTabs, self.list, self.item = 2, {}, {}
	self.Tab1:SetText('|TInterface/Addons/Scrap/Art/Thumbsup:14:14:-2:2:16:16:0:16:0:16:73:255:73|t ' .. L.NotJunk)
	self.Tab2:SetText('|TInterface/Addons/Scrap/Art/Thumbsdown:14:14:-2:-2:16:16:0:16:0:16:255:73:73|t ' .. L.Junk)
	self.ForgetButton:SetText(L.Forget)
	self.ForgetButton:SetWidth(self.ForgetButton:GetTextWidth() + 20)
	self.Spinner.Anim:Play()
	self.ParentTab = tab

	self:SetScript('OnShow', self.OnShow)
	self:SetScript('OnHide', self.OnHide)
	self:UpdateButtons()
	self:SetTab(1)
end

function Visualizer:OnShow()
	CloseDropDownMenus()
	self:RegisterSignal('LIST_CHANGED', 'UpdateList')
	self:Delay(0, 'QueryItems')

	if UndoFrame then
		UndoFrame.Arrow:Hide()
	end
end

function Visualizer:OnHide()
	self:UnregisterSignal('LIST_CHANGED')
	wipe(self.list)
end


-- [[ API ]]--

function Visualizer:QueryItems()
	local ready = true
	for id in pairs(Scrap.junk) do
		ready = ready and GetItemInfo(id)
	end

	if not ready then
		self:Delay(0.2, 'QueryItems')
	end

	self.Spinner:SetShown(not ready)
	self:UpdateList()
end

function Visualizer:SetTab(i)
	PanelTemplates_SetTab(self, i)
	self:UpdateList()
end

function Visualizer:SetItem(id)
	self.item = {id = id, type = self.selectedTab}
	self.Scroll:update()
	self:UpdateButtons()
end

function Visualizer:ToggleItem()
	Scrap:ToggleJunk(self.item.id)
	self.item = {}
end

function Visualizer:ForgetItem()
	Scrap.junk[self.item.id] = nil
	Scrap:Print(format(L.Forgotten, select(2, GetItemInfo(self.item.id))), 'LOOT')
	Scrap:SendSignal('LIST_CHANGED', self.item.id)
	self.item = {}
end


--[[ Update ]]--

function Visualizer:UpdateList()
	if self:IsVisible() then
		self.list = {}

		local mode = self.selectedTab == 2
		for id, classification in pairs(Scrap.junk) do
			if classification == mode and GetItemInfo(id) then
				tinsert(self.list, id)
			end
		end

		sort(self.list, function(A, B)
			if not A then
				return true
			elseif not B or A == B then
				return nil
			end

			local nameA, _ , qualityA, _,_,_,_,_,_,_,_, classA = GetItemInfo(A)
			local nameB, _ , qualityB, _,_,_,_,_,_,_,_, classB = GetItemInfo(B)
			if qualityA == qualityB then
				return (classA == classB and nameA < nameB) or classA > classB
			else
				return qualityA > qualityB
			end
		end)

		self.Scroll:update()
		self:UpdateButtons()
	end
end

function Visualizer.Scroll:update()
	local self = Visualizer
	if not self.Scroll.buttons then
		HybridScrollFrame_CreateButtons(self.Scroll, 'ScrapVisualizerButtonTemplate', 1, -2, 'TOPLEFT', 'TOPLEFT', 0, -3)
	end

	local focus = GetMouseFocus()
	local offset = HybridScrollFrame_GetOffset(self.Scroll)
	local width = #self.list > 17 and 296 or 318

	for i, button in ipairs(self.Scroll.buttons) do
		local index = i + offset
		local id = self.list[index]

		if id then
			local name, link, quality = GetItemInfo(id)
			button.item, button.link = id, link
			button:SetHighlightLocked(id == self.item.id)
			button.Text:SetTextColor(ITEM_QUALITY_COLORS[quality].color:GetRGB())
			button.Icon:SetTexture(GetItemIcon(id))
			button.Text:SetText(name)
			button:SetWidth(width)
			button:Show()

			if focus == button then
				ExecuteFrameScript(button, 'OnEnter')
			end

			if mod(index, 2) == 0 then
				button.Stripe:Show()
			else
				button.Stripe:Hide()
			end
		else
			button:Hide()
		end
	end

	HybridScrollFrame_Update(self.Scroll, #self.list * 20 + 2, #self.Scroll.buttons * 18)
	self.Scroll:SetWidth(width + 5)
end

function Visualizer:UpdateButtons()
	self.ForgetButton:SetEnabled(self.selectedTab == self.item.type)
	self.ToggleButton:SetEnabled(self.selectedTab == self.item.type)
	self.ToggleButton:SetText(self.selectedTab == 1 and L.Add or L.Remove)
	self.ToggleButton:SetWidth(self.ToggleButton:GetTextWidth() + 20)
end
