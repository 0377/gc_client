HallManager = class("HallManager");

requireForGameLuaFile("PlayerInfo");
requireForGameLuaFile("HallMsgManager");
requireForGameLuaFile("HallDataManager")
requireForGameLuaFile("SceneController")
requireForGameLuaFile("ViewManager")
local scheduler = cc.Director:getInstance():getScheduler()
 
function HallManager:ctor()
		--大厅数据处理类  that is  not player data
	CustomHelper.addSetterAndGetterMethod(self,"hallDataManager",HallDataManager:create());
	--玩家数据类  player data
	CustomHelper.addSetterAndGetterMethod(self,"playerInfo",nil);
	--得到大厅消息处理类 send and receive d
	CustomHelper.addSetterAndGetterMethod(self,"hallMsgManager",HallMsgManager:create());
	--子游戏管理类
	CustomHelper.addSetterAndGetterMethod(self,"subGameManager",nil);
	--增加秒定时器
	-- CustomHelper.performWithDelayGlobal(function()
	-- 		self:refreshByOneSecond();
	-- 	end,1,true)
	self:init();
end
function HallManager:init()
	local HallGameConfigTab = GameManager:getInstance():getVersionManager():getHallInfoConfigTab();
	self.hallDataManager:initDataWithServerConfig(HallGameConfigTab);	
end
function HallManager:start()
	--还原数据
	self:reset();
	CustomHelper.unscheduleGlobal(self.secondScheduleID);
	self.secondScheduleID = scheduler:scheduleScriptFunc(function()
		-- print("11111111111111111111111111:")
		self:refreshByOneSecond();
	end, 1.0, false)
	local HallInit = requireForGameLuaFile("HallInit");
	HallInit:start()
end
function HallManager:connect()
	print("connect addr:",self.hallDataManager:getTcpAddr())
	self.hallMsgManager:connect(self.hallDataManager:getConnectionID(),self.hallDataManager:getTcpAddr(),self.hallDataManager:getTcpPort())
end
function HallManager:callbackWhenReceiveTCPConnectionStatusModiy(status)
	self.hallMsgManager:callbackWhenReceiveTCPConnectionStatusModiy(status)
end
---处理收到的消息
function HallManager:dealWithWhenReceiveOneFullTCPMsg(msgID,dataStr)
		--print("GameManager:callbackWhenReceiveOneFullTCPMsg:",msgID,",dataStr:",dataStr);
	self.hallMsgManager:callbackWhenReceiveOneFullMsg(msgID,dataStr);
end
--登录处理完成
function HallManager:callbackWhenLoginFinished()
	--进入大厅场景
	--增加“xxx登陆游戏”的跑马灯提示
	local playerInfo = self.playerInfo;
	local marqueeStr = string.format("欢迎“%s”进入游戏，祝您游戏愉快！",playerInfo:getNickName())
	marqueeStr = CustomHelper.encodeURI(marqueeStr)
	--[[
	// 跑马灯
	message Marquee{
		optional int32  id = 1;							// 编号
		optional int32  start_time = 2;					// 开始时间
		optional int32  end_time = 3;					// 结束时间
		optional string content = 4;					// 消息内容
		optional int32 number = 5;						// 轮播次数
		optional int32 interval_time = 6;				// 轮播时间间隔（秒）	
	}
	]]
	local welcomeMarquee = {
		id = 1,
		content = marqueeStr,
		number = 1
	}
	local msgTab = {
		pb_msg_data = welcomeMarquee
	}
	self.hallMsgManager:on_SC_NewMarquee(msgTab);
	SceneController.goHallScene();
end
function HallManager:reset()
	self.hallMsgManager:reset();
	self.hallDataManager:reset();
	CustomHelper.unscheduleGlobal(self.secondScheduleID);
end
--进入某个游戏
function HallManager:enterOneGameWithGameInfoTab(infoTab)
	dump(infoTab,"infoTab")
	--游戏二级id
	local gameType = infoTab[HallGameConfig.GameIDKey];
	local gameSecondId = infoTab[HallGameConfig.SecondRoomIDKey];
	local serverID = infoTab["game_id"];
	--从服务器常量中获取数据
	local allOpenGames = self.hallDataManager:getAllOpenGamesDeatilTab();
	print("gameType:",gameType);
	local curTyeGameDetailTab = allOpenGames[gameType];
	local roomListTab = curTyeGameDetailTab[HallGameConfig.SecondRoomKey];
	local gameDetailTab = CustomHelper.copyTab(curTyeGameDetailTab);
	gameDetailTab[HallGameConfig.SecondRoomKey] = nil;
	for i,v in ipairs(roomListTab) do
		if v[HallGameConfig.SecondRoomIDKey] == gameSecondId  then
			--todo
			CustomHelper.updateJsonTab(gameDetailTab,v);
			break;
		end
	end
	dump(gameDetailTab, "gameDetailTab", nesting)
    self.hallDataManager:setCurSelectedGameDetailInfoTab(gameDetailTab);
    --根据配置文件加载子游戏搜索路径
    self:initSubGameSearchPath()
	local gameEntry = gameDetailTab[HallGameConfig.GameEntranceKey];	
    local sceneClass = requireForGameLuaFile(gameEntry);
    sceneClass:create();
    dump(sceneClass, "sceneClass", nesting)
    --切换场景
    local needPreloadResArray = sceneClass:getNeedPreloadResArray();
    SceneController.goOneSceneWithPreloadArray(needPreloadResArray,function()
    	local scene = sceneClass:getStartScene(infoTab);
    	SceneController.goOneScene(scene)
    end, infoTab)
end
function HallManager:initSubGameSearchPath()
	local gameDetailTab = self.hallDataManager:getCurSelectedGameDetailInfoTab()
	local packageRootPath = gameDetailTab[HallGameConfig.GamePackageRootPathKey]

	if global_initSearchPathBeforeEnterGame == nil then
		--todo
		global_initSearchPathBeforeEnterGame = cc.FileUtils:getInstance():getSearchPaths();
	end
	--还原为初始化，防止在重复添加
	cc.FileUtils:getInstance():setSearchPaths(global_initSearchPathBeforeEnterGame)
	local needSearchPath = {
		"src",
		"src/config/",
		"src/controller/",
		"src/views/",
		"src/model/",
		"res",
		"res/ccs_export/"
		-- "res/pb_files"
	}
	local writablePath = cc.FileUtils:getInstance():getWritablePath();
	local resRootPath = "res/";
	for i,v in ipairs(needSearchPath) do
		local tempPath = packageRootPath..v
		cc.FileUtils:getInstance():addSearchPath(writablePath..tempPath,true);
		cc.FileUtils:getInstance():addSearchPath(resRootPath..tempPath);
	end
	-- dump(cc.FileUtils:getInstance():getSearchPaths(), "searchPath", nesting)
end

function HallManager:clearLoadedOneGameFiles(  )
	self.subGameManager:clearLoadedOneGameFiles()
end

function HallManager:refreshByOneSecond()
	self.hallDataManager:refreshByOneSecond();
	self.hallMsgManager:refreshByOneSecond();
end
return HallManager;
--





































