local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local RechargeLayer = class("RechargeLayer", CustomBaseView)
RechargeLayer.ViewType = {
	Zfb = 1,
	Wx = 2,
	TransferPay =3,--转账支付
	Dlcz  = 4,
	Dlzs = 5,
	
}

function RechargeLayer:ctor()
	self.csNode = cc.CSLoader:createNode(CustomHelper.getFullPath("RechargeLayerCCS.csb"));
    self:addChild(self.csNode);
    self.subViewParentNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "sub_view_parent"),"ccui.Widget");
	local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"close_btn"),"ccui.Widget");
	closeBtn:addClickEventListener(function ()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
		self:removeSelf();
	end);
	
	self.showRechargeType = {1,2,3,4,5}
	
	local rechargeType =  CustomHelper.getOneHallGameConfigValueWithKey("recharge_types")
	self.viewBtnListView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "view_btn_listview"), "ccui.Widget");
	self.viewBtnListView:setScrollBarEnabled(false)
	--zfb????
	self.zfbBtn = tolua.cast(CustomHelper.seekNodeByName(self.viewBtnListView, "btn_zfb"), "ccui.Button")
	self.zfbBtn:addClickEventListener(function()
		 GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		 self:showViewWithType(RechargeLayer.ViewType.Zfb)
	end);
	if not rechargeType.zfb then
		table.removebyvalue(self.showRechargeType,RechargeLayer.ViewType.zfb)
		self.viewBtnListView:removeItem(self.viewBtnListView:getIndex(self.zfbBtn))
	end
	
	--wx??ť
	self.wxBtn = tolua.cast(CustomHelper.seekNodeByName(self.viewBtnListView, "btn_wx"), "ccui.Button")
	self.wxBtn:addClickEventListener(function()
		 GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		 self:showViewWithType(RechargeLayer.ViewType.Wx)
	end);
	if not rechargeType.weixin then
		table.removebyvalue(self.showRechargeType,RechargeLayer.ViewType.Wx)
		self.viewBtnListView:removeItem(self.viewBtnListView:getIndex(self.wxBtn))
	end
	
	
	--??????ֵ??ť
	self.dlczBtn = tolua.cast(CustomHelper.seekNodeByName(self.viewBtnListView, "btn_dlcz"), "ccui.Button")
	self.dlczBtn:addClickEventListener(function()
		 GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		 self:showViewWithType(RechargeLayer.ViewType.Dlcz)
	end);
	local agentsInfo =  CustomHelper.getOneHallGameConfigValueWithKey("agents_info")
	if not agentsInfo or #agentsInfo == 0 then
		table.removebyvalue(self.showRechargeType,RechargeLayer.ViewType.Dlcz)
		self.viewBtnListView:removeItem(self.viewBtnListView:getIndex(self.dlczBtn))
	end
	
	--???????̰?ť
	self.dlzsBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_dlzs"), "ccui.Button")
	self.dlzsBtn:addClickEventListener(function()
		 GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		 self:showViewWithType(RechargeLayer.ViewType.Dlzs)
	end);
	local agentsZhaoShang =  CustomHelper.getOneHallGameConfigValueWithKey("agents_zhaoshang")
	if not (agentsZhaoShang and ((agentsZhaoShang.qq and table.nums(agentsZhaoShang.qq) > 0 ) or (agentsZhaoShang.weixin and table.nums(agentsZhaoShang.weixin) > 0 )))then
		table.removebyvalue(self.showRechargeType,RechargeLayer.ViewType.Dlzs)
		self.viewBtnListView:removeItem(self.viewBtnListView:getIndex(self.dlzsBtn))
	end 

	self.transferBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_zzzf"), "ccui.Button")
	self.transferBtn:addClickEventListener(function()
		 GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		 self:showViewWithType(RechargeLayer.ViewType.TransferPay)
	end);
	if not rechargeType.transferpay then
		table.removebyvalue(self.showRechargeType,RechargeLayer.ViewType.TransferPay)
		self.viewBtnListView:removeItem(self.viewBtnListView:getIndex(self.transferBtn))
	end
	
	
	RechargeLayer.super.ctor(self)
	CustomHelper.addWholeScrennAnim(self)
end
--??ʾ????
function RechargeLayer:showViewWithType(viewType)
	local myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
	self.viewType = viewType;
	for _,item in ipairs(self.viewBtnListView:getItems()) do
		item:setEnabled(true)
	end
	
	
	local subViews = self.subViewParentNode:getChildren();
	for i,subView in ipairs(subViews) do
		subView:setVisible(false);
	end
	if viewType == RechargeLayer.ViewType.Zfb then
		--todo
		if self.rechargeZfbLayer ~= nil then
			--todo
			self.rechargeZfbLayer:removeSelf();
			self.rechargeZfbLayer = nil
		end
		local RechargeZfbLayer = requireForGameLuaFile("RechargeTypeLayer")
		self.zfbBtn:setEnabled(false)
		self.rechargeZfbLayer = RechargeZfbLayer:create(viewType);
		self.subViewParentNode:addChild(self.rechargeZfbLayer)
	elseif viewType == RechargeLayer.ViewType.Wx then
		--todo
		if self.rechargeWxLayerr ~= nil then
			--todo
			self.rechargeWxLayerr:removeSelf();
			self.rechargeWxLayerr = nil;
		end
		local RechargeWxLayer = requireForGameLuaFile("RechargeTypeLayer");
		self.wxBtn:setEnabled(false)
		self.rechargeWxLayerr = RechargeWxLayer:create(viewType);
		self.subViewParentNode:addChild(self.rechargeWxLayerr)
	elseif viewType == RechargeLayer.ViewType.Dlcz then
		--todo
		if self.rechargeDlczLayer ~= nil then
			--todo
			self.rechargeDlczLayer:removeSelf()
			self.rechargeDlczLayer = nil;
		end
		self.dlczBtn:setEnabled(false)
		local RechargeDlczLayer = requireForGameLuaFile("RechargeDlczLayer");
		self.rechargeDlczLayer = RechargeDlczLayer:create();
		self.subViewParentNode:addChild(self.rechargeDlczLayer)
	elseif viewType == RechargeLayer.ViewType.Dlzs then
		--todo
		if self.rechargeDlzsLayer ~= nil then
			--todo
			self.rechargeDlzsLayer:removeSelf()
			self.rechargeDlzsLayer = nil;
		end
		self.dlzsBtn:setEnabled(false)
		local RechargeDlzsLayer = requireForGameLuaFile("RechargeDlzsLayer");
		self.rechargeDlzsLayer = RechargeDlzsLayer:create();
		self.subViewParentNode:addChild(self.rechargeDlzsLayer)
	elseif viewType == RechargeLayer.ViewType.TransferPay then
		--todo
		if self.rechargeTransferPayLayer ~= nil then
			--todo
			self.rechargeTransferPayLayer:removeSelf();
			self.rechargeTransferPayLayer = nil
		end
		local rechargeTransferPayLayer = requireForGameLuaFile("RechargeTypeLayer")
		self.transferBtn:setEnabled(false)
		self.rechargeTransferPayLayer = rechargeTransferPayLayer:create(viewType);
		self.subViewParentNode:addChild(self.rechargeTransferPayLayer)
	end
end
return RechargeLayer;