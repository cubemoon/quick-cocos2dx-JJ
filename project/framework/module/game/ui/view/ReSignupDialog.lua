local ReSignupDialog = class("ReSignupDialog", import("sdk.ui.JJDialogBase"))
local TAG = "ReSignupDialog"
--[[
    参数
    @text: 提示的内容
    @close: 是否显示关闭按钮，默认显示
    @mask: 是否显示遮罩，默认显示
]]
function ReSignupDialog:ctor(params)
    --params.viewSize = CCSize(454, 303)
    ReSignupDialog.super.ctor(self, params)

    self.theme_ = params.theme
    self.dimens_ = params.dimens
    self.tourneyId_ = params.tourneyId or 0
    self.matchPoint_= params.matchPoint or 0
    --self:setScale(self.dimens_.scale_)
    --JJLog.i("linxh", "ReSignupDialog, matchpoint=", self.matchPoint_)
    -- 背景框 454*303
    local bg = jj.ui.JJImage.new({
        image = self.theme_:getImage("common/common_alert_dialog_bg.png"),
    })
    
    bg:setAnchorPoint(ccp(0.5, 0.5))
    bg:setPosition(self.dimens_.cx, self.dimens_.cy)
    bg:setScale(self.dimens_.scale_)
    bg:setTouchEnable(true)
    bg:setOnClickListener(handler(self, function() end ))
    self:addView(bg)
    local type = tonumber(params.matchType)
    --type = MatchDefine.MATCH_TYPE_TIMELY
    -- 提示文字
    if type == MatchDefine.MATCH_TYPE_FIXED then 
        self.scheduler_ = require(cc.PACKAGE_NAME..".scheduler")         
        self.countDownLabel_ = jj.ui.JJLabel.new({
                singleLine = true,
                fontSize = self.dimens_:getDimens(22),
                color = ccc3(0, 0, 0),
                text = "距离开赛时间：",
                align = ui.TEXT_ALIGN_CENTER,
            viewSize = CCSize(self.dimens_:getDimens(600), self.dimens_:getDimens(30))
            })
        self.countDownLabel_:setAnchorPoint(ccp(0.5, 1))
        self.countDownLabel_:setPosition(self.dimens_.cx, self.dimens_.cy)
        self:addView(self.countDownLabel_)

        self.timeToMatch = self.matchPoint_ - (math.modf(JJTimeUtil:getCurrentServerTime()/1000))
        
        self:countDown()
        self.countDownScheduler_ = self.scheduler_.scheduleGlobal(function() self:countDown() end, 1)

    elseif type == MatchDefine.MATCH_TYPE_TIMELY then
        local y = self.dimens_.cy + self.dimens_:getDimens(80)
        local ftSize = self.dimens_:getDimens(22)
        local lbl = jj.ui.JJLabel.new({
                singleLine = true,
                fontSize = ftSize,
                color = ccc3(0, 0, 0),
                text = "目前平均开赛时间为",
                align = ui.TEXT_ALIGN_LEFT,
            viewSize = CCSize(0, self.dimens_:getDimens(30))
            })
        lbl:setAnchorPoint(ccp(0, 1))
        lbl:setPosition(self.dimens_.cx - self.dimens_:getDimens(120), y)
        self:addView(lbl)

        self.intervalLabel_ = jj.ui.JJLabel.new({
            singleLine = true,
            fontSize = ftSize,
            color = ccc3(255, 0, 0),            
            align = ui.TEXT_ALIGN_CENTER,
            --text = "30",
            viewSize = CCSize(0, self.dimens_:getDimens(30))
            })
        self.intervalLabel_:setAnchorPoint(ccp(0, 1))
        self.intervalLabel_:setPosition(lbl:getPositionX() + lbl:getWidth(), y + self.dimens_:getDimens(2))
        self:addView(self.intervalLabel_)

        self.intervalLabelS_ = jj.ui.JJLabel.new({
            singleLine = true,
            fontSize = ftSize,
            color = ccc3(0, 0, 0),
            text = "秒",
            align = ui.TEXT_ALIGN_LEFT,
            })
        self.intervalLabelS_:setAnchorPoint(ccp(0, 1))
        self.intervalLabelS_:setPosition(self.intervalLabel_:getPositionX()+self.intervalLabel_:getWidth(), y)
        self:addView(self.intervalLabelS_)

        y = self.dimens_.cy + self.dimens_:getDimens(40)
        lbl = jj.ui.JJLabel.new({
                singleLine = true,
                fontSize = ftSize,
                color = ccc3(0, 0, 0),
                text = "大约还有",
                align = ui.TEXT_ALIGN_LEFT,
            viewSize = CCSize(0, 30)
            })
        lbl:setAnchorPoint(ccp(0, 1))
        lbl:setPosition(self.dimens_.cx - self.dimens_:getDimens(100), y)
        self:addView(lbl)

        self.startIntervalLabel_ = jj.ui.JJLabel.new({
            singleLine = true,
            fontSize = ftSize,
            color = ccc3(255, 0, 0),
            --text = "2",
            align = ui.TEXT_ALIGN_CENTER,
            viewSize = CCSize(0, self.dimens_:getDimens(30))
            })
        self.startIntervalLabel_:setAnchorPoint(ccp(0, 1))
        self.startIntervalLabel_:setPosition(lbl:getPositionX() + lbl:getWidth(), y + self.dimens_:getDimens(2))
        self:addView(self.startIntervalLabel_)

        self.startIntervalLabelS_ = jj.ui.JJLabel.new({
            singleLine = true,
            fontSize = ftSize,
            color = ccc3(0, 0, 0),
            text = "秒开赛...",
            align = ui.TEXT_ALIGN_LEFT,
            })
        self.startIntervalLabelS_:setAnchorPoint(ccp(0, 1))
        self.startIntervalLabelS_:setPosition(self.startIntervalLabel_:getPositionX()+self.startIntervalLabel_:getWidth(), y)
        self:addView(self.startIntervalLabelS_)

        y = self.dimens_.cy - self.dimens_:getDimens(20)
        self.progress = jj.ui.JJLoadingBar.new({
                viewSize = CCSize(300,32),
                background = {image = self.theme_:getImage("matchselect/match_item_time_progress_bg.png"), 
                            zorder = -1 },
                images = { progress = self.theme_:getImage("matchselect/match_item_time_progress.png"), 
                            zorder = 1 }
            })
        self.progress:setAnchorPoint(ccp(0.5, 0.5))
        self.progress:setPosition(self.dimens_.cx, y)
        self.progress:setScale(self.dimens_.scale_)
        self.progress:setVisible(false)
        self:addView(self.progress)

        y = self.dimens_.cy - self.dimens_:getDimens(10)
        self.personLabel_ = jj.ui.JJLabel.new({
            singleLine = true,
            fontSize = self.dimens_:getDimens(13),
            color = ccc3(0, 0, 0),
            --text = "24/96",
            align = ui.TEXT_ALIGN_CENTER,
            valgin = ui.TEXT_VALIGN_CENTER,
            viewSize = CCSize(self.dimens_:getDimens(100), self.dimens_:getDimens(20))
            })
        self.personLabel_:setAnchorPoint(ccp(0.5, 1))
        self.personLabel_:setPosition(self.dimens_.cx, y)
        self.personLabel_:setVisible(false)
        self:addView(self.personLabel_)
    end

    --退赛
    self.btnSignout_ = jj.ui.JJButton.new({
        images = {
            normal = "img/diploma/diploma_resignup_dialog_view_btn_red_n.png",
            highlight = "img/diploma/diploma_resignup_dialog_view_btn_red_d.png",
            disable = "img/diploma/diploma_resignup_dialog_view_btn_red_d.png"
        },
        color = ccc3(255, 255, 255),
        text = "退赛",
        fontSize = self.dimens_:getDimens(30),
        viewSize = CCSize(self.dimens_:getDimens(234), self.dimens_:getDimens(68)), 

    })
    self.btnSignout_:setAnchorPoint(ccp(0.5, 1))
    --self.btnSignout_:setScale(self.dimens_.scale_)
    self.btnSignout_:setPosition(self.dimens_.cx, self.dimens_.cy - self.dimens_:getDimens(45))
    self.btnSignout_:setOnClickListener(handler(self, function()
                                                    LobbyDataController:unSignupMatch(self.tourneyId_)
                                                end ))
    self:addView(self.btnSignout_)

    --    self:setStartMatchAvgTime(30)
    --    self:setStartMatchLastTime(17)
    --    self:setPercent(24, 96)
end

function ReSignupDialog:onExit()
    if self.countDownScheduler_ then
        self.scheduler_.unscheduleGlobal(self.countDownScheduler_)
    end

    ReSignupDialog.super.onExit(self)
end


local function _getMatchStartPointPrompt(time)
    local prompt = ""
    if time > 0 then
        local second = math.fmod(time, 60)
        local nMin = math.modf(time/60)
        if nMin > 0 then
            local nHour = math.modf(nMin/60)
            local nDay = math.modf(nHour/24)
            nMin = nMin - nHour * 60
            nHour = nHour - nDay * 24
            --超过1天
            if nDay > 0 then 
                prompt = prompt .. nDay .. "天"
            end
            if nHour > 0 then
                prompt = prompt .. nHour .. "小时"
            end
            if nMin > 0 then
                prompt = prompt .. nMin .. "分钟"
            end
            if second > 0 then
               prompt = prompt .. second .. "秒" 
            end
        else
            if second > 0 then
               prompt = prompt .. second .. "秒" 
            end
        end
    end

    return prompt
end


function ReSignupDialog:countDown()
    if self.countDownLabel_ then
        if self.timeToMatch >= 1 then self.timeToMatch = self.timeToMatch - 1 end 
        if self.timeToMatch < 1 then self.timeToMatch = 1 end
        local str = _getMatchStartPointPrompt(self.timeToMatch)          
        self.countDownLabel_:setText("距离开赛时间：" .. str)
    end

end

function ReSignupDialog:setStartMatchAvgTime(startMatchAvgTime) 
    if self.intervalLabel_ and startMatchAvgTime then
        if startMatchAvgTime < 0 then startMatchAvgTime = 20 end
        self.intervalLabel_:setText(startMatchAvgTime)
        self.intervalLabelS_:setPositionX(self.intervalLabel_:getPositionX()+self.intervalLabel_:getWidth())
    end
end

function ReSignupDialog:setStartMatchLastTime(startMatchLastTime)
    if self.startIntervalLabel_ and startMatchLastTime then
        if startMatchLastTime < 0 then startMatchLastTime = 2 end
        self.startIntervalLabel_:setText(startMatchLastTime)
        self.startIntervalLabelS_:setPositionX(self.startIntervalLabel_:getPositionX()+self.startIntervalLabel_:getWidth())
    end
end

function ReSignupDialog:setPercent(current, total)
    if current and total then 
        if current > total then
            current = total
        end        
        if self.progress then
            self.progress:setVisible(true)
            self.progress:setValue(math.modf(current*100/total))
        end

        if self.personLabel_ then
            self.personLabel_:setVisible(true)
            self.personLabel_:setText(string.format("%d/%d", current, total))
        end
    end
end


--[[
    设置是否点击外部即销毁对话框

function ReSignupDialog:setCanceledOnTouchOutside(cancel)
    ReSignupDialog.super.setCanceledOnTouchOutside(self, cancel)
    self.cancel_ = cancel
end
]]


return ReSignupDialog
