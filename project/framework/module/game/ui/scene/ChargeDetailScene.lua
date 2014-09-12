local ChargeDetailScene = class("ChargeDetailScene", import("game.ui.scene.JJGameSceneBase"))
local ChargeListAdapter = class("ChargeListAdapter", import("sdk.ui.JJBaseAdapter"))
local ChargeListCell = class("ChargeListCell", import("sdk.ui.JJListCell"))

local TAG = "ChargeDetailScene"

local pcm = require("game.data.config.PayConfigManager")

local TITLE = {}
TITLE[PayDef.CHARGE_TYPE_G10086_SMS_API] = "charge/charge_title_sms.png"
TITLE[PayDef.CHARGE_TYPE_WOVAC_SMS] = "charge/charge_title_sms.png"
TITLE[PayDef.CHARGE_TYPE_EGAME_SMS] = "charge/charge_title_sms.png"
TITLE[PayDef.CHARGE_TYPE_UMPAY_SMS] = "charge/charge_title_sms.png"
TITLE[PayDef.CHARGE_TYPE_TELECOM_SMS] = "charge/charge_title_sms.png"
TITLE[PayDef.CHARGE_TYPE_G10086_SMS] = "charge/charge_title_sms.png"
TITLE[PayDef.CHARGE_TYPE_ALIPAY] = "charge/charge_title_alipay.png"
TITLE[PayDef.CHARGE_TYPE_UMPAY_EBANK] = "charge/charge_title_umpay.png"
TITLE[PayDef.CHARGE_TYPE_SZF_CMCC] = "charge/charge_title_szf.png"
TITLE[PayDef.CHARGE_TYPE_SZF_UNICOM] = "charge/charge_title_wovac.png"
TITLE[PayDef.CHARGE_TYPE_IOS] = "charge/charge_title_charge.png"

local TITLETEXT = {}
TITLETEXT[PayDef.CHARGE_TYPE_G10086_SMS_API] = "短信充值"
TITLETEXT[PayDef.CHARGE_TYPE_WOVAC_SMS] = "短信充值"
TITLETEXT[PayDef.CHARGE_TYPE_EGAME_SMS] = "短信充值"
TITLETEXT[PayDef.CHARGE_TYPE_UMPAY_SMS] = "短信充值"
TITLETEXT[PayDef.CHARGE_TYPE_TELECOM_SMS] = "短信充值"
TITLETEXT[PayDef.CHARGE_TYPE_G10086_SMS] = "短信充值"
TITLETEXT[PayDef.CHARGE_TYPE_ALIPAY] = "支付宝充值"
TITLETEXT[PayDef.CHARGE_TYPE_UMPAY_EBANK] = "信用卡充值"
TITLETEXT[PayDef.CHARGE_TYPE_SZF_CMCC] = "神州行充值卡"
TITLETEXT[PayDef.CHARGE_TYPE_SZF_UNICOM] = "联通充值卡"
TITLETEXT[PayDef.CHARGE_TYPE_IOS] = "充值中心"
local CHARGE_ICON = "charge/charge_item_gold_img_%d.png"

function ChargeListCell:ctor(params)
    ChargeListCell.super.ctor(self)
    self.theme_ = params.theme
    self.dimens_ = params.dimens
    self.width_ = params.width 
    self.height_ = self.dimens_:getDimens(80)
    self.item_ = params.item
    self.index_ = params.index
    self.scene_ = params.scene
    self.cost_ = tonumber(self.item_.cost)

    local left, top = 0, 0
    left = self.dimens_:getDimens(10)
    top = self.dimens_:getDimens(5)
    local chargeImage = string.format(CHARGE_ICON,tonumber(self.item_.img))
    self.chargeIcon_ = jj.ui.JJImage.new({
        image = self.theme_:getImage(chargeImage),
        viewSize = CCSize(70, 70),
        scale9 = true,
        })
    self.chargeIcon_:setAnchorPoint(ccp(0,0))
    self.chargeIcon_:setScale(self.dimens_.scale_)
    self.chargeIcon_:setPosition(left, top)
    self:addView(self.chargeIcon_)
    JJLog.i("self.chargeIcon_ = ",self.item_.desc)
    left = left + self.dimens_:getDimens(25) + self.dimens_:getDimens(self.chargeIcon_:getViewSize().width)
    if self.item_.desc == nil or string.len(self.item_.desc) == 0 then
        top = self.dimens_:getDimens(54)
    else
        top = self.dimens_:getDimens(60)
    end        
    local chargeLabel = jj.ui.JJLabel.new({
        text = self.item_.money.."金币",
        color = ccc3(255, 217, 0),
        fontSize = self.dimens_:getDimens(24),
        })
    chargeLabel:setAnchorPoint(ccp(0, 1))
    chargeLabel:setPosition(left, top)
    -- chargeLabel:setScale(self.dimens_.scale_)
    self:addView(chargeLabel)

    top = self.dimens_:getDimens(30)
    local proLabel = jj.ui.JJLabel.new({
        text = self.item_.desc,
        color = display.COLOR_WHITE,
        fontSize = self.dimens_:getDimens(18),
        })
    proLabel:setAnchorPoint(ccp(0,1))    
    proLabel:setPosition(left, top)
    -- proLabel:setScale(self.dimens_.scale_)
    self:addView(proLabel)

    left = self.width_ - self.dimens_:getDimens(200)
    top = self.dimens_:getDimens(5)
    self.chargeBtn_ = jj.ui.JJButton.new({
            images = {
                normal = self.theme_:getImage("common/common_signup_small_btn_n.png"),
                highlight = self.theme_:getImage("common/common_signup_small_btn_d.png"),
                --scale9 = true,
                viewSize = CCSize(125,68),    
            },
            --fontSize = self.dimens_:getDimens(25),
            --color = display.COLOR_WHITE,
            --text = "￥"..self.item_.cost,
            viewSize = CCSize(125,68)
        })
    self.chargeBtn_:setAnchorPoint(ccp(0, 0))
    self.chargeBtn_:setPosition(left, top)
    self.chargeBtn_:setScale(self.dimens_.scale_)
    self.chargeBtn_:setOnClickListener(handler(self, self.onClick))
    self:addView(self.chargeBtn_)

    local btnText = jj.ui.JJLabel.new({
            text = "￥"..self.item_.cost,           
            fontSize = self.dimens_:getDimens(25),
            color = display.COLOR_WHITE,
       })
    btnText:setAnchorPoint(ccp(0.5, 0.5))
    btnText:setPosition(left + self.chargeBtn_:getBoundingBoxWidth() * self.dimens_.scale_ / 2 ,
                        top + self.chargeBtn_:getBoundingBoxHeight() * self.dimens_.scale_ / 2 )
    self:addView(btnText)

    self.line = jj.ui.JJImage.new({
        image = self.theme_:getImage("common/common_view_list_div_h.png"),
        scale9 = true,
        viewSize = CCSize(self.dimens_.width - self.dimens_:getDimens(300), self.dimens_:getDimens(2)),
    })
    self.line:setAnchorPoint(CCPoint(0, 0))
    self.line:setPosition(self.dimens_:getDimens(10), 0)
    self:addView(self.line)

    self:setViewSize(self.width_, self.height_)
end

function ChargeListCell:onClick(target)
    JJLog.i(TAG, "onClick, cost=", self.cost_, ", schemeId=", self.item_.dwECASchemeID, ", endMid=", self.item_.dwEndMID)
    if target == self.chargeBtn_ then
        self.scene_:onSelectPay(self.cost_, self.item_.money, self.item_.dwECASchemeID, self.item_.dwEndMID)
    end
end

function ChargeListAdapter:ctor(params)
    ChargeListAdapter.super.ctor(self)
    self.theme_ = params.theme
    self.dimens_ = params.dimens
    self.width_ = params.width
    self.items_ = params.items.money
    self.scene_ = params.scene
end


function ChargeListAdapter:getCount() 
    if self.items_ == nil then
        return 0
    end 
    return #self.items_
end

function ChargeListAdapter:getView(position)
    return ChargeListCell.new({
        scene = self.scene_,
        theme = self.theme_,
        dimens = self.dimens_,
        item = self.items_[position],
        width = self.width_,
        index = position,
    })
end

local ID_PROMPT = 1

function ChargeDetailScene:initView()
    ChargeDetailScene.super.initView(self)

    local title = "charge/charge_title_charge.png"
    if TITLETEXT[self.controller_.params_.type] ~= nil then
        title = TITLETEXT[self.controller_.params_.type]
    end

    self:setThemeStyle(self.THEME_LANDSCAPE_SYTLE)
    self:setBackBtn(true)
    self:setTitle(title)

    -- 只有游戏移动基地显示资费说明,后续添加
    if self.controller_:displayAlertPay() then
        local btnAlertPay = jj.ui.JJButton.new({
                images = {
                    normal = self.theme_:getImage("charge/charge_item_standard_btn_n.png"),
                },
            })
        btnAlertPay:setAnchorPoint(ccp(1, 1))
        btnAlertPay:setPosition(self.dimens_.width - self.dimens_:getDimens(10), self.dimens_.height - self.dimens_:getDimens(10))
        btnAlertPay:setScale(self.dimens_.scale_)
        btnAlertPay:setOnClickListener(function()  end)
        self:addView(btnAlertPay)
    end

    -- 提示内容  暂时不用
    local prompt = jj.ui.JJLabel.new({
        fontSize = self.dimens_:getDimens(20),
        color = ccc3(255, 255, 255),
        text = "金币: " .. UserInfo.gold_,
        background = {
            scale9 = true,
            image = self.theme_:getImage("common/common_btn_bg_n.png"),
        },
        viewSize = CCSize(self.dimens_.width - self.dimens_:getDimens(40), self.dimens_:getDimens(24)),
        padding = self.dimens_:getDimens(8)
    })
    prompt:setId(ID_PROMPT)
    prompt:setAnchorPoint(ccp(0.5, 0.5))
    prompt:setPosition(ccp(self.dimens_.cx, self.dimens_.height - self.dimens_:getDimens(100)))
    -- self:addView(prompt)

    -- 充值列表
    local payConfig = pcm:getPayConfig(self.controller_.params_.type)
    if payConfig ~= nil then
        self.width_ = self.dimens_.width - self.dimens_:getDimens(200)
        local top = self.dimens_.height/2
        self.height_ = self.dimens_:getDimens(400)
        local bg = jj.ui.JJImage.new({
            image = self.theme_:getImage("common/common_btn_bg_n.png"),
            scale9 = true,
            viewSize = CCSize(self.dimens_.width-self.dimens_:getDimens(260), self.height_),
            })
        bg:setAnchorPoint(ccp(0,0.5))
        bg:setPosition(self.dimens_:getDimens(200),top)
        self:addView(bg)

        local tableView = jj.ui.JJListView.new({
            viewSize = CCSize(self.width_, self.height_),
            adapter = ChargeListAdapter.new({
                scene = self,
                theme = self.theme_,
                dimens = self.dimens_,
                width = self.width_,
                height = self.height_,
                items = payConfig,
            }),
        })
        tableView:setAnchorPoint(ccp(0, 0.5))
        tableView:setPosition(self.dimens_:getDimens(200), top)
        self:addView(tableView)        
    end
end

function ChargeDetailScene:onSelectPay(amount, gold, schemeId, endMid)
    self.controller_:onSelectPay(amount, gold, schemeId, endMid)
end


function ChargeDetailScene:onDestroy()

end   

return ChargeDetailScene
