local InterimTheme = class("InterimTheme", require("game.ui.JJTheme"))

function InterimTheme:getImage(image)
    local path = "img/interim/" .. image
    return InterimTheme.super.getImage(self, path, image)
end

return InterimTheme