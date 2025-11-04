local _, Addon = ...
local Scrap2 = LibStub('WildAddon-1.1'):NewAddon('Scrap2', Addon, 'StaleCheck-1.0')
Scrap2.FakeList = {}
Scrap2.Tags = {}


--[[ Main API ]]--

function Scrap2:NewTag(info)
    info.iconScale = info.iconScale or 1
    info.Filter = info.Filter or nop

    self.Tags[info.id] = info
    return info
end

function Scrap2:SetTag(id, tag)
    self.FakeList[id] = tag
    self:SendSignal('LIST_CHANGED')
end

function Scrap2:GetTag(id, bag, slot)
    if id then
        if self.FakeList[id] then
            return self.FakeList[id]
        end

        for i, tag in pairs(self.Tags) do
            if tag:Filter(id) then
                return i
            end
        end
    end

    return 0
end

function Scrap2:GetTagInfo(...)
    return self.Tags[self:GetTag(...)]
end


--[[ UI ]]--

function Scrap2:TagMenu()
    local link = GameTooltip:IsVisible() and select(2, GameTooltip:GetItem())
	if link then
        local id = tonumber(link:match('item:(%d+)'))
        local text = link:gsub("|H.-|h%[", ""):gsub("%]|h", "")

        MenuUtil.CreateContextMenu(UIParent, function(_, drop)
            drop:SetTag('Scrap2_Tag')
            drop:CreateTitle(text)

            for i, tag in pairs(Scrap2.Tags) do
                drop:CreateRadio(tag.name, function() return self:GetTag(id) == i end, function() self:SetTag(id, i) end):AddInitializer(function(button)
                    local icon = button:AttachTexture()
                    icon:SetSize(18 * tag.iconScale, 18 * tag.iconScale)
                    icon:SetAtlas(tag.icon)
                    icon:SetPoint('RIGHT')
                end)
            end
        end)
	end
end