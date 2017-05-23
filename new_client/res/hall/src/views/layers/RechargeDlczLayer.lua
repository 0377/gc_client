local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local RechargeDlczLayer = class("RechargeDlczLayer", CustomBaseView)


--临时数据
local agents = CustomHelper.getOneHallGameConfigValueWithKey("agents_info")
function RechargeDlczLayer:ctor()
	-- self.csNode = cc.CSLoader:createNode(CustomHelper.getFullPath("RechargeDlczLayerCCS.csb"));
	local CCSLuaNode =  requireForGameLuaFile("RechargeDlczLayerCCS")
	self.csNode = CCSLuaNode:create().root;
    self:addChild(self.csNode);
    self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
	-- self.moneyText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "money_text"), "ccui.Text");
	-- self.bankText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "bank_text"), "ccui.Text");
	-- self.idText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "id_text"), "ccui.Text");
	self:resetTempMondAndBank();
	self:showMoneyInfoView();
    self:initView();
	self.page = 1 
	if agents then
		self.maxPage =  math.ceil(#agents / 8)
	end
	self:showAgentsPage(self.page)
	RechargeDlczLayer.super.ctor(self);
end

function RechargeDlczLayer:initView()
	
	local text =  tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Text_26"), "ccui.Text");
	local yhfk_btn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_yhfk"), "ccui.Button");
	yhfk_btn:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		ViewManager.setForceAlertOneView(true)
		ViewManager.enterOneLayerWithClassName("FeedbackLayerNew")
	end);

	

	self.left_btn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_left"), "ccui.Button");
	self.left_btn:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		self.page = self.page-1
		self:showAgentsPage(self.page)
	end);
	self.right_btn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_right"), "ccui.Button");
	self.right_btn:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		self.page = self.page + 1
		self:showAgentsPage(self.page)
	end);
	self.dlsView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Panel_dls"), "ccui.Layout");

	if #agents == 0 then
		text:setVisible(false)
		left_btn:setVisible(false);
		right_btn:setVisible(false); 
	end 
end

--初始化代理商选项卡页面
function RechargeDlczLayer:showAgentsPage(page)
	if #agents == 0 then return end 
	self.dlsView:removeAllChildren()
	local startX = 0 
	local startY = 190
	for i=1,8 do
		local index = (page-1)*8 + i
		if index > #agents then break end
		local rechargeDailiNode =   requireForGameLuaFile("secondary_game_node.RechargeDailiNode")
		local node = rechargeDailiNode:create(agents[index])
		node:setPosition(cc.p(startX + (i-1)%4*237,startY - math.modf((i-1)/4)*190))
		print("showAgentsPage:",i)
		self.dlsView:addChild(node)
	end
	if self.maxPage > 1 then 
		self.left_btn:setVisible(true);
		self.right_btn:setVisible(true);
		if page == self.maxPage then
			self.right_btn:setVisible(false);
		end
		if page == 1 then
			self.left_btn:setVisible(false)
		end	
	end 
end

function RechargeDlczLayer:resetTempMondAndBank()
	self.tempMoney = self.myPlayerInfo:getMoney();
	self.tempBank = self.myPlayerInfo:getBank()
	self.willRechargeValue = 0
end
function RechargeDlczLayer:showMoneyInfoView()
	-- local moneyStr = CustomHelper.moneyShowStyleNone(self.tempMoney - self.willRechargeValue)
	-- self.moneyText:setString(moneyStr)

	-- local bankMoneyStr = CustomHelper.moneyShowStyleNone(self.tempBank);
	-- self.bankText:setString(bankMoneyStr)

	-- local  idStr = tostring(self.myPlayerInfo:getGuid())
	-- self.idText:setString(idStr);
end

--发送存钱消息

function RechargeDlczLayer:registerNotification()
	---增加服务器消息监听 ,只有增加了的命令，才会回调对应成功监听函数
	--self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_BankDeposit);
	RechargeDlczLayer.super.registerNotification(self);
end
--收到服务器处理成功通知函数
function RechargeDlczLayer:receiveServerResponseSuccessEvent(event)
    RechargeDlczLayer.super.receiveServerResponseSuccessEvent(self,event)
end
return RechargeDlczLayer