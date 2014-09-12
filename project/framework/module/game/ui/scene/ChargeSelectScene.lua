local ChargeSelectScene = class("ChargeSelectScene", import("game.ui.scene.JJGameSceneBase"))
local TAG = "ChargeSelectScene"

local pcm = require("game.data.config.PayConfigManager")


local TYPE_PARAM = {} -- 类型对应的显示参数：图片、文字
TYPE_PARAM[PayDef.CHARGE_TYPE_G10086_SMS_API] = {
    img = "charge/charge_type_iv_sms.png",
    txt = "短信充值",
}
TYPE_PARAM[PayDef.CHARGE_TYPE_WOVAC_SMS] = {
    img = "charge/charge_type_iv_sms.png",
    txt = "短信充值",
}
TYPE_PARAM[PayDef.CHARGE_TYPE_EGAME_SMS] = {
    img = "charge/charge_type_iv_sms.png",
    txt = "短信充值",
}
TYPE_PARAM[PayDef.CHARGE_TYPE_UMPAY_SMS] = {
    img = "charge/charge_type_iv_sms.png",
    txt = "短信充值",
}
TYPE_PARAM[PayDef.CHARGE_TYPE_TELECOM_SMS] = {
    img = "charge/charge_type_iv_sms.png",
    txt = "短信充值",
}
TYPE_PARAM[PayDef.CHARGE_TYPE_G10086_SMS] = {
    img = "charge/charge_type_iv_sms.png",
    txt = "短信充值",
}
TYPE_PARAM[PayDef.CHARGE_TYPE_ALIPAY] = {
    img = "charge/charge_type_iv_alipay.png",
    txt = "支付宝",
}
TYPE_PARAM[PayDef.CHARGE_TYPE_UMPAY_EBANK] = {
    img = "charge/charge_type_iv_unionpay.png",
    txt = "信用卡充值",
}
TYPE_PARAM[PayDef.CHARGE_TYPE_SZF_CMCC] = {
    img = "charge/charge_type_iv_szf.png",
    txt = "神州行充值卡",
}
TYPE_PARAM[PayDef.CHARGE_TYPE_SZF_UNICOM] = {
    img = "charge/charge_type_iv_unicom.png",
    txt = "联通充值卡",
}
TYPE_PARAM[PayDef.CHARGE_TYPE_OTHER] = {
    img = "charge/charge_type_iv_other.png",
    txt = "JJ卡密",
}

local ID_PROMPT = 1

function ChargeSelectScene:initView()
    ChargeSelectScene.super.initView(self)

    local CHARGE_TITLE_HEIGHT = (self.dimens_.height - self.dimens_:getDimens(195) - self.dimens_:getDimens(200)) / 2
    local CHARGE_SELECT_WIDTH = self.dimens_:getDimens(195) 
    local CHARGE_SELECT_HEIGHT = self.dimens_:getDimens(190)
    local chargecolor = nil
    if self.controller_.params_ ~= nil and self.controller_.params_.chargecolor ~= nil then
        chargecolor = self.controller_.params_.chargecolor
    else
        chargecolor = ccc3(255, 255, 255)
    end

    --self:setTitle(self.theme_:getImage("charge/charge_title_charge.png"))
    self:setThemeStyle(self.THEME_LANDSCAPE_SYTLE)
    self:setBackBtn(true)
    self:setTitle("充值中心")

    -- 联系我们  暂时不用
    --[[
    local btnContactUs = jj.ui.JJButton.new({
            images = {
                normal = self.theme_:getImage("charge/charge_contact_us_n.png"),
            },
        })
    btnContactUs:setAnchorPoint(ccp(1, 1))
    btnContactUs:setPosition(self.dimens_.width - self.dimens_:getDimens(10), self.dimens_.height - self.dimens_:getDimens(10))
    btnContactUs:setScale(self.dimens_.scale_)
    btnContactUs:setOnClickListener(function() self.controller_:onClickContactUs() end)
    self:addView(btnContactUs)
]]
    -- 提示内容
    local prompt = jj.ui.JJLabel.new({
        fontSize = self.dimens_:getDimens(20),
        color = ccc3(255, 255, 255),
        text = "金币: " .. UserInfo.gold_,
        background = {
            scale9 = true,
            image = self.theme_:getImage("common/common_view_bg.png"),
        },
        viewSize = CCSize(self.dimens_.width - self.dimens_:getDimens(40), self.dimens_:getDimens(24)),
        padding = self.dimens_:getDimens(8)
    })
    prompt:setId(ID_PROMPT)
    prompt:setAnchorPoint(ccp(0.5, 0.5))
    prompt:setPosition(ccp(self.dimens_.cx, self.dimens_.height - self.dimens_:getDimens(100)))
    -- self:addView(prompt)

    -- 充值方式
    local displayParam = pcm:getDisplayParam()
    JJLog.i(TAG, "#displayParam=", #displayParam)
    local startY = CHARGE_TITLE_HEIGHT
    for i=1, #displayParam do
        local payType = displayParam[i]

        local layout = jj.ui.JJViewGroup.new({
                viewSize = CCSize(CHARGE_SELECT_WIDTH, CHARGE_SELECT_HEIGHT),
            })
        local x = 0
        local y = 0
        if i == 1 or i == 4 then
            x = self.dimens_:getDimens(200)
            layout:setAnchorPoint(ccp(0, 0))
        elseif i == 2 or i == 5 then
            x = self.dimens_:getDimens(405) 
            layout:setAnchorPoint(ccp(0, 0))
        else
            x = self.dimens_:getDimens(610)
            layout:setAnchorPoint(ccp(0, 0))
        end

        if i == 1 or i == 2 or i == 3 then
            y = startY + self.dimens_:getDimens(200)
        elseif i == 4 or i == 5 or i == 6 then
            y = startY
        end
        layout:setPosition(ccp(x, y))
        --layout:setScale(self.dimens_.scale_)
        self:addView(layout)

        local bg = jj.ui.JJButton.new({
                images = {
                    normal = self.theme_:getImage("common/common_btn_bg_n.png"),
                    highlight = self.theme_:getImage("common/common_btn_bg_d.png"),
                    scale9 = true,
                    viewSize = CCSize(CHARGE_SELECT_WIDTH, CHARGE_SELECT_HEIGHT),
                },
                    viewSize = CCSize(CHARGE_SELECT_WIDTH, CHARGE_SELECT_HEIGHT),
            })
        bg:setOnClickListener(function() self.controller_:onSelectPayType(payType) end)
        --bg:setScale(self.dimens_.scale_)
        layout:addView(bg)

        if TYPE_PARAM[payType] ~= nil then
            local img = jj.ui.JJImage.new({
                    image = self.theme_:getImage(TYPE_PARAM[payType].img),
                    scale9 = true,
                    viewSize = CCSize(100, 100),
                })
            img:setAnchorPoint(ccp(0.5, 1))
            img:setPosition(ccp(CHARGE_SELECT_WIDTH/2, CHARGE_SELECT_HEIGHT - self.dimens_:getDimens(25)))
            img:setScale(self.dimens_.scale_)
            layout:addView(img)

            local label = jj.ui.JJLabel.new({
                    fontSize = self.dimens_:getDimens(22),
                    color = chargecolor,
                    text = TYPE_PARAM[payType].txt,
                })
            label:setAnchorPoint(ccp(0.5, 0))
            label:setPosition(ccp(CHARGE_SELECT_WIDTH/2, (CHARGE_SELECT_HEIGHT - self.dimens_:getDimens(10 + 100 + 50))))
            layout:addView(label)
        end
    end
end

--[[
    免注册登录注册引导
]]
local UIUtil = require("game.ui.UIUtil")
function ChargeSelectScene:showGuideToBindNoRegDialog(show)
    JJLog.i(TAG, "showGuideToBindNoRegDialog IN! and show : ", show)
     if show then
        local function onClick()
            JJLog.i(TAG, "showGuideToBindNoRegDialog, onClick, onClickRegister")
            self.controller_:onClickRegister()
        end

        local function closeDialog()
            self.bindNoRegDialog_ = nil
        end

        self.bindNoRegDialog_ = UIUtil.showGuideToBindNoRegDialog({
            btn1CB = nil,
            btn2CB = onClick,
            dismissCB = closeDialog,
            theme = self.theme_,
            dimens = self.dimens_,
            scene = self,
            prompt = "亲，建议您注册升级为JJ帐号，JJ帐号会自动保留您当前的所有财物和账户信息，方便又安全。",
        })

    else
        if self.bindNoRegDialog_ then
            UIUtil.dismissDialog(self.bindNoRegDialog_)
            self.bindNoRegDialog_ = nil
        end
    end
end

function ChargeSelectScene:onDestory()
    self:showGuideToBindNoRegDialog(false)
    ChargeSelectScene.super.onDestory(self)
end

function ChargeSelectScene:onBackPressed()
    if self.bindNoRegDialog_ then
        self:showGuideToBindNoRegDialog(false)
        return true
    else
        return false
    end
end

return ChargeSelectScene
