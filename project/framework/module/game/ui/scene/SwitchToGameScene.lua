local SwitchToGameScene = class("SwitchToGameScene", require("game.ui.scene.JJGameSceneBase"))
local TAG = "SwitchToGameScene"

--SwitchToGameScene.btnCancel_ = nil
SwitchToGameScene.prompt_ = nil
SwitchToGameScene.progressBg_ = nil
SwitchToGameScene.progressBar_ = nil

local PROGRESS_BAR_WIDTH = 600
local PROGRESS_BAR_HEIGHT = 32
local PROGRESS_BAR_MIN_WIDTH = 40

function SwitchToGameScene:ctor(controller)
    SwitchToGameScene.super.ctor(self,controller)
end

function SwitchToGameScene:onDestory()
    SwitchToGameScene.super.onDestory(self)
    -- self.btnCancel_ = nil
    self.prompt_ = nil
    self.progressBg_ = nil
    self.progressBar_ = nil
end

function SwitchToGameScene:initView()
    SwitchToGameScene.super.initView(self)

    -- 动画
    local array = CCArray:create()
    for i = 1, #self.controller_.params_.anims do
        array:addObject(CCSpriteFrame:create(self.controller_.params_.anims[i], CCRect(0, 0, 180, 223)))
    end
    local animation = CCAnimation:createWithSpriteFrames(array, 0.08)

    local lord = jj.ui.JJImage:new()
    lord:setPosition(self.dimens_.cx, self.dimens_.cy + self.dimens_:getDimens(80))
    lord:setScale(self.dimens_.scale_)
    self:addView(lord)
    lord:playAnimationForever(animation)

    -- -- 提示语背景图
    -- self.promptBg_ = jj.ui.JJImage.new({
    --     scale9 = true,
    --     image = self.theme_:getImage("switchtogame/prompt_bg.png"),
    --     viewSize = CCSize(self.dimens_.width, 60),
    -- })
    -- self.promptBg_:setAnchorPoint(ccp(0.5, 1))
    -- self.promptBg_:setPosition(self.dimens_.cx, self.dimens_.cy - self.dimens_:getDimens(80))
    -- self.promptBg_:setScale(self.dimens_.scale_)
    -- self:addView(self.promptBg_)

    -- 提示语
    self.prompt_ = jj.ui.JJLabel.new({
        singleLine = true,
        fontSize = self.dimens_:getDimens(28),
        color = ccc3(255, 255, 255),
        text = "玩命加载中，请稍候...",
        viewSize = CCSize(self.dimens_.width, self.dimens_:getDimens(60)),
        align = ui.TEXT_ALIGN_CENTER,
    })
    self.prompt_:setAnchorPoint(ccp(0.5, 0.5))
    self.prompt_:setPosition(self.dimens_.cx, self.dimens_.cy - self.dimens_:getDimens(110))
    --self.prompt_:setScale(self.dimens_.scale_)
    self:addView(self.prompt_)

    -- -- 按钮
    -- self.btnCancel_ = jj.ui.JJButton.new({
    --     images = {
    --         normal = self.theme_:getImage("common/common_cancel_small_btn_n.png"),
    --         highlight = self.theme_:getImage("common/common_cancel_small_btn_n.png"),
    --     },
    --     fontSize = 28,
    --     color = ccc3(255, 255, 255),
    --     text = "取消",
    --     viewSize = CCSize(125, 68),
    -- })
    -- self.btnCancel_:setAnchorPoint(ccp(0.5, 0.5))
    -- self.btnCancel_:setPosition(self.dimens_.cx, self.dimens_:getDimens(50))
    -- self.btnCancel_:setScale(self.dimens_.scale_)
    -- self.btnCancel_:setOnClickListener(handler(self.controller_, self.controller_.onBackPressed))
    -- self:addView(self.btnCancel_)

    -- 进度条
    self.progressBg_ = jj.ui.JJImage.new({
        viewSize = CCSize(PROGRESS_BAR_WIDTH, PROGRESS_BAR_HEIGHT),
        image = self.theme_:getImage("switchtogame/progress_bar_bg.png"),
        scale9 = true,
    })
    self.progressBg_:setAnchorPoint(ccp(0.5, 0.5))
    self.progressBg_:setPosition(self.dimens_.cx, self.dimens_.cy - self.dimens_:getDimens(110))
    self.progressBg_:setScale(self.dimens_.scale_)
    self:addView(self.progressBg_)

    self.progressBar_ = jj.ui.JJImage.new({
        viewSize = CCSize(PROGRESS_BAR_WIDTH, PROGRESS_BAR_HEIGHT),
        image = self.theme_:getImage("switchtogame/progress_bar.png"),
        scale9 = true,
    })
    self.progressBar_:setAnchorPoint(ccp(0, 0.5))
    self.progressBar_:setPosition(self.dimens_.cx - self.dimens_:getDimens(PROGRESS_BAR_WIDTH/2), self.dimens_.cy - self.dimens_:getDimens(110))
    self.progressBar_:setScale(self.dimens_.scale_)
    self:addView(self.progressBar_)

    self:showProgress(false)
end

function SwitchToGameScene:showProgress(flag)
    JJLog.i(TAG, "showProgress, flag=", flag)
    if self.progressBg_ ~= nil and self.progressBar_ ~= nil then
        self.progressBg_:setVisible(flag)
        self.progressBar_:setVisible(flag)
    end

    if flag then
        if self.prompt_ ~= nil then
            self.prompt_:setPosition(self.dimens_.cx, self.dimens_.cy - self.dimens_:getDimens(60))
            self.prompt_:setFontSize(self.dimens_:getDimens(24))
            self.prompt_:setText("加载更新中，请稍候...")
            self:updateProgress(0)
        end
    else
        if self.prompt_ ~= nil then
            self.prompt_:setPosition(self.dimens_.cx, self.dimens_.cy - self.dimens_:getDimens(110))
            self.prompt_:setFontSize(self.dimens_:getDimens(28))
            self.prompt_:setText("玩命加载中，请稍候...")
        end
    end
end

function SwitchToGameScene:updateProgress(percent)
    JJLog.i(TAG, "updateProgress, percent=", percent)
    if self.progressBar_ ~= nil then
        local width = (percent * (PROGRESS_BAR_WIDTH - PROGRESS_BAR_MIN_WIDTH)) / 100 + PROGRESS_BAR_MIN_WIDTH
        JJLog.i(TAG, "updateProgress, width=", width)
        self.progressBar_:setViewSize(width, PROGRESS_BAR_HEIGHT)
    end
end

return SwitchToGameScene
