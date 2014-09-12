-- 大厅消息
LobbyMsg = {}

require("game.pb.SendMsg")

local function _getTKMobileReq()
	local msg = {}
	return msg
end

local function _getLobbyReq()
	local msg = _getTKMobileReq()
	msg.lobby_req_msg = {}
	return msg
end

-- 第一条消息
function LobbyMsg:sendAnonymouseBrowseReq()
	local msg = _getLobbyReq()
	msg.lobby_req_msg.anonymous_req_msg = {}
	SendMsg:send(msg)
end

-- 免注册登录
function LobbyMsg:sendNoRegLoginReq(specCode, mac)
	local msg = _getLobbyReq()
	msg.lobby_req_msg.noreglogin_req_msg = {
		specialcode = specCode,
		macaddr = mac,
	}
	SendMsg:send(msg)
end

--帐号登陆消息
function LobbyMsg:sendGeneralLoginReq(userName, passWord, mac)
	local msg = _getLobbyReq()
	msg.lobby_req_msg.generallogin_req_msg = {
		generalloginname = userName,
		password = passWord,
		macaddr = mac
	}
	SendMsg:send(msg)
end

--登出消息
function LobbyMsg:sendLogoutReq(userId)
	local msg = _getLobbyReq()
	msg.lobby_req_msg.logout_req_msg = {
		userid = userId
	}
	SendMsg:send(msg)
end

--获取用户成就
function LobbyMsg:sendGetUserAllGrowReq(userId)
	local msg = _getLobbyReq()
	msg.lobby_req_msg.getuserallgrow_req_msg = {
		userid = userId
	}
	SendMsg:send(msg)
end

-- 获取成就：分域获取
function LobbyMsg:sendGetUserDomainGrowReq(userId, domainId, gameId)
	local msg = _getLobbyReq()
	msg.lobby_req_msg.getuserdomaingrow_req_msg = {
		userid = userId,
		domainid = domainId,
		gameid = gameId
	}
	SendMsg:send(msg)
end

-- 获取成就：单条
function LobbyMsg:sendGetSingleGrowReq(userId, growId)
	if userId and growId then
		local msg = _getLobbyReq()	
		msg.lobby_req_msg.getsinglegrow_req_msg = {
			userid = userId,
			growid = growId
		}
		SendMsg:send(msg)
	end
end

--获取用户物品
function LobbyMsg:sendGetUserAllWareReq(userId)
	local msg = _getLobbyReq()
	msg.lobby_req_msg.getuserallware_req_msg = {
		userid = userId
	}
	SendMsg:send(msg)
end

--获取用户帐户信息
function LobbyMsg:sendGetAccNumMoneyReq(userId, accNum, accType)
	local msg = _getLobbyReq()
	msg.lobby_req_msg.getaccnummoney_req_msg = {
		userid = userId,
		accnum = accNum,
		acctype = accType
	}
	SendMsg:send(msg)
end

--报名比赛
function LobbyMsg:sendTourneySignupExReq(userId, tourneyId, matchPoint, type, gameId)
	local msg = _getLobbyReq()
	msg.lobby_req_msg.tourneysignupex_req_msg = {
		userid = userId,
		tourneyid = tourneyId,
		matchpoint = matchPoint,
		signuptype = type,
		gameid = gameId
	}
	SendMsg:send(msg)
    JJAnalytics:addSignupTimes() --添加报名次数统计，报名次数加一
end

--退出未开始比赛
function LobbyMsg:sendTourneyUnsignupReq(userId, tourneyId, matchPoint)
	local msg = _getLobbyReq()
	msg.lobby_req_msg.tourneyunsignup_req_msg = {
		userid = userId, 
		tourneyid = tourneyId,
		matchpoint = matchPoint
	}
	SendMsg:send(msg)
end

--实名登录后获取之前报名的比赛
function LobbyMsg:sendGetUserInterfixTourneyListReq(userId)
	local msg = _getLobbyReq()
	msg.lobby_req_msg.getuserinterfixtourneylist_req_msg = {
		userid = userId
	}
	SendMsg:send(msg)
end

-- 修改用户昵称
function LobbyMsg:sendModifyNickNameReq(userId, nickName)
	local msg = _getLobbyReq()
	msg.lobby_req_msg.modifynickname_req_msg = {
		userid = userId,
		nicknamenew = nickName
	}
	SendMsg:send(msg)
end

-- 验证昵称 注册
function LobbyMsg:sendVerfyNickNameReq(nickName, iparam)
	local msg = _getLobbyReq()
	msg.lobby_req_msg.verifynickname_req_msg = {
		nickname = nickName,
		param = iparam
	}
	SendMsg:send(msg)
end

-- 验证用户名 注册
function LobbyMsg:sendVerifyLoginNameReq(loginName, iparam)
	local msg = _getLobbyReq()
	msg.lobby_req_msg.verifyloginname_req_msg = {
		loginname = loginName,
		param = iparam
	}
	SendMsg:send(msg)
end

-- 验证手机号 注册
function LobbyMsg:sendVerifyLoginNameExistReq(loginName, iparam,type)
	local msg = _getLobbyReq()
	msg.lobby_req_msg.verifyloginnameexist_req_msg = {
		loginname = loginName,
		param = iparam,
		acctype = type
	}
	SendMsg:send(msg)
end

-- 获取验证码 注册
function LobbyMsg:sendGetVerifyCodeReq()
	local msg = _getLobbyReq()
	msg.lobby_req_msg.getverifycode_req_msg = {}
	SendMsg:send(msg)
end

-- 注册请求
function LobbyMsg:sendRegisterReq(loginName, nickName, passWord, verifyCode, timeFound, iparam, mac)
	local msg = _getLobbyReq()
	msg.lobby_req_msg.register_req_msg = {
		loginname = loginName,
		nickname = nickName,
		password = passWord,
		verifycode = verifyCode,
		timefound = timeFound,
		param = iparam,
		macaddr = mac
	}
	SendMsg:send(msg)
end

--发送sms验证码
function LobbyMsg:sendURSSendRegSMSCodeReq(userId, phoneNum, smsChannel)
	local msg = _getLobbyReq()
	msg.lobby_req_msg.urssendregsmscode_req_msg = {
		userid = userId, 
		phonenumber = phoneNum,
		smschannel = smsChannel
	}
	SendMsg:send(msg)
end
	
--手机注册
function LobbyMsg:sendMobileRegisterReq(phoneNum, nickName, passWord, smsCode)
	local msg = _getLobbyReq()
	msg.lobby_req_msg.mobileregister_req_msg = {
		phonenumber = phoneNum,
		nickname = nickName,
		password = passWord,
		smslongcode = smsCode
	}
	SendMsg:send(msg)
end

--手机绑定
function LobbyMsg:SendNoRegBindMobileAccReq(phoneNum, nickName, passWord, smsCode,specialCode)
	JJLog.i("SendNoRegBindMobileAccReq")
		
	local msg = _getLobbyReq()
	msg.lobby_req_msg.noregbindmobileacc_req_msg = {
		specialcode = specialCode,
		mobile = phoneNum,
		password = passWord,
		nickname = nickName,
		smscode = smsCode,	
	}
	SendMsg:send(msg)
end

--个性注册绑定
function LobbyMsg:SendNoRegBindDefaultAccReq(username, nickName, passWord, verifyCode,specialCode,timeFound)
	JJLog.i("SendNoRegBindDefaultAccReq")
		
	local msg = _getLobbyReq()
	msg.lobby_req_msg.noregbinddefaultacc_req_msg = {
		specialcode = specialCode,
		loginname = username,
		password = passWord,
		nickname = nickName,
		verifycode = verifyCode,
		timefound = timeFound,
	}
	
	SendMsg:send(msg)
end

-- 获取 SSO
function LobbyMsg:sendGetSSO(userId)
	local msg = _getLobbyReq()
	msg.lobby_req_msg.gettickettempex_req_msg = {
		userid = userId,
		type = 2, -- URL 类型的 SSO
	}
	SendMsg:send(msg)
end

-- 设置积分
function LobbyMsg:sendModifyGrowReq(userId, growId, growValue)
	JJLog.i("sendModifyGrowReq")
	local msg = _getLobbyReq()
	msg.lobby_req_msg.modifygrow_req_msg = {
		userid = userId,
		growid = growId,
		growvalue = growValue,
	}
	
	SendMsg:send(msg)
end

return LobbyMsg