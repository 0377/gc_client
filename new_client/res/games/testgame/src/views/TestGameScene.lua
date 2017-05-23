local SubGameBaseScene = requireForGameLuaFile("SubGameBaseScene")
local TestGameScene = class("TestGameScene",SubGameBaseScene);
function TestGameScene:ctor()
	self.rootPath = TestGameManager:getInstance():getPackageRootPath();
	local csNodePath = cc.FileUtils:getInstance():fullPathForFilename("TestGameLayerCCS.csb");
    self.csNode = cc.CSLoader:createNode(csNodePath);
    self:addChild(self.csNode);
    local exitBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "exitBtn"), "ccui.Button");
    exitBtn:addClickEventListener(function(sender)
        local subGameManager = GameManager:getInstance():getHallManager():getSubGameManager();
        subGameManager:onExit();
    	SceneController.goHallScene();
    end);
    local testBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "testBtn"), "ccui.Button");
    testBtn:addClickEventListener(function()
		TestGameManager:getInstance():sendTestCSDemoMsg("hello,this is a test game msg");
    end);
    --调用父类，必须调用
    self.super.ctor(self);
end
--监听相关通知
function TestGameScene:registerNotification()
	local dispatcher = cc.Director:getInstance():getEventDispatcher();
	---增加服务器消息监听 ,只有增加了的命令，才会回调对应成功监听函数
	self:addOneTCPMsgListener(TestGameManager.MsgName.SC_Demo);
	self.super.registerNotification(self);
end
--请求失败通知，网络连接状态变化
function TestGameScene:callbackWhenConnectionStatusChange(event)
	self.super.callbackWhenConnectionStatusChange(self,event);
end
--收到服务器返回的失败的通知，如果登录失败，密码错误
function TestGameScene:receiveServerResponseErrorEvent(event)
    print("TestGameScene:receiveServerResponseErrorEvent(event)")
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    local ret = userInfo["ret"];
    local description = HallUtils:getDescWithMsgNameAndRetNum(msgName,ret);
    HallUtils:showAlertView(description);
    HallUtils.removeIndicationTip();
end
--收到服务器处理成功通知函数
function TestGameScene:receiveServerResponseSuccessEvent(event)
	print("LoginScene:receiveServerResponseSuccessEvent(event)")  
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    HallUtils.removeIndicationTip();
    if msgName == TestGameManager.MsgName.SC_Demo then --成功收到demo命令
    	-- print("收到消息咯");
    	-- dump(userInfo, "userInfo", nesting)
    end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
end
return TestGameScene;