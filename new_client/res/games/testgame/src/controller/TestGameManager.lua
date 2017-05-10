local SubGameBaseManager = requireForGameLuaFile("SubGameBaseManager");
TestGameManager = class("TestGameManager",SubGameBaseManager);
import(".TestGameDataManager");
--[[
	游戏控制器
]]
TestGameManager.MsgName = {
	CS_Demo = "CS_Demo",--游戏开始
	SC_Demo = "SC_Demo"--游戏结束
}
TestGameManager.instance = nil;
function TestGameManager:getInstance()
	if TestGameManager.instance == nil then
		--todo
		TestGameManager.instance = TestGameManager:create();
	end
	return TestGameManager.instance;
end
function TestGameManager:ctor()
	self.gameDetailInfoTab = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab();
	-- dump(self.gameDetailInfoTab, "self.gameDetailInfoTab", nesting)
	--增加属性
	CustomHelper.addSetterAndGetterMethod(self,"packageRootPath",self.gameDetailInfoTab[HallGameConfig.GamePackageRootPathKey]);--游戏包根目录，在HallGameConfig中配置
	CustomHelper.addSetterAndGetterMethod(self,"dataManager",TestGameDataManager:create());--游戏数据管理器
	--注册pb文件
	self:registerPBProtocolToHallMsgManager();
end
--注册协议到协议解析中
function TestGameManager:registerPBProtocolToHallMsgManager()
	local pbFileTab = {};
	table.insert(pbFileTab,"common_msg_demo.proto");
	local hallMsgManager = GameManager:getInstance():getHallManager():getHallMsgManager();
	for k,v in pairs(pbFileTab) do
		local pbFullPath = cc.FileUtils:getInstance():fullPathForFilename(v);
		hallMsgManager:registerProtoFileToPb(pbFullPath);
	end
	--增加解析key
	for k,v in pairs(TestGameManager.MsgName) do
		hallMsgManager:registerMsgNameToMsgPBMananager(v);
	end
end
--增加消息处理监听函数
function TestGameManager:registerNotification()
	
end
--发送消息
function TestGameManager:sendTestCSDemoMsg(testStr)
	---
	local msgTab = {};
	msgTab["test"] = testStr;
	local msgName = TestGameManager.MsgName.CS_Demo;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end
--收到消息函数
function TestGameManager:on_SC_Demo(msgTab)
	-- dump(msgTab, "on_SC_Demo", nesting)
end
return TestGameManager;