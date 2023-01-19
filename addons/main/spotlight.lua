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

if Bagnon or Bagnonium then return end
local Spotlight = Scrap:NewModule('Spotlight')
local C = LibStub('C_Everywhere').Container
local R,G,B = GetItemQualityColor(0)


--[[ Display ]]--

function Spotlight:OnEnable()
	self.Glows, self.Icons = {}, {}
	self:RegisterSignal('LIST_CHANGED', 'UpdateAll')

	if ContainerFrame_Update then
		hooksecurefunc('ContainerFrame_Update', function(frame) self:UpdateContainer(frame) end)
	else
		self:IterateFrames('ContainerFrame', function(frame)
			hooksecurefunc(frame, 'Update', function(frame) self:UpdateContainer(frame) end)
		end)

		hooksecurefunc(ContainerFrameCombinedBags, 'Update', function() self:UpdateAll() end)
	end
end

function Spotlight:UpdateAll()
	self:IterateFrames('ContainerFrame', function(frame)
		self:UpdateContainer(frame)
	end)
end

function Spotlight:UpdateContainer(frame)
	self:IterateFrames(frame:GetName() .. 'Item', function(button)
		self:UpdateButton(frame, button)
	end)
end

function Spotlight:UpdateButton(frame, button)
	if button:IsShown() then
		local bag, slot = button.bagID or frame:GetID(), button:GetID()
		local id = C.GetContainerItemID(bag, slot)
		local isJunk = id and Scrap:IsJunk(id, bag, slot)

		local icon = (button.JunkIcon or self.Icons[button] or self:NewIcon(button))
		local glow = (self.Glows[button] or self:NewGlow(button))

		icon:SetShown(isJunk and Scrap.sets.icons)
		glow:SetShown(isJunk and Scrap.sets.glow)

		if button.IconBorder then
			button.IconBorder:SetAlpha(glow:IsShown() and 0 or 1)
		end
	end
end

function Spotlight:IterateFrames(namePrefix, call)
	local i = 1
	local frame = _G[namePrefix .. i]
	while frame do
		call(frame)

		i = i + 1
		frame = _G[namePrefix .. i]
	end
end


--[[ Construct ]]--

function Spotlight:NewGlow(button)
	local glow = button:CreateTexture(nil, 'OVERLAY')
	glow:SetTexture('Interface/Buttons/UI-ActionButton-Border')
	glow:SetVertexColor(R,G,B, .7)
	glow:SetBlendMode('ADD')
	glow:SetPoint('CENTER')
	glow:SetSize(67, 67)

	self.Glows[button] = glow
	return glow
end

function Spotlight:NewIcon(button)
	local icon = button:CreateTexture(nil, 'OVERLAY')
	icon:SetTexture('Interface/Buttons/UI-GroupLoot-Coin-Up')
	icon:SetPoint('TOPLEFT', 2, -2)
	icon:SetSize(15, 15)

	self.Icons[button] = icon
	return icon
end
