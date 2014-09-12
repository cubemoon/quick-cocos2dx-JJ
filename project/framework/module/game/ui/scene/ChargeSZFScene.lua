local ChargeSZFScene = class("ChargeSZFScene", import("game.ui.scene.JJGameSceneBase"))
local TAG = "ChargeSZFScene"

local pcm = require("game.data.config.PayConfigManager")
local ID_PROMPT = 1
local ID_CARD_NUM = 2
local ID_CARD_PW = 3


local function _onClickCharge(self)
    JJLog.i(TAG, "_onClickCharge")

    local num = self:getViewById(ID_CARD_NUM)
    local pw = self:getViewById(ID_CARD_PW)
    if num and pw then
        self.controller_:onClickCharge(num:getText(), pw:getText())
    end
end

function ChargeSZFScene:initView()
    ChargeSZFScene.super.initView(self)
    self:setThemeStyle(self.THEME_LANDSCAPE_SYTLE)
    self:setBackBtn(true)
    if self.controller_.params_.type == PayDef.CHARGE_TYPE_SZF_CMCC then
        --self:setTitle(self.theme_:getImage("charge/charge_title_szf.png"))
        self:setTitle("神州行充值卡")
    else
        --self:setTitle(self.theme_:getImage("charge/charge_title_wovac.png"))
        self:setTitle("联通充值卡")
    end

--[[
    -- 联系我们
    local btnContactUs = jj.ui.JJButton.new({
            images = {
                normal = self.theme_:getImage("charge/charge_contact_us_n.png"),
            },
        })
    btnContactUs:setAnchorPoint(ccp(1, 1))
    btnContactUs:setPosition(self.dimens_.width - self.dimens_:getDimens(10), self.dimens_.height - self.dimens_:getDimens(10))
    btnContactUs:setScale(self.dimens_.scale_)
    btnContactUs:setOnClickListener(function() self.controller_:onClickContactUs() end)
    self:addView(btnContactUs)
]]
    local payConfig = pcm:getPayConfig(self.controller_.params_.type)
    for i,v in ipairs(payConfig.money) do
        if tonumber(v.cost) == tonumber(self.controller_.params_.amount) then
            self.controller_.item_ = v
            break
        end
    end

    if self.controller_.item_ == nil then
        JJLog.i(TAG, "Can't find charge config")
        return
    end

    -- 提示内容
    local prompt = jj.ui.JJLabel.new({
        fontSize = self.dimens_:getDimens(20),
        color = ccc3(255, 255, 255),
        text = "金币: " .. UserInfo.gold_,
        background = {
            scale9 = true,
            image = self.theme_:getImage("common/common_view_bg.png"),
        },
        viewSize = CCSize(self.dimens_.width - self.dimens_:getDimens(40), self.dimens_:getDimens(24)),
        padding = self.dimens_:getDimens(8)
    })
    prompt:setId(ID_PROMPT)
    prompt:setAnchorPoint(ccp(0.5, 0.5))
    prompt:setPosition(ccp(self.dimens_.cx, self.dimens_.height - self.dimens_:getDimens(100)))
    -- self:addView(prompt)

    local x = self.dimens_.cx
    local y = self.dimens_.height - self.dimens_:getDimens(90)
    local tvHolderFontSize = self.dimens_:getDimens(24)
    local tvFontSize = self.dimens_:getDimens(22)
    local titleParams = {
        fontSize = self.dimens_:getDimens(24),
        color = ccc3(255, 255, 255),
    }
    local contentParams = {
        fontSize = self.dimens_:getDimens(24),
        color = ccc3(255, 217, 0),
    }
    -- 卡名
    titleParams.text = "充值卡类型："
    local label = jj.ui.JJLabel.new(titleParams)
    label:setAnchorPoint(ccp(1, 0.5))
    label:setPosition(ccp(x, y))
    --label:setScale(self.dimens_.scale_)
    self:addView(label)

    if self.controller_.params_.type == PayDef.CHARGE_TYPE_SZF_CMCC then
        contentParams.text = "神州行充值卡"
    else
        contentParams.text = "联通充值卡"
    end
    label = jj.ui.JJLabel.new(contentParams)
    label:setAnchorPoint(ccp(0, 0.5))
    label:setPosition(ccp(x, y))
    --label:setScale(self.dimens_.scale_)
    self:addView(label)

    -- 金额 金币
    y = y - self.dimens_:getDimens(40)
    titleParams.text = "充值卡面额："
    label = jj.ui.JJLabel.new(titleParams)
    label:setAnchorPoint(ccp(1, 0.5))
    label:setPosition(ccp(x, y))
    --label:setScale(self.dimens_.scale_)
    self:addView(label)

    contentParams.text = "￥" .. self.controller_.item_.cost .. "    " .. self.controller_.item_.money .. "金币"
    label = jj.ui.JJLabel.new(contentParams)
    label:setAnchorPoint(ccp(0, 0.5))
    label:setPosition(ccp(x, y))
    --label:setScale(self.dimens_.scale_)
    self:addView(label)

    -- 充值卡号
    y = y - self.dimens_:getDimens(50)
    titleParams.text = "充值卡卡号："
    label = jj.ui.JJLabel.new(titleParams)
    label:setAnchorPoint(ccp(1, 0.5))
    label:setPosition(ccp(x, y))
    --label:setScale(self.dimens_.scale_)
    self:addView(label)

    local EDIT_WIDTH = self.dimens_:getDimens(320)
    local EDIT_HEIGHT = self.dimens_:getDimens(60)
    self.editNumber = jj.ui.JJEditBox.new({
        normal = self.theme_:getImage("common/edit_bg.png"),
        viewSize = CCSize(EDIT_WIDTH, EDIT_HEIGHT),
        layout = {
            paddingLeft = 14,
            paddingRight = 5
        },
        listener = function(event, editbox)
            if event == "ended" then
                local text = editbox:getText()

                local input = "input is nil"
                if (text) then
                    input = text
                end

                JJLog.i(TAG, "card number =", input)
            end
        end
    })

    self.editNumber:setId(ID_CARD_NUM)
    self.editNumber:setAnchorPoint(ccp(0, 0.5))
    self.editNumber:setPosition(x, y)
    self.editNumber:setPlaceHolder("充值卡卡号")
    self.editNumber:setPlaceHolderFont("", tvHolderFontSize)
    self.editNumber:setPlaceHolderFontColor(ccc3(193, 193, 193))
    self.editNumber:setFontColor(display.COLOR_BLACK)
    self.editNumber:setMaxLength(50)
    self.editNumber:setFont("宋体", tvFontSize)
    self.editNumber:setInputMode(kEditBoxInputModeNumeric)
    self.editNumber:setReturnType(kKeyboardReturnTypeDone)
    --self.editNumber:setScale(self.dimens_.scale_)
    self:addView(self.editNumber)

    -- 密码
    y = y - self.dimens_:getDimens(80)
    titleParams.text = "充值卡密码："
    label = jj.ui.JJLabel.new(titleParams)
    label:setAnchorPoint(ccp(1, 0.5))
    label:setPosition(ccp(x, y))
    --label:setScale(self.dimens_.scale_)
    self:addView(label)

    self.editPassword = jj.ui.JJEditBox.new({
        normal = self.theme_:getImage("common/edit_bg.png"),
        viewSize = CCSize(EDIT_WIDTH, EDIT_HEIGHT),
        layout = {
            paddingLeft = 14,
            paddingRight = 5
        },
        listener = function(event, editbox)
            if event == "ended" then
                local text = editbox:getText()

                local input = "input is nil"
                if (text) then
                    input = text
                end

                JJLog.i(TAG, "password text = ", input)
            end
        end
    })

    self.editPassword:setId(ID_CARD_PW)
    self.editPassword:setAnchorPoint(ccp(0, 0.5))
    self.editPassword:setPosition(x, y)
    self.editPassword:setPlaceHolder("充值卡密码")
    self.editPassword:setPlaceHolderFont("宋体", tvHolderFontSize)
    self.editPassword:setPlaceHolderFontColor(ccc3(193, 193, 193))
    self.editPassword:setFontColor(display.COLOR_BLACK)
    self.editPassword:setMaxLength(50)
    self.editPassword:setFont("宋体", tvFontSize)
    self.editPassword:setInputMode(kEditBoxInputModeNumeric)
    self.editPassword:setReturnType(kKeyboardReturnTypeDone)
    --self.editPassword:setScale(self.dimens_.scale_)
    self:addView(self.editPassword)

    -- 提示
    local x_start = self.dimens_.cx - label:getBoundingBoxWidth() 
    y = y - self.dimens_:getDimens(60)
    titleParams.text = "充值卡卡号："
    label = jj.ui.JJLabel.new({
        fontSize = self.dimens_:getDimens(20),
        color = ccc3(255, 192, 0),
        --text = "充值前请确认充值卡面额和实际的是否一致，否则会导致消费不成功和余额丢失。"
        text = "请确认充值卡面额和实际的是否一致，避免余额丢失。"
    })
    label:setAnchorPoint(ccp(0, 0.5))
    label:setPosition(ccp(x_start, y))
    --label:setScale(self.dimens_.scale_)
    self:addView(label)

    -- 充值按钮
    y = y - self.dimens_:getDimens(70)
    local btn = jj.ui.JJButton.new({
        images = {
            scale9 = true,
            normal = self.theme_:getImage("register/register_btn_long_green_n.png"),
            highlight = self.theme_:getImage("register/register_btn_long_green_d.png"),
            viewSize = CCSize(460, 66),
        },
        --fontSize = 28,
        color = ccc3(255, 255, 255),
        --text = "确认充值",
        viewSize = CCSize(460, 66)
    })
    btn:setAnchorPoint(ccp(0, 0.5))
    btn:setPosition(ccp(x_start, y))
    btn:setScale(self.dimens_.scale_)
    btn:setOnClickListener(handler(self, _onClickCharge))
    self:addView(btn)

    local btnText = jj.ui.JJLabel.new({
            text = "确认充值",            
            fontSize = self.dimens_:getDimens(28),
       })
    btnText:setAnchorPoint(ccp(0.5, 0.5))
    btnText:setPosition(x_start + btn:getBoundingBoxWidth() * self.dimens_.scale_ / 2 , y)
    self:addView(btnText)

    self:_initData(self)
end  

-- 用于注册成功之后，清除之前的输入
function ChargeSZFScene:clearBeforeInput()
    -- 保存编辑后的参数
    local number = nil
    local password = nil

    if self.editNumber ~= nil then
        number = self.editNumber:setText("")
    end
    if self.editPassword ~= nil then
        password = self.editPassword:setText("")
    end   

    MainController:setTable(TAG, {
        number = number,
        password = password,
    })
end

function ChargeSZFScene:_initData()
    JJLog.i(TAG, "_initData")
    local param = MainController:getTable(TAG)
  
    if param ~= nil then
        local number = param.number
        if self.editNumber ~= nil and number ~= nil and number ~= "" then
            self.editNumber:setText(number)
        end
        if self.editPassword ~= nil and param.password ~= nil then
            self.editPassword:setText(param.password)
        end        
    end
end

function ChargeSZFScene:onDestory()
     ChargeSZFScene.super.onDestory(self)
      -- 保存编辑后的参数
    local number = nil
    local password = nil
    if self.editNumber ~= nil then
        number = self.editNumber:getText()
    end 
    if self.editPassword ~= nil then
        password = self.editPassword:getText()
    end 

    MainController:setTable(TAG, {
        number = number,
        password = password,
    })

    self.editNumber = nil
    self.editPassword = nil
end

function ChargeSZFScene:onExit()
    ChargeSZFScene.super.onExit(self)
    JJLog.i(TAG, "onExit")
      -- 保存编辑后的参数
    local number = nil
    local password = nil
    if self.editNumber ~= nil then
        number = self.editNumber:setText("")
    end
    if self.editPassword ~= nil then
        password = self.editPassword:setText("")
    end   

    MainController:setTable(TAG, {
        number = number,
        password = password,
    })

    self.editNumber = nil
    self.editPassword = nil
end
return ChargeSZFScene
