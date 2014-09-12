local JJRootView = class("JJRootView")

local TAG = "JJRootView"

--[[
	params: table type, params as follows:
	displayType: string type, such as "scene", "director", indicator where the views should to display
	display: CCScene or CCDirector type

--]]
function JJRootView:ctor(params)
	assert(params~=nil, "ERROR: params should not be nil!")
	if params ~= nil then
		if params.displayType ~= nil and params.displayType == "director" then
			self.displayType_ = "director"
		else
			self.displayType_ = "scene"
		end
	else
		self.displayType_ = "scene"
	end
	self.display_ = params.display
	self.rootview_ = nil
	local viewgroup = jj.ui.JJViewGroup.new()
	viewgroup:registTouchHandler()
	
	 if self.displayType_ == "scene" then
		 assert(tolua.type(self.display_=="CCScene", "ERROR: self.display_ not CCScene type"))
		local scene = self.display_
		assert(scene ~= nil, "ERROR: running scene is nil!")
		scene:removeAllChildren()
		scene:addChild(viewgroup:getNode())
		self.rootview_ = viewgroup
	else
		assert(tolua.type(self.display_)=="CCDirector", "ERROR: self.display_ not CCDirector type")
		self.display_:addChild(viewgroup:getNode())
		self.rootview_ = viewgroup
	end

	self.rootview_ = viewgroup
end

function JJRootView:addView(viewgroup)
	
	if self.rootview_ ~= nil then
		self.rootview_:addView(viewgroup)
	end
end

function JJRootView:removeView(view)
	if self.rootview_ ~= nil then
		self.rootview_:removeView(view)
	end
end

return JJRootView

