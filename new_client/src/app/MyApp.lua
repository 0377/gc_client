
--还原为初始化，防止在热启动的时候重复添加
cc.FileUtils:getInstance():setSearchPaths(InitSearchPaths)
local writablePath = cc.FileUtils:getInstance():getWritablePath();
cc.FileUtils:getInstance():addSearchPath(writablePath,true);
local framePaths = {
	"frame/src/",
	"frame/src/3rd/",
	"frame/src/config/",
	"frame/src/controller/",
	"frame/src/views/",
	"frame/src/utils/",
	"frame/res/",
	"frame/res/csb/"
}
for i,v in ipairs(framePaths) do
	local tempPath = writablePath..v
	cc.FileUtils:getInstance():addSearchPath(tempPath,true);
	--print("tempFrame:"..tempPath);
end
local resRootPath = "res/"
for i,v in ipairs(framePaths) do
	local tempPath = resRootPath..v;
	cc.FileUtils:getInstance():addSearchPath(tempPath);
end
---重写require函数，用于在游戏热更新后，重新热加载
function requireForGameLuaFile(file)
	if needReloadLuaFileArray == nil then
		--todo
		needReloadLuaFileArray = {}
	end
	needReloadLuaFileArray[file] = file
	local  x
	xpcall(function()
		x = require(file)
	end, function( ... )
		needReloadLuaFileArray[file] = nil
	end)
	return x
end
--重新加载lua文件
function reloadGameLuaFiles()
	if needReloadLuaFileArray ~= nil then
		--todo
		--清除缓存路径
		cc.FileUtils:getInstance():purgeCachedEntries();
		-- dump(needReloadLuaFileArray, "needReloadLuaFileArray", nesting)
		-- local searchPaths = cc.FileUtils:getInstance():getSearchPaths();
		-- dump(searchPaths, "searchPaths", nesting)
		local loaded = package.loaded;
		for k,v in pairs(needReloadLuaFileArray) do
			loaded[k] = nil;
			requireForGameLuaFile(k);
		end
	end
end
--游戏管理类
gameManagerInstance = nil;
--热重启游戏
function restartGame()
	GameManager.destory();
    reloadGameLuaFiles()
    require("app.MyApp"):create();
end
local MyApp = class("MyApp", cc.load("mvc").AppBase)
package.loaded["CustomHelper"] = nil
package.loaded["GameManager"] = nil
package.loaded["LogUtils"] = nil
requireForGameLuaFile("CustomHelper");
requireForGameLuaFile("GameManager");
requireForGameLuaFile("LogUtils");
function MyApp:onCreate()
	GameManager:getInstance():start();
    math.randomseed(os.time())
end

return MyApp
