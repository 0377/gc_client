local CustomBaseView = requireForGameLuaFile("CustomBaseView");
local PersonalInfoLayer = class("PersonalInfoLayerCCS",CustomBaseView)  
function PersonalInfoLayer:ctor()
    -- self.csNode = cc.CSLoader:createNode(CustomHelper.getFullPath("PersonalInfoLayerCCS.csb"));
    local CCSLuaNode =  requireForGameLuaFile("PersonalInfoLayerCCS")
	self.csNode = CCSLuaNode:create().root;
    self:addChild(self.csNode);
    self:showView()
	PersonalInfoLayer.super.ctor(self);
end
function PersonalInfoLayer:showView()
	self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
	--显示头像 
	self:showHeadIcon();
	self:showPersonInfo();
	local modifyHeadBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "change_head_btn"), "ccui.Button");
	modifyHeadBtn:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		local AvatarModifyLayer = requireForGameLuaFile("AvatarModifyLayer")
		local layer = AvatarModifyLayer:create();
		cc.Director:getInstance():getRunningScene():addChild(layer)
	end);
	--修改密码按钮
	local changePwdBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "change_pwd_btn"), "ccui.Button");
	changePwdBtn:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		ViewManager.setForceAlertOneView(true);
		ViewManager.enterChangePwdLayer();
	end)
	-- 更换账户按钮
	local logoutBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "exit_btn"), "ccui.Button");
	logoutBtn:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		local runnscene = cc.Director:getInstance():getRunningScene();
		if runnscene.alertLogoutTipView then
			--todo
			runnscene:alertLogoutTipView()
		end
	end)
	changePwdBtn:setVisible(true);
	logoutBtn:setVisible(true);
	local isGuest = self.myPlayerInfo:getIsGuest();
	if isGuest then
		--todo
		changePwdBtn:setVisible(false)
		logoutBtn:setVisible(false);
	else

	end
	--显示玩家ID
	local userIDText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "id_text"), "ccui.Text");
	userIDText:setString(self.myPlayerInfo:getGuid());
	local accountText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "account_text"), "ccui.Text");
	accountText:setString(self.myPlayerInfo:getAccount());
	local goldText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "gold_text"), "ccui.Text");
	local moneyStr = CustomHelper.moneyShowStyleNone(self.myPlayerInfo:getMoney());
	goldText:setString(moneyStr)
	
	local btnCopyId = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_copy_id"), "ccui.Button")
	btnCopyId:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		local PayHelper = requireForGameLuaFile("PayHelper")
		if PayHelper.copyStrToShearPlate(self,self.myPlayerInfo:getGuid()) then
			MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "ID已复制到剪贴板")
		end
	end)
	
end
function PersonalInfoLayer:showPersonInfo()
	if self.editBtn == nil then
		--todo
		self.editBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "edit_nickname_btn"), "ccui.Button");
		self.editBtn:addClickEventListener(function()
			self.nickNameEditBox:touchDownAction(self.nickNameEditBox, ccui.TouchEventType.ended)
		end)
	end
	if self.saveBtn == nil then
	 	--todo
	 	self.saveBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "save_btn"), "ccui.Button");
	 	self.saveBtn:addClickEventListener(function()
	 		self:saveNewNickName();
	 	end)
	end
	if self.nickNameEditBox == nil then
		--todo
	    local nickNameEditBoxBgNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "nick_name_text"), "ccui.Text");
	    local bgFileName = "bank_file"
	    self.nickNameEditBox = ccui.EditBox:create(nickNameEditBoxBgNode:getContentSize(),bgFileName)
	    self.nickNameEditBox:setPosition(nickNameEditBoxBgNode:getPosition())
	    self.nickNameEditBox:setAnchorPoint(nickNameEditBoxBgNode:getAnchorPoint())
	    self.nickNameEditBox:setFontName("Helvetica-Bold")
	    self.nickNameEditBox:setFontSize(30)
	    self.nickNameEditBox:setFontColor(cc.c3b(255, 255, 255))
	    self.nickNameEditBox:setPlaceHolder("请输入新的昵称")
	    self.nickNameEditBox:setPlaceholderFontColor(cc.c3b(103, 95, 96))
	    self.nickNameEditBox:setPlaceholderFontSize(30)
	    self.nickNameEditBox:setMaxLength(20)
    	self.nickNameEditBox:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    	self.nickNameEditBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
	    self.nickNameEditBox:registerScriptEditBoxHandler(function(eventType)
    		if eventType == "ended" then
    			--todo
    			local nickNameStr = self.nickNameEditBox:getText();
    			local orginNickname = self.myPlayerInfo:getNickName()
    			if nickNameStr == "" then
    				--todo
    				self.nickNameEditBox:setText(orginNickname)
    				nickNameStr = self.nickNameEditBox:getText();
    			end
    			if nickNameStr == orginNickname then
    				--todo
    				--显示修改
					self.saveBtn:setVisible(false);
					self.editBtn:setVisible(true);
    			else --显示保存
    					--todo	
					self.saveBtn:setVisible(true);
					self.editBtn:setVisible(false);
    			end
    		end
    		print("print:",eventType)
    	end)
	    -- )
	    nickNameEditBoxBgNode:setVisible(false);
	    nickNameEditBoxBgNode:getParent():addChild(self.nickNameEditBox, 100)
	end
	self.nickNameEditBox:setText(self.myPlayerInfo:getNickName())
	self.nickNameEditBox:setTouchEnabled(true);
	self.saveBtn:setVisible(false);
	self.editBtn:setVisible(true);
	if self.myPlayerInfo:getIsGuest() then -- 游客不能改名
		--todo
		self.editBtn:setVisible(false);
		self.nickNameEditBox:setTouchEnabled(false);
	end
end
--显示头像
function PersonalInfoLayer:showHeadIcon()
	local headParentView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "head_icon_parent"), "cc.Node");
	local headNodeName = "head_icon_node"
	local preHeadIconNode = headParentView:getChildByName(headNodeName)
	if preHeadIconNode then
		--todo
		preHeadIconNode:removeFromParent();
	end

	local headSpr = cc.Sprite:create(self.myPlayerInfo:getSquareHeadIconPath());
	headSpr:setScale(headParentView:getContentSize().width/headSpr:getContentSize().width);
	--将正方形头像截取圆角
	local clipperNode = cc.ClippingNode:create();
	clipperNode:setStencil(cc.Sprite:create(CustomHelper.getFullPath("hall_res/setting/bb_grxx_txk.png")))
	--clipperNode:setAlphaThreshold(0.0);
	clipperNode:setScale(0.93)
	clipperNode:addChild(headSpr);
	clipperNode:setName(headNodeName)
	headParentView:addChild(clipperNode)
	clipperNode:setPosition(cc.p(clipperNode:getParent():getContentSize().width/2,clipperNode:getParent():getContentSize().height/2))
end
function PersonalInfoLayer:saveNewNickName()
	local nickNameTextStr = self.nickNameEditBox:getText(); 
	if nickNameTextStr == "" then
        errorStr = "请您输入昵称！";
    end
    --if not CustomHelper.checkTextType(nickNameTextStr,"^[\w\u4e00-\u9fa5]+$") then 
    errorStr = CustomHelper.isNameLegal(nickNameTextStr )
	if errorStr ~= nil then
		--todo
		 MyToastLayer.new(cc.Director:getInstance():getRunningScene(), errorStr)
		 return;
	end
	local infoTab = {};
	infoTab["nickname"] = nickNameTextStr;
	self.saveBtn:setEnabled(false);
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(HallMsgManager.MsgName.CS_SetNickname,infoTab);
end

--
function PersonalInfoLayer:receiveRefreshPlayerInfoNotify()
	self:showView()
end
function PersonalInfoLayer:registerNotification()
    self:addOneTCPMsgListener(HallMsgManager.MsgName.CS_SetNickname)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_SetNickname)
    PersonalInfoLayer.super.registerNotification(self);
end
--消息发送失败
function PersonalInfoLayer:receiveMsgRequestErrorEvent(event)
    self.saveBtn:setEnabled(true);
    PersonalInfoLayer.super.receiveMsgRequestErrorEvent(self,event)
end
function PersonalInfoLayer:receiveServerResponseErrorEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    local isCallSuper = true;
    if msgName == HallMsgManager.MsgName.SC_SetNickname then
		self.saveBtn:setEnabled(true);
    end  
	PersonalInfoLayer.super.receiveServerResponseErrorEvent(self,event)
end
--收到服务器处理成功通知函数
function PersonalInfoLayer:receiveServerResponseSuccessEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
	dump(msgName)
    if msgName == HallMsgManager.MsgName.SC_SetNickname then
    	--todo
    	self.saveBtn:setEnabled(true);
    	MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "昵称修改成功！");
    	self:showPersonInfo()
    end
end
return PersonalInfoLayer;