require("game.def.MatchViewDef")
MatchViewMsgController = {}

MATCHVIEW_UPDATE_ACK = 1
function MatchViewMsgController:handleMsg(msg)    
	-- body
    msg[MSG_CATEGORY] = MATCHVIEW_ACK_MSG
    --JJLog.i("linxh", vardump(msg, "MatchViewMsgController"))
    local ack = msg.matchview_ack_msg
    local matchData = StartedMatchManager:getMatch(ack.matchid)
    if #ack.matchupdateview_ack_msg ~= 0 then
        self:handleMatchupdateviewAck(msg, matchData)        
    elseif #ack.matchservicetime_ack_msg ~= 0 then
        self:handleMatchservicetimeAck(msg, matchData)
    end        
end

function MatchViewMsgController:handleMatchservicetimeAck(msg, matchData)
    if matchData then
        local ack = msg.matchview_ack_msg.matchservicetime_ack_msg
        matchData.matchServiceTimeOffset_ = ack.servicetime - JJTimeUtil:getCurrentSecond()
    end
end

function MatchViewMsgController:handleMatchupdateviewAck(msg, matchData)
    msg[MSG_TYPE] = MATCHVIEW_UPDATE_ACK
    local ack = msg.matchview_ack_msg.matchupdateview_ack_msg
    local attrs = ack.attributes

    if matchData and attrs then        
        local type = ack.infotype
        
        if type == MatchViewDef.INFO_TYPE_MATCH then
            self:handleTypeViewAck(attrs, matchData)
        elseif type == MatchViewDef.INFO_TYPE_PHASE then
            self:handlePhaseTypeViewAck(attrs, matchData)
        elseif type == MatchViewDef.INFO_TYPE_STAGE then
            self:handleStageTypeViewAck(attrs, matchData)
        elseif type == MatchViewDef.INFO_TYPE_BOUT then
            self:handleBoutTypeViewAck(attrs, matchData)
        elseif type == MatchViewDef.INFO_TYPE_ROUND then
            self:handleRoundTypeViewAck(attrs, matchData)
        elseif type == MatchViewDef.INFO_TYPE_TABLE then
            self:handleTableTypeViewAck(attrs, matchData)
        end
    end
end

function MatchViewMsgController:handleTypeViewAck(attrs, matchData)
    for i, attr in ipairs(attrs) do         
        if attr.attrtype == MatchViewDef.ATTR_TYPE_MATCH_PLAYER_COUNT then --比赛总人数
            matchData.totalMatchPlayer_ = attr.attrvalue
        elseif attr.attrtype == MatchViewDef.ATTR_TYPE_MATCH_POTCOUNT then --总奖池                        
            matchData.potCount_ = attr.attrvalue
        end
    end
end    

function MatchViewMsgController:handlePhaseTypeViewAck(attrs, matchData)
    for i, attr in ipairs(attrs) do 
        if attr.attrtype == MatchViewDef.ATTR_TYPE_PHASE_INDEX then --第几阶段
            matchData.phase_ = attr.attrvalue

            --对晋级数据进行初始化
            matchData.averageTime_ = 0
            matchData.finishPercent_ = 0
            matchData.promotionPercentMax_ = 0
            matchData:setCurrentStageStartTime(true) --记录阶段的开始时间

        elseif attr.attrtype == MatchViewDef.ATTR_TYPE_PHASE_NAME then --阶段名称                       
            matchData.phaseName_ = attr.attrstr
        end
    end
end    

function MatchViewMsgController:handleStageTypeViewAck(attrs, matchData)
    matchData.promotionStageBoutFlag_ = MatchViewDef.INFO_TYPE_STAGE
    for i, attr in ipairs(attrs) do         
        if attr.attrtype == MatchViewDef.ATTR_TYPE_STAGE_RULE then --赛制
            matchData.ruler_ = attr.attrvalue
        elseif attr.attrtype == MatchViewDef.ATTR_TYPE_STAGE_BOUT_COUNT then -- 总共几轮
            matchData.bountCount_ = attr.attrvalue
        elseif attr.attrtype == MatchViewDef.ATTR_TYPE_STAGE_WINNER_COUNT then --晋级人数
            matchData.winnerCount_ = attr.attrvalue
        elseif attr.attrtype == MatchViewDef.ATTR_TYPE_STAGE_OVER_WHEN_LEFT_UNIT_COUNT then --截止人数
            matchData.overCount_ = attr.attrvalue
        elseif attr.attrtype == MatchViewDef.ATTR_TYPE_STAGE_GAMECOUNT_AWARD_INFO then --岛屿盘数奖励信息：这个已经通过天降喜金实现了
            
        elseif attr.attrtype == MatchViewDef.ATTR_TYPE_STAGE_TASK_INFO then --岛屿任务信息

        elseif attr.attrtype == MatchViewDef.ATTR_TYPE_STAGE_BASE_RAISE_TIME then --涨盲时间点
            matchData.baseRaiseTime_ = attr.attrvalue
        elseif attr.attrtype == MatchViewDef.ATTR_TYPE_STAGE_RANK_TYPE then --1：排名；0：不排名,即1显示颁奖倒计时，0不显示
            matchData.rankType_ = attr.attrvalue

        --以下适用于晋级等待            
        elseif attr.attrtype == MatchViewDef.ATTR_TYPE_STAGE_PROMOTION_AVERAGE_TIME then --平均时长
            matchData.averageTime_ = attr.attrvalue            
        elseif attr.attrtype == MatchViewDef.ATTR_TYPE_STAGE_PROMOTION_FINISH_PERCENT then --完成百分比
            matchData.finishPercent_ = attr.attrvalue
        elseif attr.attrtype == MatchViewDef.ATTR_TYPE_STAGE_PROMOTION_SCORE then --预计晋级分数
            matchData.expectPromotionScore_ = attr.attrvalue
        elseif attr.attrtype == MatchViewDef.ATTR_TYPE_STAGE_PROMOTION_STAGE_COUNTDOWN_PECENT_MAX then --本阶段最大百分比
            matchData.promotionPercentMax_ = attr.attrvalue
        end
    end
end    

function MatchViewMsgController:handleBoutTypeViewAck(attrs, matchData)
    matchData.promotionStageBoutFlag_ = MatchViewDef.INFO_TYPE_BOUT

    for i, attr in ipairs(attrs) do 
        if attr.attrtype == MatchViewDef.ATTR_TYPE_BOUT_PROMOTE_RULE then --晋级规则
            matchData.promoteRuler_ = attr.attrstr
        elseif attr.attrtype == MatchViewDef.ATTR_TYPE_BOUT_PROMOTION_AVERAGE_TIME then --平均时长
            matchData.averageTime_ = attr.attrvalue
        elseif attr.attrtype == MatchViewDef.ATTR_TYPE_BOUT_PROMOTION_FINISH_PERCENT then --完成百分比
            matchData.finishPercent_ = attr.attrvalue
        elseif attr.attrtype == MatchViewDef.ATTR_TYPE_BOUT_PROMOTION_SCORE then --预计晋级分数
            matchData.expectPromotionScore_ = attr.attrvalue
        elseif attr.attrtype == MatchViewDef.ATTR_TYPE_STAGE_PROMOTION_BOUT_COUNTDOWN_PECENT_MAX then --本轮最大百分比                        
            matchData.promotionPercentMax_ = attr.attrvalue
        end
    end
end    

function MatchViewMsgController:handleRoundTypeViewAck(attrs, matchData)
    for i, attr in ipairs(attrs) do 
        if attr.attrtype == MatchViewDef.ATTR_TYPE_ROUND_GAME_COUNT then --每轮几局
            matchData.roundGameCount_ = attr.attrvalue
        elseif attr.attrtype == MatchViewDef.ATTR_TYPE_ROUND_OUT_SCORE then --低于多少淘汰
            matchData.roundOutScore_ = attr.attrvalue
        end
    end
end    

function MatchViewMsgController:handleTableTypeViewAck(attrs, matchData)    
end    
