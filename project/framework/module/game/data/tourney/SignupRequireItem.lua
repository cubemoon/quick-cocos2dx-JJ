-- 报名所需要的条件项
local SignupRequireItem = class("SignupRequireItem")

function SignupRequireItem:ctor(type, itemId, name, ownValue, minValue, maxValue, note)
	self.type_ = type
	self.itemId_ = itemId
	self.name_ = name
	self.ownValue_ = ownValue
	self.minValue_ = minValue
	self.maxValue_ = maxValue
	self.note_ = note
end

return SignupRequireItem