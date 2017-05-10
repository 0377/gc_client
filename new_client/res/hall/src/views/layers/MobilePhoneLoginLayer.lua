local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local MobilePhoneLoginLayer = class("MobilePhoneLoginLayer",CustomBaseView);
function MobilePhoneLoginLayer:ctor()
	-- body
	self.csNode = cc.CSLoader:createNode(CustomHelper.getFullPath("MobilePhoneLoginLayerCCS.csb"));
    self:addChild(self.csNode);
    self:initView();
    local alertPanel = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alert_panel"), "ccui.Widget");
    CustomHelper.addAlertAppearAnim(alertPanel)
    local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "close_btn"), "ccui.Button");
    closeBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    	self:removeSelf();
    end);
    --获取验证码
    self.codeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "code_btn"), "ccui.Button");
    self.codeBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    	self:clickVerifyCodeBtn();
    end)
    self.loginBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "login_btn"), "ccui.Button");
    self.loginBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    	self:clickLoginBtn();
    end); 
	MobilePhoneLoginLayer.super.ctor(self)
end
function MobilePhoneLoginLayer:initView()
	local editBoxBgFileName = "hall_res/account/bb_grxx_bdzh_ditiao.png"
	if self.accountTF == nil then
		--todo
		local phoneNumInputBgView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "account_input_bg"), "ccui.Widget");
		phoneNumInputBgView:setVisible(false);
	    self.accountTF = ccui.EditBox:create(phoneNumInputBgView:getContentSize(),editBoxBgFileName)
	    self.accountTF:setPosition(cc.p(phoneNumInputBgView:getPositionX(),phoneNumInputBgView:getPositionY()))
	    self.accountTF:setAnchorPoint(phoneNumInputBgView:getAnchorPoint())
	    self.accountTF:setFontName("Helvetica-Bold")
	    self.accountTF:setFontSize(30)
	    self.accountTF:setFontColor(cc.c3b(255,255,255))
	    self.accountTF:setPlaceHolder("请输入手机号")
	    self.accountTF:setPlaceholderFontColor(cc.c3b(103,95,96))
	    self.accountTF:setPlaceholderFontSize(30)
	    self.accountTF:setMaxLength(16)
	    self.accountTF:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD);
	    self.accountTF:setInputMode(cc.EDITBOX_INPUT_MODE_PHONENUMBER)
	    self.accountTF:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
	    phoneNumInputBgView:getParent():addChild(self.accountTF)
	end
	if self.verifyCodeTF == nil then
		--todo
		local verifyCodeInputBgView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "verify_code_input_bg"), "ccui.Widget");
		verifyCodeInputBgView:setVisible(false);
		self.verifyCodeTF = ccui.EditBox:create(verifyCodeInputBgView:getContentSize(),editBoxBgFileName)
	    self.verifyCodeTF:setPosition(cc.p(verifyCodeInputBgView:getPositionX(),verifyCodeInputBgView:getPositionY()))
	    self.verifyCodeTF:setAnchorPoint(verifyCodeInputBgView:getAnchorPoint())
	    self.verifyCodeTF:setFontName("Helvetica-Bold")
	    self.verifyCodeTF:setFontSize(30)
	    self.verifyCodeTF:setFontColor(cc.c3b(255,255,255))
	    self.verifyCodeTF:setPlaceHolder("请输入验证码")
	    self.verifyCodeTF:setPlaceholderFontColor(cc.c3b(103,95,96))
	    self.verifyCodeTF:setPlaceholderFontSize(30)
	    self.verifyCodeTF:setMaxLength(6)
	    --self._identifycode:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
	    self.verifyCodeTF:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
	    self.verifyCodeTF:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
	    verifyCodeInputBgView:getParent():addChild(self.verifyCodeTF)
	end

end
function MobilePhoneLoginLayer:clickVerifyCodeBtn()
    --获取验证码验证
    local phoneNumTextStr = self.accountTF:getText();
    local errorStr = CustomHelper.isPhoneNumberLegal(phoneNumTextStr);
    if errorStr ~= nil then
        --todo
         MyToastLayer.new(self, errorStr)
         return
    end
    self.codeBtn:setEnabled(false)
    GameManager:getInstance():getHallManager():getHallMsgManager():sendTelVerifyCode(phoneNumTextStr);
end
function MobilePhoneLoginLayer:clickLoginBtn()
	local phoneNumTextStr = self.accountTF:getText();
	local verifyCodeTextStr = self.verifyCodeTF:getText();
	local errorStr = nil
    if errorStr == nil then
    	--todo
    	errorStr = CustomHelper.isPhoneNumberLegal(phoneNumTextStr);
    end
    local codeNeedLen = 6;
   	if errorStr == nil then
		--todo
		errorStr = CustomHelper.isCheckNumberLegal(verifyCodeTextStr)
	end
	if errorStr ~= nil then
		--todo
		 MyToastLayer.new(cc.Director:getInstance():getRunningScene(), errorStr)
		 return;
	end
    self.loginBtn:setEnabled(false)
    GameManager:getInstance():getHallManager():getHallMsgManager():sendLoginBySms(phoneNumTextStr,verifyCodeTextStr)
end
function MobilePhoneLoginLayer:showVerifyCoundDownTip()
    if self.verifyCodeTipText == nil then
        --todo
        self.verifyCodeTipText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "verify_code_tip"), "ccui.Text");
    end
    self.codeBtn:setVisible(false);
    local countDown = 90;
    local acTag = 100021
    local ac = cc.Repeat:create(
            cc.Sequence:create(
                cc.CallFunc:create(function()
                    if countDown <= 0 then
                        --todo
                        self.codeBtn:setVisible(true);
                        self.verifyCodeTipText:setVisible(false)
                    end
                    self.verifyCodeTipText:setString("验证码已发送，重新发送请等待" .. countDown .. "秒")
                    countDown = countDown - 1
                end),
                cc.DelayTime:create(1.0)
            ), 
    countDown+1)
    ac:setTag(acTag)
    self.verifyCodeTipText:stopActionByTag(acTag)
    self.verifyCodeTipText:setVisible(true)
    self.verifyCodeTipText:runAction(ac)
end
function MobilePhoneLoginLayer:registerNotification()
    ---增加服务器消息监听 ,只有增加了的命令，才会回调对应成功监听函数
    self:addOneTCPMsgListener(HallMsgManager.MsgName.CS_RequestSms)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_RequestSms)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.CL_LoginBySms,{HallMsgManager.MsgName.LC_Login})
    self:addOneTCPMsgListener(HallMsgManager.MsgName.LC_Login) --CL_LoginBySms 返回消息为LC_Login
    MobilePhoneLoginLayer.super.registerNotification(self);
end

--消息发送失败
function MobilePhoneLoginLayer:receiveMsgRequestErrorEvent(event)
    self.codeBtn:setEnabled(true)
    self.loginBtn:setEnabled(true)
    MobilePhoneLoginLayer.super.receiveMsgRequestErrorEvent(self,event)
end
function MobilePhoneLoginLayer:receiveServerResponseErrorEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    local isCallSuper = true;
    if msgName == HallMsgManager.MsgName.SC_RequestSms then
       self.codeBtn:setEnabled(true)
    elseif msgName == HallMsgManager.MsgName.LC_Login then 
       --todo
       self.loginBtn:setEnabled(true)
       isCallSuper = false;
    end  
    if isCallSuper then
        --todo
        MobilePhoneLoginLayer.super.receiveServerResponseErrorEvent(self,event)
    end
end

--收到服务器处理成功通知函数
function MobilePhoneLoginLayer:receiveServerResponseSuccessEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == HallMsgManager.MsgName.SC_RequestSms then
        self.codeBtn:setEnabled(true)
        self:showVerifyCoundDownTip();  
        print("验证码已经发送")
    end  
    -- LoginScene.super.receiveServerResponseSuccessEvent(self,event);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
end
return MobilePhoneLoginLayer