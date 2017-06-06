local SubGameBaseManager = requireForGameLuaFile("SubGameBaseManager");
DflhjGameManager = class("DflhjGameManager",SubGameBaseManager);
import(".DflhjGameDataManager");

DflhjGameManager.MsgName = 
{
	SC_Slotma_Start = "SC_Slotma_Start",--开始游戏返回
	CS_Slotma_Start = "CS_Slotma_Start",--请求开始游戏
	CS_SlotmaPlayerConnectGame = "CS_SlotmaPlayerConnectGame",--断线重连
	CS_SlotmaLeaveGame = "CS_SlotmaLeaveGame",--离开游戏
	SC_SimpleRespons = "SC_SimpleRespons"
}

function DflhjGameManager:clearLoadedOneGameFiles()
	-- body
	local loaded = package.loaded;
    --重新加载frame内文件
    loaded["DflhjGameDataManager"] = nil;
    loaded["DflhjGameManager"] = nil;
    loaded["DflhjGameEnd"] = nil;
    loaded["DflhjGameTips"] = nil;
  
    DflhjGameManager.instance = nil;
end

----1准备状态
----2可以下注
DflhjGameManager.instance = nil;
function DflhjGameManager:getInstance()
	if DflhjGameManager.instance == nil then
		DflhjGameManager.instance = DflhjGameManager:create();
	end
	return DflhjGameManager.instance;
end



function DflhjGameManager:ctor()

	self.gameDetailInfoTab = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab();
	CustomHelper.addSetterAndGetterMethod(self,"packageRootPath",self.gameDetailInfoTab[HallGameConfig.GamePackageRootPathKey]);--游戏包根目录，在HallGameConfig中配置
	CustomHelper.addSetterAndGetterMethod(self,"dataManager",DflhjGameDataManager:create());--游戏数据管理器
	--注册pb文件
	self:registerPBProtocolToHallMsgManager();
	DflhjGameManager.super.ctor(self)
	self.subGameTipsConfig = requireForGameLuaFile("LhjTipsConfig");
end
--注册协议到协议解析中
function DflhjGameManager:registerPBProtocolToHallMsgManager()
	local pbFileTab = {};
	table.insert(pbFileTab,"common_msg_slotma.proto");
	local hallMsgManager = GameManager:getInstance():getHallManager():getHallMsgManager();
	for k,v in pairs(pbFileTab) do
		local filePath =  v --self.packageRootPath.."res/pb_files/" ..
		local pbFullPath = cc.FileUtils:getInstance():fullPathForFilename(filePath);
		hallMsgManager:registerProtoFileToPb(pbFullPath);
	end

	--增加解析key
	for k,v in pairs(DflhjGameManager.MsgName) do
		hallMsgManager:registerMsgNameToMsgPBMananager(v);
	end
	DflhjGameManager.super.registerPBProtocolToHallMsgManager(self)
end


--增加消息处理监听函数
function DflhjGameManager:registerNotification()
	
end

----开始游戏获取数据
--	cellTimes 底注的倍数
--	lines 选择押注线的列表
function DflhjGameManager:sendStartGame(cellTimes,lines)
	local msgTab = {
		cell_times = cellTimes,
		lines = lines,
	}
	--发送消息前清理收到的数据
	self.dataManager:clearRoundData()
	local msgName = DflhjGameManager.MsgName.CS_Slotma_Start;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end

----开始游戏获取数据
function DflhjGameManager:sendPlayerReconnection()
	-- body
	local msgTab = {}
	local msgName = DflhjGameManager.MsgName.CS_SlotmaPlayerConnectGame;
	--发送消息前清理收到的数据
	-- self.dataManager:clearRoundData()
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end

function DflhjGameManager:on_SC_Slotma_Start(msgTab)
	-- body
	print( "开始游戏返回数据")
	self.dataManager:OnMsg_Slotma_Start(msgTab)
	
end

--离开房间
function DflhjGameManager:sendLeaveGame()
	local msg = {}
	local msgName = DflhjGameManager.MsgName.CS_SlotmaLeaveGame;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msg)
end

-- ----游戏停服消息
-- function DflhjGameManager:on_SC_GameServerStop(msgTab)
-- 	self.dataManager:OnMsg_GameServerStop(msgTab)
-- end


-- function DflhjGameManager:on_SC_StandUpAndExitRoom(msgTab)
--  	--dump(msgTab,"msgTab")

-- end
return DflhjGameManager