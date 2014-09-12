local SettingsScene = class("SettingsScene", import("game.ui.scene.JJGameSceneBase"))
local TAG = "SettingsScene"

local DynamicDisplayManager = require("game.data.config.DynamicDisplayManager")
function SettingsScene:onDestory()
    SettingsScene.super.onDestory(self)
    self.scrollView_ = nil

    self.volumeBg_ = nil
    self.lblVolume_ = nil
    self.volumeSeekbar = nil

    self.effectBg_ = nil
    self.lblBgSound_ = nil
    self.bgSoundChkbox_ = nil
    self.effectSep1_ = nil

    self.lblSoundEffect_ = nil
    self.soundEffectChkbox_ = nil
    self.effectSep2_ = nil

    self.lblVoice_ = nil
    self.voiceChkbox_ = nil

    self.recomBg_ = nil
    self.lblRecom_ = nil
    self.btnRecomChkbox_ = nil

    self.helpBg_ = nil
    self.btnHelp1_ = nil
    self.btnHelp2_ = nil
    self.helpSep1_ = nil

    self.btnMore1_ = nil
    self.btnMore2_ = nil
    self.helpSep2_ = nil

    self.btnAbout1_ = nil
    self.btnAbout2_ = nil

    self.btnShare1_ = nil
    self.btnShare2_ = nil
    self.shareSep2_ = nil

    self.btnFeedback1_ = nil
    self.btnFeedback2_ = nil
    self.feedbackSep2_ = nil
end

function SettingsScene:initView()
    self.FEEDBACK, self.SHARE, self.HELP, self.MORE_GAME, self.ABOUT = 1, 2, 3, 4, 5
    self.infoLength = 3

    SettingsScene.super.initView(self)

    self.top = (self.dimens_.height - self.dimens_:getDimens(137) * 2 - self.dimens_:getDimens(130)) / 2
    --JJLog.i("self.top = ",self.top,self.dimens_.height,self.dimens_:getDimens(137))
    --self:setTitle(self.theme_:getImage("setting/setting_title.png"))
    self:setThemeStyle(self.THEME_LANDSCAPE_SYTLE)
    self:setBackBtn(true)
    self:setTitle("设置")
    self.settingsInfoImg = { "setting/setting_feedback.png", "setting/setting_help.png", "setting/setting_about.png" }
    self.settingsInfoText = { "意见反馈", "游戏帮助", "游戏关于" }
    self.settingsInfoOnClick = {
        self.controller_.onClickFeedback,
        self.controller_.onClickHelp,
        self.controller_.onClickAbout
    }

    --[[
        背景音乐
        游戏音效
        游戏人声
        推荐比赛    
    ]]
    local lineHeight = self.dimens_:getDimens(91) --  单行高度
    local width = self.dimens_:getDimens(275)
    local height = self.dimens_:getDimens(400)

    local marginLeftBG = self.dimens_:getDimens(520) -- 左边控件离左边界    
    local marginLeft = self.dimens_:getDimens(548) -- 左边控件离左边界
    local params = {
        singleLine = true,
        fontSize = self.dimens_:getDimens(22),
        align = ui.TEXT_ALIGN_LEFT,
        color = ccc3(255, 255, 255)
    }
    local chkParams = {
        images = {
            on = self.theme_:getImage("setting/setting_checked.png"),
            off = self.theme_:getImage("setting/setting_unchecked.png"),
        },
        viewSize = CCSize(132, 56),
    }

    local bg = jj.ui.JJImage.new({
        image = self.theme_:getImage("common/common_btn_bg_n.png"),
        scale9 = true,
        viewSize = CCSize(width, height),
    })
    bg:setAnchorPoint(ccp(0, 0))
    bg:setPosition(marginLeftBG, self.top)
    self:addView(bg)

    -- 背景音乐
    --local bgTop = height
    params.text = "背景音乐"
    local text = jj.ui.JJLabel.new(params)
    local y = self.top + height - self.dimens_:getDimens((400 - 91 * 3 - 25) / 2)
    local y_check = self.dimens_:getDimens(21)

    params.text = "背景音乐"
    self.lblBgSound_ = jj.ui.JJLabel.new(params)
    self.lblBgSound_:setAnchorPoint(ccp(0, 1))
    self.lblBgSound_:setPosition(marginLeft, y)
    self:addView(self.lblBgSound_)

    local marginRight = marginLeft + self.lblBgSound_:getBoundingBoxWidth() + 20 -- 右边控件离右边界
    chkParams.state = (self.controller_:getSoundBg() and "on") or "off"
    self.bgSoundChkbox_ = jj.ui.JJCheckBox.new(chkParams)
    self.bgSoundChkbox_:setAnchorPoint(ccp(0, 1))
    self.bgSoundChkbox_:setPosition(marginRight, y + y_check)
    self.bgSoundChkbox_:setScale(self.dimens_.scale_)
    self.bgSoundChkbox_:setOnCheckedChangeListener(handler(self, self.onCheckedChangeListener))
    self:addView(self.bgSoundChkbox_)

    -- 游戏音效
    y = y - lineHeight
    params.text = "游戏音效"
    self.lblSoundEffect_ = jj.ui.JJLabel.new(params)
    self.lblSoundEffect_:setAnchorPoint(ccp(0, 1))
    self.lblSoundEffect_:setPosition(marginLeft, y)
    self:addView(self.lblSoundEffect_)

    chkParams.state = (self.controller_:getSoundEffect() and "on") or "off"
    self.soundEffectChkbox_ = jj.ui.JJCheckBox.new(chkParams)
    self.soundEffectChkbox_:setAnchorPoint(ccp(0, 1))
    self.soundEffectChkbox_:setPosition(marginRight, y + y_check)
    self.soundEffectChkbox_:setScale(self.dimens_.scale_)
    self.soundEffectChkbox_:setOnCheckedChangeListener(handler(self, self.onCheckedChangeListener))
    self:addView(self.soundEffectChkbox_)

    local voiceEnable = true
    if self.controller_.params_.voiceEnable == false then
        voiceEnable = false
    end

    if voiceEnable then
        -- 游戏人声
        y = y - lineHeight
        params.text = "游戏人声"
        self.lblVoice_ = jj.ui.JJLabel.new(params)
        self.lblVoice_:setAnchorPoint(ccp(0, 1))
        self.lblVoice_:setPosition(marginLeft, y)
        self:addView(self.lblVoice_)

        chkParams.state = (self.controller_:getSoundVoice() and "on") or "off"
        self.voiceChkbox_ = jj.ui.JJCheckBox.new(chkParams)
        self.voiceChkbox_:setAnchorPoint(ccp(0, 1))
        self.voiceChkbox_:setPosition(marginRight, y + y_check)
        self.voiceChkbox_:setScale(self.dimens_.scale_)
        self.voiceChkbox_:setOnCheckedChangeListener(handler(self, self.onCheckedChangeListener))
        self:addView(self.voiceChkbox_)
    end
    --推荐比赛
    --bgTop = bgTop - lineHeight * 3 - marginBetween
    -- y = bgTop - lineHeight

    y = y - lineHeight
    params.text = "推荐比赛"
    self.lblRecom_ = jj.ui.JJLabel.new(params)
    self.lblRecom_:setAnchorPoint(ccp(0, 1))
    self.lblRecom_:setPosition(marginLeft, y)
    self:addView(self.lblRecom_)

    chkParams.state = (self.controller_:getRecomMatchPrompt() and "on") or "off"
    self.btnRecomChkbox_ = jj.ui.JJCheckBox.new(chkParams)
    self.btnRecomChkbox_:setAnchorPoint(ccp(0, 1))
    self.btnRecomChkbox_:setPosition(marginRight, y + y_check)
    self.btnRecomChkbox_:setScale(self.dimens_.scale_)
    self.btnRecomChkbox_:setOnCheckedChangeListener(handler(self, self.onCheckedChangeListener))
    self:addView(self.btnRecomChkbox_)

    if RUNNING_MODE == RUNNING_MODE_GAME and not Util:isQihu360() then
        self.infoLength = self.infoLength + 1
        table.insert(self.settingsInfoImg, 1, "setting/setting_switch.png")
        table.insert(self.settingsInfoText, 1, "切换帐号")
        table.insert(self.settingsInfoOnClick, 1, self.controller_.onClickSwitchAccount)        
    end

    -- 是否有分享
    local JJGameUtil = import("game.util.JJGameUtil")
    local allowShare = DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_SHARE) --JJGameUtil:allowShareInSetting(PROMOTER_ID)
    if  allowShare then
        self.infoLength = self.infoLength + 1
        table.insert(self.settingsInfoImg, 2, "setting/setting_share.png")
        table.insert(self.settingsInfoText, 2, "推荐好友")
        table.insert(self.settingsInfoOnClick, 2, self.controller_.onClickShare)
    end

    local dis = DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_MORE_GAME) -- and UserInfo:isLogin()
    -- 如果是已经登录，并且更多游戏显示控制为true，才显示更多游戏选项  宋基星去掉未登录  
    if dis then
        table.insert(self.settingsInfoImg, self.infoLength, "setting/setting_more.png")
        table.insert(self.settingsInfoText, self.infoLength, "更多游戏")
        table.insert(self.settingsInfoOnClick, self.infoLength, self.controller_.onClickMoreGame)
        self.infoLength = self.infoLength + 1
    end

        JJLog.i("self.infoLength 3 = ",self.infoLength)
    -- self:refreshVolume()
    self:refreshSoundState()
    self:refreshRecomState()
    self:settingsInfo()
end

function SettingsScene:settingsInfo()
    -- body

    local CHARGE_SELECT_WIDTH = self.dimens_:getDimens(149)
    local CHARGE_SELECT_HEIGHT = self.dimens_:getDimens(127)
    for i = 1, self.infoLength do

        local layout = jj.ui.JJViewGroup.new({
            viewSize = CCSize(CHARGE_SELECT_WIDTH, CHARGE_SELECT_HEIGHT),
        })
        local x = 0
        local y = 0
        local startY = self.top
        if i == 1 or i == 3 or i == 5 then
            x = self.dimens_:getDimens(200)
            layout:setAnchorPoint(ccp(0, 0))
        else
            x = self.dimens_:getDimens(358)
            layout:setAnchorPoint(ccp(0, 0))
        end

        if i == 1 or i == 2 then
            y = startY + self.dimens_:getDimens(137 + 137)
        elseif i == 3 or i == 4 then
            y = startY + self.dimens_:getDimens(137)
        else
            y = startY
        end

        layout:setPosition(ccp(x, y))
        --layout:setScale(self.dimens_.scale_)
        self:addView(layout)
        local bg = {}
        
        if RUNNING_MODE == RUNNING_MODE_GAME then
            if i == 1 then
                bg = jj.ui.JJButton.new({
                    images = {
                        normal = self.theme_:getImage("common/common_btn_bg_d.png"),
                        highlight = self.theme_:getImage("common/common_btn_bg_n.png"),
                        viewSize = CCSize(CHARGE_SELECT_WIDTH, CHARGE_SELECT_HEIGHT),
                        scale9 = true,
                    },
                    viewSize = CCSize(CHARGE_SELECT_WIDTH, CHARGE_SELECT_HEIGHT),
                })
            else
                bg = jj.ui.JJButton.new({
                    images = {
                        normal = self.theme_:getImage("common/common_btn_bg_n.png"),
                        highlight = self.theme_:getImage("common/common_btn_bg_d.png"),
                        viewSize = CCSize(CHARGE_SELECT_WIDTH, CHARGE_SELECT_HEIGHT),
                        scale9 = true,
                    },
                    viewSize = CCSize(CHARGE_SELECT_WIDTH, CHARGE_SELECT_HEIGHT),                
                })
            end
        else
            bg = jj.ui.JJButton.new({
                    images = {
                        normal = self.theme_:getImage("common/common_btn_bg_n.png"),
                        highlight = self.theme_:getImage("common/common_btn_bg_d.png"),
                        viewSize = CCSize(CHARGE_SELECT_WIDTH, CHARGE_SELECT_HEIGHT),
                        scale9 = true,
                    },
                    viewSize = CCSize(CHARGE_SELECT_WIDTH, CHARGE_SELECT_HEIGHT),                
                })
        end


        bg:setOnClickListener(handler(self.controller_,self.settingsInfoOnClick[i]))

        layout:addView(bg)

        JJLog.i("self.infoLength = ",i,self.infoLength)
        local img = jj.ui.JJImage.new({
            image = self.theme_:getImage(self.settingsInfoImg[i]),
            viewSize = CCSize(self.dimens_:getDimens(100), self.dimens_:getDimens(100)),
        })
        img:setAnchorPoint(ccp(0.5, 1))
        img:setPosition(ccp(CHARGE_SELECT_WIDTH / 2, CHARGE_SELECT_HEIGHT))
        img:setScale(self.dimens_.scale_)
        layout:addView(img)

        local label = jj.ui.JJLabel.new({
            fontSize = self.dimens_:getDimens(22),
            color = chargecolor,
            text = self.settingsInfoText[i],
        })
        label:setAnchorPoint(ccp(0.5, 0))
        label:setPosition(ccp(CHARGE_SELECT_WIDTH / 2, (CHARGE_SELECT_HEIGHT - self.dimens_:getDimens(100 + 7))))
        layout:addView(label)
    end
end

-- 
function SettingsScene:onSelectId(id)
    return self.settingsInfoOnClick[id]
end

function SettingsScene:onClick(target)
    local id = 0
    if target ~= nil then
        id = target:getId()
    end

    if id == self.ABOUT then -- 关于
        self.controller_:onClickAbout()
    elseif id == self.MORE_GAME then --更多游戏
        self.controller_:onClickMoreGame(JJGameDefine.GAME_ID_LORD_UNION)
    elseif id == self.HELP then --帮助
        self.controller_:onClickHelp()
    elseif id == self.SHARE then --推荐给好友
        self.controller_:onClickShare()
    elseif id == self.FEEDBACK then --意见反馈
        self.controller_:onClickFeedback()
    end
end

function SettingsScene:onCheckedChangeListener(target)
    if target ~= nil then
        local check = target:isSelected()
        if target == self.bgSoundChkbox_ then -- 背景音乐
            self.controller_:setSoundBg(check)
            self:refreshSoundState()
        elseif target == self.soundEffectChkbox_ then -- 游戏音效
            self.controller_:setSoundEffect(check)
            self:refreshSoundState()
        elseif target == self.voiceChkbox_ then -- 游戏人声
            self.controller_:setSoundVoice(check)
            self:refreshSoundState()
        elseif target == self.btnRecomChkbox_ then -- 推荐比赛
            self.controller_:setRecomMatchPrompt(check)
            self:refreshRecomState()
        end
    end
end

function SettingsScene:onVolumeChangeListener(target)
    if target then
        self.controller_:setSoundVolume(target:getValue() / 100)
    end
end

-- function SettingsScene:refreshVolume()
--     if self.volumeSeekbar ~= nil then
--         self.volumeSeekbar:setValue(self.controller_:getSoundVolume() * 100)
--     end
-- end

function SettingsScene:refreshSoundState()

    if self.bgSoundChkbox_ ~= nil then
        self.bgSoundChkbox_:setChecked(self.controller_.getSoundBg())
    end

    if self.soundEffectChkbox_ ~= nil then
        self.soundEffectChkbox_:setChecked(self.controller_.getSoundEffect())
    end

    if self.voiceChkbox_ ~= nil then
        self.voiceChkbox_:setChecked(self.controller_.getSoundVoice())
    end
end

function SettingsScene:refreshRecomState()
    if self.btnRecomChkbox_ ~= nil then
        self.btnRecomChkbox_:setChecked(self.controller_.getRecomMatchPrompt())
    end
end

return SettingsScene
