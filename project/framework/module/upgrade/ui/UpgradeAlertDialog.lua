local UpgradeAlertDialog = class("UpgradeAlertDialog", require("upgrade.ui.UpgradeDialogBase"))
local TAG = "UpgradeAlertDialog"

local BG_WIDTH = 480
local BG_HEIGHT = 364
local LABEL_ORDER = 10
--[[
    参数
    @cx, cy
    @scale
    @title: 标题
    @prompt: 提示内容
    @btn1: 按键一
    @id1: 按键一的id
    @btn2: 按键二
    @id2: 按键二的id
    @close: 是否有关闭的叉
    @closeId: 关闭叉的 id
    @checkbox: 勾选框旁的提示文字
]]
function UpgradeAlertDialog:ctor(params)
    UpgradeAlertDialog.super.ctor(self, params)

    local scale = params.scale
    local width, height = 2 * params.cx, 2 * params.cy
    local root = CCNode:create()
    self:addChild(root)

    -- 提示文字
    local prompt = ui.newTTFLabel({
        text = params.prompt,
        size = 24 * scale,
        dimensions = CCSizeMake(400*scale, 0),
        color = ccc3(113, 97, 74),
    })
    prompt:setAnchorPoint(ccp(0.5, 1))
    local size = prompt:getContentSize()

    local checkboxHeight = 0
    local bgSize = CCSize(470 * scale, BG_HEIGHT * scale)
    if size.height > 160 * scale then
        if size.height > 700 * scale then
            size.height = 700 * scale
        end
        if params.checkbox ~= nil then
            checkboxHeight = 30 * scale
        end
        bgSize = CCSize(470 * scale, size.height + 160 * scale + checkboxHeight)
    end

    local bgHeightMin = params.cy - bgSize.height/2
    local bgHeightMax = params.cy + bgSize.height/2

    -- 背景
    local bg = display.newScale9Sprite("img/upgrade/alert_dialog_bg.png", params.cx, params.cy, bgSize)
    bg:setCapInsets(CCRect(120, 120, 10, 10))
    --bg:setScale(params.scale)
    root:addChild(bg)

    local title = ui.newTTFLabel({
        text = params.title or "提示",
        size = 28 * scale,
        color = ccc3(73, 63, 48),
    })
    title:setAnchorPoint(ccp(0.5, 1))
    title:setPosition(ccp(params.cx, bgHeightMax - 18 * scale))
    root:addChild(title)

    prompt:setPosition(ccp(params.cx, bgHeightMax - 58 * scale))
    root:addChild(prompt)

    local menus = {}

    local showSingleBtn = params.id2 == nil or params.btn2 == nil

    if showSingleBtn == true then
        local btn1 = ui.newImageMenuItem({
            image = "img/upgrade/btn_mid_green_n.png",
            imageSelected = "img/upgrade/btn_mid_green_d.png",
            listener = function()
                self:onClick(params.id1 or self.ID_YES)
            end,
        })
        btn1:setAnchorPoint(ccp(0.5, 0))
        btn1:setPosition(ccp(params.cx, bgHeightMin + 25 * scale))
        btn1:setScale(scale)

        local text = ui.newTTFLabel({
            text = params.btn1,
        })
        text:setAnchorPoint(ccp(0.5, 0.5))
        text:setPosition(ccp(195, 36))
        btn1:addChild(text)
        menus[#menus + 1] = btn1
    else
        local btn1 = ui.newImageMenuItem({
            image = "img/upgrade/btn_yes_n.png",
            imageSelected = "img/upgrade/btn_yes_d.png",
            listener = function()
                self:onClick(params.id1 or self.ID_YES)
            end,
        })
        local text = ui.newTTFLabel({
            text = params.btn1,
        })
        text:setAnchorPoint(ccp(0.5, 0.5))
        text:setPosition(ccp(100, 36))
        btn1:addChild(text, LABEL_ORDER)
        menus[#menus + 1] = btn1
        btn1:setAnchorPoint(ccp(1, 0))
        btn1:setPosition(ccp(params.cx - 5 * scale, bgHeightMin + 25 * scale))
        btn1:setScale(scale)

        local btn2 = ui.newImageMenuItem({
            image = "img/upgrade/btn_no_n.png",
            imageSelected = "img/upgrade/btn_no_d.png",
            listener = function()
                self:onClick(params.id2 or self.ID_NO)
            end,
        })
        text = ui.newTTFLabel({
            text = params.btn2,
        })
        text:setAnchorPoint(ccp(0.5, 0.5))
        text:setPosition(ccp(100, 36))
        btn2:setPosition(ccp(params.cx + 5 * scale, bgHeightMin + 25 * scale))
        btn2:setAnchorPoint(ccp(0, 0))
        btn2:addChild(text, LABEL_ORDER)
        btn2:setScale(scale)
        menus[#menus + 1] = btn2
    end

    -- 关闭按钮
    if params.close == true then
        local close = ui.newImageMenuItem({
            image = "img/upgrade/dialog_close_btn_n.png",
            imageSelected = "img/upgrade/dialog_close_btn_d.png",
            listener = function() self:onClick(params.closeId) end,
        })
        local offset = (width - bgSize.width)/2
        close:setPosition(ccp(width - offset - 30 * scale, bgHeightMax - 13 * scale))
        close:setScale(scale)
        menus[#menus + 1] = close
    end

    if params.checkbox ~= nil then
        self.checkbox_ = require("upgrade.ui.UpgradeCheckbox").new({ common = "img/upgrade/checkbox_off.png", select = "img/upgrade/checkbox_on.png", listener = nil })
        self.checkbox_:setAnchorPoint(ccp(0, 0))
        self.checkbox_:setPosition(ccp(65 * scale, bgHeightMin + 110 * scale))
        self.checkbox_:setScale(scale)
        root:addChild(self.checkbox_)

        local checkboxText = ui.newTTFLabel({
            text = params.checkbox or "",
            size = 15 * scale,
            color = ccc3(113, 97, 74),
        })
        checkboxText:setAnchorPoint(ccp(0, 0))
        checkboxText:setPosition(ccp(80 * scale, bgHeightMin + 100 * scale))
        root:addChild(checkboxText)
    end

    root:addChild(ui.newMenu(menus))
end

function UpgradeAlertDialog:isChecked()
    local checked = false
    if self.checkbox_ ~= nil then
        checked = self.checkbox_:isChecked()
    end
    return checked or false
end

return UpgradeAlertDialog
