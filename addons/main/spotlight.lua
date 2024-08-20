--[[
Copyright 2008-2024 João Cardoso
All Rights Reserved
--]]

if BagBrother then return end
local Spotlight = Scrap:NewModule('Spotlight')
local C = LibStub('C_Everywhere').Container
local R,G,B = GetItemQualityColor(0)

--[[ Display ]]--

local eventframe = CreateFrame("FRAME", "ScrapEventFrame");
eventframe:RegisterEvent("PLAYER_ENTERING_WORLD");
eventframe:RegisterEvent("BAG_UPDATE");
eventframe:RegisterEvent("MERCHANT_SHOW");
eventframe:RegisterEvent("BAG_CONTAINER_UPDATE");
eventframe:RegisterEvent("BAG_NEW_ITEMS_UPDATED");
eventframe:RegisterEvent("UNIT_INVENTORY_CHANGED");

local function EventHandler(self, event, ...)
	if DLAPI then DLAPI.DebugLog("Scrap", "Spotlight:eventHandler Entered: " .. event) end
	Spotlight:UpdateAll()
end

eventframe:SetScript("OnEvent", EventHandler);

function Spotlight:OnEnable()
	if DLAPI then DLAPI.DebugLog("Scrap", "Spotlight:OnEnable Entered") end
	self.Glows, self.Icons = {}, {}
	self:RegisterSignal('LIST_CHANGED', 'UpdateAll')

	if ContainerFrame_Update then
		hooksecurefunc('ContainerFrame_Update', function(frame) self:UpdateAll() end)
	else
		local frameContainer = _G["ContainerFrameContainer"]
		for i, frame in ipairs(frameContainer.ContainerFrames) do
			hooksecurefunc(frame, 'Update', function() self:UpdateAll() end)
		end
		hooksecurefunc(ContainerFrameCombinedBags, 'Update', function() self:UpdateAll() end)
	end
end

Spotlight.delayCounter = 0
Spotlight.maxDelays = 5

function Spotlight:UpdateAll()
    if DLAPI then DLAPI.DebugLog("Scrap", "Spotlight:UpdateAll Entered") end
    local combinedBags = _G["ContainerFrameCombinedBags"]
    if #combinedBags.Items == 0 then
        if self.delayCounter < self.maxDelays then
            self.delayCounter = self.delayCounter + 1
            if DLAPI then DLAPI.DebugLog("Scrap", "Spotlight:UpdateAll Delayed execution scheduled, count: " .. self.delayCounter) end
            C_Timer.After(1, function() self:UpdateAll() end)
        else
            if DLAPI then DLAPI.DebugLog("Scrap", "Spotlight:UpdateAll Max delay count reached") end
        end
        --return
    end
    for i, button in ipairs(combinedBags.Items) do
        self:UpdateButtonCombined(button)
        --call(frame)
    end

    local frameContainer = _G["ContainerFrameContainer"]
    if #frameContainer.ContainerFrames == 0 then
        if self.delayCounter < self.maxDelays then
            self.delayCounter = self.delayCounter + 1
            if DLAPI then DLAPI.DebugLog("Scrap", "Spotlight:UpdateAll Delayed execution scheduled, count: " .. self.delayCounter) end
            C_Timer.After(1, function() self:UpdateAll() end)
        else
            if DLAPI then DLAPI.DebugLog("Scrap", "Spotlight:UpdateAll Max delay count reached") end
        end
        --return
    end
    for i, frame in ipairs(frameContainer.ContainerFrames) do
        if #frame.Items == 0 then
            if self.delayCounter < self.maxDelays then
                self.delayCounter = self.delayCounter + 1
                if DLAPI then DLAPI.DebugLog("Scrap", "Spotlight:UpdateAll Delayed execution scheduled, count: " .. self.delayCounter) end
                C_Timer.After(1, function() self:UpdateAll() end)
            else
                if DLAPI then DLAPI.DebugLog("Scrap", "Spotlight:UpdateAll Max delay count reached") end
            end
            --return
        end
        for j, button in ipairs(frame.Items) do
            self:UpdateButton(frame, button)
        end
    end
    --self.delayCounter = 0 -- Reset the counter after successful execution
end

function Spotlight:UpdateButtonCombined(button)
	--if DLAPI then DLAPI.DebugLog("Scrap", "Spotlight:UpdateButton Entered") end
	--if button:IsShown() then
		--if DLAPI then DLAPI.DebugLog("Scrap", "Spotlight:UpdateButton:IsShown Entered") end
		local bag, slot = button.bagID, button:GetID()
		--local bag, slot = self:GetBagAndSlot(button)
		local id = C.GetContainerItemID(bag, slot)
		local isJunk = id and Scrap:IsJunk(id, bag, slot)

		local icon = (button.JunkIcon or self.Icons[button] or self:NewIcon(button))
		local glow = (self.Glows[button] or self:NewGlow(button))

		icon:SetShown(isJunk and Scrap.sets.icons)
		glow:SetShown(isJunk and Scrap.sets.glow)

		if(isJunk and Scrap.sets.icons) then
			if DLAPI then DLAPI.DebugLog("Scrap", "Icon Enabled On: %s", button:GetID()) end
		end

		if button.IconBorder then
			button.IconBorder:SetAlpha(glow:IsShown() and 0 or 1)
		end
	--end
end

function Spotlight:UpdateButton(frame, button)
	--if DLAPI then DLAPI.DebugLog("Scrap", "Spotlight:UpdateButton Entered") end
	--if button:IsShown() then
		--if DLAPI then DLAPI.DebugLog("Scrap", "Spotlight:UpdateButton:IsShown Entered") end
		local bag, slot = button.bagID or frame:GetID(), button:GetID()
		local id = C.GetContainerItemID(bag, slot)
		local isJunk = id and Scrap:IsJunk(id, bag, slot)

		local icon = (button.JunkIcon or self.Icons[button] or self:NewIcon(button))
		local glow = (self.Glows[button] or self:NewGlow(button))

		icon:SetShown(isJunk and Scrap.sets.icons)
		glow:SetShown(isJunk and Scrap.sets.glow)

		if(isJunk and Scrap.sets.icons) then
			if DLAPI then DLAPI.DebugLog("Scrap", "FrameName: %s", frame:GetID()) end
		end

		if button.IconBorder then
			button.IconBorder:SetAlpha(glow:IsShown() and 0 or 1)
		end
	--end
end



--[[ Construct ]]--

function Spotlight:NewGlow(button)
	local glow = button:CreateTexture(nil, 'OVERLAY')
	glow:SetTexture('Interface/Buttons/UI-ActionButton-Border')
	glow:SetVertexColor(R,G,B, .7)
	glow:SetBlendMode('ADD')
	glow:SetPoint('CENTER')
	glow:SetSize(67, 67)

	self.Glows[button] = glow
	return glow
end

function Spotlight:NewIcon(button)
	local icon = button:CreateTexture(nil, 'OVERLAY')
	icon:SetTexture('Interface/Buttons/UI-GroupLoot-Coin-Up')
	icon:SetPoint('TOPLEFT', 2, -2)
	icon:SetSize(15, 15)

	self.Icons[button] = icon
	return icon
end
