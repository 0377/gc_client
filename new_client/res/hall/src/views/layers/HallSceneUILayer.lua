local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local HallSceneUILayer = class("HallSceneUILayer",CustomBaseView);
local SettingLayer = requireForGameLuaFile("SettingLayer");
local FeedbackLayerNew = requireForGameLuaFile("FeedbackLayerNew");
local NoticeLayer = requireForGameLuaFile("NoticeLayer");
local MessageLayer = requireForGameLuaFile("MessageLayer");
local CustomServiceLayer = requireForGameLuaFile("CustomServiceLayer");
local HallGameNode = requireForGameLuaFile("HallGameNode");
local RechargeLayer = requireForGameLuaFile("RechargeLayer");
local ShopLayer = requireForGameLuaFile("ShopLayer");
local scheduler = cc.Director:getInstance():getScheduler()
function HallSceneUILayer.getNeedPreloadResArray()
	local resPathArray = {
		CustomHelper.getFullPath("hall_res/hall/bb_dating_beijing.jpg"),
		CustomHelper.getFullPath("hall_res/game_select/bb_fc_beijing.jpg"),
		CustomHelper.getFullPath("hall_res/hall/bb_dating_beijing.jpg"),
		CustomHelper.getFullPath("hall_res/bombbox/bb_sz_tck.png"),
		CustomHelper.getFullPath("hall_res/anim/d_gamehall_anieffects/d_gamehall_anieffects.ExportJson")
	}
	--得到开放游戏需要显示的图标
	local openGameTab = GameManager:getInstance():getHallManager():getHallDataManager():getAllOpenGamesDeatilTab()
	if openGameTab ~= nil then
		--todo
		--dump(openGameTab,"openGameTab", 20)
		for k,infoTab in pairs(openGameTab) do
				--todo
			table.insert(resPathArray,CustomHelper.getFullPath(infoTab[HallGameConfig.GameIconKey]));
		end
	end

	-- for k, v in pairs(HallGameConfig.game.IconAnimResConfig) do
 --        local fullPath = CustomHelper.getFullPath("anim/hall/" .. v[2]);
 --        table.insert(resPathArray,fullPath)
 --    end
	return resPathArray;
end
function HallSceneUILayer:ctor(hallScene)
	self.hallScene = hallScene;
	self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
    local CCSLuaNode =  requireForGameLuaFile("HallSceneCCS")
    self.csNode = CCSLuaNode:create().root;

    self:addChild(self.csNode);
    --快速开始按钮
	-- self.exitBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"exitBtn"), "ccui.Button");
	-- self.exitBtn:addClickEventListener(function(sender)
	-- 	self:clickExitBtn();
	-- end);
	self:onPreload();
	--初始化界面
	self:initView();
	HallSceneUILayer.super.ctor(self);

	if self.marqueeText == nil then
		--todo
		self.marqueeText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "marquee_text"), "ccui.Text");
	end
	self.marqueeText:setString("")
	self.marqueePanel = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "panel_marquee"), "ccui.Widget");
	self.marqueePanel:setOpacity(0);
	self:showMarqueeTip();
end
--用于在场景初始化时预加载资源
function HallSceneUILayer:onPreload()
    -- Hall.super.onPreload(self)
    -- dump(HallGameConfig.game.IconAnimResConfig, "HallGameConfig.game.IconAnimResConfig", nesting)
    -- local needLoadResArray = HallSceneUILayer.getNeedPreloadResArray();
    -- for i,v in ipairs(needLoadResArray) do
    -- 	if string.find(v,".ExportJson") then
    -- 		--todo
    -- 		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(v);
    -- 	end
    -- end
end

function HallSceneUILayer:onEnter()
    self:addCustomEventListener("kNotifyName_RefreshMessageReaded", handler(self, self._onEvent_refreshMessageReaded))
    self:addCustomEventListener("kNotifyName_RefreshFeedbackReaded", handler(self, self._onEvent_refreshFeedbackReaded))

	local FeedbackHelper = requireForGameLuaFile("FeedbackHelper")
	FeedbackHelper.queryFeedbackStatus()


	self:_onEvent_refreshMessageReaded()



end

function HallSceneUILayer:onExit()
    self:removeAllEventListeners()

    print("HallSceneUILayer:onExit()")
    local needLoadResArray = HallSceneUILayer.getNeedPreloadResArray();
    for i,v in ipairs(needLoadResArray) do
    	if string.find(v,".ExportJson") then
    		--todo
    		 ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(v);
    	end
    end
	if self.checklistenner then
		 self:getEventDispatcher():removeEventListener(self.checklistenner)
	end
	
    HallSceneUILayer.super.onExit(self)
end
--退出游戏
function HallSceneUILayer:callbackWhenClickExitBtn()
	self.hallScene:exitScene();
end
function HallSceneUILayer:initView()
	
	--初始化按钮
	self:initBtns()

	--显示游戏底部信息
	self:showButtomView();
	--显示服务器列表
	--self:initHallGameListView();
	self:initHllGameTableView()

    self:_onEvent_refreshMessageReaded()
    self:_onEvent_refreshFeedbackReaded()
end
function HallSceneUILayer:showButtomView()
	if self.headIconView == nil then
		--todo
		self.headIconView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "head_icon"), "ccui.ImageView");
		-- self.headIconView:ignoreContentAdaptWithSize(true);
	end
	self.headIconView:loadTexture(self.myPlayerInfo:getSquareHeadIconPath());
	--显示玩家id
	if self.playerIdText == nil then
		--todo
		self.playerIdText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "player_id_text"), "ccui.Text");
		self.playerIdText:setFontName("Helvetica")
	end
	self.playerIdText:setString("ID:"..self.myPlayerInfo:getGuid())
	--昵称
	if self.playerNickNameText == nil then
		--todo
		self.playerNickNameText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "nickname_text"),"ccui.Text");
		self.playerNickNameText:setFontName("Helvetica")
	end
	self.playerNickNameText:setString(self.myPlayerInfo:getNickName())
	--金币
	if self.moneyText == nil then
		--todo
		self.moneyText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "money_text"), "ccui.TextAtlas");
	end
	local moneyStr = CustomHelper.moneyShowStyleNone(self.myPlayerInfo:getMoney());
	moneyStr = string.gsub(moneyStr, "%.", "/")
	self.moneyText:setString(moneyStr)
	--银行存款
	if self.bankMoneyText == nil then
		--todo
		self.bankMoneyText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "bank_money_text"), "ccui.TextAtlas");
	end
	local bankMoneyStr = CustomHelper.moneyShowStyleNone(self.myPlayerInfo:getBank());
	bankMoneyStr = string.gsub(bankMoneyStr, "%.", "/")
	self.bankMoneyText:setString(bankMoneyStr)
	--
end
function HallSceneUILayer:initBtns()
	--账号按钮事件
	local accountBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_account"), "ccui.Button");
	accountBtn:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		ViewManager.enterPlayerAccountInfoLayer();
	end);
	


	local bankCenterBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "bank_center_btn"), "ccui.Button");
	bankCenterBtn:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		ViewManager.enterBankDepositLayer()
	end);
	--返回大厅游戏按钮
	self.rightBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_right"), "ccui.Button");
	self.rightBtn:addClickEventListener(handler(self,self._handlePageButton))
	self.rightBtn:setVisible(false)
	--更多游戏按钮
	self.leftBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_left"), "ccui.Button");
	self.leftBtn:addClickEventListener(handler(self,self._handlePageButton))
	self.leftBtn:setVisible(false)
	
	--更多功能按钮
	self.moreFunctionPanel = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "more_function_panel"),"ccui.Button");
	self.moreFunctionPanel:setVisible(false);
	self.moreFunctionBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "more_function_btn"),"ccui.Button");
	local closeMorePanelBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "close_more_panel_btn"), "ccui.Button");
	self.moreFunctionBtn:addClickEventListener(function(sender)
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		self.moreFunctionPanel:setVisible(not self.moreFunctionPanel:isVisible())
		closeMorePanelBtn:setVisible(self.moreFunctionPanel:isVisible())
	end);	
	closeMorePanelBtn:addClickEventListener(function()
		self.moreFunctionPanel:setVisible(false);
		closeMorePanelBtn:setVisible(false)
	end);
	--
	local settingBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"setting_btn"), "ccui.Button");
	settingBtn:addClickEventListener(function(sender)
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        ViewManager.enterOneLayerWithClassName("SettingLayer")
	end);
	local personalBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "personal_btn"), "ccui.Button");
	personalBtn:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		ViewManager.enterPersonalInfoLayer()
	end);

	-- 反馈按钮
	local btn_feedback = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_feedback"), "ccui.Button");
	btn_feedback:addClickEventListener(function(sender)
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        ViewManager.enterOneLayerWithClassName("FeedbackLayerNew")
	end);
    self.btn_feedback = btn_feedback

    local btn_custom_service = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_custom_service"), "ccui.Button");
    btn_custom_service:addClickEventListener(function(sender)
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        ViewManager:enterCustomServiceLayer()
    end);
    btn_custom_service:setVisible(false)

    -- 公告按钮
    local btn_notice = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_notice"), "ccui.Button");
    btn_notice:addClickEventListener(function(sender)
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        ViewManager.enterOneLayerWithClassName("NoticeLayer")
    end);
    self.btn_notice = btn_notice

    -- 消息按钮
    local btn_message = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_message"), "ccui.Button");
    btn_message:addClickEventListener(function(sender)
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        ViewManager.enterOneLayerWithClassName("MessageLayer")
    end);
    self.btn_message = btn_message
	  -- 商城按钮
    local btn_store = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_store"), "ccui.Button");
    btn_store:addClickEventListener(function(sender)
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        ViewManager.enterStoreLayer();
    end);

    local amartureNode = btn_store:getChildByName("eff_99yl_ui_loading")
    -- amartureNode:init("d_gamehall_anieffects")
    amartureNode:getAnimation():play("ani_03")
    -- amartureNode:getAnimation():setMovementEventCallFunc(function(sender, type)
    --     if type == ccs.MovementEventType.complete then
    --         print("[HallSceneUILayer] ccs.MovementEventType.complete")
    --     end
    -- end)
	
    --绑定有奖
    self.bindRewardTipBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_kaifu"), "ccui.Button");

    amartureKaiFuNode = self.bindRewardTipBtn:getChildByName("eff_99yl_ui_loading")
    -- amartureNode:init("d_gamehall_anieffects")
    amartureKaiFuNode:getAnimation():play("ani_02")
	
    self.bindRewardTipBtn:addClickEventListener(function()
    	ViewManager.alertAccountBindTipLayer()
    end)
    --绑定了话，就不用显示了
	if self.myPlayerInfo:getIsGuest() == false then
    	--todo
    	self.bindRewardTipBtn:setVisible(false)
	end


	local node_gold = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "node_gold"),"ccui.ImageView");
	local node_baoxianxiang = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "node_baoxianxiang"),"ccui.ImageView");
	local btn_addGold = node_gold:getChildByName("btn")
	local btn_add = node_baoxianxiang:getChildByName("btn")

	btn_addGold:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		ViewManager.enterStoreLayer();
	end)
	btn_add:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		ViewManager.enterStoreLayer();
	end)
	


	--苹果审核状态 账户按钮/开户按钮 /兑换按钮不显示
	if CustomHelper.isExaminState() then
		accountBtn:setVisible(false)
		self.bindRewardTipBtn:setVisible(false)
		btn_custom_service:setVisible(false)
		--隐私条款
		local  btn_privacy = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_privacy"),"ccui.Button");
		btn_privacy:setVisible(true)
		btn_privacy:addClickEventListener(function()
			GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
			ViewManager.alertPrivacyLayer();
		end)

	end

	self:showBtnsIsVisibleByConfig();
	
end
function HallSceneUILayer:showBtnsIsVisibleByConfig()
	--得到大厅开放的开关
	--底部按钮
	local hallBtnsConfig = CustomHelper.getOneHallGameConfigValueWithKey("hall_ui_btns_config")
	--dump(hallBtnsConfig, "hallBtnsConfig")
	--得到显示按钮数量
	local mainBtnsNum = 0;
	local needShowBtnArray = {}
	for i,v in ipairs(hallBtnsConfig) do
		for btnName,visible in pairs(v) do
			-- 去掉btn_custom_service，改代码的原因是此功能去掉了，比改N多配置简单
			if btnName == "btn_custom_service" then
				visible = false
			end
			local tempBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, btnName), "ccui.Button");
				if tempBtn then
					--todo
					if visible then
					--todo
					if tempBtn:isVisible() then
						--todo
						table.insert(needShowBtnArray,tempBtn);
						mainBtnsNum = mainBtnsNum + 1;
					end
				else
					tempBtn:setVisible(false);
				end
			end
		end
	end
	self.buttomBtnPanel = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "buttom_btn_panel"), "ccui.Widget");	
	self.moreFunctionBtn:setVisible(false);
	local buttomBtnNum = 6;
	local btnSpace = self.buttomBtnPanel:getContentSize().width / math.min(buttomBtnNum,mainBtnsNum)
	if mainBtnsNum > buttomBtnNum then --需要显示更多按钮
		--todo
		--插入更多按钮
		mainBtnsNum = mainBtnsNum + 1
		table.insert(needShowBtnArray,6,self.moreFunctionBtn)
		self.moreFunctionBtn:setVisible(true);
		--self.buttomBtnPanel:setContentSize(cc.size(0,self.buttomBtnPanel:getContentSize().height));
		for i=1,buttomBtnNum do
			local tempBtn = needShowBtnArray[i];
			tempBtn:retain();
			tempBtn:removeFromParent();
			self.buttomBtnPanel:addChild(tempBtn);
			tempBtn:setAnchorPoint(cc.p(0.5,0.5));
			local lightSp = display.newSprite("hall_res/hall/bb_dating_diguang.png")
			lightSp:addTo(tempBtn)
			lightSp:setPosition(cc.p(tempBtn:getContentSize().width/2,23))
			local lineSp = display.newSprite("hall_res/hall/bb_dating_shuxian.png")
			lineSp:addTo(self.buttomBtnPanel)
			local lineSize = lineSp:getContentSize()
			local lightSize = lightSp:getContentSize()
			lineSp:setPosition(cc.p(btnSpace*(i-1),lineSize.height/2))
			
			local posX = self.buttomBtnPanel:getContentSize().width + tempBtn:getContentSize().width/2

			posX = btnSpace *(i-0.5)
			tempBtn:setPosition(cc.p(posX,self.buttomBtnPanel:getContentSize().height/2))
			--self.buttomBtnPanel:setContentSize(cc.size(posX + tempBtn:getContentSize().width/2,self.buttomBtnPanel:getContentSize().height));			
			tempBtn:release()
		end
		self.moreFunctionPanel:setAnchorPoint(cc.p(1,0.5));
		local moreFPWidth = btnSpace*(mainBtnsNum - buttomBtnNum)
		self.moreFunctionPanel:setSize(cc.size(moreFPWidth,self.moreFunctionPanel:getContentSize().height));
		local startIndex = buttomBtnNum + 1
		for i= startIndex,mainBtnsNum do
			local tempBtn = needShowBtnArray[i];
			tempBtn:retain();
			tempBtn:removeFromParent();
			self.moreFunctionPanel:addChild(tempBtn);
			tempBtn:setAnchorPoint(cc.p(0.5,0.5));
			local posX = self.moreFunctionPanel:getContentSize().width + tempBtn:getContentSize().width/2
			if i ~= startIndex then
				--posX = posX + btnSpace
			end
			posX = btnSpace *(i - startIndex +0.5)
			tempBtn:setPosition(cc.p(posX,self.moreFunctionPanel:getContentSize().height/2))
			--self.moreFunctionPanel:setContentSize(cc.size(posX + tempBtn:getContentSize().width/2,self.moreFunctionPanel:getContentSize().height));
			tempBtn:release()
		end
		--右边与 self.buttomBtnPanel 对齐
		local buttomBtnPaneRight = self.buttomBtnPanel:getPositionX() + (1 - self.buttomBtnPanel:getAnchorPoint().x) *  self.buttomBtnPanel:getContentSize().width
		self.moreFunctionPanel:setAnchorPoint(cc.p(1,self.moreFunctionPanel:getAnchorPoint().y))
		self.moreFunctionPanel:setPosition(cc.p(buttomBtnPaneRight,self.moreFunctionPanel:getPositionY()))
	else -- 不需要显示更多按钮
		--self.buttomBtnPanel:setContentSize(cc.size(0,self.buttomBtnPanel:getContentSize().height));
		for i,tempBtn in ipairs(needShowBtnArray) do
			local tempBtn = needShowBtnArray[i];
			tempBtn:retain();
			tempBtn:removeFromParent();
			self.buttomBtnPanel:addChild(tempBtn);
			tempBtn:setAnchorPoint(cc.p(0.5,0.5));

			-- local lightSp = display.newSprite("hall_res/hall/bb_dating_diguang.png")
			-- lightSp:addTo(tempBtn)
			-- lightSp:setPosition(cc.p(tempBtn:getContentSize().width/2,23))
			-- local lineSp = display.newSprite("hall_res/hall/bb_dating_shuxian.png")
			-- lineSp:addTo(self.buttomBtnPanel)
			-- local lineSize = lineSp:getContentSize()
			-- local lightSize = lightSp:getContentSize()
			-- lineSp:setPosition(cc.p(btnSpace*(i-1),lineSize.height/2))
			
			local posX = self.buttomBtnPanel:getContentSize().width + tempBtn:getContentSize().width/2

			posX = btnSpace *(i-0.5)
			print(posX)
			tempBtn:setPosition(cc.p(posX,self.buttomBtnPanel:getContentSize().height/2))
			---self.buttomBtnPanel:setContentSize(cc.size(posX + tempBtn:getContentSize().width/2,self.buttomBtnPanel:getContentSize().height));			
			tempBtn:release()
		end
	end
	--更新其他单独的按钮 hall_ui_other_btns_config
	local otherBtnVisibleConfig = CustomHelper.getOneHallGameConfigValueWithKey("hall_ui_other_btns_config") 
	for btnName,visible in pairs(otherBtnVisibleConfig) do
		local tempBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, btnName), "ccui.Button");
		if tempBtn and tempBtn:isVisible() then
			--todo
			tempBtn:setVisible(visible)
		end
	end
end
--处理换页的按钮事件
function HallSceneUILayer:_handlePageButton(sender)
	if not sender then
		return
	end
	GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)

	local innerSize = self.tableView:getContainer():getContentSize()
	local innerPos = self.tableView:getContentOffset()
	local viewSize = self.tableView:getViewSize()
	if innerSize.width <= viewSize.width then
		return
	end
	
	local diffWidth = innerPos.x

	self.leftBtn:setVisible(true)
	self.rightBtn:setVisible(true)
	if sender:getName() == "Button_left" then
		innerPos.x  = innerPos.x + 4*self.gameItemWidth 
	elseif sender:getName() == "Button_right" then
		innerPos.x  = innerPos.x - 4*self.gameItemWidth 
	end
	innerPos.x = math.min(innerPos.x,0)
	innerPos.x = math.max(innerPos.x,-(innerSize.width - viewSize.width))
	self.tableView:setContentOffset(innerPos,true)
end
function HallSceneUILayer:initHllGameTableView()
	local gameListParentNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "game_list_parent"), "ccui.Widget");
	local viewSize = gameListParentNode:getContentSize()
	viewSize.height = viewSize.height
	self.maxSizeForTableView = viewSize

	self.defaultGameItemNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "defaultGameItem"), "ccui.Layout");
	self.defaultGameItemNode:setVisible(false);
	self.gameItemWidth = self.defaultGameItemNode:getContentSize().width
		--todo
	self.tableView = cc.TableView:create(viewSize)
    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    --self.tableView:setPosition(cc.p(self.size.width/2,self.size.height/2))
    self.tableView:setDelegate()
    gameListParentNode:addChild(self.tableView,1)
    self.tableView:setPosition(cc.p(0,0))
    self.tableView:registerScriptHandler(handler(self,HallSceneUILayer.scrollViewDidScroll),cc.SCROLLVIEW_SCRIPT_SCROLL)
    self.tableView:registerScriptHandler(handler(self,HallSceneUILayer.scrollViewDidZoom),cc.SCROLLVIEW_SCRIPT_ZOOM)
    self.tableView:registerScriptHandler(handler(self,HallSceneUILayer.tableCellTouched),cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(handler(self,HallSceneUILayer.cellSizeForTable),cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(handler(self,HallSceneUILayer.tableCellAtIndex),cc.TABLECELL_SIZE_AT_INDEX)
    self.tableView:registerScriptHandler(handler(self,HallSceneUILayer.numberOfCellsInTableView),cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
	--显示tableview数据
    self:refreshTableView();
	--这里设置触摸监听，主要监听在触摸tableview结束后，处理回弹功能
	if not self.checklistenner then
		local eventDispatcher = self:getEventDispatcher()  
		self.checklistenner = cc.EventListenerTouchOneByOne:create()  
		self.checklistenner:registerScriptHandler(handler(self,self._touchBegin), cc.Handler.EVENT_TOUCH_BEGAN )  
		self.checklistenner:registerScriptHandler(handler(self,self._touchEnd), cc.Handler.EVENT_TOUCH_ENDED )    
		eventDispatcher:addEventListenerWithFixedPriority(self.checklistenner, -1)
	end
end
--刷新显示tableview
function HallSceneUILayer:refreshTableView()
	--游戏开放列表
	local openGameTab = GameManager:getInstance():getHallManager():getHallDataManager():getAllOpenGamesDeatilTab()
	local orderGameTab = HallGameConfig.gameOrderList
	--遍历生成
	--dump(openGameTab, "openGameTab", 100)
	self.gameDatas = {}
	local gameOrderNum = 0
	if openGameTab ~= nil then
		--todo
		for i,v in ipairs(orderGameTab) do
			local infoTab = openGameTab[v];
			if infoTab then
				--todo
				infoTab[HallGameConfig.GameIDKey] = v;
				gameOrderNum = gameOrderNum+1
				table.insert(self.gameDatas,infoTab)
			end
		end
	end
	self.gameNum = gameOrderNum
	----如果小于3个就放在中间
	local x,y = self:cellSizeForTable()
	local viewSize = self.maxSizeForTableView
	
	--这里如果游戏图标长度小于UI尺寸的宽度，就不让滑动
	if x*gameOrderNum <= viewSize.width then
		self.tableView:setViewSize(cc.size(x*gameOrderNum,viewSize.height))
		self.tableView:setPositionX((viewSize.width - x*gameOrderNum )/2)
		self.tableView:setTouchEnabled(false)
	else
		self.rightBtn:setVisible(true)
		self.leftBtn:setVisible(false)
		self.tableView:setTouchEnabled(true)
	end
	self.tableView:reloadData()
	--其他控件的渲染顺序需要重新设置了
	-- tolua.cast(CustomHelper.seekNodeByName(self.csNode, "panel_Bottom"),"ccui.Widget"):setLocalZOrder(2)
	-- self.rightBtn:setLocalZOrder(2)
	-- self.leftBtn:setLocalZOrder(2)
end
function HallSceneUILayer:_touchBegin(touch, event)
	local location = touch:getLocation() 
	if not self.tableView then
		return false
	end
	local viewSize = self.tableView:getViewSize()
	local tablePos = self.tableView:convertToWorldSpace(cc.p(0,0))
	local rect = cc.rect(tablePos.x,tablePos.y,viewSize.width,viewSize.height)
	--只处理在tableview中的触摸
	if cc.rectContainsPoint(rect,location) then
		self.tableView:stopActionByTag(9999)
		return true
	else
		return false
	end
end
function HallSceneUILayer:_touchEnd(touch,event)
	local cellAction = cc.Sequence:create(cc.DelayTime:create(1.0),cc.CallFunc:create(handler(self,self._checkCellPos)))
	cellAction:setTag(9999)
	self.tableView:runAction(cellAction)
end
--检测并且回弹tableview的位置 保证一个游戏图标完全显示
function HallSceneUILayer:_checkCellPos()

	local innerSize = self.tableView:getContainer():getContentSize()
	local innerPos = self.tableView:getContentOffset()
	local viewSize = self.tableView:getViewSize()
	if innerSize.width <= viewSize.width then
		return
	end
	local diffWidth = innerPos.x
	local diff = math.floor(innerPos.x) % math.floor(self.gameItemWidth)
	if math.abs(diff) >= self.gameItemWidth/2 then
		innerPos.x = innerPos.x + self.gameItemWidth - diff
	else
		
		innerPos.x = innerPos.x - diff
	end
	
	innerPos.x = math.min(innerPos.x,0)
	innerPos.x = math.max(innerPos.x,-(innerSize.width - viewSize.width))
	self.tableView:setContentOffset(innerPos,true)

end


function HallSceneUILayer:numberOfCellsInTableView(view)
	return self.gameNum or 0
end

function HallSceneUILayer:scrollViewDidScroll(view)
	local innerSize = self.tableView:getContainer():getContentSize()
	local innerPos = self.tableView:getContentOffset()
	local viewSize = self.tableView:getViewSize()

	if innerSize.width>viewSize.width then
		self.rightBtn:setVisible(true)
		self.leftBtn:setVisible(true)
		if innerPos.x >=0 then
			self.leftBtn:setVisible(false)
		elseif innerPos.x <= - (innerSize.width - viewSize.width) then
			self.rightBtn:setVisible(false)
		end
	end	
end

function HallSceneUILayer:scrollViewDidZoom(view)

end
function HallSceneUILayer:tableCellTouched(view,cell)
	-- print("tableCellTouched...",cell:getIdx())
	-- local gamenode = cell:getChildByName("HallGameNode")
	-- if gamenode and gamenode.touchGameNode then

	-- 	gamenode:touchGameNode()
	-- end
end
function HallSceneUILayer:cellSizeForTable(view,idx)
	return self.defaultGameItemNode:getContentSize().width,self.defaultGameItemNode:getContentSize().height
end
function HallSceneUILayer:createItemIdx(view,idx)
	local csNode = self.defaultGameItemNode:clone()
	csNode:setName("ItemNode"..tostring(idx))
	csNode:setVisible(true)
	local itemNode = HallGameNode:create(csNode,self.gameDatas[idx+1])
	local x,y = self:cellSizeForTable(view,idx)
	itemNode:setSwallowTouches(false)
	itemNode:setName("HallGameNode")
	itemNode:setAnchorPoint(cc.p(0.5,0.5))
	itemNode:setPosition(cc.p(x/2,y/2))
	return itemNode
end
function HallSceneUILayer:tableCellAtIndex(view,idx)
    local cell = view:dequeueCell()
	local ritem = nil
    if nil == cell then
        cell = cc.TableViewCell:new()
		ritem = self:createItemIdx(view,idx)		
		cell:addChild(ritem)	
    else
        ritem = cell:getChildByName("HallGameNode")
    end
	local gamedata = self.gameDatas[idx+1]
	if gamedata then
		ritem:showInfoWithOneGameItemNode(gamedata)
		ritem.selectBtn:addTouchEventListener(
			function(sender,event)
				if event == ccui.TouchEventType.ended then
					--todo
					if self.tableView:isTouchMoved() then
						--todo
						return;
					end
					ritem:touchGameNode()
				end
			end
		)
	end
	ritem:setVisible(true)
    return cell
end
--显示跑马灯动画
function HallSceneUILayer:showMarqueeTip()
	local marqueeInfo = GameManager:getInstance():getHallManager():getHallDataManager():getNextNeedShowMarqueeInfo();
	if self.isShowingMarquee == true or marqueeInfo == nil then
		--todo
		return;
	end
	local marqueeTipStr = marqueeInfo.content;
	marqueeTipStr = CustomHelper.decodeURI(marqueeTipStr)
	self.isShowingMarquee = true
	if marqueeTipStr == nil then
		--todo
		return;
	end

	-- dump(self.marqueeText, "self.marqueeText", nesting)
	if marqueeTipStr then
		--todo
		self.marqueePanel:runAction(
			cc.Sequence:create(
				cc.FadeIn:create(0.5),
				cc.CallFunc:create(
					function()
						self.marqueeText:setString(marqueeTipStr);
						local clipperWidth = self.marqueeText:getParent():getContentSize().width
						local marqueeTextWidth = self.marqueeText:getContentSize().width
						local needMoveWidth = marqueeTextWidth + clipperWidth;
						self.marqueeText:setPosition(cc.p(clipperWidth,self.marqueeText:getPositionY()));
						self.marqueeText:stopAllActions();
						local speed = 80.0;
						local time = needMoveWidth/speed;
						local seq = cc.Sequence:create(
							cc.MoveTo:create(time,cc.p(-marqueeTextWidth,self.marqueeText:getPositionY())),
							cc.CallFunc:create(function()
								GameManager:getInstance():getHallManager():getHallDataManager():callbackWhenOneMarqueeShowFinished(marqueeInfo)
								local marqueeInfo = GameManager:getInstance():getHallManager():getHallDataManager():getNextNeedShowMarqueeInfo();
								--dump(marqueeInfo, "marqueeInfo", nesting)
								if marqueeInfo == nil then
									--todo
									self.marqueePanel:runAction(cc.FadeOut:create(0.5))
								end
								self.isShowingMarquee = false
							end)
							);
						self.marqueeText:runAction(seq)	
					end
				)
			)
		)	

	end
end

function HallSceneUILayer:showNoticeTip(event)
	if event and event.userInfo then
		-- 	HallDataManager.NOTICE_TYPE = 
-- {
-- 	HALL_NOTICE = 2,-- 2大厅公告
-- 	HORSE_RACE_LAMP = 3, -- 3跑马灯
-- 	GLOBAL_NOTICE = 4,-- 4全服公告
-- 	GAME_NOTICE = 5,-- 5游戏房间公告
-- 	DAY_NOTICE = 6,-- 6每日公告
-- }
		local HallDataManager = GameManager:getInstance():getHallManager():getHallDataManager();
		if event.userInfo._Content.content_type and tonumber(event.userInfo._Content.content_type) == HallDataManager.NOTICE_TYPE.HALL_NOTICE 
		or tonumber(event.userInfo._Content.content_type) == HallDataManager.NOTICE_TYPE.GLOBAL_NOTICE or tonumber(event.userInfo._Content.content_type) == HallDataManager.NOTICE_TYPE.DAY_NOTICE then
			ViewManager.showNotice(event.userInfo)
		end
	end
end

function HallSceneUILayer:_onEvent_refreshMessageReaded()
    self:updateUnreadDotVisible()
end

function HallSceneUILayer:_onEvent_refreshFeedbackReaded()
    self:updateUnreadDotVisible()
end

local function updateReadPoint(icon_point, count)
    icon_point:setVisible(count > 0)

    local labelCount = icon_point:getChildByName("label_count")
    labelCount:setString(count < 99 and count or 99)
    labelCount:setPosition(icon_point:getContentSize().width / 2, icon_point:getContentSize().height / 2)
end

function HallSceneUILayer:updateUnreadDotVisible()
    local playInfo = GameManager:getInstance():getHallManager():getPlayerInfo()

    local messageInfo = playInfo:getMessageInfo()
    local feedbackInfo = playInfo:getFeedbackInfo()

    local countMessage = messageInfo:getUnreadMessageCountBytype(messageInfo.MSG_TYPE.MESSAGE)
    local countNotice = messageInfo:getUnreadMessageCountBytype(messageInfo.MSG_TYPE.NOTICE)
    local countFeedback = feedbackInfo:getUnreadMessageCount()

    updateReadPoint(self.btn_notice:getChildByName("icon_point"), countNotice)
    updateReadPoint(self.btn_message:getChildByName("icon_point"), countMessage)
    updateReadPoint(self.btn_feedback:getChildByName("icon_point"), countFeedback)
    updateReadPoint(self.moreFunctionBtn:getChildByName("icon_point"), countNotice)
end

--注册监听通知
function HallSceneUILayer:registerNotification()
	--监听游戏服务器列表消息通知
	self:addOneTCPMsgListener(HallMsgManager.MsgName.GC_GameServerCfg);
	self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_FreezeAccount);
    HallSceneUILayer.super.registerNotification(self);
    local marqueeShowListener =  cc.EventListenerCustom:create(HallMsgManager.kNotifyName_NeedShowMarqueeInfo,function(event) 
       self:showMarqueeTip()
    end);
   	local noticeShowListener =  cc.EventListenerCustom:create(HallMsgManager.kNotifyName_NeedShowNotice,function(event) 
       self:showNoticeTip(event)
    end);
   	local noticeShowBtns = cc.EventListenerCustom:create(HallMsgManager.kNotifyName_RefreshConstConifg,function(event)
   		print("0----------------0")
   		self:showBtnsIsVisibleByConfig()
   	end)
    self.eventDispatcher:addEventListenerWithSceneGraphPriority(marqueeShowListener,self);
    self.eventDispatcher:addEventListenerWithSceneGraphPriority(noticeShowListener,self);
	self.eventDispatcher:addEventListenerWithSceneGraphPriority(noticeShowBtns,self);
end
--收到服务器处理成功通知函数
function HallSceneUILayer:receiveServerResponseSuccessEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    print("HallSceneUILayer_msgName:")
    if msgName ==  HallMsgManager.MsgName.GC_GameServerCfg then
    	--todo
    	--刷新服务器列表
    	self:refreshTableView();
    end
end
--刷新用户信息通知处理
function HallSceneUILayer:receiveRefreshPlayerInfoNotify()
	self:showButtomView();
	    --绑定了话，就不用显示了
	if self.myPlayerInfo:getIsGuest() == false then
    	--todo
    	self.bindRewardTipBtn:setVisible(false)
    end
end

return HallSceneUILayer;