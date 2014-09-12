DynamicDisplayManager = {}
require("game.def.JJSceneDef")

local TAG = "DynamicDisplayManager"
local config_ = {}

-- {"attr":{},"method":"getset","datas":[{"4":1,"8":0,"1":0,"5":1,"9":0,"6":0,"3":0,"7":0,"2":0}],"class":"display_module","msgid":20333}
DynamicDisplayManager.DISPLAY_TYPE_MORE_GAME = 1              --更多游戏    更多游戏显隐
DynamicDisplayManager.DISPLAY_TYPE_FIND_PASSWORD = 2          --登录  找回密码显隐
DynamicDisplayManager.DISPLAY_TYPE_MOBILE_REGISTER = 3        --注册  手机注册显隐
DynamicDisplayManager.DISPLAY_TYPE_MOBILE_REGISTER_GOLD = 4   --注册  手机注册送金
DynamicDisplayManager.DISPLAY_TYPE_LOADING = 5                --Loading 联运登录相关
DynamicDisplayManager.DISPLAY_TYPE_APP_RECOMMEND = 6          --应用推荐    游戏内容配置
DynamicDisplayManager.DISPLAY_TYPE_ROAR_CCP = 7               --语音咆吧    语音咆吧开关
DynamicDisplayManager.DISPLAY_TYPE_RANK = 8                   --排行榜 显隐控制
DynamicDisplayManager.DISPLAY_TYPE_TOPIC = 9                  --活动  活动显隐
DynamicDisplayManager.DISPLAY_TYPE_WARECOMPOSE = 10           --合成炉 合成炉显隐
DynamicDisplayManager.DISPLAY_TYPE_WARE = 11                  --物品  物品显隐
DynamicDisplayManager.DISPLAY_TYPE_EXCHANGE_PRIZE = 12        --兑奖中心    兑奖中心显隐
DynamicDisplayManager.DISPLAY_TYPE_SHARE = 13                 --分享    分享入口点隐藏
DynamicDisplayManager.DISPLAY_TYPE_ROAR = 14                  --咆哮 咆哮入口显隐
DynamicDisplayManager.DISPLAY_TYPE_CHARGE = 15                --充值  渠道充值显隐开关
DynamicDisplayManager.DISPLAY_TYPE_ROAR_TW = 16               --提问区 隐掉咆哮中提问区模块

--修改为根据当前的游戏进行区分
local getCurPackageDisDatas = function ()
    return "data/" .. MainController:getCurPackageId() .. "_DynamicDisplayConfig.lua"
end

function DynamicDisplayManager:initFromFile()
    JJLog.i(TAG, "initFromFile")
    config_[MainController:getCurPackageId()] = LuaDataFile.get(getCurPackageDisDatas())
    JJLog.i(TAG, vardump(config_,"config_"))
end

local function _save()
    LuaDataFile.save(config_[MainController:getCurPackageId()], getCurPackageDisDatas())
end

function DynamicDisplayManager:updateView()
    JJLog.i(TAG, "updateView")
    local top = JJSDK:getTopSceneController()
    local sceneId = top and top:getSceneId()
    JJLog.i(TAG, "updateView,sceneId = ",sceneId)
    if sceneId == JJSceneDef.ID_MAIN or sceneId == JJSceneDef.ID_MATCH_SELECT or sceneId == JJSceneDef.ID_LOBBY then
        top:refreshBottomViewBtn()
    end
end

function DynamicDisplayManager:save(data)
    JJLog.i(TAG, "save, data = ",data)
    if data and #data > 0 then
        config_[MainController:getCurPackageId()] =  data[1]
    else
        config_[MainController:getCurPackageId()] =  nil
    end
    self:updateView()
    _save()
end

function DynamicDisplayManager:canDisplay(type)
    JJLog.i(TAG,"canDisplay,type = ",type)
    local bDisplay = true
    if config_ and config_[MainController:getCurPackageId()] and config_[MainController:getCurPackageId()][tostring(type)] and config_[MainController:getCurPackageId()][tostring(type)] == 0 then
        bDisplay = false
    end
    JJLog.i(TAG,"canDisplay,type = ",type,"MainController:getCurPackageId() = ",MainController:getCurPackageId(),"bDisplay = ",bDisplay)
    return bDisplay
end

function DynamicDisplayManager:canDisplayRoarCcp()
    JJLog.i(TAG,"canDisplayRoarCcp,In ")
    local bDisplay = true
    local util = require("sdk.util.Util")
    local stProcessor = util:getProcessor()
    JJLog.i(TAG,"canDisplayRoarCcp,stProcessor = ",stProcessor)
    local st = string.find(stProcessor, "Intel")
    JJLog.i(TAG,"canDisplayRoarCcp,st = ",st)
    if st then --如果是X86的版本去掉语音咆吧，不支持
        bDisplay = false
    else
        bDisplay = self:canDisplay(self.DISPLAY_TYPE_ROAR_CCP)
    end
    JJLog.i(TAG,"canDisplayRoarCcp,bDisplay = ",bDisplay)
    return bDisplay
end

return DynamicDisplayManager