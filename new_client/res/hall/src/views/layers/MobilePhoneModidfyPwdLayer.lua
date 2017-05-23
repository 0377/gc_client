local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local MobilePhoneModidfyPwdLayer = class("MobilePhoneModidfyPwdLayer", CustomBaseView);
function MobilePhoneModidfyPwdLayer:ctor()
    local CCSLuaNode =  requireForGameLuaFile("MobilePhoneModidfyPwdLayerCCS")
    self.csNode = CCSLuaNode:create().root;

    self:addChild(self.csNode);
    local alertPanel = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alert_panel"), "ccui.Widget");
    CustomHelper.addAlertAppearAnim(alertPanel);
    self:initView();
	MobilePhoneModidfyPwdLayer.super.ctor(self)
end
function MobilePhoneModidfyPwdLayer:initView()
	local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"close_btn"), "ccui.Button");
	closeBtn:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    	self:removeSelf();
	end);
	local cancelBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "cancel_btn"), "ccui.Button");
	cancelBtn:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    	self:removeSelf();
	end);
	local resetBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "reset_pwd_btn"), "ccui.Button");
	resetBtn:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		self:clickResetBtn();
	end);
	self.playerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
	local editBoxBgFileName = "blank_file"
	local phoneNumInputBgView = CustomHelper.seekNodeByName(self.csNode, "phonenum_input_bg");
    self.accountTF = ccui.EditBox:create(phoneNumInputBgView:getContentSize(),editBoxBgFileName)
    self.accountTF:setTouchEnabled(false);--账号直接读取
    self.accountTF:setPosition(cc.p(phoneNumInputBgView:getPositionX(),phoneNumInputBgView:getPositionY()))
    self.accountTF:setAnchorPoint(phoneNumInputBgView:getAnchorPoint())
    self.accountTF:setFontName("Helvetica-Bold")
    self.accountTF:setFontSize(30)
    self.accountTF:setFontColor(cc.c3b(255,255,255))
    self.accountTF:setPlaceHolder("请输入手机号")
    self.accountTF:setPlaceholderFontColor(cc.c3b(103,95,96))
    self.accountTF:setPlaceholderFontSize(30)
    self.accountTF:setMaxLength(16)
    self.accountTF:setText(self.playerInfo:getAccount());
    self.accountTF:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD);
    self.accountTF:setInputMode(cc.EDITBOX_INPUT_MODE_PHONENUMBER)
    self.accountTF:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    phoneNumInputBgView:getParent():addChild(self.accountTF)

	self.codeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "verify_code_btn"), "ccui.Button");
	self.codeBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        --获取验证码验证
        local phoneNumTextStr = self.accountTF:getText();
        local errorStr = CustomHelper.isPhoneNumberLegal(phoneNumTextStr);
        if errorStr ~= nil then
            --todo
             MyToastLayer.new(cc.Director:getInstance():getRunningScene(), errorStr)
             return
        end
        GameManager:getInstance():getHallManager():getHallMsgManager():sendTelVerifyCode(phoneNumTextStr);
	end)

	local verifyCodeInputBgView = CustomHelper.seekNodeByName(self.csNode, "verifycode_input_bg");
	self.identifycodeTF = ccui.EditBox:create(verifyCodeInputBgView:getContentSize(),editBoxBgFileName)
    self.identifycodeTF:setPosition(cc.p(verifyCodeInputBgView:getPositionX(),verifyCodeInputBgView:getPositionY()))
    self.identifycodeTF:setAnchorPoint(verifyCodeInputBgView:getAnchorPoint())
    self.identifycodeTF:setFontName("Helvetica-Bold")
    self.identifycodeTF:setFontSize(30)
    self.identifycodeTF:setFontColor(cc.c3b(255,255,255))
    self.identifycodeTF:setPlaceHolder("请输入验证码")
    self.identifycodeTF:setPlaceholderFontColor(cc.c3b(103,95,96))
    self.identifycodeTF:setPlaceholderFontSize(30)
    self.identifycodeTF:setMaxLength(6)
    --self._identifycode:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    self.identifycodeTF:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.identifycodeTF:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    verifyCodeInputBgView:getParent():addChild(self.identifycodeTF)


    local newPwdEditBoxBgNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "newpwd_bg"), "ccui.ImageView");
    self.newPwdEditBox = ccui.EditBox:create(newPwdEditBoxBgNode:getContentSize(),editBoxBgFileName)
    self.newPwdEditBox:setPosition(newPwdEditBoxBgNode:getPosition())
    self.newPwdEditBox:setAnchorPoint(newPwdEditBoxBgNode:getAnchorPoint())
    self.newPwdEditBox:setFontName("Helvetica-Bold")
    self.newPwdEditBox:setFontSize(30)
    self.newPwdEditBox:setFontColor(cc.c3b(255, 255, 255))
    self.newPwdEditBox:setPlaceHolder("请输入新密码")
    self.newPwdEditBox:setPlaceholderFontColor(cc.c3b(103, 95, 96))
    self.newPwdEditBox:setPlaceholderFontSize(30)
    self.newPwdEditBox:setMaxLength(18)
    self.newPwdEditBox:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    self.newPwdEditBox:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    self.newPwdEditBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    newPwdEditBoxBgNode:getParent():addChild(self.newPwdEditBox)  

    local newPwd2EditBoxBgNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "new_pwd2_bg"), "ccui.ImageView");
    local bgFileName = "blankFile"
    self.newPwd2EditBox = ccui.EditBox:create(newPwd2EditBoxBgNode:getContentSize(),editBoxBgFileName)
    self.newPwd2EditBox:setPosition(newPwd2EditBoxBgNode:getPosition())
    self.newPwd2EditBox:setAnchorPoint(newPwd2EditBoxBgNode:getAnchorPoint())
    self.newPwd2EditBox:setFontName("Helvetica-Bold")
    self.newPwd2EditBox:setFontSize(30)
    self.newPwd2EditBox:setFontColor(cc.c3b(255, 255, 255))
    self.newPwd2EditBox:setPlaceHolder("请再次输入密码")
    self.newPwd2EditBox:setPlaceholderFontColor(cc.c3b(103, 95, 96))
    self.newPwd2EditBox:setPlaceholderFontSize(30)
    self.newPwd2EditBox:setMaxLength(18) 
    self.newPwd2EditBox:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    self.newPwd2EditBox:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    self.newPwd2EditBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    newPwd2EditBoxBgNode:getParent():addChild(self.newPwd2EditBox) 

end
function MobilePhoneModidfyPwdLayer:showVerifyCoundDownTip()
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
function MobilePhoneModidfyPwdLayer:clickResetBtn()
	local verifyCodeTextStr = self.identifycodeTF:getText();
    local newPwdStr = self.newPwdEditBox:getText();
    local newPwd2Str = self.newPwd2EditBox:getText();
    local codeNeedLen = 6;
   	local errorStr = nil
    if errorStr == nil  then
		--todo
		errorStr = CustomHelper.isCheckNumberLegal(verifyCodeTextStr)
	end
    if errorStr == nil and newPwdStr == "" then
        --todo
        errorStr = "请输入新密码"
    end

    if errorStr == nil then
		--todo
		errorStr = CustomHelper.isPasswordNumberLegal(newPwdStr )
	end

    if errorStr == nil and newPwdStr ~= newPwd2Str then
        --todo
        errorStr = "两次密码不一致"
    end
    if errorStr ~= nil then
        --todo
        MyToastLayer.new(cc.Director:getInstance():getRunningScene(), errorStr)
        return
    end
    self.isSetPwdBySms = true;
    GameManager:getInstance():getHallManager():getHallMsgManager():sendResetPwdBySms(newPwdStr,verifyCodeTextStr)
end
function MobilePhoneModidfyPwdLayer:registerNotification()
    ---增加服务器消息监听 ,只有增加了的命令，才会回调对应成功监听函数
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_RequestSms)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_SetPassword);
    MobilePhoneModidfyPwdLayer.super.registerNotification(self);
end
--收到服务器处理成功通知函数
function MobilePhoneModidfyPwdLayer:receiveServerResponseSuccessEvent(event)
    print("LoginScene:receiveServerResponseSuccessEvent(event)")  
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == HallMsgManager.MsgName.SC_RequestSms then
        self:showVerifyCoundDownTip();
        print("验证码已经发送")
    elseif msgName == HallMsgManager.MsgName.SC_SetPassword and self.isSetPwdBySms == true then
    	--todo
    	self.isSetPwdBySms = false;
    	MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "密码重置成功！")
    	self:removeSelf();
    	return;
    end  
    -- LoginScene.super.receiveServerResponseSuccessEvent(self,event);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
end
return MobilePhoneModidfyPwdLayer;