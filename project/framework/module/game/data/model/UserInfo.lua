UserInfo = {
	userId_ = 0,
	nickname_ = "",
	figureId_ = 0,
	gold_ = 0, -- 金币
	cert_ = 0,  -- 参赛积分
	totalScore_ = 0, -- 总经验值
	totalMasterScore_ = 0, -- 总大师分
	isBindMobile_ = false, -- 是否已经绑定手机
	grows_ = {},
	wares_ = {},
	gameData_ = {}, -- 和游戏相关的数据
	maxScore_ = 0, -- 最大经验值
}

local TAG = "UserInfo"

--[[
	score: 经验值
	masterScore: 大师分
	rank: 职业积分榜排名
	rankScore: 职业积分榜积分
	totalHand: 总局数
	winHand: 胜局数
	allInHand: 全下局数
	giveUpHand: 弃牌局数
]]

-- 是否已经登录，有效用户
function UserInfo:isLogin()
	JJLog.i(TAG, "isLogin, userId=", self.userId_)
	return self.userId_ ~= 0
end

function UserInfo:reset()
	JJLog.i(TAG, "reset")
	self.userId_ = 0
	self.nickname_ = ""
	self.figureId_ = 0
	self.figureIdBackup_ = nil
	self.gold_ = 0
	self.cert_ = 0
	self.totalScore_ = 0
	self.totalMasterScore_ = 0
	self.isBindMobile_ = false
	self.grows_ = {}
	self.wares_ = {}
	self.gameData_ = {}
	Util:registerLuaLogReportNickname("")
end

function UserInfo:addGrow(id, value)
	JJLog.i(TAG, "addGrow, id=", id, ", value=", value)

	-- 头像积分ID 83
	if id == 83 then
		if value > 1 then
			-- 设置了头像，处于审核状态
			if self.figureIdBackup_ == nil then
				-- 不存在临时头像，备份原始头像
				self.figureIdBackup_ = self.figureId_
					-- 删除临时头像
				HeadImgManager:delTmpImg(value)
			else
				-- 删除临时头像
				HeadImgManager:delTmpImg(self.figureId_)
			end
			-- 更新头像为临时ID
			self.figureId_ = value

		elseif value == 1 then
			-- 临时头像审核通过，更新正式头像
			if self.figureIdBackup_ ~= nil then
				self.figureIdBackup_ = nil
				-- 删除临时头像
				HeadImgManager:delTmpImg(self.figureId_)
				-- 删除头像
				HeadImgManager:delImg(self.figureId_)
			end
		else
			
			-- 临时头像审核不通过
			-- 删除临时头像
			HeadImgManager:delTmpImg(self.figureId_)
			-- 恢复正式头像
			if self.figureIdBackup_ ~= nil then
				self.figureId_ = self.figureIdBackup_
				self.figureIdBackup_ = nil
			end
		end

		-- 请求头像
		HeadImgManager:getImg(self.userId_, self.figureId_)

	elseif id == 7201 then

		if value == 1 then
			local JJGameUtil = require("game.util.JJGameUtil")
			JJGameUtil:changeToHall()
		elseif value == 0 then
			if CURRENT_PACKAGE_ID == JJGameDefine.GAME_ID_HALL and ORIGINAL_PACKAGE_ID ~= JJGameDefine.GAME_ID_HALL then
				LobbyMsg:sendModifyGrowReq(UserInfo.userId_, 7201, 1)
			end
		end
	end

	self.grows_[id] = value
end

function UserInfo:getGrowCount(id)
	if self.grows_[id] then
		return self.grows_[id]
	else
		return 0
	end
end

function UserInfo:addWare(id, type, count)
	JJLog.i("UserInfo", "addWare, id=" .. id .. ", count=" .. count)
	-- 如果是属性相同的，改变数量即可
	local wareItem = nil
	for i, item in ipairs(self.wares_) do
		if item.id_ == id and item.type_ == type then
			wareItem = item
			break
		end
	end

	if wareItem == nil then
		wareItem = {
			id_ = id,
			type_ = type,
			count_ = count
		}
		table.insert(self.wares_, wareItem)
	else
		wareItem.count_ = count
	end
end

function UserInfo:delWare(id, type)
	for i, wareItem in ipairs(self.wares_) do
		if wareItem.id_ == id and wareItem.type_ == type then
			table.remove(self.wares_, i)
		end
	end
end

function UserInfo:getWareCount(id)
	local count = 0
	for i, wareItem in ipairs(self.wares_) do
		if wareItem.id_ == id then
			count = wareItem.count_
			break;
		end
	end

	return count
end

function UserInfo:getQiuKaCount()
	return self:getWareCount(889)
end

function UserInfo:setMaxScore(score)
	if score > self.maxScore_ then
		self.maxScore_ = score
	end
end

function UserInfo:getMaxScore()
	return self.maxScore_
end

return UserInfo