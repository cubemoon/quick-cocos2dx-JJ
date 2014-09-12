-- define global module
RoarInterface = {}

local TAG = "RoarInterface"
local CHECK_TICK = 15 -- 15s 检查一次
local NOTE_UPDATE_TICK = 180 -- 三分钟更新一次 Notemsg
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
roarRemindMsgFlag_ = false; --是否有未读的提醒标示

TAG_GROW = 1
TAG_WARE = 2

--[[
    咆哮相关接口

  public final static String TAG_GAMEID = "gemeid";
	public final static String TAG_PACKAGEID= "packageid";
	public final static String TAG_USERID = "userid";
	public final static String TAG_NICKNAME = "nickname";
	public final static String TAG_SCORE = "score";
	public final static String TAG_ANONYMOUSE = "isAnonymouse";
	public final static String TAG_JJTIME= "jjtime";
	public final static String TAG_GROUP_THIRD_VER = "groupthirdver";
	public final static String TAG_ALLOW_EXIST = "allowexist";
	public final static String TAG_NEED_REQINFO= "needreqinfo";
	public final static String TAG_NETWORK= "network";
	public final static String TAG_MSG_MAXNUM= "msgmaxnum";
	public final static String TAG_VERSION_CODE = "versioncode";
	public final static String TAG_LAST_COMPLAIT_TIME = "lastcomplaittime";
	public final static String TAG_LIMIT_SEC = "roarlimitsec";
	public final static String TAG_GAME_NAME = "gamename";
	public final static String TAG_GROW_NAME = "growname";
	public final static String TAG_WARE_NAME = "warename";
	public final static String TAG_CLIENT_SW = "clientsw";
	public final static String TAG_MAHJONG_TP = "ismahjongtp";
	public final static String TAG_SHOW_TW_FLAG = "showtw";
]]

local function _getRoarCurGameID()
    local gameid = MainController:getCurGameId()
    if (MainController:getCurGameId() == JJGameDefine.GAME_ID_LORD_UNION) then
        gameid = JJGameDefine.GAME_ID_LORD
    end
    JJLog.i(TAG, "_getRoarCurGameID IN, 2 gameid=", gameid)
    return gameid;
end

function RoarInterface:getRoarInputParam()
    local paramTable = {
        ["gemeid"] = _getRoarCurGameID(),
        ["packageid"] = MainController.packageId_,
        ["userid"] = UserInfo.userId_,
        ["nickname"] = UserInfo.nickname_,
        ["score"] = UserInfo.totalScore_,
        ["isAnonymouse"] = 0,
        ["groupthirdver"] = DynamicDisplayManager:canDisplayRoarCcp() and 1 or 0,
        -- ["allowexist"] = 1,
        -- ["needreqinfo"] = 1,

        -- ["network"] = 0,
        ["msgmaxnum"] = 50,
        ["versioncode"] = Util:getClientVersion(),
        -- ["lastcomplaittime"] = 1,
        ["roarlimitsec"] = GlobalConfigManager:getConfigRoarPostInterval(MainController.curPackageId_) or 10,
        ["clientsw"] = GlobalConfigManager:getConfigClientSW(MainController.curPackageId_) or 0,
        ["ismahjongtp"] = 0,
        ["headimgpath"] = HeadImgManager:getImg(UserInfo.userId_, UserInfo.figureId_),
        ["jjtime"] = JJTimeUtil:getCurrentSecond(),
        ["showtw"] = DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_ROAR_TW) and 1 or 0,
    }
    return json.encode(paramTable)
end

function RoarInterface:roarcallback(strJson)
	local decodeJjson = json.decode(strJson)
	if decodeJjson ~= nil then
		if decodeJjson.item1 == 1 then --OnAskCommonHttpReq(final int gameId, final int msgId, final String strReq)
			HttpMsg:sendCommonHttpJsonReq(decodeJjson.item4, decodeJjson.item2, decodeJjson.item3, "roar")
		elseif decodeJjson.item1 == 2 then --
			--do nothing
		elseif decodeJjson.item1 == 3 then --OnInitHeadImageFetcher
--			HeadImgManager:init()
		elseif decodeJjson.item1 == 4 then --OnClearHeadImageFetcher()
			--do nothing
		elseif decodeJjson.item1 == 5 then --OnLoadHeadImage(ImageView headIcon)
			--do nothing
		elseif decodeJjson.item1 == 6 then --OnGetGameName(final int gameId)
			local paramTable = {
        		["gamename"] = "斗地主",
    		}
    		self:setRoarParams(tostring(json.encode(paramTable)))
		elseif decodeJjson.item1 == 7 then --OnGetGrowName(final int nId)//
			local paramTable = {
        		["growname"] = GrowInfoManager:getGrowName(decodeJjson.item2),
    		}
    		self:setRoarParams(tostring(json.encode(paramTable)))
		elseif decodeJjson.item1 == 8 then --OnGetWareInfo(final int nId)--
			local paramTable ={}
			local wareItem = WareInfoManager:getWareInfo(decodeJjson.item2)
			if wareItem ~= nil then
			local paramTable = {
        		["wareId"] = wareItem.wareId_,
        		["compose"] = wareItem.compose_,
        		["reward"] = wareItem.reward_,
        		["wareName"] = wareItem.wareName_,
        		["wareExplain"] = wareItem.wareExplain_,
        		["wareIntro"] = wareItem.wareIntro_,
        		["merit"] = wareItem.merit_,
        		["rewardDes"] = wareItem.rewardDes_,
    		}
			end
    		self:setWareInfo(tostring(json.encode(paramTable)))
		elseif decodeJjson.item1 == 9 then --OnGetWareName(final int nId)
			local paramTable = {
        		["warename"] = WareInfoManager:getWareName(decodeJjson.item2),
    		}
    		self:setRoarParams(tostring(json.encode(paramTable)))
		elseif decodeJjson.item1 == 10 then --OnSendGetNote(final int userId, final int lnid, final int gameId, final int typeId)
			--do nothing
		elseif decodeJjson.item1 == 11 then --OnGetJJTime()
			local paramTable = {
        		["jjtime"] = JJTimeUtil:getCurrentSecond(),
    		}
    		self:setRoarParams(tostring(json.encode(paramTable)))
		elseif decodeJjson.item1 == 12 then --
			--do nothing
		end

	end
end

--[[
    启动排行榜入口 startRoarActivity(final int a_nState, final String str_jsonData, final int callback)
]]
function RoarInterface:enteRoar(state)
	JJLog.i(TAG, "enteRoar IN, state=", state, ", device.platform=", device.platform)
    if device.platform == "android" then
		className = "cn/jj/base/JJUtil"
		methodName = "startRoarActivity"
		sig = "(Ljava/lang/String;II)V"
		local function callback(result)
		  self:roarcallback(result);
		end
		args = {tostring(self:getRoarInputParam()),state,callback}
		JJLog.i(TAG, "enteRoar, args=", args)
		result, model = luaj.callStaticMethod(className, methodName, args, sig)
	elseif device.platform == "ios" then
        -- register roar function
        local className = "HttpListener"
        local methodName = "registerScriptHandler"
        local function callbackSendMsg(result)
            local decodeJjson = json.decode(result.argv)
            if decodeJjson ~= nil then
                HttpMsg:sendCommonHttpJsonReq(result.argv, result.gameId, decodeJjson.msgid, "roar")
            end
            --HttpMsg:sendCommonHttpJsonString(result.argv, result.gameId, "roar")
		end
		local args = {
              listener = callbackSendMsg,
        }
        local ok, ret = luaoc.callStaticMethod(className,methodName,args)
        if not ok then
            print(string.format(" -- call API failure, error code: %s",tostring(ret)))
        end

        -- register get grow ware value
        local className = "LobbyData"
        local methodName = "registerScriptHandler"
        local function callbackGetData(result)
            self:handlerDataReq(result.type,result.dataId)
        end
        local args = {
            listener = callbackGetData,
        }
        local ok, ret = luaoc.callStaticMethod(className,methodName,args)
        if not ok then
            print(string.format(" -- call API failure, error code: %s",tostring(ret)))
        end

        -- enter view
        if ok then
            local className = "RoarController"
            local methodName = "enterRoarOrHonorView"
            local args = {
                  state = 0,
                  gameId = _getRoarCurGameID(),
                  userid = UserInfo.userId_ .. "",
                  nickname = UserInfo.nickname_,
                  isAnonymouse = 0,
                  score = UserInfo.totalScore_,
            }
            local ok, ret = luaoc.callStaticMethod(className,methodName,args)
            if not ok then
                  print(string.format(" -- call API failure, error code: %s",tostring(ret)))
            end
        end
	elseif not device.platform == "windows" then

	end
end

function RoarInterface:exitRoar()
    JJLog.i(TAG, "exitRoar IN")
    if device.platform == "android" then
		className = "cn/jj/base/JJUtil"
		methodName = "destroyRoarActivity"
		args = {}
		sig = "()V"
		result, model = luaj.callStaticMethod(className, methodName, args, sig)
	elseif not device.platform == "windows" then

	end
end

function RoarInterface:handleRoarHttpAck(str_jsonData)
    if device.platform == "android" then
        JJLog.i(TAG, "handleRoarHttpAck In android")
        handleRoarHttpAckMsgLua(str_jsonData)
    elseif device.platform == "ios" then
        local className = "HttpController"
        local methodName = "onHandlerMsg"
        local args = {
          msg = str_jsonData,
        }
        local ok, ret = luaoc.callStaticMethod(className,methodName,args)
        if not ok then
             print(string.format(" -- call API failure, error code: %s",tostring(ret)))
        end
	elseif not device.platform == "windows" then

	end
end

function RoarInterface:handleRoarAPPConfigHttpAck(str_jsonData)
    if device.platform == "android" then
        JJLog.i(TAG, "handleRoarAPPConfigHttpAck In android")
        className = "cn/jj/base/RoarBridge"
        methodName = "handleRoarAPPConfigHttpAck"
        args = {}
        sig = "(Ljava/lang/String;)V"
        args = {str_jsonData}
        result, model = luaj.callStaticMethod(className, methodName, args, sig)
--      handleRoarAPPConfigHttpAckLua(str_jsonData)
--      handleRoarHttpAckMsgLua(str_jsonData)
  elseif not device.platform == "windows" then

  end
end

function RoarInterface:handleRoarConfigControllerMsg(str_jsonData)
    if device.platform == "android" then
        JJLog.i(TAG, "handleRoarConfigControllerMsg In android")
        className = "cn/jj/base/RoarBridge"
        methodName = "handleRoarConfigControllerMsg"
        local function callback(result)
            self:roarRemindcallback(result)
        end
        args = {}
        sig = "(Ljava/lang/String;I)V"
        args = {str_jsonData,callback}
        result, model = luaj.callStaticMethod(className, methodName, args, sig)
  elseif not device.platform == "windows" then

  end
end


function RoarInterface:setRoarParams(str_jsonData)
    if device.platform == "android" then
--		className = "cn/jj/base/RoarBridge"
--		methodName = "setRoarParams"
--		args = {}
--		sig = "(Ljava/lang/String;)V"
--		args = {str_jsonData}
--		result, model = luaj.callStaticMethod(className, methodName, args, sig)
    JJLog.i(TAG, "setRoarParams In android")
		setRoarParamsLua(str_jsonData)
	elseif not device.platform == "windows" then

	end
end

function RoarInterface:setWareInfo(str_jsonData)
    if device.platform == "android" then
--		className = "cn/jj/base/RoarBridge"
--		methodName = "setWareInfo"
--		args = {}
--		sig = "(Ljava/lang/String;)V"
--		args = {str_jsonData}
--		result, model = luaj.callStaticMethod(className, methodName, args, sig)
		JJLog.i(TAG, "setWareInfo In android")
		setWareInfoLua(str_jsonData)
	elseif not device.platform == "windows" then

	end
end

function RoarInterface:init()
    if device.platform == "android" then
--		className = "cn/jj/base/RoarBridge"
--		methodName = "init"
--		args = {}
--		sig = "()V"
--		result, model = luaj.callStaticMethod(className, methodName, args, sig)
    JJLog.i(TAG, "init In android")
		initRoarLua()
	elseif not device.platform == "windows" then

	end
end

function RoarInterface:roarRemindcallback(strJson)
	if strJson ~= nil then
	  if DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_ROAR) then
        if strJson == "havenewmsg" then
          --update lobby msg remind
          roarRemindMsgFlag_ = true
        elseif strJson == "havenomsg" then
          roarRemindMsgFlag_ = false
        end
        local event = require("game.message.RoarMsgUpdateMsg").new(roarRemindMsgFlag_)
            JJSDK:pushMsgToSceneController(event)
	  else
        roarRemindMsgFlag_ = false
	  end

	end
end

--public static void getRoarOfflineCloudReq(final int nGroupThirdVer, final int nUserId, final int luaCallbackFunction)
function RoarInterface:getRoarOfflineCloudReq(nUserId)
	JJLog.i(TAG, "getRoarOfflineCloudReq IN, nUserId=", nUserId)
    if device.platform == "android" then
  		className = "cn/jj/base/RoarBridge"
  		methodName = "getRoarOfflineCloudReq"
  		sig = "(III)V"
  		local function callback(result)
  		  self:roarRemindcallback(result)
  		end
  		args = {DynamicDisplayManager:canDisplayRoarCcp() and 1 or 0,nUserId,callback}
  		JJLog.i(TAG, "enteRoar, args=", args)
  		result, model = luaj.callStaticMethod(className, methodName, args, sig)
      JJLog.i(TAG, "getRoarOfflineCloudReq In android")
--      getRoarOfflineCloudReqLua(nGroupThirdVer, nUserId, callback)
	elseif not device.platform == "windows" then

	end
end

function RoarInterface:initRoarAllMsg(aUserId)
    if device.platform == "android" then
--		className = "cn/jj/base/RoarBridge"
--		methodName = "initRoarAllMsg"
--		args = {aUserId}
--		sig = "(I)V"
--		result, model = luaj.callStaticMethod(className, methodName, args, sig)
		JJLog.i(TAG, "initRoarAllMsg In android")
    initRoarAllMsgLua(aUserId)
	elseif not device.platform == "windows" then

	end
end

local function getFileLine(file_name)
  local BUFSIZE = 84012
  local f = assert(io.open(file_name, 'r'))
  local lines,rest = f:read(BUFSIZE, "*line")
  f:close()
  return lines , rest
end

local function _getRoarNewsLastUpdateTime()
    local MSG_ROAR_GROUP_DIS_FILE = "_roargroupdismsg.json";
    local strFileName = "data/roar/"..UserInfo.userId_..MSG_ROAR_GROUP_DIS_FILE
    JJLog.i(TAG, "_getRoarNewsLastUpdateTime IN, strFileName=", strFileName)
    if JJFileUtil:exist(strFileName) then
        JJLog.i(TAG, "_getRoarNewsLastUpdateTime IN, JJFileUtil:getFullPath(strFileName)=", JJFileUtil:getFullPath(strFileName))
        local size = 0
        local path = JJFileUtil:getFullPath(strFileName)
        local tmp, size = CCFileUtils:sharedFileUtils():getFileData(path, "r", size)
        if (tmp ~= nil) and (size > 0) then
          JJLog.i(TAG, "_getRoarNewsLastUpdateTime IN, tmp=", tmp)
          tmp = string.sub(tmp, 1, size)
          JJLog.i(TAG, "_getRoarNewsLastUpdateTime IN,2 tmp=", tmp)
          local decodeJjson = json.decode(tmp)
          JJLog.i(TAG, "_getRoarNewsLastUpdateTime IN, decodeJjson=", decodeJjson)
          if decodeJjson ~= nil then
                JJLog.i(TAG, "_getRoarNewsLastUpdateTime IN, decodeJjson.attr=", decodeJjson.attr)
                JJLog.i(TAG, "_getRoarNewsLastUpdateTime IN, decodeJjson.attr.ctime=", decodeJjson.attr.ctime)
                return decodeJjson.attr.ctime
          end
        end
    end
    return 0
end

local function _sendAllRoarRemindReq(gameId)
    JJLog.i(TAG, "_sendAllRoarRemindReq In")
    if (UserInfo.userId_ == 0) then
        JJLog.i(TAG, "_sendAllRoarRemindReq In userId_ == 0")
        return
    end
    HttpMsg:sendGetRoarTipsReq(gameId)
    HttpMsg:sendGetRoarGroupNoticeReq(gameId)
    HttpMsg:sendGetRoarNewsReq(gameId, _getRoarNewsLastUpdateTime())
end

--[[
    提醒每帧回调
]]
local lastTick = 0
local function _update(dt)
    JJLog.i(TAG, "_update In")
    local cur = JJTimeUtil:getCurrentSecond()
    if (cur - lastTick) > NOTE_UPDATE_TICK then
       _sendAllRoarRemindReq(_getRoarCurGameID())
       lastTick = JJTimeUtil:getCurrentSecond()
    end
end

-- 外部接口
-- 添加需要监听
function RoarInterface:getAllRoarRemindData()
    JJLog.i(TAG, "getAllRoarRemindData In")
    if self.scheduleHandler_ == nil then
       self.scheduleHandler_ = scheduler.scheduleGlobal(_update, CHECK_TICK)
    end
     _sendAllRoarRemindReq(_getRoarCurGameID())
     lastTick = JJTimeUtil:getCurrentSecond()
end

function RoarInterface:getRoarAllRemindMsg()
    if device.platform == "android" then
    className = "cn/jj/base/RoarBridge"
    methodName = "getRoarAllRemindMsg"
    local function callback(result)
      self:roarRemindcallback(result);
    end
    args = {callback}
    sig = "(I)V"
    result, model = luaj.callStaticMethod(className, methodName, args, sig)
  elseif not device.platform == "windows" then

  end
end

--[[
1.content:发表内容
2.topicid：发表的类型
  public static final int TYPE_ROAR = 0; // 咆哮
  public static final int TYPE_HONOR = 1; // 荣誉室
  public static final int TYPE_DAILY_STAR = 24; // 每日之星
  public static final int TYPE_WANJI = 101; // 玩机
  public static final int TYPE_IKNOW = 201; // I知道
  public static final int TYPE_NEWS = 203; // 快讯
3. rank：排名，不是荣誉室，直接传0
]]
function RoarInterface:postRoarReq(content, topicid)
    HttpMsg:postRoarReq("roar", "postRoar", _getRoarCurGameID(),content,topicid,UserInfo.nickname_,0)
end

function RoarInterface:postGloryReq(content, topicid, rank)
    HttpMsg:postRoarReq("glory", "postGlory", _getRoarCurGameID(),content,topicid,UserInfo.nickname_,rank)
end

--[[****************************************咆哮ios相关接口*********************************]]

function RoarInterface:handlerDataReq(_type,_dataId)
	print("liny -- handlerDataReq _type=",_type,"_dataId",_dataId)
    local data = {}
	if (_type == TAG_GROW) then
        local growItem = GrowInfoManager:getGrowInfo(_dataId)
        local className = "LobbyData"
		local methodName = "getDataFromLua"
        local args = {
        type_ = "grow",
        growId_ = growItem.growId_,
        name_ = growItem.growName_,
        intro_ = growItem.growIntro_,
        }
        local ok, ret = luaoc.callStaticMethod(className,methodName,args)
        if not ok then
            print(string.format(" -- call API failure, error code: %s",tostring(ret)))
        end

	elseif (_type == TAG_WARE) then
		local wareItem = WareInfoManager:getWareItem(_dataId)
        local args = {}
        local className = "LobbyData"
		local methodName = "getDataFromLua"

		if wareItem ~= nil then
			args = {
			    type_ = "ware",
                wareId = wareItem.wareId_,
                compose = wareItem.compose_,
                reward = wareItem.reward_,
                wareName = wareItem.wareName_,
                wareExplain = wareItem.wareExplain_,
                wareIntro = wareItem.wareIntro_,
                merit = wareItem.merit_,
                rewardDes = wareItem.rewardDes_,
    		}
		end

        local ok, ret = luaoc.callStaticMethod(className,methodName,args)
        if not ok then
            print(string.format(" -- call API failure, error code: %s",tostring(ret)))
        end

	end
end

return RoarInterface