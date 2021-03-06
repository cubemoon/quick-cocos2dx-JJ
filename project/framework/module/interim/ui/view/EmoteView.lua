local JJViewGroup = require("sdk.ui.JJViewGroup")
local EmoteView = class("EmoteView", JJViewGroup)
local InterimUtilDefine = require("interim.util.InterimUtilDefine")
local INTERIM_SOUND = InterimUtilDefine.INTERIM_SOUND

function EmoteView:ctor(parentView)
	EmoteView.super.ctor(self, parentView)
	self.parentView = parentView
    self.positionConfig = parentView.positionConfig
	self.dimens_ = parentView.dimens_
	self:initView()
end

function EmoteView:initView()

    function onButtonClicked(sender)
       -- JJLog.i("onButtonClicked")
        local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
        local playerInfo = gameData:getMyPlayerInfo()
       -- JJLog.i(playerInfo)
        if playerInfo == nil then
            return
        end
        JJLog.i("发送表情" .. sender.name - 1)
         MatchMsg:sendGameSimpleActionReq(INTERIM_MATCH_ID, UserInfo.userId_, 0, sender.name-1)
        -- for i,v in ipairs(gameData.allPlayerInfo) do
        --     JJLog.i("sending emote")
        --     MatchMsg:sendGameSimpleActionReq(INTERIM_MATCH_ID, UserInfo.userId_, v.tkInfo.userid, sender.name-1)
        -- end
        self.parentView:hideEmoteView()
    end

	local background = jj.ui.JJImage.new({
		 image = "img/interim/ui/emote_bg.png",
      })
    background:setAnchorPoint(ccp(0.5, 0.5))
    background:setPosition(0, 0)
    background:setScale(self.dimens_.scale_)
    self:addView(background)
   
    self:setAnchorPoint(ccp(0.5, 0.5))

    self.bgSize = CCSizeMake(background:getViewSize().width*self.dimens_.scale_,
    background:getViewSize().height*self.dimens_.scale_)
    
    local titleLabel = jj.ui.JJLabel.new({
    	fontSize = 30*self.dimens_.scale_,
        color = ccc3(252, 217, 97),
        text = "表 情",
    })
    titleLabel:setAnchorPoint(ccp(0.5,0.5))
    titleLabel:setPosition(self.dimens_:getDimens(-5), self.dimens_:getDimens(117))
    self:addView(titleLabel)

    self:setTouchEnable(true)

    for i=1,16 do
        local button = self:createButton(i)
        button.name = i
        button:setAnchorPoint(ccp(0.2,0.8))
        self:addView(button)
        button:setScale(self.dimens_.scale_)
        button:setPosition(self.positionConfig.emotePos[i])
        button:setOnClickListener(onButtonClicked)
    end
end

function EmoteView:onTouchBegan(x, y)
    if self:isTouchInside(x, y) == true and self.bTouchEnable_ then
        self:setTouchedIn(true)
        local pos = self:convertToNodeSpace(ccp(x, y))
        -- JJLog.i("x y " .. pos.x .. " " .. pos.y)
        if pos.x > 184*self.dimens_.scale_
         and pos.y > 104*self.dimens_.scale_ then
           self.parentView:hideEmoteView()
           SoundManager:playEffect(INTERIM_SOUND.BUTTON)
        
        end
        return true
    end
    return false
end

function EmoteView:createButton(buttonText)
    local frameName = "emote_" .. buttonText .. "_1.png";
    local frame = display.newSpriteFrame(frameName)
    local btn = jj.ui.JJButton.new({
        fontSize = 28,
        images = {
            normal = frame,   
        },
        color = ccc3(255, 255, 255),
        -- text = buttonText,
    })
    btn:setAnchorPoint(ccp(0.5, 0.5))
    return btn
end

return EmoteView
