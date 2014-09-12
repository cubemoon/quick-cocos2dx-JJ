local JJViewGroup = import("sdk.ui.JJViewGroup")
local MatchView = class("MatchView", JJViewGroup)
require("game.def.LordSingleMatchDefine")

function MatchView:ctor(params, customParam)
    MatchView.super.ctor(self)
    self.theme_ = params.theme
    self.dimens_ = params.dimens
    self.scene_ = params.scene
    self.tourneyInfo_ = params.tourneyInfo
    self.gameId_ = params.gameId
    self.customParam_ = customParam
    self.isLordSingle_ = self.gameId_ == JJGameDefine.GAME_ID_LORD_SINGLE
    if self.isLordSingle_ then
        self.singleMatchData_ = params.singleMatchData -- 单机比赛数据
        self.singleGameManager_ = params.singleGameManager
    end
    local height = self.dimens_:getDimens(103)
    local width = self.dimens_:getDimens(337)
    local bgSize = CCSize(337, 103)
    self:setViewSize(width, height)
    -- touch处理层
    self.touchLayer_ = jj.ui.JJViewGroup.new()
    self.touchLayer_:setAnchorPoint(ccp(0, 0))
    self.touchLayer_:setPosition(0,0)
    self.touchLayer_:setViewSize(width, height)
    self:addView(self.touchLayer_)
    if self.isLordSingle_ then
        local amount = 0
        local productName = "200金币入场" 
        local matchPro = ""      
        local matchProColor = self.customParam_.matchListPromptFontColor 
        if self.singleMatchData_ then
            if self.singleMatchData_.matchtype == LordSingleMatchDefine.MATCH_TYPE_DAOYUSAI then
                amount = "999人"
            else
                amount = tostring(self.singleMatchData_.maxsignupteam) .. "人"
            end
            productName = self.singleMatchData_.matchname
            if self.singleGameManager_:checkCanSignup(nil, self.singleMatchData_.matchid) then
                if self.singleMatchData_.awardinfo then
                    local awardInfo = self.singleMatchData_.awardinfo[1]
                    if awardInfo then
                        if self.singleMatchData_.matchtype == LordSingleMatchDefine.MATCH_TYPE_DAOYUSAI then
                            matchPro = string.format("第1~10局，每局奖励%d铜板+%d经验", awardInfo.copper, awardInfo.experience)
                        else
                            matchPro = string.format("第一名奖励%d铜板+%d经验", awardInfo.copper, awardInfo.experience)
                        end
                    end
                end
            else
                matchPro = "报名条件不足"
                matchProColor = ccc3(200, 56, 31)
            end
        end         
        self.bgBtn_ = jj.ui.JJButton.new({
            images = {
                normal = self.theme_:getImage("matchselect/lobby_match_item_normal_bg_n.png"),
                highlight = self.theme_:getImage("matchselect/lobby_match_item_normal_bg_d.png"),
                --                scale9 = true,
                viewSize = bgSize,
            },
            viewSize = bgSize,
            })   
        self.bgBtn_:setAnchorPoint(ccp(0, 1))
        self.bgBtn_:setPosition(0, height)
        self.bgBtn_:setScale(self.dimens_.scale_)
        self.bgBtn_:setOnClickListener(handler(self, self.onClick))
        self.touchLayer_:addView(self.bgBtn_)
        local left, top = 0, 0
        local fntSize = self.dimens_:getDimens(15)
        self.runAmount_ = jj.ui.JJLabel.new({
            singleLine = true,
            text = amount,--"800人",
            fontSize = self.dimens_:getDimens(self.customParam_.matchListPeronCountFontSize),
            color = self.customParam_.matchListPersonCountFontColor,
        })
        left = width - self.dimens_:getDimens(14)
        top = height - self.dimens_:getDimens(45)
        self.runAmount_:setAnchorPoint(ccp(1, 0))
        self.runAmount_:setPosition(left, top)
        self.touchLayer_:addView(self.runAmount_)


        self.time_ = jj.ui.JJLabel.new({
            singleLine = true,
            text = "即时",
            fontSize = self.dimens_:getDimens(self.customParam_.matchListTimerFontSize),
            color = self.customParam_.matchListTimerFontColor,
        })
        left = width - self.dimens_:getDimens(14)
        top = self.dimens_:getDimens(20)
        self.time_:setAnchorPoint(ccp(1, 0))
        self.time_:setPosition(left, top)
        self.touchLayer_:addView(self.time_)

        self.matchName_ = jj.ui.JJLabel.new({
            singleLine = true,
            text = productName,
            fontSize = self.dimens_:getDimens(self.customParam_.matchListNameFontSize),
            color = self.customParam_.matchListNameFontColor,
            viewSize = CCSize(self.dimens_:getDimens(250), self.dimens_:getDimens(30)),
        })
        left = self.dimens_:getDimens(14)
        top = height - self.dimens_:getDimens(21)
        self.matchName_:setAnchorPoint(ccp(0, 1))
        self.matchName_:setPosition(left, top)
        self.touchLayer_:addView(self.matchName_)

        self.matchPro_ = jj.ui.JJLabel.new({
            singleLine = true,
            text = matchPro,
            fontSize = self.dimens_:getDimens(self.customParam_.matchListPromptFontSize),
            color = matchProColor,
        })
        left = self.dimens_:getDimens(14)
        top = self.dimens_:getDimens(20)
        self.matchPro_:setAnchorPoint(ccp(0, 0))
        self.matchPro_:setPosition(left, top)
        self.touchLayer_:addView(self.matchPro_)
    else
        local runAmountFontColor = self.customParam_.matchListPersonCountFontColor
        local matchNameFontColor = self.customParam_.matchListNameFontColor
        local timeFontColor = self.customParam_.matchListTimerFontColor
        local matchProFontColor = self.customParam_.matchListPromptFontColor
        local amountText = "800人"
        local timeText = "散桌"
        local matchNameText = "200金币入场"
        local matchProText = "6副牌送一副秋卡"              
        if self.tourneyInfo_ then
            if self.tourneyInfo_.status_ == MatchDefine.STATUS_SIGNOUTABLE then
                runAmountFontColor = self.customParam_.matchListSignPersonCountFontColor
                matchNameFontColor = self.customParam_.matchListSignNameFontColor
                timeFontColor = self.customParam_.matchListSignTimerFontColor
                matchProFontColor = self.customParam_.matchListSignPromptFontColor
            end
            amountText = tostring(self.tourneyInfo_:getPlayerAmount()) .. "人"   
            timeText = self.tourneyInfo_:getStartTimeString()
            matchNameText = self.tourneyInfo_.matchconfig_ and self.tourneyInfo_.matchconfig_.productName
            if self.tourneyInfo_.matchconfig_ and self.tourneyInfo_.matchconfig_.brand ~= nil then
                matchProText = self.tourneyInfo_.matchconfig_.brand
            end
        end
        if self.tourneyInfo_ and self.tourneyInfo_.status_ == MatchDefine.STATUS_SIGNOUTABLE then
            self.bgBtn_ = jj.ui.JJButton.new({
                images = {
                    normal = self.theme_:getImage("matchselect/lobby_match_item_signed_bg_n.png"),
                    highlight = self.theme_:getImage("matchselect/lobby_match_item_signed_bg_d.png"),
                    --                    scale9 = true,
                    viewSize = bgSize,
                },
                viewSize = bgSize,
                })
        else           
            self.bgBtn_ = jj.ui.JJButton.new({
                images = {
                    normal = self.theme_:getImage("matchselect/lobby_match_item_normal_bg_n.png"),
                    highlight = self.theme_:getImage("matchselect/lobby_match_item_normal_bg_d.png"),
                    --                    scale9 = true,
                    viewSize = bgSize,
                },
                viewSize = bgSize,
                })          
        end
            self.bgBtn_:setAnchorPoint(ccp(0, 1))
            self.bgBtn_:setPosition(0, height)
        self.bgBtn_:setScale(self.dimens_.scale_)
            self.bgBtn_:setOnClickListener(handler(self, self.onClick))
            self.touchLayer_:addView(self.bgBtn_)       
            local left, top = 0, 0
            local fntSize = self.dimens_:getDimens(15)
            self.runAmount_ = jj.ui.JJLabel.new({
                singleLine = true,
                text = amountText,
                fontSize = self.dimens_:getDimens(self.customParam_.matchListPeronCountFontSize),
                color = runAmountFontColor,
            })
            left = width - self.dimens_:getDimens(14)
            top = height - self.dimens_:getDimens(45)
            self.runAmount_:setAnchorPoint(ccp(1, 0))
            self.runAmount_:setPosition(left, top)
            self.touchLayer_:addView(self.runAmount_)       

            self.time_ = jj.ui.JJLabel.new({
                singleLine = true,
                text = timeText,
                fontSize = self.dimens_:getDimens(self.customParam_.matchListTimerFontSize),
                color = timeFontColor,
            })
            left = width - self.dimens_:getDimens(14)
            top = self.dimens_:getDimens(20)
            self.time_:setAnchorPoint(ccp(1, 0))
            self.time_:setPosition(left, top)
            self.touchLayer_:addView(self.time_)                  

            self.matchName_ = jj.ui.JJLabel.new({
                singleLine = true,
                text = matchNameText,
                fontSize = self.dimens_:getDimens(self.customParam_.matchListNameFontSize),
                color = matchNameFontColor,
                viewSize = CCSize(self.dimens_:getDimens(245), self.dimens_:getDimens(30)),
            })
            left = self.dimens_:getDimens(14)
            top = height - self.dimens_:getDimens(21)
            self.matchName_:setAnchorPoint(ccp(0, 1))
            self.matchName_:setPosition(left, top)
            self.touchLayer_:addView(self.matchName_)       

            self.matchPro_ = jj.ui.JJLabel.new({
                singleLine = true,
                text = matchProText,
                fontSize = self.dimens_:getDimens(self.customParam_.matchListPromptFontSize),
                color = matchProFontColor,
            })
            left = self.dimens_:getDimens(14)
            top = self.dimens_:getDimens(20)
            self.matchPro_:setAnchorPoint(ccp(0, 0))
            self.matchPro_:setPosition(left, top)
            self.touchLayer_:addView(self.matchPro_)
    end           
end

function MatchView:onClick(target)
    if self.isLordSingle_ then
        if self.singleMatchData_ then
            self.scene_:showMatchDesView({
                singleMatchData = self.singleMatchData_,
            })
        end
    else
        self.scene_:showMatchDesView({
            tourneyInfo = self.tourneyInfo_,
        })
    end
end

return MatchView