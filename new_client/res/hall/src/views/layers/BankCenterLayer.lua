local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local BankCenterLayer = class("BankCenterLayer", CustomBaseView)
BankCenterLayer.ViewType = {
	Deposit = 1,
	WithDraw = 2,
	TransferAccounts  = 3
}
function BankCenterLayer:ctor()
	self.csNode = cc.CSLoader:createNode(CustomHelper.getFullPath("BankCenterLayerCCS.csb"));
    self:addChild(self.csNode);
    self.subViewParentNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "sub_view_parent"),"ccui.Widget");
	local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"close_btn"),"ccui.Widget");
	closeBtn:addClickEventListener(function ()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
		self:removeSelf();
	end);
	local viewBtnListView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "view_btn_listview"), "ccui.Widget");
	viewBtnListView:setScrollBarEnabled(false)
	--存入界面
	self.depositViewBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "bank_deposit_view_btn"), "ccui.Button")
	self.depositViewBtn:addClickEventListener(function()
		 GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		 self:showViewWithType(BankCenterLayer.ViewType.Deposit)
	end);
	--转出界面按钮
	self.withdrawViewBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "bank_viewdraw_view_btn"), "ccui.Button")
	self.withdrawViewBtn:addClickEventListener(function()
		 GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		 self:showViewWithType(BankCenterLayer.ViewType.WithDraw)
	end);
	--转账界面按钮
	self.transferAccountsViewBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "transfer_accounts_view_btn"), "ccui.Button")
	self.transferAccountsViewBtn:addClickEventListener(function()
		 GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		 self:showViewWithType(BankCenterLayer.ViewType.TransferAccounts)
	end);

	local myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
	--关闭转账功能
	local p = myPlayerInfo:getEnable_transfer()
	
	if myPlayerInfo:getEnable_transfer() == true then
		self.transferAccountsViewBtn:setVisible(true);
	else
		self.transferAccountsViewBtn:setVisible(false);
	end
	BankCenterLayer.super.ctor(self)
	CustomHelper.addWholeScrennAnim(self)
end
--显示界面
function BankCenterLayer:showViewWithType(viewType)
	local myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
	self.viewType = viewType;
	self.depositViewBtn:setEnabled(true);
	self.withdrawViewBtn:setEnabled(true);
	self.transferAccountsViewBtn:setEnabled(true);
	local subViews = self.subViewParentNode:getChildren();
	for i,subView in ipairs(subViews) do
		subView:setVisible(false);
	end
	if viewType == BankCenterLayer.ViewType.Deposit then
		--todo
		if self.bankDepositLayer ~= nil then
			--todo
			self.bankDepositLayer:removeSelf();
			self.bankDepositLayer = nil
		end
		local BankDepositLayer = requireForGameLuaFile("BankDepositLayer")
		self.depositViewBtn:setEnabled(false)
		self.bankDepositLayer = BankDepositLayer:create();
		self.subViewParentNode:addChild(self.bankDepositLayer)
	elseif viewType == BankCenterLayer.ViewType.WithDraw then
		--todo
		if self.bankWithdrawLayer ~= nil then
			--todo
			self.bankWithdrawLayer:removeSelf();
			self.bankWithdrawLayer = nil;
		end
		local BankWithdrawLayer = requireForGameLuaFile("BankWithdrawLayer");
		self.withdrawViewBtn:setEnabled(false)
		self.bankWithdrawLayer = BankWithdrawLayer:create();
		self.subViewParentNode:addChild(self.bankWithdrawLayer)
	elseif viewType == BankCenterLayer.ViewType.TransferAccounts then
		--todo
		if self.bankTransferAccountsLayer ~= nil then
			--todo
			self.bankTransferAccountsLayer:removeSelf()
			self.bankTransferAccountsLayer = nil;
		end
		self.transferAccountsViewBtn:setEnabled(false)
		local BankTransferAccountsLayer = requireForGameLuaFile("BankTransferAccountsLayer");
		self.bankTransferAccountsLayer = BankTransferAccountsLayer:create();
		self.subViewParentNode:addChild(self.bankTransferAccountsLayer)
	end
end
return BankCenterLayer;