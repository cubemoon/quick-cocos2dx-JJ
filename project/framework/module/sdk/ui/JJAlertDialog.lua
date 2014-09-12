local JJAlertDialog = class("JJAlertDialog", require("sdk.ui.JJDialog"))

local TAG = "JJAlertDialog"

--[[
	params: table type
	title: string type, the title of the dialog
	message: string type the message of the dialog
--]]
function JJAlertDialog:ctor(params)
	JJAlertDialog.super.ctor(self, params)
	if params ~= nil then
		if params.title ~= nil then
			self:setTitle(params.title)
		end

		if params.message ~= nil then
			self:setContent(params.message)
		end
	end
end


return JJAlertDialog

