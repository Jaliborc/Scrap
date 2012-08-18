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

local Options = CreateFrame('Frame', 'ScrapOptions')
Options.name = 'Scrap'

Options:SetScript('OnShow', function()
	local loaded, reason = LoadAddOn('Scrap_Options')
	if not loaded then
		local string = Options:CreateFontString(nil, nil, 'GameFontHighlight')
		string:SetText(format('"Scrap_Options" could not be loaded because the addon is %s', strlower(_G['ADDON_'..reason])))
		string:SetPoint('RIGHT', -40, 0)
		string:SetPoint('LEFT', 40, 0)
		string:SetHeight(30)
	end 
end)

InterfaceOptions_AddCategory(Options)