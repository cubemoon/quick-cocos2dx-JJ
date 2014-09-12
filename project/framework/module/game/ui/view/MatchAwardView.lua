-- 奖励方案界面
local JJViewGroup = import("sdk.ui.JJViewGroup")
local MatchAwardView = class("MatchAwardView", JJViewGroup)
local AwardListAdapter = class("AwardListAdapter", import("sdk.ui.JJBaseAdapter"))
local AwardListCell = class("AwardListCell", import("sdk.ui.JJListCell"))
require("game.def.LordSingleMatchDefine")

function AwardListCell:ctor(params, customParam)
    AwardListCell.super.ctor(self)
    self.theme_ = params.theme
    self.dimens_ = params.dimens    
    self.width_ = params.width - self.dimens_:getDimens(60)
    self.height_ = self.dimens_:getDimens(35)
    self.customParam_ = customParam
    self:setViewSize(self.width_, self.height_)    
    local left, top = 0, 0
    local fontSize = self.dimens_:getDimens(self.customParam_.matchDesAwardTextFontSize)
    local fontColor = self.customParam_.matchDesAwardTextFontColor
    if params.position ~= nil and params.position ~= "" then
        local pos = "第"..params.position.."名"
        local posLabel = jj.ui.JJLabel.new({
            text = pos,
            singleLine = true,
            fontSize = fontSize,
            color = fontColor,
        })

        posLabel:setAnchorPoint(ccp(0, 1))
        top = self.dimens_:getDimens(30)
        posLabel:setPosition(0, top)
        self:addView(posLabel)
        left = self.dimens_:getDimens(160)
        if params.desc ~= nil then
            local desLabel = jj.ui.JJLabel.new({
                text = params.desc,
                fontSize = fontSize,
                color = fontColor,
                singleLine = true,
                viewSize = CCSize(self.width_ - self.dimens_:getDimens(165), fontSize+self.dimens_:getDimens(5))
            })
            desLabel:setAnchorPoint(ccp(0, 1))
            desLabel:setPosition(left, top)
            self:addView(desLabel)
        end
    else
        if params.desc ~= nil then
            local desLabel = jj.ui.JJLabel.new({
                text = params.desc,
                fontSize = fontSize,
                color = fontColor,
                viewSize = CCSize(self.width_,0),
            })
            desLabel:setAnchorPoint(ccp(0, 1))
            desLabel:setPosition(left, desLabel:getViewSize().height)
            self:setViewSize(self.width_, desLabel:getViewSize().height)
            self:addView(desLabel)
        end
    end

end

-- function AwardListCell:getHeight()
--     return self.height_
-- end

-- function AwardListCell:getWidth()
--     return self.width_
-- end

-- function AwardListCell:getSize()
--     return CCSizeMake(self.width_, self.height_)
-- end

function AwardListAdapter:ctor(params, customParam)
    AwardListAdapter.super.ctor(self)
    self.theme_ = params.theme
    self.dimens_ = params.dimens
    self.width_ = params.width
    self.isLordSingle_ = params.isLordSingle
    self.customParam_ = customParam
    if self.isLordSingle_ then
        if params.singleMatchData then
            local singleMatchData = params.singleMatchData
            local singleAwardList = {}
            if singleMatchData.awardinfo then
                for key, var in pairs(singleMatchData.awardinfo) do
                    if var then
                        local awardItem = {}
                        if singleMatchData.matchtype == LordSingleMatchDefine.MATCH_TYPE_DAOYUSAI then
                            if var.highrank == 9999999 then
                                awardItem.desc = string.format("第%d局以后，每局奖励%d铜板+%d经验", var.lowrank, var.copper, var.experience)
                            else
                                awardItem.desc = string.format("第%d-%d局，每局奖励%d铜板+%d经验", var.lowrank, var.highrank, var.copper, var.experience)
                            end

                        else
                            if var.highrank == var.lowrank then
                                awardItem.position = var.highrank
                            else
                                awardItem.position = string.format("%d-%d", var.highrank, var.lowrank)
                            end
                            awardItem.desc = string.format("%d铜板+%d经验", var.copper, var.experience)
                        end
                        table.insert(singleAwardList, awardItem)
                    end
                end
            end
            self.awardList_ = singleAwardList
        end
    else
        local tourneyInfo = params.tourneyInfo
        self.awardList_ = tourneyInfo.matchconfig_ and tourneyInfo.matchconfig_.awards
    end

end

function AwardListAdapter:getCount()
    if self.awardList_ ~= nil then
        return #self.awardList_
    else
        return 0
    end
end

function AwardListAdapter:getView(position)
    local item = self.awardList_[position]
    return AwardListCell.new({
        theme = self.theme_,
        dimens = self.dimens_,
        position = item.position,
        desc = item.desc,
        width = self.width_,
    }, self.customParam_)
end

function MatchAwardView:ctor(params, customParam)
    MatchAwardView.super.ctor(self)
    self.theme_ = params.theme
    self.dimens_ = params.dimens
    self.scene_ = params.scene
    self.tourneyInfo_ = params.tourneyInfo
    self.gameId_ = params.gameId
    self.isLordSingle_ = self.gameId_ == JJGameDefine.GAME_ID_LORD_SINGLE
    if self.isLordSingle_ then
        self.singleMatchData_ = params.singleMatchData
    end
    self.width_ = params.width
    self.height_ = params.height
    self:setViewSize(params.width, params.height)
    local getParams = function ()
    	if self.isLordSingle_ then
    		return { theme = self.theme_, dimens = self.dimens_, isLordSingle = self.isLordSingle_, singleMatchData = self.singleMatchData_, width = self.width_, height = self.height_, }
    	else
            return { theme = self.theme_, dimens = self.dimens_, isLordSingle = self.isLordSingle_, tourneyInfo = self.tourneyInfo_, width = self.width_, height = self.height_, }
    	end
    end
    local tableView = jj.ui.JJListView.new({
        viewSize = CCSize(self.width_-self.dimens_:getDimens(40), self.height_),
        adapter = AwardListAdapter.new(getParams(), customParam),
    })
    tableView:setAnchorPoint(ccp(0, 0))
    tableView:setPosition(self.dimens_:getDimens(20), 0)
    self:addView(tableView)
end

return MatchAwardView