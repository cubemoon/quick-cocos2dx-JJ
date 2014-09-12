local RegisterSelectScene = class("RegisterSelectScene", import("game.ui.scene.JJGameSceneBase"))
local TAG = "RegisterSelectScene"

function RegisterSelectScene:onDestory()
    JJLog.i(TAG, "onDestory")
    RegisterSelectScene.super.onDestory(self)

    -- 清理句柄
    self.btnMobile_ = nil
    self.btnNormal_ = nil
    self.btnJJLogin_ = nil
end

function RegisterSelectScene:initView()
    RegisterSelectScene.super.initView(self)

    self:setThemeStyle(self.THEME_LANDSCAPE_SYTLE)
    self:setBackBtn(true)
    --self:setTitle(self.theme_:getImage("register/register_select_title.png"))
    self:setTitle("注册帐号")
    local dimens = self.dimens_

    local btnPositionX = dimens.cx + dimens:getDimens(50)
    -- 提示
    local prompt = jj.ui.JJLabel.new({
        fontSize = dimens:getDimens(20),
        color = ccc3(255, 255, 255),
        text = "将自动保留所有财物和账户信息。",
        viewSize = CCSize(768, 0),
        align = ui.TEXT_ALIGN_CENTER
    })
    prompt:setAnchorPoint(ccp(0.5, 1))
    prompt:setPosition(btnPositionX, dimens.height - dimens:getDimens(70))
    --prompt:setScale(dimens.scale_)
    self:addView(prompt)
    if (LoginController.type_ ~= LOGIN_TYPE_NOREG) then
        prompt:setVisible(false)
    end

    local btnWidth = dimens:getDimens(435)
    local btnHeight = dimens:getDimens(116)
    local textPositionX = dimens:getDimens(240)

    local DynamicDisplayManager = require("game.data.config.DynamicDisplayManager")
    local mobileRegEnable = DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_MOBILE_REGISTER)
    if mobileRegEnable then
        -- 手机
        local mobileLayer = jj.ui.JJViewGroup.new({
            viewSize = CCSize(btnWidth, btnHeight),
        })
        --mobileLayer:setScale(dimens.scale_)
        mobileLayer:setAnchorPoint(ccp(0.5, 0.5))
        mobileLayer:setPosition(btnPositionX, dimens.cy + dimens:getDimens(70))
        self:addView(mobileLayer)

        self.btnMobile_ = jj.ui.JJButton.new({
            images = {
                normal = self.theme_:getImage("register/register_select_mobile_n.png"), 
                highlight = self.theme_:getImage("register/register_select_mobile_d.png"), 
            },
        })
        self.btnMobile_:setAnchorPoint(ccp(0, 0))
        self.btnMobile_:setPosition(0, 0)
        self.btnMobile_:setOnClickListener(handler(self, self.onClick))
        self.btnMobile_:setScale(dimens.scale_)
        mobileLayer:addView(self.btnMobile_)

        local mobiletext = jj.ui.JJLabel.new({
            text = "手机号注册",
            color = ccc3(255, 255, 255),
            fontSize = dimens:getDimens(28),
        })
        mobiletext:setAnchorPoint(ccp(0.5, 0.5))
        mobiletext:setPosition(textPositionX, btnHeight / 2)
        mobileLayer:addView(mobiletext)
        if DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_MOBILE_REGISTER_GOLD) then

            local txt = jj.ui.JJLabel.new({
                text = "注册即送1000金币",
                color = ccc3(255, 217, 0),
                fontSize = dimens:getDimens(20),
            })
            txt:setAnchorPoint(ccp(0.5, 0.5))
            txt:setPosition(textPositionX, btnHeight / 2 - mobiletext:getBoundingBoxHeight())        
            mobileLayer:addView(txt)
        end
    end

    --[[    txt = jj.ui.JJLabel.new({
            text = "10秒快速注册，好记又安全",
            color = ccc3(144, 117, 12),
            fontSize = 18,
        })
        txt:setAnchorPoint(ccp(0.5, 1))
        txt:setPosition(btnWidth / 2, btnHeight / 2)
        mobileLayer:addView(txt)]]

    local y = dimens.cy - dimens:getDimens(80)
    if not mobileRegEnable then
        y = dimens.cy
    end
        
    -- 普通注册
    local normalLayer = jj.ui.JJViewGroup.new({
        viewSize = CCSize(btnWidth, btnHeight),
    })
    --normalLayer:setScale(dimens.scale_)
    normalLayer:setAnchorPoint(ccp(0.5, 0.5))
    normalLayer:setPosition(btnPositionX, y)
    self:addView(normalLayer)

    self.btnNormal_ = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("register/register_select_normal_n.png"), 
            highlight = self.theme_:getImage("register/register_select_normal_d.png"), 
        },
    })
    self.btnNormal_:setAnchorPoint(ccp(0, 0))
    self.btnNormal_:setPosition(0, 0)
    self.btnNormal_:setScale(dimens.scale_)
    self.btnNormal_:setOnClickListener(handler(self, self.onClick))
    normalLayer:addView(self.btnNormal_)

    local txt = jj.ui.JJLabel.new({
        text = "个性帐号注册",
        color = ccc3(255, 255, 255),
        fontSize = dimens:getDimens(28),
    })
    txt:setAnchorPoint(ccp(0.5, 0.5))
    txt:setPosition(textPositionX, btnHeight / 2)
    normalLayer:addView(txt)
    
    -- 使用已有JJ帐号登录
    self.btnJJLogin_ = jj.ui.JJButton.new({
        text = "使用已有JJ帐号登录",
        fontSize = dimens:getDimens(24),
        viewSize = CCSize(dimens:getDimens(260), dimens:getDimens(36)),
        color = ccc3(255, 217, 0),
        })
    self.btnJJLogin_:setAnchorPoint(ccp(1, 0.5))
    self.btnJJLogin_:setPosition(dimens.width - dimens:getDimens(10), dimens:getDimens(30))
   -- self.btnJJLogin_:setScale(dimens.scale_)
    self.btnJJLogin_:setOnClickListener(handler(self, self.onClick))    
    self:addView(self.btnJJLogin_)

    if (RUNNING_MODE == RUNNING_MODE_GAME) then --增加处理，只有在游戏模式下才显示
        self.btnJJLogin_:setVisible(true)
    else
        self.btnJJLogin_:setVisible(false)
    end
end

--[[
    按键处理
]]
function RegisterSelectScene:onClick(target)
    if target == self.btnMobile_ then
        self.controller_:onClickMobile()
    elseif target == self.btnNormal_ then
        self.controller_:onClickNormal()
    elseif target == self.btnJJLogin_ then
        self.controller_:onJJLogin()
    end
end

return RegisterSelectScene
