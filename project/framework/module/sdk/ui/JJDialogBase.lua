
local JJViewGroup = import(".JJViewGroup")

local JJDialogBase = class("JJDialogBase", JJViewGroup)

local scale = 1
local TAG = "JJDialogBase"
JJDialogBase.dismiss_ = false -- 是否已经销毁掉

--[[
   params: 参数表
   onCancelListener: cancel监听函数，本质上和dismiss监听一样
   onShowListener: 调用onShow时的监听函数
   onDismissListener: dismiss()的监听函数
   mask:是否显示遮罩,默认显示
   backKey: 是否响应返回键，必须父节点是 Scene 的可以
   backKeyClose: 返回键是否关闭对话框，默认和 backKey 的值一样
   监听函数定义如下:
   1. onClickListener(dialog, which) which 为整数值标明是id为which的控件发生了click
   2. onCancelListener(dialog)
   3. onDismissListener(dialog)
   4. onShowListener(dialog)
--]]
function JJDialogBase:ctor(params)
    JJDialogBase.super.ctor(self, params)
    self.dismiss_ = false
    self.bCanceledOnTouchOutside_ = true
    if params ~= nil then
        assert(type(params)=="table", "invalid params, params should be a table")
        self.onCancelListener_ = params.onCancelListener or nil
        self.onShowListener_ = params.onShowListener or nil
        self.onDismissListener_ = params.onDismissListener or nil
        self.onClickListener_ = params.onClickListener or nil
        self.backKey_ = params.backKey or false
        if self.backKey_ then
            if params.backKeyClose ~= nil then
                self.backKeyClose_ = params.backKeyClose
            else
                self.backKeyClose_ = true
            end
        end
    end

    local bg = jj.ui.JJImage.new({
    	image="img/ui/bg_mask.png",
    })
    local director = CCDirector:sharedDirector()
    local glview = director:getOpenGLView()
    local size = glview:getFrameSize()

    bg:setScaleX(size.width)
    bg:setScaleY(size.height)
    bg:setOpacity(100)
    self:addView(bg, -100)
    bg:setAnchorPoint(ccp(0,0))
    bg:setPosition(ccp(0,0))
    if params ~= nil and params.mask == false then
        bg:setOpacity(0)
    end

    self:setViewSize(size.width, size.height)
    self.bCancelable_ = false
    self:setOnClickListener(handler(self, self._onClick))
end

function JJDialogBase:onExit()
	JJLog.i(TAG, "onExit() IN")
	self.dismiss_ = true
end

function JJDialogBase:_onClick(view)
	if self.bCanceledOnTouchOutside_ == true then
		self:dismiss()
	else
		JJLog.i(TAG, "canceled on touch out side is disable, just return")
	end
end

--Sets whether this dialog is cancelable with the BACK key.
--TODO:目前没功能， UI还不响应key的事件处理
function JJDialogBase:setCancelable(flag)
    self.bCancelable_ = flag
end

--当touch到dialog外面时是否取消dialog
--Sets whether this dialog is canceled when touched outside the window's bounds. If setting to true, the dialog is set to be cancelable if not already set.
--TODO:目前这个接口不起作用， 所有的dialog都是响应全屏事件，除非点击按钮消除掉dialog
function JJDialogBase:setCanceledOnTouchOutside(cancel)
    self.bCanceledOnTouchOutside_ = cancel
end

function JJDialogBase:setOnCancelListener(listener)
    self.onCancelListener_ = listener
end

function JJDialogBase:setOnDismissListener(listener)
    self.onDismissListener_ = listener
end

function JJDialogBase:setOnShowListener(listener)
    self.onShowListener_ = listener
end

function JJDialogBase:setOnClickListener(listener)
    self.onClickListener_ = listener
end

function JJDialogBase:show(rootview, zOrder)
    JJLog.i(TAG, "show()")
    self.rootview_ = rootview
    assert(rootview ~= nil, "ERROR: rootview ~= nil")
    local order = zOrder or 0
    rootview:addView(self, order)
    self:setAnchorPoint(CCPoint(0.5, 0.5))
    local director = CCDirector:sharedDirector()
    local glview = director:getOpenGLView()
    local size = glview:getFrameSize()
    self:setPosition(CCPoint(size.width/2, size.height/2))

    -- 比如是 Scene 才有这个接口
    if self.backKey_ and rootview.regBackKey ~= nil then
        rootview:regBackKey(self, function()
            if self.backKeyClose_ then
                self:dismiss()
            end
        end)
    end
end

function JJDialogBase:isShowing()
    return (self:getParentView() ~= nil)
end

function JJDialogBase:dismiss()
    JJLog.i(TAG, "dismiss IN")
    if self.dismiss_ == false then

        if self.rootview_ and self.rootview_.unregBackKey ~= nil then
            self.rootview_:unregBackKey(self)
        end

        self.dismiss_ = true
        self:setVisible(false)
        self:removeSelf(true)
        if self.onDismissListener_ ~= nil then
            self.onDismissListener_(self)
        end
	else
		JJLog.i(TAG, "ERROR: the native ccnode had been releaseed!!!")
    end
end

--TODO: do nothing now
function JJDialogBase:onBackPressed()

end

return JJDialogBase
