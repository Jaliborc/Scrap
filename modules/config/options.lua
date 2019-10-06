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

local Patrons = {{title='Jenkins',people={'Gnare','Arriana Sylvester','SirZooro','ProfessahX'}},{},{title='Ambassador',people={'Sembiance','Fernando Bandeira','Michael Irving','Julia F','Peggy Webb','Lolari','Craig Falb','Mary Barrentine','Grey Sample','Patryk Kalis','Lifeprayer','Steve Lund'}}} -- generated patron list
local L = LibStub('AceLocale-3.0'):GetLocale('Scrap')

local Options = SushiMagicGroup(Scrap.options)
Options:SetAddon('Scrap')
Options:SetFooter('Copyright 2008-2019 João Cardoso')
Options:SetTitle(Scrap.options.name)
Options:SetChildren(function(self)
	self:CreateHeader('Behaviour', 'GameFontHighlight', true)
	self:Create('CheckButton', 'sell')
	self:Create('CheckButton', 'repair')
	self:Create('CheckButton', 'guild', nil, not Scrap.sets.repair, true)
	self:Create('CheckButton', 'safe')
	self:Create('CheckButton', 'learn')

	self:CreateHeader('Filters', 'GameFontHighlight', true)
	self:Create('CheckButton', 'unusable')
	self:Create('CheckButton', 'equip')
	self:Create('CheckButton', 'consumable')

	self:CreateHeader('Visuals', 'GameFontHighlight', true)
	self:Create('CheckButton', 'glow')
	self:Create('CheckButton', 'icons')
end)

local Share = SushiCheckButton(Options)
Share:SetPoint('BOTTOM', Options, 'TOP', 115, 10)
Share:SetText(L.CharSpecific)
Share:SetChecked(not Scrap.charsets.shared)
Share:SetScale(.9)
Share:SetCall('OnInput', function(self, v)
	Scrap.charsets.share = not v
	Scrap:SendSignal('SETS_CHANGED')
end)

local Credits = SushiCreditsGroup:CreateOptionsCategory(Options:GetTitle())
Credits:SetFooter('Copyright 2008-2019 João Cardoso')
Credits:SetWebsite('http://www.patreon.com/jaliborc')
Credits:SetPeople(Patrons)
Credits:SetAddon('Scrap')

function Scrap.options.default()
	Scrap_Sets, Scrap_CharSets = nil
	ReloadUI()
end
