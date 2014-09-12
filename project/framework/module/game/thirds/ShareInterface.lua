-- define global module
ShareInterface = {}

local TAG = "ShareInterface"

local TAG_ITEM_MARK_DIPLOMA = 1--奖状界面
local TAG_ITEM_MARK_EXCHANGE = 2--兑奖界面
local TAG_ITEM_MARK_SETTING = 3--设置界面
local TAG_ITEM_MARK_SINGLE_DIPLOMA = 4--单机奖状界面，没有荣誉室

local lastTick = 0
local DOUBLE_CLICK_TICK = 1 -- 重复点击的时间限制

--[[
   分享相关接口
]]

function ShareInterface:getCurGameID()
    local gameid = MainController:getCurGameId()
    if (MainController:getCurGameId() == JJGameDefine.GAME_ID_LORD_UNION) then
        gameid = JJGameDefine.GAME_ID_LORD
    end
    JJLog.i(TAG, "getCurGameID IN, 2 gameid=", gameid)
    return gameid;
end

local function _getShareGameUrl()
    local url = "http://www.jj.cn/mob/ddzfx.html?"
    if (MainController.packageId_ == JJGameDefine.GAME_ID_HALL) then
        url = "http://www.jj.cn/mob/jjdt_an_fx.html?"
    elseif (MainController.packageId_ == JJGameDefine.GAME_ID_LORD_UNION) then
        url = "http://www.jj.cn/mob/ddzfx.html?"
    elseif MainController.packageId_ == JJGameDefine.GAME_ID_LORD_UNION_HL then
    	url = "http://www.jj.cn/mob/hl_lord_fx.html?"
    elseif (MainController.packageId_ == JJGameDefine.GAME_ID_MAHJONG) or (MainController.packageId_ == JJGameDefine.GAME_ID_MAHJONG_TP)then
        url = "http://www.jj.cn/mob/mjfx.html?"
    end
    JJLog.i(TAG, "_getShareGameUrl outer, url=", url)
    return url
end

function ShareInterface:getShareUrl()
    local url = _getShareGameUrl().."userid="..UserInfo.userId_
    JJLog.i(TAG, "getShareUrl outer, url=", url)
    return url
end

function ShareInterface:sharecallback(strJson, diplomaCallback)
  JJLog.i(TAG, "sharecallback IN, strJson=", strJson)
	local decodeJjson = json.decode(strJson)
	if decodeJjson ~= nil then
	   JJLog.i(TAG, "sharecallback IN, decodeJjson.item1=", decodeJjson.item1)
		if decodeJjson.item1 == 1 then
		  if(decodeJjson.item2 == "CLICKED") then
		      --荣誉室按钮被点击，分享荣誉室
--          RoarInterface:postRoarReq("赢大奖了哟",1,1)
        if (diplomaCallback ~= nil) then
            JJLog.i("linxh", "sharecallback IN, strJson 2")
            diplomaCallback()
        end
		  end
		end

	end
end

--[[
        启动分享参数封装
    public final static String TAG_DESTRIPTION = "destription";
    public final static String TAG_IMAGEPATH= "imagepath";
    public final static String TAG_URL = "url";
    public final static String TAG_ITEMMARK = "itemmark";
    public final static String TAG_ROARFLAG = "roarflag";
]]
function ShareInterface:getShareInputParam(a_strDestription, a_strOtherImagePath, a_ItemMark, isLordSingle, isRoarShow)
    local paramTable = {}
    if (a_strOtherImagePath == nil) then
        paramTable = {
            ["destription"] = a_strDestription,
            ["url"] = self:getShareUrl(),
            ["itemmark"] = a_ItemMark,
            ["roarflag"] = isRoarShow and 1 or 0,
        }
    else
       paramTable = {
            ["destription"] = a_strDestription,
            ["imagepath"] = a_strOtherImagePath,
            ["url"] = self:getShareUrl(),
            ["itemmark"] = a_ItemMark,
            ["roarflag"] = isRoarShow and 1 or 0,
        }
    end
    JJLog.i(TAG, "getShareInputParam, json.encode(paramTable)=", json.encode(paramTable))
    return json.encode(paramTable)
end

--[[
    启动分享的入口
   * 1、a_strDestription：分享的描述信息
   * 2、a_strOtherImagePath：目前只有奖状界面在用，传入奖状的本地地址，其它传入NULL
   * 3、 a_strOtherParam：目前暂时传入NULL
   * 4、a_strUrl：链接的地址
   * 5、a_ItemMark：标示是哪个界面在用
   * 6、luaCallbackFunction：lua的回调
]]
function ShareInterface:startShowShare(a_strDestription, a_strOtherImagePath, a_ItemMark, diplomaCallback, isLordSingle, isRoarShow)
    local cur = JJTimeUtil:getCurrentSecond()
    if (cur - lastTick) < DOUBLE_CLICK_TICK then
       JJLog.i(TAG, "startShowShare, return")
       return
    else
       JJLog.i(TAG, "startShowShare, IN")
       lastTick = JJTimeUtil:getCurrentSecond()
    end
	  JJLog.i(TAG, "startShowShare IN, a_ItemMark=", a_ItemMark, ", device.platform=", device.platform)
    if device.platform == "android" then
    		className = "cn/jj/base/ShareBridge"
    		methodName = "startShowShare"
    		local function callback(result)
    		  self:sharecallback(result, diplomaCallback)
    		end
        JJLog.i(TAG, "startShowShare, isLordSingle=", isLordSingle)
        if (isLordSingle) then
            a_ItemMark = TAG_ITEM_MARK_SINGLE_DIPLOMA
        end
    		local strDestription = a_strDestription
    		local strOtherImagePath = a_strOtherImagePath
    		local itemMark = a_ItemMark
    		local lordSingleFlag = isLordSingle
    		local roarShowFlag = isRoarShow
        if Util:supportFunction("startShowShareInputJson") then
            sig = "(Ljava/lang/String;I)V"
            args = {self:getShareInputParam(strDestription, strOtherImagePath, itemMark, lordSingleFlag, roarShowFlag), callback}
        else
            if (a_strOtherImagePath == nil) then
                sig = "(Ljava/lang/String;Ljava/lang/String;II)V"
                args = {a_strDestription,self:getShareUrl(),a_ItemMark,callback}
            else
                sig = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;II)V"
                args = {a_strDestription,a_strOtherImagePath,self:getShareUrl(),a_ItemMark,callback}
            end
        end

    		JJLog.i(TAG, "startShowShare, a_strDestription=", a_strDestription)
    		JJLog.i(TAG, "startShowShare, a_strOtherImagePath=", a_strOtherImagePath)
    		JJLog.i(TAG, "startShowShare, self:getShareUrl()=", self:getShareUrl())
    		JJLog.i(TAG, "startShowShare, a_ItemMark=", a_ItemMark)
    		JJLog.i(TAG, "startShowShare, callback=", callback)
    		JJLog.i(TAG, "startShowShare, args=", args)
    		result, model = luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
	  elseif not device.platform == "windows" then

	end
end

function ShareInterface:setShareGameUrl()
    if device.platform == "android" then
      JJLog.i(TAG, "setRoarParams In android")
      className = "cn/jj/base/ShareBridge"
      methodName = "setShareGameUrl"
      args = {}
      sig = "(Ljava/lang/String;)V"
      args = {_getShareGameUrl()}
      result, model = luaj.callStaticMethod(className, methodName, args, sig)
  elseif not device.platform == "windows" then
  end
end

function ShareInterface:directFinish()
    if device.platform == "android" then
      JJLog.i(TAG, "directFinish In android")
      className = "cn/jj/base/ShareBridge"
      methodName = "directFinish"
      args = {}
      sig = "()V"
      result, model = luaj.callStaticMethod(className, methodName, args, sig)
  elseif not device.platform == "windows" then
  end
end

function ShareInterface:stopSDK()
    if device.platform == "android" then
      JJLog.i(TAG, "directFinish In android")
      className = "cn/jj/base/ShareBridge"
      methodName = "stopSDK"
      args = {}
      sig = "()V"
      result, model = luaj.callStaticMethod(className, methodName, args, sig)
  elseif not device.platform == "windows" then
  end
end

return ShareInterface