local UpgradeLoadingDialog = class("UpgradeLoadingDialog", require("upgrade.ui.UpgradeDialogBase"))
local TAG = "UpgradeLoadingDialog"

local txtWidth = 280
local txtHeight = 80
local iconWidth = 42
local iconHeight = 42
local iconMargin = 18
local bgWidth = txtWidth + iconWidth + iconMargin * 2
local bgHeight = txtHeight
local iconX = iconMargin + iconWidth / 2

--[[
    参数
    @cx, cy
    @scale
]]
function UpgradeLoadingDialog:ctor(params)
    UpgradeLoadingDialog.super.ctor(self, params)

    -- 进度框
    local bg = display.newScale9Sprite("img/upgrade/loading_dialog_bg.png", params.cx, params.cy, CCSize(bgWidth, bgHeight))
    self:addChild(bg)
    bg:setScale(params.scale)

    local icon = display.newSprite("img/upgrade/icon_loading.png")
    icon:setAnchorPoint(ccp(0.5, 0.5))
    icon:setPosition(iconX, bgHeight / 2)
    icon:runAction(CCRepeatForever:create(CCRotateTo:create(1, 720)))
    bg:addChild(icon)

    -- 文字
    local label = ui.newTTFLabel({
        text = "正在加载中，请稍候...",
        fontSize = 24,
        color = ccc3(255, 255, 255),
    })

    label:setAnchorPoint(ccp(0, 0.5))
    label:setPosition(iconX + iconMargin + iconWidth / 2, bgHeight / 2)
    bg:addChild(label)
end

return UpgradeLoadingDialog
