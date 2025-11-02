local _, Addon = ...
local Scrap2 = LibStub('WildAddon-1.1'):NewAddon('Scrap2', Addon, 'StaleCheck-1.0')

local Categories = {
    {name = 'Junk', icon = 'lootroll-toast-icon-greed-up'},
    {name = 'Disenchant', icon = 'lootroll-toast-icon-disenchant-up'},
    {name = 'Bank', icon = 'banker'},
    {name = 'Warband', icon = 'warbands-icon', iconScale = 1.1},
    {name = 'Guild', icon = 'warfronts-FieldMapIcons-Neutral-Banner-Minimap', iconScale = 1.1},
    {name = NONE}
}

function Scrap2:TagItem()
    local link = GameTooltip:IsVisible() and select(2, GameTooltip:GetItem())
	if link then
        local id = tonumber(link:match('item:(%d+)'))
        local text = link:gsub("|H.-|h%[", ""):gsub("%]|h", "")

        MenuUtil.CreateContextMenu(UIParent, function(_, drop)
            drop:SetTag('Scrap2_Tag')
            drop:CreateTitle(text)

            for i, tag in ipairs(Categories) do
                drop:CreateRadio(tag.name, nop, nop):AddInitializer(function(button)
                    local icon = button:AttachTexture()
                    icon:SetSize(18 * (tag.iconScale or 1), 18 * (tag.iconScale or 1))
                    icon:SetAtlas(tag.icon)
                    icon:SetPoint('RIGHT')
                end)
            end
        end)
	end
end