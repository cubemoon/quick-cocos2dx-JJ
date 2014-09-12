--[[
注册模块：包括注册相关参数返回含义等
]]
RegisterController = {}
local TAG = "[RegisterController]"

--获取短信验证码消息
MOBILE_REGIST_SUCCESS = 0 -- 成功
MOBILE_REGIST_FAIL = 1 -- 失败
MOBILE_REGIST_EXIST = 2 -- 已注册
MOBILE_REGIST_NULL = 12 -- 手机号为空
MOBILE_REGIST_GET_CODE_FAIL = 103 -- 获取验证码失败

function RegisterController:getMobileSMSPrompt(param)
    JJLog.i(TAG, "getMobileSMSPrompt")

    local ret = ""

    if param == MOBILE_REGIST_SUCCESS then
        ret = "短信验证码已发送到注册手机号，请注意查收!"
    elseif param == MOBILE_REGIST_FAIL then
        ret = "注册失败，请您重新注册！"
    elseif param == MOBILE_REGIST_EXIST then
        ret = "手机号已注册，请您使用未注册过的手机号注册！"
    elseif param == MOBILE_REGIST_NULL then
        ret = "手机号为空，请您使用正确的手机号注册！"
    elseif param == MOBILE_REGIST_GET_CODE_FAIL then
        ret = "获取短信验证码失败！"
    else
        ret = "获取短信验证码失败！"
    end

    return ret
end


--注册返回消息
PARAM_OK = 0
PARAM_LOGIN_NAME_EXIST = 10 -- 用户名已存在
PARAM_NICK_NAME_EXIST = 11 -- 昵称已存在
PARAM_LOGIN_NAME_ERR = 12 -- 登陆名错误
PARAM_NICK_NAME_ERR = 13 -- 昵称错误
PARAM_PASSWORD_ERR = 14 -- 密码错误
PARAM_VERIFY_CODE_ERR = 15 -- 验证码错误
PARAM_NICK_NAME_VALID = 16 -- 昵称非法
PARAM_EMAIL_ERR = 17 -- 免注册账户已经注册
PARAM_VERIFY_CODE_INVALID_DATE = 18 -- 验证码失效
PARAM_CLIENT_ERR = 200 -- 客户端签名错误
PARAM_PARTNER_ERR = 201 -- 合作方认证失败

function RegisterController:getRegistePrompt(param)
    JJLog.i(TAG, "getRegistePrompt")

    local ret = ""

    if param == PARAM_OK then
        ret = "注册成功！"
    elseif param == PARAM_LOGIN_NAME_EXIST then
        ret = "用户名已存在！"
    elseif param == PARAM_NICK_NAME_EXIST then
        ret = "昵称已存在！"
    elseif param == PARAM_LOGIN_NAME_ERR then
        ret = "用户名非法！"
    elseif param == PARAM_NICK_NAME_ERR then
        ret = "昵称非法！"
    elseif param == PARAM_PASSWORD_ERR then
        ret = "密码非法！";
    elseif param == PARAM_VERIFY_CODE_ERR then
        ret = "验证码错误！"
    elseif param == PARAM_NICK_NAME_VALID then
        ret = "昵称非法！"
    elseif param == PARAM_EMAIL_ERR then
        ret = "免注册账户已经注册！"
    elseif param == PARAM_VERIFY_CODE_INVALID_DATE then
        ret = "验证码已过期！"
    elseif param == PARAM_CLIENT_ERR then
        ret = "客户端签名错误！"
    elseif param == PARAM_PARTNER_ERR then
        ret = "合作方认证失败！"
    else
        ret = "注册失败！"
    end

    return ret
end

--判断是否是手机号，目前只判断是否为1开头，且为11的数字
function RegisterController:isMobileNumber(param)
    JJLog.i(TAG, "isMobileNumber")

    local ret = false

    local number = tonum(param)

    if (number) and (number > 10000000000) and (number < 20000000000) then
        ret = true
    end

    return ret
end

--判断输入的字符串，是否是字母、数字或者下划线
function RegisterController:isLetter_Number(input)
    JJLog.i(TAG, "isLetter_Number")

    local ret = false
    local len = 0

    if (input) then
        len = string.len(input)
    end

    if (len > 0) then
        ret = true

        for i = 1, len do
            local c = string.byte(input, i, i) --取每一个字符
            if (c == 95) then --下划线
            elseif ((c >= 65 and c <= 90) or (c >= 97 and c <= 122)) then --大小写字母
            elseif (c >= 48 and c <= 57) then --数字
            else
                ret = false
                break
            end
        end
    end

    return ret
end

--判断输入的字符串，是否是字母、数字或者下划线，至少两种组合
function RegisterController:isLetter_NumberUnion(input)
    JJLog.i(TAG, "isLetter_Number")

    local ret = false
    local prompt = "密码必须包括数字、字母和下划线的其中两类"

    local underline = 95
    local len = 0

    if (input) then
        len = string.len(input)
    end

    if (len > 0) then
        local hasUnderline, hasLetters, hasNumbers = 0, 0, 0

        for i = 1, len do
            local c = string.byte(input, i, i) --取每一个字符
            --JJLog.i("c =",c)

            if (c == underline) then --下划线
                hasUnderline = 1
                --JJLog.i("is Underline",c)
            elseif ((c >= 65 and c <= 90) or (c >= 97 and c <= 122)) then --大小写字母
                hasLetters = 1
                --JJLog.i("is letters",c,rst,over)
            elseif (c >= 48 and c <= 57) then --数字
                hasNumbers = 1
                --JJLog.i("is numbers",c)
            else
                prompt = "密码包含非法字符"
                return ret, prompt
            end
        end

        local union = hasUnderline + hasLetters + hasNumbers
        if (union >= 2) then
            ret = true
            prompt = ""
        end
    end

    return ret, prompt
end

function RegisterController:checkOnePassword(password, promptNull)
    JJLog.i(TAG, "checkOnePassword")

    local valid = false
    local prompt = ""

    local len = 0

    if (password ~= nil) then
        len = string.len(password)
    end

    if len == 0 then
        if (promptNull) then
            prompt = "密码不能为空！" --为空时不提示
        end
        JJLog.i(TAG, "ERR: password is nil")
    elseif len < 8 then
        prompt = "密码最少8位"
        JJLog.i(TAG, "ERR: password is short")
    elseif len > 18 then
        prompt = "密码过长！"
        JJLog.i(TAG, "ERR: password is long")
    elseif (string.find(password, " ")) then
        prompt = "密码不支持空格哦"
    else
        valid, prompt = self:isLetter_NumberUnion(password)
    end

    return valid, prompt
end


--判断两次输入的密码，返回3个参数，1、是否valid；2、password提示string；3、confirm提示string
function RegisterController:checkRegistePassword(password, confirm)
    local valid = false

    local validpw, pmpw = self:checkOnePassword(password)
    local validcnf, pmcnf = self:checkOnePassword(confirm)

    if (validpw and validcnf) then
        if (password == confirm) then
            valid = true
        else
            pmpw = "两次密码不一致"
            pmcnf = "两次密码不一致"
        end
    end

    JJLog.i(TAG, "checkRegistePassword ", valid, pmpw, pmcnf)
    return valid, pmpw, pmcnf
end

--注册成功后，保存用户名和密码
function RegisterController:SaveAccountAfterSuccess(username, password)
    -- 保存到登录历史中
    local loginData = require("game.data.login.LoginData")
    loginData:trace()
    if loginData ~= nil then
        loginData:addRecord(LOGIN_TYPE_JJ, username, password)
    end

    MainController.autoLogin_ = true
end

return RegisterController