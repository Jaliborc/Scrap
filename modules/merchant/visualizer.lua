--[[
Copyright 2008-2019 João Cardoso
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

local Visualizer = ScrapVisualizer
local L = Scrap_Locals
local List = {}


--[[ Startup ]]--

function Visualizer:Startup()
	self.tab1:SetText(L.Junk)
	self.tab2:SetText(L.NotJunk)

	PanelTemplates_TabResize(self.tab1, 0)
	PanelTemplates_TabResize(self.tab2, 0)
	PanelTemplates_SetNumTabs(self, 2)

	self.portrait:SetTexture('Interface\\Addons\\Scrap\\art\\enabled-icon')
	self.loading:SetText(L.Loading)
	self.TitleText:SetText('Scrap')

	self:SetScript('OnUpdate', self.QueryItems)
	self:SetScript('OnShow', self.OnShow)
	self:SetScript('OnHide', self.OnHide)
	self:UpdateButton()
	self:SetTab(1)

	local portraitBack = self:CreateTexture(nil, 'BORDER')
	portraitBack:SetPoint('TOPRIGHT', self.portrait, -5, -5)
	portraitBack:SetPoint('BOTTOMLEFT', self.portrait, 6, 5)
	portraitBack:SetColorTexture(0, 0, 0)
end

function Visualizer:SetTab(i)
	PanelTemplates_SetTab(self, i)
	self:UpdateList()
end


--[[ Shoe/Hide ]]--

function Visualizer:OnShow()
	self:UpdateList()
	CloseDropDownMenus()
end

function Visualizer:OnHide()
	List = nil
end


--[[ Query ]]--

function Visualizer:QueryItems()
	if self:QueryList() then
		return
	end

	HybridScrollFrame_CreateButtons(self.scroll, 'ScrapVisualizerButtonTemplate', 1, -2, 'TOPLEFT', 'TOPLEFT', 0, -3)
	hooksecurefunc(Scrap, 'ToggleJunk', function() self:UpdateList() end)

	self.Startup, self.QueryItems, self.QueryList = nil
	self:SetScript('OnUpdate', nil)
	self.loading:Hide()
	self:UpdateList()
end

function Visualizer:QueryList()
	for itemID in pairs(Scrap.junk) do
		if not GetItemInfo(itemID) then
			return true
		end
	end
end


--[[ Update ]]--

function Visualizer:UpdateList()
	if not self.QueryItems and self:IsShown() then
		List = {}

		local showJunk = self.selectedTab == 1
		for itemID, itemType in pairs(Scrap.junk) do
			if itemType == showJunk then
				tinsert(List, itemID)
			end
		end

		sort(List, function(A, B)
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

		self.scroll:update()
	end

	self:UpdateButton()
end

function Visualizer:UpdateButton()
	local tab = self.selectedTab
	if tab == self.selectionType then
		self.button:Enable()
	else
		self.button:Disable()
	end

	self.button:SetText(tab == 1 and L.Remove or L.Add)
	self.button:SetWidth(self.button:GetTextWidth() + 20)
end

function Visualizer.scroll:update()
	local self = Visualizer.scroll
	local selection = Visualizer.selection
	local offset = HybridScrollFrame_GetOffset(self)
	local width = #List > 18 and 296 or 318
	local focus = GetMouseFocus()

	for i, button in ipairs(self.buttons) do
		local index = i + offset
		local itemID = List[index]

		if itemID then
			local name, link, quality = GetItemInfo(itemID)
			button.text:SetTextColor(GetItemQualityColor(quality))
			button.icon:SetTexture(GetItemIcon(itemID))
			button.text:SetText(name)
			button:SetWidth(width)
			button.item = itemID
			button.link = link
			button:Show()

			if itemID == selection then
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

	HybridScrollFrame_Update(self, #List * 20 + 2, #self.buttons * 18)
	self:SetWidth(width + 5)
end

Visualizer:Startup()
Scrap.visualizer = Visualizer
