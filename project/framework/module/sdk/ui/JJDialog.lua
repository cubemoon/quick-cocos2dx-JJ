
local JJViewGroup = import(".JJViewGroup")
local JJDialogBase = import(".JJDialogBase")
local JJDialog = class("JJDialog", JJDialogBase)

local scale = 1
local TAG = "JJDialog"


JJDialog.POSITIVE_BTN = 1
JJDialog.NEGATIVE_BTN = 2
JJDialog.NEUTRAL_BTN = 3

local JJButton = import(".JJButton")
local default_top_h = 30
local default_middle_h = 30
local default_bottom_h = 54
local default_dialog_w = display.width/2

local ContentView = class("ContentView", JJViewGroup)

local TitleView = class("TitleView", JJViewGroup)

function TitleView:ctor(params)
	TitleView.super.ctor(self, params)
	if params ~= nil then
		local label = jj.ui.JJLabel.new(params)
		self:addView(label)
		label:setAnchorPoint(ccp(0, 0))
		label:setPosition(ccp(0, 0))
		self.text_ = params.text
		self.label_ = label
	end
end

function TitleView:setText(text)
	if self.text_ ~= text then
		if self.label_ ~= nil then
			self.label_:setText(text)
			self.label_ = nil
		else

			local label = jj.ui.JJLabel({
											text=text
			})

			label:setAnchorPoint(ccp(0,0))
			label:setPosition(ccp(0,0))
			self:addView(label)
			self.label_ = label
		end
	end
end

function TitleView:getText()
	if self.label_ ~= nil then
		return self.label_:getText()
	end
end

function TitleView:setView(view)
	if self.label_ ~= nil then
		self.label_:removeSelf()
	end
	self.view_ = view
	self:addView(view)
	view:setAnchorPoint(ccp(0, 0))
	view:setPosition(ccp(0,0))
	self:setviewSize(view:getWidth(), view:getHeight())

end

function TitleView:getView()
	return self.view_
end

--[[
	params: table type
	text: string type
	fontSize: number type
	
--]]
function ContentView:ctor(params)
	self.TAG = "ContentView"
	ContentView.super.ctor(self, params)

	if params ~= nil then
		local label = jj.ui.JJLabel.new(params)
		self:addView(label)
		label:setAnchorPoint(ccp(0, 0))
		label:setPosition(ccp(0, 0))
		-- label:setHeightWrapContent(true)
		self.text_ = params.text
		self.label_ = label
		
	end

	self:relayout()
end

function ContentView:setText(text)

	local num = getLineNumByString(text, ui.DEFAULT_TTF_FONT, ui.DEFAULT_TTF_FONT_SIZE, self:getWidth())
	JJLog.i("ContentView", "num=", num)
	local textH = (num+1)*ui.DEFAULT_TTF_FONT_SIZE

	if self.text_ ~= text then
		if self.label_ ~= nil then
			self.label_:removeSelf()
			self.label_ = nil
		end
		
		local label = jj.ui.JJLabel.new({
											text=text,
											singleLine=false,
											viewSize=CCSize(self:getWidth(), textH)
		})

		label:setAnchorPoint(ccp(0,0))
		label:setPosition(ccp(0,0))
		-- label:setHeightWrapContent(true)
		self:addView(label)
		self.label_ = label
		self:relayout()
	end
end

function ContentView:getText()
	if self.label_ ~= nil then
		return self.label_:getText()
	end
end

function ContentView:setView(view)
	if self.label_ ~= nil then
		self.label_:removeSelf()
		self.label_ = nil
	end

	if self.view_ ~= nil then
		self.view_:removeSelf()
		self.view_ = nil
	end
	self.view_ = view
	self:addView(view)
	--view:setAnchorPoint(ccp(0, 0))
	--view:setPosition(ccp(0,0))
	self:setViewSize(view:getWidth(), view:getHeight())
	self:relayout()
end

function ContentView:relayout()
	JJLog.i("ContentView", "relayout()")
	local labelW = 0
	local labelH = 0
	local viewW = 0
	local viewH = 0

	if self.label_ ~= nil then
		labelW = self.label_:getWidth()
		labelH = self.label_:getHeight()
	else
		JJLog.i("ContentView", "ERROR: self.label_ == nil")
	end

	if self.view_ ~= nil then
		viewW = self.view_:getWidth()
		viewH = self.view_:getHeight()
	end

	JJLog.i("ContentView", "labelW=", labelW, ", labelH=", labelH, ", viewW=", viewW, ", viewH=", viewH)
	local w = math.max(labelW, viewW)
	local h = math.max(labelH, viewH)

	self:setViewSize(w, h)
end

local ButtonView = class("ButtonView", JJViewGroup)

function ButtonView:ctor(params)
	ButtonView.super.ctor(self, params)
	self.TAG = "ButtonView"

	self:setBackground({image="img/ui/bottom_bar.png", scale9=true})
	self:_refresh()
end

function ButtonView:setButton1(text)
	self:_initButton(JJDialog.POSITIVE_BTN, text)
end

function ButtonView:setButton2(text)
	self:_initButton(JJDialog.NEGATIVE_BTN, text)
end

function ButtonView:setButton3(text)
	self:_initButton(JJDialog.NEUTRAL_BTN, text)
end

function ButtonView:getButton(which)

end

function ButtonView:_initButton(which, text)
	JJLog.i(self.TAG, "_initButton() text=", text)
	assert((which==JJDialog.POSITIVE_BTN or which==JJDialog.NEGATIVE_BTN or which == NEUTRAL_BTN), "which is invalid params")
	
	JJLog.i(self.TAG, "0000000000000")
	local btn = JJButton.new({
								 images = {
									 normal = "img/ui/btn_default_normal.9.png",
									 highlight = "img/ui/btn_default_pressed.9.png",
									 disable = "img/ui/btn_default_normal_disable.9.png",
									 scale9=true
								 },
								 singleLine=true,
								 fontSize=24,
								 text=text,
								 align=ui.TEXT_ALIGN_CENTER,
								 valign=ui.TEXT_VALIGN_CENTER
	})
	JJLog.i(self.TAG, "1111111")
	local button = self:getViewById(which)

	if button ~= nil then
		button:removeSelf()
	end
	
	btn:setId(which)
	btn:setOnClickListener(handler(self, self._onClick))

	self:addView(btn)
	JJLog.i(self.TAG, "22222222222222")
	self:_refresh()
	
end


function ButtonView:_onClick(view)
	local id = view:getId()

	if id == JJDialog.POSITIVE_BTN then
		
	elseif id == JJDialog.NEGATIVE_BTN then

	elseif id == JJDialog.NEUTRAL_BTN then

	end
	
	
	if self.onClickListener_ ~= nil then
		self.onClickListener_(JJDialog, id)
	end

	self:getParentView():dismiss()
end

function ButtonView:_refresh()
	JJLog.i(self.TAG, "_refresh() IN")
	local count = self:getViewCount()
	if count == 0 then
		self:setVisible(false)
		JJLog.i(self.TAG, "count==0 return")
		return
	else
		self:setVisible(true)
	end
	local w = 0
	local h = 0

	for k, v in ipairs(self.mChildren_) do
		w = w + v:getWidth()
		h = v:getHeight()
	end

	w = w + (count+1)*10
	h = 38
	JJLog.i(self.TAG, "w="..w..", h="..h)
	--self:setViewSize(w, h)
	local pading = 10
	local left = pading
	local top = self:getHeight()
	top = top/2
	local btnW = (self:getWidth()-(count+1)*10)/count
	JJLog.i("ButtonView", "btnW=", btnW, ", count=", count, "width=", self:getWidth())
	for k, v in ipairs(self.mChildren_) do 
		v:setWidth(btnW)
		v:setAnchorPoint(ccp(0, 0.5))
		v:setPosition(ccp(left, top))
		left = left + v:getWidth() + pading
	end
	JJLog.i(self.TAG, "_refresh() OUT")
end

function ButtonView:relayout()
	self:_refresh()
end

function ButtonView:getWidth()
	if self:isVisible() then
		return ButtonView.super.getWidth(self)
	else
		return 0
	end
end

function ButtonView:getHeight()
	if self:isVisible() then
		return ButtonView.super.getHeight(self)
	else
		return 0
	end
end
--[[
	params: 参数表
	onCancelListener: cancel监听函数，本质上和dismiss监听一样
	onShowListener: 调用onShow时的监听函数
	onDismissListener: dismiss()的监听函数

	监听函数定义如下:
	1. onClickListener(dialog, which) which 为整数值标明是id为which的控件发生了click
	2. onCancelListener(dialog)
	3. onDismissListener(dialog)
	4. onShowListener(dialog)
--]]
--local JJDialogInterface = import(".JJDialogInterface")
function JJDialog:ctor(params)
	JJDialog.super.ctor(self, params)
	JJLog.i(TAG, "ctor()")
	JJLog.i(TAG, "dialog_w=", default_dialog_w)
	self.topView_ = TitleView.new({viewSize=CCSize(default_dialog_w, default_top_h)})
	self.middleView_ = ContentView.new({viewSize=CCSize(default_dialog_w, default_middle_h)})
	self.bottomView_ = ButtonView.new({viewSize=CCSize(default_dialog_w, default_bottom_h)})
	
	self:addView(self.topView_)
	self:addView(self.middleView_)
	self:addView(self.bottomView_)

	local w = self.topView_:getWidth() + self.middleView_:getWidth() + self.bottomView_:getWidth()
	local h = self.topView_:getHeight() + self.middleView_:getHeight() + self.bottomView_:getHeight()

	JJLog.i(TAG, "LQT::::LQT  befor set listener....")
	if params ~= nil then
		assert(type(params)=="table", "invalid params, params should be a table")
		self.onCancelListener_ = params.onCancelListener or nil
		self.onShowListener_ = params.onShowListener or nil
		self.onDismissListener_ = params.onDismissListener or nil
		self.onClickListener_ = params.onClickListener or nil
		JJLog.i(TAG, "self.onClickListener_ == afaasfa")
	else
		JJLog.i(TAG, "WARNNING: params == nil")
	end
	JJLog.i(TAG, "LQT::::LQT  after set listener....")	

	if params == nil or params.background == nil then
		--self:setBackground({image="img/ui/popup_full_dark.9.png", scale9=true})
	end
	
	self.bCancelable_ = false 
	
	if params ~= nil and params.showCloseBtn == true then
	self.closeBtn_ = JJButton.new({images={
									   normal = "img/ui/close_btn_n.png", 
									   highlight = "img/ui/close_btn_d.png",
									   disable = "img/ui/close_btn_d.png"
								 }})

	self.closeBtn_:setOnClickListener(handler(self, self.dismiss))
	self:addView(self.closeBtn_)
	end
	-- divider line
	-- self.dividerlineSprite_ = display.newScale9Sprite("img/ui/dialog_divider_horizontal_light.9.png")
	-- self:getNode():addChild(self.dividerlineSprite_)
	-- self.dividerlineSprite_:setContentSize(CCSizeMake(self.viewSize_.width, 3))

	self:relayout()
end

function JJDialog:show(rootview)
	JJLog.i(TAG, "show()")
	assert(rootview ~= nil, "ERROR: rootview ~= nil")
	rootview:addView(self)
	self:setAnchorPoint(CCPoint(0.5, 0.5))
	local director = CCDirector:sharedDirector()
	local glview = director:getOpenGLView()
	local size = glview:getFrameSize()
	JJLog.i(TAG, "size.width="..size.width..", size.height="..size.height)
	self:setPosition(CCPoint(size.width/2, size.height/2))
	
	if self.onShowListener_ ~= nil then
		self.onShowListener_(self)
	end
end

function JJDialog:isShowing()
	return (self:getParentView() ~= nil and self:isVisible())
end

--TODO: do nothing now
function JJDialog:onBackPressed()

end

function JJDialog:setTitle(text)
	self.topView_:removeAllView()
	self.topView_:setText(text)
	self:relayout()
end

function JJDialog:setTitleView(view)
	self.topView_:removeAllView()
	self.topView_:setView(view)
	self:relayout()
end

function JJDialog:setContent(text)
	self.middleView_:removeAllView()
	self.middleView_:setText(text)
	self:relayout()
end

function JJDialog:setContentView(view)
	self.middleView_:removeAllView()
	self.middleView_:setView(view)
	self:relayout()
end

function JJDialog:setButton1(text)
	self.bottomView_:setButton1(text)
	self:relayout()
end

function JJDialog:setButton2(text)
	self.bottomView_:setButton2(text)
	self:relayout()
end

function JJDialog:setButton3(text)
	self.bottomView_:setButton3(text)
	self:relayout()
end

function JJDialog:getButton(which)
	self.bottomView_:getButton(which)
end


function JJDialog:relayout()
	JJLog.i(TAG, "relayout()")
	local w1 = self.topView_:getWidth()
	local w2 = self.middleView_:getWidth()
	local w3 = self.bottomView_:getWidth()

	local h1 = self.topView_:getHeight()
	local h2 = self.middleView_:getHeight()
	local h3 = self.bottomView_:getHeight()

	local w = math.max(math.max(w1, w2), w3)
	local h = h1 + h2 + h3

	JJLog.i(TAG, "w=", w, ", h=", h)
	self:setViewSize(w, h)
	
	local left = 0
	local top = self:getHeight()
	if self.closeBtn_ ~= nil then
	self.closeBtn_:setAnchorPoint(ccp(1, 1))
	self.closeBtn_:setPosition(ccp(self:getWidth(), self:getHeight()))
	end
	self.topView_:setAnchorPoint(ccp(0, 1))
	self.topView_:setPosition(ccp(left, top))

	-- self.dividerlineSprite_:setAnchorPoint(ccp(0.5, 1))


	top = top - self.topView_:getHeight()
	-- self.dividerlineSprite_:setContentSize(CCSize(self:getWidth(), 3))
	-- self.dividerlineSprite_:setPosition(ccp(w/2, top))

	self.middleView_:setAnchorPoint(ccp(0, 1))
	self.middleView_:setPosition(ccp(left, top))
	
	top = top - self.middleView_:getHeight()
	self.bottomView_:setAnchorPoint(ccp(0, 1))
	self.bottomView_:setPosition(ccp(left, top))
end

return JJDialog
