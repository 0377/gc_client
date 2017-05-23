local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local AvatarModifyLayer = class("AvatarModifyLayer",CustomBaseView)
function AvatarModifyLayer:ctor()
    local CCSLuaNode =  requireForGameLuaFile("AvatarModifyLayerCCS")
    self.csNode = CCSLuaNode:create().root;
    self:addChild(self.csNode);
    self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
    self:initView();
    local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "close_btn"), "ccui.Button");
    closeBtn:addClickEventListener(function()
    	self:removeSelf();
    end);
	local alertPanel = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"alert_panel"),"ccui.Widget");
	CustomHelper.addAlertAppearAnim(alertPanel);

	local closeBtnok = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "close_btn_ok"), "ccui.Button");
    closeBtnok:addClickEventListener(function()
    	self:removeSelf();
    end);
end
function AvatarModifyLayer:initView()
	local headListView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "head_list_view"), "ccui.ListView");
	headListView:setScrollBarEnabled(false);
	local defaultItemNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "default_item_node"), "ccui.Widget");
	local headPrefix = "hall_res/head_icon"
	local headNum = 10;
	local column = 5;
	headListView:removeAllItems();
	defaultItemNode:setVisible(false);
	self.allHeadPanels = {};
	for i=1,headNum do
		local tempRow = math.floor((i-1)/column);
		local tempColumn = math.floor((i-1)%column) + 1 
		local itemNode = headListView:getItem(tempRow);
		if itemNode == nil then
			--todo
			itemNode = defaultItemNode:clone();
			itemNode:setVisible(true);
			headListView:pushBackCustomItem(itemNode);
		end
		itemNode:setVisible(true);
		local headPanelName = string.format("head_panel_%d",tempColumn)
		local headPanel = tolua.cast(CustomHelper.seekNodeByName(itemNode,headPanelName), "ccui.Widget");
		if headPanel == nil  then
			--todo
		 	local defaultHeadPanel = tolua.cast(CustomHelper.seekNodeByName(itemNode,"head_panel_1"), "ccui.Widget");
		 	headPanel = defaultHeadPanel:clone();
			headPanel:setName(headPanelName);
			itemNode:addChild(headPanel)
		end
		headPanel:setAnchorPoint(cc.p(0.5,0.5))
		local itemNodeWidth = itemNode:getContentSize().width;
		local perWidth = itemNodeWidth/column;
		headPanel:setPosition(cc.p(itemNodeWidth * (tempColumn)/column - perWidth/2,headPanel:getPositionY()));
		headPanel.newHeadImageNameNum = i
		local headIconNode = tolua.cast(CustomHelper.seekNodeByName(headPanel, "head_icon_node"), "ccui.ImageView")
		local headPath = CustomHelper.getFullPath(string.format("hall_res/head_icon/%d.png",i));
		headIconNode:loadTexture(headPath)
		local selectedBtn = tolua.cast(CustomHelper.seekNodeByName(headPanel, "selected_btn"), "ccui.Button");
		selectedBtn:addClickEventListener(function()
			self:clickSelectedBtn(headPanel)
		end)
		print("headPanel.newHeadImageNameNum:",headPanel.newHeadImageNameNum,",my head icon Bun：",self.myPlayerInfo:getHeadIconNum())
		if headPanel.newHeadImageNameNum == self.myPlayerInfo:getHeadIconNum() then
			--todo
			print("1111---------------------:",i)
			selectedBtn:setEnabled(false);
		else
			selectedBtn:setEnabled(true);
		end
		table.insert(self.allHeadPanels,headPanel);
	end
end
function AvatarModifyLayer:clickSelectedBtn(selectedPanel)
	for i,v in ipairs(self.allHeadPanels) do
		local selectedBtn = tolua.cast(CustomHelper.seekNodeByName(v, "selected_btn"), "ccui.Button");
		selectedBtn:setEnabled(true)
		if v == selectedPanel then
			--todo
			selectedBtn:setEnabled(false)
		end
	end
	local newHeadImageName = selectedPanel.newHeadImageNameNum
	--发送消息
	local info = {};
	info.header_icon = newHeadImageName
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(HallMsgManager.MsgName.CS_ChangeHeaderIcon,info)
end
function AvatarModifyLayer:registerNotification()
	---增加服务器消息监听 ,只有增加了的命令，才会回调对应成功监听函数
	self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_ChangeHeaderIcon);
	SecondarySelectLayer.super.registerNotification(self);
end
--收到服务器处理成功通知函数
function AvatarModifyLayer:receiveServerResponseSuccessEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == HallMsgManager.MsgName.SC_ChangeHeaderIcon then
    	--todo
    	MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "头像修改成功！");
    	-- self:showPersonInfo()
    end
end
return AvatarModifyLayer;