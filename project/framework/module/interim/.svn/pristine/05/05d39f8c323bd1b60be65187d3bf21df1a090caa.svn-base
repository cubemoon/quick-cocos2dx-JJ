require("sdk.JJSDK")
require("game.controller.MainController")

local ProjectApp = class("ProjectApp")
local TAG = "ProjectApp"

local init = false

function ProjectApp:run()

    self:initRes()
    MainController:init(CURRENT_PACKAGE_ID)
    MainController:pushScene(CURRENT_PACKAGE_ID, JJSceneDef.ID_MATCH_SELECT, CURRENT_PACKAGE_ID)
end

-- 初始化资源
function ProjectApp:initRes()
    JJLog.i(TAG, "initRes, init=", init)
    if init == false then
        init = true
        CCFileUtils:sharedFileUtils():addSearchPath(device.writablePath .. "update/module/interim/res/")
        CCFileUtils:sharedFileUtils():addSearchPath("module/interim/res/")

        local InterimDimens = require("interim.ui.InterimDimens")
        InterimDimens:init()
        registerSizeChangeListener("interim", handler(InterimDimens, InterimDimens.init))
   end
end

return ProjectApp
