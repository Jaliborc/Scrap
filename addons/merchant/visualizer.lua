--[[
Copyright 2008-2023 João Cardoso
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

local Visualizer = Scrap:NewModule('Visualizer', ScrapVisualizer, 'MutexDelay-1.0')
local L = LibStub('AceLocale-3.0'):GetLocale('Scrap')


--[[ Startup ]]--

function Visualizer:OnEnable()
	local title = self.TitleText or self.TitleContainer.TitleText
	title:SetText('Scrap')

	local portrait = self.portrait or self.PortraitContainer.portrait
	portrait:SetTexture('Interface/Addons/Scrap/Art/Enabled-Icon')

	local backdrop = portrait:GetParent():CreateTexture(nil, 'BORDER')
	backdrop:SetColorTexture(0, 0, 0)
	backdrop:SetAllPoints(portrait)

	local mask = portrait:GetParent():CreateMaskTexture()
	mask:SetTexture('Interface/CHARACTERFRAME/TempPortraitAlphaMask')
	mask:SetAllPoints(backdrop)
	backdrop:AddMaskTexture(mask)
	portrait:AddMaskTexture(mask)

	local tab = LibStub('SecureTabs-2.0'):Add(MerchantFrame)
	tab:SetText('Scrap')
	tab.frame = self

	self.numTabs, self.list, self.item = 2, {}, {}
	self.Tab1:SetText('|TInterface/Addons/Scrap/Art/Thumbsup:14:14:-2:2:16:16:0:16:0:16:73:255:73|t ' .. L.NotJunk)
	self.Tab2:SetText('|TInterface/Addons/Scrap/Art/Thumbsdown:14:14:-2:-2:16:16:0:16:0:16:255:73:73|t ' .. L.Junk)
	self.Spinner.Anim:Play()
	self.ParentTab = tab

	self:SetScript('OnShow', self.OnShow)
	self:SetScript('OnHide', self.OnHide)
	self:UpdateButton()
	self:SetTab(1)
end

function Visualizer:OnShow()
	CloseDropDownMenus()
	self:RegisterSignal('LIST_CHANGED', 'UpdateList')
	self:Delay(0, 'QueryItems')
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
	self:UpdateButton()
end

function Visualizer:ToggleItem()
	Scrap:ToggleJunk(self.item.id)
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
		self:UpdateButton()
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
			button.Text:SetTextColor(ITEM_QUALITY_COLORS[quality].color:GetRGB())
			button.Icon:SetTexture(GetItemIcon(id))
			button.Text:SetText(name)
			button:SetWidth(width)
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

function Visualizer:UpdateButton()
	self.Button:SetEnabled(self.selectedTab == self.item.type)
	self.Button:SetText(self.selectedTab == 1 and L.Add or L.Remove)
	self.Button:SetWidth(self.Button:GetTextWidth() + 20)
end
