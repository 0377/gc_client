local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local AlipayBindEnsureLayer = class("AlipayBindEnsureLayer", CustomBaseView)
function AlipayBindEnsureLayer:ctor(args)
	dump(args, "args", nesting)
    self.alipayName = args.alipayName;
    self.alipayAccount = args.alipayAccount;
    self.csNode = cc.CSLoader:createNode(CustomHelper.getFullPath("AlipayBindEnsureLayerCCS.csb"));
    self:addChild(self.csNode);
    local alertPanel = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alert_panel"), "ccui.Widget");
    CustomHelper.addAlertAppearAnim(alertPanel);
    local cancelBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "cancel_btn"), "ccui.Button");
    cancelBtn:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		self:removeSelf();
    end);
    self.confirmBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "confirm_btn"), "ccui.Button");
    self.confirmBtn:addClickEventListener(function()
    	GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    	self:clickEnsureBtn();
    end); 
    local nameText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "name_text"), "ccui.Text");
    nameText:setString(self.alipayName);
    local accountText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "account_text"), "ccui.Text");
    accountText:setString(self.alipayAccount);
    AlipayBindEnsureLayer.super.ctor(self)

    local cancelBtn1 = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "cancel_btn_0"), "ccui.Button");
    cancelBtn1:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        self:removeSelf();
    end);
end
function AlipayBindEnsureLayer:clickEnsureBtn()
	-- print("you need implement alipay bind server request")
    self.confirmBtn:setEnabled(false)
    GameManager:getInstance():getHallManager():getHallMsgManager():sendBindAlipayAccount(self.alipayName,self.alipayAccount)
end
function AlipayBindEnsureLayer:registerNotification()
    local dispatcher = cc.Director:getInstance():getEventDispatcher();
    ---增加服务器消息监听 ,只有增加了的命令，才会回调对应成功监听函数
    self:addOneTCPMsgListener(HallMsgManager.MsgName.CS_BandAlipay);
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_BandAlipay)
    AlipayBindEnsureLayer.super.registerNotification(self);
end
--消息发送失败
function AlipayBindEnsureLayer:receiveMsgRequestErrorEvent(event)
    self.confirmBtn:setEnabled(true)
    AlipayBindEnsureLayer.super.receiveMsgRequestErrorEvent(self,event)
end
function AlipayBindEnsureLayer:receiveServerResponseErrorEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == HallMsgManager.MsgName.SC_BandAlipay then
        --todo
        self.confirmBtn:setEnabled(true)
    end
    AlipayBindEnsureLayer.super.receiveServerResponseErrorEvent(self,event)
end--收到服务器处理成功通知函数
function AlipayBindEnsureLayer:receiveServerResponseSuccessEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == HallMsgManager.MsgName.SC_BandAlipay then
     --todo
        MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "支付宝绑定成功")
        self:removeSelf();
    end
    AlipayBindEnsureLayer.super.receiveServerResponseSuccessEvent(self,event)
end
return AlipayBindEnsureLayer;
