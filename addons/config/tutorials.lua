--[[
Copyright 2008-2024 João Cardoso
All Rights Reserved
--]]

local Tutorials = Scrap:NewModule('Tutorials', 'CustomTutorials-2.1')
local L = LibStub('AceLocale-3.0'):GetLocale('Scrap')

function Tutorials:OnEnable()
	self:Register()
	self:TriggerTutorial(1)
end

function Tutorials:Register()
	self:RegisterTutorials {
		savedvariable = Scrap.sets,
		key = 'tutorial',
		title = 'Scrap',

		{
			text = L.Tutorial_Welcome,
			image = 'Interface/Addons/Scrap/art/scrap-big',
			imageW = 128, imageH = 128,
			point = 'CENTER',
		},
		{
			text = L.Tutorial_Button,
			image = 'Interface/Addons/Scrap/art/tutorial-button',
			point = 'TOPLEFT', relPoint = 'TOPRIGHT',
			shineTop = 5, shineBottom = -5,
			shineRight = 5, shineLeft = -5,
			shine = Scrap.Merchant,
			anchor = MerchantFrame,
			y = -16,
		},
		{
			text = L.Tutorial_Drag,
			image = 'Interface/Addons/Scrap/art/tutorial-drag',
			point = 'BOTTOMRIGHT', relPoint = 'BOTTOMRIGHT',
			anchor = MainMenuBarBackpackButton,
			shine = MainMenuBarBackpackButton,
			shineTop = 6, shineBottom = -6,
			shineRight = 6, shineLeft = -6,
			x = -150, y = 45,
		},
		{
			text = L.Tutorial_Visualizer,
			image = 'Interface/Addons/Scrap/art/tutorial-visualizer',
			shineRight = -2, shineLeft = 2, shineTop = 6,
			point = 'TOPLEFT', relPoint = 'TOPRIGHT',
			shine = Scrap.Visualizer and Scrap.Visualizer.ParentTab,
			anchor = MerchantFrame,
			y = -16,
		},
		{
			text = L.Tutorial_Bye,
			image = 'Interface/Addons/Scrap/art/scrap-big',
			imageW = 128, imageH = 128,
			point = 'CENTER',
		}
	}
end

function Tutorials:Start()
	self:Register()
	self:TriggerTutorial(5)
end

function Tutorials:Restart()
	self:Register()
	self:ResetTutorials()
	self:TriggerTutorial(1)
end