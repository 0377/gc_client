local CustomBaseScene = requireForGameLuaFile("CustomBaseScene")
local LoginScene = class("LoginScene",CustomBaseScene);
local TextStringForSavePwd = "******" -- 有保存账号时,密码信息
LoginScene.isChangedAccount     = false
function LoginScene:ctor()
    print("login scene ctor")
    -- local csNodePath = cc.FileUtils:getInstance():fullPathForFilename("LoginAccountLayerCCS.csb");
    local CCSLuaNode =  requireForGameLuaFile("LoginAccountLayerCCS")
    self.csNode = CCSLuaNode:create().root;
    local winSize = CustomHelper.getWinSize();
    self:addChild(self.csNode);
    -- 添加背景动画baoboblue
    -- local bgPanelNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Panel_Bg"), "ccui.Widget");
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("anim/login/bb_signed_eff/bb_signed_eff.ExportJson")
    -- local t_animate = ccs.Armature:create( "bb_signed_eff")
    -- t_animate:getAnimation():play("ani_01")
    -- bgPanelNode:addChild(t_animate)
    -- t_animate:setPosition(cc.p(t_animate:getParent():getContentSize().width/2,t_animate:getParent():getContentSize().height/2))
    --快速开始按钮
	self.quickStartBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"quickStartBtn"), "ccui.Button");
	self.quickStartBtn:addClickEventListener(function(sender)
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
		self:clickQuickStartBtn();
	end);
	--登录按钮
	self.loginBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "loginBtn"), "ccui.Button");
	self.loginBtn:addClickEventListener(function(sender)
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
		self:clickLoginBtn();
	end);
	self.mobilePhoneLoginBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"phone_login_view_btn"),"ccui.Button");
	self.mobilePhoneLoginBtn:addClickEventListener(function ()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
		local MobilePhoneLoginLayer = requireForGameLuaFile("MobilePhoneLoginLayer")
		local layer = MobilePhoneLoginLayer:create();
		self:addChild(layer);
	end);
    self:addSomeNodes()
	LoginScene.super.ctor(self);
    self:aotuLogin()
end
function LoginScene:addSomeNodes()
    --添加账号输入框
    local usernameBgNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Image_3"), "ccui.ImageView");
    --usernameBgNode:setVisible(false);
    local editboxBgFileName = "emptyfile"
    local editBoxSize = cc.size(usernameBgNode:getContentSize().width -10,usernameBgNode:getContentSize().height -10)
    self.usernameField = ccui.EditBox:create(editBoxSize,editboxBgFileName)
    self.usernameField:setPosition(cc.p(usernameBgNode:getPositionX(),usernameBgNode:getPositionY()))
    -- self.usernameField:setFontName("Helvetica-Bold")
    self.usernameField:setFontSize(32)
    self.usernameField:setFontColor(cc.c3b(223,232,82))
    self.usernameField:setPlaceHolder("请输入帐号")
    self.usernameField:setPlaceholderFontColor(cc.c3b(103,95,96))
    self.usernameField:setPlaceholderFontSize(32)
    self.usernameField:setMaxLength(18)
    self.usernameField:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD);
    self.usernameField:setInputMode(cc.EDITBOX_INPUT_MODE_PHONENUMBER);
    -- self._accountTf:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    self.usernameField:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    usernameBgNode:getParent():addChild(self.usernameField,100)

    --添加密码输入框
    local passwordBgNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Image_4"), "ccui.Widget")
    -- 宝博蓝版
    self.passwordField = ccui.EditBox:create(editBoxSize,editboxBgFileName)
    self.passwordField:setPosition(cc.p(passwordBgNode:getPositionX(),passwordBgNode:getPositionY()))
    -- self.passwordField:setFontName("Helvetica-Bold")
    self.passwordField:setFontSize(32)
    self.passwordField:setFontColor(cc.c3b(223,232,82))
    self.passwordField:setPlaceHolder("请输入密码")
    self.passwordField:setPlaceholderFontColor(cc.c3b(103,95,96))
    self.passwordField:setPlaceholderFontSize(32)
    self.passwordField:setMaxLength(18)
    self.passwordField:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    self.passwordField:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)

    self.passwordField:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    passwordBgNode:getParent():addChild(self.passwordField,100)
--    self._passwordField:setText("******")
    self:showAccountInfo();
end
function LoginScene:showAccountInfo()
    self.savePassword = GameManager:getInstance():getHallManager():getHallDataManager():getSavePlayerPwd();
    if self.savePassword and #self.savePassword > 0 then
        self.passwordField:setText(TextStringForSavePwd)
    else
        self.passwordField:setText("")
    end
    local saveAccount = GameManager:getInstance():getHallManager():getHallDataManager():getSavePlayerAccount();
    self.usernameField:setText(saveAccount or "")
    --如果不是切换账号
    -- if LoginScene.isChangedAccount == false then
    --     if saveAccount and #saveAccount > 0 then --存在账号
    --         self:clickLoginBtn()
    --     else
    --         self:clickQuickStartBtn()
    --     end
    -- else

    -- end
end
function LoginScene:aotuLogin()
    local seq = cc.Sequence:create(cc.DelayTime:create(0.3),cc.CallFunc:create(function()
        local saveAccount = GameManager:getInstance():getHallManager():getHallDataManager():getSavePlayerAccount();
        --如果不是切换账号
        if LoginScene.isChangedAccount == false then
            if saveAccount and #saveAccount > 0 then --存在账号
                self:clickLoginBtn()
            else
                self:clickQuickStartBtn()
            end
        else

        end
    end))
    self:runAction(seq)
end


--监听相关通知
function LoginScene:registerNotification()
    -- print("3432432423432")
	local dispatcher = cc.Director:getInstance():getEventDispatcher();
    self:addOneTCPMsgListener(HallMsgManager.MsgName.CL_RegAccount,{HallMsgManager.MsgName.LC_Login});
	LoginScene.super.registerNotification(self);
    dump(self.cmdSet, "self.cmdSet", nesting)
end
function LoginScene:onCreate()
    -- add background image
    -- add HelloWorld label
    --test about login 
end
--点击快速开始按钮
function LoginScene:clickQuickStartBtn()
	--增加风火轮
	CustomHelper.addIndicationTip(HallUtils:getDescriptionWithKey("loginTip"),self,0);
	GameManager:getInstance():getHallManager():getHallMsgManager():sendQuickStartMsg();
end
function LoginScene:clickLoginBtn()
    local account = self.usernameField:getText()
    local pwd = self.passwordField:getText()
    if account == nil or account == "" or pwd == nil or pwd == "" then --please input account and password
        --todo
        MyToastLayer.new(self, "请输入用户名和密码")
        return;
    end
    local saveStr = GameManager:getInstance():getHallManager():getHallDataManager():getSavePlayerAccount();
    if saveStr ~= account then
        local errorStr = nil
        errorStr = CustomHelper.isPhoneNumberLegal(account);
        
        if errorStr ~= nil then
            MyToastLayer.new(self, errorStr)
            return;
        end
    end
    if pwd == TextStringForSavePwd then
        --todo
        pwd = self.savePassword;
    end
    CustomHelper.addIndicationTip(HallUtils:getDescriptionWithKey("loginTip"),self,0);
	GameManager:getInstance():getHallManager():getHallMsgManager():sendLoginMsg(account,pwd);
end

function LoginScene:receiveServerResponseErrorEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    local ret = userInfo["ret"] or userInfo["result"]; 
    if msgName == HallMsgManager.MsgName.LC_Login and (ret == 15 or ret == 32 )then --賬號被封\服务器登录维护中
        CustomBaseScene.super.receiveServerResponseErrorEvent(self,event);
    else
        LoginScene.super.receiveServerResponseErrorEvent(self,event);
    end
end
function LoginScene:receiveServerResponseSuccessEvent(event)
	print("LoginScene:receiveServerResponseSuccessEvent(event)")  
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == HallMsgManager.MsgName.C_PublicKey then
        -- CustomHelper.addIndicationTip(HallUtils:getDescriptionWithKey("loginTip"),self,0);
        local isResendMsg = GameManager:getInstance():getHallManager():getHallMsgManager():checkIsNeedResendMsgToServer(false);
        if isResendMsg == false then
            --todo
            MyToastLayer.new(self, "网络连接成功")
            CustomHelper.removeIndicationTip();
        end
    elseif msgName == HallMsgManager.MsgName.LC_Login then --登录成功，则发送获取玩家信息
    	--todo
        CustomHelper.removeIndicationTip();
        local callback = function()
            --发送获取玩家信息消息
            GameManager:getInstance():getHallManager():getHallMsgManager():checkIsNeedResendMsgToServer(true);
            CustomHelper.addIndicationTip(HallUtils:getDescriptionWithKey("get_player_info_tip"),self,0);
            GameManager:getInstance():getHallManager():getHallMsgManager():sendGetPlayerInfoMsg();
        end
        
        --是否第一次注册账号
        self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
        local isFirst = self.myPlayerInfo:getIsFirst()


        --是否渠道邀请码版本
        local showInviter = CustomHelper.getOneHallGameConfigValueWithKey("inviter_code")
        if isFirst == 1 and showInviter == "true" then 
            local InvitationCodeLayer = requireForGameLuaFile("InvitationCodeLayer")
            local invitationCodeLayer = InvitationCodeLayer:create(callback);
            self:addChild(invitationCodeLayer, 1000);
        else
            local wordVerifyData =  GameManager:getInstance():getHallManager():getHallDataManager():getWordVerifyData();
            --检测是否弹出文字验证框
            if wordVerifyData then
                --todo
                local LoginWordVerifyLayer = requireForGameLuaFile("LoginWordVerifyLayer")
                local loginWordVerifyLayer = LoginWordVerifyLayer:create(wordVerifyData,callback);
                self:addChild(loginWordVerifyLayer, 1000);
            else
                callback();
            end
        end

       
	elseif msgName == HallMsgManager.MsgName.SC_ReplyPlayerInfoComplete then
		--todo
        self:showAccountInfo();
		CustomHelper.removeIndicationTip();
        GameManager:getInstance():getHallManager():callbackWhenLoginFinished();
        -- CustomHelper.removeIndicationTip();
    end  
    -- LoginScene.super.receiveServerResponseSuccessEvent(self,event);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
end
return LoginScene
