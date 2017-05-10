local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local SecondarySelectLayer = class("SecondarySelectLayer",CustomBaseView);
function SecondarySelectLayer:ctor()
	print("SecondarySelectLayer:----")
	local csNodePath = cc.FileUtils:getInstance():fullPathForFilename("SecondarySelectLayerCCS.csb");
    self.csNode = cc.CSLoader:createNode(csNodePath);
    self:addChild(self.csNode);
    local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "closeBtn"), "ccui.Button");
    closeBtn:addClickEventListener(function(sender)
    	GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    	self:removeSelf();
    end);
    self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
    --快速开始按钮
    self.quickStartBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_quickStart"), "ccui.Button");
    self.quickStartBtn:addClickEventListener(function()
    	GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    	self:clickQuickStartBtn();
    end);
    SecondarySelectLayer.super.ctor(self);
	CustomHelper.addWholeScrennAnim(self)
end
function SecondarySelectLayer:onExit()
	for i,fullPath in ipairs(self.loadAramtureResTab) do
		ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(fullPath);
	end
	SecondarySelectLayer.super.onExit(self)
end
--快速开始按钮
function SecondarySelectLayer:clickQuickStartBtn()
	if self.selectedGameInfoTab then
		--todo
		local roomListTab = self.selectedGameInfoTab[HallGameConfig.SecondRoomKey];
		--调整方案：每次点击【快速开始】按钮，都默认匹配入场条件最小的房间。
		local readyEnterRoomTab = nil;
		for i,tempRoomInfoTab in ipairs(roomListTab) do
			local needMoneyLimit = tempRoomInfoTab[HallGameConfig.SecondRoomMinMoneyLimitKey]
			if readyEnterRoomTab == nil then
				--todo
				readyEnterRoomTab = tempRoomInfoTab
			elseif needMoneyLimit < readyEnterRoomTab[HallGameConfig.SecondRoomMinMoneyLimitKey] then
				--todo
				readyEnterRoomTab = tempRoomInfoTab;
			end
		end
		self:readyEnterOneGame(readyEnterRoomTab);
	end
end
--显示界面
function SecondarySelectLayer:showView(gameID)
	self.gameID = gameID;
	local gameBaseInfoTab = HallGameConfig.allGames[self.gameID]
	--显示游戏基本信息
	self.loadAramtureResTab = {};
	local allAramtureResInfoStr = gameBaseInfoTab[HallGameConfig.GameSecondEffectResKey];
	local allAramtureResInfoArray = string.split(allAramtureResInfoStr,"#");
	for i,aramtureResInfoStr in ipairs(allAramtureResInfoArray) do
		local fullPath = CustomHelper.getFullPath(aramtureResInfoStr)
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fullPath);
		table.insert(self.loadAramtureResTab,fullPath);
		-- print("fullPath:",fullPath)
	end
	--显示标题
	local titleView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "title_icon_view"), "ccui.ImageView");
	local titleResPath = CustomHelper.getFullPath(gameBaseInfoTab[HallGameConfig.GameSecondTitleResKey])
	titleView:ignoreContentAdaptWithSize(true);
	titleView:loadTexture(titleResPath);
	self.gameName = gameBaseInfoTab[HallGameConfig.GameNameKey] or "";

	local openGameTab = GameManager:getInstance():getHallManager():getHallDataManager():getAllOpenGamesDeatilTab()
	local tab = nil;
	if openGameTab then
		tab = openGameTab[self.gameID]
	end
	--清除上次的提示框
	if self.allGameClosedTipLayer then
		--todo
		self.allGameClosedTipLayer:removeSelf();
		self.allGameClosedTipLayer = nil;
	end
	if tab == nil or table.nums(tab) == 0 then
		--todo
		self.allGameClosedTipLayer = CustomHelper.showAlertView(
			self.gameName.."游戏升级维护中，请尝试其他游戏",
			false,
			true,
			function(tipLayer)
				-- body
				tipLayer:removeSelf();
				self.allGameClosedTipLayer = nil;
				self:removeSelf();
			end,
			function(tipLayer)
				-- body
				tipLayer:removeSelf();
				self.allGameClosedTipLayer = nil;
				self:removeSelf();
			end
		)
	end
	self.selectedGameInfoTab = tab;
	self.roomListData = {};
	if tab ~= nil then
		--todo
		self.roomListData = tab[HallGameConfig.SecondRoomKey];
		if  table.nums(self.roomListData) == 1 then
			local v = self.roomListData[1]
			self:readyEnterOneGame(v);
			self:removeSelf();
			return
		end
	end
	self:initRoomList()
end
function SecondarySelectLayer:initRoomList()
	local gameListView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "roomListView"), "ccui.ListView")
	gameListView:setVisible(false)
	local viewSize = gameListView:getContentSize()
	viewSize.height = viewSize.height
	self.maxSizeForTableView = viewSize;
	if self.tableView == nil then
		--todo
		self.tableView = cc.TableView:create(viewSize)
	    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
	    --self.tableView:setPosition(cc.p(self.size.width/2,self.size.height/2))
	    self.tableView:setDelegate()
		self.tableView:setPosition(cc.p(gameListView:getPositionX(),gameListView:getPositionY()))
	    gameListView:getParent():addChild(self.tableView,1)
	    self.tableView:registerScriptHandler(handler(self,self.scrollViewDidScroll),cc.SCROLLVIEW_SCRIPT_SCROLL)
	    self.tableView:registerScriptHandler(handler(self,self.scrollViewDidZoom),cc.SCROLLVIEW_SCRIPT_ZOOM)
	    self.tableView:registerScriptHandler(handler(self,self.tableCellTouched),cc.TABLECELL_TOUCHED)
	    self.tableView:registerScriptHandler(handler(self,self.cellSizeForTable),cc.TABLECELL_SIZE_FOR_INDEX)
	    self.tableView:registerScriptHandler(handler(self,self.tableCellAtIndex),cc.TABLECELL_SIZE_AT_INDEX)
	    self.tableView:registerScriptHandler(handler(self,self.numberOfCellsInTableView),cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
	end
   --刷新界面
    self:refreshRoomListTableView();
end
function SecondarySelectLayer:refreshRoomListTableView()
	local x,y = self:cellSizeForTable()
	local roomCount = self:numberOfCellsInTableView()
	local viewSize = self.maxSizeForTableView;
	if x*roomCount <= viewSize.width then
		self.tableView:setViewSize(cc.size(x*roomCount,viewSize.height))
		self.tableView:setPositionX((viewSize.width - x*roomCount )/2)
		self.tableView:setTouchEnabled(false)
	else
		self.tableView:setTouchEnabled(true)
	end
	
	self.tableView:reloadData()
end
function SecondarySelectLayer:numberOfCellsInTableView(view)
	return table.nums(self.roomListData) or 0
end

function SecondarySelectLayer:scrollViewDidScroll(view)

end

function SecondarySelectLayer:scrollViewDidZoom(view)

end

function SecondarySelectLayer:tableCellTouched(view,cell)
	print("tableCellTouched...",cell:getIdx())
	local gamenode = cell:getChildByName("Node")
	if gamenode and gamenode.selectNode then
		gamenode:selectNode()
	end
end
function SecondarySelectLayer:cellSizeForTable(view,idx)
	return 320,450
end
function SecondarySelectLayer:createItemIdx(view,idx)
	local SecondaryGameNodeClass = requireForGameLuaFile(self.selectedGameInfoTab[HallGameConfig.SecondRoomNodeClassNameKey])
	local itemNode = SecondaryGameNodeClass:create()
	local x,y = self:cellSizeForTable(view,idx)
	itemNode:setSwallowTouches(false)
	itemNode:setName("Node")
	itemNode:setAnchorPoint(cc.p(0.0,0.0))
	--itemNode:setPosition(cc.p(x/2,y/2))
	return itemNode
end
function SecondarySelectLayer:tableCellAtIndex(view,idx)
	
    local cell = view:dequeueCell()
	local ritem = nil
    if nil == cell then
        cell = cc.TableViewCell:new()
		ritem = self:createItemIdx(view,idx)		
		cell:addChild(ritem)	
    else
        ritem = cell:getChildByName("Node")
		
    end
	local roomData = self.roomListData[idx+1]
	if roomData and ritem and ritem.initViewData then
		ritem:initViewData(roomData,function()
			self:readyEnterOneGame(roomData)
		end,not view:isTouchEnabled())
	end
	ritem:setTag(idx)
	
    return cell
end
function SecondarySelectLayer:readyEnterOneGame(gameInfoTab)

	if GameManager:getInstance():getHallManager():getPlayerInfo():getFreezeAccount() == 1 then
		MyToastLayer.new(self, "账号已经被冻结,请联系客服")
		return
	end
	--判断是否正在其他游戏中
	if self:checkIsNeedAlertPreGameTip() == true then
		--todo
		print("self:checkIsNeedAlertPreGameTip() :true");
		self:dispatchCustomEvent("show_gaming_tip")
		return;
	end


--	dump(gameInfoTab, "gameInfoTab", nesting)
--	print("ready enter one game:",self.selectedGameInfoTab[HallGameConfig.GameNameKey],",room:",gameInfoTab[HallGameConfig.SecondRoomNameKey]);
	local needMoneyLimit = CustomHelper.tonumber(gameInfoTab[HallGameConfig.SecondRoomMinMoneyLimitKey])
	local needMoneyTipStr = string.format("金币不足,无法进入房间,需要金币:%s\n 是否充值", CustomHelper.moneyShowStyleNone(needMoneyLimit))

	local storyCallbackFunc = function(layer)
		layer:removeSelf();
		ViewManager.setForceAlertOneView(true);
		ViewManager.enterStoreLayer()
    end
   	local bankCallbackFunc = function(layer)
		layer:removeSelf();
		ViewManager.setForceAlertOneView(true);
		ViewManager.enterBankWithDrawLayer()
    end

    local cancallCallbackFunc = function(layer)
		layer:removeSelf()
    end
	if CustomHelper.showLackMoneyAlertView(needMoneyLimit,needMoneyTipStr,cancallCallbackFunc,bankCallbackFunc,storyCallbackFunc,cancallCallbackFunc) then

		return;
	end


	if self._isCanEnterGame ~=nil and self._isCanEnterGame == false then
		return;
	end
	self._isCanEnterGame = false;
	
	--禁用相关按钮
	self.quickStartBtn:setTouchEnabled(false)
    --self.roomListView:setTouchEnabled(false)
	--发送进入游戏消息
	local gameTypeID = self.selectedGameInfoTab[HallGameConfig.GameIDKey];
	local roomID = gameInfoTab[HallGameConfig.SecondRoomIDKey];
	CustomHelper.addIndicationTip(HallUtils:getDescriptionWithKey("entering_gamescene_tip"));
	GameManager:getInstance():getHallManager():getHallMsgManager():sendEnterOneGameMsg(gameTypeID,roomID);
end
function SecondarySelectLayer:checkIsNeedAlertPreGameTip()
	self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
    local gamingInfoTab = self.myPlayerInfo:getGamingInfoTab()
    if gamingInfoTab ~= nil then
        --todo
       return true;
   else
   	   return false;
   end
end
function SecondarySelectLayer:registerNotification()
	local dispatcher = cc.Director:getInstance():getEventDispatcher();
	---增加服务器消息监听 ,只有增加了的命令，才会回调对应成功监听函数
	self:addOneTCPMsgListener(HallMsgManager.MsgName.CS_ChangeGame);
	self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_EnterRoomAndSitDown)
	self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_GameMaintain)
		--监听游戏服务器列表消息通知
	self:addOneTCPMsgListener(HallMsgManager.MsgName.GC_GameServerCfg);
	SecondarySelectLayer.super.registerNotification(self);
end
-- --请求失败通知，网络连接状态变化
-- function SecondarySelectLayer:callbackWhenConnectionStatusChange(event)
--     local status = event.userInfo.status;
--     if status == NetworkManager.TCPConnectionStatus.TCPConnectionStatus_Close then
--     	self:setTouchEnabled(true)
--     end
--     SecondarySelectLayer.super.callbackWhenConnectionStatusChange(self,event);
-- end

--消息发送失败
function SecondarySelectLayer:receiveMsgRequestErrorEvent(event)
    self.quickStartBtn:setTouchEnabled(true)
	--self.roomListView:setTouchEnabled(true)
	self._isCanEnterGame = true;
   -- print("SecondarySelectLayer:receiveMsgRequestErrorEvent")
    SecondarySelectLayer.super.receiveMsgRequestErrorEvent(self,event)
end
function SecondarySelectLayer:receiveServerResponseErrorEvent(event)
    --print("SecondarySelectLayer:receiveServerResponseErrorEvent(event)")
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    self.quickStartBtn:setTouchEnabled(true)
	--self.roomListView:setTouchEnabled(true)
	self._isCanEnterGame = true;
    SecondarySelectLayer.super.receiveServerResponseErrorEvent(self,event)
end--收到服务器处理成功通知函数
function SecondarySelectLayer:receiveServerResponseSuccessEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == HallMsgManager.MsgName.SC_EnterRoomAndSitDown then
    	--todo
    	self._isCanEnterGame = true;
    	self.quickStartBtn:setTouchEnabled(true)
		--self.roomListView:setTouchEnabled(true)
	elseif msgName == HallMsgManager.MsgName.GC_GameServerCfg then
		--todo
		--刷新界面
		self:showView(self.gameID);
    end

    SecondarySelectLayer.super.receiveServerResponseSuccessEvent(self,event)
end
return SecondarySelectLayer;
