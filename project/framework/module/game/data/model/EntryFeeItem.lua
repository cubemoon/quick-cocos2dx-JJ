-- 报名费用
local EntryFeeItem = class("EntryFeeItem")

function EntryFeeItem:ctor(note, type, flag, reason, goldReq)
	self.note_ = note or "" -- 提示文字
	self.type_ = type -- 类型
	self.useable_ = flag or true -- 是否可用
	self.reason_ = reason or "" -- 不可用的原因
	self.goldReq_ = goldReq or true -- 是否金币
end

return EntryFeeItem