local FeedbackScene = class("FeedbackScene", import("game.ui.scene.JJGameSceneBase"))
local UIUtil = require("game.ui.UIUtil")
local JJHlLabel = require("game.ui.view.JJHlLabel")
local TAG = "FeedbackScene"

local PHONENUMBER = "010-62981235"
local fontColor = ccc3(255, 217, 0)
local fontHLColor = ccc3(255, 190, 0)

FeedbackScene.telUrl_ = nil
FeedbackScene.btnSubmit_ = nil
FeedbackScene.callDialog_ = nil
FeedbackScene.btnMyQuestion_ = nil
FeedbackScene.editorFeedback_ = nil

function FeedbackScene:onDestory()
    FeedbackScene.super.onDestory(self)
      -- 保存编辑后的参数
    local editor = nil
    if self.editorFeedback_ ~= nil then
        editor = self.editorFeedback_:getText()
    end 

    MainController:setTable(TAG, {
        editor = editor,
    })
    
    self.telUrl_ = nil
    self.btnSubmit_ = nil
    self.callDialog_ = nil   
    self.btnMyQuestion_ = nil
    self.editorFeedback_ = nil
end

function FeedbackScene:ctor(controller)
    FeedbackScene.super.ctor(self, controller)     
end

function FeedbackScene:initView()
    FeedbackScene.super.initView(self)

    self.theme_ = self.controller_.theme_
    self.dimens_ = self.controller_.dimens_
   
    local HALLFONTSIZE = self.dimens_:getDimens(24)
    --local title = "common/feedback_title.png"  
    --self:setTitle(self.theme_:getImage(title))
    self:setThemeStyle(self.THEME_LANDSCAPE_SYTLE)
    self:setBackBtn(true)
    if self.controller_ and self.controller_.title then        
        self:setTitle(self.controller_.title)
    else        
        self:setTitle("意见反馈")
    end
    --self:setThemeTwo()    
    --self:setTitle("img/feedback/feedback_title.png")
    
    local EDIT_START_Y = self.dimens_.height - self.dimens_:getDimens(60)
    local EDIT_WIDTH = self.dimens_.width - self.dimens_:getDimens(280)
    local EDIT_HEIGHT = self.dimens_:getDimens(180)
    local EDIT_MARGIN_TOP = self.dimens_:getDimens(20)    
    local EDIT_LEFT = self.dimens_:getDimens(220)
    local y = EDIT_START_Y
    local edOffset = {
            paddingLeft = self.dimens_:getDimens(10),
            paddingRight = self.dimens_:getDimens(10),
            paddingTop = self.dimens_:getDimens(10)
        }

    self.editorFeedback_ = jj.ui.JJEditBox.new({
        normal = self.theme_:getImage("common/edit_bg.png"),
        viewSize = CCSize(EDIT_WIDTH, EDIT_HEIGHT),
        layout = edOffset,
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_TOP,
        singleLine = false,
        listener = function(event, editbox) end
    })
    self.editorFeedback_:setAnchorPoint(ccp(0, 1))
    self.editorFeedback_:setPosition(EDIT_LEFT, y)
    self.editorFeedback_:setPlaceHolder("有什么问题或意见请在这里提交。")
    self.editorFeedback_:setPlaceHolderFontColor(ccc3(193, 193, 193))
    self.editorFeedback_:setPlaceHolderFont("宋体", self.dimens_:getDimens(24))
    self.editorFeedback_:setMaxLength(140)
    self.editorFeedback_:setFont("宋体", self.dimens_:getDimens(18))
    self.editorFeedback_:setFontColor(display.COLOR_BLACK)
    self.editorFeedback_:setInputMode(eEditBoxInputModeAny)
    self.editorFeedback_:setReturnType(kKeyboardReturnTypeDone)
    self:addView(self.editorFeedback_)


    local BTN_SUB_MARGIN_LEFT = EDIT_START_Y - EDIT_HEIGHT - self.dimens_:getDimens(20)
    local BTN_SUB_MARGIN_TOP = EDIT_START_Y - EDIT_HEIGHT - self.dimens_:getDimens(20)
    local BTN_SUB_WIDTH = 400
    local BTN_SUB_HEIGHT = 66

    self.btnSubmit_ = jj.ui.JJButton.new({
        images = {
            --normal="img/common/common_btn_long_green_n.png",
            --highlight="img/common/common_btn_long_green_d.png",
            normal = self.theme_:getImage("register/register_btn_long_green_n.png"),
            highlight = self.theme_:getImage("register/register_btn_long_green_d.png"),
            scale9 = true,
        },
        --text="提交",
        --fontSize = 28,
        viewSize = CCSize(BTN_SUB_WIDTH, BTN_SUB_HEIGHT),
    })
    self.btnSubmit_:setAnchorPoint(ccp(0.5, 1))    
    self.btnSubmit_:setScale(self.dimens_.scale_)
    -- 需要模拟圆角所以btn设置宽高要小点
    JJLog.i("self.editorFeedback_:getBoundingBoxWidth() ",self.editorFeedback_:getBoundingBoxWidth())
    self.btnSubmit_:setPosition(EDIT_LEFT + self.editorFeedback_:getBoundingBoxWidth() / 2, 
                    BTN_SUB_MARGIN_TOP)
    self.btnSubmit_:setOnClickListener(handler(self, self.onClick))
    self:addView(self.btnSubmit_)

    local btnText = jj.ui.JJLabel.new({
            text = "提交",            
            fontSize = self.dimens_:getDimens(28),
       })
    btnText:setAnchorPoint(ccp(0.5, 0.5))
    btnText:setPosition(EDIT_LEFT + self.editorFeedback_:getBoundingBoxWidth()  / 2 ,
                        BTN_SUB_MARGIN_TOP - self.btnSubmit_:getBoundingBoxHeight() * self.dimens_.scale_ / 2 )
    self:addView(btnText)

    local BTN_MY_QUESTION_TOP = BTN_SUB_MARGIN_TOP - self.btnSubmit_:getBoundingBoxHeight() * self.dimens_.scale_ 
    local INFO_WIDTH = self.dimens_:getDimens(300)
    local btnMyQuestionLayer = jj.ui.JJViewGroup:new()
    btnMyQuestionLayer:setPosition(self.dimens_.cx, BTN_MY_QUESTION_TOP)
    btnMyQuestionLayer:setAnchorPoint(ccp(0.5, 1))
    btnMyQuestionLayer:setViewSize(EDIT_WIDTH, BTN_SUB_HEIGHT)
    self:addView(btnMyQuestionLayer)
    
    local MYQUESTION_LEFT = EDIT_LEFT + self.editorFeedback_:getBoundingBoxWidth()  / 2    
    
    self.btnMyQuestion_ = JJHlLabel.new({
            text = "查看我的提问>",
            color = fontColor,
            fontSize = self.dimens_:getDimens(26),
            -- viewSize = CCSizeMake(INFO_NAME_LABLE_WIDTH - INFO_QIUCARD_WIDTH - INFO_QIUCARDINFO_MARGIN, INFO_QIUCARD_HIGHT),
            -- dimensions = CCSizeMake(INFO_NAME_LABLE_WIDTH - INFO_QIUCARD_WIDTH - INFO_QIUCARDINFO_MARGIN, INFO_QIUCARD_HIGHT),
        },self,fontColor,fontHLColor)
    self.btnMyQuestion_:setAnchorPoint(ccp(0.5, 1))
    self.btnMyQuestion_:setPosition(MYQUESTION_LEFT, BTN_MY_QUESTION_TOP - self.dimens_:getDimens(20))    
    self.btnMyQuestion_:setOnClickListener(handler(self, self.onClick))
    self:addView(self.btnMyQuestion_)

    local paramscolor = {}
    if self.controller_.params_.fontColor  then
        paramscolor = self.controller_.params_.fontColor 
    else
        paramscolor = ccc3(111, 198, 252)
    end

     -- 客服电话
    local params = {
        fontSize = HALLFONTSIZE,
        color = paramscolor,
    }

    local urlparam = {
        fontSize = HALLFONTSIZE,
        color = fontColor,
    } 
   

    local x = EDIT_LEFT
    local y = BTN_MY_QUESTION_TOP - self.dimens_:getDimens(90) 
     --腾讯微信   
    params.text = "官方微信：jjmobile"
    local weixin_ = jj.ui.JJLabel.new(params)
    weixin_:setAnchorPoint(ccp(0, 1))
    weixin_:setPosition(x, y)
    self:addView(weixin_)   

    local x = EDIT_LEFT + weixin_:getBoundingBoxWidth() + self.dimens_:getDimens(95)

    params.text = "客服电话："
    local tel_ = jj.ui.JJLabel.new(params)
    tel_:setAnchorPoint(ccp(0, 1))
    tel_:setPosition(x, y)
    self:addView(tel_)

    local X_WHITE = tel_:getBoundingBoxWidth() 

    urlparam.text = PHONENUMBER
    self.telUrl_ = JJHlLabel.new(urlparam,self,fontColor,fontHLColor)
    self.telUrl_:setAnchorPoint(ccp(0, 1))
    self.telUrl_:setPosition(x + X_WHITE, y)
    self.telUrl_:setTouchEnable(true)
    self.telUrl_:setOnClickListener(handler(self, self.onClick))
    self:addView(self.telUrl_)

--[[
    local label = jj.ui.JJLabel.new({
        text = "客服邮箱：gm@service.jj.cn",
            color = ccc3(111, 198, 252),
            fontSize = HALLFONTSIZE,
            -- viewSize = CCSizeMake(INFO_NAME_LABLE_WIDTH - INFO_QIUCARD_WIDTH - INFO_QIUCARDINFO_MARGIN, INFO_QIUCARD_HIGHT),
            -- dimensions = CCSizeMake(INFO_NAME_LABLE_WIDTH - INFO_QIUCARD_WIDTH - INFO_QIUCARDINFO_MARGIN, INFO_QIUCARD_HIGHT),
        })
    label:setAnchorPoint(ccp(0,1))
    label:setPosition(x, y)
    self:addView(label)
    ]]
    self:_initData(self)
end

function FeedbackScene:onClick(target)
    local id = 0
    if target ~= nil then
        id = target:getId()
    end

    if target == self.btnSubmit_ then                                             -- 提交
        self.controller_:onClickSubmit(self.editorFeedback_:getText())
    elseif target == self.btnMyQuestion_  then                                    --查看我的提问
        self.controller_:onClickMyquestion()
    elseif target == self.telUrl_ then
        self:callDialog(PHONENUMBER)
    end
end

-- 按下返回键
function FeedbackScene:onBackPressed()
    JJLog.i(TAG, "onBackPressed12 ",self.callDialog_)
    if self.callDialog_ ~= nil then
        UIUtil.dismissDialog(self.callDialog_)
        self.callDialog_ = nil
    end
end

function FeedbackScene:callDialog(phonenumber) 
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

function FeedbackScene:getEditorContent()
    return self.editorFeedback_:getText()
end

function FeedbackScene:_initData()
    JJLog.i(TAG, "_initData")
    local param = MainController:getTable(TAG)
    if param ~= nil then
        local editor = param.editor
        if self.editorFeedback_ ~= nil and editor ~= nil and editor ~= "" then
            self.editorFeedback_:setText(editor)            
        end       
    end    
end

-- 用于注册成功之后，清除之前的输入
function FeedbackScene:clearBeforeInput()
    -- 保存编辑后的参数
    local editor = nil
    if self.editorFeedback_ ~= nil then
        editor = self.editorFeedback_:setText("")
    end
    
    MainController:setTable(TAG, {
        editor = editor,
    })
end

return FeedbackScene
