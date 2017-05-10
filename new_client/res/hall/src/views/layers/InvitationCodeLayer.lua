local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local InvitationCodeLayer = class("InvitationCodeLayer",CustomBaseView)



function InvitationCodeLayer:ctor(finishedCallback)
    self.finishedCallback = finishedCallback;
    self.csNode = cc.CSLoader:createNode(CustomHelper.getFullPath("InvitationCodeLayer.csb"));
    self:addChild(self.csNode);
    self.alertView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alert_view"), "ccui.Widget");

	self.btn_sure = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"btn_sure"),"ccui.Button");
	self.btn_sure:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
    	self:clickSure();
    end)
	InvitationCodeLayer.super.ctor(self);
	self:initInputBox()	
    CustomHelper.addAlertAppearAnim(self.alertView)
end

function InvitationCodeLayer:initInputBox()
	local inputBgView = CustomHelper.seekNodeByName(self.csNode, "invitation_code_input_bg")
	local editBoxBgFileName = "baobo_popupview_changtiao"
	local editBoxSize = inputBgView:getContentSize();
  
	self.rechargeValueTF = ccui.EditBox:create(editBoxSize,editBoxBgFileName)
    self.rechargeValueTF:setPosition(cc.p(inputBgView:getPositionX(),inputBgView:getPositionY()))
    self.rechargeValueTF:setAnchorPoint(inputBgView:getAnchorPoint())
    self.rechargeValueTF:setFontName("Helvetica-Bold")
    self.rechargeValueTF:setFontSize(36)
    self.rechargeValueTF:setFontColor(cc.c3b(255,255,255))
    self.rechargeValueTF:setPlaceHolder("请输入您的邀请码")
    self.rechargeValueTF:setPlaceholderFontColor(cc.c3b(103,95,96))
    self.rechargeValueTF:setPlaceholderFontSize(36)
    self.rechargeValueTF:setMaxLength(5)
    self.rechargeValueTF:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_ALL_CHARACTERS);
    self.rechargeValueTF:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    self.rechargeValueTF:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    inputBgView:getParent():addChild(self.rechargeValueTF)
	
end

function InvitationCodeLayer:clickSure()
	
	local code = self.rechargeValueTF:getText();
    if code == "" then
        MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "请输入您的邀请码")
        return
    end 
    if string.len(code) < 5 then
        MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "邀请码长度不够")
        return
    end
    self.btn_sure:setTouchEnabled(false)
	local infoTab = {};
	infoTab["invite_code"] = code;
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(HallMsgManager.MsgName.CL_GetInviterInfo,infoTab);
end


function InvitationCodeLayer:closeView()
	CustomHelper.addCloseAnimForAlertView(
		self.alertView,
		function()
            self.finishedCallback();
			self:removeSelf();
	end)
end


function InvitationCodeLayer:registerNotification()
	self:addOneTCPMsgListener(HallMsgManager.MsgName.CL_GetInviterInfo,{HallMsgManager.MsgName.LC_GetInviterInfo})
    self:addOneTCPMsgListener(HallMsgManager.MsgName.LC_GetInviterInfo)
    InvitationCodeLayer.super.registerNotification(self);
end

--消息发送失败
function InvitationCodeLayer:receiveMsgRequestErrorEvent(event)
    self:removeSelf();
    InvitationCodeLayer.super.receiveMsgRequestErrorEvent(self,event)
end
function InvitationCodeLayer:receiveServerResponseErrorEvent(event)
   
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == HallMsgManager.MsgName.LC_GetInviterInfo then
    
    	self.btn_sure:setTouchEnabled(true)
    end
    InvitationCodeLayer.super.receiveServerResponseErrorEvent(self,event)
end
--收到服务器处理成功通知函数
function InvitationCodeLayer:receiveServerResponseSuccessEvent(event)
	self.btn_sure:setTouchEnabled(true)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];

    if msgName == HallMsgManager.MsgName.LC_GetInviterInfo  then
		self.rechargeValueTF:setText("")
		local InviterInfoLayer = requireForGameLuaFile("InviterInfoLayer")
		local inviterInfoLayer = InviterInfoLayer:create(userInfo,self.finishedCallback)
		self:addChild(inviterInfoLayer,1000);
		
		
    end
	InvitationCodeLayer.super.receiveServerResponseSuccessEvent(self,event)
end


return InvitationCodeLayer;