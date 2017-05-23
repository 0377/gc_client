-------------------------------------------------------------------------
-- Desc:    BaseCore
-- Author:  zengzx
-- Date:    2017.5.11
-- Last:    
-- Content:  文字国际化
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
SHi18nUtils = class("SHi18nUtils")

SHi18nUtils.instance = nil
function SHi18nUtils:getInstance()
	if SHi18nUtils.instance == nil then
		SHi18nUtils.instance = SHi18nUtils:create()
	end
	return SHi18nUtils.instance
end

--[[
加载文件
@param filename 国际化文件名
@parame lang 语言版本
]]--
function SHi18nUtils:load(filename, lang)

    --加载国际化文件
	local languageLuaFile = string.format("%s_%s",filename, lang)
	printLog(languageLuaFile)

    --有保护的加载i18n文件
	local ret, languageString = pcall(requireForGameLuaFile,languageLuaFile)
	if ret == false then
		printLog('[ShuSiLog]/error', 'load string file failed, not default string file exist')
	end

	self.stringTables = languageString

	-- dump(self.stringTables)
end

function SHi18nUtils:get(module, key)

	if (type(module) ~= 'string') or not (not key or type(key) == 'string') then
		printLog('[ShuSiLog]/error', 'params must been string type')
		return
	end

	local returnStr

	--到相应的模块查找相应的Key
	local moduleTable = self.stringTables[module]
	if nil == moduleTable then
		returnStr = ''
	end
	if key then
		local value = moduleTable[key]
		if nil == value then
			returnStr = ''
		else
			returnStr = value
		end
	else
		return moduleTable
	end


	return returnStr
end
return SHi18nUtils