--
-- Author: xinxy
-- Date: 2014-05-20 19:27:58
--
local snap = class("snap")

function snap:ctor()
end

function snap:snapImage(gamename, format, dimens, isToast)
    -- 兼容老接口
    local toast = true--默认显示toast
    if isToast ~= nil then
        toast = isToast
    end

    JJLog.i("snap", "snapImage IN format is ", format, "kCCImageFormatPNG is ", kCCImageFormatPNG)
    if format ~= kCCImageFormatPNG and format ~= kCCImageFormatJPEG then
        format = kCCImageFormatJPEG
    end

    local ex = ".jpg"
    if format == kCCImageFormatPNG then
        ex = ".png"
    end

    local size = CCDirector:sharedDirector():getWinSize()
    local screen = CCRenderTexture:create(size.width, size.height, 0)
    local temp = CCDirector:sharedDirector():getRunningScene()
    screen:begin()
    temp:visit()
    screen:endToLua()

    local file = "data\\" .. gamename .. os.time() .. ex
    if screen:saveToFile(file, format) == true and toast then
        jj.ui.JJToast:show({
            text = "图片已保存至" .. file,
            dimens = dimens,
        })
    end

    return file
end

return snap