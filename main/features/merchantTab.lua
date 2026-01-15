--[[
	Copyright 2008-2025 João Cardoso, All Rights Reserved
	Adds a tab to the merchant frame that opens the Scrap2 frame, taint free.
--]]

local Tab = Scrap2:NewModule('MerchantTab', LibStub('SecureTabs-2.0'):Add(MerchantFrame, nil, 'Scrap2'))
local L = LibStub('AceLocale-3.0'):GetLocale('Scrap2')
local W,H = MerchantFrame:GetSize()

function Tab:OnSelect()
	if AddOnUtil.LoadAddOn('Scrap_Window') then
		Scrap2.Frame:Anchor(MerchantFrame)
		Scrap2.Frame:SetFrameLevel(600)

		self:SetFrameLevel(610)

		MerchantFrame:SetSize(Scrap2.Frame:GetSize())
		UpdateUIPanelPositions(MerchantFrame)
		HideUIPanel(Scrap2.Frame.Container)
	end
end

function Tab:OnDeselect()
	if AddOnUtil.LoadAddOn('Scrap_Window') then
		Scrap2.Frame:Hide()
		MerchantFrame:SetSize(W,H)
		UpdateUIPanelPositions(MerchantFrame)
	end
end