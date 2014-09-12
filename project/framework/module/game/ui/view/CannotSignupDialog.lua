local JJViewGroup = import("sdk.ui.JJViewGroup")
local CannotSignupDialog = class("CannotSignupDialog", JJViewGroup)
local SignupListAdapter = class("SignupListAdapter", import("sdk.ui.JJBaseAdapter"))
local SignupListCell = class("SignupListCell", import("sdk.ui.JJListCell"))

function SignupListCell:ctor(params, customParam)
    SignupListCell.super.ctor(self)
    self.dimens_ = params.dimens
    self.theme_ = params.theme
    self.width_ = params.width
    self.packageId_ = params.packageId
    self.customParam_ = customParam
    local left, top = 0, 0
    local fntSize = self.dimens_:getDimens(self.customParam_.cannotSignupDialogTextFontSize)
    local fntColorTitle = self.customParam_.CannotSignupDialogTextTitleFontColor
    local fntColor = self.customParam_.CannotSignupDialogTextFontColor
    if params.name ~= nil then
        top = self.dimens_:getDimens(20)
        if params.des ~= nil then
            left = 0
            top = self.dimens_:getDimens(5)
            local split_h = jj.ui.JJImage.new({
                image = self.theme_:getImage("matchselect/match_item_split_h.png"),
                scale9 = true,
                viewSize = CCSize(self.width_, 2)
            })
            split_h:setAnchorPoint(ccp(0, 0))
            split_h:setPosition(left, top)
            self:addView(split_h)
            top = self.dimens_:getDimens(20)

            local desPro = "获取："
            local desProLabel = jj.ui.JJLabel.new({
                text = desPro,
                fontSize = fntSize,
                color = fntColorTitle,
                singleLine = true,
            })
            desProLabel:setAnchorPoint(ccp(0, 0))
            self:addView(desProLabel)

            left = desProLabel:getViewSize().width + self.dimens_:getDimens(5)
            local des = params.des
            des = string.gsub(des, "-","－")
            self.desLabel_ = jj.ui.JJLabel.new({
                text = des,
                fontSize = fntSize,
                color = fntColor,
                align = ui.TEXT_ALIGN_LEFT,
                viewSize = CCSize(self.width_ - desProLabel:getViewSize().width - self.dimens_:getDimens(40), 0)
            })
            self.desLabel_:setAnchorPoint(ccp(0, 0))
            self.desLabel_:setPosition(left, top)
            self:addView(self.desLabel_)

            desProLabel:setPosition(0, top + self.desLabel_:getViewSize().height- self.dimens_:getDimens(22))
            --  + self.desLabel_:getViewSize().height - self.dimens_:getDimens(22)
        end
        if self.desLabel_ ~= nil and self.desLabel_:getViewSize().height ~= 0 then
            top = top + self.desLabel_:getViewSize().height + self.dimens_:getDimens(5)
        else
            top = top + self.dimens_:getDimens(35)
        end

        left = 0
        local numPro = "数量："
        local numProLabel = jj.ui.JJLabel.new({
            text = numPro,
            fontSize = fntSize,
            color = fntColorTitle,
            singleLine = true,
        })
        numProLabel:setAnchorPoint(ccp(0, 0))
        numProLabel:setPosition(left, top)
        self:addView(numProLabel)

        left = numProLabel:getViewSize().width + self.dimens_:getDimens(5)
        local num = params.num
        local numLabel = jj.ui.JJLabel.new({
            text = num,
            fontSize = fntSize,
            color = fntColor,
            singleLine = true,
        })
        numLabel:setAnchorPoint(ccp(0, 0))
        numLabel:setPosition(left, top)
        self:addView(numLabel)
        top = top + math.max(numLabel:getViewSize().height, numProLabel:getViewSize().height) + self.dimens_:getDimens(5)             
        local namePro = "名称："
        local nameProLabel = jj.ui.JJLabel.new({
            text = namePro,
            singleLine = true,
            fontSize = fntSize,
            color = fntColorTitle,
        })
        nameProLabel:setAnchorPoint(ccp(0, 0))
        nameProLabel:setPosition(0, top)
        self:addView(nameProLabel)

        left = nameProLabel:getViewSize().width + self.dimens_:getDimens(5)
        local name = params.name
        local nameLabel = jj.ui.JJLabel.new({
            text = name,
            singleLine = true,
            fontSize = fntSize,
            color = fntColor,
        })
        nameLabel:setAnchorPoint(ccp(0, 0))
        nameLabel:setPosition(left, top)
        self:addView(nameLabel)  

        -- 充值按钮        
        if params.name == "金币" then
            left = self.width_
            -- top = top - self.dimens_:getDimens(40)     
            self.chargeReturn_ = jj.ui.JJButton.new({
                fontSize = self.dimens_:getDimens(22),
                color = display.COLOR_WHITE,
                text = "充 值",                
                images = {        
                    normal = self.theme_:getImage("common/common_signup_small_btn_n.png"),
                    highlight = self.theme_:getImage("common/common_signup_small_btn_d.png"),
                    -- scale9 = true,
                    -- viewSize = CCSize(self.dimens_:getDimens(125), self.dimens_:getDimens(68)),    
                },
                viewSize = CCSize(self.dimens_:getDimens(125), self.dimens_:getDimens(68))
            })
            self.chargeReturn_:setAnchorPoint(ccp(1, 1))
            self.chargeReturn_:setPosition(left, top + nameLabel:getViewSize().height+self.dimens_:getDimens(5))
            -- self.chargeReturn_:setScale(self.dimens_.scale_)
            self.chargeReturn_:setOnClickListener(handler(self, self.onClick))    
            self:addView(self.chargeReturn_)  
            self.height_ = top + math.max(nameProLabel:getViewSize().height,nameLabel:getViewSize().height) --+ self.dimens_:getDimens(35)
        else
            self.height_ = top + math.max(nameProLabel:getViewSize().height,nameLabel:getViewSize().height) + self.dimens_:getDimens(5)            
        end
        self:setViewSize(self.width_, self.height_)
    end
end

function SignupListCell:onClick(target)
    if target == self.chargeReturn_ then
        local pcm = require("game.data.config.PayConfigManager")
        PayDef:chargeBtnHandler(pcm:getParam())
    end
end

function _getItem(signupRequireItem_) 
    if signupRequireItem_.type_ == MatchDefine.SIGNUPCOST_TYPE_WARE then
        local explainStr = ""        
        if WareInfoManager:getWareItem(signupRequireItem_.itemId_) ~= nil then
            explainStr = WareInfoManager:getWareItem(signupRequireItem_.itemId_).ware_introduction
        end        
        return {
                name = signupRequireItem_.name_,
                num = signupRequireItem_.note_,
                explain = explainStr,
            }
    else
        local id = 0
        local name = ""
        local explain = ""    
        if signupRequireItem_.type_ == MatchDefine.SIGNUPCOST_TYPE_GOLD then
            id = 10000
        elseif signupRequireItem_.type_ == MatchDefine.SIGNUPCOST_TYPE_CERT then
            id = 10001
        elseif signupRequireItem_.type_ == MatchDefine.SIGNUPCOST_TYPE_GROW then
            id = signupRequireItem_.itemId_
        end
        local explainStr = "未知"  
        local name_ = "未知物品"      
        if GrowInfoManager:getGrowItem(id) ~= nil then
            explainStr = GrowInfoManager:getGrowItem(id).explain
            name_ = GrowInfoManager:getGrowItem(id).name
        end  
        return {
                name = name_,
                num = signupRequireItem_.note_,
                explain = explainStr,
            }
    end
end

function SignupListAdapter:ctor(params, customParam)
    SignupListAdapter.super.ctor(self)   
    self.tourneyInfo_ = params.tourneyInfo
    self.theme_ = params.theme
    self.dimens_ = params.dimens
    self.packageId_ = params.packageId
    self.customParam_ = customParam
    self.signupRequireItemList_ = self.tourneyInfo_:getSignupRequireItemList()
    self.width_ = params.width
end

function SignupListAdapter:getCount()
    if self.signupRequireItemList_ ~= nil then
        return #self.signupRequireItemList_
    else
        return 0
    end
end

function SignupListAdapter:getView(position)
    local item = self.signupRequireItemList_[position]  
    local param = _getItem(item)
    return SignupListCell.new({
        theme = self.theme_,
        dimens = self.dimens_,
        name = param.name,
        num = param.num,
        des = param.explain,
        width = self.width_,
        packageId = self.packageId_,
    }, self.customParam_)
end

local function _onClickMask(self)
    self.scene_:showCannotSingupDialog(false)
end

function CannotSignupDialog:ctor(params, customParam)
    CannotSignupDialog.super.ctor(self)
    self.scene_ = params.scene
    self.tourneyInfo_ = params.tourneyInfo
    self.dimens_ = params.dimens
    self.theme_ = params.theme    
    self.width_ = self.dimens_:getDimens(454)
    self.height_ = self.dimens_:getDimens(303)
    self.packageId_ = params.packageId

    local left, top = 0
    self:setViewSize(self.dimens_.width, self.dimens_.height)    
    -- 背景遮罩
    self.bgMask_ = require("game.ui.view.JJFullScreenMask").new()
    self:addView(self.bgMask_)
    self.bgMask_:setOnClickListener(handler(self, _onClickMask))

    -- 背景框
    self.layer_ = jj.ui.JJViewGroup.new()
    self.layer_:setViewSize(self.width_, self.height_)
    self.layer_:setAnchorPoint(ccp(0.5, 0.5))
    self.layer_:setPosition(self.dimens_.cx, self.dimens_.cy)
    self:addView(self.layer_)

    self.bg_ = jj.ui.JJImage.new({        
            image = self.theme_:getImage("common/common_alert_dialog_bg.png"),
        })
    self.bg_:setAnchorPoint(ccp(0, 0))
    self.bg_:setPosition(0, 0)
    self.bg_:setScale(self.dimens_.scale_)
    self.bg_:setTouchEnable(true)
    self.bg_:setOnClickListener(handler(self, self.onClick))
    self.layer_:addView(self.bg_)
    
    local fntSize = self.dimens_:getDimens(customParam.cannotSignupDialogTitleFontSize)
    -- 标题
    self.proStr = jj.ui.JJLabel.new({
        singleLine = true,
        fontSize = fntSize,
        color = customParam.cannotSignupDialogTitleFontColor,
        text = "报名条件说明",
    })
    top = self.height_ - self.dimens_:getDimens(35)
    self.proStr:setAnchorPoint(ccp(0.5, 1))
    self.proStr:setPosition(self.width_/2, top)
    self.layer_:addView(self.proStr)    

    -- 关闭按钮
    self.btnClose_ = jj.ui.JJButton.new({
        images = {        
            normal = self.theme_:getImage("common/common_dialog_close_btn_n.png"),
            highlight = self.theme_:getImage("common/common_dialog_close_btn_d.png"),
        },
        -- viewSize = CCSize(50, 50),
    })
    left = self.width_ - self.dimens_:getDimens(12)
    top = self.height_ - self.dimens_:getDimens(0)
    self.btnClose_:setAnchorPoint(ccp(1, 1))
    self.btnClose_:setPosition(left, top)
    self.btnClose_:setScale(self.dimens_.scale_)
    -- self.btnClose_:setOnClickListener(handler(self, self.onClick))
    -- self.layer_:addView(self.btnClose_)

    local tableView = jj.ui.JJListView.new({
        viewSize = CCSize(self.width_ - self.dimens_:getDimens(60), self.height_ - self.dimens_:getDimens(110)),
        adapter = SignupListAdapter.new({
            theme = self.theme_,
            dimens = self.dimens_,
            tourneyInfo = self.tourneyInfo_,
            width = self.width_ - self.dimens_:getDimens(60),
            height = self.height_ - self.dimens_:getDimens(110),
            packageId = self.packageId_,
        }, customParam),
    })
    tableView:setAnchorPoint(ccp(0, 1))
    tableView:setPosition(self.dimens_:getDimens(40), self.height_ - self.dimens_:getDimens(75))
    self.layer_:addView(tableView)
end

function CannotSignupDialog:onClick(target)
    -- if target == self.bg_ then
    --     -- return true
    if target == self.btnClose_ then
        self.scene_:showCannotSingupDialog(false)
    end
end

return CannotSignupDialog
