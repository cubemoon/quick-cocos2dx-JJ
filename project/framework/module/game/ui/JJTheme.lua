local JJTheme = class("JJTheme")

local TAG = "JJTheme"

--[[
    获取该主题的某个图片内容
    @path: 图片在改项目中的完整路径
    @image: 图片不区分项目的路径
]]
function JJTheme:getImage(path, image)
    if JJFileUtil:exist(path) then
        return path
    elseif JJFileUtil:exist("img/" .. image) then
        return "img/" .. image
    end
    JJLog.e(TAG, "getImage, image=", image)
    return "img/no_image.png"
end

return JJTheme