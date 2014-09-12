require("io")
require("lfs")

JJFileUtil = {}

local TAG = "JJFileUtil"


-- 文件是否存在：针对相对路径
function JJFileUtil:exist(filePath)
	local ret = false

    local path = CCFileUtils:sharedFileUtils():fullPathForFilename(filePath)
    if CCFileUtils:sharedFileUtils():isFileExist(path) then
        ret = true
    end
    -- JJLog.i(TAG, "JJFileUtil:exist(), ret=", ret, ", fullpath=", path)

	return ret
end

-- 写文件
function JJFileUtil:writeFile(filePath, content, mode)
	self:checkPathWin32(filePath)
	-- JJLog.i(TAG, "writeFile, filePath=" .. filePath)
	local path = filePath
	if not self:isAbsolutePath(filePath) then
		path = device.writablePath .. filePath
	end
	local pathInfo = self:pathinfo(path)
		
	if not JJFileUtil:exist(pathInfo.dirname) then	
		JJFileUtil:mkdir(filePath)
	end
	return io.writefile(path, content, mode)
end

function JJFileUtil:pathinfo(path)
    local pos = string.len(path)
    local extpos = pos + 1
    while pos > 0 do
        local b = string.byte(path, pos)
        if b == 46 then -- 46 = char "."
            extpos = pos
        elseif b == 47 then -- 47 = char "/"
            break
        elseif b == 92 then -- 92 = char "\"
        	break
        end
        pos = pos - 1
    end

    local dirname = string.sub(path, 1, pos)
    local filename = string.sub(path, pos + 1)
    extpos = extpos - pos
    local basename = string.sub(filename, 1, extpos - 1)
    local extname = string.sub(filename, extpos)
    return {
        dirname = dirname,
        filename = filename,
        basename = basename,
        extname = extname
    }
end

-- 建立文件夹，递归进行，从 writable 目录往下
function JJFileUtil:mkdir(path)
	-- JJLog.i(TAG, "mkdir, path=" .. path)
	
	local isAbs = self:isAbsolutePath(path)
	if JJFileUtil:exist(path) then
		return
	end

	local separate = "/"
	
	--input is same, windows do not need this action fanqitao 20140312
	--if device.platform == "windows" then
	--	separate = "\\"
	--end
	
	local i = string.find(path, separate, 1)
		
	while i ~= nil do
		local separtePath = string.sub(path, 1, i)
		
		-- local tmp = writePath .. separtePath
		local tmp = separtePath
		if not isAbs then
			tmp = device.writablePath .. separtePath
		end
		
		if not JJFileUtil:exist(tmp) then
      		if device.platform == "ios" or device.platform == "windows" then
      			CCFileUtils:sharedFileUtils():createPath(separtePath)
      		else
      			os.execute(('mkdir ' .. tmp))
      		end
		end
		
		i = string.find(path, separate, i + 1)
	end
end

function JJFileUtil:checkPathWin32(path)
	if device.platform ~= "windows" then
		return path
	end
	return string.gsub(path, "/", "\\")
end

-- 获取文件的全路径，不存在返回 nil
function JJFileUtil:getFullPath(filePath)
    -- JJLog.i(TAG, "getFullPath, filePath=", filePath)

    if JJFileUtil:exist(filePath) then
        return CCFileUtils:sharedFileUtils():fullPathForFilename(filePath)
    end

    return nil
end

-- 获取文件的大小
function JJFileUtil:getFileSize(path)
	local fp = io.open(path, "rb")
	if not fp then return 0 end
	local size = fp:seek("end")
	fp:close()
	return size
end

-- 获取目录的大小，如果目录为空则返回0
function JJFileUtil:getDirSize(path)
	local files = self:getFilesOfDir(path)
	dump(files, "dir files")
	if #files == 0 then return 0 end
	local totalSize = 0
	for i = 1, #files do
		local size = self:getFileSize(files[i])
		totalSize = totalSize + size
	end
	return totalSize
end

--[[
	获取指定目录下的文件集合
	@param dirPath:目录的绝对路径
	       files:存放该目录下文件信息的表格
	@return 存放该目录下文件信息的表格
]]
function JJFileUtil:getFilesOfDir(dirPath, files)
	local len = string.len(dirPath)
	if string.sub(dirPath, -1) == "/" or string.sub(dirPath, -1) == "\\" then
		dirPath = string.sub(dirPath, 0, len - 1)
	end
    local files = files or {}
    for entry in lfs.dir(dirPath) do
        if entry ~= '.' and entry ~= '..' then
            local path = dirPath .. '/' .. entry
            local attr = lfs.attributes(path)
            assert(type(attr) == 'table')
            if attr.mode == 'directory' then
                self:getFilesOfDir(path, files)
            else
                table.insert(files, path)
            end
        end
    end
    return files
end

--[[
	拷贝文件
	@param srcPath:被拷贝的文件路径，需是绝对路径
	       desPath:拷贝到的新路径
	@return 返回true表示拷贝成功
]]
function JJFileUtil:copyFile(srcPath, desPath)
	local content = io.readfile(srcPath)
	return self:writeFile(desPath, content, "w")
end

--[[
	拷贝目录（包含其子目录以及文件）到指定目录下
	@param srcPath:被拷贝的源目录
		   desPath:拷贝到指定目录
	@return 返回true表示拷贝成功
]]
function JJFileUtil:copyDir(srcPath, desPath)
	local pos = string.len(srcPath) - 1
    while pos > 0 do
        local b = string.byte(srcPath, pos)
        -- 47 represent "/" and 92 represent "\"
        if b == 47 or b == 92 then
            break
        end
        pos = pos - 1
    end
    local srcDir = string.sub(srcPath, pos + 1, -1)
    local path = desPath .. srcDir
	local files = self:getFilesOfDir(srcPath)
	for i = 1, #files do
		local p = string.find(files[i], srcDir)
		local writePath = desPath .. string.sub(files[i], p, -1)
		-- JJLog.i(TAG, "writePath : ", writePath, " files[i] : ", files[i], " srcDir : ", srcDir)
		if not self:copyFile(files[i], writePath) then
			return false
		end
	end
	return true
end

--[[
	判断是否为绝对路径
	@param 所需判断的路径字符串
]]
function JJFileUtil:isAbsolutePath(path)
	if device.platform == "windows" then
		-- 路径第二个字符为":"
		local head = string.sub(path, 2, 2)
		return head == ":"
	else
		-- 路径第一个字符为"/"
		return string.sub(path, 0, 1) == "/"
	end
end

--[[
	删除指定目录
	@param 删除目录的路径
	@return 返回true表示删除成功
]]
function JJFileUtil:removeDir(path)
	if not self:isAbsolutePath(path) then
		path = device.writablePath .. path
	end
	-- local cmd = "RD /S /Q " .. path
	local cmd = "rm -r " .. path
	return os.execute(cmd)
end

function JJFileUtil:getExternalStorageDirectory()
	-- JJLog.i(TAG, "getExternalStorageDirectory()")
	local value = ""
	if device.platform == "android" then
		className = "cn/jj/base/JJUtil"
		methodName = "getExternalStorageDirectory"
		args = {}
		sig = "()Ljava/lang/String;"
		local result
		result, value = luaj.callStaticMethod(className, methodName, args, sig)
		-- print(TAG, "getExternalStorageDirectory value = ", value)
	elseif device.platform == "ios" then
		
	end
	return value
end

return JJFileUtil
