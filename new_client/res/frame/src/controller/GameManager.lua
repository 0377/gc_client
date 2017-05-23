GameManager = class("GameManager");
local search = cc.FileUtils:getInstance():getSearchPaths();

requireForGameLuaFile("MsgPBParseManager")
requireForGameLuaFile("VersionManager")
requireForGameLuaFile("DownloaderManager")
requireForGameLuaFile("MusicAndSoundManager");
requireForGameLuaFile("NetworkManager")
function GameManager:getInstance()
	if self.networkManager then
		--todo
		self.networkManager:release()
		self.networkManager = nil;
	end
	if gameManagerInstance == nil then
		--todo
		gameManagerInstance = GameManager:new();
	end
	return gameManagerInstance;
end
function GameManager.destory()
	dump(gameManagerInstance, "gameManagerInstance", nesting)
	if gameManagerInstance then
		--todo
		gameManagerInstance:release();
		gameManagerInstance = nil;
	end
end
function GameManager:release()
	if self.networkManager then
	--todo
		self.networkManager:destory()
		self.networkManager = nil;
	end
	if self.msgPBParseManager then
		--todo
		self.msgPBParseManager = nil;
	end
	if self.hallManager then
		--todo
		self.hallManager:reset();
		self.hallManager = nil;
	end
	if self.versionManager then
		--todo
		self.versionManager = nil;
	end
	if self.downloaderManager  then
		--todo
		self.downloaderManager = nil;
	end
	if self.musicAndSoundManager then
		--todo
		self.musicAndSoundManager = nil;
	end
end
function GameManager:ctor()
	--构建 网络管理器
	self.networkManager = NetworkManager:create();
	--创建消息解码器
	self.msgPBParseManager = MsgPBParseManager:create();
	--初始化大厅管理器，在大厅资源下载完成后创建
	self.hallManager = nil;
	-- --创建更新管理器
	self.versionManager = VersionManager:create();
	--下载管理器
	self.downloaderManager = DownloaderManager:create();
	--音乐音效管理器
	self.musicAndSoundManager = MusicAndSoundManager:create()
end
--得到网络接口
function GameManager:getNetworkManager()
	return self.networkManager;
end
--得到消息解析类
function GameManager:getMsgPBParseManager()
	return self.msgPBParseManager;
end
--得到大厅管理器
function GameManager:getHallManager()
	return self.hallManager;
end
--得到版本管理器
function GameManager:getVersionManager()
	return self.versionManager;
end
--返回下载管理器
function GameManager:getDownloaderManager()
	return self.downloaderManager;
end
--返回音效管理器
function GameManager:getMusicAndSoundManager()
	return self.musicAndSoundManager
end
--大厅版本检测完成
function GameManager:callbackWhenHallVersionDownloadFinished()
	--初始化大厅searchpath
	if global_initSearchPathBeforeEnterHall == nil then
		--todo
		global_initSearchPathBeforeEnterHall = cc.FileUtils:getInstance():getSearchPaths();
	end
	--还原为初始化，防止在重复添加
	cc.FileUtils:getInstance():setSearchPaths(global_initSearchPathBeforeEnterHall)
	--todo
	local hallSkinName = "hall";
	local writablePath = cc.FileUtils:getInstance():getWritablePath();
	--添加大厅相关资源
	local hallPaths = {
		hallSkinName.."/src",
		hallSkinName.."/src/3rd/",
		hallSkinName.."/src/config/",
		hallSkinName.."/src/controller/",
		hallSkinName.."/src/model/",
		hallSkinName.."/src/views/",
		hallSkinName.."/src/views/scenes",
		hallSkinName.."/src/views/layers",
		hallSkinName.."/src/utils/",
		hallSkinName.."/res/",
		hallSkinName.."/res/ccs_export/",
		hallSkinName.."/res/pb_files/"
	}
	for i,v in ipairs(hallPaths) do
		local tempPath = writablePath..v
		cc.FileUtils:getInstance():addSearchPath(tempPath,true);
		--print("tempFrame:"..tempPath);
	end
	local resRootPath = "res/"
	for i,v in ipairs(hallPaths) do
		local tempPath = resRootPath..v;
		cc.FileUtils:getInstance():addSearchPath(tempPath);
	end
	
	-- local searchs = cc.FileUtils:getInstance():getSearchPaths();
	-- dump(searchs, "searchs", nesting);
	local HallManager = requireForGameLuaFile("HallManager");
	if self.hallManager then
		--todo
		self.hallManager:reset();
		self.hallManager = nil;
	end
	self.hallManager = HallManager:create();
	self.hallManager:start();
end
function GameManager:start()
	local LaunchScene = requireForGameLuaFile("LaunchScene");
	local launchScene = LaunchScene:create();
	local runningScene = cc.Director:getInstance():getRunningScene();
	if runningScene then
		--todo
		cc.Director:getInstance():replaceScene(launchScene)
	else
		cc.Director:getInstance():runWithScene(launchScene)
	end
	-- cc.Director:getInstance():runWithScene("launchScene")
	-- launchScene:showWithScene();
end
---从底层收到msg消息
function GameManager:callbackWhenReceiveOneFullTCPMsg(msgID,dataStr)
	--根据消息id解析dataStr
	self.hallManager:dealWithWhenReceiveOneFullTCPMsg(msgID,dataStr);
end

--第三方回调游戏
function GameManager:threedCallFunction(urlScheme,dataStr)
	print("urlScheme:",urlScheme)
	print("dataStr:",dataStr)
end

function GameManager:callbackWhenLogoutFinished()
	self.hallManager:reset();
	self.downloaderManager:reset();
end
--从底层收到tcp连接状态变化通知
function GameManager:callbackWhenReceiveTCPConnectionStatusModiy(connectionID,status)
	print("callbackWhenReceiveTCPConnectionStatusModiy:connectionID:"..connectionID..",status:"..status);
	if connectionID == self.hallManager:getHallDataManager():getConnectionID() then
		--todo
		self.hallManager:callbackWhenReceiveTCPConnectionStatusModiy(status);
	end
end
--从服务器获取最新配置信息
function GameManager:getServerConfig(callback)
	self.versionManager:getNewestClientConstTabFromServer(callback);
end
return GameManager;

