--tourenyInfo 信息
local TourneyInfo = class("TourneyInfo")
local TAG = "TourneyInfo"
require("bit")

function TourneyInfo:ctor()
	-- matchconfig 相关内容
	self.matchconfig_ = nil
	self.gameId_ = 0 -- 如果matchconfig是空的，需要通过gameId参数得到game相关的tourneyinfo 	

	-- TourneyData
	self.tourneyId_ = 0
	self.productId_ = 0
	self.matchStartTime_ = 0
	self.matchStartType_ = 0
	self.tourneyState_ = 0

	-- SignupData
	self.signupData_ = nil

	-- MatchPoint
	self.matchpoint_ = nil

	-- PlayerAmount
	self.playingAmount_ = 0
	self.signupAmount_ = 0
	self.runAmount_ = 0

	self.signupedTime_ = 0 -- 已报名的比赛，设置开赛时间点
	self.status_ = nil -- 状态：可报名、正在报名、已报名、等待数据...
	self.entryFee_ = {} -- 报名费用，需要消耗的
	self.signupRequireItemList_ = nil -- 报名需要的条件，需要满足的

	self.minGoldCost_ = 0 --报名最小消耗金币数量
end

function TourneyInfo:getEntryFee()
	return self.entryFee_
end

function TourneyInfo:addEntryFee(item, index)
	if index ~= nil then
		table.insert(self.entryFee_, index, item)
	else
		table.insert(self.entryFee_, item)
	end
end

function TourneyInfo:clearEntryFee()
	for k in pairs(self.entryFee_) do
		self.entryFee_[k] = nil
	end
end

-- 获取下一个报名时间点
function TourneyInfo:getSignupTime()
	local time = 0
	if self.matchconfig_ and self.matchconfig_.matchType == tostring(MatchDefine.MATCH_TYPE_FIXED) then
		if self.matchpoint_ == nil then
			time = self.matchStartTime_
		else
			local cur = JJTimeUtil:getCurrentSecond()
			for k, item in pairs(self.matchpoint_) do
				if item.state == MatchDefine.TOURNEYSIGNUPING and item.matchpoint > cur then
					time = item.matchpoint
					break
				end
			end
		end
		JJLog.i(TAG, "getSignupTime, name=" .. self.matchconfig_.productName .. ", time=" .. time)
	end
	return time
end

-- 获取比赛的开始时间串：已报名的比赛，显示开赛时间点，未报名的比赛，显示最近的时间点
function TourneyInfo:getStartTimeString()
	local str = "散桌"
	if self.matchconfig_ and self.matchconfig_.matchType == tostring(MatchDefine.MATCH_TYPE_FIXED) then
		local tick = 0
		if self.signupedTime_ ~= 0 then
			tick = self.signupedTime_
		else
			tick = self:getSignupTime()
		end

		if tick == 0 then
			str = ""
		else
			str = JJTimeUtil:getTimeString(tick)
		end
	elseif self.matchconfig_ and self.matchconfig_.matchType == tostring(MatchDefine.MATCH_TYPE_TIMELY) then
		str = "满" .. tostring(self.matchconfig_.minPlayer) .. "人开赛"
	end
	return str
end

function TourneyInfo:isConsoleSwOpen(flag)
    local open = false
    local config = self.matchconfig_

    if(config) then
        local sw = tonum(config.consoleSW)
        local val = bit.band(sw, flag)
        open = val > 0
    end

    JJLog.i(TAG,"isConsoleSwOpen",sw,flag,open)
    return open
end

-- 获取当前比赛，是否是自由桌比赛
function TourneyInfo:isSelectTable()
    return self:isConsoleSwOpen(MatchDefine.CSW_SELECT_TABLE)
end

-- 获取比赛的人数: MatchPoint 的比赛，所有相加
function TourneyInfo:getPlayerAmount()
	local amount = 0
	if self.matchpoint_ ~= nil then
		for i, mp in pairs(self.matchpoint_) do
			amount = amount + mp.signupamount
		end
	else
		amount = math.max(self.playingAmount_, self.signupAmount_, self.runAmount_)	
	end
	return amount
end

function TourneyInfo:setSignupRequireItemList(arrlist)
	self.signupRequireItemList_ = arrlist
end

function TourneyInfo:getSignupRequireItemList()
	return self.signupRequireItemList_
end

-- 得到定点开赛开始时间
function TourneyInfo:getStartTimeEx()
	if self.matchconfig_ and self.matchconfig_.matchType == tostring(MatchDefine.MATCH_TYPE_FIXED) then
		if self.tourneyId_ > 0 then
			local mp = MatchPointManager:getLastMatchPoint(self.tourneyId_)
			local matchPoint = 0
			if mp ~= nil then
				if mp.matchpoint > 0 then
					matchPoint = mp.matchpoint
				end
			else
				matchPoint = self.matchStartTime_
			end
			return matchPoint
		end
	end
	return 0
end

return TourneyInfo
