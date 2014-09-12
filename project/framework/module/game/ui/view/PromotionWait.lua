-- 晋级等待
--[[ 如果重载了该view必须实现以下方法
setContent(), setTotalRank(), updateStageBontResult(), setWaitInfo()
]]
local PromotionWait = class("PromotionWait", require("game.ui.view.JJMatchView"))
require("game.def.MatchRulerDefine")
local scheduler = require(cc.PACKAGE_NAME..".scheduler")
local DynamicDisplayManager = require("game.data.config.DynamicDisplayManager")

local WAITTIME_STYLE_1 = 1 --平均时间>已开赛时间
local WAITTIME_STYLE_2 = 2 --平均时间<已开赛时间
local AVERAGE_WAIT_TIME = 300

local DISPLAY_STYLE_OLD = 0
local DISPLAY_STYLE_NEW = 0

--====================小球==========================--
local PromotionBall = class("PromotionBall", require("sdk.ui.JJViewGroup"))

function PromotionBall:ctor(theme, past)
    PromotionBall.super.ctor(self, {viewSize = CCSize(96, 96)})
    self.theme_ = theme

    self.ballNumber = {self.theme_:getImage("game/promotion/promotion_wait_number_0.png"),
                       self.theme_:getImage("game/promotion/promotion_wait_number_1.png"),
                       self.theme_:getImage("game/promotion/promotion_wait_number_2.png"),
                       self.theme_:getImage("game/promotion/promotion_wait_number_3.png"),
                       self.theme_:getImage("game/promotion/promotion_wait_number_4.png"),
                       self.theme_:getImage("game/promotion/promotion_wait_number_5.png"),
                       self.theme_:getImage("game/promotion/promotion_wait_number_6.png"),
                       self.theme_:getImage("game/promotion/promotion_wait_number_7.png"),
                       self.theme_:getImage("game/promotion/promotion_wait_number_8.png"),
                       self.theme_:getImage("game/promotion/promotion_wait_number_9.png"),
                   }

    local cx, cy = 48, 48
    local bg = jj.ui.JJImage.new({
        image = self.theme_:getImage("game/promotion/promotion_ball_bg.png")
        })
    bg:setAnchorPoint(ccp(0.5, 0.5))
    bg:setPosition(cx, cy)    
    self:addView(bg)

    self.fg = jj.ui.JJImage.new({
        image = (past and self.theme_:getImage("game/promotion/promotion_ball_current.png"))
                or self.theme_:getImage("game/promotion/promotion_ball_later.png")
        })
    self.fg:setAnchorPoint(ccp(0.5, 0.5))
    self.fg:setPosition(cx, cy-1)    
    self:addView(self.fg)

    self.num1 = jj.ui.JJImage.new({
        image = self.ballNumber[3]
        })
    self.num1:setAnchorPoint(ccp(0, 1))
    self.num1:setPosition(21, 68)    
    self:addView(self.num1)

    self.num2 = jj.ui.JJImage.new({
        image = self.ballNumber[4]
        })
    self.num2:setAnchorPoint(ccp(0, 1))
    self.num2:setPosition(35, 68)    
    self:addView(self.num2)

    self.num3 = jj.ui.JJImage.new({
        image = self.ballNumber[5]
        })
    self.num3:setAnchorPoint(ccp(0, 1))
    self.num3:setPosition(48, 68)    
    self:addView(self.num3)

    self.prompt = jj.ui.JJImage.new({
        image = self.theme_:getImage("game/promotion/promotion_ball_x_promotion.png")
        })
    self.prompt:setAnchorPoint(ccp(0, 1))
    self.prompt:setPosition(30, 64)    
    self:addView(self.prompt)
end

function PromotionBall:setCount(count, last, first)
    local n1 = math.modf(count/100)
    if n1 > 0 then count = count - n1*100 end

    local n2 = math.modf(count/10)
    if n2 > 0 then count = count - n2*10 end

    local n3 = count

    if n1 > 0 then        
        self.num1:setImage(self.ballNumber[n1+1])        
        self.num2:setImage(self.ballNumber[n2+1])
        self.num3:setImage(self.ballNumber[n3+1])
    elseif n2 > 0 then
        self.num1:setPositionX(28)
        self.num1:setImage(self.ballNumber[n2+1])        
        self.num2:setPositionX(44)
        self.num2:setImage(self.ballNumber[n3+1])
        self.num3:setVisible(false)
    else
        --self.num2:setPositionX(40)
        self.num2:setImage(self.ballNumber[n3+1])        
        self.num1:setVisible(false) 
        self.num3:setVisible(false)      
    end
    
    if last then
        if n1 > 0 then   
            self.prompt:setImage(self.theme_:getImage("game/promotion/promotion_ball_x_promotion_zg.png"))
        else
            self.prompt:setImage(self.theme_:getImage("game/promotion/promotion_ball_x_promotion_zg2.png"))
        end
    elseif first then
        self.prompt:setImage(self.theme_:getImage("game/promotion/promotion_ball_1_startmatch.png"))
    elseif n2 > 0 then   
        self.prompt:setImage(self.theme_:getImage("game/promotion/promotion_ball_x_promotion.png"))
        self.prompt:setPositionX(28)
    else
        self.prompt:setImage(self.theme_:getImage("game/promotion/promotion_ball_x_promotion_2.png"))
    end
end    
--==================================================--
function PromotionWait:getWaitList(waitStr)
    --waitStr like  "96,24,12,6,3"
    --waitStr = waitStr or "96,24,12,6,3"
    --JJLog.i("linxh", "getWaitList waitstr=", waitStr)
    local index, waitList = 0

    if waitStr then
        waitList = {}
        local len = string.len(waitStr)
        local i, st, et = 1
        while i <= len do
            st, et = string.find(waitStr, ",", i, true)
            --JJLog.i("linxh", "st=", st, "et=", et, "i=", i)
            if st then 
                index = index + 1
                waitList[index] = tonumber(string.sub(waitStr, i, st-1))
                i = et + 1
            else
                if i <= len then 
                    index = index + 1
                    waitList[index] = tonumber(string.sub(waitStr, i, -1))
                end
                break
            end
        end
    end

    if index < 1 then 
        waitList = nil 
    else
        table.sort(waitList, function(a, b) return b < a end)
    end
    --JJLog.i("linxh", vardump(waitList, "waitList"))
    return waitList
end
--==================================================--
function PromotionWait:ctor(viewController)
    PromotionWait.super.ctor(self, viewController)    
    self.gameId = viewController.gameId_ --获取当前游戏gameId
    self.stageOrBoutFlag = 0 --用于区分当前以bout 为准还以Stage 为准    

    self:initView()

    --更新局制信息（还剩多少桌）
    scheduler.performWithDelayGlobal(handler(self, self.askGetRank), 0.5)

    self:setContent()

    --延时处理， 否则无法准确获得剩余桌数
    scheduler.performWithDelayGlobal(handler(self, self.initPromotionData), 0.2)

    --[[self:setPromotion_promt("您的得分较高，晋级机会很大，请耐心等待其他选手完成比赛。", 1000)
    self:updateStageBontResult(12, 100)]]

    --[[self:setTableRank(1, 3)
    self:setScore(14500)
    self:setPromotion_promt("您的得分较高，晋级机会很大，请耐心等待其他选手完成比赛。", 1000)
    self:updateStageBontResult(7, 10)
    self:displayRemainTime(10, 2)]]
end

function PromotionWait:onExit()
    JJLog.i("linxh", "PromotionWait:onExit")
    if self.updateTableScheduler then
        scheduler.unscheduleGlobal(self.updateTableScheduler)
        self.updateTableScheduler = nil
    end
    self.destoryed = true
end

function PromotionWait:askGetRank()    
    local md = self.viewController_:getMatchData()
    if md then
        MatchMsg:sendStageBoutResultReq(md.matchId_, {UserInfo.userId_})
    end

    if not self.updateTableScheduler then 
        self.updateTableScheduler = scheduler.scheduleGlobal(handler(self, self.askGetRank), 10)
    end
end

function PromotionWait:initView()
    local bg = jj.ui.JJImage.new({
        image = self.theme_:getImage("common/bg_normal.jpg")
        })
    bg:setPosition(self.dimens_.cx, self.dimens_.cy)
    bg:setScaleX(self.dimens_.wScale_)
    bg:setScaleY(self.dimens_.hScale_)
    self:addView(bg)

    local md = self.viewController_:getMatchData() 
    local txt = md and md.matchName_
    if not txt or string.len(txt) == 0 then txt = "晋级等待" end
    --txt = "免费10元话费赛"
    local title = jj.ui.JJLabel.new({
        text = txt,
        fontSize = self.dimens_:getDimens(26),
        align = ui.TEXT_ALIGN_CENTER,
        valign = ui.TEXT_VALIGN_CENTER,
        color = ccc3(255, 255, 255),
        })
    title:setAnchorPoint(CCPoint(0.5, 1))
    title:setPosition(self.dimens_.cx, self.dimens_.top - self.dimens_:getDimens(20))
    self:addView(title)

    
    self.styleGrp = jj.ui.JJViewGroup.new({
        viewSize = CCSize(self.dimens_:getDimens(854), self.dimens_:getDimens(380))
    })
    self.styleGrp:setAnchorPoint(ccp(0.5, 1))
    self.styleGrp:setPosition(self.dimens_.cx, self.dimens_.top-self.dimens_:getDimens(75))    
    --self.styleGrp:setScale(self.dimens_.scale_)
    self:addView(self.styleGrp)
        
    
    local tourneyInfo = md and TourneyController:getTourneyInfoByTourneyId(md.tourneyId_)
    self.waitMatchList = self:getWaitList(tourneyInfo and tourneyInfo.matchconfig_ and tourneyInfo.matchconfig_.waitMatch)    
    --self.waitMatchList = {480,210, 96, 24, 12, 6, 3}    
    if self.waitMatchList then        
        self:initNewStyle()
    else
        self:initOldStyle()
    end

    local allowRoar = DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_ROAR)
    if allowRoar then
    self.btnNews = jj.ui.JJButton.new({
                    images = {
                        normal = self.theme_:getImage("common/common_alert_dialog_btn_1_n.png"),
                        highlight = self.theme_:getImage("common/common_alert_dialog_btn_1_d.png"),
                        disable = self.theme_:getImage("common/common_alert_dialog_btn_1_d.png")
                    },
                    text = "头条看点", 
                    font = "Arial",
                    color = ccc3(255, 255, 255),
                    fontSize = self.dimens_:getDimens(26),
                    viewSize = CCSize(self.dimens_:getDimens(198), self.dimens_:getDimens(76)), 
                  })
    --self.btnNews:setScale(self.dimens_.scale_)
    self.btnNews:setAnchorPoint(ccp(1, 0))
    self.btnNews:setPosition(self.dimens_.cx - self.dimens_:getDimens(65), self.dimens_:getDimens(30))
    self.btnNews:setOnClickListener(handler(self, self.onClick))
    self:addView(self.btnNews)
    end

    self.btnMatchDesc = jj.ui.JJButton.new({
                    images = {
                        normal = self.theme_:getImage("common/common_alert_dialog_btn_1_n.png"),
                        highlight = self.theme_:getImage("common/common_alert_dialog_btn_1_d.png"),
                        disable = self.theme_:getImage("common/common_alert_dialog_btn_1_d.png")
                    },
                    text = "赛场详情", 
                    font = "Arial",
                    color = ccc3(255, 255, 255),
                    fontSize = self.dimens_:getDimens(26),
                    viewSize = CCSize(self.dimens_:getDimens(198), self.dimens_:getDimens(76)), 
                  })
    if allowRoar then
        self.btnMatchDesc:setAnchorPoint(ccp(0, 0))
        self.btnMatchDesc:setPosition(self.dimens_.cx + self.dimens_:getDimens(65), self.dimens_:getDimens(30))
    else
        self.btnMatchDesc:setAnchorPoint(ccp(0.5, 0))
        self.btnMatchDesc:setPosition(self.dimens_.cx, self.dimens_:getDimens(30))
    end
    --self.btnMatchDesc:setScale(self.dimens_.scale_)
    self.btnMatchDesc:setOnClickListener(handler(self, self.onClick))
    self:addView(self.btnMatchDesc)
end

function PromotionWait:initOldStyle()
    self.style = DISPLAY_STYLE_OLD
    local grp = self.styleGrp
    local width = grp:getWidth()
    local cx, top = width/2, grp:getHeight()-self.dimens_:getDimens(20)

    self.promptContent = jj.ui.JJLabel.new({
        text = "正在获取比赛信息，请稍候...",
        fontSize = self.dimens_:getDimens(18),
        align = ui.TEXT_ALIGN_CENTER,
        valign = ui.TEXT_VALIGN_TOP,
        color = ccc3(255, 255, 255),
        viewSize = CCSize(width, self.dimens_:getDimens(30))
        })
    self.promptContent:setAnchorPoint(CCPoint(0.5, 1))
    self.promptContent:setPosition(cx, top)
    grp:addView(self.promptContent)

   local x, y = cx, top-self.dimens_:getDimens(30)
   local bg = jj.ui.JJImage.new({
        image = self.theme_:getImage("common/common_view_bg.png"),
        scale9 = true,
        viewSize = CCSize(self.dimens_:getDimens(700), self.dimens_:getDimens(230))})
    bg:setAnchorPoint(ccp(0.5, 1))
    bg:setPosition(x, y)
    grp:addView(bg)

    y = y - self.dimens_:getDimens(25)
    x = self.dimens_:getDimens(120)
    self.rankTitle = jj.ui.JJLabel.new({
        text = "本桌排名：",
        fontSize = self.dimens_:getDimens(20),
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_TOP,
        color = ccc3(255, 255, 255),
        })
    self.rankTitle:setAnchorPoint(CCPoint(0, 1))
    self.rankTitle:setPosition(x, y)
    grp:addView(self.rankTitle)

    self.rankSelf = jj.ui.JJLabel.new({
        text = "1",
        fontSize = self.dimens_:getDimens(20),
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_TOP,
        color = ccc3(255, 217, 0),
        })
    self.rankSelf:setAnchorPoint(CCPoint(0, 1))
    self.rankSelf:setPosition(x+self.rankTitle:getWidth(), y)
    grp:addView(self.rankSelf)

    self.rankTotal = jj.ui.JJLabel.new({
        text = "/20",
        fontSize = self.dimens_:getDimens(20),
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_TOP,
        color = ccc3(255, 255, 255),
        })
    self.rankTotal:setAnchorPoint(CCPoint(0, 1))
    self.rankTotal:setPosition(x+self.dimens_:getDimens(120), y)
    grp:addView(self.rankTotal)

    y = y - self.dimens_:getDimens(25)
    local scoreTitle = jj.ui.JJLabel.new({
        text = "当前积分：",
        fontSize = self.dimens_:getDimens(20),
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_TOP,
        color = ccc3(255, 255, 255),
        })
    scoreTitle:setAnchorPoint(CCPoint(0, 1))
    scoreTitle:setPosition(x, y)
    grp:addView(scoreTitle)

    self.score = jj.ui.JJLabel.new({
        text = "8400",
        fontSize = self.dimens_:getDimens(20),
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_TOP,
        color = ccc3(255, 217, 0),
        })
    self.score:setAnchorPoint(CCPoint(0, 1))
    self.score:setPosition(x+scoreTitle:getWidth(), y)
    grp:addView(self.score)

    y = y - self.dimens_:getDimens(30)
    local div = jj.ui.JJImage.new({
        image = self.theme_:getImage("common/common_view_list_div_h.png"),
        scale9 = true,
        viewSize = CCSize(self.dimens_:getDimens(700), self.dimens_:getDimens(2))})
    div:setAnchorPoint(ccp(0.5, 1))
    div:setPosition(cx, y)
    grp:addView(div)

    y = y - self.dimens_:getDimens(20)
    self.promotionPrompt = jj.ui.JJLabel.new({
        text = "您当前晋级机会比较大啊",
        fontSize = self.dimens_:getDimens(18),
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_TOP,
        color = ccc3(255, 255, 255),
        viewSize = CCSize(600, 30)
        })
    self.promotionPrompt:setAnchorPoint(CCPoint(0, 1))
    self.promotionPrompt:setPosition(x, y)
    self.promotionPrompt:setVisible(false)
    grp:addView(self.promotionPrompt)

    y = y - self.dimens_:getDimens(40)
    self.ruler = jj.ui.JJLabel.new({
        text = "晋级规则：第一名晋级，第二名待定，第三名淘汰",
        fontSize = self.dimens_:getDimens(20),
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_CENTER,
        color = ccc3(255, 217, 0),
        viewSize = CCSize(self.dimens_:getDimens(600), self.dimens_:getDimens(30))
        })
    self.ruler:setAnchorPoint(CCPoint(0, 1))
    self.ruler:setPosition(x, y)
    grp:addView(self.ruler)

    -- 当前还有多少桌 
    y = y - self.dimens_:getDimens(50)
    self.leftTable = jj.ui.JJLabel.new({
        text = "还有45桌未完成比赛，",
        fontSize = self.dimens_:getDimens(18),
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_TOP,
        color = ccc3(255, 255, 255),
        })
    self.leftTable:setAnchorPoint(CCPoint(0, 1))
    self.leftTable:setPosition(x, y)
    self.leftTable:setVisible(false)
    grp:addView(self.leftTable)

    self.waitTime = jj.ui.JJLabel.new({
        text = "请稍候...",
        fontSize = self.dimens_:getDimens(18),
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_TOP,
        color = ccc3(255, 255, 255),
        })
    self.waitTime:setAnchorPoint(CCPoint(0, 1))
    self.waitTime:setPosition(cx, y)
    self.waitTime:setVisible(false)
    grp:addView(self.waitTime)      
end

function PromotionWait:initNewStyle()
    self.style = DISPLAY_STYLE_NEW
    local grp = self.styleGrp
    local width = self.dimens_:getDimens(854)
    local cx, top = width/2, self.dimens_:getDimens(380)

    local x = self:initBallView()

    --排名&小人动画
    self.rankGrp = jj.ui.JJViewGroup.new({
        viewSize = CCSize(self.dimens_:getDimens(240), self.dimens_:getDimens(140))
    })
    self.rankGrp:setAnchorPoint(ccp(1, 1))
    self.rankGrp:setPosition(x+self.dimens_:getDimens(120), top)     
    grp:addView(self.rankGrp)
    self:initRankScore()

    --剩余桌数
    self.leftGrp = jj.ui.JJViewGroup.new({
        viewSize = CCSize(self.dimens_:getDimens(200), self.dimens_:getDimens(30))
    })
    self.leftGrp:setAnchorPoint(ccp(0, 1))
    self.leftGrp:setPosition(x-self.dimens_:getDimens(30), self.dimens_:getDimens(230))  
    self.leftGrp:setVisible(false)
    grp:addView(self.leftGrp)
    self:initLeftGrp()
   

    --平均晋级分，晋级几率
    local bg = jj.ui.JJImage.new({
        image = self.theme_:getImage("common/common_view_bg.png"),
        scale9 = true,
        viewSize = CCSize(self.dimens_:getDimens(500), self.dimens_:getDimens(100))})
    bg:setAnchorPoint(ccp(0.5, 0))
    bg:setPosition(cx, self.dimens_:getDimens(90))
    grp:addView(bg)

    self.promotionScore = jj.ui.JJLabel.new({
        text = "平均1000分晋级",
        fontSize = self.dimens_:getDimens(18),
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_TOP,
        color = ccc3(189, 240, 255),
        })
    self.promotionScore:setAnchorPoint(CCPoint(0, 0))
    self.promotionScore:setPosition(cx-self.dimens_:getDimens(230), self.dimens_:getDimens(155))
    self.promotionScore:setVisible(false)
    grp:addView(self.promotionScore)

    self.promotionPrompt = jj.ui.JJLabel.new({
        text = "您已率先完成本轮，请等候其他玩家打完后进行排名并决定晋级者",
        fontSize = self.dimens_:getDimens(18),
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_TOP,
        color = ccc3(255, 255, 255),
        viewSize = CCSize(self.dimens_:getDimens(450), 0)
        })
    self.promotionPrompt:setAnchorPoint(CCPoint(0, 0))
    self.promotionPrompt:setPosition(cx-self.dimens_:getDimens(230), self.dimens_:getDimens(95))
    self.promotionPrompt:setVisible(false)
    grp:addView(self.promotionPrompt)
end


function PromotionWait:getCurrentBallId()
    local md = self.viewController_:getMatchData() 
    local winCount = (md and md.leavePlayer_) or 1
    local count = #self.waitMatchList

    self.currentBallId = nil
    if count > 1 then
        if winCount <= self.waitMatchList[1] and winCount > self.waitMatchList[2] then
            self.currentBallId = 1
        end
    end
    
    if not self.currentBallId and count >= 3 then
        if winCount <= self.waitMatchList[2] and winCount > self.waitMatchList[3] then
            self.currentBallId = 2
        end
    end

    if not self.currentBallId and count >= 4 then
        if winCount <= self.waitMatchList[3] and winCount > self.waitMatchList[4] then
            self.currentBallId = 3
        end

        if count == 4 and (winCount == self.waitMatchList[4] or winCount == 3) then
            self.currentBallId = 3
        end
    end

    if not self.currentBallId and count >= 5 then
        if winCount <= self.waitMatchList[4] and winCount > self.waitMatchList[5] then
            self.currentBallId = 4
        end

        if count == 5 and (winCount == self.waitMatchList[5] or winCount == 3) then
            self.currentBallId = 4
        end
    end

    if not self.currentBallId and count >= 6 then
        if winCount <= self.waitMatchList[5] and winCount > self.waitMatchList[6] then
            self.currentBallId = 5
        end

        if count == 6 and (winCount == self.waitMatchList[6] or winCount == 3) then
            self.currentBallId = 5
        end
    end

    if not self.currentBallId and count >= 7 then
        if winCount <= self.waitMatchList[6] and winCount > self.waitMatchList[7] then
            self.currentBallId = 6
        end

        if count == 7 and (winCount == self.waitMatchList[7] or winCount == 3 or winCount == 4) then
            self.currentBallId = 6
        end
    end

    self.currentBallId = self.currentBallId or 1
    return self.currentBallId
end

function PromotionWait:initBallView()
    --7个小圆球
    local grp = self.styleGrp
    
    local count = #self.waitMatchList
    local current = self:getCurrentBallId()
    local x = self.dimens_:getDimens(427) - self.dimens_:getDimens(52)*count
    local y = self.dimens_:getDimens(200)

    if current >= 1 and count > 1 then
        x = x - self.dimens_:getDimens(52)
    end

    local currentX = x --返回当前球位置坐标

    --self.balls = {}
    local ball, progress, size
    for i = 1, count-1 do
        ball = PromotionBall.new(self.theme_, i==current)
        ball:setAnchorPoint(ccp(0, 0))
        ball:setPosition(x, y)    
        ball:setScale(self.dimens_.scale_)            
        grp:addView(ball)
        ball:setCount(self.waitMatchList[i], false, i==1)


        if i == current then             
            size = 300 --136
        else 
            size = 12 --40
        end

        if i == current then             
            self.progress = jj.ui.JJLoadingBar.new({
                viewSize = CCSize(size, 32),
                background = {image = self.theme_:getImage("game/promotion/promotion_wait_ball_and_progress_past_bg.png"), 
                            zorder = jj.ui.JJLoadingBar.BG_ZORDER,
                            scale9 = true,  },
                images = { progress = self.theme_:getImage("game/promotion/promotion_wait_style_2_progress.png"), 
                            zorder = jj.ui.JJLoadingBar.PROGRESS_ZORDER, 
                            },               
                
            })
            self.progress:setAnchorPoint(ccp(0, 0.5))
            self.progress:setPosition(x+self.dimens_:getDimens(79), y+self.dimens_:getDimens(48))
            self.progress:setValue(1)           
            self.progress:setScale(self.dimens_.scale_)
            grp:addView(self.progress)              
            x = x + self.dimens_:getDimens(size-87)
            currentX = x - self.dimens_:getDimens(80)
        else
            progress = jj.ui.JJImage.new({
                    image = self.theme_:getImage("game/promotion/promotion_wait_ball_and_progress_past_bg.png"),
                    scale9 = true,
                    viewSize = CCSize(size, 32)})
            progress:setAnchorPoint(ccp(0, 0.5))
            progress:setPosition(x+self.dimens_:getDimens(85), y+self.dimens_:getDimens(48))
            progress:setScale(self.dimens_.scale_)
            grp:addView(progress)
        end

        x = x+self.dimens_:getDimens(85)
    end
    
    self.lastBallGrp = jj.ui.JJViewGroup.new({
        viewSize = CCSize(self.dimens_:getDimens(158), self.dimens_:getDimens(120))
    })
    self.lastBallGrp:setAnchorPoint(ccp(0, 0))
    self.lastBallGrp:setPosition(x, y)    
    grp:addView(self.lastBallGrp)
    self:initLastBallGrp()
    self.lastBall:setCount(self.waitMatchList[count], true, false)

    return currentX
end

function PromotionWait:initLeftGrp()
    local grp = self.leftGrp
    
    local lbl = jj.ui.JJLabel.new({
        text = "剩余",
        fontSize = self.dimens_:getDimens(22),
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_TOP,
        color = ccc3(255, 255, 255),
        })
    lbl:setAnchorPoint(CCPoint(0, 1))
    lbl:setPosition(0, self.dimens_:getDimens(30))
    grp:addView(lbl)

    self.leftTableNew = jj.ui.JJLabel.new({
        text = "500",
        fontSize = self.dimens_:getDimens(24),
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_TOP,
        color = ccc3(255, 217, 0),
        })
    self.leftTableNew:setAnchorPoint(CCPoint(0, 1))
    self.leftTableNew:setPosition(lbl:getWidth(), self.dimens_:getDimens(30))
    grp:addView(self.leftTableNew)

    self.leftTimePrompt = jj.ui.JJLabel.new({
        text = "桌，请稍候...",
        fontSize = self.dimens_:getDimens(22),
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_TOP,
        color = ccc3(255, 255, 255),
        })
    self.leftTimePrompt:setAnchorPoint(CCPoint(0, 1))
    self.leftTimePrompt:setPosition(self.dimens_:getDimens(60), self.dimens_:getDimens(30))
    grp:addView(self.leftTimePrompt)
end

function PromotionWait:initLastBallGrp()
    local grp = self.lastBallGrp

    self.lastBall = PromotionBall.new(self.theme_, false)
    self.lastBall:setAnchorPoint(ccp(0, 0))
    self.lastBall:setPosition(0, 0)  
    self.lastBall:setScale(self.dimens_.scale_) 
    grp:addView(self.lastBall)

    local hat = jj.ui.JJImage.new({
        image = self.theme_:getImage("game/promotion/promotion_hat_bg.png")})
    hat:setAnchorPoint(ccp(0, 0))
    hat:setPosition(self.dimens_:getDimens(18), self.dimens_:getDimens(65))
    hat:setScale(self.dimens_.scale_) 
    grp:addView(hat)
end

function PromotionWait:initRankScore()
    local grp = self.rankGrp
    
    local x, y = 0, self.dimens_:getDimens(140)
    --当前积分
    local bg = jj.ui.JJImage.new({
        image = self.theme_:getImage("game/promotion/promotion_wait_style2_rank_bg.png"),
        viewSize = CCSize(self.dimens_:getDimens(171), self.dimens_:getDimens(73)),
        })
    bg:setAnchorPoint(ccp(0, 1))
    bg:setPosition(x, y)    
    bg:setScale(self.dimens_.scale_)
    grp:addView(bg)

    x = x + self.dimens_:getDimens(5)
    y = y - self.dimens_:getDimens(10)
    local lbl = jj.ui.JJLabel.new({
        text = "当前积分：",
        fontSize = self.dimens_:getDimens(18),
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_TOP,
        color = ccc3(255, 255, 255),
        })
    lbl:setAnchorPoint(CCPoint(0, 1))
    lbl:setPosition(x, y)
    grp:addView(lbl)

    self.score = jj.ui.JJLabel.new({
        text = "26700",
        fontSize = self.dimens_:getDimens(18),
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_TOP,
        color = ccc3(255, 255, 255),
        })
    self.score:setAnchorPoint(CCPoint(0, 1))
    self.score:setPosition(x+self.dimens_:getDimens(85), y)
    grp:addView(self.score)

    y = y - self.dimens_:getDimens(30)
    self.rankTitle = jj.ui.JJLabel.new({
        text = "本桌排名：",
        fontSize = self.dimens_:getDimens(18),
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_TOP,
        color = ccc3(255, 255, 255),
        })
    self.rankTitle:setAnchorPoint(CCPoint(0, 1))
    self.rankTitle:setPosition(x, y)
    grp:addView(self.rankTitle)

    self.rank = jj.ui.JJLabel.new({
        text = "23/35",
        fontSize = self.dimens_:getDimens(18),
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_TOP,
        color = ccc3(255, 255, 255),
        })
    self.rank:setAnchorPoint(CCPoint(0, 1))
    self.rank:setPosition(x+self.dimens_:getDimens(85), y)
    grp:addView(self.rank)

    --动画
    self:addAnimView(grp)
end    

--小人动画
function PromotionWait:addAnimView(parent)
    self.animImages = self:getAnimImages()
    local array = CCArray:create()
    for k, img in pairs(self.animImages) do
      array:addObject(CCSpriteFrame:create(img, CCRect(0, 0, 180, 223)))
    end
    local animation = CCAnimation:createWithSpriteFrames(array, 0.08)
    self.anim_ = jj.ui.JJImage.new({
        image = self.theme_:getImage("switchtogame/loading1.png")})
    self.anim_:setAnchorPoint(ccp(0, 1))
    self.anim_:setPosition(self.dimens_:getDimens(160), self.dimens_:getDimens(120))
    self.anim_:setScale(self.dimens_.scale_*0.4)
    parent:addView(self.anim_)
    self.anim_:playAnimationForever(animation)
end

function PromotionWait:getAnimImages()
  return {self.theme_:getImage("switchtogame/loading1.png"),
          self.theme_:getImage("switchtogame/loading2.png"),
          self.theme_:getImage("switchtogame/loading3.png"),
          self.theme_:getImage("switchtogame/loading4.png"),
          self.theme_:getImage("switchtogame/loading5.png"),
          self.theme_:getImage("switchtogame/loading6.png"),
          self.theme_:getImage("switchtogame/loading7.png"),
          self.theme_:getImage("switchtogame/loading8.png"),
          self.theme_:getImage("switchtogame/loading9.png"),
          self.theme_:getImage("switchtogame/loading10.png"),
        }
end

function PromotionWait:setContent()
    local md = self.viewController_:getMatchData()       
    if md then
        --积分    
        self:setScore(md.selfScore_)
        
        --排名
        local curRank = md.rank_             
        if curRank > md.leavePlayer_ then
           curRank = md.leavePlayer_
        end

        local bPromptScore = false
        local strPrompt = "您已率先完成本轮，请等候其他玩家打完后进行排名并决定晋级者"        
        --根据赛制，显示晋级规则
        local strRuler = nil
        if md.ruler_ == MatchRulerDefine.MATCH_RULE_CHAOS then -- 打立出局
            --全场排名
            self:setTotalRank(curRank, md.leavePlayer_)

            strRuler = string.format("%d人截止，%d人晋级", md.overCount_, md.winnerCount_)
            strPrompt = string.format("您率先完成打立阶段，请等待其他选手结束比赛，共有%d名选手晋级", md.winnerCount_)
            bPromptScore = true
        elseif md.ruler_ == MatchRulerDefine.MATCH_RULE_SWISS then --瑞士移位
            --全场排名
            self:setTotalRank(curRank, md.leavePlayer_)

            strRuler = md.promoteRuler_

            if md.roundInfo_ then
                if md.winnerCount_ > 0 then
                    strPrompt = string.format(" 您率先完成第%d轮瑞士移位（共%d轮）,共有%d名选手晋级，请等待其他选手结束比赛。",
                                            md.roundInfo_.boutId_, md.bountCount_, md.winnerCount_)
                else
                    strPrompt = string.format(" 您率先完成第%d轮瑞士移位（共%d轮）, 请等待其他选手结束比赛。",
                                            md.roundInfo_.boutId_, md.bountCount_)
                end
            end
            bPromptScore = true
        elseif md.ruler_ == MatchRulerDefine.MATCH_RULE_KICKOUT
             or md.ruler_ == MatchRulerDefine.MATCH_RULE_KICKOUT3
             or md.ruler_ == MatchRulerDefine.MATCH_RULE_KICKOUT3X2N then --定局积分
            --本桌排名
            self:setTableRank(md.tableRank_ )

            strRuler = md.promoteRuler_
            if md.tableRank_ == 1 then
                strPrompt = "恭喜您成功晋级，请耐心等待其他选手结束比赛后进入下一轮"
            elseif md.tableRank_ == 2 then  

                if md.roundInfo_ and md.roundInfo_.boutId_ > 0 then                    
                    if self.gameId == JJGameDefine.GAME_ID_LORD_PK then
                        strPrompt = string.format("您率先完成第%d轮定局积分，很遗憾，您被淘汰了，可退出比赛报名下一场",
                                                    md.roundInfo_.boutId_) 
                    else
                        strPrompt = string.format("您率先完成第%d轮定局积分，请等待其他选手结束比赛后确认是否晋级",
                                                md.roundInfo_.boutId_) 
                    end
                end
                bPromptScore = true                    
           elseif md.tableRank_ == 3 then
                strPrompt = "很遗憾，您被淘汰了，你可退出比赛报名下一场（不影响您本场比赛应得奖励）"
           end
        end

        self:setPromoteRuler(strRuler)
        self:setPrompt(strPrompt)
        
        if md.expectPromotionScore_ == 0 then
            self:setContentForNewStyle()
        elseif bPromptScore then
            --规则显示自己的分数高于晋级分数的1.3倍时,显示不同的信息            
            if md.selfScore_ >= md.expectPromotionScore_ * 1.3 then
                self:setPromotion_promt("您的得分较高，晋级机会很大，请耐心等待其他选手完成比赛。", md.expectPromotionScore_)
            else
                self:setPromotion_promt("您的得分一般，不过仍然有机会晋级哦，请耐心等待，祝您好运。", md.expectPromotionScore_)
            end
        end
   end
end

function PromotionWait:setContentForNewStyle()
    local md = self.viewController_:getMatchData() 
    if md then        
        local strPrompt = "您已率先完成本轮，请等候其他玩家打完后进行排名并决定晋级者"
        -- 根据赛制，显示晋级规则    
        if md.ruler_ == MatchRulerDefine.MATCH_RULE_CHAOS then --打立出局
            if md.rank_ <= md.winnerCount_ then
                strPrompt = "您的得分较高，晋级机会很大哦，请耐心等待其他选手完成比赛。"
            else 
                strPrompt = "您的得分一般，不过仍然有机会晋级哦，请耐心等待，祝您好运。"
            end
        elseif md.ruler_ == MatchRulerDefine.MATCH_RULE_KICKOUT
             or md.ruler_ == MatchRulerDefine.MATCH_RULE_KICKOUT3
             or md.ruler_ == MatchRulerDefine.MATCH_RULE_KICKOUT3X2N then --定局积分
            if md.tableRank_ == 1 then
                strPrompt = "恭喜您成功晋级，请耐心等待其他选手完成比赛后进行下一轮pk。"
            elseif md.tableRank_ == 2 then
                if self.gameId == JJGameDefine.GAME_ID_LORD_PK then
                    strPrompt = "很遗憾，您已被淘汰。建议您退出比赛（不影响发奖）或等待排名信息。"
                else
                    strPrompt = "您需和其他每桌第2名选手得分pk，决定您是否晋级，请耐心等待。"
                end
            elseif md.tableRank_ == 3 then
                strPrompt = "很遗憾，您已被淘汰。建议您退出比赛（不影响发奖）或等待排名信息。"
            end
        end
        self:setPromotion_promt(strPrompt, md.expectPromotionScore_)
    end
end

function PromotionWait:onClick(target)
    if target == self.btnMatchDesc then
        self.viewController_:showMatchDesDlg(true)        
    elseif target == self.btnNews then --头条
        local md = self.viewController_:getMatchData()
        if md then md.promotionWaitClickRoarFlag = true end        
        local RoarInterface = require("game.thirds.RoarInterface")
        RoarInterface:enteRoar(7)
    elseif target == self.btnRank then --排行榜        
        local RankInterface = require("game.thirds.RankInterface")
        RankInterface:enteRank(2)
    end
end

function PromotionWait:setPrompt(str)
    if self.promptContent and str then 
        self.promptContent:setText(str)
    end
end

function PromotionWait:setPromoteRuler(str)
    if self.ruler then 
        if str then 
            --self.ruler:setVisible(true)
            self.ruler:setText(str)
        else
            if self.leftTable and self.waitTime then 
                self.leftTable:setPositionY(self.ruler:getPositionY())
                self.waitTime:setPositionY(self.ruler:getPositionY())
            end
            self.ruler:setVisible(false)
        end
    end
end

function PromotionWait:setPromotion_promt(str, score)
    local bShowScore = false
    --产品要求，暂时隐藏掉
    --[[if self.promotionScore and score > 0 then
        bShowScore = true
        self.promotionScore:setVisible(true)
        self.promotionScore:setText(string.format("平均%d分晋级", score))
    end]]

   
    if self.promotionPrompt and str then 
        --老版本定局积分时不显示这个字符串
        if not self.waitMatchList then             
            local md = self.viewController_:getMatchData() 
            if md and (md.ruler_ == MatchRulerDefine.MATCH_RULE_KICKOUT
             or md.ruler_ == MatchRulerDefine.MATCH_RULE_KICKOUT3
             or md.ruler_ == MatchRulerDefine.MATCH_RULE_KICKOUT3X2N
             or md.ruler_ == MatchRulerDefine.MATCH_RULE_CHAOS) then --定局积分
                if not self.moveUp then
                    self.moveUp = true --只移动一次就可以了
                    self.promotionPrompt:setVisible(false)                    
                    local y = self.ruler:getPositionY() + self.dimens_:getDimens(30)
                    if self.ruler then self.ruler:setPositionY(y) end
                    y = self.leftTable:getPositionY() + self.dimens_:getDimens(30)
                    if self.leftTable then self.leftTable:setPositionY(y) end                    
                    if self.waitTime then self.waitTime:setPositionY(y) end
                end
            end
        else
            self.promotionPrompt:setVisible(true)
            self.promotionPrompt:setText(str)

            if not bShowScore and not self.moveUp and self.waitMatchList then
                self.moveUp = true --只移动一次就可以了
                self.promotionPrompt:setPositionY(self.promotionPrompt:getPositionY()+self.dimens_:getDimens(20))
            end
        end
    end
end

function PromotionWait:setScore(scoreStr)
    if self.score and scoreStr then 
       self.score:setText(scoreStr)
    end
end

function PromotionWait:setRank(myRank, total, title)
    if self.rankSelf and self.rankTotal then
        if myRank == -1 then
            self.rankTotal:setVisible(false)
            self.rankSelf:setText("获取中...")
        elseif myRank then
            self.rankSelf:setText(myRank)

            self.rankTotal:setVisible(true)  
            self.rankTotal:setPositionX(self.rankSelf:getPositionX() + self.rankSelf:getWidth())          
            self.rankTotal:setText("/" .. total)
        end
    end

    if self.rank then
        if myRank == -1 then
            self.rank:setText("获取中...")
        elseif myRank then      
            self.rank:setText(string.format("%d/%d", myRank, total))
        end
    end
end

function PromotionWait:setTableRank(myRank, total)
    total = total or 3
    if self.gameId == JJGameDefine.GAME_ID_LORD_PK then
       total = 2
    end
    if myRank then 
        if self.rankTitle then self.rankTitle:setText("本桌排名：") end
        self:setRank(myRank, total)
    end
end

function PromotionWait:setTotalRank(myRank, total)
    if myRank and total then
        if self.rankTitle then self.rankTitle:setText("全场排名：") end
        self:setRank(myRank, total)
    end
end

function PromotionWait:updateStageBontResult(nLeave, outCount)
    if not self.leftTableCount_ or nLeave < self.leftTableCount_ then --防止收到第二阶段信息 
        self.leftTableCount_ = nLeave
        if not self.leftTableFirst_ then self.leftTableFirst_ = nLeave+1 end

        if self.leftTable then
            self.leftTable:setVisible(true)        
            self.leftTable:setText(string.format("还有%d桌未完成比赛，", nLeave))
            if self.waitTime then
                self.waitTime:setPositionX(self.leftTable:getPositionX() + self.leftTable:getWidth())
            end
        end

        --[[if self.outNum then
            self.outNum:setText(tostring(outCount))
        end]]

        if self.leftTableNew then
            self.leftGrp:setVisible(true)
            self.leftTableNew:setText(tostring(nLeave))
            self.leftTimePrompt:setPositionX(self.leftTableNew:getPositionX() + self.leftTableNew:getWidth())
        end
    end
end


function PromotionWait:initPromotionData() 
     --home键进入后台再前台处理，必须在延时里面处理
    if self.viewController_:isShowMatchDesDlg() then 
        self.viewController_:showMatchDesDlg(self.viewController_.showMatchDesAward)
    end

    self:setWaitInfo()   
    local  md = self.viewController_:getMatchData()      
    if md then        
        md.promotionWaitClickRoarFlag = false --不能处理               
        --本地记录开始时间, -10,用于先显示一些进度        
        md.startShowPromotionTime_ = JJTimeUtil:getCurrentSecond() - 10  --开始时间(重要)

        self.remainTime = 0
        self.pastTime = JJTimeUtil:getCurrentSecond() - md.startShowPromotionTime_        
        self.finishPercent = md.finishPercent_
        self.percentMax = (md.promotionPercentMax_ > 0 and md.promotionPercentMax_)  or 80
        self.averageTime = md.averageTime_
        
        if self.averageTime > md:getCurrentStagePastTime() then            
            self.waitTimeStyle = WAITTIME_STYLE_1
        else            
            self.waitTimeStyle = WAITTIME_STYLE_2
        end
        --平均时长大于0,标明开启了此功能
        if self.percentMax > 0 then
           self:setWaitTimeInfo(self.finishPercent, self.percentMax)
        end
    end
end

function PromotionWait:setWaitInfo()
    local  md = self.viewController_:getMatchData()      
    if md then        
        self.finishPercent = md.finishPercent_

        if self.finishPercent > 100 then self.finishPercent = 100 end

        if self.finishPercent > 0 then --标明收到了 百分比信息
            if self.progress then self.progress:setValue(self.finishPercent) end

            if self.waitTimeStyle == WAITTIME_STYLE_2 and self.remainTime == 0 then
                --保证只进入一次
                --当平均等待时间大于/等于已开赛时间时：
                --剩余时间为：
                --1.服务器已告知当前进度： 您约等待"（已开赛时间/当前进度）-已开赛时间"
                --2.服务器未告知当前进度： 正在计算等待时间，请稍候

                local dif = md:getCurrentStagePastTime()*100/self.finishPercent - md:getCurrentStagePastTime()
                if dif <= 0 then dif = 1 end

                self.remainTime = math.modf(dif)
                self:displayRemainTime(dif, 1)
                scheduler.performWithDelayGlobal(handler(self, self.delayDisplayRemainTime), 0.1)
            end
        end
    end
end

function PromotionWait:delayDisplayRemainTime()
    self.remainTime = self.remainTime - 1
    if self.remainTime <= 0 then self.remainTime = 1 end

    --进行一次较正
    if self.finishPercent >= 90 and self.remainTime > 60 then
        self.remainTime = 60
    end

    self:displayRemainTime(self.remainTime, 1)

    if self.remainTime >= 1 then
        scheduler.performWithDelayGlobal(handler(self, self.delayDisplayRemainTime), 1)
    end
end

function PromotionWait:displayRemainTime(waitTime, flag)
    if not self.destoryed then 
        if self.waitTime then        
            if flag == 1 then
                self.waitTime:setVisible(true)            
                self.waitTime:setText(string.format("您约等待%s", JJTimeUtil:formatTimeString(waitTime)))
            elseif flag == 2 then
                self.waitTime:setVisible(true)
                self.waitTime:setText("请稍候...")
            else
                self.waitTime:setVisible(false)
            end
        end

        if self.leftTimePrompt then    
            if flag == 1 then
                self.leftTimePrompt:setText(string.format("桌，约等待%s", JJTimeUtil:formatTimeString(waitTime)))
            else
                self.leftTimePrompt:setText("桌，请稍候...")
            end
        end
    end
end

function PromotionWait:setWaitTimeInfo(finishPercent, percentMax)   
    local  md = self.viewController_:getMatchData()      
    if md then
        if not self.oldPhase then
            self.oldPhase = md.promotionStageBoutFlag_
        end

        local averageTime = md.averageTime_
        if self.waitTime then
            
            --如果阶段发生变化，说明是收到下一局数据， 则关闭等待时间显示
            if self.oldPhase == md.promotionStageBoutFlag_ then
                local dif = averageTime - md:getCurrentStagePastTime()

                --防止收到下一轮的时间，所以必须判断完成百分比
                --只执行一次                
                if dif >= 1 and finishPercent < 100 
                   and self.waitTimeStyle == WAITTIME_STYLE_1 and self.remainTime == 0 then                   
                   self.remainTime = math.modf(dif*1.5)
                   scheduler.performWithDelayGlobal(handler(self, self.delayDisplayRemainTime), 0.1)
                elseif self.waitTimeStyle == WAITTIME_STYLE_2 then                    
                    --当平均等待时间大于/等于已开赛时间时：
                    --剩余时间为：
                    --1.服务器已告知当前进度： 您约等待"（已开赛时间/当前进度）-已开赛时间"
                    --2.服务器未告知当前进度： 正在计算等待时间，请稍候
                    if finishPercent == 0 then
                        self:displayRemainTime(0, 2)
                    else
                        self:displayRemainTime(0, 0)
                    end
                end
            else
                self.waitTime:setVisible(false)
            end
        end

        if percentMax > 0 and self.progress then --标明开启了功能            
            if finishPercent > 0 then --说明已经来了消息， 以这个为准                
                self.progress:setValue(finishPercent)
            else --没来消息自己计算                
                scheduler.performWithDelayGlobal(handler(self, self.MOVE_RIGHT), 0.1)
            end
        end
    end
end

function PromotionWait:MOVE_RIGHT()
    local  md = self.viewController_:getMatchData()  
    --完成百分比没收到时才执行          
    if md and self.progress and self.finishPercent == 0 and self.percentMax > 0 and not self.destoryed then 
        self.pastTime =  JJTimeUtil:getCurrentSecond() - md.startShowPromotionTime_
        
        if self.pastTime > AVERAGE_WAIT_TIME then
            self.progress:setValue(self.percentMax)
        else
            --JJLog.i("linxh", "total=", self.leftTableFirst_, ", left=", self.leftTableCount_)
            if self.leftTableFirst_ and self.leftTableFirst_ >= 1 then
                local avg = (self.percentMax/self.leftTableFirst_)                 
                maxPercent = avg*(self.leftTableFirst_-self.leftTableCount_) + avg*self.pastTime/AVERAGE_WAIT_TIME
                --JJLog.i("linxh", "avg=", avg, ", max=", maxPercent)
            else
                maxPercent = self.percentMax*self.pastTime/AVERAGE_WAIT_TIME
            end 
            self.progress:setValue(maxPercent)
            scheduler.performWithDelayGlobal(handler(self, self.MOVE_RIGHT), 1)            
        end
    end
end

return PromotionWait