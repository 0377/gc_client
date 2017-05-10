-------------------------------------------------------------------------
-- Desc:    BaseCore
-- Author:  diyal.yin
-- Date:    2015.10.22
-- Last:    
-- Content:  文字国际化
-- Copyright (c) wawagame Entertainment All right reserved.
--------------------------------------------------------------------------
Tmji18nUtils = class("Tmji18nUtils")

Tmji18nUtils.instance = nil
function Tmji18nUtils:getInstance()
	if Tmji18nUtils.instance == nil then
		Tmji18nUtils.instance = Tmji18nUtils:create()
	end
	return Tmji18nUtils.instance
end

--[[
加载文件
@param filename 国际化文件名
@parame lang 语言版本
]]--
function Tmji18nUtils:load(filename, lang)

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

function Tmji18nUtils:get(module, key)

	if (type(module) ~= 'string') or (type(key) ~= 'string') then
		printLog('[ShuSiLog]/error', 'params must been string type')
		return
	end

	local returnStr

	--到相应的模块查找相应的Key
	local moduleTable = self.stringTables[module]
	if nil == moduleTable then
		returnStr = ''
	end

	local value = moduleTable[key]
	if nil == value then
		returnStr = ''
	else
		returnStr = value
	end

	return returnStr
end
return Tmji18nUtils