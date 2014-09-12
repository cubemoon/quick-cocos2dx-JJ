
require("sdk.debug.JJLog")
require("sdk.util.Util")
require("sdk.file.JJFileUtil")
require("sdk.file.LuaDataFile")
require("sdk.message.MsgDef")
require("sdk.message.SDKMsgDef")

jj = jj or {}

jj.ui = import(".ui.init")

local TAG = "init"
local viewChangeCB_ = nil
local sizeChangeCB_ = {}

-- 界面的高宽变化了
local function _initDimens()
	JJLog.i(TAG, "_initDimens")

	for k,v in pairs(sizeChangeCB_) do
		v()
	end

	if viewChangeCB_ ~= nil then
		viewChangeCB_()
	end

	jj.ui.JJToast:onSizeChange()
end

function registerViewChangeListener(callback)
	viewChangeCB_ = callback
	JJCloseIMEKeyboard()
	CCNotificationCenter:sharedNotificationCenter():registerScriptObserver(nil, _initDimens, "SizeChange")
end

--[[
	注册界面尺寸改变的回调
	@model：
	@callback：
]]
function registerSizeChangeListener(model, callback)
	sizeChangeCB_[model] = callback
end

--[[
	注册界面尺寸改变的回调
	@model：
	@callback：
]]
function unregisterSizeChangeListener(model)
	sizeChangeCB_[model] = nil
end



-- 查看缓存图片状态
require("sdk.cache.ImageCacheManager")
ImageCacheManager:init()
-- TODO gc操作不能执行多次
--ImageCacheManager:gcCache()

