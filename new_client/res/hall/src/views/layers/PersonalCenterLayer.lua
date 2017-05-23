local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local PersonalCenterLayer = class("PersonalCenterLayer", CustomBaseView)
PersonalCenterLayer.ViewType = {
	BindAccountView = 1,
	PersonInfoView = 2,
	BindAlipayView  = 3
}
function PersonalCenterLayer:ctor()
	-- self.csNode = cc.CSLoader:createNode(CustomHelper.getFullPath("PersonalCenterLayerCCS.csb"));
	local CCSLuaNode =  requireForGameLuaFile("PersonalCenterLayerCCS")
	self.csNode = CCSLuaNode:create().root;
    self:addChild(self.csNode);

    ViewManager.initPublicTopInfoLayer(self,"hall_res/account/bb_grxx_bt.png")
    self.subViewParentNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "sub_view_parent"),"ccui.Widget");
	local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"close_btn"),"ccui.Widget");
	closeBtn:addClickEventListener(function ()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
		self:removeSelf();
	end);
	--bind_ account btn
	self.accountBindBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"account_bind_view_btn"),"ccui.Button");
	self.accountBindBtn:addClickEventListener(function ()
		 GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		self:showViewWithType(PersonalCenterLayer.ViewType.BindAccountView)
	end)
	self.personInfoBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "person_info_view_btn"), "ccui.Button");
	self.personInfoBtn:addClickEventListener(function()
		 GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		self:showViewWithType(PersonalCenterLayer.ViewType.PersonInfoView)
	end)
	-- self.alipayBindBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alipay_bind_view_btn"), "ccui.Button");
	-- self.alipayBindBtn:addClickEventListener(function()
	-- 	 GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
	-- 	self:showViewWithType(PersonalCenterLayer.ViewType.BindAlipayView)
	-- end)

	--正式账号不显示绑定账号按钮
	if GameManager:getInstance():getHallManager():getPlayerInfo():getIsGuest() == false then
		self.accountBindBtn:setVisible(false)
	end

	if CustomHelper.isExaminState() then
		-- self.alipayBindBtn:setVisible(false)
	end

	PersonalCenterLayer.super.ctor(self);
	CustomHelper.addWholeScrennAnim(self)
end
--显示界面
function PersonalCenterLayer:showViewWithType(viewType)
	
	local myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
	if myPlayerInfo:getIsGuest() == false then -- 绑定后的用户 不显示
		--todo
		if viewType == PersonalCenterLayer.ViewType.BindAccountView then 
			viewType = PersonalCenterLayer.ViewType.PersonInfoView
		end
		self.accountBindBtn:setVisible(false)

		-- if self.accountBindBtn ~= nil then
		-- 	--todo
		-- 	self.accountBindBtn:removeFromParent();
		-- 	self.accountBindBtn = nil;
		-- end
	else -- 如果是游客
		if viewType == PersonalCenterLayer.ViewType.BindAlipayView then
			--todo
			viewType = PersonalCenterLayer.ViewType.BindAccountView
			MyToastLayer.new(cc.Director:getInstance():getRunningScene(),HallUtils:getDescriptionWithKey("BandAlipay_Need_BindAccount"))
		end
	end
	if self.accountBindBtn ~= nil then
		--todo
		self.accountBindBtn:setEnabled(true);
	end
	self.viewType = viewType;
	self.personInfoBtn:setEnabled(true);
	-- self.alipayBindBtn:setEnabled(true);
	local subViews = self.subViewParentNode:getChildren();
	for i,subView in ipairs(subViews) do
		subView:setVisible(false);
	end
	if viewType == PersonalCenterLayer.ViewType.BindAccountView then
		--todo
		if self.accountBindLayer == nil then
			--todo
			local AccountBindLayer = requireForGameLuaFile("AccountBindLayer")
			self.accountBindLayer = AccountBindLayer:create();
			self.subViewParentNode:addChild(self.accountBindLayer)
		end
		self.accountBindBtn:setEnabled(false);
		self.accountBindLayer:setVisible(true);
	elseif viewType == PersonalCenterLayer.ViewType.PersonInfoView then
		--todo
		if self.personalInfoLayer == nil then
			--todo
			local PersonalInfoLayer = requireForGameLuaFile("PersonalInfoLayer");
			self.personalInfoLayer = PersonalInfoLayer:create();
			self.subViewParentNode:addChild(self.personalInfoLayer)
		end
		self.personInfoBtn:setEnabled(false);
		self.personalInfoLayer:setVisible(true);
	elseif viewType == PersonalCenterLayer.ViewType.BindAlipayView then
		--todo
		if self.alipayBindLayer == nil then
			--todo
			local AlipayBindLayer = requireForGameLuaFile("AlipayBindLayer");
			self.alipayBindLayer = AlipayBindLayer:create();
			self.subViewParentNode:addChild(self.alipayBindLayer)
		end
		-- self.alipayBindBtn:setEnabled(false);
		self.alipayBindLayer:setVisible(true);
	end
	--读取按钮是否显示按钮
	local personCenterBtnConfig = CustomHelper.getOneHallGameConfigValueWithKey("personal_center_btns")
	local needShowBtnArray = {}
	if personCenterBtnConfig then
		--todo
		for i,v in ipairs(personCenterBtnConfig) do
			for btnName,visible in pairs(v) do
				local tempBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, btnName), "ccui.Button");
				if tempBtn then
					--todo
					if visible then
						--todo
						if tempBtn:isVisible() then
							--todo
							table.insert(needShowBtnArray,tempBtn);
						end
					else
						tempBtn:setVisible(false);
					end
				end
			end
		end
	end
	local btnsParentNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btns_parent_view"), "ccui.Widget");
	btnsParentNode:setContentSize(cc.size(btnsParentNode:getContentSize().width,0));
	local  btnSpace = 10
	local btnsNum = #needShowBtnArray
	for i=1,btnsNum do
		local tempBtn = needShowBtnArray[btnsNum - i + 1]
		tempBtn:retain();
		tempBtn:removeFromParent();
		btnsParentNode:addChild(tempBtn);
		tempBtn:setAnchorPoint(cc.p(0,0.5));
		local posY = btnsParentNode:getContentSize().height + tempBtn:getContentSize().height/2
		if i ~= 1 then
			--todo
			posY = posY + btnSpace
		end
		tempBtn:setPosition(cc.p(0,posY))
		btnsParentNode:setContentSize(cc.size(btnsParentNode:getContentSize().width,posY + tempBtn:getContentSize().height/2));			
		tempBtn:release()
	end
end
function PersonalCenterLayer:receiveRefreshPlayerInfoNotify()
	self:showViewWithType(self.viewType);
end
return PersonalCenterLayer;