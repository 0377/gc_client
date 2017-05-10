local SubGameBaseManager = requireForGameLuaFile("SubGameBaseManager");
LhjGameManager = class("LhjGameManager",SubGameBaseManager);
import(".LhjGameDataManager");

LhjGameManager.MsgName = 
{
	SC_Slotma_Start = "SC_Slotma_Start",--开始游戏返回
	CS_Slotma_Start = "CS_Slotma_Start",--请求开始游戏
	CS_SlotmaPlayerConnectGame = "CS_SlotmaPlayerConnectGame",--断线重连
	CS_SlotmaLeaveGame = "CS_SlotmaLeaveGame",--离开游戏
	SC_SimpleRespons = "SC_SimpleRespons"
}

function LhjGameManager:clearLoadedOneGameFiles()
	-- body
	local loaded = package.loaded;
    --重新加载frame内文件
    loaded["LhjGameDataManager"] = nil;
    loaded["LhjGameManager"] = nil;
    loaded["LhjGameEnd"] = nil;
    loaded["LhjGameTips"] = nil;
  
    LhjGameManager.instance = nil;
end

----1准备状态
----2可以下注
LhjGameManager.instance = nil;
function LhjGameManager:getInstance()
	if LhjGameManager.instance == nil then
		LhjGameManager.instance = LhjGameManager:create();
	end
	return LhjGameManager.instance;
end



function LhjGameManager:ctor()

	self.gameDetailInfoTab = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab();
	CustomHelper.addSetterAndGetterMethod(self,"packageRootPath",self.gameDetailInfoTab[HallGameConfig.GamePackageRootPathKey]);--游戏包根目录，在HallGameConfig中配置
	CustomHelper.addSetterAndGetterMethod(self,"dataManager",LhjGameDataManager:create());--游戏数据管理器
	--注册pb文件
	self:registerPBProtocolToHallMsgManager();
	LhjGameManager.super.ctor(self)
	self.subGameTipsConfig = requireForGameLuaFile("LhjTipsConfig");
end
--注册协议到协议解析中
function LhjGameManager:registerPBProtocolToHallMsgManager()
	local pbFileTab = {};
	table.insert(pbFileTab,"common_msg_slotma.proto");
	local hallMsgManager = GameManager:getInstance():getHallManager():getHallMsgManager();
	for k,v in pairs(pbFileTab) do
		local filePath =  v --self.packageRootPath.."res/pb_files/" ..
		local pbFullPath = cc.FileUtils:getInstance():fullPathForFilename(filePath);
		hallMsgManager:registerProtoFileToPb(pbFullPath);
	end

	--增加解析key
	for k,v in pairs(LhjGameManager.MsgName) do
		hallMsgManager:registerMsgNameToMsgPBMananager(v);
	end
	LhjGameManager.super.registerPBProtocolToHallMsgManager(self)
end


--增加消息处理监听函数
function LhjGameManager:registerNotification()
	
end

----开始游戏获取数据
--	cellTimes 底注的倍数
--	lines 选择押注线的列表
function LhjGameManager:sendStartGame(cellTimes,lines)
	local msgTab = {
		cell_times = cellTimes,
		lines = lines,
	}
	--发送消息前清理收到的数据
	self.dataManager:clearRoundData()
	local msgName = LhjGameManager.MsgName.CS_Slotma_Start;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end

----开始游戏获取数据
function LhjGameManager:sendPlayerReconnection()
	-- body
	local msgTab = {}
	local msgName = LhjGameManager.MsgName.CS_SlotmaPlayerConnectGame;
	--发送消息前清理收到的数据
	-- self.dataManager:clearRoundData()
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end

function LhjGameManager:on_SC_Slotma_Start(msgTab)
	-- body
	print( "开始游戏返回数据")
	self.dataManager:OnMsg_Slotma_Start(msgTab)
	
end

--离开房间
function LhjGameManager:sendLeaveGame()
	local msg = {}
	local msgName = LhjGameManager.MsgName.CS_SlotmaLeaveGame;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msg)
end

-- ----游戏停服消息
-- function LhjGameManager:on_SC_GameServerStop(msgTab)
-- 	self.dataManager:OnMsg_GameServerStop(msgTab)
-- end


-- function LhjGameManager:on_SC_StandUpAndExitRoom(msgTab)
--  	--dump(msgTab,"msgTab")

-- end
return LhjGameManager