--[[
Copyright 2008-2023 João Cardoso
All Rights Reserved
--]]

local Sushi = LibStub('Sushi-3.1')
local BasePanel = LibStub('Sushi-3.1').OptionsGroup:NewClass()
local Options = Scrap:NewModule('Options', BasePanel('|Tinterface/addons/scrap/art/scrap-enabled:12:12:0:0|t Scrap'))
local L = LibStub('AceLocale-3.0'):GetLocale('Scrap')

local PATRONS = {{},{title='Jenkins',people={'Gnare','Seventeen','Justin Hall','Debora S Ogormanw','Johnny Rabbit'}},{title='Ambassador',people={'Julia F','Lolari ','Rafael Lins','Dodgen','Kopernikus ','Ptsdthegamer','Burt Humburg','Kelly Wolf','Adam Mann','Christie Hopkins','Bc Spear','Jury ','Tigran Andrew','Jeffrey Jones','Swallow@area52','Peter Hollaubek','Bobby Pagiazitis','Michael Kinasz','Sam Ramji','Syed Hamdani','Raidek ','Thinkdesigner '}}} -- generated patron list
local FOOTER = 'Copyright 2008-2023 João Cardoso'


--[[ Panels ]]--

function Options:OnEnable()
	self:SetFooter(FOOTER)
	self:SetSubtitle(L.GeneralDesc)
	self:SetChildren(function(self)
		self:AddHeader(L.Behaviour)
		self:AddCheck {set = 'sell', text = 'AutoSell'}
		self:AddCheck {set = 'repair', text = 'AutoRepair'}
		self:AddCheck {set = 'guild', text = 'GuildRepair', parent = 'repair'}
		self:AddCheck {set = 'safe', text = 'SafeMode'}
		self:AddCheck {set = 'destroy', text = 'DestroyWorthless'}
	
		self:AddHeader(L.Visuals)
		self:AddCheck {set = 'icons', text = 'Icons'}
		self:AddCheck {set = 'glow', text = 'Glow'}
	
		if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
			self:AddCheck {set = 'prices', text = 'SellPrices'}
		end
	end)


	local filters = BasePanel(self, 'Junk List '.. CreateAtlasMarkup('poi-workorders'))
	filters:SetSubtitle(L.FiltersDesc)
	filters:SetFooter(FOOTER)
	filters:SetChildren(function(self)
		local share = self:Add('Check', L.CharSpecific)
		share:SetChecked(not Scrap_CharSets.share)
		share:SetCall('OnInput', function(share, v)
			Scrap_CharSets.share = not v
			self:SendSignal('SETS_CHANGED')
		end)
		self:AddCheck {set = 'learn', text = 'Learning'}

		self:AddHeader(CALENDAR_FILTERS)
		self:AddCheck {set = 'unusable', text = 'Unusable', char = true}
		self:AddCheck {set = 'equip', text = 'LowEquip', char = true}
		self:AddCheck {set = 'consumable', text = 'LowConsume', char = true}
	end)

	local credits = Sushi.CreditsGroup(self, PATRONS, 'Patrons |Tinterface/addons/scrap/art/patreon:12:12|t')
	credits:SetSubtitle('Scrap is distributed for free and supported trough donations. A massive thank you to all the supporters on Patreon and Paypal who keep development alive. You can become a patron too at |cFFF96854patreon.com/jaliborc|r.', 'http://www.patreon.com/jaliborc')
	credits:SetFooter(FOOTER)
end


--[[ API ]]--

function BasePanel:AddHeader(text)
	self:Add('Header', text, GameFontHighlight, true)
end

function BasePanel:AddCheck(info)
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

function BasePanel:SetDefaults()
	Scrap_Sets, Scrap_CharSets = nil
	self:SendSignal('SETS_CHANGED')
	self:Update()
end
