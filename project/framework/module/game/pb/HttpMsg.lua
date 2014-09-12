-- Http 消息
HttpMsg = {}
local TAG = "HttpMsg"

require("game.pb.SendMsg")
require("game.data.config.DynamicDisplayManager")

local msgId_ = JJTimeUtil:getCurrentSecond()
-- 用于判断该消息是那一条
local commonHttpMsg_ = {} -- Key: msgid, Value: type

local function _getTKMobileReq()
	local msg = {}
	return msg
end

local function _getHttpReq()
	local msg = _getTKMobileReq()
	msg.http_req_msg = {}
	return msg
end

local function _getMsgId()
	msgId_ = msgId_ + 1
	return msgId_
end

local function _saveType(msgId, type)
	commonHttpMsg_[tostring(msgId)] = type
end

--[[
	用于处理消息时，判断这条消息是通用协议中的哪一条
]]
function HttpMsg:getType(msgId)
	return commonHttpMsg_[tostring(msgId)]
end

--[[
	发送通用协议消息
	@txt: 消息内容
	@gameId
	@class
	@method
	@msgId
	@msgType
	@lua: 是否走lua接口（服务器端）
]]

local REQTYPE_PHP = 0
local REQTYPE_LUA = 1
function HttpMsg:sendCommonHttpReq(txt, gameId, class, method, msgId, msgType, lua, luaPhpType)
	JJLog.i(TAG, "sendCommonHttpReq, txt=", txt, ", gameId=", gameId, ", class=", class, ", method=", method, ", msgId=", msgId, ", msgType=", msgType)
	local msg = _getHttpReq()
	local serverType = "json"
    local reqtype = REQTYPE_LUA
    local supportZip = false

    if (luaPhpType) then
        reqtype = luaPhpType
    end

	if lua then
		serverType = "lua"
	end

    if reqtype == REQTYPE_PHP and serverType == "json" and type(JJZipUtil) ~= "nil" then
        supportZip = true
    end

	msg.http_req_msg.commonhttp_req_msg = {
		type = serverType,
		argv = txt,
		gameid = gameId,
        reqtype = reqtype,
        isSupportZip = supportZip,
	}
	SendMsg:send(msg)
	_saveType(msgId, msgType)
end

-- 头像
function HttpMsg:sendGetHeadImgReq(headId, token)
	local id = tostring(_getMsgId(self))
	local jsonTable = {
		class = "Headimg",
		method = "GetHeadimg",
		msgid = id,
		params = {
			head_id = headId,
			["token"] = token,
		},
	}

	local txt = json.encode(jsonTable)
	JJLog.i(TAG, "sendGetHeadImgReq, txt=", txt)
	self:sendCommonHttpReq(txt, 1001, "Headimg", "GetHeadimg", id, "GetHeadimg")
end

-- 比赛配置信息
function HttpMsg:sendGetMatchConfigReq(gameId, timeStamp, productId)
	local id = tostring(_getMsgId(self))
	local jsonTable = {
		class = "match_conf",
		method = "getmatchconf",
		msgid = id,
		params = {
			mclu = timeStamp or 0,
			productid = productId or 0,
			id = 1,
		},
	}

	local txt = json.encode(jsonTable)
	JJLog.i(TAG, "sendGetMatchConfigReq, txt=", txt)
	self:sendCommonHttpReq(txt, gameId, "match_conf", "getmatchconf", id, "getmatchconf", true)
end

-- 发送通用协议消息
function HttpMsg:sendCommonHttpJsonReq(txt, gameId, msgId, msgType)
	local msg = _getHttpReq()
    local supportZip = false
    if type(JJZipUtil) ~= "nil" then
        supportZip = true
    end
	msg.http_req_msg.commonhttp_req_msg = {
		type = "json",
		argv = txt,
		gameid = gameId,
		reqtype = 0,
        isSupportZip = supportZip,
	}

	SendMsg:send(msg)
	_saveType(msgId, msgType)
end

-- 排行榜数据
function HttpMsg:sendGetRankInMatchReq(gameID, userId)
	local id = _getMsgId(self)
	local jsonTable = {
		class = "rank",
		method = "getRankInMatch",
		msgid = id,
		params = {
			date = "total",
			type = 20,
			plat = device.platform,
			gameid = gameID,
			uids = userId,
		  },
	}

	local txt = json.encode(jsonTable)
	self:sendCommonHttpJsonReq(txt, gameID, tostring(id), "getRankInMatch")
end

-- 私信消息
function HttpMsg:sendGetMsgReq(gameId, timeStamp)
	local id = _getMsgId(self)
	local jsonTable = {
		class = "user_message",
		method = "directmessage",
		msgid = id,
		params = {
			timestamp = timeStamp or 0,
			uid = UserInfo.userId_,
		  },
	}

	local txt = json.encode(jsonTable)
	self:sendCommonHttpReq(txt, gameId, "user_message", "directmessage", id, "directmessage", true)
end

-- 公告消息
function HttpMsg:sendGetNoteReq(gameId, timeStamp)
	local id = _getMsgId(self)
	local jsonTable = {
		class = "user_message",
		method = "broadmessage",
		msgid = id,
		params = {
			timestamp = timeStamp or 0,
			package_id = gameId,
		  },
	}

	local txt = json.encode(jsonTable)
	self:sendCommonHttpReq(txt, gameId, "user_message", "broadmessage", id, "broadmessage", true)
end

-- 物品消息
function HttpMsg:sendGetWareReq(gameId, timeStamp, wareId, singleWare)
	if singleWare == true then
		local id = _getMsgId(self)
		local jsonTable = {
			class = "get_ware_dict",
			method = "getware",
			msgid = id,
			params = {
				wareid = wareId,
			  },
		}
		local txt = json.encode(jsonTable)
		self:sendCommonHttpReq(txt, gameId, "get_ware_dict", "getware", id, "getware", true)
	else
		local id = _getMsgId(self)
		local jsonTable = {
			class = "get_ware_dict",
			method = "getware",
			msgid = id,
			params = {
				uptime = timeStamp or 0,
				waretype = 1,
			  },
		}
		local txt = json.encode(jsonTable)
		self:sendCommonHttpReq(txt, gameId, "get_ware_dict", "getware", id, "getware", true)
	end
end

--发送获取更多游戏消息

--是否显示按钮，display = 1,检测
function HttpMsg:sendCheckMoreGameReq(gameId, display)
    local id = _getMsgId(self)

    JJLog.i(TAG,"sendCheckMoreGameReq",id, display)

    local jsonTable = {
        class = "moregame",
        method = "getmoregame",
        msgid = id,
        params = {
            checkdisplay = display or 1,
        },
    }

    local txt = json.encode(jsonTable)
    self:sendCommonHttpReq(txt, gameId, "moregame", "getmoregame", id, "checkmoregame", false)
    -- self:sendCommonHttpJsonReq(txt, gameID, tostring(id), "getRankInMatch")
end

function HttpMsg:sendGetMoreGameReq(gameId, time)
    local id = _getMsgId(self)

    JJLog.i(TAG,"sendGetMoreGameReq",id, time)

    local jsonTable = {
        class = "moregame",
        method = "getmoregame",
        msgid = id,
        params = {
            uptime = time or 0,
        },
    }

    local txt = json.encode(jsonTable)
    self:sendCommonHttpReq(txt, gameId, "moregame", "getmoregame", id, "getmoregame", true)
end

function HttpMsg:sendUserBehaviorsReq(gameId, param)
    local id = _getMsgId(self)

    --JJLog.i(TAG, "sendUserBehaviorsReq", id, vardump(param))

    local jsonTable = {
        class = "UserBehaviors",
        method = "BehaviorsUpload",
        msgid = id,
        params = param,
    }

    local txt = json.encode(jsonTable)
    self:sendCommonHttpReq(txt, gameId, "UserBehaviors", "BehaviorsUpload", id, "BehaviorsUpload", false, REQTYPE_PHP)
end

function HttpMsg:sendUserOeratersReq(gameId, param)
    local id = _getMsgId(self)

    --JJLog.i(TAG, "sendUserOeratersReq", id, vardump(param))

    local jsonTable = {
        class = "CLASS_USER_OPERATER",
        method = "METHOD_OPERATER_UPLOAD",
        msgid = id,
        params = param,
    }

    local txt = json.encode(jsonTable)
    self:sendCommonHttpReq(txt, gameId, "CLASS_USER_OPERATER", "METHOD_OPERATER_UPLOAD", id, "METHOD_OPERATER_UPLOAD", false, REQTYPE_PHP)
end

function HttpMsg:sendSingleLordDataReq(gameId, param)
    local id = _getMsgId(self)

    --JJLog.i(TAG, "sendSingleLordDataReq", id, vardump(param))

    local jsonTable = {
        class = "CLASS_SINGLE_LORD_DATA",
        method = "METHOD_SINGLELORD_UPLOAD",
        msgid = id,
        params = param,
    }

    local txt = json.encode(jsonTable)
    self:sendCommonHttpReq(txt, gameId, "CLASS_SINGLE_LORD_DATA", "METHOD_SINGLELORD_UPLOAD", id, "METHOD_SINGLELORD_UPLOAD", false, REQTYPE_PHP)
end

-- 充值配置
function HttpMsg:sendPayConfig(gameId, time)
	local id = _getMsgId(self)

    JJLog.i(TAG,"sendPayConfig", id, time, gameId)
    local jsonTable = {}
    if device.platform == "ios" or device.platform == "mac" then
    gameId = 0
        jsonTable = {
            class = "ios_recharge",
            method = "getset",
            msgid = id,
            params = {
                packageid = gameId,
            },
        }
        local txt = json.encode(jsonTable)
        self:sendCommonHttpReq(txt, gameId, "pay_conf", "payconf", id, "payconf")
    else
        jsonTable = {
            class = "pay_conf",
            method = "payconf",
            msgid = id,
            params = {
                pclu = time or 0,
            },
        }
        local txt = json.encode(jsonTable)
        self:sendCommonHttpReq(txt, gameId, "pay_conf", "payconf", id, "payconf", true)
    end

end

-- Push
function HttpMsg:sendPushReq(gameId, type, time)
	local id = _getMsgId(self)

    JJLog.i(TAG,"sendPushReq", id, time, gameId,PROMOTER_ID)

    local jsonTable = {
        class = "pns",
        method = "getAndroidPushNotes",
        msgid = id,
        params = {
            time = time or 0,
            promoterid = PROMOTER_ID,
        	type = type,
        },
    }

    local txt = json.encode(jsonTable)
    self:sendCommonHttpReq(txt, gameId, "pns", "getAndroidPushNotes", id, "getAndroidPushNotes", false, REQTYPE_PHP)
end

function HttpMsg:sendRoarGroupCcpAppConfigReq(packageId)
	--如果不是语音版本，直接退出，暂不处理
	local packageTemp = 0
	if not DynamicDisplayManager:canDisplayRoarCcp() then
	   return
	else
	   packageTemp = 1
	end
	local gameId = MainController:getCurGameId()
  if (MainController:getCurGameId() == JJGameDefine.GAME_ID_LORD_UNION) or (MainController:getCurGameId() == JJGameDefine.GAME_ID_LORD_UNION_HL) then
      gameId = JJGameDefine.GAME_ID_LORD
  end

 	local id = 88
    JJLog.i(TAG,"sendRoarGroupCcpAppConfigReq",id, packageId)

    local jsonTable = {
        class = "group",
        method = "getappconfig",
        msgid = id,
        markid = _getMsgId(self),
        params = {
            package = packageTemp,
        },
    }

    local txt = json.encode(jsonTable)
    self:sendCommonHttpJsonReq(txt, gameId,  tostring(id), "roar")
    -- self:sendCommonHttpJsonReq(txt, gameID, tostring(id), "getRankInMatch")
end

-- 获取用户回复提醒
function HttpMsg:sendGetRoarTipsReq(gameId)
  local id = 91
  local jsonTable = {
    class = "tips",
    method = "gettips",
    msgid = id,
    params = {
      },
  }

  local txt = json.encode(jsonTable)
  self:sendCommonHttpReq(txt, gameId, "tips", "gettips", id, "getroarremind", true)
end

-- 咆吧通知消息 type=3
function HttpMsg:sendGetRoarGroupNoticeReq(gameId)
  local id = 92
  local jsonTable = {
    class = "group_message",
    method = "groupnotice",
    msgid = id,
    params = {
      },
  }

  local txt = json.encode(jsonTable)
  self:sendCommonHttpReq(txt, gameId, "group_message", "groupnotice", id, "getroarremind", true)
end

-- 咆吧最新动态 type=4
function HttpMsg:sendGetRoarNewsReq(gameId, timeStamp)
  local id = 93
  local jsonTable = {
    class = "group_message",
    method = "groupnews",
    msgid = id,
    params = {
        timestamp = timeStamp or 0,
      },
  }

  local txt = json.encode(jsonTable)
  self:sendCommonHttpReq(txt, gameId, "group_message", "groupnews", id, "getroarremind", true)
end

-- send CommonHttp Json
function HttpMsg:sendCommonHttpJsonString(txt, gameID, class)
	local id = _getMsgId(self)
	self:sendCommonHttpJsonReq(txt, gameID, tostring(id), class)
end

--发咆哮接口
--"{"class":"roar","msgid":50,"method":"postRoar","params":{"content":"ghjjjbb","topicid":0,"username":"来宾189136480"}}",
function HttpMsg:postRoarReq(class, method, gameId, content, topicid, username, rank)
  local id = 50
  local jsonTable = {
    class = class,--"roar",
    method = method,--"postRoar",
    msgid = id,
    params = {
        content = content,
        topicid = topicid,
        username = username,
        rank = rank,
      },
  }

  local txt = json.encode(jsonTable)
  self:sendCommonHttpJsonReq(txt, gameId,  tostring(id), "postroar")
end

--{"class":"display_module","method":"getset","msgid":"2319497540","params":{"packageid":1001}}
function HttpMsg:sendDisplayModule(gameId)
    local id = _getMsgId(self)
    local jsonTable = {
        class = "display_module",
        method = "getset",
        msgid = id,
        params = {
            packageid = gameId
        },
    }
    local txt = json.encode(jsonTable)
    self:sendCommonHttpReq(txt, gameId, "display_module", "getset", id, "getset", true, false)
end

return HttpMsg
