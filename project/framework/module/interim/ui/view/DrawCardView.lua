local JJViewGroup = require("sdk.ui.JJViewGroup")
local DrawCardView = class("DrawCardView", JJViewGroup)
local CardView = require("interim.ui.view.CardView")
local PortraitView = require("interim.ui.view.PortraitView")
local AnimationFactory = require("interim.util.AnimationFactory")
local CoinBet = require("interim.ui.view.CoinBet")
--local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local InterimUtilDefine = require("interim.util.InterimUtilDefine")
local INTERIM_OPPONENT_CARD_SCALE = InterimUtilDefine.INTERIM_OPPONENT_CARD_SCALE
local INTERIM_RESULT = InterimUtilDefine.INTERIM_RESULT 
local INTERIM_SOUND = InterimUtilDefine.INTERIM_SOUND


function DrawCardView:ctor(parentView)
	DrawCardView.super.ctor(self, parentView)
	self.parentView = parentView
	self.dimens_ = parentView.dimens_
    self.positionConfig = parentView.positionConfig
	self:initView()
end

function DrawCardView:initView()
    self.myself = false

    self:setTouchEnable(true)

	-- local background = jj.ui.JJImage.new({
	-- 	 image = "img/interim/smallbg.png",
 --      })
    
    local background = jj.ui.JJImage.new({
        image = "img/interim/ui/wabao_bg.jpg"
      })
    self:addView(background, -1)
    background:setAnchorPoint(ccp(0.5, 0.5))
    background:setPosition(self.dimens_:getDimens(0), self.dimens_:getDimens(0))
    background:setScale(self.dimens_.scale_)

    self.nickNameLabel = jj.ui.JJLabel.new({
        fontSize = 25*self.dimens_.scale_,
        color = ccc3(255, 252, 157),
        text = "北极星",
    })
    self.nickNameLabel:setAnchorPoint(ccp(1,0.5))
    self.nickNameLabel:setPosition( self.dimens_:getDimens(-10), self.dimens_:getDimens(120) )
    self:addView(self.nickNameLabel)
    
     self.progressBg = jj.ui.JJImage.new({
        image = "img/interim/ui/wabaozhong.png"
      })
    self:addView(self.progressBg)
    self.progressBg:setAnchorPoint(ccp(0.0, 0.5))
    self.progressBg:setPosition(self.dimens_:getDimens(10), self.dimens_:getDimens(120))
    self.progressBg:setScale(self.dimens_.scale_)


    local function onButtonClicked(sender)
        self.parentView:onDrawCardViewClicked(sender.name)
    end

    local btn = jj.ui.JJButton.new({
        images = {
            normal = "img/interim/common/blue_button02.png",   
            highlight = "img/interim/common/yellow_button02.png",
            scale9 = true
        },
        viewSize = CCSize(130, 50),
        fontSize = 28,
        color = ccc3(255, 255, 255),
        text = "关闭",
    })
    btn.name = "CloseDrawCard"
    btn:setAnchorPoint(ccp(0.5, 0.5))
    btn:setPosition(self.dimens_:getDimens(-330), -self.dimens_.top*0.45)
    self:addView(btn)
    btn:setOnClickListener(onButtonClicked)
    btn:setVisible(false)

    self:addCard()

    self.portraitFrame = jj.ui.JJImage.new({
        image = "img/interim/ui/portrait_frame.png"
      })
    self.portraitFrame:setAnchorPoint(ccp(0.5, 0.5))
    self.portraitFrame:setScale(self.dimens_.scale_)
    self:addView(self.portraitFrame)
    self.portraitFrame:setPosition(self.dimens_:getDimens(-150),
     self.dimens_:getDimens(-170))
    
    local portraitImage = "img/interim/common/player.png"
    self.portrait = PortraitView.new({
        image = portraitImage,
      })

    self.portrait:setAnchorPoint(ccp(0.5, 0.5))
    self.portrait:setPosition(self.dimens_:getDimens(-150), self.dimens_:getDimens(-160))
    self.portrait:setVisible(true)
    self.portrait:setScale(self.dimens_.scale_)
    
    self:addView(self.portrait)

    self.scoreLabel = jj.ui.JJLabel.new({
        fontSize = 20,
        color = ccc3(255, 255, 255),
        text = "score",
    })
    self.scoreLabel:setAnchorPoint(ccp(0.5, 0.5))
    self.scoreLabel:setPosition(self.dimens_:getDimens(-150),
        self.dimens_:getDimens(-207))
    self:addView(self.scoreLabel)


    self.pity = jj.ui.JJImage.new({
        image = "img/interim/animate/pity.png"
      })
    self.pity:setAnchorPoint(ccp(0.5, 0.5))
    self.pity:setScale(self.dimens_.scale_)
    self.pity:setVisible(false)
    self:addView(self.pity)

    self.fall = display.newSprite("#fall_1.png")
    self.fall:setScale(self.dimens_.scale_)
    self:getNode():addChild(self.fall)
    --self.fall:setPosition(self.dimens_.right/2, self.dimens_.top/2)
    self.fall:setVisible(false)

    self.cardSelected = nil

    self.resultLabel = jj.ui.JJLabel.new({
        fontSize = 35*self.dimens_.scale_,
        color = ccc3(0, 0, 0),
        text = "",
    })
    self.resultLabel:setAnchorPoint(ccp(0.5, 0.5))
    self.resultLabel:setPosition(0, self.dimens_:getDimens(180))
    self:addView(self.resultLabel)
    self.resultLabel:setVisible(false)

    self.alert = display.newSprite("img/interim/animate/red_fr/red_fr_1.png")
    self.alert:setScale(self.dimens_.scale_*0.7)
    self.alert:setPosition(self.portraitFrame:getPosition())
    self:getNode():addChild(self.alert)
    self.alert:setVisible(false)

    self.ALERT_STATUS_NONE = 0
    self.ALERT_STATUS_GREEN = 1
    self.ALERT_STATUS_RED = 2

    self.alertStatus = self.ALERT_STATUS_NONE 



    self.coinStartPos = ccp(0, self.dimens_:getDimens(255))

    self.coinWonArray = {}

    for i=1,5 do
        local coinWonView = CoinBet.new(self)
        self:addView(coinWonView)
        coinWonView:setVisible(false)

        self.coinWonArray[i] = coinWonView
    end

    self:addGoldCoin()

    self.foreground = jj.ui.JJImage.new({
         image = "img/interim/ui/win_back.png",
     --    image = "img/interim/ui/win_back_flash.png",
      })
    self.foreground:setAnchorPoint(ccp(0.5, 0.5))
    self.foreground:setPosition(0, 0)
    self.foreground:setScaleX(self.dimens_.wScale_)
    self.foreground:setScaleY(self.dimens_.hScale_)  
    self:addView(self.foreground)
    -- self.foreground:setPosition(self.dimens_.right/2,self.dimens_.top/2)
    
    self.foregroundFlash = display.newSprite("img/interim/ui/win_back_flash.png")
    self.foregroundFlash:setAnchorPoint(ccp(0.5, 0.5))
    self.foregroundFlash:setPosition(0, 0)
    self.foregroundFlash:setScaleX(self.dimens_.wScale_)
    self.foregroundFlash:setScaleY(self.dimens_.hScale_)  
    self:getNode():addChild(self.foregroundFlash)
    self.foregroundFlash:setVisible(false)

    self.lotteryFlash = display.newSprite("img/interim/ui/lottery_flash.png")
    self.lotteryFlash:setAnchorPoint(ccp(0.5, 1))
    self.lotteryFlash:setPosition(0, self.dimens_.top/2)
    self.lotteryFlash:setScale(self.dimens_.scale_)
    self:getNode():addChild(self.lotteryFlash)
    self.lotteryFlash:setVisible(true)

    self.AAAA = display.newSprite("img/interim/animate/AAAA.png")
    self.AAAA:setScale(self.dimens_.scale_*0.8)
    self:getNode():addChild(self.AAAA)
    self.AAAA:setVisible(false)

    self.JJJJ = display.newSprite("img/interim/animate/JJJJ.png")
    self.JJJJ:setScale(self.dimens_.scale_*0.8)
    self:getNode():addChild(self.JJJJ)
    self.JJJJ:setVisible(false)

    self.Fivesamestraight = display.newSprite("#THS_14.png")
    self.Fivesamestraight:setScale(self.dimens_.scale_*0.8)
    self:getNode():addChild(self.Fivesamestraight)
    self.Fivesamestraight:setVisible(false)

    self.AJFourSame = display.newSprite("#4T_1.png")
    self.AJFourSame:setScale(self.dimens_.scale_*0.8)
    self:getNode():addChild(self.AJFourSame)
    self.AJFourSame:setVisible(false)


    self.CourageAnim = display.newSprite("#GXZDJ_00001.png")
    self.CourageAnim:setScale(self.dimens_.scale_*0.8)
    self:getNode():addChild(self.CourageAnim)
    self.CourageAnim:setVisible(false)

    self.SmallPrize = display.newSprite("#YZXJZWYC_00001.png")
    self.SmallPrize:setScale(self.dimens_.scale_*0.8)
    self:getNode():addChild(self.SmallPrize)
    self.SmallPrize:setVisible(false)

    self.ComeOnAnim = display.newSprite("#JYZWYZ_00001.png")
    self.ComeOnAnim:setScale(self.dimens_.scale_*0.8)
    self:getNode():addChild(self.ComeOnAnim)
    self.ComeOnAnim:setVisible(false)

    self:refreshCardLayout(40)   --it is a Test
    -- self:startPlayGold()

    
    -- self:playBlinkAnimation(self.AAAA)
    -- local delay = CCDelayTime:create(0.5)
    -- self:runAction(delay)
    -- self:playCourageAnim()
    -- self:startPlayGold()

    -- self:playFivesamestraightAnim()
    -- self:startPlayGold()

    -- self:playAJFourSame()
    -- self:startPlayGold()

    --self:playSmallPrizeAnim()

    --self:playComeOnAnim()




end

function DrawCardView:playBlinkAnimation(target)
    target:setVisible(true)
    target:setPosition(self.dimens_:getDimens(0),self.dimens_:getDimens(0))

    local arr = CCArray:create()
    local fadein = CCFadeIn:create(0.5)
    arr:addObject(fadein)

    local delay = CCDelayTime:create(0.1)
    arr:addObject(delay)

    local fadeout = CCFadeOut:create(0.5)
    arr:addObject(fadeout)

    local onComplete  
    onComplete = function()
        print("Animation Complete")
    end 
    local callFunc = CCCallFunc:create(handler(self,onComplete))
    arr:addObject(callFunc)

    local sequence = CCSequence:create(arr)
    target:runAction(sequence) 
end

function DrawCardView:addGoldCoin()
    --local goldCoinBatchNode = display.newBatchNode("img/interim/ui/gold.png", 10)
    self.goldCoin = {}
    for i=1,200 do
        local coin = jj.ui.JJImage.new({
         image = "img/interim/ui/gold.png",
        })
        coin.isActive = false
        coin:setScale(self.dimens_.scale_)
        self.goldCoin[i] = coin
        self:addView(coin)
        coin:setVisible(false)
    end
end

function DrawCardView:resetGoldCoin()
    for i,v in ipairs(self.goldCoin) do
        v.isActive = false
        v:setVisible(false)
    end
    return nil
end

function DrawCardView:getNextInactiveGold()
    for i,v in ipairs(self.goldCoin) do
        if v.isActive == false then
            return v
        end
    end
    return nil
end

function DrawCardView:createRandomPos()
    local value = math.random()
    local width = self.dimens_.right*0.8
    local start = -width/2
    local pos = ccp(width * value + start, self.dimens_.top)
    return pos
end

function DrawCardView:startPlayGold()
    math.randomseed(os.time())
   
    self:resetGoldCoin()

    local array = CCArray:create()
    array:addObject(CCCallFunc:create(handler(self, self.playGold)))
    array:addObject(CCDelayTime:create(0.01))
    local seq = CCSequence:create(array)
    
    local repeatAction = CCRepeat:create(seq, 200)
    
    self:runAction(repeatAction)
end

function DrawCardView:endPlayGold(  )
    
end

function DrawCardView:playGold()
    local function playGoldFinish(coin)
        -- coin.isActive = false
        -- coin:setVisible(false)
    end

    local coin = self:getNextInactiveGold()
    if coin == nil then
        return
    end

    coin.isActive = true
    coin:setVisible(true)

    local array = CCArray:create()

    local startPos = self:createRandomPos()
    coin:setPosition(startPos)
    local targetPos = ccp(startPos.x , - self.dimens_.top/2)
    local moveTo = CCMoveTo:create(0.8, targetPos)

    array:addObject(moveTo)
    array:addObject(CCCallFuncN:create(handler(self, self.playGoldFinish)))
    local seq = CCSequence:create(array)
    coin:runAction(seq)
end

function DrawCardView:playGoldFinish(coin)
   coin.isActive = false
   coin:setVisible(false)
end

function DrawCardView:updateConGambAck(gameData)
    self:stopCountDown()

    self:selectCard(gameData.conGamb.card, gameData.conGamb.click)
    self.resultLabel:setVisible(true)
    if gameData.conGamb.enResult == INTERIM_RESULT.Foursamestraight then
        -- local str = "已中小奖,再挖一张"
        -- if gameData.conGamb.winCoin > 0 then
        --     str = str .. "奖励金额：" .. gameData.conGamb.winCoin
        -- end
        -- self.resultLabel:setText(str)
        self:playSmallPrizeAnim()
    elseif gameData.conGamb.enResult == INTERIM_RESULT.Sickstraight then
        -- local str = "加油，在挖一张"
        -- if gameData.conGamb.winCoin > 0 then
        --     str = str .. "奖励金额：" .. gameData.conGamb.winCoin
        -- end
        -- self.resultLabel:setText(str)
        self:playComeOnAnim()
    end

    local winCoin = gameData.conGamb.winCoin
    self:showWinnerCoin(winCoin)
    local everyWin = gameData.conGamb.everyWin
    local winerSeatIndex = gameData.conGamb.seat
    self:showEveryWin(everyWin, winerSeatIndex)

    self.secondDrawCount = gameData.conGamb.cardCount

    if gameData.conGamb.cardCount == 0 then
        return
    end

    local array = CCArray:create()
    array:addObject(CCDelayTime:create(1))
    array:addObject(CCCallFunc:create(handler(self, self.callSecondDraw)))
    local seq = CCSequence:create(array)
    self:runAction(seq) 
    
    array = CCArray:create()
    array:addObject(CCDelayTime:create(2))
    array:addObject(CCCallFunc:create(handler(self, self.hideResultLabel)))
    seq = CCSequence:create(array)
    self:runAction(seq) 

    self:showFlash()

    self:playCourageAnim()                         --还能继续挖宝时，播放鼓励加油动画

end

function DrawCardView:playSmallPrizeAnim() 
    self.SmallPrize:setVisible(true)
    self.SmallPrize:setPosition(self.dimens_:getDimens(0), self.dimens_:getDimens(120))

    local function onComplete()
        self.SmallPrize:setVisible(false)
    end

    local arr = CCArray:create()
    local animation = AnimationFactory:createSmallPrizeAnim()
    local animate = CCAnimate:create(animation)
    arr:addObject(animate)
    local delay = CCDelayTime:create(0.6)
    arr:addObject(delay)
    local callFunc = CCCallFunc:create(handler(self, onComplete))
    arr:addObject(callFunc)
    local sequence = CCSequence:create(arr)
    self.SmallPrize:runAction(sequence)

end

function DrawCardView:playComeOnAnim()
    self.ComeOnAnim:setVisible(true)
    self.ComeOnAnim:setPosition(self.dimens_:getDimens(0), self.dimens_:getDimens(0))

    local function onComplete()
        self.ComeOnAnim:setVisible(false)
    end

    local arr = CCArray:create()
    local animation = AnimationFactory:createComeOnAnim()
    local animate = CCAnimate:create(animation)
    arr:addObject(animate)
    local delay = CCDelayTime:create(0.6)
    arr:addObject(delay)
    local callFunc = CCCallFunc:create(handler(self, onComplete))
    arr:addObject(callFunc)
    local sequence = CCSequence:create(arr)
    self.ComeOnAnim:runAction(sequence)

end

function DrawCardView:playCourageAnim()     
    self.CourageAnim:setVisible(true)
    self.CourageAnim:setPosition(self.dimens_:getDimens(0), self.dimens_:getDimens(0))

    local function onComplete()
         self.CourageAnim:setVisible(false)
    end

    local arr = CCArray:create()
    local animation = AnimationFactory:createCourageAnim()
    local animate = CCAnimate:create(animation)
    arr:addObject(animate)
    local delay = CCDelayTime:create(0.6)
    arr:addObject(delay)
    local callFunc = CCCallFunc:create(handler(self, onComplete))
    arr:addObject(callFunc)
    local sequence = CCSequence:create(arr)
    self.CourageAnim:runAction(sequence)

end

function DrawCardView:showFlashBackground()
    local flashDuration = 0.8
    local array = CCArray:create()
    array:addObject(CCFadeIn:create(flashDuration))
    array:addObject(CCFadeOut:create(flashDuration))
    array:addObject(CCCallFunc:create(handler(self, self.hideFlash)))
    self.foregroundFlash:setVisible(true)
    self.foregroundFlash:setOpacity(0)
    local seq = CCSequence:create(array)
    self.foregroundFlash:runAction(seq)

    array = CCArray:create()
    array:addObject(CCFadeIn:create(flashDuration))
    array:addObject(CCFadeOut:create(flashDuration))
    self.lotteryFlash:setVisible(true)
    self.lotteryFlash:setOpacity(0)
    seq = CCSequence:create(array)
    self.lotteryFlash:runAction(seq)
end

function DrawCardView:showFlash()

    local flashDuration = 0.8

    local array = CCArray:create()
    array:addObject(CCFadeIn:create(flashDuration))
    array:addObject(CCFadeOut:create(flashDuration))
    array:addObject(CCCallFunc:create(handler(self, self.hideFlash)))
    self.foregroundFlash:setVisible(true)
    self.foregroundFlash:setOpacity(0)
    local seq = CCSequence:create(array)
    self.foregroundFlash:runAction(seq)

    array = CCArray:create()
    array:addObject(CCFadeIn:create(flashDuration))
    array:addObject(CCFadeOut:create(flashDuration))
    self.lotteryFlash:setVisible(true)
    self.lotteryFlash:setOpacity(0)
    seq = CCSequence:create(array)
    self.lotteryFlash:runAction(seq)

    --self:startPlayGold()
end

function DrawCardView:hideFlash()
    self.foregroundFlash:setVisible(true)
    self.foregroundFlash:setOpacity(255)
    self.lotteryFlash:setVisible(true)
    self.lotteryFlash:setOpacity(255)
end

function DrawCardView:showWinnerCoin(winCoin)
    if winCoin > 0 then
        local wonView = self.coinWonArray[1]
        wonView:setCoin(winCoin)
        wonView:setVisible(true)
        wonView:setPosition(self.coinStartPos)

        local targetPos = ccp(self.portrait:getPositionX(),
                self.portrait:getPositionY())

        local array = CCArray:create()
        array:addObject(CCMoveTo:create(1, targetPos))
        array:addObject(CCDelayTime:create(1))
        array:addObject(CCCallFunc:create(handler(wonView, wonView.hide)))
        local seq = CCSequence:create(array)
        wonView:runAction(seq)
    end
end

function DrawCardView:showEveryWin(everyWin, winerSeatIndex)
    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    JJLog.i("winerSeatIndex: " .. winerSeatIndex)
    if everyWin > 0 then
        SoundManager:playEffect(INTERIM_SOUND.ALLPRIZE)

        local takenSeats = self.parentView:getTakenSeats()
        for i,v in ipairs(takenSeats) do
            local seat = v
            local layoutIndex = seat.layoutIndex
            if seat.seatIndex ~= winerSeatIndex then
                
                JJLog.i("show money to layout : " .. layoutIndex)
               -- JJLog.i("show money to seat : " .. seat.seatIndex)
                local startPos = self.coinStartPos
                local targetPos = self.positionConfig.seatPositionTable[layoutIndex]
                local selfPos = ccp(self:getPositionX(), self:getPositionY())
                targetPos = ccp(targetPos.x - selfPos.x, targetPos.y - selfPos.y)
                
                local wonView = self.coinWonArray[layoutIndex]
                --if wonView then
                   
                wonView:setVisible(true)
                wonView:setPosition(startPos)
                wonView:setCoin(everyWin)

                local array = CCArray:create()
                array:addObject(CCMoveTo:create(1, targetPos))
                array:addObject(CCDelayTime:create(2))
                array:addObject(CCCallFunc:create(handler(wonView, wonView.hide)))
                local seq = CCSequence:create(array)
                wonView:runAction(seq)

            end
        end

    end
end

function DrawCardView:callSecondDraw()
    self:showExtend(self.secondDrawCount)
end

function DrawCardView:showExtend(cardCount)
    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    self.timer = tonumber(gameData.property.lotteryTime)
    self:startCountDown( self.timer )

    self.selected = false
    self.cardSelected = nil

    --self.resultLabel:setVisible(false)

    self:hideAllCard()
    self:refreshCardLayout(cardCount)

    self.pity:setVisible(false)
    self.fall:setVisible(false)

   -- self.handCard[5]:concealed()
   --self.handCard[5]:setVisible(true)
end

function DrawCardView:selectCard(cardID, click)
    JJLog.i("selectCard: " .. cardID .. " click : " .. click)
    if self.cardSelected == nil then
        self.cardSelected = self.cardCache[click]
        if self.cardSelected == nil then
            return
        end
        local pos = ccp(self.cardSelected:getPositionX(),
             self.cardSelected:getPositionY())
        pos.y = pos.y + self.dimens_:getDimens(30)
        self.cardSelected:setPosition(pos)

    end
    -- self.cardSelected:setCardID(cardID)
    -- self.cardSelected:expose()
    self.cardSelected:setVisible(false)

    local card, targetPos = self:getLastCard()
    
    card:setCardID(cardID)
    local cardPos = ccp(self.cardSelected:getPositionX(),self.cardSelected:getPositionY())
    card:setPosition(cardPos)
    card:setVisible(true)
    card:expose()

    local moveTo = CCMoveTo:create(1.3, targetPos)
    local easeAction = CCEaseExponentialOut:create(moveTo)
    card:runAction(easeAction)

    -- self:displayLastCard(cardID)

end

function DrawCardView:show(cardCount, handCard, playerInfo)

    --self:showFlashBackground()

    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    self.timer = tonumber(gameData.property.lotteryTime)
    self:startCountDown( self.timer )

    self.resultLabel:setVisible(false)

    self.selected = false
    self.cardSelected = nil

    self:hideAllCard()
    self:refreshCardLayout(cardCount)

    if playerInfo ~= nil then
        local userID = playerInfo.tkInfo.userid
        if userID ~= 0 then
            local path = HeadImgManager:getImg(userID, playerInfo.tkInfo.figureId)
            if path ~= nil then
                local texture = CCTextureCache:sharedTextureCache():addImage(path)
                self.portrait:setTexture(texture)
                self.portrait:setVisible(true)
            end
        end

        if userID == UserInfo.userId_ then
            self.myself = true
            local labelText = "您在挖宝中"
            self.nickNameLabel:setText(labelText)
        else
            self.myself = false
            local labelText = playerInfo.tkInfo.nickname
            self.nickNameLabel:setText(labelText)
        end

        self.scoreLabel:setText(tostring(playerInfo.tkInfo.score))
    else
        self.myself = false
        self.nickNameLabel:setText("")
    end

    if handCard ~= nil then
        for i=1,3 do
            self.handCard[i]:setVisible(true)
            self.handCard[i]:setCardID(handCard[i])
            self.handCard[i]:expose()
        end
    end

    self.pity:setVisible(false)
    self.fall:setVisible(false)

    self.handCard[4]:concealed()
    self.handCard[4]:setVisible(false)
    self.handCard[5]:setVisible(false)

end

function DrawCardView:hideResultLabel()
    self.resultLabel:setVisible(false)
end

function DrawCardView:onTouchBegan(x, y)
    if self:isTouchInside(x, y) == true and self.bTouchEnable_ then
        self:setTouchedIn(true)
        return true
    end
    return false
end

function DrawCardView:onTouchMoved(x, y)
    if self.myself ~= true then
        return
    end

    local pos = self:convertToNodeSpace(ccp(x, y))
    local cardSize = CCSize(self.dimens_:getDimens(62), self.dimens_:getDimens(81))
  --  JJLog.i(pos.x .. " ".. pos.y)

    local touchedCard = false
    for i=54,1,-1 do
        local card = self.cardCache[i]
        if card:isVisible() == true then

            local rect = {}
            rect.x = card:getPositionX() - cardSize.width/2
            rect.y = card:getPositionY() - cardSize.height/2
            
        --    JJLog.i("rect: " .. rect.x .. " " .. rect.y)
        --    JJLog.i("size: " .. rect.x + cardSize.width .. " " .. rect.y + cardSize.height)

            if pos.x > rect.x and pos.x < rect.x + cardSize.width
                and pos.y > rect.y and pos.y < rect.y + cardSize.height then
                self:touchOnCard(card)
                touchedCard = true
                break
            end

        end
    end

    if touchedCard == false then
        self:touchOnCard(nil)
    end
end

function DrawCardView:onTouchEnded( x, y )
    if self.cardSelected ~= nil then
        local card = self.cardSelected
        self:stopCountDown()
        local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
        local playerInfo = gameData:getMyPlayerInfo()
        InterimMsg:sendGambReqMsg(INTERIM_MATCH_ID, card.tag - 1, playerInfo.tkInfo.seat)
        
    end
end

function DrawCardView:addCard()
    self.cardCache = {}
    for i=1,54 do
        self.cardCache[i] = CardView.new()
        self:addView(self.cardCache[i])
        self.cardCache[i]:setScale(self.dimens_.scale_)
        self.cardCache[i].tag = i
        self.cardCache[i]:setVisible(false)
        self.cardCache[i]:setTouchEnable(false)
        self.cardCache[i].delegate = self

    end

    self.handCard = {}
    for i=1,5 do
        self.handCard[i] = CardView.new()
        self:addView(self.handCard[i])
        self.handCard[i]:setScale(self.dimens_.scale_)
        --self.handCard[i]:setVisible(false)
    end

    local yPos = self.dimens_:getDimens(-160)
    local xPos = self.dimens_:getDimens(65)
    self.handCard[1]:setPosition(-xPos, yPos)
    self.handCard[2]:setPosition(0, yPos)
    self.handCard[3]:setPosition(xPos, yPos)
    self.handCard[4]:setPosition(xPos*2, yPos)
    self.handCard[5]:setPosition(xPos*3, yPos)
end

function DrawCardView:hideAllCard()
    for i=1,54 do
        self.cardCache[i]:concealed()
        self.cardCache[i]:setVisible(false)
    end
end

function DrawCardView:refreshCardLayout(cardCount)
    local cardOfRow = (cardCount/2)
    cardOfRow = cardOfRow - cardOfRow%1
    for i=1,cardCount do
        self.cardCache[i]:setVisible(true)
        if i <= cardOfRow then
            local yPos = self.dimens_:getDimens(50)
            local space = self.dimens_:getDimens(33)
            local startPos = ccp(-(cardOfRow/2)*space, yPos)
            local index = i
            local pos = ccp(startPos.x + i*space, yPos)
            self.cardCache[i]:setPosition(pos)
            self.cardCache[i]:setOriginPos(pos.x, pos.y)
        else
            local yPos = self.dimens_:getDimens(-50)
        
            local cardOfSecondRow = cardCount - cardOfRow
            local space = self.dimens_:getDimens(30)
            local startPos = ccp(-(cardOfSecondRow/2)*space, yPos)
            local index = i - cardOfRow
            local pos = ccp(startPos.x + index*space, yPos)
            self.cardCache[i]:setPosition(pos)
            self.cardCache[i]:setOriginPos(pos.x, pos.y)
        end
    end
end

function DrawCardView:onPortraitClicked(view)
end

function DrawCardView:touchOnCard(card)

    if self.cardSelected ~= nil then
        self:touchOffCard(self.cardSelected)
    end
    self.cardSelected = card

    if card ~= nil then 
        local pos = ccp(card.originPos.x, card.originPos.y)
        pos.y = pos.y + self.dimens_:getDimens(30)
        card:setPosition(pos)
    end
end

function DrawCardView:touchOffCard(card)
    card:setPosition(card.originPos)
end

function DrawCardView:onCardTouched(view)
    if self.myself ~= true then
        return
    end

    self.cardSelected = view
    local pos = ccp(view:getPositionX(), view:getPositionY())
    pos.y = pos.y + self.dimens_:getDimens(30)
    view:setPosition(pos)
    if self.selected == false then
        local pos = ccp(view:getPositionX(), view:getPositionY())
        pos.y = pos.y + self.dimens_:getDimens(30)
        view:setPosition(pos)
        self.selected = true
        self.cardSelected = view
        self:stopCountDown()
        local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
        local playerInfo = gameData:getMyPlayerInfo()
        InterimMsg:sendGambReqMsg(INTERIM_MATCH_ID, view.tag - 1, playerInfo.tkInfo.seat)
        
   end
end

function DrawCardView:onCardMoved(view)
    
end

function DrawCardView:onCardMoveEnded(view)
    
    view:setPosition(view.originPos)
    
end

function DrawCardView:getLastCard()
    if self.handCard[4]:isVisible() == false then
        return self.handCard[4], self.positionConfig.handCard[4]
    else
        return self.handCard[5], self.positionConfig.handCard[5]
    end
end

function DrawCardView:displayLastCard(cardID)
    if self.handCard[5]:isVisible() == true then
        self.handCard[5]:setCardID(cardID)
        self.handCard[5]:expose()
    elseif self.handCard[4]:isVisible() == true then
        self.handCard[4]:setCardID(cardID)
        self.handCard[4]:expose()
    end
end

--博彩环节结束 自己赢得彩金
function DrawCardView:winCard(data)
    local result = data.gambData.enResult
    local winCoin = data.gambData.winCoin

   -- self.handCard[5]:setVisible(true)

   self:showFlash()

    self.resultLabel:setVisible(true)
    if result == INTERIM_RESULT.Fivesamestraight or result == INTERIM_RESULT.Skysamestraight then
        self.resultLabel:setText("五张同花顺！")    --普通同花顺
        SoundManager:playEffect(INTERIM_SOUND.GAMBSTRAIGHT)
        self:playFivesamestraightAnim()
        self:startPlayGold()
  
    elseif result == INTERIM_RESULT.AJFoursame then
        self.resultLabel:setText("AJ四条！")        --四个A或者四个J
        SoundManager:playEffect(INTERIM_SOUND.GAMB4SAME)
       
       local cardNum = math.mod(self.handCard[1]:getCardID(), 13)
       if cardNum == 1 then
            self:playBlinkAnimation(self.AAAA)
       else
            self:playBlinkAnimation(self.JJJJ)
       end
        local delay = CCDelayTime:create(0.5)
        self:runAction(delay)
        self:playCourageAnim()
        self:startPlayGold()
      
    elseif result == INTERIM_RESULT.Foursame  then
        self.resultLabel:setText("普通四条！")        
        SoundManager:playEffect(INTERIM_SOUND.GAMB4SAME)
        self:playAJFourSame()
        self:startPlayGold()
    end

    local array = CCArray:create()
    array:addObject(CCDelayTime:create(3))
    array:addObject(CCCallFunc:create(handler(self, self.hide)))
    local seq = CCSequence:create(array)
    self:runAction(seq) 

    self:showWinnerCoin(winCoin)
    local everyWin = data.gambData.everyWin
    local winerSeatIndex = data.gambData.seat
    self:showEveryWin(everyWin, winerSeatIndex)

end

function DrawCardView:playFivesamestraightAnim()  --普通同花顺
    self.Fivesamestraight:setVisible(true)
    self.Fivesamestraight:setPosition(self.dimens_:getDimens(0), self.dimens_:getDimens(0))


    local function onComplete()
        self.Fivesamestraight:setVisible(false)
    end

    local arr = CCArray:create()
    local animation = AnimationFactory:createFivesamestraight()
    local animate = CCAnimate:create(animation)
    arr:addObject(animate)
    local delay = CCDelayTime:create(1)
    arr:addObject(delay)
    local callFunc = CCCallFunc:create(handler(self, onComplete))
    arr:addObject(callFunc)
    local sequence = CCSequence:create(arr)
    self.Fivesamestraight:runAction(sequence)

end

function DrawCardView:playAJFourSame()          
    self.AJFourSame:setVisible(true)
    self.AJFourSame:setPosition(self.dimens_:getDimens(0), self.dimens_:getDimens(0))

    local function onComplete()
        self.AJFourSame:setVisible(false)
    end

    local arr = CCArray:create()
    local animation = AnimationFactory:createFourSame()
    local animate = CCAnimate:create(animation)
    arr:addObject(animate)
    local delay = CCDelayTime:create(1)
    arr:addObject(delay)
    local callFunc = CCCallFunc:create(handler(self, onComplete))
    arr:addObject(callFunc)
    local sequence = CCSequence:create(arr)
    self.AJFourSame:runAction(sequence)

end

function DrawCardView:missCard()
   
    local function onComplete()
        JJLog.i("play animation finished")

        local array = CCArray:create()
        array:addObject(CCDelayTime:create(1))
        array:addObject(CCCallFunc:create(handler(self, self.hide)))
        local seq = CCSequence:create(array)
        self:runAction(seq) 
    end

    self.pity:setVisible(true)
    self.fall:setVisible(true)

    local animation = AnimationFactory:createFallLeaves()
  
    self.fall:playAnimationOnce(animation, false, onComplete)
    SoundManager:playEffect(INTERIM_SOUND.PASS)
    
end

function DrawCardView:hide()
    self.parentView:hideDrawCardView()
    self.resultLabel:setVisible(false)

end

function DrawCardView:startCountDown(count)
    JJLog.i(TAG, "startCountDown count=", count)
    self.red = 0
    self.green = 255
    self.blue = 0
    self.percentage = 100
    
    --如果定时器没有停止，那么停止后重新开启定时
    if self.countDown_ ~= nil then     
        self:stopCountDown()
    end
    --self:destoryBreakNetState()

    if self.countDown_ == nil then
        local image = "img/interim/ui/count_down_bg.png"
        local to = CCProgressFromTo:create(count, 100, 0)
        self.countDownSprite = CCSprite:create(image)

        self.countDownSprite:setColor(ccc3(self.red, self.green, self.blue))

        self.countDown_ = CCProgressTimer:create(self.countDownSprite)
        self.countDown_:setType(kCCProgressTimerTypeRadial)
        self.countDown_:setAnchorPoint(ccp(0.5, 0.5))
        self.countDown_:setPosition(ccp(self.dimens_:getDimens(-150), self.dimens_:getDimens(-170)))
        self.countDown_:setScale(self.dimens_.scale_)
        self.countDown_:setReverseDirection(true)
        -- self.countDown_:setPercentage(self.percentage)
        self.countDown_:runAction(to)
        self.countDown_:setTag(110)
        self:getNode():addChild(self.countDown_)
    end

    local updateTime = count / self.percentage
    JJLog.i(TAG, "updateTime is ", updateTime)
    JJLog.i(TAG, "self.countDown_ is ", self.countDown_)
    self.countDownScheduleHandler_ = self:schedule(function()
        self:updateCountdown()
    end, updateTime)

    local delaytime = CCDelayTime:create(count)
    local callBack = CCCallFunc:create(handler(self, self.countDownTimeOut))
    local aryAction = CCArray:create()
    aryAction:addObject(delaytime)
    aryAction:addObject(callBack)
    local actions = CCSequence:create(aryAction)
    self:runAction(actions)
end

function DrawCardView:getRed()
    --self.red = self.red + (100 - self.percentage) * (255 - self.red) / 2000
end

function DrawCardView:getGreen()
    --self.green = self.green - (100 - self.percentage) * (self.green) / 2000
end

function DrawCardView:getBlue()
end

function DrawCardView:updateColor()
    self:getRed()
    self:getGreen()
    self:getBlue()
end

function DrawCardView:updateCountdown()
    if self.countDown_ then
        self.percentage = self.countDown_:getPercentage()
        JJLog.i("updateCountdown:percentage:**__ " .. self.percentage)
        if self.percentage <= 0 then
            self.percentage = 0
        else
            self:updateColor()
            self.countDownSprite:setColor(ccc3(self.red, self.green, self.blue))
        end
    end
end

function DrawCardView:countDownTimeOut()
    -- body
    if self.countDown_ ~= nil then
        self:stopCountDown()
    end
end

function DrawCardView:stopCountDown()
    if self.countDown_ then
        local countDown = self:getNode():getChildByTag(110)
        if countDown ~= nil then
            self:getNode():removeChild(countDown, false)
        end

        self:stopAllActions()
    end
    self.countDown_ = nil

    if self.countDownScheduleHandler_ then
        self:unschedule(self.countDownScheduleHandler_)
    end
end

function DrawCardView:alertPlayAnimation()
    self.alert:setVisible(true)
    
    local function onComplete()
        self:alertPlayAnimation()
    end

    if self.timer <= 0 then
        return
    end

    local animation
    if self.timer/self.callTime < 0.5 then
        animation = AnimationFactory:createRedFrame()
        self.alertStatus = self.ALERT_STATUS_RED
    else
        animation = AnimationFactory:createGreenFrame()
        self.alertStatus = self.ALERT_STATUS_GREEN
    end
  
    self.alert:playAnimationOnce(animation, false, onComplete)

end

return DrawCardView
