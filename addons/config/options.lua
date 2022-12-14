--[[
Copyright 2008-2022 João Cardoso
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

local Sushi = LibStub('Sushi-3.1')
local Options = Scrap:NewModule('Options', Sushi.OptionsGroup('|Tinterface/addons/scrap/art/enabled-icon:12:12:0:0|t Scrap'))
local L = LibStub('AceLocale-3.0'):GetLocale('Scrap')

local PATRONS = {{},{title='Jenkins',people={'Gnare','Seventeen','Grumpyitis','Justin Hall','Debora S Ogormanw','Angryclown','Johnny Rabbit','Frankn\'furter'}},{title='Ambassador',people={'Fernando Bandeira','Julia F','Lolari ','Owen Pitcairn','Rafael Lins','Mediocre Monk','Joanie Nelson','Nitro ','Guidez ','Ptsdthegamer','Dodgen','Frosted(mrp)','Burt Humburg','Unhalted','Connie ','Adam Mann','Christie Hopkins','Kopernikus ','Bc Spear','Kendall Lane','Jury ','Bob Farrell','Dominik','Jeff Stokes','Tigran Andrew','Marinoco ','Keks','Jeffrey Jones','Swallow@area52','Daniel Foster','Peter Hollaubek','Daniel  Di Battis','Teofan Bobarnea','Bobby Pagiazitis','Metadata','Lars Norberg'}}} -- generated patron list
local FOOTER = 'Copyright 2008-2022 João Cardoso'


--[[ Startup ]]--

function Options:OnEnable()
	local credits = Sushi.CreditsGroup(self, PATRONS, 'Patrons |Tinterface/addons/scrap/art/patreon:12:12|t')
	credits:SetSubtitle('Scrap is distributed for free and supported trough donations. A massive thank you to all the supporters on Patreon and Paypal who keep development alive. You can become a patron too at |cFFF96854patreon.com/jaliborc|r.', 'http://www.patreon.com/jaliborc')
	credits:SetFooter(FOOTER)

	local share = Sushi.Check(self)
	share:SetChecked(not Scrap_CharSets.share)
	share:SetPoint(unpack(SettingsPanel and {'TOPLEFT', 60, 57} or {'TOPRIGHT', -30, 36}))
	share:SetText(L.CharSpecific)
	share:SetScale(.9)
	share:SetCall('OnInput', function(share, v)
		Scrap_CharSets.share = not v
		self:SendSignal('SETS_CHANGED')
	end)

	self:SetFooter(FOOTER)
	self:SetSubtitle(L.Description)
	self:SetChildren(self.OnPopulate)
	self:SetCall('OnDefaults', self.OnDefaults)
end

function Options:OnDefaults()
	Scrap_Sets, Scrap_CharSets = nil
	self:SendSignal('SETS_CHANGED')
	self:Update()
end

function Options:OnPopulate()
	self:AddHeader(L.Behaviour)
	self:AddCheck {set = 'sell', text = 'AutoSell'}
	self:AddCheck {set = 'repair', text = 'AutoRepair'}
	self:AddCheck {set = 'guild', text = 'GuildRepair', parent = 'repair'}
	self:AddCheck {set = 'safe', text = 'SafeMode'}
	self:AddCheck {set = 'destroy', text = 'DestroyWorthless'}

	self:AddHeader(CALENDAR_FILTERS)
	self:AddCheck {set = 'unusable', text = 'Unusable', char = true}
	self:AddCheck {set = 'equip', text = 'LowEquip', char = true}
	self:AddCheck {set = 'consumable', text = 'LowConsume', char = true}
	self:AddCheck {set = 'learn', text = 'Learning'}

	self:AddHeader(L.Visuals)
	self:AddCheck {set = 'glow', text = 'Glow'}
	self:AddCheck {set = 'icons', text = 'Icons'}
end


--[[ API ]]--

function Options:AddHeader(text)
	self:Add('Header', text, GameFontHighlight, true)
end

function Options:AddCheck(info)
	local sets = info.char and Scrap_CharSets or Scrap_Sets
	local b = self:Add('Check', L[info.text])
	b.left = b.left + (info.parent and 10 or 0)
	b:SetEnabled(not info.parent or sets[info.parent])
	b:SetTip(L[info.text], L[info.text .. 'Tip'])
	b:SetChecked(sets[info.set])
	b:SetSmall(info.parent)
	b:SetCall('OnInput', function(b, v)
		sets[info.set] = v
		self:SendSignal('LIST_CHANGED')
	end)
end
