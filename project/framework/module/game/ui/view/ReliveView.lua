-- 复活
--[[ 如果重载了该view必须实现以下方法
无
]]
local ReliveView = class("ReliveView", require("game.ui.view.JJMatchView"))
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

function ReliveView:ctor(viewController)
    ReliveView.super.ctor(self, viewController)
    
    self:initView()   
    self:initData() 
end

function ReliveView:initView()
    local bg = jj.ui.JJImage.new({
        image = self.theme_:getImage("common/bg_normal.jpg")
    })
    bg:setPosition(self.dimens_.cx, self.dimens_.cy)
    bg:setScaleX(self.dimens_.wScale_)
    bg:setScaleY(self.dimens_.hScale_)
    self:addView(bg)

    bg = jj.ui.JJImage.new({
        image = self.theme_:getImage("game/anim/lord_revive_anim.png")
    })
    bg:setScale(self.dimens_.scale_)
    bg:setAnchorPoint(ccp(0.5, 1))
    bg:setPosition(self.dimens_.cx, self.dimens_.top - self.dimens_:getDimens(10))  
    self:addView(bg)

    local ftSize, cc = self.dimens_:getDimens(20), ccc3(255, 217, 0)
    self.prompt = jj.ui.JJLabel.new({
        text = "等待复活",
        font = "Arial",
        fontSize = ftSize,
        align = ui.TEXT_ALIGN_CENTER,
        color = cc,
        })
    self.prompt:setAnchorPoint(CCPoint(0.5, 0.5))
    self.prompt:setPosition(self.dimens_.cx, self.dimens_.cy + self.dimens_:getDimens(10))
    self:addView(self.prompt)

    bg = jj.ui.JJImage.new({
        image = self.theme_:getImage("common/common_view_bg.png"),
        scale9 = true,
        viewSize = CCSize(self.dimens_:getDimens(540), self.dimens_:getDimens(150))})
    bg:setAnchorPoint(ccp(0.5, 1))
    bg:setPosition(self.dimens_.cx, self.dimens_.cy - self.dimens_:getDimens(10))
    self:addView(bg)

    local x, y = self.dimens_.cx - self.dimens_:getDimens(210), self.dimens_.cy - self.dimens_:getDimens(30)
    local lbl = jj.ui.JJLabel.new({
                    text = "当前金币：",
                    font = "Arial",
                    fontSize = ftSize,
                    align = ui.TEXT_ALIGN_LEFT,
                    color = ccc3(255, 255, 255),
                    })
    lbl:setAnchorPoint(CCPoint(0, 1))
    lbl:setPosition(x, y)
    self:addView(lbl)

    x = x + self.dimens_:getDimens(100)
    self.gold = jj.ui.JJLabel.new({
                    text = "100",
                    font = "Arial",
                    fontSize = ftSize,
                    align = ui.TEXT_ALIGN_LEFT,
                    color = cc,
                    })
    self.gold:setAnchorPoint(CCPoint(0, 1))
    self.gold:setPosition(x, y)
    self:addView(self.gold)

    x = x + self.dimens_:getDimens(140)
    lbl = jj.ui.JJLabel.new({
                    text = "复活消耗：",
                    font = "Arial",
                    fontSize = ftSize,
                    align = ui.TEXT_ALIGN_LEFT,
                    color = ccc3(255, 255, 255),
                    })
    lbl:setAnchorPoint(CCPoint(0, 1))
    lbl:setPosition(x, y)
    self:addView(lbl)

    x = x + self.dimens_:getDimens(100)
    self.costDesc = jj.ui.JJLabel.new({
                    text = "一张积分卡",
                    font = "Arial",
                    fontSize = ftSize,
                    align = ui.TEXT_ALIGN_LEFT,
                    color = cc,
                    })
    self.costDesc:setAnchorPoint(CCPoint(0, 1))
    self.costDesc:setPosition(x, y)
    self:addView(self.costDesc)

    y = y - self.dimens_:getDimens(30)
    --[[bg = jj.ui.JJImage.new({
            image = self.theme_:getImage("common/common_view_list_div_h.png"),
            scale9 = true,
            viewSize = CCSize(self.dimens_:getDimens(540), self.dimens_:getDimens(2))})
    bg:setAnchorPoint(ccp(0.5, 1))
    bg:setPosition(self.dimens_.cx, y)
    self:addView(bg)]]

    x, y = self.dimens_.cx - self.dimens_:getDimens(210), y - self.dimens_:getDimens(10)
    lbl = jj.ui.JJLabel.new({
                    text = "当前人数：",
                    font = "Arial",
                    fontSize = ftSize,
                    align = ui.TEXT_ALIGN_LEFT,
                    color = ccc3(255, 255, 255),
                    })
    lbl:setAnchorPoint(CCPoint(0, 1))
    lbl:setPosition(x, y)
    self:addView(lbl)

    x = x + self.dimens_:getDimens(100)
    self.playerCount = jj.ui.JJLabel.new({
                    text = "20",
                    font = "Arial",
                    fontSize = ftSize,
                    align = ui.TEXT_ALIGN_LEFT,
                    color = cc,
                    })
    self.playerCount:setAnchorPoint(CCPoint(0, 1))
    self.playerCount:setPosition(x, y)
    self:addView(self.playerCount)

    x = x + self.dimens_:getDimens(140)
    lbl = jj.ui.JJLabel.new({
                    text = "复活积分：",
                    font = "Arial",
                    fontSize = ftSize,
                    align = ui.TEXT_ALIGN_LEFT,
                    color = ccc3(255, 255, 255),
                    })
    lbl:setAnchorPoint(CCPoint(0, 1))
    lbl:setPosition(x, y)
    self:addView(lbl)

    x = x + self.dimens_:getDimens(100)
    self.costScore = jj.ui.JJLabel.new({
                    text = "9999",
                    font = "Arial",
                    fontSize = ftSize,
                    align = ui.TEXT_ALIGN_LEFT,
                    color = cc,
                    })
    self.costScore:setAnchorPoint(CCPoint(0, 1))
    self.costScore:setPosition(x, y)
    self:addView(self.costScore)

    y = y - self.dimens_:getDimens(30)
    bg = jj.ui.JJImage.new({
            image = self.theme_:getImage("common/common_view_list_div_h.png"),
            scale9 = true,
            viewSize = CCSize(self.dimens_:getDimens(540), self.dimens_:getDimens(2))})
    bg:setAnchorPoint(ccp(0.5, 1))
    bg:setPosition(self.dimens_.cx, y)
    self:addView(bg)

    y = y - self.dimens_:getDimens(15)
    self.leftTime = jj.ui.JJLabel.new({
                    text = "剩余时间",
                    font = "Arial",
                    fontSize = ftSize,
                    align = ui.TEXT_ALIGN_LEFT,
                    color = ccc3(255, 255, 255),
                    })
    self.leftTime:setAnchorPoint(CCPoint(0.5, 1))
    self.leftTime:setPosition(self.dimens_.cx, y)
    self:addView(self.leftTime)


    self.noReviveBtn_ = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("common/common_alert_dialog_btn_1_n.png"),
            highlight = self.theme_:getImage("common/common_alert_dialog_btn_1_d.png"),
            disable = self.theme_:getImage("common/common_alert_dialog_btn_1_d.png")
        },
        text = "不复活", 
        font = "Arial",
        color = ccc3(255, 255, 255),
        fontSize = self.dimens_:getDimens(26),
         viewSize = CCSize(self.dimens_:getDimens(198), self.dimens_:getDimens(76)), 
    })
    self.noReviveBtn_:setAnchorPoint(ccp(1, 1))
    self.noReviveBtn_:setPosition(self.dimens_.cx - self.dimens_:getDimens(30), self.dimens_:getDimens(80))
    --self.noReviveBtn_:setScale(self.dimens_.scale_)
    self.noReviveBtn_:setOnClickListener(handler(self, self.onClickBtn))
    self:addView(self.noReviveBtn_)

    self.reviveBtn_ = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("common/common_alert_dialog_btn_2_n.png"),
            highlight = self.theme_:getImage("common/common_alert_dialog_btn_2_d.png"),
            disable = self.theme_:getImage("common/common_alert_dialog_btn_2_d.png")
        },
        text = "复活", 
        font = "Arial",
        color = ccc3(255, 255, 255),
        fontSize = self.dimens_:getDimens(26),
         viewSize = CCSize(self.dimens_:getDimens(198), self.dimens_:getDimens(76)), 
    })
    self.reviveBtn_:setAnchorPoint(ccp(0, 1))
    self.reviveBtn_:setPosition(self.dimens_.cx + self.dimens_:getDimens(30), self.dimens_:getDimens(80))
    --self.reviveBtn_:setScale(self.dimens_.scale_)
    self.reviveBtn_:setOnClickListener(handler(self, self.onClickBtn))
    self:addView(self.reviveBtn_)
end

function ReliveView:initData()
    local matchData = self.viewController_:getMatchData()
    local rd = matchData and matchData.reliveData_
    
    --self.viewController_.reviveStartTick = JJTimeUtil:getCurrentSecond()
    if rd then

        self.gold:setText(UserInfo.gold_)
        self.relivable = rd.relivable
        if rd.relivable then
            --self.reviveBtn_:setEnable(true)
            self.prompt:setText(string.format("您被淘汰出局了，可以消耗【%s】复活，复活后您将带入【%d】积分，剩余%d人。", 
                                            rd.cost, rd.score, rd.liveplayercount))
        else
            --self.reviveBtn_:setEnable(false)
            self.reason = string.format("复活需要【%s】，您没有满足条件不能复活！", rd.cost)
            self.prompt:setText(self.reason)
        end

        self.costDesc:setText(rd.cost)
        self.playerCount:setText(rd.liveplayercount)
        self.costScore:setText(rd.score)

        self.restSec = rd.timeout

        self:checkLeftTime()
    end
end

function ReliveView:onEnter()
    self:cancelCheck()
    self.checkTime = scheduler.scheduleGlobal(function() self:checkLeftTime() end, 1)
end

function ReliveView:onExit()
    self:cancelCheck()
    ReliveView.super.onExit(self)
end

function ReliveView:cancelCheck()
    if self.checkTime then
        scheduler.unscheduleGlobal(self.checkTime)
        self.checkTime = nil
    end    
end

function ReliveView:checkLeftTime()
    local dif = JJTimeUtil:getCurrentSecond() - (self.viewController_.reviveStartTick or 0)
    
    if self.restSec > dif then
        self.leftTime:setText(string.format("剩余时间：%d秒", self.restSec - dif))
    else
        self.leftTime:setText("剩余时间：0")
        self:cancelCheck()
        self.viewController_:toRelive(false)
    end

end

function ReliveView:onClickBtn(target)
    if target == self.noReviveBtn_ then        
        self:cancelCheck()
        self.viewController_:toRelive(false)        
    elseif target == self.reviveBtn_ then
        if not self.relivable then             
            jj.ui.JJToast:show({text = self.reason,dimens = self.dimens_})
        else
            self:cancelCheck()
            self.viewController_:toRelive(true)
        end
    end    
end

return ReliveView