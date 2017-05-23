local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local AccountBindLayer = class("AccountBindLayer", CustomBaseView)
function AccountBindLayer:ctor()
    local CCSLuaNode =  requireForGameLuaFile("AccountBindLayerCCS")
    self.csNode = CCSLuaNode:create().root;
	self:addChild(self.csNode);
	--初始化输入框
	self:initInputCommponent()
	self.bindBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "bind_btn"), "ccui.Button");
	self.bindBtn:addClickEventListener(function()
		---
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		self:clickBindBtn();
	end);
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
        self.codeBtn:setEnabled(false)
        GameManager:getInstance():getHallManager():getHallMsgManager():sendTelVerifyCode(phoneNumTextStr,2);
	end)
	AccountBindLayer.super.ctor(self)
end
function AccountBindLayer:closeView()
	CustomHelper.addCloseAnimForAlertView(
		self.alertView,
		function()
			self:removeSelf();
	end)
end
function AccountBindLayer:initInputCommponent()
	local nickNameInputBgView = CustomHelper.seekNodeByName(self.csNode, "nickname_input_bg");
	local phoneNumInputBgView = CustomHelper.seekNodeByName(self.csNode, "phonenum_input_bg");
	local verifyCodeInputBgView = CustomHelper.seekNodeByName(self.csNode, "verifycode_input_bg");
	local pwdInputBgView = CustomHelper.seekNodeByName(self.csNode, "pwd_input_bg")
	local pwd2InputBgView = CustomHelper.seekNodeByName(self.csNode, "pwd2_input_bg")
	local editBoxBgFileName = "blank_file"
	local editBoxSize = pwd2InputBgView:getContentSize();
    self.nickNameTF = ccui.EditBox:create(editBoxSize,editBoxBgFileName)
    self.nickNameTF:setPosition(cc.p(nickNameInputBgView:getPositionX(),nickNameInputBgView:getPositionY()))
    self.nickNameTF:setAnchorPoint(nickNameInputBgView:getAnchorPoint())
    self.nickNameTF:setFontName("Helvetica-Bold")
    self.nickNameTF:setFontSize(30)
    self.nickNameTF:setFontColor(cc.c3b(255,255,255))
    self.nickNameTF:setPlaceHolder("请输入昵称")
    self.nickNameTF:setPlaceholderFontColor(cc.c3b(0xad,0xad,0xad))
    self.nickNameTF:setPlaceholderFontSize(30)
    self.nickNameTF:setMaxLength(16)
    self.nickNameTF:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD);
    self.nickNameTF:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    self.nickNameTF:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    nickNameInputBgView:getParent():addChild(self.nickNameTF)	

    self.accountTF = ccui.EditBox:create(editBoxSize,editBoxBgFileName)
    self.accountTF:setPosition(cc.p(phoneNumInputBgView:getPositionX(),phoneNumInputBgView:getPositionY()))
    self.accountTF:setAnchorPoint(phoneNumInputBgView:getAnchorPoint())
    self.accountTF:setFontName("Helvetica-Bold")
    self.accountTF:setFontSize(30)
    self.accountTF:setFontColor(cc.c3b(255,255,255))
    self.accountTF:setPlaceHolder("请输入手机号")
    self.accountTF:setPlaceholderFontColor(cc.c3b(0xad,0xad,0xad))
    self.accountTF:setPlaceholderFontSize(30)
    self.accountTF:setMaxLength(18)
    self.accountTF:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD);
    self.accountTF:setInputMode(cc.EDITBOX_INPUT_MODE_PHONENUMBER)
    self.accountTF:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    phoneNumInputBgView:getParent():addChild(self.accountTF)

    self.identifycodeTF = ccui.EditBox:create(editBoxSize,editBoxBgFileName)
    self.identifycodeTF:setPosition(cc.p(verifyCodeInputBgView:getPositionX(),verifyCodeInputBgView:getPositionY()))
    self.identifycodeTF:setAnchorPoint(verifyCodeInputBgView:getAnchorPoint())
    self.identifycodeTF:setFontName("Helvetica-Bold")
    self.identifycodeTF:setFontSize(30)
    self.identifycodeTF:setFontColor(cc.c3b(255,255,255))
    self.identifycodeTF:setPlaceHolder("请输入验证码")
    self.identifycodeTF:setPlaceholderFontColor(cc.c3b(0xad,0xad,0xad))
    self.identifycodeTF:setPlaceholderFontSize(30)
    self.identifycodeTF:setMaxLength(6)
    --self._identifycode:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    self.identifycodeTF:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.identifycodeTF:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    verifyCodeInputBgView:getParent():addChild(self.identifycodeTF)

    self.pwdTF = ccui.EditBox:create(editBoxSize,editBoxBgFileName)
    self.pwdTF:setPosition(cc.p(pwdInputBgView:getPositionX(),pwdInputBgView:getPositionY()))
    self.pwdTF:setAnchorPoint(pwdInputBgView:getAnchorPoint())
    self.pwdTF:setFontName("Helvetica-Bold")
    self.pwdTF:setFontSize(30)
    self.pwdTF:setFontColor(cc.c3b(255,255,255))
    self.pwdTF:setPlaceHolder("请输入密码")
    self.pwdTF:setPlaceholderFontColor(cc.c3b(0xad,0xad,0xad))
    self.pwdTF:setPlaceholderFontSize(30)
    self.pwdTF:setMaxLength(18)
    self.pwdTF:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    self.pwdTF:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    self.pwdTF:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    pwdInputBgView:getParent():addChild(self.pwdTF)

    self.pwd2TF = ccui.EditBox:create(editBoxSize,editBoxBgFileName)
    self.pwd2TF:setPosition(cc.p(pwd2InputBgView:getPositionX(),pwd2InputBgView:getPositionY()))
    self.pwd2TF:setAnchorPoint(pwd2InputBgView:getAnchorPoint())
    self.pwd2TF:setFontName("Helvetica-Bold")
    self.pwd2TF:setFontSize(30)
    self.pwd2TF:setFontColor(cc.c3b(255,255,255))
    self.pwd2TF:setPlaceHolder("请再次输入密码")
    self.pwd2TF:setPlaceholderFontColor(cc.c3b(0xad,0xad,0xad))
    self.pwd2TF:setPlaceholderFontSize(30)
    self.pwd2TF:setMaxLength(18)
    self.pwd2TF:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    self.pwd2TF:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    self.pwd2TF:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    pwd2InputBgView:getParent():addChild(self.pwd2TF,1)
end
function AccountBindLayer:clickBindBtn()
	local nickNameTextStr = string.trim(self.nickNameTF:getText());
	local phoneNumTextStr = self.accountTF:getText();
	local verifyCodeTextStr = self.identifycodeTF:getText();
	local pwdTextStr = self.pwdTF:getText();
	local pwd2TextStr = self.pwd2TF:getText();
	local errorStr = nil
	print("nickNameTextStr:",nickNameTextStr,"_____________",phoneNumTextStr)
	if nickNameTextStr == "" then
        errorStr = "请您输入昵称！";
    end

    print("fds-------ghg----")
    --if not CustomHelper.checkTextType(nickNameTextStr,"^[\w\u4e00-\u9fa5]+$") then 
    errorStr = CustomHelper.isNameLegal(nickNameTextStr )
    
    if errorStr == nil then
    	--todo
    	errorStr = CustomHelper.isPhoneNumberLegal(phoneNumTextStr);
    end
    local codeNeedLen = 6;
   	if errorStr == nil  then
		--todo
		errorStr = CustomHelper.isCheckNumberLegal(verifyCodeTextStr)
	end
    
	if errorStr == nil then
		--todo
		errorStr = CustomHelper.isPasswordNumberLegal(pwdTextStr )
	end
	if errorStr == nil  and  pwd2TextStr ~= pwdTextStr then
		errorStr = "两次密码不一样"
	end
	if errorStr ~= nil then
		--todo
		 MyToastLayer.new(cc.Director:getInstance():getRunningScene(), errorStr)
		 return;
	else
		--发送请求
        self.bindBtn:setEnabled(false);
        GameManager:getInstance():getHallManager():getHallMsgManager():sendAccountBindMsg(phoneNumTextStr,pwdTextStr,nickNameTextStr,verifyCodeTextStr);
	end
end
function AccountBindLayer:showVerifyCoundDownTip()
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
                    self.verifyCodeTipText:setString( countDown .. "秒后可再次获取")
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
function AccountBindLayer:registerNotification()
    ---增加服务器消息监听 ,只有增加了的命令，才会回调对应成功监听函数
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_RequestSms)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.CS_RequestSms)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.CS_ResetAccount)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_ResetAccount)
    AccountBindLayer.super.registerNotification(self);
end
--消息发送失败
function AccountBindLayer:receiveMsgRequestErrorEvent(event)
   

    self.bindBtn:setEnabled(true)
    self.codeBtn:setEnabled(true)
    AccountBindLayer.super.receiveMsgRequestErrorEvent(self,event)
end
--收到服务器返回的失败的通知，如果登录失败，密码错误
function AccountBindLayer:receiveServerResponseErrorEvent(event)
    print("CustomBaseView:receiveServerResponseErrorEvent(event)")
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    local ret = userInfo["ret"] or userInfo["result"]; 
    if msgName == HallMsgManager.MsgName.SC_ResetAccount then
        --todo
        self.bindBtn:setEnabled(true)
    elseif msgName == HallMsgManager.MsgName.SC_RequestSms then
        --todo
        self.codeBtn:setEnabled(true)
    end
    AccountBindLayer.super.receiveServerResponseErrorEvent(self,event)
end
--收到服务器处理成功通知函数
function AccountBindLayer:receiveServerResponseSuccessEvent(event)
    print("LoginScene:receiveServerResponseSuccessEvent(event)")  
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == HallMsgManager.MsgName.SC_RequestSms then
        self:showVerifyCoundDownTip();
        self.codeBtn:setEnabled(true)
        print("验证码已经发送")
    elseif msgName == HallMsgManager.MsgName.SC_ResetAccount then
        --todo
        --注册成功
        self.bindBtn:setEnabled(true)
        MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "绑定成功！");
        self:removeSelf();
    end  
    -- LoginScene.super.receiveServerResponseSuccessEvent(self,event);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
end
return AccountBindLayer;