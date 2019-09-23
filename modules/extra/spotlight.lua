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

if not Scrap.hasSpotlight then
	Scrap.hasSpotlight = true
else
	return
end

local R,G,B  = GetItemQualityColor(0)
local Glows, Icons = {}, {}

local function CreateGlow(button)
	local glow = button:CreateTexture(nil, 'OVERLAY')
	glow:SetTexture('Interface\\Buttons\\UI-ActionButton-Border')
	glow:SetVertexColor(R,G,B, .7)
	glow:SetBlendMode('ADD')
	glow:SetPoint('CENTER')
	glow:SetSize(67, 67)

	Glows[button] = glow
	return glow
end

local function CreateIcon(button)
	local icon = button:CreateTexture(nil, 'OVERLAY')
	icon:SetTexture('Interface\\Buttons\\UI-GroupLoot-Coin-Up')
	icon:SetPoint('TOPLEFT', 2, -2)
	icon:SetSize(15, 15)

	Icons[button] = icon
	return icon
end

hooksecurefunc('ContainerFrame_Update', function(self)
  local bag = self:GetID()
  local name = self:GetName()
  local size = self.size

	for i = 1, size do
		local slot = size - i + 1
    local button = _G[name .. 'Item' .. slot]
		local id = GetContainerItemID(bag, i)

		local isJunk = id and Scrap:IsJunk(id, bag, slot)
		local glow = Glows[button] or CreateGlow(button)
		local icon = Icons[button] or CreateIcon(button)

		glow:SetShown(isJunk and Scrap.sets.glow)
		icon:SetShown(isJunk and Scrap.sets.icons)
	end
end)

hooksecurefunc(Scrap, 'ToggleJunk', function()
	local i = 1
	local frame = _G['ContainerFrame' .. i]

	while frame do
		if frame:IsShown() then
			ContainerFrame_Update(frame)
		end

		i = i + 1
		frame = _G['ContainerFrame' .. i]
	end
end)
