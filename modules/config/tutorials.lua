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

local Tutorials = LibStub('CustomTutorials-2.1')
local L = Scrap_Locals

Tutorials.RegisterTutorials('Scrap', {
	savedvariable = Scrap.sets,
	key = 'tutorial',
	title = 'Scrap',

	{
		text = L.Tutorial_Welcome,
		image = 'Interface\\Addons\\Scrap\\art\\enabled-icon',
		point = 'Center',
		height = 150,
	},
	{
		text = L.Tutorial_Button,
		image = 'Interface\\Addons\\Scrap\\art\\tutorial-button',
		shineTop = 5, shineBottom = -5,
		shineRight = 5, shineLeft = -5,
		shine = Scrap,
		anchor = MerchantFrame,
		point = 'TopLeft', relPoint = 'TopRight',
		y = -16,
	},
	{
		text = L.Tutorial_Drag,
		image = 'Interface\\Addons\\Scrap\\art\\tutorial-drag',
		shine = MainMenuBarBackpackButton,
		shineTop = 6, shineBottom = -6,
		shineRight = 6, shineLeft = -6,
		point = 'TOPRIGHT',
		x = -5, y = -50
	},
	{
		text = L.Tutorial_Visualizer,
		image = 'Interface\\Addons\\Scrap\\art\\tutorial-visualizer',
		shineRight = -2, shineLeft = 2, shineTop = 6,
		shine = Scrap.tab,
		anchor = MerchantFrame,
		point = 'TopLeft', relPoint = 'TopRight',
		y = -16,
	},
	{
		text = L.Tutorial_Bye,
		image = 'Interface\\Addons\\Scrap\\art\\enabled-icon',
		point = 'Center',
		height = 150,
	},
})


function Scrap:BlastTutorials()
	Tutorials.TriggerTutorial('Scrap', 5)
end

function Scrap:ResetTutorials()
	Tutorials.ResetTutorials('Scrap')
	Tutorials.TriggerTutorial('Scrap', 5)
end
