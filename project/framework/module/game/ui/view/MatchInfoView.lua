-- 赛事详情界面
local JJViewGroup = import("sdk.ui.JJViewGroup")
local MatchInfoView = class("MatchInfoView", JJViewGroup)

function MatchInfoView:ctor(params, customParam)

    MatchInfoView.super.ctor(self)
    self.dimens_ = params.dimens
    self.theme_ = params.theme
    self.scene_ = params.scene
    self.tourneyInfo_ = params.tourneyInfo
    self.gameId_ = params.gameId
    self.customParam_ = customParam
    self.isLordSingle_ = self.gameId_ == JJGameDefine.GAME_ID_LORD_SINGLE
    if self.isLordSingle_ then
        self.singleMatchData_ = params.singleMatchData
    end
    self.width_ = params.width
    self.height_ = params.height
    self:setViewSize(params.width, params.height)

    self.scrollerView_ = jj.ui.JJScrollView.new({
        viewSize = CCSize(self.width_- self.dimens_:getDimens(50), self.height_),
        direction = jj.ui.JJScrollView.DIRECTION_VERTICAL,
    })
    self.scrollerView_:setAnchorPoint(ccp(0, 0))
    self.scrollerView_:setPosition(0+self.dimens_:getDimens(20), 0)
    self:addView(self.scrollerView_)

    local top = self.height_
    self.label_ = jj.ui.JJLabel.new({
        text = "赛事说明",
        fontSize = self.dimens_:getDimens(self.customParam_.matchDesInfoTextFontSize),
        color = self.customParam_.matchDesInfoTextFontColor,  
        viewSize = CCSize(self.width_ - self.dimens_:getDimens(80), 0),
    })

    self:refresh()
end

-- 更新赛事详情信息
function MatchInfoView:refresh()
    if self.isLordSingle_ then
        if self.singleMatchData_ then
            local matchFormat = ""
            if self.singleMatchData_.ruledescriptions then
                for key, var in pairs(self.singleMatchData_.ruledescriptions) do
                    if var and var.ruledescription then
                        matchFormat = matchFormat..var.ruledescription
                    end
                end
            end
            self.label_:setText(matchFormat)
        end
    else
        if self.tourneyInfo_ then
            if self.tourneyInfo_.matchconfig_ and self.tourneyInfo_.matchconfig_.matchFormat ~= nil then
                self.label_:setText(self.tourneyInfo_.matchconfig_.matchFormat)
            end
        end
    end
    self.scrollerView_:setContentView(self.label_)
end

return MatchInfoView