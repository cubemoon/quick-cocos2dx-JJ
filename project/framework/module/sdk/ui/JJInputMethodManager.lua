local JJInputMethodManager = {}

local TAG = "JJInputMethodManager"
local lastOpenTime_ = getCurrentMillis()
function JJInputMethodManager:registerInputMethodPosxy(posxy)

end

function JJInputMethodManager:unregisterInputMethodPosxy(posxy)

end


function JJInputMethodManager:canShowSoftKeyboard()
	JJLog.i(TAG, "canShowSoftKeyboard() IN")
	local cur = getCurrentMillis()

	local delta = cur - lastOpenTime_
	JJLog.i(TAG, "curtime=", cur, "last=", lastOpenTime_, " delta=", delta)
	if delta  > 300 then
		JJLog.i(TAG, "OK can show softkeyboard")
		lastOpenTime_ = cur
		return true
	else
		JJLog.i(TAG, "WARNNING: can not show softkwyboard")
	end

	return false
end

return JJInputMethodManager
