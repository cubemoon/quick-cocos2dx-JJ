local AboutScene = class("AboutScene", import("game.ui.scene.JJGameSceneBase"))
local JJHlLabel = require("game.ui.view.JJHlLabel")
local TAG = "AboutScene"

local PHONENUMBER = "010-62981235"
local fontColor = ccc3(255, 217, 0)
local fontHLColor = ccc3(255, 190, 0)

AboutScene.telUrl_ = nil
AboutScene.weiboUrl_ = nil
AboutScene.homepageUrl_ = nil
AboutScene.callDialog_ = nil

function AboutScene:ctor(controller)
    AboutScene.super.ctor(self, controller)
end

function AboutScene:onDestory()
    JJLog.i(TAG, "onDestory")
    AboutScene.super.onDestory(self)

    -- 清理句柄
    self.homepageUrl_ = nil
    self.weiboUrl_ = nil
    self.telUrl_ = nil
    self.callDialog_ = nil
end

function AboutScene:initView()
    AboutScene.super.initView(self)

    --local title = "about/about_title.png"
    self:setThemeStyle(self.THEME_LANDSCAPE_SYTLE)
    self:setBackBtn(true)
    self:setTitle("游戏关于")
    --self:setTitle(self.theme_:getImage(title))

    -- 版本
    local params = {
        fontSize = self.dimens_:getDimens(20),
        color = ccc3(255, 255, 255),
    }
    local x = self.dimens_.cx - self.dimens_:getDimens(200)
    local y = self.dimens_.height - self.dimens_:getDimens(100)
    

    -- 官方网址
    local params = {
        fontSize = self.dimens_:getDimens(22),
        color = display.COLOR_WHITE,
    }
    local x = self.dimens_.cx - self.dimens_:getDimens(200)
    local y_dimens = self.dimens_:getDimens(50)
    
    params.text = "官方网址："
    local homepage_ = jj.ui.JJLabel.new(params)
    homepage_:setAnchorPoint(ccp(0, 1))
    homepage_:setPosition(x, y)
    self:addView(homepage_)

    local X_WHITE = homepage_:getBoundingBoxWidth()
    local urlparam = {
        fontSize = self.dimens_:getDimens(22),
        color = fontColor,
    }
    urlparam.text = "http://www.jj.cn"
    self.homepageUrl_ = JJHlLabel.new(urlparam,self,fontColor,fontHLColor)
    self.homepageUrl_:setAnchorPoint(ccp(0, 1))
    self.homepageUrl_:setPosition(x + X_WHITE, y)
    local JJGameUtil = require("game.util.JJGameUtil")
    if JJGameUtil:isAboutUrlLink(PROMOTER_ID) then
    	self.homepageUrl_:setTouchEnable(true)
	    self.homepageUrl_:setOnClickListener(handler(self, self.onClick))
    end
    self:addView(self.homepageUrl_)

    -- 客服电话
    y = y - y_dimens
    params.text = "客服电话："
    local tel_ = jj.ui.JJLabel.new(params)
    tel_:setAnchorPoint(ccp(0, 1))
    tel_:setPosition(x, y)
    self:addView(tel_)

    urlparam.text = PHONENUMBER
    self.telUrl_ = JJHlLabel.new(urlparam,self,fontColor,fontHLColor)
    self.telUrl_:setAnchorPoint(ccp(0, 1))
    self.telUrl_:setPosition(x + X_WHITE, y)
    self.telUrl_:setTouchEnable(true)
    self.telUrl_:setOnClickListener(handler(self, self.onClick))
    self:addView(self.telUrl_)

    --腾讯微信
    y = y - y_dimens
    params.text = "官方微信：jjmobile"
    local weixin_ = jj.ui.JJLabel.new(params)
    weixin_:setAnchorPoint(ccp(0, 1))
    weixin_:setPosition(x, y)
    self:addView(weixin_)

    --新浪微博
    y = y - y_dimens
    params.text = "新浪微博："
    local weibo_ = jj.ui.JJLabel.new(params)
    weibo_:setAnchorPoint(ccp(0, 1))
    weibo_:setPosition(x, y)
    self:addView(weibo_)

    urlparam.text = "http://e.weibo.com/jjmobile"
    self.weiboUrl_ = JJHlLabel.new(urlparam,self,fontColor,fontHLColor)
    self.weiboUrl_:setAnchorPoint(ccp(0, 1))
    self.weiboUrl_:setPosition(x + X_WHITE, y)
    if JJGameUtil:isAboutUrlLink(PROMOTER_ID) then
    	self.weiboUrl_:setTouchEnable(true)
    	self.weiboUrl_:setOnClickListener(handler(self, self.onClick))
    end
    self:addView(self.weiboUrl_)

    --客户端版本
    y = y - y_dimens
    local util = require("sdk.util.Util")
    package.loaded["sdk.config"] = nil
    local sdkVer = require("sdk.config").version_ or "0"
    local gameVer = sdkVer
    local curPkgVer = MainController:getCurPackageId()
    if require("sdk.file.JJFileUtil"):exist(JJGameDefine.GAME_DIR_TABLE[curPkgVer] .. "/config.lua") then
        package.loaded[JJGameDefine.GAME_DIR_TABLE[curPkgVer] .. ".config"] = nil
        gameVer = require(JJGameDefine.GAME_DIR_TABLE[curPkgVer] .. ".config").version_ or sdkVer
    end
    local buildTimeInt, buildTimeStr = util:getApkBuildTime()
    JJLog.i(TAG, "AboutScene:initView IN buildTimeInt is ", buildTimeInt, " buildTimeStr is ", buildTimeStr)
    local promoterId = PROMOTER_ID or "0"
    params.text = string.format("%sv%s.%s.%s.%s.%s", "客户端版本：", util:getClientVersion(), sdkVer, gameVer, buildTimeInt, promoterId)
    local clientVer_ = jj.ui.JJLabel.new(params)
    clientVer_:setAnchorPoint(ccp(0, 1))
    clientVer_:setPosition(x, y)
    self:addView(clientVer_)
end

function AboutScene:onClick(target)
    JJLog.i(TAG, "onClick")
    local function openUrl(item)
        local url = item:getText()
        JJLog.i(TAG, "openUrl", url)

        if (url) then
            Util:openSystemBrowser(url)
        end
    end

    if target == self.homepageUrl_ then
        openUrl(target)
    elseif target == self.weiboUrl_ then
        openUrl(target)
    elseif target == self.telUrl_ then
        self:callDialog(PHONENUMBER)
    end
end

-- 按下返回键
function AboutScene:onBackPressed()
    JJLog.i(TAG, "onBackPressed12 ",self.callDialog_)
    if self.callDialog_ ~= nil then
        UIUtil.dismissDialog(self.callDialog_)
        self.callDialog_ = nil
    end
end

function AboutScene:callDialog(phonenumber) 
    self.callDialog_ = require("game.ui.view.AlertDialog").new({
        title = "提示",
        prompt = "您即将拨打电话 "..phonenumber,
        theme = self.theme_,
        dimens = self.dimens_,
        backKey = true,
        onDismissListener = function() self.callDialog_ = nil end
    })    

    self.callDialog_:setButton1("确定", function() Util:dial(phonenumber) end)
    self.callDialog_:setCloseButton(nil)
    self.callDialog_:setCanceledOnTouchOutside(true)
    self.callDialog_:show(self)
end

return AboutScene
