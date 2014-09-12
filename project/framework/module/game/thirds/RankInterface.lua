-- define global module
RankInterface = {}

local TAG = "RankInterface"

--[[
    排行榜相关接口
]]

function RankInterface:getRankCurGameID()
    local gameid = MainController:getCurGameId()
    if (MainController:getCurGameId() == JJGameDefine.GAME_ID_LORD_UNION or MainController:getCurGameId() == JJGameDefine.GAME_ID_LORD_UNION_HL) then
        gameid = JJGameDefine.GAME_ID_LORD
    end
    JJLog.i(TAG, "getRankCurGameID IN, 2 gameid=", gameid)
    return gameid;
end

function RankInterface:getLordColFlag()
    JJLog.i(TAG, "getLordColFlag IN, MainController.curPackageId_=", MainController.curPackageId_)
    if (MainController.curPackageId_ == JJGameDefine.GAME_ID_LORD_UNION or MainController.curPackageId_ == JJGameDefine.GAME_ID_LORD_UNION_HL) then
        return 1;
    else
        return 0;
    end
end

function RankInterface:getGameRankDirName()
    JJLog.i(TAG, "getGameRankDirName IN, MainController.packageId_=", MainController.packageId_)
    local dirName = "module/"..JJGameDefine:getGameDirName(MainController.packageId_).."/res/"
    JJLog.i(TAG, "getGameRankDirName OUTER, dirName=", dirName)
    return dirName
end

function RankInterface:getRankInputParam()
    local paramTable = {
        ["logincount"] = JJAnalytics:getLoginTimes(),
        ["topdetail"] = GlobalConfigManager:getConfigTopDetail(MainController.curPackageId_) or 0,--GlobalConfig.topDetail,
        ["gemeid"] = self:getRankCurGameID(),
        ["rankgameid"] = self:getRankCurGameID(),
        ["versionname"] = Util:getSysVersion(),
        ["userid"] = UserInfo.userId_,
        ["nickname"] = UserInfo.nickname_,
        ["versionrecord"] = 0,
        ["curversion"] = Util:getClientVersion(),
        ["packageid"] = MainController.curPackageId_,
        ["lordcolflag"] = self:getLordColFlag(),
        ["flowercount"] = Settings:getRankSendFlowerCounts(),
        ["flowerdate"] = Settings:getRankSendFlowerDate(),
        ["headimgpath"] = HeadImgManager:getImg(UserInfo.userId_, UserInfo.figureId_),
        ["jjtime"] = JJTimeUtil:getCurrentSecond(),
        ["gamedirname"] = self:getGameRankDirName(),
    }
    return json.encode(paramTable)
end

function RankInterface:rankcallback(strJson)
  JJLog.i(TAG, "rankcallback IN, strJson=", strJson)
	local decodeJjson = json.decode(strJson)
	if decodeJjson ~= nil then
	   JJLog.i(TAG, "rankcallback IN, decodeJjson.item1=", decodeJjson.item1)
		if decodeJjson.item1 == 1 then --OnAskCommonHttpReq(final int gameId, final int msgId, final String strReq)
			HttpMsg:sendCommonHttpJsonReq(decodeJjson.item4, decodeJjson.item2, decodeJjson.item3, "rank")
		elseif decodeJjson.item1 == 2 then --
			--do nothing
		elseif decodeJjson.item1 == 3 then --OnAskSendMsgCustom(final String strReq)
		  require("game.pb.HbaseMsg")
			HbaseMsg:sendCommonHbaseReq(decodeJjson.item2, 1001)
		elseif decodeJjson.item1 == 4 then --OnInitHeadImageFetcher()
--			HeadImgManager:init()
		elseif decodeJjson.item1 == 5 then --OnClearHeadImageFetcher()
			--do nothing
		elseif decodeJjson.item1 == 6 then --OnLoadHeadImage(ImageView headIcon)
			--do nothing
		elseif decodeJjson.item1 == 7 then --OnGetRankSendFlowerCounts()
			local paramTable = {
        		["flowercount"] = Settings:getRankSendFlowerCounts(),
    		}
    		self:setRankParams(tostring(json.encode(paramTable)))
		elseif decodeJjson.item1 == 8 then --OnSetRankSendFlowerCounts(final int nCounts)
			Settings:setRankSendFlowerCounts(decodeJjson.item2)
		elseif decodeJjson.item1 == 9 then --OnGetRankSendFlowerDate()
			local paramTable = {
        		["flowerdate"] = Settings:getRankSendFlowerDate(),
    		}
    		self:setRankParams(tostring(json.encode(paramTable)))
		elseif decodeJjson.item1 == 10 then --OnSetRankSendFlowerDate(final String nDate)
			Settings:setRankSendFlowerDate(decodeJjson.item2)
		elseif decodeJjson.item1 == 11 then --OnAskGetWareName(final int wareId)
			local paramTable = {
        		["warename"] = WareInfoManager:getWareName(decodeJjson.item2),
    		}
    		self:setRankParams(tostring(json.encode(paramTable)))
		elseif decodeJjson.item1 == 12 then --OnGetJJTime()
		  JJLog.i(TAG, "rankcallback 12 111")
			local paramTable = {
        		["jjtime"] = JJTimeUtil:getCurrentSecond(),
    		}
    		JJLog.i(TAG, "rankcallback 12, json.encode(paramTable)=", tostring(json.encode(paramTable)))
    		self:setRankParams(tostring(json.encode(paramTable)))
		end

	end
end

--[[
    启动排行榜入口 startRankActivity(final int a_nState, final String str_jsonData, final int callback)
]]
function RankInterface:enteRank(state)
	JJLog.i(TAG, "enteRank IN, state=", state, ", device.platform=", device.platform)
    if device.platform == "android" then
		className = "cn/jj/base/JJUtil"
		methodName = "startRankActivity"
		sig = "(Ljava/lang/String;II)V"
		local function callback(result)
		  self:rankcallback(result)
		end
		args = {tostring(self:getRankInputParam()),state,callback}
		JJLog.i(TAG, "enteRank, args=", args)
		result, model = luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
    	-- register rank function
        local className = "HttpListener"
	    local methodName = "registerScriptHandler"
        local function callbackSendMsg(result)
            local decodeJjson = json.decode(result.argv)
            if decodeJjson ~= nil then
                HttpMsg:sendCommonHttpJsonReq(result.argv, result.gameId, decodeJjson.msgid, "rank")
            end
		    --HttpMsg:sendCommonHttpJsonString(result.argv, result.gameId, "rank")
		end
		local args = {
            listener = callbackSendMsg,
        }
		local ok, ret = luaoc.callStaticMethod(className,methodName,args)
        if not ok then
        	JJLog.i(TAG, "-- call HttpListener API failure, error code: ", tostring(ret))
        end

	    local className = "RankController"
        local methodName = "enterRankView"
        local args = {
            state = 0,
            gameid = self:getRankCurGameID(),
            userid = UserInfo.userId_ .. "",
        }
        local ok, ret = luaoc.callStaticMethod(className,methodName,args)
        if not ok then
            JJLog.i(TAG, "-- call RankController API failure, error code: ", tostring(ret))
        end
	elseif not device.platform == "windows" then

	end
end

function RankInterface:exitRank()
    if device.platform == "android" then
		className = "cn/jj/base/JJUtil"
		methodName = "destroyRankActivity"
		args = {}
		sig = "()V"
		result, model = luaj.callStaticMethod(className, methodName, args, sig)
	elseif not device.platform == "windows" then

	end
end

function RankInterface:handleRankingHttpAck(str_jsonData)
    if device.platform == "android" then
        handleRankHttpAckMsgLua(str_jsonData)
    elseif device.platform == "ios" then
		local className = "HttpController"
		local methodName = "onHandlerMsg"
		local args = {
          msg = str_jsonData,
        }
        local ok, ret = luaoc.callStaticMethod(className,methodName,args)
        if not ok then
            JJLog.i(TAG, "-- call handleRankingHttpAck API failure, error code: ", tostring(ret))
        end
	elseif not device.platform == "windows" then

	end
end

function RankInterface:handleHbaseRankingMsg(str_jsonData)
    if device.platform == "android" then
--		className = "cn/jj/base/RankBridge"
--		methodName = "handleHbaseRankingMsg"
--		args = {}
--		sig = "(Ljava/lang/String;)V"
--		args = {str_jsonData}
--		result, model = luaj.callStaticMethod(className, methodName, args, sig)
      JJLog.i(TAG, "handleHbaseRankingMsg In android")
      handleHbaseRankingMsgLua(str_jsonData)
	elseif not device.platform == "windows" then

	end
end

function RankInterface:setRankParams(str_jsonData)
    if device.platform == "android" then
--		className = "cn/jj/base/RankBridge"
--		methodName = "setRankParams"
--		args = {}
--		sig = "(Ljava/lang/String;)V"
--		args = {str_jsonData}
--		result, model = luaj.callStaticMethod(className, methodName, args, sig)
      JJLog.i(TAG, "setRankParams In android str_jsonData=", str_jsonData)
      setRankParamsLua(str_jsonData)
	elseif not device.platform == "windows" then

	end
end

function RankInterface:init()
    if device.platform == "android" then
--		className = "cn/jj/base/RankBridge"
--		methodName = "init"
--		args = {}
--		sig = "(II)V"
--		args = {Util:getClientVersion(),MainController.packageId_}
--		result, model = luaj.callStaticMethod(className, methodName, args, sig)
		JJLog.i(TAG, "init In android")
		initRankLua(Util:getClientVersion(), MainController.curPackageId_)
	elseif not device.platform == "windows" then

	end
end

function RankInterface:updateRankingRuleReq()
    if device.platform == "android" then
--		className = "cn/jj/base/RankBridge"
--		methodName = "updateRankingRuleReq"
--		args = {}
--		sig = "(II)V"
--		args = {MainController:getCurGameId(),MainController.packageId_}
--		result, model = luaj.callStaticMethod(className, methodName, args, sig)
		JJLog.i(TAG, "updateRankingRuleReq In android")
		updateRankingRuleReqLua(MainController:getCurGameId(), MainController.curPackageId_)
	elseif not device.platform == "windows" then

	end
end


return RankInterface