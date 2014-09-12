local MatchData = class("MatchData")

function MatchData:ctor()
    self.started_ = false
    self.seat_ = 0
    self.userType_ = 0
    --before start
    self.tourneyId_ = 0
    self.productId_ = 0
    self.matchPoint_ = 0
    self.serverStartTime_ = 0
    -- started
    self.matchId_ = 0
    self.strTick_ = ""
    self.matchName_ = ""
    self.totalMatchPlayer_ = 0
    self.rank_ = 0  --我的位置
    self.tableRank_ = 0 -- 我的本桌排名
    self.leavePlayer_ = 0 --当前剩余总人数
    self.startTime_ = 0  -- real 开赛点
    self.matchServiceTimeOffset_ = 0
    self.selfScore_ = 0
    self.scoreBase_ = 0
    self.stageBoutTableNo_ = 0 -- 第几桌
    self.roundCount_ = 0       -- 第几圈
    self.potCount_ = 0         --奖池金额
    self.phase_ = 0            --第几阶段
    self.phaseName_ = ""       --阶段名称
    self.ruler_ = 0            --赛制
    self.bountCount_ = 0        --多少轮
    self.winnerCount_ = 0      --winner 人数
    self.overCount_ = 0        --结束人数
    self.baseRaiseTime_ = 0    --涨盲时间
    self.promoteRuler_ = ""    --晋级规则 
    self.roundGameCount_ = 0   --每轮几局
    self.roundOutScore_ = 0    --低于多少淘汰
    self.islandData_ = {}
    self.roundInfo_ = nil
    self.awardData_ = nil
    self.isMarkLockDown_ = false --是否显示继续同该玩家进行下一局
    self.isLock_ = false
    self.CVWin_ = 0
    --self.playerOrder_ = {} --整个排名
    self.gamePlayers_ = {} --比赛玩家排名
    self.tablePlayers_ = {} --同一桌玩家
    self.finishCount = 0 --完成局数
    self.isRefreshGamePlayer = false --是否刷新了 Stage 的排名顺序
    self.rankType_ = 1 -- 1：排名；0：不排名,即1显示颁奖倒计时，0不显示

    self.gameCountAwardInfo_ = nil --天降喜金规则
    self.cvAwardList_ = nil --连胜奖励信息

    self.mapStartTime_ = {}
    self.promotionStageBoutFlag_ = 0
    self.averageTime_ = 300
    self.finishPercent_ = 0
    self.promotionPercentMax_ = 80
    self.expectPromotionScore_ = 0 --预计晋级分数    

    self.reliveData_ = nil --复活条件

    self.isSupportChangeTable_ = false -- 是否支持换桌
end

function MatchData:addTablePlayer(player)
    if player then
    	local item = require("game.data.game.PlayerOrderInfo").new()                            
        item.userId_ = player.userid
        item.rank_ =player.seatorder
        item.nickName_ = player.nickname
        --item.out_ = player.outroundstate
        item.score_ = player.score
        item.deskMate_ = true            
        table.insert(self.tablePlayers_, item)
    end 
end

--[[设置自己桌三位用户的名次]]
function MatchData:setRoundPlayerOrder(matchPlayers)
    if matchPlayers then
        local curUser = nil
        local tablePlayers = {}
        for k, playerItem in pairs(matchPlayers) do
            local item = require("game.data.game.PlayerOrderInfo").new()
            item.userId_ = playerItem.userid
            item.rank_ =playerItem.placeorder
            item.nickName_ = playerItem.nickname
            item.out_ = (playerItem.outroundstate == 0)
            item.score_ = playerItem.score
            item.deskMate_ = true            

            if playerItem.userid == UserInfo.userId_ then
                curUser = item
                self.selfScore_ = playerItem.score
            else 
                table.insert(tablePlayers, item)
            end
        end

        table.sort(tablePlayers, function(a, b) return a.rank_ < b.rank_ end)
        if curUser ~= nil then                
            table.insert(tablePlayers, 1, curUser)
        end

        --去掉相同的        
        for i, player in ipairs(tablePlayers) do 
            for k, v in ipairs(self.gamePlayers_) do 
                if v.userId_ == player.userId_ then
                    player.rank_ = v.rank_
                    table.remove(self.gamePlayers_, k)
                    break
                end
            end
        end
        
        for i, player in ipairs(tablePlayers) do 
            table.insert(self.gamePlayers_, i, player)
        end        
    end
end


function MatchData:setMatchPlayers(playerList)
	if playerList then
		self.gamePlayers_ = {}
		local item 
		for k, player in ipairs(playerList) do
			if k > 80 then break end
			item = require("game.data.game.PlayerOrderInfo").new()
            item.userId_ = player.userid
            item.rank_ =player.placeorder
            item.nickName_ = player.nickname
            item.out_ = (player.outroundstate == 0)
            item.score_ = player.score
            item.deskMate_ = false
            table.insert(self.gamePlayers_, item)
		end
		table.sort(self.gamePlayers_, function(a,b) return a.rank_ < b.rank_ end)     
	end
end

function MatchData:setCurrentStageStartTime(flag)
    if flag and self.phase_ then
        self.mapStartTime_[self.phase_] = JJTimeUtil:getCurrentSecond() - self.matchServiceTimeOffset_
    end
end    

--获取阶段开始时间
function MatchData:getCurrentStagePastTime()
	local past = 0
	if self.phase_ and self.mapStartTime_[self.phase_] then
		past = JJTimeUtil:getCurrentSecond() - self.matchServiceTimeOffset_ - self.phase_
	end

	return past
end

return MatchData