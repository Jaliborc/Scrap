local _, Addon = ...
local Scrap2 = LibStub('WildAddon-1.1'):NewAddon('Scrap2', Addon, 'StaleCheck-1.0')
Scrap2.FakeList = {}
Scrap2.Tags = {}


--[[ Main API ]]--

function Scrap2:NewTag(info)
    info.hasAtlas = info.icon and C_Texture.GetAtlasID(info.icon) ~= 0
    info.iconScale = info.iconScale or 1

    self.Tags[info.id] = info
    return info
end

function Scrap2:SetTag(id, tag)
    self.FakeList[id] = tag
    self:SendSignal('LIST_CHANGED')
end

function Scrap2:GetTag(id, bag, slot)
    if id then
        local tagID = self.FakeList[id]
        if tagID then
            return tagID
        end
    end

    return 0
end

function Scrap2:GetTagInfo(...)
    return self.Tags[self:GetTag(...)]
end


--[[ UI ]]--

function Scrap2:TagMenu()
    local data = GameTooltip:IsVisible() and GameTooltip:GetPrimaryTooltipData() -- GameTooltip:GetItem() is bugged
	if data and data.id and ((data.guid and data.guid:find('^Item')) or (data.hyperlink and data.hyperlink:find('Hitem'))) then
        MenuUtil.CreateContextMenu(UIParent, function(_, drop)
            drop:SetTag('Scrap2_Tag')
            drop:CreateTitle(self:GetItemName(data.id))

            for i, tag in pairs(Scrap2.Tags) do
                drop:CreateRadio(tag.name, function() return self:GetTag(data.id) == i end, function() self:SetTag(data.id, i) end):AddInitializer(function(button)
                    local icon = button:AttachTexture()
                    icon[tag.hasAtlas and 'SetAtlas' or 'SetTexture'](icon, tag.icon)
                    icon:SetPoint('RIGHT')
                    icon:SetSize(18, 18)
                end)
            end
        end)
	end
end

function Scrap2:GetItemName(id)
    local name, _, quality = C_Item.GetItemInfo(id)
    return ITEM_QUALITY_COLORS[quality].color:WrapTextInColorCode(name)
end