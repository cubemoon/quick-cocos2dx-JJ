local DiplomaCommentDialog = class("DiplomaCommentDialog", import("sdk.ui.JJDialogBase"))

--[[
计算字符串长度，包含中文的
]]
local function utf8StrLen(str)
    local len = 0
    if str and string.len(str) > 0 then
        local count = string.len(str)
        local i, ch = 1, nil
        --linxh 最多按3个算，按照标准最多有6个的
        while i <= count do
            ch = string.byte(str, i) 
            if ch < 0x80 then  
                i = i + 1
            elseif ch < 0xE0 then
                i = i + 2
            else
                i = i + 3
            end          
            len = len + 1
        end
    end
    return len
end

--[[
截取字符串，包含中文的
]]
local function utf8SubStr(str, len, start)
    start = start or 1
    len = len or 0
    local text = ""
    if str and string.len(str) > 0 then
        local  count = string.len(str)
        local strLen, i, ch = 0, start, nil
        --linxh 最多按3个算，按照标准最多有6个的
        while i <= count and strLen < len do
            ch = string.byte(str, i)            
            if ch < 0x80 then  
                text = text .. string.sub(str, i, i)                
                i = i + 1
            elseif ch < 0xE0 then
                text = text .. string.sub(str, i, i+1)
                i = i + 2
            else
                text = text .. string.sub(str, i, i+2)
                i = i + 3
            end

            strLen = strLen + 1
        end
    end
    return text
end


--[[    
]]
function DiplomaCommentDialog:ctor(parent, params)    
    DiplomaCommentDialog.super.ctor(self, params)
    self.theme_ = params.theme
    self.dimens_ = params.dimens  
    --self:setOnDismissListener(self.onDismissListener)

    --[[self.mask_ = require("game.ui.view.JJFullScreenMask").new()
    self.mask_:setPosition(0, 0)
    self.mask_:setOpacity(0) -- 完全透明
    self:addView(self.mask_)
    self.mask_:setOnClickListener(handler(self, self.onClick))]] 

    --BUG8028 输入内容后触点荣誉室外的空白区域时会编辑框且内容被清空
    self:setCanceledOnTouchOutside(false)

    local group = jj.ui.JJViewGroup.new({viewSize=CCSize(self.dimens_:getDimens(454), 
                                                        self.dimens_:getDimens(303))})
    --group:setScale(self.dimens_.scale_)  
    group:setAnchorPoint(ccp(0.5, 0.5))
    group:setPosition(self.dimens_.cx, self.dimens_.cy) 
    group:setTouchEnable(true)
    group:setOnClickListener(function(view) end)
    self:addView(group)
    self.top = self.dimens_:getDimens(303)
    self.cx = self.dimens_:getDimens(227)
    self.right = self.dimens_:getDimens(454)

    -- 背景框 454*303
    local bg = jj.ui.JJImage.new({
        image = self.theme_:getImage("common/common_alert_dialog_bg.png"),
    })    
    bg:setAnchorPoint(CCPoint(0.5, 0.5))    
    bg:setPosition(self.dimens_:getDimens(227), self.dimens_:getDimens(151.5))
    bg:setScaleX(self.dimens_.wScale_)
    bg:setScaleY(self.dimens_.hScale_)
    group:addView(bg)

    --title
    local lbl = jj.ui.JJLabel.new({
            singleLine = true,
            fontSize = self.dimens_:getDimens(25),
            color = ccc3(0, 0, 0),
            text = "晒到荣誉室",
            align = ui.TEXT_ALIGN_CENTER,
            valign = ui.TEXT_VALIGN_CENTER,
            viewSize = CCSize(self.dimens_:getDimens(140), self.dimens_:getDimens(30))
            })
    lbl:setAnchorPoint(ccp(0.5, 1))
    lbl:setPosition(self.cx, self.top-self.dimens_:getDimens(20))
    group:addView(lbl)

    lbl = jj.ui.JJLabel.new({
            singleLine = true,
            fontSize = self.dimens_:getDimens(20),
            color = ccc3(0, 0, 0),
            text = "晒奖状到荣誉室，随便说点什么吧：",
            align = ui.TEXT_ALIGN_CENTER,
            valign = ui.TEXT_VALIGN_CENTER,
            viewSize = CCSize(self.dimens_:getDimens(400), self.dimens_:getDimens(30))
            })
    lbl:setAnchorPoint(ccp(0.5, 1))
    lbl:setPosition(self.cx, self.top-self.dimens_:getDimens(50))
    group:addView(lbl)    

    lbl = jj.ui.JJLabel.new({
            singleLine = true,
            fontSize = self.dimens_:getDimens(18),
            color = ccc3(0, 0, 0),
            text = "(剩余",
            align = ui.TEXT_ALIGN_LEFT,
            valign = ui.TEXT_VALIGN_CENTER,
            viewSize = CCSize(self.dimens_:getDimens(60), self.dimens_:getDimens(30))
            })
    lbl:setAnchorPoint(ccp(0, 1))
    lbl:setPosition(self.right-self.dimens_:getDimens(150), self.top-self.dimens_:getDimens(70))
    group:addView(lbl)  

    self.tvPrompt = jj.ui.JJLabel.new({
            singleLine = true,
            fontSize = self.dimens_:getDimens(18),
            color = ccc3(255, 0, 0),
            text = "140",
            valign = ui.TEXT_VALIGN_CENTER,
            viewSize = CCSize(0, self.dimens_:getDimens(30))
            })
    self.tvPrompt:setAnchorPoint(ccp(0, 1))
    self.tvPrompt:setPosition(self.right-self.dimens_:getDimens(110), self.top-self.dimens_:getDimens(74))
    group:addView(self.tvPrompt)  

    self.tvPromptR = jj.ui.JJLabel.new({
            singleLine = true,
            fontSize = self.dimens_:getDimens(18),
            color = ccc3(0, 0, 0),
            text = "字)",
            align = ui.TEXT_ALIGN_LEFT,
            valign = ui.TEXT_VALIGN_CENTER,
            viewSize = CCSize(self.dimens_:getDimens(60), self.dimens_:getDimens(30))
            })
    self.tvPromptR:setAnchorPoint(ccp(0, 1))
    self.tvPromptR:setPosition(self.tvPrompt:getPositionX()+self.tvPrompt:getWidth(), 
                                self.top-self.dimens_:getDimens(70))
    group:addView(self.tvPromptR)  

    self.maxLen = 140
    --edit input box
    self.editInput_ = jj.ui.JJEditBox.new({
                        normal = self.theme_:getImage("common/edit_bg.png"),
                        viewSize = CCSize(self.dimens_:getDimens(400), self.dimens_:getDimens(115)),
						align = ui.TEXT_ALIGN_LEFT,
						valign = ui.TEXT_VALIGN_TOP,
                        layout = {paddingLeft = self.dimens_:getDimens(10), 
                                  paddingRight = self.dimens_:getDimens(5), 
                                  paddingTop = self.dimens_:getDimens(6), 
                                  paddingBottom = self.dimens_:getDimens(6)},
						singleLine=false,
                        listener = function(event, editbox)
                        --JJLog.i("linxh", "input event = " , event)   
                            if event == "changed" then   
                                local text = editbox:getText()
                                local len = utf8StrLen(text)
                                if len > self.maxLen then
                                    text = utf8SubStr(text, self.maxLen)
                                    len = self.maxLen
                                end
                                local leftLen = self.maxLen - len
                                if self.tvPrompt then self.tvPrompt:setText(leftLen) end
                                if self.tvPromptR then 
                                    self.tvPromptR:setPositionX(self.tvPrompt:getPositionX()+self.tvPrompt:getWidth())
                                end
                                --self.editInput_:setText(text)
                            end
                        end
                    })

    self.editInput_:setAnchorPoint(ccp(0, 0))
    self.editInput_:setPosition(self.dimens_:getDimens(27), self.dimens_:getDimens(90))
    --self.editInput_:setPlaceHolder("4~18位数字、字母或下划线")
    --self.editInput_:setPlaceHolderFont("宋体", 20)
    --self.editInput_:setPlaceHolderFontColor(ccc3(193, 193, 193))
    self.editInput_:setMaxLength(self.maxLen)
    self.editInput_:setFont("宋体", self.dimens_:getDimens(20))
    self.editInput_:setFontColor(ccc3(0, 0, 0))
    self.editInput_:setInputMode(kEditBoxInputModeAny)
    self.editInput_:setReturnType(kKeyboardReturnTypeDone)
    group:addView(self.editInput_)


    --bottom button
    local btnCancel = jj.ui.JJButton.new({
                    images = {
                        normal = self.theme_:getImage("common/common_alert_dialog_btn_1_n.png"),
                        highlight = self.theme_:getImage("common/common_alert_dialog_btn_1_d.png"),
                    },
                    fontSize = self.dimens_:getDimens(28),
                    color = ccc3(255, 255, 255),
                    text = "取消",
                    viewSize = CCSize(self.dimens_:getDimens(198), self.dimens_:getDimens(76)),
                })
  btnCancel:setAnchorPoint(ccp(1, 1))
  btnCancel:setPosition(self.cx - self.dimens_:getDimens(10), self.dimens_:getDimens(93))
  --btnCancel:setScale(self.dimens_.scale_)
  btnCancel:setOnClickListener(handler(self, self.onClick))
  group:addView(btnCancel)

  self.btnOk = jj.ui.JJButton.new({
                    images = {
                        normal = self.theme_:getImage("common/common_alert_dialog_btn_2_n.png"),
                        highlight = self.theme_:getImage("common/common_alert_dialog_btn_2_d.png"),
                    },
                    fontSize = self.dimens_:getDimens(28),
                    color = ccc3(255, 255, 255),
                    text = "提交",
                    viewSize = CCSize(self.dimens_:getDimens(198), self.dimens_:getDimens(76)),
                })
  self.btnOk:setAnchorPoint(ccp(0, 1))
  self.btnOk:setPosition(self.cx + self.dimens_:getDimens(10), self.dimens_:getDimens(93))
  --self.btnOk:setScale(self.dimens_.scale_)
  self.btnOk:setOnClickListener(handler(self, self.onClick))
  group:addView(self.btnOk)

  local ctrl = JJSDK:getTopSceneController()
  if ctrl then
    if ctrl.DiplomaInputText and string.len(ctrl.DiplomaInputText) > 0 then
		self.editInput_:setText(ctrl.DiplomaInputText)
		self.tvPrompt:setText(self.maxLen - utf8StrLen(ctrl.DiplomaInputText))
		ctrl.DiplomaInputText = nil
	end
	ctrl.showDiplomaInputDlg_ = nil
  end  
end

--[[
这个是重载了基类的_onClick, 基类如果有变化这个也要跟着变

function DiplomaCommentDialog:_onClick(view)
    --JJLog.i("linxh", "DiplomaCommentDialog:_onClick 1")
    self.exit_ = true --标记是home键退出还是用户点击退出
    DiplomaCommentDialog.super._onClick(view)
end]]

function DiplomaCommentDialog:onExit()
    self.tvPrompt = nil 
    self.tvPromptR = nil
    
    --JJLog.i("linxh", "DiplomaCommentDialog:onExit 1")
    if not self.exit_ then 
        --JJLog.i("linxh", "DiplomaCommentDialog:onExit 2")
        local ctrl = JJSDK:getTopSceneController()
        if ctrl then 
            ctrl.showDiplomaInputDlg_ = true
            ctrl.DiplomaInputText = self.editInput_:getText()
        end
    end
end

function DiplomaCommentDialog:onClick(target)
    --JJLog.i("linxh", "DiplomaCommentDialog:onClick 1")
    self.exit_ = true
    if target == self.btnOk then
        self.text = self.editInput_ and self.editInput_:getText()
        if self.onOkListener_ then
            self.onOkListener_(self.text)
        end            
    end
    self:dismiss()
end

function DiplomaCommentDialog:setOkListener(listener)
   self.onOkListener_ = listener
end

return DiplomaCommentDialog
