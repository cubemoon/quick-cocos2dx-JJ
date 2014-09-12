local UpgradeScene = class("UpgradeScene", function()
    return display.newScene("UpgradeScene")
end)
local TAG = "UpgradeScene"

local controller_ = require("upgrade.controller.UpgradeController")

local def_ = require("upgrade.def.UpgradeDefine")

local wScale_, hScale_, scale_, cx_, cy_

local PROGRESS_ICON = 3333
local PROGRESS_BAR_WIDTH = 400
local PROGRESS_BAR_HEIGHT = 40
local PROGRESS_BAR_WIDTH_MIN = 40

local function _getDimens(px)
    return scale_ * px
end

-- 计算当前的缩放比例
local function _initDisplay()
    local size = CCDirector:sharedDirector():getOpenGLView():getFrameSize()

    local width, height
    if size.width > size.height then
        width = size.height
        height = size.width
    else
        width = size.width
        height = size.height
    end
    wScale_ = width / 480
    hScale_ = height / 854

    if (wScale_ > hScale_) then
        scale_ = hScale_
    else
        scale_ = wScale_
    end

    cx_ = width / 2
    cy_ = height / 2

    print(TAG, "_initDisplay, size w=", size.width, ", h=", size.height, ", scale_=", scale_, ", wScale_=", wScale_, ", hScale_=", hScale_)
end

function UpgradeScene:ctor()

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "requestPortrait"
        local args = {}
        local sig = "()V"
        luaj.callStaticMethod(className, methodName, args, sig)
    end

    print(TAG, "UpgradeScene:ctor")
    _initDisplay()

    -- 注册响应back键
    local layer = display.newLayer()
    layer:addKeypadEventListener(function(event)
        if event == "back" then
            if self.alertShowing_ ~= true then
                self:showAlertDialog({ title = "退出提示", text = "是否退出应用？", btnText1 = "退出", close = true, id1 = def_.BUTTON_EXIT, closeId = def_.BUTTON_HIDE_DIALOG })
                self.alertShowing_ = true
            end
        end
    end)
    self:addChild(layer)
    layer:setKeypadEnabled(true)

    -- 背景
    local bg = display.newSprite("img/upgrade/bg.jpg", cx_, cy_)
    bg:setScaleX(wScale_)
    bg:setScaleY(hScale_)
    self:addChild(bg)

    if require("upgrade.util.UpgradeUtil"):isKuaiya() then
        --kuaiya logo
        local kuaiyaLogo = display.newSprite("img/upgrade/kuaiya_logo.png")
        kuaiyaLogo:setPosition(cx_ - _getDimens(90), cy_ + _getDimens(120))
        kuaiyaLogo:setScale(scale_)
        self:addChild(kuaiyaLogo)

        -- Logo
        local logo = display.newSprite("img/upgrade/logo.png")
        logo:setPosition(cx_ + _getDimens(120), cy_ + _getDimens(100))
        logo:setScale(scale_ * 0.7)
        self:addChild(logo)
    else
        -- Logo
        local logo = display.newSprite("img/upgrade/logo.png")
        logo:setPosition(cx_, cy_ + _getDimens(100))
        logo:setScale(scale_)
        self:addChild(logo)
    end

    -- txt
    local txt = display.newSprite("img/upgrade/logo_txt.png")
    txt:setAnchorPoint(ccp(0.5, 0))
    txt:setPosition(cx_, _getDimens(120))
    txt:setScale(scale_)
    self:addChild(txt)

    -- 提示语句
    self.prompt_ = ui.newTTFLabel({
        text = "玩命加载中...",
        size = 18 * scale_,
    })
    self.prompt_:setAnchorPoint(ccp(0.5, 0.5))
    self.prompt_:setPosition(cx_, cy_)
    --self.prompt_:setScale(scale_)
    self:addChild(self.prompt_)

    -- 进度框
    local icon = display.newSprite("img/upgrade/icon_loading.png")
    icon:setTag(PROGRESS_ICON)
    icon:setAnchorPoint(ccp(0.5, 0.5))
    icon:setPosition(cx_ * 0.7, cy_)
    icon:runAction(CCRepeatForever:create(CCRotateTo:create(1, 720)))
    self:addChild(icon)

    -- 进度
    local y = cy_
    self.progressMask_ = display.newScale9Sprite("img/upgrade/progress_bar_bg.png", cx_ - _getDimens(PROGRESS_BAR_WIDTH / 2), y, CCSize(PROGRESS_BAR_WIDTH, PROGRESS_BAR_HEIGHT))
    self.progressMask_:setAnchorPoint(ccp(0, 0.5))
    self.progressMask_:setScale(scale_)
    self.progressMask_:setCapInsets(CCRect(20, 0, 1, 40))
    self:addChild(self.progressMask_)
    self.progressMask_:setVisible(false)

    self.progress_ = display.newScale9Sprite("img/upgrade/progress_bar.png", cx_ - _getDimens(PROGRESS_BAR_WIDTH / 2), y, CCSize(PROGRESS_BAR_WIDTH, PROGRESS_BAR_HEIGHT))
    self.progress_:setAnchorPoint(ccp(0, 0.5))
    self.progress_:setScale(scale_)
    self.progress_:setCapInsets(CCRect(20, 4, 1, 38))
    self:addChild(self.progress_)
    self.progress_:setVisible(false)

    self.progressPrompt_ = ui.newTTFLabel({
        text = "下载中...",
        size = 16 * scale_,
        color = display.COLOR_BLACK,
    })
    self.progressPrompt_:setAnchorPoint(ccp(0.5, 0.5))
    self.progressPrompt_:setPosition(cx_, y)
    --self.progressPrompt_:setScale(scale_)
    self:addChild(self.progressPrompt_)
    self.progressPrompt_:setVisible(false)

    -- 后台更新按钮
    self.backUpgradeBtn = ui.newImageMenuItem({
        image = "img/upgrade/btn_yes_n.png",
        imageSelected = "img/upgrade/btn_yes_d.png",
        listener = function()
            controller_:setInstallEnable(false)
            self:refreshGameItems()
            self.backUpgradeBtn:setVisible(false)
        end,
    })
    self.backUpgradeBtn:setPosition(ccp(cx_, cy_ - _getDimens(120)))
    local text = ui.newTTFLabel({
        text = "后台更新",
    })
    text:setAnchorPoint(ccp(0.5, 0.5))
    text:setPosition(ccp(100, 36))
    self.backUpgradeBtn:addChild(text)
    self:showEnterButton(false)

    self:addChild(ui.newMenu({ self.backUpgradeBtn }))

end

function UpgradeScene:onEnter()
    if UPGRADE_SWITCH == nil then
        UPGRADE_SWITCH = true
    end
    if device.platform == "mac" or device.platform == "windows" then
        UPGRADE_SWITCH = false
    end
    if UPGRADE_SWITCH == true then
        -- 默认允许安装apk，点击后台更新按钮后置为false
        controller_:setInstallEnable(true)
        local show = CCUserDefault:sharedUserDefault():getBoolForKey("show_promoter_warn", true)
        if controller_:checkWarnPromoters() and show then
            local text = string.format("您将要开始使用的应用是由竞技世界开发、拥有、运营的JJ斗地主。本司不承担该应用任何方面的任何责任，包括但不限于其性能、知识产权、安全、支持、服务、内容及收费等。该应用在使用过程中可能产生的数据流量或WLAN费用请参看相关运营商公布的收费标准。")
            self:showAlertDialog({ text = text, btnText1 = "确定", btnText2 = "退出", id1 = def_.BUTTON_PROMOTER_ENTER, id2 = def_.BUTTON_PROMOTER_EXIT, checkbox = "下次不再显示" })
            return
        end
        if not controller_:checkUpgrade(handler(self, self.checkUpgradeCallback)) then
            --self:registerForeground()
            local gameItemController = require("upgrade.controller.GameItemController")
            gameItemController:initClassify(1)
            self:runProjectApp()
        end
    else
        if require("upgrade.util.UpgradeUtil"):getNetworkType() == 0 then
            local gameItemController = require("upgrade.controller.GameItemController")
            gameItemController:initClassify(1)
            self:runProjectApp()
        else
            self:refreshGameItems()
        end
    end
end

function UpgradeScene:refreshGameItems()
    local msg = "玩命加载中..."
    self:updateMessage(msg, true)
    self.progress_:setVisible(false)
    self.progressMask_:setVisible(false)
    self.progressPrompt_:setVisible(false)

    -- 更新游戏节点信息
    local gameItemController = require("upgrade.controller.GameItemController")
    gameItemController:refreshGameItems(function(result)
        if not result then
            print(TAG, "refreshGameItems fail!")
        end
        gameItemController:initClassify(1) -- root node id is 1
        if UPGRADE_SWITCH == false then
            self:runProjectApp()
            return
        end
        if RUNNING_MODE == RUNNING_MODE_GAME then
            -- 单包模式，初始化更新变量
            local games = gameItemController:getGameItems()
            local updateSingle = false
            for i = 1, #games do
                local curPkgId = CURRENT_PACKAGE_ID
                local lordunions = { 5, 6 }
                for i=1,#lordunions do
                    if CURRENT_PACKAGE_ID == lordunions[i] then
                        curPkgId = 2
                    end
                end
                if tonum(games[i].game_id) == curPkgId then
                    local ver = require(games[i].packagename .. "/config").version_
                    if games[i].version ~= nil then
                        print(TAG, "single ver : ", ver, " config version : ", tonum(games[i].version.version_id))
                        if tonum(games[i].version.version_id) > ver then
                            self.singleData_ = { url = games[i].version.file_name, md5 = games[i].version.hash_code, callback = handler(self, self.upgradeSingleCallback), id = games[i].id, uptime = games[i].utime }
                            updateSingle = true
                            local zipSize = tonum(games[i].version.file_size)
                            if not controller_:checkUpgradeZip(zipSize) then
                                controller_:startUpgradeSingle(self.singleData_)
                            else
                                local text = string.format("需要下载更新大小为%sM的更新补丁,建议在wifi状态下进行更新，要继续下载请点击\'升级\'按钮。", zipSize/(1024*1024))
                                self:showAlertDialog({ title = "升级提示", text = text, btnText1 = "升级", btnText2 = "退出游戏", id1 = def_.BUTTON_UPGRADE_SIG, id2 = def_.BUTTON_EXIT })
                            end
                        else
                            self:runProjectApp()
                            return
                        end
                    end
                end
            end
            if not updateSingle then
                self:runProjectApp()
            end
        else
            -- 大厅模式
            self:runProjectApp()
        end
    end)
end

function UpgradeScene:checkUpgradeCallback(responseTable)
    print(TAG, "checkUpgradeCallback IN")

    local error = responseTable["error"]

    if error then
        -- TODO 网络连接出现问题，继续进入大厅
        print(TAG, "checkUpgradeCallback error : ", error)
    end

    self.responseData_ = responseTable or {}
    local clientData = responseTable["ApkVersion"]
    local scriptData = responseTable["ZipVersion"]

    -- 如果超过7天未登录游戏，除非强生，否则不进行升级操作
    local save = CCUserDefault:sharedUserDefault()
    local recordTime = save:getIntegerForKey("update_login_time", 0)
    local currentTime = getCurrentSecond()
    local clientCsy, scriptCsy = true, true
    print(TAG, "currentTime : ", currentTime, " and recordTime : ", recordTime)
    if tonum(currentTime) - tonum(recordTime) < 7 * 24 * 3600 or recordTime == 0 then
        if clientData then clientCsy = tonum(clientData["Compulsory"]) == 1 end
        --if scriptData then scriptCsy = tonum(scriptData["Compulsory"]) == 1 end
    end
    if recordTime == 0 then
        save:setIntegerForKey("update_login_time", currentTime)
        save:flush()
    end

    -- 需要整包升级，弹出对话框询问用户
    if clientData and clientCsy then
        if not controller_:checkStorageAvailable() then
            local text = "存储空间不足，请检查并清理SD卡以及本地存储空间！"
            self:showAlertDialog({ text = text, btnText1 = "确定", btnText2 = "退出游戏", id1 = def_.BUTTON_EXIT, id2 = def_.BUTTON_EXIT })
            return
        end
        local compulsory = clientData["Compulsory"] == 1
        local btnText, btnId
        if compulsory then
            btnText = "退出游戏"
            btnId = def_.BUTTON_EXIT
        else
            btnText = "进入游戏"
            btnId = def_.BUTTON_APK_CANCEL
        end
        self:showAlertDialog({ title = "升级提示", text = clientData["Comment"] or "更新APK？", btnText1 = "升级", btnText2 = btnText, id1 = def_.BUTTON_UPGRADE_APK, id2 = btnId })
        -- 非强生apk显示后台更新按钮
        --if not compulsory then self:showEnterButton(true) end
    -- 需要脚本包升级，显示升级状态
    elseif scriptData and scriptCsy then
        self.restart_ = false
        for i=1,#scriptData do
            if scriptData[i].isrestart == 1 then
                self.restart_ = true
            end
        end
        local params = { index = 1, data = scriptData, callback = handler(self, self.upgradeScriptCallback) }
        local zipSize = tonum(scriptData.FileSize)
        if not controller_:checkUpgradeZip(zipSize) then
            controller_:startUpdateScript(params)
        else
            local text = string.format("需要下载更新大小为%sM的更新补丁,建议在wifi状态下进行更新，要继续下载请点击\'升级\'按钮。", zipSize/(1024*1024))
            self:showAlertDialog({ title = "升级提示", text = text, btnText1 = "升级", btnText2 = "退出游戏", id1 = def_.BUTTON_UPGRADE_LUA, id2 = def_.BUTTON_EXIT })
        end
    -- 不需要升级，进入登陆界面
    else
        --controller_:recordUpgradeError({ err_type = UpgradeDefine.MSG_UPDATE_SUCCESS })
        self:refreshGameItems()
    end
end

--[[
    更新脚本的响应回调，用于通知场景更新指定的对话框
    @param type : 消息类型，value : 消息值
]]
function UpgradeScene:upgradeScriptCallback(type, value)
    print(TAG, "updateScriptCallback type : ", type, " value : ", value)
    if type == UpgradeDefine.TYPE_UPDATE_END then
        if self.restart_ == true then
            JJUpdateManager:instance():restartApplicationLua()
        else
            -- 更新游戏节点
            self:refreshGameItems()
        end
    elseif type == UpgradeDefine.TYPE_UPDATE_RESULT then
        if value == UpgradeDefine.MSG_UPDATE_SUCCESS then
            -- 更新成功
            print("updateScriptCallback success !!!")
            local msg = string.format("正在下载更新包 %s%%", 100)
            self:updateProgress(100, msg)
        else
            if value == UpgradeDefine.MSG_ERROR_UNCOMPRESS then
                local text = "更新数据解压发生错误，请检查内存是否充足，建议内存充足后清除应用数据重新更新。"
                self:showAlertDialog({ text = text, btnText1 = "重试更新", btnText2 = "退出游戏", id1 = def_.BUTTON_CLEAR_RESTART, id2 = def_.BUTTON_EXIT })
            else
                -- 非不可逆的更新失败，进入游戏，用户无感知
                self:runProjectApp()
            end
        end
    elseif type == UpgradeDefine.TYPE_UPDATE_PROGRESS then
        local msg = string.format("正在下载更新包 %s%%", value)
        self:updateProgress(value, msg)
    end
end

--[[
    更新Apk的响应回调，用于通知场景更新指定的对话框
    @param type : 消息类型，value : 消息值
]]
function UpgradeScene:upgradeApkCallback(type, value)
    if type == UpgradeDefine.TYPE_UPDATE_RESULT then
        if value == UpgradeDefine.MSG_UPDATE_SUCCESS then
            print("upgradeApkCallback success !!!")
            local msg = string.format("正在下载Apk安装包 %s%%", 100)
            self:updateProgress(100, msg)
        else
            local text = "更新发生错误！"
            if value == UpgradeDefine.MSG_ERROR_MD5 then
                text = "更新数据校验发生错误，如重新启动游戏依然发生该错误，建议清除应用数据重新更新。"
            elseif value == UpgradeDefine.MSG_ERROR_DOWNLOAD then
                text = "更新数据下载发生错误，请检查当前网络状态是否良好。"
            end
            local clientData = self.responseData_["ApkVersion"]
            local compulsory = clientData["Compulsory"] == 1
            local btnText, btnId = "取消", def_.BUTTON_ENTER_SIG
            if compulsory then
                btnText, btnId = "退出", def_.BUTTON_EXIT
            end
            self:showAlertDialog({ text = text, btnText1 = "重试", btnText2 = btnText, id1 = def_.BUTTON_UPGRADE_APK, id2 = btnId })
        end
    elseif type == UpgradeDefine.TYPE_UPDATE_PROGRESS then
        local msg = string.format("正在下载Apk安装包 %s%%", value)
        self:updateProgress(value, msg)
    end
end

function UpgradeScene:upgradeSingleCallback(type, value)
    if type == UpgradeDefine.TYPE_UPDATE_RESULT then
        if value == UpgradeDefine.MSG_UPDATE_SUCCESS then
            local msg = string.format("正在下载游戏更新包 %s%%", 100)
            self:updateProgress(100, msg)
            self:runProjectApp()
        else
            -- local text = "更新发生错误！"
            -- if value == UpgradeDefine.MSG_ERROR_MD5 then
            --     text = "更新数据校验发生错误，如重新启动游戏依然发生该错误，建议清除应用数据重新更新。"
            -- elseif value == UpgradeDefine.MSG_ERROR_DOWNLOAD then
            --     text = "更新数据下载发生错误，请检查当前网络状态是否良好。"
            -- end
            -- self:showAlertDialog({ text = text, btnText1 = "进入大厅", btnText2 = "退出游戏", id1 = def_.BUTTON_ENTER_SIG, id2 = def_.BUTTON_EXIT })

            if value == UpgradeDefine.MSG_ERROR_UNCOMPRESS then
                local text = "更新数据解压发生错误，请检查内存是否充足，建议内存充足后清除应用数据重新更新。"
                self:showAlertDialog({ text = text, btnText1 = "重试更新", btnText2 = "退出游戏", id1 = def_.BUTTON_CLEAR_RESTART, id2 = def_.BUTTON_EXIT })
            else
                -- 非不可逆的更新失败，进入游戏，用户无感知
                self:runProjectApp()
            end
        end
    elseif type == UpgradeDefine.TYPE_UPDATE_PROGRESS then
        local msg = string.format("正在下载游戏更新包 %s%%", value)
        self:updateProgress(value, msg)
    end
end

function UpgradeScene:updateProgress(value, msg)
    print(TAG, "updateProgress value=", value, ", msg=", msg)
    if self.progress_ ~= nil then

        self:updateMessage("", false)

        if not self.progress_:isVisible() then
            self.progress_:setVisible(true)
        end
        if self.progressMask_ ~= nil and not self.progressMask_:isVisible() then
            self.progressMask_:setVisible(true)
        end
        if self.progressPrompt_ ~= nil and not self.progressPrompt_:isVisible() then
            self.progressPrompt_:setVisible(true)
        end
        if value <= 0 then
            value = 1
        end
        if value > 100 then
            value = 100
        end
        local width = value * (PROGRESS_BAR_WIDTH - PROGRESS_BAR_WIDTH_MIN) / 100 + PROGRESS_BAR_WIDTH_MIN
        self.progress_:setContentSize(CCSize(width, PROGRESS_BAR_HEIGHT))
        self.progressPrompt_:setString(msg)
    end
end

function UpgradeScene:updateMessage(msg, showIcon)
    local icon = self:getChildByTag(PROGRESS_ICON)
    if icon ~= nil then
        showIcon = showIcon or false
        icon:setVisible(showIcon)
    end
    if self.prompt_ ~= nil then
        self.prompt_:setString(msg)
    end
end

function UpgradeScene:showEnterButton(show)
    -- TODO 根据需求，不现实后台更新按钮
    --self.backUpgradeBtn:setVisible(show)
    self.backUpgradeBtn:setVisible(false)
end

--[[
    显示提示对话框
    @params {
                title        对话框标题内容
                text         对话框信息内容
                btnText1     Button1的文字内容
                btnText2     Button2的文字内容
                id1          Button1的id
                id2          Button2的id
            }
]]
function UpgradeScene:showAlertDialog(params)
    local dialog = nil
    -- 对话框按键点击回调
    local function onClick(id)
        print(TAG, "showAlertDialog button id : ", id)
        if id == def_.BUTTON_ENTER then
            self:refreshGameItems()
        elseif id == def_.BUTTON_ENTER_SIG then
            self:runProjectApp()
        elseif id == def_.BUTTON_EXIT then
            os.exit()
        elseif id == def_.BUTTON_NET_SETTING then
            local util = require("upgrade.util.UpgradeUtil")
            util:callNetworkSetting()
        elseif id == def_.BUTTON_UPGRADE_APK then
            local clientData = self.responseData_["ApkVersion"]
            local params = { url = clientData["FileURL"], md5 = clientData["HashCode"], callback = handler(self, self.upgradeApkCallback) }
            controller_:startUpdateApk(params)
        elseif id == def_.BUTTON_APK_CANCEL then
            local scriptData = self.responseData_["ZipVersion"]
            if scriptData then
                local params = { index = 1, data = scriptData, callback = handler(self, self.upgradeScriptCallback) }
                local zipSize = tonum(scriptData.FileSize)
                if not controller_:checkUpgradeZip(zipSize) then
                    controller_:startUpdateScript(params)
                else
                    local text = string.format("需要下载更新大小为%sM的更新补丁,建议在wifi状态下进行更新，要继续下载请点击\'升级\'按钮。", zipSize/(1024*1024))
                    self:showAlertDialog({ text = text, btnText1 = "升级", btnText2 = "退出游戏", id1 = def_.BUTTON_UPGRADE_LUA, id2 = def_.BUTTON_EXIT })
                end
            else
                self:refreshGameItems()
            end
        elseif id == def_.BUTTON_UPGRADE_LUA then
            local scriptData = self.responseData_["ZipVersion"]
            local params = { index = 1, data = scriptData, callback = handler(self, self.upgradeScriptCallback) }
            controller_:startUpdateScript(params)
        elseif id == def_.BUTTON_UPGRADE_SIG then
            if self.singleData_ ~= nil and self.controller_ ~= nil then
                controller_:startUpgradeSingle(self.singleData_)
            end
        elseif id == def_.BUTTON_CLEAR_RESTART then
            if device.platform ~= "windows" then
                local save = CCUserDefault:sharedUserDefault()
                save:setStringForKey("game_uptime", "0")
                save:flush()
                os.execute("rm -r " .. device.writablePath .. "update")
                os.execute("rm -r " .. device.writablePath .. "temp")
                JJUpdateManager:instance():restartApplicationLua()
            end
        elseif id == def_.BUTTON_HIDE_DIALOG then
            self.alertShowing_ = false
        elseif id == def_.BUTTON_PROMOTER_ENTER then
            if dialog ~= nil then
                local show = not dialog:isChecked() or false
                CCUserDefault:sharedUserDefault():setBoolForKey("show_promoter_warn", show)
                CCUserDefault:sharedUserDefault():flush()
            end
            if not controller_:checkUpgrade(handler(self, self.checkUpgradeCallback)) then
                local gameItemController = require("upgrade.controller.GameItemController")
                gameItemController:initClassify(1)
                self:runProjectApp()
            end
        elseif id == def_.BUTTON_PROMOTER_EXIT then
            if dialog ~= nil then
                --local show = not dialog:isChecked() or false
                --CCUserDefault:sharedUserDefault():setBoolForKey("show_promoter_warn", show)
                --CCUserDefault:sharedUserDefault():flush()
            end
            os.exit()
        end
    end

    -- 显示对话框
    dialog = require("upgrade.ui.UpgradeAlertDialog").new({
        cx = cx_,
        cy = cy_,
        scale = scale_,
        title = params.title or "提示",
        prompt = params.text or "",
        btn1 = params.btnText1 or "确定",
        id1 = params.id1,
        btn2 = params.btnText2 or "取消",
        id2 = params.id2,
        close = params.close or false,
        closeId = params.closeId,
        checkbox = params.checkbox
    })
    self:addChild(dialog, 1000)
    dialog:setListener(onClick)
end

--[[
-- 显示加载对话框
-- params = {
--              show,  bool变量，是否显示对话框
--          }
--]]
function UpgradeScene:showProgressDialog(params)
    local show = params.show or false
    if show then
        self.progressDialog_ = require("upgrade.ui.UpgradeLoadingDialog").new({
            cx = cx_,
            cy = cy_,
            scale = scale_,
        })
        self:addChild(self.progressDialog_, 1000)
    else
        if self.progressDialog_ ~= nil then
            self.progressDialog_:dismiss()
            self.progressDialog_ = nil
        end
    end
end

function UpgradeScene:runProjectApp()
    print(TAG, "runProjectApp IN")
    --self:unregisterForeground()
    require(PROJECT_NAME .. ".ProjectApp"):run()
end

function UpgradeScene:registerForeground()
    local notificationCenter = CCNotificationCenter:sharedNotificationCenter()
    notificationCenter:registerScriptObserver(self, function()
        print(TAG, " APP_ENTER_FOREGROUND callback")
        if TAG == "UpgradeScene" then
            -- 初始化预制的节点信息
            local gameItemController = require("upgrade.controller.GameItemController")
            gameItemController:initClassify(1)
            self:runProjectApp()
        end
    end, "APP_ENTER_FOREGROUND")
end

function UpgradeScene:unregisterForeground()
    local notificationCenter = CCNotificationCenter:sharedNotificationCenter()
    --notificationCenter:unregisterScriptObserver(self, "APP_ENTER_BACKGROUND")
    notificationCenter:unregisterScriptObserver(self, "APP_ENTER_FOREGROUND")
end

return UpgradeScene
