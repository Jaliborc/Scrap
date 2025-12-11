--[[
    Copyright 2008-2025 João Cardoso, All Rights Reserved
    Panel for list visualization and configuration.
--]]

local Visualizer = Scrap2:NewModule('Visualizer', Scrap2Visualizer)

function Visualizer:OnLoad()
    self:SetSize(702, 534)

    for i, tag in pairs(Scrap2.Tags) do
        local b = CreateFrame('Button', nil, self.LeftInset, 'Scrap2TagButtonTemplate')
        b:SetPoint('TOP', -1, -32*i-5)
        b:SetText(tag.name)

        b.Icon[tag.hasAtlas and 'SetAtlas' or 'SetTexture'](b.Icon, tag.icon)
        b.Icon:SetScale(tag.iconScale)
    end

    --[[local buttonWidth = 30
    local buttonHeight = 30
    local spacing = 5
    local buttonsPerRow = 2

    local totalWidth = (buttonWidth * buttonsPerRow) + (spacing * (buttonsPerRow - 1))
    local startX = (self.LeftInset:GetWidth() - totalWidth) / 2
    local currentX = startX
    local currentY = -10

    for i, tag in pairs(Scrap2.Tags) do
        local b = CreateFrame('Button', nil, self.LeftInset)
        b:SetSize(buttonWidth, buttonHeight)
        
        local col = i % buttonsPerRow
        local row = math.floor(i / buttonsPerRow)
        
        b:SetPoint('TOPLEFT', self.LeftInset, 'TOPLEFT', 
                startX + (col * (buttonWidth + spacing)), 
                -10 - (row * (buttonHeight + spacing)))
        
        b.Border = b:CreateTexture(nil, 'BORDER')
        b.Border:SetAtlas('adventureguide-rewardring')
        b.Border:SetAllPoints()
        
        if tag.icon then
            b.Icon = b:CreateTexture(nil, 'BACKGROUND', nil, 2)
            b.Icon:SetPoint('CENTER')
            b.Icon:SetAtlas(tag.icon)
            b.Icon:SetSize(20,20)

            b.Background = b:CreateTexture(nil, 'BACKGROUND', nil, 1)
            b.Background:SetAtlas('common-mask-circle')
            b.Background:SetAllPoints(b.Icon)
            b.Background:SetVertexColor(0,0,0, 0.9)
        end
    end--]]
    
    RegisterUIPanel(self, {area = 'left', pushable = 3,	whileDead = 1})
    C_Timer.After(1, function()
        ShowUIPanel(self)
    end)
end