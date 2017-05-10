local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local LoginWordVerifyLayer = class("SettingLayer", CustomBaseView)
function LoginWordVerifyLayer:ctor(wordVerifyData,finishedCallback)
	local csNodePath = cc.FileUtils:getInstance():fullPathForFilename("LoginWordVerifyLayer.csb");
    self.csNode = cc.CSLoader:createNode(csNodePath);
    self:addChild(self.csNode);
    self.alertView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alert_view"), "ccui.Widget");
    local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.alertView, "close_btn"), "ccui.Button");
    closeBtn:addClickEventListener(function(sender)
    	GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
    	self:removeSelf();
	end);
	self.wordVerifyData = wordVerifyData;
	self:showView();
	self.confirmBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "confirm_btn"), "ccui.Button")
	self.confirmBtn:setEnabled(false)
	self.confirmBtn:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
		self.confirmBtn:setTouchEnabled(false)
		local answers = {};
		for k,v in pairs(self.selectedAnswer) do
			table.insert(answers,v);
		end
		local msgTab = {
			answer = answers
		};
		GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(HallMsgManager.MsgName.CS_LoginValidatebox,msgTab,true)
	end);
	self.finishedCallback = finishedCallback;
	LoginWordVerifyLayer.super.ctor(self);
end
function LoginWordVerifyLayer:showView()
	local targetText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "target_text"), "ccui.Text");
	local questionWordIndexArray = self.wordVerifyData.question;
	-- table.sort(questionWordIndexArray,function(a,b)
	-- 		return a < b
	-- 	end)
	local answerWordIndexArray = self.wordVerifyData.answer; 
	-- table.sort(answerWordIndexArray,function(a,b)
	-- 	return a < b
	-- end);
	local questionStr = "";
	--字库文字对应
	local questionWordMap = CustomHelper.createJsonTabWithFilePath(cc.FileUtils:getInstance():fullPathForFilename("verify_code.json"));
	for i,v in ipairs(answerWordIndexArray) do
		local key = string.format("%d",v)
		questionStr = questionStr..questionWordMap[key].." "
	end
	targetText:setString(questionStr)
	--显示待选字
	self.selectedAnswer = {};
	for i=1,4 do
		local wordPanbel = tolua.cast(CustomHelper.seekNodeByName(self.csNode,string.format("Panel_4_%d",i)), "ccui.Text");
		local wordView = tolua.cast(CustomHelper.seekNodeByName(wordPanbel, "word_view"), "ccui.ImageView");
		local answerIndex =  questionWordIndexArray[i]
		wordView:loadTexture(CustomHelper.getFullPath("hall_res/word_verification/words/"..string.format("%04d",answerIndex)..".png"));
		wordView:ignoreContentAdaptWithSize(true)
		local selectedView = tolua.cast(CustomHelper.seekNodeByName(wordPanbel,"Image_3"), "ccui.ImageView")
		local selectedBtn = tolua.cast(CustomHelper.seekNodeByName(wordPanbel, "Button_3"), "ccui.Button");
		selectedBtn.isSelected = false;	
		selectedView:setVisible(selectedBtn.isSelected)
		selectedBtn:addClickEventListener(function()
			self.selectedAnswer[answerIndex] = nil;
			selectedBtn.isSelected = not selectedBtn.isSelected;
			selectedView:setVisible(selectedBtn.isSelected);
			if selectedBtn.isSelected then
				--todo
				self.selectedAnswer[answerIndex] = answerIndex;
			end
			if table.nums(self.selectedAnswer) == table.nums(answerWordIndexArray) then
				--todo
				self.confirmBtn:setEnabled(true)
			else
				self.confirmBtn:setEnabled(false)
			end
		end);
	end
end
function LoginWordVerifyLayer:registerNotification()
    ---增加服务器消息监听 ,只有增加了的命令，才会回调对应成功监听函数
    self:addOneTCPMsgListener(HallMsgManager.MsgName.CS_LoginValidatebox);
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_LoginValidatebox);
    LoginWordVerifyLayer.super.registerNotification(self);
end 
--消息发送失败
function LoginWordVerifyLayer:receiveMsgRequestErrorEvent(event)
    self.confirmBtn:setTouchEnabled(true)
    LoginWordVerifyLayer.super.receiveMsgRequestErrorEvent(self,event)
end
function LoginWordVerifyLayer:receiveServerResponseErrorEvent(event)
    print("CustomBaseView:receiveServerResponseErrorEvent(event)")
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == HallMsgManager.MsgName.SC_LoginValidatebox then
    	--todo
    	self.wordVerifyData = userInfo.pb_validatebox;
		self:showView();
    	self.confirmBtn:setTouchEnabled(true)
    end
    LoginWordVerifyLayer.super.receiveServerResponseErrorEvent(self,event)
end
--收到服务器处理成功通知函数
function LoginWordVerifyLayer:receiveServerResponseSuccessEvent(event)
    print("LoginScene:receiveServerResponseSuccessEvent(event)")  
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == HallMsgManager.MsgName.SC_LoginValidatebox then
        -- self:showVerifyCoundDownTip();
        self.finishedCallback();
        self:removeSelf();
    end  
    LoginWordVerifyLayer.super.receiveServerResponseSuccessEvent(self,event);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
end
return LoginWordVerifyLayer;