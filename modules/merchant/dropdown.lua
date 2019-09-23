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

local Dropdown = CreateFrame('Frame', nil, nil, 'UIDropDownMenuTemplate')
local L = Scrap_Locals

function Dropdown:Toggle(anchor)
	local info = {
		{
			text = 'Scrap', notCheckable = 1, isTitle = 1
    },
    {
			text = L.AdvancedOptions, notCheckable = 1,
			func = function()
				InterfaceOptionsFrame_OpenToCategory(ScrapOptions)
				InterfaceOptionsFrame_OpenToCategory(ScrapOptions)
			end
    },
    {
 			text = L.ShowTutorials, notCheckable = 1,
			func = function()
		    LibStub('CustomTutorials-2.1').ResetTutorials('Scrap')
				Scrap:BlastTutorials()
			end
    }
	}

	EasyMenu(info, self, anchor or 'Scrap', 0, 0, 'MENU')
end

Scrap.Dropdown = Dropdown
