local JJViewGroup = require("sdk.ui.JJViewGroup")
local MatchAwardView = class("MatchAwardView", JJViewGroup)

function MatchAwardView:ctor(parentView)
	MatchAwardView.super.ctor(self, parentView)
	self.parentView = parentView
    self.positionConfig = parentView.positionConfig
	self.dimens_ = parentView.dimens_
	self:initView()
end

function MatchAwardView:initView()

    function onButtonClicked(sender)
       
    end

	local background = jj.ui.JJImage.new({
		 image = "img/interim/ui/match_award.png",
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
        text = "比赛结果",
    })
    titleLabel:setAnchorPoint(ccp(0.5,0.5))
    titleLabel:setPosition(self.dimens_:getDimens(-5), self.dimens_:getDimens(117))
    self:addView(titleLabel)

    self.nameLabel = jj.ui.JJLabel.new({
        fontSize = 25*self.dimens_.scale_,
        color = ccc3(252, 217, 97),
        text = "亲爱的璐璐兔",
    })
    self.nameLabel:setAnchorPoint(ccp(0.0,0.5))
    self.nameLabel:setPosition(self.dimens_:getDimens(-230), self.dimens_:getDimens(75))
    self:addView(self.nameLabel)

    self.contentLabel = jj.ui.JJLabel.new({
        fontSize = 25*self.dimens_.scale_,
        color = ccc3(252, 217, 97),
        text = "你在【卡当新手锦标赛】中获得了第8名(8/10)！再接再厉。",
        singleLine=false,
    })
    self.contentLabel:setAnchorPoint(ccp(0.5,0.5))
    self.contentLabel:setPosition(self.dimens_:getDimens(-10), self.dimens_:getDimens(0))
    self:addView(self.contentLabel)
    self.contentLabel:setViewSize(self.dimens_:getDimens(400), self.dimens_:getDimens(300))

    self:setTouchEnable(true)

end

function MatchAwardView:onTouchBegan(x, y)
    if self:isTouchInside(x, y) == true and self.bTouchEnable_ then
        self:setTouchedIn(true)
        local pos = self:convertToNodeSpace(ccp(x, y))
        JJLog.i("x y " .. pos.x .. " " .. pos.y)
        if pos.x > 184*self.dimens_.scale_
         and pos.y > 104*self.dimens_.scale_ then
          -- self.parentView:hideMatchAward()
             self.parentView:exitGame()
        elseif pos.x > self.dimens_:getDimens(-84) and pos.x < self.dimens_:getDimens(73)
            and pos.y > self.dimens_:getDimens(-145) and pos.y < self.dimens_:getDimens(-83) then
            self.parentView:exitGame()
        end
        return true
    end
    return false
end

function MatchAwardView:setResult(matchAward)
    local nameText = "亲爱的" .. matchAward.nickName_
    self.nameLabel:setText(nameText)

    local contentText ="你在【" .. matchAward.matchName_ .. "】中获得了第" 
    .. matchAward.rank_ .. "名(" .. matchAward.rank_ .. "/" .. matchAward.totalPlayer_ .. ")！"

    local exText = "不要气馁，胜败乃兵家常事。"
    contentText = contentText .. exText    
    self.contentLabel:setText(contentText)

end

return MatchAwardView
