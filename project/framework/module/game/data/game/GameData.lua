local GameData = class("GameData")
local TAG = "GameData"
require("game.def.JJGameStateDefine")

function GameData:ctor(matchId,gameId)
	--playstate用于游戏界面切换
    JJLog.i(TAG,"GameData:ctor",matchId,gameId)
    self.playState_ = JJGameStateDefine.PLAY_STATE_WAIT 

    --比赛各个阶段状态空中，比如发牌，叫分等
    self.state_ = JJGameStateDefine.STATE_FIRST_WAIT 

    self.promotionView_ = false --是否有晋级等待界面
    self.promotion_ = false        --是否进入了晋级等待阶段  
    self.afterPromotion_ =false    --晋级等待阶段之后
    self.threePk_ = false            --是否进入了3人PK等待阶段
    self.relive_ = false           --是否进入了等待复活阶段
    self.register_ = false            --是否进入了等待注册阶段
    self.registerSuccess_ = false  --是否进入了注册成功阶段
    self.award_ = false          --是否进入了奖状等待阶段
    self.islandWait_ = false     --是否进入了岛屿赛等待阶段
    self.history_ = false        --是否断线恢复等待阶段
    self.addon_ = false          --是否Addon等待阶段
    self.firstRound_ = true      --首次开赛阶段

    self.addSelectOK_ = false    --Addon等待阶段选择以后
    self.couldGetStageBout_ = false  --是否可以获取剩余桌数：打立出局阶段没有
    self.gameId_ = gameId or 0    --游戏id
    self.matchId_ = matchId   -- matchid
    self.userId_ = -1   
    self.userType_ = -1
    self.selfSeat_ = -1     --自己座位号
    self.matchType_ = 0 --比赛类型
    self.gameName_ = "" --游戏名称
    self.ruleNote_ = "" --规则说明
    self.handTime_ = 0   --每手牌时间
    self.firstHandTime_ = 0 --第一次手牌的时间
    self.firstHand_ = true  --是否第一手牌
    self.strMsg = ""        --游戏公告
    self.currentOperaterSeat_ = -1 --当前操作者的座位号
    self.currentOperaterTime_ =0   --当前操作者起始时间
    self.actionTime_ = 0           --超时时间
    self.outPlayerAmount_ = 0      --本轮淘汰人数
    self.recoverByOverMsg_ = false
end

--初始化 Round 信息，在一轮开始前调用
function GameData:resetRound()
    self.handTime_ = 0
    self.firstHandTime_ = 0
    self.gameName_ = ""
    self.ruleNote_ = ""
    self.relive_ =  false
    self.addon_ = false
    self.addonSelectOK_ = false
end

function GameData:isLandMatch()
    return (self.matchType_ == MatchDefine.MATCH_TYPE_ISLAND)
end

function GameData:isInWaitState()
    return (self.playState_ == JJGameStateDefine.PLAY_STATE_WAIT)
end

function GameData:resetPlayerInfo()
end

--初始化游戏信息，在一盘游戏开始前调用
function GameData:resetGame()
    self.threePK_ = false
    self.firstHand_ = true
    self.currentOperaterSeat_ = -1
    self.currentOperaterTime_ = 0
    self.recoverByOverMsg_ = false
end

--是否进入了奖状等待阶段
function GameData:setAward(flag)
    --岛屿赛没有此状态
    if self.matchType_ ~= MatchDefine.MATCH_TYPE_ISLAND then
        self.award_ = flag
    end
end

function GameData:resetWaitState()
    self.registerSuccess_ = false
    self.register_ = false
    self.relive_ = false
    self.addon_ = false
    self.award_ = false
    self.promotion_ = false
    self.islandWait_ = false
    self.history_ = false
    self.firstRound_ = false
end

function GameData:isFirstRound()
    return self.firstRound_
end

function GameData:setFirstRoundFlag(flag)
    self.firstRound_ = flag
end

function GameData:getWaitState()
    local state = JJGameStateDefine.WAIT_STATE_ROUND

    --请保证证先判断是否注册成功， 再判断是否注册，否则无法执行到此case
    if self.history_ then
        state = JJGameStateDefine.WAIT_STATE_HISTORY
    elseif self.registerSuccess_ then 
        state = JJGameStateDefine.WAIT_STATE_REGISTER_SUCCESS
    elseif self.register_ then
        state = JJGameStateDefine.WAIT_STATE_REGISTER
    elseif self.relive_ then
        state = JJGameStateDefine.WAIT_STATE_RELIVE
    elseif self.addon_ then
        state = JJGameStateDefine.WAIT_STATE_ADDON_SELECT
    elseif self.threePk_ then
        state = JJGameStateDefine.WAIT_STATE_THREE_PK
    elseif self.award_ then
        state = JJGameStateDefine.WAIT_STATE_AWARD
    elseif self.promotion_ then
        state = JJGameStateDefine.WAIT_STATE_PROMOTION
    elseif self.islandWait_ then
        state = JJGameStateDefine.WAIT_STATE_ISLAND   
    elseif self.firstRound_ then
        state = JJGameStateDefine.WAIT_STATE_FIRST_ROUND         
    end
    return state
end

--某些游戏比赛中不进入wait界面判断处理，返回true不进入
function GameData:playNot2Wait()
    local enable = false

    --按照产品的需求，德州和赢三张晋级赛也不进入 PLAY_STATE_WAIT的MATCH_VIEW_ROUND_WAIT界面
    if (self.gameId_ == JJGameDefine.GAME_ID_THREE_CARD
            or self.gameId_ == JJGameDefine.GAME_ID_POKER) then
        enable = true
    end

    JJLog.i(TAG,"playNot2Wait",self.gameId_,enable)
    return enable
end

return GameData