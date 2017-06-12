-------------------------------------------------------------------------
-- Desc:    Support初始化
-- Author:  zzx
-- Date:    2017.3.21
-- Last: 
-- Content:  统一处理Log
--    尽量使用sslog _cclog虽然可以用，但是不建议使用
-- Copyright (c) wawagame Entertainment All right reserved.
--------------------------------------------------------------------------
--log相关
--------------------------------------------------------------------------
--[[构造cocos风格日志函数]]--
--不建议用，请使用sslog
_cclog = function(...)

    if DEBUG >= 2 then

        local tmp = ...
        if tmp == nil then
            _cclog('nil')
            return
        end
	
        print(...)
        writeLogFile(...)
    end
end

sslog = function( moduleName, ...)
    if moduleName and ... then
		local temp = {...}
		if table.nums(temp)==1 then
			_cclog( '['.. moduleName .. ']' .. tostring(temp[1]))
		else
			_cclog( '['.. moduleName .. ']' .. string.format(...))
		end
    else
        _cclog( moduleName )
    end
end

writeLogFile = function( ... )
    --如果开启了写日志
    if _logConfigParam.writeLog and (DEBUG >= 2)  then
        local filePath = cc.FileUtils:getInstance():getWritablePath().._logConfigParam.logfileName
		local temp = {...}
		if table.nums(temp)==1 then
			io.writefile(filePath, os.date("[%Y-%m-%d %H:%M:%S] ", os.time()) .. tostring(temp[1]).."\n", "a")
		else
			io.writefile(filePath, os.date("[%Y-%m-%d %H:%M:%S] ", os.time()) .. string.format(...).."\n", "a")
		end
        
    else
    end
end

if DEBUG >= 2 then
    --[[日志文件初始化]]
    function initLogFile()
        local filePath = cc.FileUtils:getInstance():getWritablePath().._logConfigParam.logfileName
        if io.exists(filePath) then
            local fileSize = io.filesize(filePath)
            if fileSize > _logConfigParam.logfileSize then
                _cclog('[Log Module] logfile is too big, restart from now on : %d', fileSize)
                io.writefile(filePath, string.format('----------------------------------------------------'
                                                     ..'\n[Log Module] logfile is too big, restart from now on')
                                                     .."\n----------------------------------------------------\n", "w+"
                                                    )
            else
                _cclog('[Log Module] Currency log file size is : %d', fileSize)
            end
        end
    end
    initLogFile()
end


local function ccdump_value_(v)
    if type(v) == "string" then
        v = "\"" .. v .. "\""
    end
    return tostring(v)
end
--可以写入日志的table打印 详情开关见config.lua
function ssdump(value, desciption, nesting)

    if not _logConfigParam.OpenSSdump or (DEBUG < 2) then
        --三级Debug Level以下，或者关闭写dump，则直接return
        return
    end 
       
    if type(nesting) ~= "number" then nesting = 3 end

    local lookupTable = {}
    local result = {}

    local traceback = string.split(debug.traceback("", 2), "\n")
    _cclog("dump from: " .. string.trim(traceback[3]))

    local function dump_(value, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        local spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(ccdump_value_(desciption)))
        end
        if type(value) ~= "table" then
            result[#result +1 ] = string.format("%s%s%s = %s", indent or "", ccdump_value_(desciption) or "", spc or "", ccdump_value_(value) or "")
        -- elseif lookupTable[tostring(value)] then
        --     result[#result +1 ] = string.format("%s%s%s = *REF*", indent, ccdump_value_(desciption), spc)
        else
            lookupTable[tostring(value)] = true
            if nest > nesting then
                result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent or "", ccdump_value_(desciption) or "")
            else
                result[#result +1 ] = string.format("%s%s = {", indent or "", ccdump_value_(desciption) or "")
                local indent2 = indent.."    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = ccdump_value_(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then keylen = vkl end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    dump_(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result +1] = string.format("%s}", indent or "")
            end
        end
    end
    dump_(value, desciption, "- ", 1)

    for i, line in ipairs(result) do
       _cclog(line)
		--print(line,type(line))
    end
end

--[[ #param luaTable ]]--
function showErrorDialog( str )
    if _logConfigParam.dialogLog and DEBUG > 0  then
        --配置了弹窗日志，且Debug Level级别 > 0的情况下，crash弹窗
        --ww.IPhoneTool:getInstance():showMessage(str, "Lua Error")
		if myLua.LuaBridgeUtils and myLua.LuaBridgeUtils.showMessage then
			myLua.LuaBridgeUtils:showMessage(str,"Lua Error")
		end
    end
end

--[[重写错误堆栈捕获]]
__G__TRACKBACK__ = function(msg)
    -- local msg = debug.traceback(msg, 3)
    local msgAll = "LUA ERROR: " .. tostring(msg) .. "\n"
        ..debug.traceback().. "\n"

    print(msgAll)

    if device.platform == "ios" or device.platform == "android" then
        -- report lua exception
        buglyReportLuaException(tostring(msg), debug.traceback())
    end

    if _logConfigParam.writeLog then
        --写日志
        writeLogFile(msgAll)
    end

    if _logConfigParam.dialogLog then
        --弹窗日志
        showErrorDialog(msgAll)
    end

    return msg
end