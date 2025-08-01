--[[
Copyright 2008-2025 João Cardoso
All Rights Reserved
--]]

local Sushi = LibStub('Sushi-3.2')
local Options = Scrap:NewModule('Options', Sushi.OptionsGroup:NewClass())
local L = LibStub('AceLocale-3.0'):GetLocale('Scrap')

local PATRONS = {{title='Jenkins',people={'Gnare','Debora S Ogormanw','Johnny Rabbit','Shaun Potts','Michel Heyn'}},{title='Ambassador',people={'Julia F','Lolari ','Rafael Lins','Ptsdthegamer','Swallow@area52','Adam Mann','Bc Spear','Jury ','Peter Hollaubek','Michael Kinasz','Brian Joaquin','Lisa','M Prieto','Ronald Platz','Airdrigh','Ole Jonny Søndenå'}}} -- generated patron list
local PATREON_ICON = '  |TInterface/Addons/Scrap/art/patreon:12:12|t'
local HELP_ICON = '  |T516770:13:13:0:0:64:64:14:50:14:50|t'
local FOOTER = 'Copyright 2012-2025 João Cardoso'


--[[ Startup ]]--

function Options:OnLoad()
	self.Main = self('|Tinterface/addons/scrap/art/scrap-small:16:16:2:0|t  Scrap')
		:SetSubtitle(L.GeneralDescription):SetFooter(FOOTER):SetChildren(self.OnMain)
	self.Filters = self(self.Main, L.JunkList .. ' ' .. CreateAtlasMarkup('poi-workorders'))
		:SetSubtitle(L.ListDescription):SetFooter(FOOTER):SetChildren(self.OnFilters)

	self.Help = Sushi.OptionsGroup(self.Main, HELP_LABEL .. HELP_ICON)
		:SetSubtitle(L.HelpDescription):SetFooter(FOOTER):SetChildren(self.OnHelp)
	self.Credits = Sushi.OptionsGroup(self.Main, 'Patrons' .. PATREON_ICON)
		:SetSubtitle(L.PatronsDescription):SetFooter(FOOTER):SetOrientation('HORIZONTAL'):SetChildren(self.OnCredits)
end


--[[ Panels ]]--

function Options:OnMain()
	self:Add('RedButton', SETTINGS_KEYBINDINGS_LABEL):SetKeys{top = -5, bottom = 15}:SetCall('OnClick', function()
		SettingsPanel:SelectCategory(SettingsPanel.keybindingsCategory)
	end)

	self:AddHeader(L.Behaviour)
	self:AddCheck {set = 'sell', text = 'AutoSell'}
	self:AddCheck {set = 'repair', text = 'AutoRepair'}
	self:AddCheck {set = 'guild', text = 'GuildRepair', parent = 'repair'}
	self:AddCheck {set = 'safe', text = 'SafeMode'}
	self:AddCheck {set = 'destroy', text = 'DestroyWorthless'}

	self:AddHeader(L.Visuals)
	self:AddCheck {set = 'icons', text = 'Icons'}
	self:AddCheck {set = 'glow', text = 'Glow'}

	if LE_EXPANSION_LEVEL_CURRENT == LE_EXPANSION_CLASSIC then
		self:AddCheck {set = 'prices', text = 'SellPrices'}
	end
end

function Options:OnFilters()
	self:Add('Check', L.CharSpecific):SetChecked(not Scrap.charsets.share):SetCall('OnInput', function(share, v)
		Scrap.charsets.share = not v
		Scrap:SendSignal('SETS_CHANGED')
	end)
	self:AddCheck {set = 'learn', text = 'Learning'}

	self:AddHeader(CALENDAR_FILTERS)
	self:AddCheck {set = 'unusable', text = 'Unusable', char = true}
	self:AddCheck {set = 'equip', text = 'LowEquip', char = true}
	self:AddTreshold ('equip')
	self:AddCheck {set = 'consumable', text = 'LowConsumable', char = true}
	self:AddTreshold ('consumable')
end

function Options:OnHelp()
	for i = 1, #L.FAQ, 2 do
		self:Add('ExpandHeader', L.FAQ[i], GameFontHighlightSmall):SetExpanded(self[i]):SetCall('OnClick', function() self[i] = not self[i] end)

		if self[i] then
			local answer = self:Add('Header', L.FAQ[i+1], GameFontHighlightSmall)
			answer.left, answer.right, answer.bottom = 16, 16, 16
		end
	end

	self:Add('RedButton', 'Show Tutorial'):SetWidth(200):SetCall('OnClick', function() Scrap.Tutorials:Restart() end).top = 10
	self:Add('RedButton', 'Ask Community'):SetWidth(200):SetCall('OnClick', function()
		Sushi.Popup:External('bit.ly/discord-jaliborc')
		SettingsPanel:Close(true)
	end)
end

function Options:OnCredits()
	for i, rank in ipairs(PATRONS) do
		if rank.people then
			self:Add('Header', rank.title, GameFontHighlight, true).top = i > 1 and 20 or 0

			for j, name in ipairs(rank.people) do
				self:Add('Header', name, i > 1 and GameFontHighlight or GameFontHighlightLarge):SetWidth(180)
			end
		end
	end

	self:AddBreak()
	self:Add('RedButton', 'Join Us'):SetWidth(200):SetCall('OnClick', function()
		Sushi.Popup:External('patreon.com/jaliborc')
		SettingsPanel:Close(true)
	end).top = 20
end


--[[ API ]]--

function Options:AddHeader(text)
	self:Add('Header', text, GameFontHighlight, true)
end

function Options:AddCheck(info)
	local sets = info.char and Scrap.charsets or Scrap.sets
	local b = self:Add('Check', L[info.text])
	b.left = b.left + (info.parent and 10 or 0)
	b:SetEnabled(not info.parent or sets[info.parent])
	b:SetTip(L[info.text], L[info.text .. 'Tip'])
	b:SetChecked(sets[info.set])
	b:SetSmall(info.parent)
	b:SetCall('OnInput', function(b, v)
		sets[info.set] = v
		Scrap:SendSignal('LIST_CHANGED')
	end)
end

function Options:AddTreshold(set)
	if Scrap.charsets[set] then
		local key = set .. 'Lvl'
		local Set = set:gsub('^%l', strupper)
		local s = self:Add('Slider', L.iLevelTreshold, Scrap.charsets[key] * 100, 0,100,1, '%s%')
		s:SetSmall(true):SetKeys {top = 5, left = 40, bottom = 15}
		s:SetTip(L['Low' .. Set], L[Set .. 'LevelTip'])
		s:SetCall('OnInput', function(s, v)
			Scrap.charsets[key] = v / 100
			Scrap:SendSignal('LIST_CHANGED')
		end)
	end
end