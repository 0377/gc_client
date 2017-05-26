local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local  PasswordModifyLayer = class("PasswordModifyLayer", CustomBaseView)
function PasswordModifyLayer:ctor()
    
    print("PasswordModifyLayer------")

	-- self.csNode = cc.CSLoader:createNode(CustomHelper.getFullPath("PasswordModifyLayerCCS.csb"));
    local CCSLuaNode =  requireForGameLuaFile("PasswordModifyLayerCCS")
    self.csNode = CCSLuaNode:create().root;
    self:addChild(self.csNode);
    local alertPanel = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alert_panel"), "ccui.Widget");
    CustomHelper.addAlertAppearAnim(alertPanel);
    local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "close_btn"), "ccui.Widget");
    closeBtn:addClickEventListener(function()
    	GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    	self:removeSelf();
    end)
    local mobileFindPwdBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "mobile_reset_pwd_btn"), "ccui.Button");
    mobileFindPwdBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        local MobilePhoneModidfyPwdLayer = requireForGameLuaFile("MobilePhoneModidfyPwdLayer");
        local layer = MobilePhoneModidfyPwdLayer:create();
        cc.Director:getInstance():getRunningScene():addChild(layer)
        --关闭当前界面
        self:removeSelf();
    end);
    self:initView()
    PasswordModifyLayer.super.ctor(self)
end
function PasswordModifyLayer:initView()
    local oldPwdEditBoxBgNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "oldpwd_bg"), "ccui.ImageView");
    local bgFileName = "blankFile"
    self.oldPwdEditBox = ccui.EditBox:create(oldPwdEditBoxBgNode:getContentSize(),bgFileName)
    self.oldPwdEditBox:setPosition(oldPwdEditBoxBgNode:getPosition())
    self.oldPwdEditBox:setAnchorPoint(oldPwdEditBoxBgNode:getAnchorPoint())
    self.oldPwdEditBox:setFontName("Helvetica-Bold")
    self.oldPwdEditBox:setFontSize(30)
    self.oldPwdEditBox:setFontColor(cc.c3b(255, 255, 255))
    self.oldPwdEditBox:setPlaceHolder("请输入旧密码")
    self.oldPwdEditBox:setPlaceholderFontColor(cc.c3b(103, 95, 96))
    self.oldPwdEditBox:setPlaceholderFontSize(30)
    self.oldPwdEditBox:setMaxLength(18)
    self.oldPwdEditBox:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    self.oldPwdEditBox:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    self.oldPwdEditBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    oldPwdEditBoxBgNode:getParent():addChild(self.oldPwdEditBox)   

    local newPwdEditBoxBgNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "newpwd_bg"), "ccui.ImageView");
    self.newPwdEditBox = ccui.EditBox:create(newPwdEditBoxBgNode:getContentSize(),bgFileName)
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
    self.newPwd2EditBox = ccui.EditBox:create(newPwd2EditBoxBgNode:getContentSize(),bgFileName)
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
    self.pwdModifyBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "pwd_modify_btn"), "ccui.Button");
    self.pwdModifyBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
        self:clickPwdModfyBtn();
    end);
end
function PasswordModifyLayer:clickPwdModfyBtn()
    local oldPwdStr = self.oldPwdEditBox:getText();
    local newPwdStr = self.newPwdEditBox:getText();
    local newPwd2Str = self.newPwd2EditBox:getText();
    local errorStr = nil
    if errorStr == nil and oldPwdStr == "" then
        --todo
        errorStr = "请输入旧密码"
    end
    if errorStr == nil and oldPwdStr ~= GameManager:getInstance():getHallManager():getHallDataManager():getSavePlayerPwd() then
        errorStr = "旧密码不正确"
    end 


    if errorStr == nil and newPwdStr == "" then
        --todo
        errorStr = "请输入新密码"
    end
    if errorStr == nil and newPwdStr ~= newPwd2Str then
        --todo
        errorStr = "两次密码不一致"
    end
    if errorStr == nil then
		--todo
		errorStr = CustomHelper.isPasswordNumberLegal(newPwdStr )
	end
    if errorStr == nil and oldPwdStr == newPwdStr then
        --todo
        errorStr = "新密码与输入的旧密码一致"
    end




    if errorStr ~= nil then
        --todo
        MyToastLayer.new(cc.Director:getInstance():getRunningScene(), errorStr)
        return
    end
    --[[
    optional string old_password = 1;               // 旧密码 需要加密
    optional string password = 2;                   // 新密码 需要加密
    ]]
    self.isResetbyOldPwd = true;
    self.pwdModifyBtn:setEnabled(false)
    GameManager:getInstance():getHallManager():getHallMsgManager():sendResetPwdByOldPwd(oldPwdStr,newPwdStr)
end

function PasswordModifyLayer:registerNotification()
    ---增加服务器消息监听 ,只有增加了的命令，才会回调对应成功监听函数
    self:addOneTCPMsgListener(HallMsgManager.MsgName.CS_SetPassword);
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_SetPassword);

    PasswordModifyLayer.super.registerNotification(self);
end 
--消息发送失败
function PasswordModifyLayer:receiveMsgRequestErrorEvent(event)
    self.pwdModifyBtn:setEnabled(true)
    PasswordModifyLayer.super.receiveMsgRequestErrorEvent(self,event)
end
function PasswordModifyLayer:receiveServerResponseErrorEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    local isCallSuper = true;
    if msgName == HallMsgManager.MsgName.SC_SetPassword and self.isResetbyOldPwd == true then
        self.pwdModifyBtn:setEnabled(true)
    end  
    PasswordModifyLayer.super.receiveServerResponseErrorEvent(self,event)
end
--收到服务器处理成功通知函数
function PasswordModifyLayer:receiveServerResponseSuccessEvent(event)
    print("LoginScene:receiveServerResponseSuccessEvent(event)")  
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == HallMsgManager.MsgName.SC_SetPassword and self.isResetbyOldPwd == true then
        -- self:showVerifyCoundDownTip();
        self.isResetbyOldPwd = false
        --恢复按钮
        self.pwdModifyBtn:setEnabled(true)
        self.oldPwdEditBox:setText("");
        self.newPwdEditBox:setText("");
        self.newPwd2EditBox:setText("");
        MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "密码修改成功！")
        self:removeSelf();
    end  
    -- LoginScene.super.receiveServerResponseSuccessEvent(self,event);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
end
return PasswordModifyLayer;
