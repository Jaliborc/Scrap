--[[
Copyright 2008-2012 João Cardoso
Scrap is distributed under the terms of the GNU General Public License (or the Lesser GPL).
This file is part of Scrap.

Scrap is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Scrap is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Scrap. If not, see <http://www.gnu.org/licenses/>.
--]]

if IsAddOnLoaded('Bagnon_Scrap') or IsAddOnLoaded('Combuctor_Scrap') or IsAddOnLoaded('Baggins_Scrap') then
	return
end

--local r, g, b = GetItemQualityColor(0)
local function CreateBorder(slot)
  local border = slot:CreateTexture(nil, 'OVERLAY')
  border:SetWidth(67)
  border:SetHeight(67)
  border:SetPoint('CENTER')
  border:SetTexture([[Interface\Buttons\UI-ActionButton-Border]])
  border:SetVertexColor(unpack(Scrap_GlowColor))
  border:SetBlendMode('ADD')

  slot.scrapGlow = border
  return border
end

hooksecurefunc('ContainerFrame_Update', function(self)
  local bag = self:GetID()
  local name = self:GetName()
  local size = self.size

	for i = 1, size do
		local slot = size - i + 1
	    local button = _G[name .. 'Item' .. slot]
		local id = GetContainerItemID(bag, i)

		local border = button.scrapGlow or CreateBorder(button)
		if Scrap_Glow and Scrap:IsJunk(id, bag, slot) then
			border:Show()
		else
			border:Hide()
		end
	end
end)

hooksecurefunc(Scrap, 'ToggleJunk', function()
	local i = 1
	local frame = _G['ContainerFrame'..i]
	
	while frame do
		if frame:IsShown() then
			ContainerFrame_Update(frame)
		end
		
		i = i + 1
		frame = _G['ContainerFrame'..i]
	end
end)