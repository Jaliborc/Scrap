--[[
Copyright 2008-2018 João Cardoso
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

local Options = CreateFrame('Frame', 'ScrapOptions', InterfaceOptionsFrame)
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