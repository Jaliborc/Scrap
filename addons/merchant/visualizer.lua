--[[
Copyright 2008-2020 João Cardoso
Scrap is distributed under the terms of the GNU General Public License (Version 3).
As a special exception, the copyright holders of this addon do not give permission to
redistribute and/or modify it.

This addon is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with the addon. If not, see <http://www.gnu.org/licenses/gpl-3.0.txt>.

This file is part of Scrap.
--]]

local Visualizer = Scrap:NewModule('Visualizer', CreateFrame('Frame', 'ScrapVisualizer', MerchantFrame, 'ScrapVisualizerTemplate'))
local L = LibStub('AceLocale-3.0'):GetLocale('Scrap')


--[[ Events ]]--

function Visualizer:OnEnable()
	local portraitBack = self:CreateTexture(nil, 'BORDER')
	portraitBack:SetPoint('TOPRIGHT', self.portrait, -5, -5)
	portraitBack:SetPoint('BOTTOMLEFT', self.portrait, 6, 5)
	portraitBack:SetColorTexture(0, 0, 0)

	local tab = LibStub('SecureTabs-2.0'):Add(MerchantFrame)
	tab:SetText('Scrap')
	tab.frame = self

	self.tab, self.list, self.item = tab, {}, {}
	self.portrait:SetTexture('Interface/Addons/Scrap/art/enabled-icon')
	self.TitleText:SetText('Scrap')
	self.Tab2:SetText(L.NotJunk)
	self.Tab1:SetText(L.Junk)
	self.Spinner.Anim:Play()

	PanelTemplates_TabResize(self.Tab1, 0)
	PanelTemplates_TabResize(self.Tab2, 0)
	PanelTemplates_SetNumTabs(self, 2)

	self:SetScript('OnUpdate', self.QueryItems)
	self:SetScript('OnShow', self.OnShow)
	self:SetScript('OnHide', self.OnHide)
	self:UpdateButton()
	self:SetTab(1)
end

function Visualizer:OnShow()
	CloseDropDownMenus()
	self:UpdateList()
end

function Visualizer:OnHide()
	wipe(self.list)
end


-- [[ API ]]--

function Visualizer:SetTab(i)
	PanelTemplates_SetTab(self, i)
	self:UpdateList()
end

function Visualizer:SetItem(id)
	self.item = {id = id, type = self.selectedTab}
	self.Scroll:update()
	self:UpdateButton()
end

function Visualizer:ToggleItem()
	Scrap:ToggleJunk(self.item.id)
	self.item = {}
end


--[[ Query ]]--

function Visualizer:QueryItems()
	if self:QueryList() then
		return
	else
		HybridScrollFrame_CreateButtons(self.Scroll, 'ScrapVisualizerButtonTemplate', 1, -2, 'TOPLEFT', 'TOPLEFT', 0, -3)
	end

	self.QueryItems, self.QueryList = nil
	self:RegisterSignal('LIST_CHANGED', 'UpdateList')
	self:SetScript('OnUpdate', nil)
	self.Spinner:Hide()
	self:UpdateList()
end

function Visualizer:QueryList()
	for id in pairs(Scrap.junk) do
		if not GetItemInfo(id) then
			return true
		end
	end
end


--[[ Update ]]--

function Visualizer:UpdateList()
	if not self.QueryItems and self:IsShown() then
		self.list = {}

		local mode = self.selectedTab == 1
		for id, classification in pairs(Scrap.junk) do
			if classification == mode then
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
	end

	self:UpdateButton()
end

function Visualizer.Scroll:update()
	local self = Visualizer
	local offset = HybridScrollFrame_GetOffset(self.Scroll)
	local width = #self.list > 18 and 296 or 318
	local focus = GetMouseFocus()

	for i, button in ipairs(self.Scroll.buttons) do
		local index = i + offset
		local id = self.list[index]

		if id then
			local name, link, quality = GetItemInfo(id)
			button.text:SetTextColor(GetItemQualityColor(quality))
			button.icon:SetTexture(GetItemIcon(id))
			button.text:SetText(name)
			button:SetWidth(width)
			button.item = id
			button.link = link
			button:Show()

			if id == self.item.id then
				button:LockHighlight()
			else
				button:UnlockHighlight()
			end

			if focus == button then
				button:GetScript('OnEnter')(button)
			end

			if mod(index, 2) == 0 then
				button.stripe:Show()
			else
				button.stripe:Hide()
			end
		else
			button:Hide()
		end
	end

	HybridScrollFrame_Update(self.Scroll, #self.list * 20 + 2, #self.Scroll.buttons * 18)
	self.Scroll:SetWidth(width + 5)
end

function Visualizer:UpdateButton()
	self.Button:SetEnabled(self.selectedTab == self.item.type)
	self.Button:SetText(self.selectedTab == 1 and L.Remove or L.Add)
	self.Button:SetWidth(self.Button:GetTextWidth() + 20)
end
