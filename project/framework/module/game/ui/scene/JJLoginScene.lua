local JJLoginScene = class("JJLoginScene", import("game.ui.scene.JJGameSceneBase"))

require("game.config.GlobalConfigManager")
require("game.def.ClientSwDef")
local TAG = "JJLoginScene"
local loginData = require("game.data.login.LoginData")
local _onClickMask = nil

-- 声明控件句柄
JJLoginScene.editUserName_ = nil
JJLoginScene.editPassword_ = nil
JJLoginScene.btnPrompt_ = nil
JJLoginScene.split_ = nil

JJLoginScene.btnJJLogin_ = nil
JJLoginScene.btnRegister_ = nil

JJLoginScene.bgMask_ = nil
JJLoginScene.btnAccountList_ = nil
JJLoginScene.accountListView_ = nil

function JJLoginScene:onDestory()
    JJLog.i(TAG, "onDestory")
    JJLoginScene.super.onDestory(self)

    -- 清理句柄
    self.editUserName_ = nil
    self.editPassword_ = nil
    self.btnPrompt_ = nil
    self.split_ = nil

    self.btnJJLogin_ = nil
    self.btnRegister_ = nil

    self.bgMask_ = nil
    self.btnAccountList_ = nil
    self.accountListView_ = nil
end

function JJLoginScene:initView()
    JJLoginScene.super.initView(self)
    self:setThemeStyle(self.THEME_LANDSCAPE_SYTLE)
    self:setBackBtn(true)
    --self:setTitle(self.theme_:getImage("jjlogin/jj_login_title.png"))
    self:setTitle("JJ帐号登录")

    local dimens = self.dimens_
    local scale = dimens.scale_
    local tvFontSize = dimens:getDimens(24) 
    local edFontSize = dimens:getDimens(22)
    local edPlaceHolderSize = dimens:getDimens(24)
    local tvWidth = dimens:getDimens(160)
    local tvHeight = dimens:getDimens(38)
    local tvSize = CCSizeMake(tvWidth, tvHeight)
    local tvAlignRight = dimens:getDimens(275) -- 标识右对齐
    local tvStartTop = dimens.height - dimens:getDimens(120) -- 内容起始点
    local edAlignLeft = dimens:getDimens(285) -- 编辑框左对齐
    local edWidth = dimens:getDimens(435)
    local edHeight = dimens:getDimens(66)
    local lineMargin = dimens:getDimens(90) -- 两行内容的间隔
    local x = dimens.cx + dimens:getDimens(75)
    local y = tvStartTop -- 这一行的 Y 坐标

    local edOffset = {
        paddingLeft = 10,
        paddingRight = 10
    }

    -- 帐号
    self.editUserName_ = jj.ui.JJEditBox.new({
        normal = self.theme_:getImage("common/edit_bg.png"),
        viewSize = CCSize(edWidth, edHeight),
        layout = { paddingLeft = 10, paddingRight = 56 },
        listener = function(event, editbox)
            if event == "ended" then
                local text = editbox:getText()

                local input = "input is nil"
                if (text) then
                    input = text
                end

                JJLog.i(TAG, "editUserName_ text = " .. input)
            end
        end
    })

    --self.editUserName_:setPaddingRight(20)
    self.editUserName_:setAnchorPoint(ccp(0.5, 0.5))
    self.editUserName_:setPosition(x, y)
    --self.editUserName_:setScale(dimens.scale_)
    self.editUserName_:setPlaceHolder("个性帐号/手机号/邮箱")
    self.editUserName_:setPlaceHolderFont("宋体", edPlaceHolderSize)
    self.editUserName_:setPlaceHolderFontColor(ccc3(193, 193, 193))
    self.editUserName_:setFontColor(display.COLOR_BLACK)
    self.editUserName_:setMaxLength(100) --登录用户名有超长的，不做限制
    self.editUserName_:setFont("宋体", edFontSize)
    self.editUserName_:setInputMode(kEditBoxInputModeSingleLine)
    self.editUserName_:setReturnType(kKeyboardReturnTypeDone)
    self:addView(self.editUserName_)

    -- JJ帐号列表管理
    self.btnAccountList_ = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("jjlogin/jj_login_spin_btn_n.png"),
            highlight = self.theme_:getImage("jjlogin/jj_login_spin_btn_d.png"),
        },
        --text = "登录",
        --fontSize = dimens:getDimens(28),
        viewSize = CCSize(70, 70),
    })
    self.btnAccountList_:setScale(dimens.scale_)
    self.btnAccountList_:setAnchorPoint(ccp(0.5, 0.5))
    self.btnAccountList_:setPosition(ccp(x + dimens:getDimens(190), y))
    self.btnAccountList_:setOnClickListener(handler(self, self.onClick))

    y = y - lineMargin

    -- 密码
    self.editPassword_ = jj.ui.JJEditBox.new({
        normal = self.theme_:getImage("common/edit_bg.png"),
        viewSize = CCSize(edWidth, edHeight),
        layout = edOffset,
        listener = function(event, editbox)
            if event == "ended" then
                local text = editbox:getText()

                local input = "input is nil"
                if (text) then
                    input = text
                end

                JJLog.i(TAG, "editPassword_ text = " .. input)
            end
        end
    })
    --self.editPassword_:setPaddingRight(15)
    self.editPassword_:setAnchorPoint(ccp(0.5, 0.5))
    self.editPassword_:setPosition(x, y)
    --self.editPassword_:setScale(dimens.scale_)
    self.editPassword_:setPlaceHolder("请输入密码")
    self.editPassword_:setPlaceHolderFont("宋体", edPlaceHolderSize)
    self.editPassword_:setPlaceHolderFontColor(ccc3(193, 193, 193))
    self.editPassword_:setFontColor(display.COLOR_BLACK)
    self.editPassword_:setMaxLength(19)
    self.editPassword_:setFont("宋体", edFontSize)
    self.editPassword_:setInputMode(kEditBoxInputModeSingleLine)
    self.editPassword_:setReturnType(kKeyboardReturnTypeDone)
    self.editPassword_:setInputFlag(kEditBoxInputFlagPassword)
    self:addView(self.editPassword_)

    -- 登录按钮
    y = y - dimens:getDimens(104)
    self.btnJJLogin_ = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("register/register_btn_long_green_n.png"),
            highlight = self.theme_:getImage("register/register_btn_long_green_d.png"),
            scale9 = true,
        },
        text = "登 录",
        fontSize = dimens:getDimens(28),
        viewSize = CCSize(edWidth, dimens:getDimens(68)),
    })
    --self.btnJJLogin_:setScale(dimens.scale_)
    self.btnJJLogin_:setAnchorPoint(ccp(0.5, 0.5))
    self.btnJJLogin_:setPosition(ccp(x, y))
    self.btnJJLogin_:setOnClickListener(handler(self, self.onClick))
    self:addView(self.btnJJLogin_)

    local postionY = dimens:getDimens(30)
    local centerX = dimens.width - dimens:getDimens(130)
    local leftX = centerX - dimens:getDimens(20)
    local rightX = centerX + dimens:getDimens(20)

    -- 忘记密码提示
    self.btnPrompt_ = jj.ui.JJButton.new({
        text = "忘记密码",
        fontSize = tvFontSize,
        viewSize = CCSize(dimens:getDimens(140), dimens:getDimens(42)),
        color = ccc3(255, 217, 0),
        align = ui.TEXT_ALIGN_RIGHT,
    })
    self.btnPrompt_:setAnchorPoint(ccp(1, 0.5))
    self.btnPrompt_:setPosition(leftX, postionY)
    --self.btnPrompt_:setScale(dimens.scale_)
    self.btnPrompt_:setOnClickListener(handler(self, self.onClick))
    self.btnPrompt_:setVisible(false) --增加clientsw开关控制后，默认不可见
    self:addView(self.btnPrompt_)

    -- 分割线
    local split = jj.ui.JJLabel.new({
        text = "|",
        fontSize = tvFontSize,
        singleLine = true,
        align = ui.TEXT_ALIGN_CENTER,
        viewSize = CCSize(dimens:getDimens(70), dimens:getDimens(36)),
        color = ccc3(255, 217, 0),
    })
    --split:setScale(dimens.scale_)
    split:setAnchorPoint(ccp(0.5, 0.5))
    split:setPosition(centerX, postionY)
    split:setVisible(false)
    self:addView(split)
    self.split_ = split

    -- 注册JJ帐号
    self.btnRegister_ = jj.ui.JJButton.new({
        text = "注册帐号",
        fontSize = tvFontSize,
        viewSize = CCSize(dimens:getDimens(130), dimens:getDimens(36)),
        color = ccc3(255, 217, 0),
        align = ui.TEXT_ALIGN_LEFT,
    })
    self.btnRegister_:setAnchorPoint(ccp(0, 0.5))
    self.btnRegister_:setPosition(rightX, postionY)
    --self.btnRegister_:setScale(dimens.scale_)
    self.btnRegister_:setOnClickListener(handler(self, self.onClick))
    self:addView(self.btnRegister_)

    -- 背景遮罩
    self.bgMask_ = require("game.ui.view.JJFullScreenMask").new()
    self:addView(self.bgMask_)
    self.bgMask_:setVisible(false)
    self.bgMask_:setOnClickListener(handler(self, _onClickMask))

    self:addView(self.btnAccountList_)

    self:createListview(dimens)

    self:_initData(self)
end

function JJLoginScene:loadAndSetLastRecord(recordName, recordPassword)
    local type, name, password = loginData:getLastRecord()
    local setname, setpassword = "", ""

    if type == LOGIN_TYPE_JJ then
        if name ~= nil then
            setname = name
        end

        if password ~= nil then
            setpassword = password
        end
    end

    if (recordName) then
        setname = recordName
    end

    if (recordPassword) then
        setpassword = recordPassword
    end

    if self.editUserName_ ~= nil then
        self.editUserName_:setText(setname)
    end

    if self.editPassword_ ~= nil then
        self.editPassword_:setText(setpassword)
        self.editPassword_:setInputFlag(kEditBoxInputFlagPassword)
    end
end

function JJLoginScene:_initData()
    JJLog.i(TAG, "_initData")

    self:loadAndSetLastRecord(self.controller_.userName_, self.controller_.password_)

    -- local enable = ClientSwDef:isClientSwOpen(self.controller_.params_.packageId, ClientSwDef.CLIENT_SW_REG_TYPE)

    local DynamicDisplayManager = require("game.data.config.DynamicDisplayManager")
    local enable = DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_FIND_PASSWORD)
    if enable then
        self.btnPrompt_:setVisible(true)
        self.split_:setVisible(true)
    end
end

function JJLoginScene:accountListDisplay(enable)
    if (self.accountListView_ ~= nil) then
        self.bgMask_:setVisible(enable)
        self.accountListView_:setVisible(enable)
    end
end

function JJLoginScene:controlListDisplay()
    local datas = loginData:getJJ()
    if datas ~= nil then
        local len = #datas

        if (self.accountListView_ ~= nil and len > 0) then
            local visible = self.accountListView_:isVisible()
            self:accountListDisplay(not visible)
        end
    end
end

function JJLoginScene:getEditorContent()
    return self.editUserName_:getText(), self.editPassword_:getText()
end

function JJLoginScene:onClick(target)
    JJLog.i(TAG, "onClick")
    if target == self.btnJJLogin_ then
        self.controller_:onClickLogin(self.editUserName_:getText(), self.editPassword_:getText())
    elseif target == self.btnPrompt_ then
        self.controller_:onClickRstPwd()
    elseif target == self.btnRegister_ then
        self.controller_:onClickRegiste()
    elseif target == self.btnAccountList_ then
        self:controlListDisplay()
    end
end



--帐号管理listview相关处理
local ACCOUNT_LIST_WIDTH = 436
local ACCOUNT_LIST_TOP_MARGIN = 180
local ACCOUNT_LIST_HEIGHT = 310

local ACCOUNT_LIST_ITEM_WIDTH = ACCOUNT_LIST_WIDTH
local ACCOUNT_LIST_ITEM_HEIGHT = 62

local INFO_FONT_SIZE = 24

local INFO_LABLE_WIDTH = 250
local INFO_LABLE_HIGHT = 30
local INFO_LABLE_LEFT = 20

local INFO_DELETE_BT_WIDTH = 75
local INFO_DELETE_BT_HIGHT = 30
local INFO_DELETE_BT_LEFT = 375


local JJListCell = import("sdk.ui.JJListCell")
local ListCell = class("ListCell", JJListCell)

function ListCell:ctor(params)
    ListCell.super.ctor(self, params)
    self.TAG = "TableCell"
    JJLog.i(self.TAG, "ctor()")

    self:setViewSize(ACCOUNT_LIST_ITEM_WIDTH, ACCOUNT_LIST_ITEM_HEIGHT)

    local index = params.index
    local logindata = params.logindata
    local scene = params.scene
    local mytheme = scene.theme_
    local mydimens = scene.dimens_

    local datas = logindata:getJJ()
    local size = #datas

    --记录当前的参数
    self.index = index
    self.logindata = logindata
    self.scene = scene

    if (size <= 0) or index > size then
        return
    end

    local jjdata = datas[index]

    --创建item显示
    local nameLabel = jj.ui.JJLabel.new({
        text = jjdata.name_,
        fontSize = INFO_FONT_SIZE,
        viewSize = CCSize(INFO_LABLE_WIDTH, INFO_LABLE_HIGHT),
        dimensions = CCSize(INFO_LABLE_WIDTH, INFO_LABLE_HIGHT),
        color = ccc3(148, 181, 255),
    })
    nameLabel:setAnchorPoint(ccp(0, 0.5))
    nameLabel:setPosition(mydimens:getDimens(INFO_LABLE_LEFT), ACCOUNT_LIST_ITEM_HEIGHT / 2)
    self:addView(nameLabel)

    self.delbtn_ = jj.ui.JJButton.new({
        images = {
            normal = mytheme:getImage("jjlogin/jj_login_del_btn_n.png"),
            highlight = mytheme:getImage("jjlogin/jj_login_del_btn_d.png"),
            --scale9 = true
        },
        viewSize = CCSize(50, 50),
    })
    self.delbtn_:setAnchorPoint(ccp(0, 0.5))
    self.delbtn_:setPosition(INFO_DELETE_BT_LEFT, ACCOUNT_LIST_ITEM_HEIGHT / 2)
    --self.delbtn_:setScale(mydimens:getDimens(50)/self.delbtn_:getWidth())
    self.delbtn_:setOnClickListener(handler(self, self.onClick))
    self:addView(self.delbtn_)

    if index < size then
        local div = jj.ui.JJImage.new({
            image = mytheme:getImage("common/common_view_list_div_h.png"),
            scale9 = true,
            viewSize = CCSize(ACCOUNT_LIST_WIDTH - mydimens:getDimens(50), mydimens:getDimens(4))
        })
        div:setAnchorPoint(ccp(0.5, 0.5))
        div:setPosition(ccp(ACCOUNT_LIST_WIDTH / 2, 0))
        self:addView(div)
    end
end

function JJLoginScene:deleteItem(index)
    local datas = loginData:getJJ()
    local len = #datas

    if (index <= len) then
        local data = datas[index]

        loginData:removeRecord(LOGIN_TYPE_JJ, data.name_)
        --self:setListHeight()
        self.accountListAdapter_:notifyDataSetChanged()
        --self.accountListView_:setAdapter(self.accountListAdapter_)
    end

    self:loadAndSetLastRecord()

    datas = loginData:getJJ()
    len = #datas

    if (len == 0) then
        self:accountListDisplay(false)
    end
end

function ListCell:onClick(target)
    JJLog.i(self.TAG, "onClick")
    if target == self.delbtn_ then
        self.scene:deleteItem(self.index)
    end
end


--点击事件
function ListCell:onTouch(event, x, y)
    JJLog.i("ListCell", "onTouch() event=" .. event)
    if event == "began" then
        if self:isTouchInside(x, y) then
            self:setTouchedIn(true)
            return true
        else
            self:setTouchedIn(false)
            return false
        end
    elseif event == "cancelled" then
        self:setTouchedIn(false)
    elseif event == "ended" then
        if self:isTouchedIn() then
            if self:isTouchInside(x, y) then
                local index = self:getIdx()
                JJLog.i("ListCell", "the onClick cell idx=", index)
                self.scene:setInputByIndex(index)
                self.scene:accountListDisplay(false)
            end
        end
    end
end


local ListAdapter = class("ListAdapter", require("sdk.ui.JJBaseAdapter"))
function ListAdapter:ctor(params)
    ListAdapter.super.ctor(self)
    self.TAG = "ListAdapter"

    --记录传入的参数
    local logindata = params.logindata
    local scene = params.scene

    self.logindata = logindata
    self.scene = scene
end

function ListAdapter:getCount()
    local len = 0
    local logindata = self.logindata

    if (logindata) then
        local datas = logindata:getJJ()
        len = #datas
    end

    JJLog.i(self.TAG, "getCount() postion=" .. len)
    return len
end

function ListAdapter:getView(position)
    JJLog.i(self.TAG, "getItem() postion=" .. position)

    return ListCell.new({
        index = position,
        logindata = self.logindata,
        scene = self.scene,
    })
end

_onClickMask = function(self)
    JJLog.i(TAG, "_onClickMask")
    self:accountListDisplay(false)
end

function JJLoginScene:getListHeight()
    local datas = loginData:getJJ()
    local height = 0

    if datas ~= nil then
        height = #datas * ACCOUNT_LIST_ITEM_HEIGHT
    end

    -- 动态设置ListView的高度
    if height > ACCOUNT_LIST_HEIGHT then
        height = ACCOUNT_LIST_HEIGHT
    end

    JJLog.i(TAG, "getListHeight Height = ", height)
    return height
end

function JJLoginScene:setListHeight()
    local height = self:getListHeight()

    self.accountListView_:setViewSize(ACCOUNT_LIST_WIDTH, height)
end

function JJLoginScene:setInputByIndex(index)
    local datas = loginData:getJJ()
    local len = 0

    if datas ~= nil then
        len = #datas
    end

    if (index <= len) then
        local data = datas[index]

        if (data) then
            if data.name_ ~= nil then
                self.editUserName_:setText(data.name_)
            end

            if data.pw_ ~= nil then
                self.editPassword_:setText(data.pw_)
            end
        end
    end
end

function JJLoginScene:createListview(dimens)
    local listHeight = 0

    listHeight = self:getListHeight()

    if listHeight > 0 then
        self.accountListAdapter_ = ListAdapter.new({ logindata = loginData, scene = self })

        self.accountListView_ = jj.ui.JJListView.new({
            viewSize = CCSize(ACCOUNT_LIST_WIDTH, listHeight),
            adapter = self.accountListAdapter_,
            background = {
                image = self.theme_:getImage("common/common_spin_list_bg.png"),
                scale9 = true
            }
        })

        self.accountListView_:setAnchorPoint(ccp(0.5, 1))
        self.accountListView_:setScale(dimens.scale_)
        self.accountListView_:setPosition(ccp(dimens.cx + dimens:getDimens(75), dimens.height - dimens:getDimens(155)))
        self.accountListView_:setVisible(false)
        self:addView(self.accountListView_)
    end
end


return JJLoginScene
