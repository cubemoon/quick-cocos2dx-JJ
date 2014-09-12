local LoginScene = {}
local TAG = "LoginScene"

function LoginScene.extend(target)
    
    if target.onBackPressed == nil then
        target.onBackPressed = function()
            JJLog.i(TAG, "onBackPressed, Not Implement")
        end
    end

    -- 提示无网络
    if target.showNoNetworkDialog == nil then
        target.showNoNetworkDialog = function()
            JJLog.i(TAG, "showNoNetworkDialog, Not Implement")
        end
    end

    if target.showLoginDialog == nil then
        target.showLoginDialog = function()
            JJLog.i(TAG, "showLoginDialog, Not Implement")
        end
    end

    if target.showLoginFailed == nil then
        target.showLoginFailed = function()
            JJLog.i(TAG, "showLoginFailed, Not Implement")
        end
    end

    if target.showLoginHistoryList == nil then
        target.showLoginHistoryList = function()
            JJLog.i(TAG, "showLoginHistoryList, Not Implement")
        end
    end
end

return LoginScene