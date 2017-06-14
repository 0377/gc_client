requireForGameLuaFile("BrnnConfig")
requireForGameLuaFile("NNPoker")
--local BrnnGameEnd = requireForGameLuaFile("BrnnGameEnd");
local SubGameBaseScene = requireForGameLuaFile("SubGameBaseScene")
local BrnnGameScene = class("BrnnGameScene",SubGameBaseScene);
local scheduler = cc.Director:getInstance():getScheduler()

----注册消息
function BrnnGameScene:registerNotification()
    self:addOneTCPMsgListener(BrnnGameManager.MsgName.SC_OxPlayerConnection);
    self:addOneTCPMsgListener(BrnnGameManager.MsgName.SC_OxTableInfo);
    self:addOneTCPMsgListener(BrnnGameManager.MsgName.SC_OxPlayerList);
    self:addOneTCPMsgListener(BrnnGameManager.MsgName.SC_OxSatusAndDownTime);
    self:addOneTCPMsgListener(BrnnGameManager.MsgName.SC_OxAddScore);
    self:addOneTCPMsgListener(BrnnGameManager.MsgName.SC_OxEveryArea);
    self:addOneTCPMsgListener(BrnnGameManager.MsgName.SC_OxDealCard);
    self:addOneTCPMsgListener(BrnnGameManager.MsgName.SC_OxBankerList);
    self:addOneTCPMsgListener(BrnnGameManager.MsgName.SC_OxBankerInfo);
    self:addOneTCPMsgListener(BrnnGameManager.MsgName.SC_OxRecord);
    self:addOneTCPMsgListener(BrnnGameManager.MsgName.SC_OxForBankerFlag);
    self:addOneTCPMsgListener(BrnnGameManager.MsgName.SC_OxBankerLeaveFlag)
    self:addOneTCPMsgListener(BrnnGameManager.MsgName.SC_OxResult)
    self:addOneTCPMsgListener(BrnnGameManager.MsgName.SC_OxBetCoin)
    self:addOneTCPMsgListener(BrnnGameManager.MsgName.SC_Ox_config_info)
    self.super.registerNotification(self);
    -----
end



local myPlayTime = {}
function BrnnGameScene:playsound(sound,deltime)
	if deltime == nil then
		deltime = 0.2
	end
	
	local time = socket.gettime()
	if myPlayTime[sound] == nil then
		MusicAndSoundManager:getInstance():playerSoundWithFile(sound)
		myPlayTime[sound] = {}
		myPlayTime[sound].time = time
		myPlayTime[sound].count = 1
	else
		if myPlayTime[sound].count <= 5 then
			MusicAndSoundManager:getInstance():playerSoundWithFile(sound)
			myPlayTime[sound].count = myPlayTime[sound].count + 1
			myPlayTime[sound].time = time
		else
			if time-myPlayTime[sound].time >= deltime then
				MusicAndSoundManager:getInstance():playerSoundWithFile(sound)
				myPlayTime[sound].time = time
				myPlayTime[sound].count = 0
			else
				
			end
		end
		
		
	end
	
	
end

----结束消息
function BrnnGameScene:receiveServerResponseSuccessEvent(event)

    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == BrnnGameManager.MsgName.SC_OxPlayerConnection then --成功收到demo命令

        self:updateMyInfo();

    elseif msgName == BrnnGameManager.MsgName.SC_OxTableInfo then ---桌面消息

		print("----------------gamestate:"..self.brnnGameManager:getDataManager():getGameStates())


        ---刷新筹码
        self:setInitChioseAllPoints(self.brnnGameManager:getDataManager():getGameChipInfo())

        -- local _tempCountdown = tonumber(self.brnnGameManager:getDataManager():getGameDownTime()) or 0
        self._gameStatuTime = tonumber(self.brnnGameManager:getDataManager():getGameDownTime()) or 0
        self.timeLabel:setString(self._gameStatuTime)
        -- self._countdown = math.floor(os.clock()) + _tempCountdown

        if self._gameStatuTime > 0 then
            self._gameStatuTime = self._gameStatuTime-1
        end
        self._gameStatuTimeTotal = self._gameStatuTime

        self:clockOutTime()
        ---当前游戏状态
        self:gameStatesUpdataUI()

        if self.brnnGameManager:getDataManager():getGameStates() == 3 then
            self._gameEnterGameState = 3

            self:dealMessage();

            ---显示等待本局结束
            self:noMyFilling(1)
        end

        if self.brnnGameManager:getDataManager():getGameStates() ~= 1 then
            ---更新自己的下注数据
            self:updateMyStakeData()

            ---更新每个区域桌面下注的钱
            self:updateEachTranslateTotalMoeny(true)
        end
            
        ---初始化庄家消息
        self:initBankerInfo()

        ---初始化可以下多少注    
        self:initMaxBetScore()

        ---初始化前面8个人
        self:updatePlayerIcon()

        ---上庄UI
        self:initBankerBtnUI();

        ---更新筹码是否可以点击
        self:updateChipBtnTouch()


    elseif msgName == BrnnGameManager.MsgName.SC_OxPlayerList then ---8位用户消息

        if self.brnnGameManager:getDataManager():getGameStates() ~= 3 then

            self:updatePlayerIcon()

        end

    ----游戏基础信息
    elseif msgName == BrnnGameManager.MsgName.SC_Ox_config_info then
        ---刷新筹码
        self:setInitChioseAllPoints(self.brnnGameManager:getDataManager():getGameChipInfo())
		
		if userInfo["bet_min_limit_money"] ~= nil then
			self.bet_min_limit_money = userInfo["bet_min_limit_money"]
		else
			self.bet_min_limit_money = 0
		end
		
		
		self:checkGuanZhan()

    ---游戏状态
    elseif msgName == BrnnGameManager.MsgName.SC_OxSatusAndDownTime then 
        self._gameEnterGameState = 0

        -- local _tempCountdown = tonumber(self.brnnGameManager:getDataManager():getGameDownTime()) or 0
        self._gameStatuTime = tonumber(self.brnnGameManager:getDataManager():getGameDownTime()) or 0
		local tt = tonumber(self.brnnGameManager:getDataManager():getGameDownTime())
        self.timeLabel:setString(self._gameStatuTime)
        -- self._countdown = math.floor(os.clock()) + _tempCountdown

        if self._gameStatuTime > 0 then

            self._gameStatuTime = self._gameStatuTime - 1
        end
        self._gameStatuTimeTotal = self._gameStatuTime

        self:clockOutTime()

        self._isBet = true

        ---更新桌面状态
        self:gameStatesUpdataUI()
		
		--print("----gamestate:"..self.brnnGameManager:getDataManager():getGameStates())
		--

        if self.brnnGameManager:getDataManager():getGameStates() == 1 then
            ---更新筹码是否可以点击
            self:updateChipBtnTouch()
        end
		
		if self.brnnGameManager:getDataManager():getGameStates() == 2 then
			MusicAndSoundManager:getInstance():playerSoundWithFile("brnnSound/startbet.mp3")
		end


    elseif msgName == BrnnGameManager.MsgName.SC_OxAddScore then ---下注返回
        self._isBet = true

        ---更新筹码是否可以点击
        self:updateChipBtnTouch()

        self:updateMyStakeData()
    
    elseif msgName == BrnnGameManager.MsgName.SC_OxEveryArea then --显示每个区域总的钱
   
        self:updateEachTranslateTotalMoeny()

        self:initMaxBetScore()

    elseif msgName == BrnnGameManager.MsgName.SC_OxDealCard then ---发牌
        --todo
		MusicAndSoundManager:getInstance():playerSoundWithFile("brnnSound/endbet.mp3")
		
        self:dealMessage();
    
    elseif msgName == BrnnGameManager.MsgName.SC_OxBankerList then ---上庄列表
        
        ---上庄成功
        self:setBankerList(self.brnnGameManager:getDataManager():getBankerLists())

        if self._bankerOnSuccess == true then
            
            self:showbankerUI();
            ---申请上庄按钮 可以触摸*
            self.bankerCancel:setEnabled(true)
            ---显示
            self.bankerListCancel:setVisible(true)

            self.bankerListOn:setVisible(false)

            self._bankerOnSuccess = false

           
        ---下庄成功
        elseif self._bankerLeaveSuccess == true then

            self:showbankerUI();

            self._bankerLeaveSuccess = false

            if self.bankerListCancel:isVisible() == true then

                self.bankerCancel:setEnabled(false)

                --self:setBankerList(self.brnnGameManager:getDataManager():getBankerLists())
            end
        end
    elseif msgName == BrnnGameManager.MsgName.SC_OxBetCoin then
            

    elseif msgName == BrnnGameManager.MsgName.SC_OxResult then

        -- local result = userInfo["result"];
  
        -- if result == 1 then
        --     MyToastLayer.new(self, "已达到庄家最大下注金额")  
        -- elseif result == 2 then
        --     MyToastLayer.new(self, "玩家金币不足")  
        -- elseif result == 3 then
        --     MyToastLayer.new(self, "不满足最低下注金币限制")  
        -- elseif result == 4 then
        --     MyToastLayer.new(self, "其他错误")  
        -- end

    ---庄家信息
    elseif msgName == BrnnGameManager.MsgName.SC_OxBankerInfo then
    
    ---记录
    elseif msgName == BrnnGameManager.MsgName.SC_OxRecord then

        self:showJiluUI();
        
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    ---上庄
    elseif msgName == BrnnGameManager.MsgName.SC_OxForBankerFlag then
        self._bankerOnSuccess = true
        MyToastLayer.new(self, "申请上庄成功") 
    ----取消上庄
    elseif msgName == BrnnGameManager.MsgName.SC_OxBankerLeaveFlag then
        --self.bankerOn:setEnabled(true)
        self._bankerLeaveSuccess = true
        MyToastLayer.new(self, "下庄成功") 
        ---游戏停服通知
    elseif msgName == HallMsgManager.MsgName.SC_GameMaintain then
        if self.brnnGameManager:getDataManager():getGameStates() == 1 then
            self:isContinueGameConditions()
        end
    end


    BrnnGameScene.super.receiveServerResponseSuccessEvent(self,event)
end

---重新连接成功
function BrnnGameScene:callbackWhenReloginAndGetPlayerInfoFinished(event)
    -- body
    print("重新连接成功")
    BrnnGameScene.super.callbackWhenReloginAndGetPlayerInfoFinished(self,event);
    -- local gameingInfoTable = GameManager:getInstance():getHallManager():getPlayerInfo():getGamingInfoTab()
    -- if gameingInfoTable == nil  then
    --    CustomHelper.showAlertView(
    --             "本局已经结束,退回到大厅!!!",
    --             false,
    --             true,
    --             nil,
    --         function(tipLayer)
    --              self:jumpToHallScene();
    --     end)
    --    return;
    -- end
        ---发送开始消息
    -- self.brnnGameManager:sendPlayerReconnection()
    --    CustomHelper.showAlertView(
    --        "请重新进入房间!!!",
    --        false,
    --        true,
    --        function(tipLayer)
    --            self:exitGame()
    --        end,
    --        function(tipLayer)
    --            self:exitGame()
    --    end)

    --- 尝试直接发送进入游戏消息
    local roomInfo = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab()
    local gameTypeID = roomInfo[HallGameConfig.GameIDKey]
    local roomID = roomInfo[HallGameConfig.SecondRoomIDKey]

    CustomHelper.addIndicationTip(HallUtils:getDescriptionWithKey("entering_gamescene_tip"));
    GameManager:getInstance():getHallManager():getHallMsgManager():sendEnterOneGameMsg(gameTypeID,roomID);
end

--请求失败通知，网络连接状态变化
function BrnnGameScene:callbackWhenConnectionStatusChange(event)
    BrnnGameScene.super.callbackWhenConnectionStatusChange(self,event);
    print("网络断开连接")
end

----收到服务器返回的失败的通知，如果登录失败，密码错误
function BrnnGameScene:receiveServerResponseErrorEvent(event)
    
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"]

    -- ---申请上庄失败 允许上庄按钮点击，并且显示界面
    -- if msgName == BrnnGameManager.MsgName.SC_OxForBankerFlag then
    --     if userInfo["result"] == 1 then
    --        MyToastLayer.new(self, "金币不足") 
    --     end
    --     self.bankerOn:setEnabled(true)
    --     self.bankerListOn:setVisible(true)
    -- end
    if msgName == BrnnGameManager.MsgName.SC_OxBetCoin then
        ---金币不足清除记录
        if userInfo["result"] >= 1 then
            self.willCoin = 0
        end
    end
    if msgName == HallMsgManager.MsgName.SC_GameMaintain then
        if self.brnnGameManager:getDataManager():getGameStates() == 1 then
            self:isContinueGameConditions()
        end
    end
    BrnnGameScene.super.receiveServerResponseErrorEvent(self,event);
end


----初始化要加载的资源
function BrnnGameScene.getNeedPreloadResArray()
    -- body
    local  res = {
        CustomHelper.getFullPath("game_res/zh_brnn_youxiguize.png"),
        CustomHelper.getFullPath("game_res/zh_brnn_beijing.png"),
        CustomHelper.getFullPath("game_res/zh_brnn_tongsha.png"),
        CustomHelper.getFullPath("game_res/zh_brnn_jiesuandi.png "),
        CustomHelper.getFullPath("game_res/zh_brnn_shangzhuangdi.png"),
        CustomHelper.getFullPath("anim/dkj_brnn_ui/dkj_brnn_ui.ExportJson")
    }
    return res
end


function BrnnGameScene:checkGuanZhan()
	
	
	
	if self.isGuanzhan == false then
		
		--local myInfo = self.brnnGameManager:getDataManager():getMyMoney()
		local myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
		if myPlayerInfo ~= nil then
			--local myMoney = string.format("%0.2f", myInfo["money"]/100)
			--self.playerCoin:setString(CustomHelper.moneyShowStyleNone(myInfo["money"]))
			--self.playerName:setString(myInfo["nickname"])
			print("--------------moeny:"..myPlayerInfo:getMoney())
			if myPlayerInfo:getMoney() < self.bet_min_limit_money then
                local bankCallbackFunc = function (  )
                    local BankCenterLayer = requireForGameLuaFile("BankCenterLayer")
                    self:exitGame({
                        { tag = ViewManager.SECOND_LAYER_TAG.BANK, parme = BankCenterLayer.ViewType.WithDraw },
                    })
                end
                local storyCallbackFunc = function (  )
                    self:exitGame({
                        { tag = ViewManager.SECOND_LAYER_TAG.STORY },
                    })
                end
                local closeCallbackFunc = function(sender) sender:removeSelf() end

                CustomHelper.showLackMoneyAlertView(self.bet_min_limit_money,
                    "由于你携带金币小于"..( CustomHelper.moneyShowStyleNone(self.bet_min_limit_money))..",现在你只能处于观战模式,不能下注！",
                    nil,bankCallbackFunc,storyCallbackFunc,closeCallbackFunc)

				self.isGuanzhan = true
				self.guanzhanStartTime = socket.gettime()
				--
				self:updateChipBtnTouch()
			else
				self.isGuanzhan = false
			end
		end
		
	else
		if self.guanzhanStartTime ~= nil then
			local time = socket.gettime()-self.guanzhanStartTime
			print("------------time:"..time)
			if time > 3600 then
				self:exitGame()
			end
		end
	end
	
	
	local xiadi = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "xiadi"), "ccui.ImageView");
	local headIcon = xiadi:getChildByName("Panel_guanzhan")--
	if self.isGuanzhan == true then
		--Image_guanzhan
		
		headIcon:setVisible(true)
	else
		headIcon:setVisible(false)
	end
	
	
	return self.isGuanzhan
end


function BrnnGameScene:ctor()
	
	self.isGuanzhan = false
	self.bet_min_limit_money = 0

    self._areaCoinLabs = {} ---存放桌子上面每个区域显示总的下注 Lable

    self._areaMeCoinLabs = {} ---存放桌子上面每个区域显示自己总的下注 Lable

    self._gameStatuTime = 0; ---状态时间

    self._gameStatuTimeTotal = 0; ---总时间

    self._userCoin = nil;---选择的筹码图片

    self._initChioseAllPoints = {}; ---筹码数值

    self._coinBtns = {}---筹码按钮 

    self._table = nil; ---桌子放金币用的

    self._tableCoinSprite = {}  --桌子上的金币集合

    self._coinChoice = 10; ---当前选择的筹码 默认为10

    self._gameEnterGameState = 0---进入游戏时的状态

    self._bankerOnSuccess = false; ---上庄成功

    self._bankerLeaveSuccess = false;---下庄成功

    self._isXuTou = false;---是否续投 true 点击

    self._isBet = true;--- 是否可以下注

    self._chipSprite = {}; --- 筹码精灵容器

    self._chipMoveTime = 0.01 ---筹码移动时间

    self._starAreaWinAction = false ----开始区域win动画

    self._areaWinActionNode = {} ----保存区域win动画Node

    self._countdown = 0; ---倒计时

    self._isSystemBanker = false; ---true 系统当庄 

    ---初始化数据对象
    self.brnnGameManager = BrnnGameManager:getInstance();

    BrnnGameScene.super.ctor(self);

    ---初始化界面
    local CCSLuaNode =  requireForGameLuaFile("GameBrnnCCS")
    self.csNode = CCSLuaNode:create().root;     
    self:addChild(self.csNode)
	
	local bg = {
		[1] = CustomHelper.getFullPath("game_res/bg1.jpg"),
		[2] = CustomHelper.getFullPath("game_res/bg2.jpg"),
	}
	self.csNode:getChildByName("tableImgBg"):loadTexture(bg[self.brnnGameManager.gameDetailInfoTab["second_game_type"]])
	
	---初始化自己的信息
    self:initMyInfo()

    ---初始化筹码数据
    --self:setInitChioseAllPoints(gameBrnn.CONFIG_NORMAL_COIN)
	self:setInitChioseAllPoints(gameBrnn.CONFIG_NORMAL_COINS[self.brnnGameManager.gameDetailInfoTab["second_game_type"]])

    ---设置默认选择1个筹码值
    self:userCoin(1);

    ---初始化UI
    self:initUI();

    

    ---初始化下注区域的按钮
    self:initCentreBtn();

    ---初始化桌面上面的前面8个人为隐藏
    self:updatePlayerIcon(false)

    ---初始化倒计时
    self:initClock();

    ---初始化庄家面板
    self:initBankerBtnUI()    

    ---发送开始消息
    self.brnnGameManager:sendPlayerReconnection()

    ---背景音乐
    MusicAndSoundManager:getInstance():playMusicWithFile("brnnSound/"..gameBrnn.Sound.brnnBg, true)


    GameManager:getInstance():getHallManager():getPlayerInfo():setGamingInfoTab(nil)
end

function BrnnGameScene:onExit()
    if self._scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scheduler)
        self._scheduler = nil
    end
end

---游戏状态更新UI
function BrnnGameScene:gameStatesUpdataUI()

    if self.brnnGameManager:getDataManager():getGameStates() == 1 then

        ----游戏释放停服
        self:isContinueGameConditions()

        ---休息时间
        self.timeImg:loadTexture(CustomHelper.getFullPath("game_res/zh_brnn_xiuxipianke.png"))

        ---清空桌子数据
        self:updateTabelState()

        ---更新庄家信息
        self:initBankerInfo()

        ---更新最大下注
        self:initMaxBetScore()

        ---设置闹钟位置
        self.clock:setPosition(cc.p(637.71,292.18))

        ---隐藏下注提示
        self.tipsXiaZhuIcon:setVisible(false);

        ---禁止下注
        self:noMyFilling(2)

        ---更新上庄列表信息
        self:showbankerUI()
        
        ---更新庄家列表
        self:setBankerList(self.brnnGameManager:getDataManager():getBankerLists())
		
		
		--
		self:checkGuanZhan()

    elseif self.brnnGameManager:getDataManager():getGameStates() == 2 then
        
        local chipNum = 0
        for k,v in pairs(self.brnnGameManager:getDataManager():getMySreaCoins()) do
            chipNum = v 
        end

		local myInfo = self.brnnGameManager:getDataManager():getMyUserInfo()
		--local myMoney = 0
		--if myInfo ~= nil then
        
		--	myMoney = myInfo["money"]
		--end
		
        ---上把有押注才能打开续投按钮
        --if chipNum > 0 and self.brnnGameManager:getDataManager():isMyBanker() == false and myMoney > 0 then 
		if chipNum > 0 and self.brnnGameManager:getDataManager():isMyBanker() == false then
            self.xuTouBtn:setEnabled(true)
        end
        
        self._isXuTou = false;

        ---清空桌子
		self:stopActionByTag(100)
        self._table:removeAllChildren(true)

        ---下注时间
        self.timeImg:loadTexture(CustomHelper.getFullPath("game_res/zh_brnn_xiazhushijian.png"))

        ---改变闹钟坐标
        self.clock:setPosition(cc.p(335.46,651.66))

        ---显示下注提示
        self.tipsXiaZhuIcon:setVisible(true);


    elseif self.brnnGameManager:getDataManager():getGameStates() == 3 then

        self.brnnGameManager:getDataManager():getMyAreaBetRecord()
        ---开牌时间
        self.timeImg:loadTexture(CustomHelper.getFullPath("game_res/zh_brnn_kaipaishijian.png"))

        ---改变闹钟坐标
        self.clock:setPosition(cc.p(335.46,651.66))

        ---隐藏下注提示
        self.tipsXiaZhuIcon:setVisible(false);

    end
end

----初始化界面
function BrnnGameScene:initUI()
   
    local tableBg = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "tableImgBg"), "ccui.ImageView");

    ---状态显示
    self.timeImg = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "timeImg"), "ccui.ImageView");

    ---游戏放筹码 放扑克  结束 的层
    self._table = tolua.cast(CustomHelper.seekNodeByName(tableBg, "panel_chipSpr"), "ccui.Layout")
    

    self.panel_JiLuList = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "panel_JiLuList"), "ccui.ListView")

    ---记录
    local jiLuBtn = tolua.cast(CustomHelper.seekNodeByName(tableBg, "jiLuBtn"), "ccui.Button");
    CustomHelper.addPressedDarkAnimForBtn(jiLuBtn)
    jiLuBtn:addClickEventListener(function ()
        if self.panel_JiLuList:isVisible() == false  then
            --self.brnnGameManager:sendOxRecord()
            self.panel_JiLuList:setVisible(true)
        else
            self.panel_JiLuList:setVisible(false)
        end
        
    end)

    ---提示
    self.tipsXiaZhuIcon = tolua.cast(CustomHelper.seekNodeByName(tableBg, "tipsXiaZhuIcon"), "ccui.ImageView");
    self.tipsXiaZhuIcon:setVisible(false);

     ---退出游戏
    local choceBtn = tolua.cast(CustomHelper.seekNodeByName(tableBg, "returnchoiceBtn"),"ccui.Button");
    choceBtn:addClickEventListener(function ()

        print(#self.brnnGameManager:getDataManager()._tempAreaCoins,"#self.brnnGameManager:getDataManager()._tempAreaCoins")
        local chipNum = 0
        for k,v in pairs(self.brnnGameManager:getDataManager()._tempAreaCoins) do
            chipNum = v;
        end
        if self.brnnGameManager:getDataManager():isMyBanker() == true then
            MyToastLayer.new(self, "你是庄家不能退出") 
            return
        end
        if  (chipNum == 0 or self.brnnGameManager:getDataManager():getGameStates() ~= 2)
                and self.brnnGameManager:getDataManager():isMyBanker() == false
                and self._isBet
        then
            self:exitGame()
        else
            MyToastLayer.new(self, "游戏中不能退出") 
        end
    end)

    ---- 初始化庄家金币
    local shangdi = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "shangdi"), "ccui.ImageView");
    local moeny = tolua.cast(CustomHelper.seekNodeByName(shangdi, "moeny"), "ccui.Text")
    moeny:setString("--")

end

---退出游戏界面
function BrnnGameScene:jumpToHallScene(...)
    ---释放资源
    local needLoadResArray = BrnnGameScene.getNeedPreloadResArray();
    for i,v in ipairs(needLoadResArray) do
        if string.find(v,".ExportJson") then
        --todo
            ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(v);
        end
    end

    if self._scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scheduler)   
        self._scheduler = nil
    end


    self.brnnGameManager:clearLoadedOneGameFiles()

    local subGameManager = GameManager:getInstance():getHallManager():getSubGameManager();
	if subGameManager ~= nil then
		subGameManager:onExit();
	end
    

    SceneController.goHallScene(...);
end

----退出房间
function BrnnGameScene:exitGame(...)
    self.brnnGameManager:sendOxLeaveGame()

    self.brnnGameManager:sendStandUpAndExitRoomMsg()

    GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)

    self:jumpToHallScene(...);
end

 ----庄家信息
function BrnnGameScene:initBankerInfo(isGameEndUpdata)
    

    local bankerInfo = self.brnnGameManager:getDataManager():getBankerInfo()
    if isGameEndUpdata == true then
        
       bankerInfo =  self.brnnGameManager:getDataManager():getGameEndBankerInfo()

    end
    if bankerInfo==nil then
        return
    end

    local shangdi = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "shangdi"), "ccui.ImageView");
    local name = tolua.cast(CustomHelper.seekNodeByName(shangdi, "name"), "ccui.Text")
    name:setString(bankerInfo["nickname"] )

    local moeny = tolua.cast(CustomHelper.seekNodeByName(shangdi, "moeny"), "ccui.Text")
    moeny:setString(CustomHelper.moneyShowStyleNone(bankerInfo["money"]))

    local score = tolua.cast(CustomHelper.seekNodeByName(shangdi, "score"), "ccui.Text")
    local scoreNum = bankerInfo["banker_score"] or 0
    score:setString(CustomHelper.moneyShowStyleNone(scoreNum));


    local lianzhuang = tolua.cast(CustomHelper.seekNodeByName(shangdi, "lianzhuang"), "ccui.Text")
    lianzhuang:setString(bankerInfo["bankertimes"])


    
    local touxiangIcon = tolua.cast(CustomHelper.seekNodeByName(shangdi, "touxiangIcon"), "ccui.ImageView")
    local headIconNum = bankerInfo["header_icon"] or 1
    if headIconNum == -1 then
        self._isSystemBanker = true
        name:setString("系统当庄")
        touxiangIcon:loadTexture(CustomHelper.getFullPath("game_res/zh_brnn_xitongdangzhuang.png"))
        moeny:setString("--")
    else
        self._isSystemBanker = false
        touxiangIcon:loadTexture(CustomHelper.getFullPath("hall_res/head_icon/"..(headIconNum)..".png"))
    end
end



----上庄面板
function BrnnGameScene:initBankerBtnUI()

    self.bankerListOn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "bankerListOn"), "ccui.ImageView");
    local bankerCionTipsText = tolua.cast(CustomHelper.seekNodeByName(self.bankerListOn, "bankerCionTipsText"), "ccui.Text");
    bankerCionTipsText:setString("申请上庄需要"..CustomHelper.moneyShowStyleAB(self.brnnGameManager:getDataManager():getBankerLimit()).."金币")
    ---申请上庄按钮
    self.bankerOn = tolua.cast(CustomHelper.seekNodeByName(self.bankerListOn, "bankerOn"), "ccui.Button");

    self.bankerOn:addClickEventListener(function ()
        
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        local bankerCion = gameBrnn.BankerCion[self.brnnGameManager.gameDetailInfoTab["second_game_type"]]
        local bankerLimit = self.brnnGameManager:getDataManager():getBankerLimit()
        if bankerLimit ~= nil and bankerLimit > 0 then
            bankerCion = bankerLimit
        end
        if  self.brnnGameManager:getDataManager():getMyMoney() <  bankerCion then
            MyToastLayer.new(self, "金币不足!")
        else
            self.brnnGameManager:sendApplyForBanker();
            self.bankerOn:setEnabled(false)
            self.bankerListOn:setVisible(false)
        end
    end)

    local itme = tolua.cast(CustomHelper.seekNodeByName(self.bankerListOn, "itemS_1"), "ccui.Layout");

    ---下庄
    self.bankerCancel_0 = tolua.cast(CustomHelper.seekNodeByName(self.bankerListOn, "bankerCancel_0"), "ccui.Button");
    self.bankerCancel_0:addClickEventListener(function ()
        -- body
        ---当庄时下庄
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        local bankerInfo = self.brnnGameManager:getDataManager():getBankerInfo()
        local myUserInfo = self.brnnGameManager:getDataManager():getMyUserInfo()

        ----自己是庄家
        if  self.brnnGameManager:getDataManager():isMyBanker() == true then
            self.brnnGameManager:sendOxCurBankerLeave();
            self.bankerCancel_0:setEnabled(false);
            MyToastLayer.new(self, "申请下庄成功,等待本轮结束!")
        else
            self.brnnGameManager:sendOxLeaveForBanker();
        end
    end)

    self:showbankerUI()

    ---取消上庄
    self.bankerListCancel = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "bankerListCancel"), "ccui.ImageView");
    local bankerCionTipsText1 = tolua.cast(CustomHelper.seekNodeByName(self.bankerListCancel, "bankerCionTipsText"), "ccui.Text");
    bankerCionTipsText1:setString("申请上庄需要"..CustomHelper.moneyShowStyleNone(self.brnnGameManager:getDataManager():getBankerLimit()).."金币")
    
    self.bankerCancel = tolua.cast(CustomHelper.seekNodeByName(self.bankerListCancel, "bankerCancel"), "ccui.Button");
    self.bankerCancel:addClickEventListener(function ()
        
        ----自己是庄家
        if self.brnnGameManager:getDataManager():isMyBanker() == true then
            self.brnnGameManager:sendOxCurBankerLeave();
            MyToastLayer.new(self, "申请下庄成功,等待本轮结束!")
            self.bankerListCancel:setVisible(false)
            self.bankerListOn:setVisible(true)
        end
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        self.brnnGameManager:sendOxLeaveForBanker();

    end)

    ---关闭列表
    local offListBtn = tolua.cast(CustomHelper.seekNodeByName(self.bankerListCancel, "offListBtn"), "ccui.Button");
    offListBtn:addClickEventListener(function ()
        -- body
        self.bankerListCancel:setVisible(false)
        self.bankerListOn:setVisible(true)
    end)
    ---关闭列表
    local offButton = tolua.cast(CustomHelper.seekNodeByName(self.bankerListCancel, "offButton"), "ccui.Button")
    offButton:addClickEventListener(function ()
        -- body
        self.bankerListCancel:setVisible(false)
        
        local function showBankerListView( )
            self.bankerListOn:setVisible(true)
        end
        local func = cc.CallFunc:create(showBankerListView)
        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),func))
    end)
end


----更新上庄显示界面
function BrnnGameScene:showbankerUI()
    -- body
    ---先查找自己是否是庄家 
    local bankerInfo = self.brnnGameManager:getDataManager():getBankerInfo()

    local myUserInfo = self.brnnGameManager:getDataManager():getMyUserInfo()
    local bankerListInfo = self.brnnGameManager:getDataManager():getBankerLists()

    local isMyBankerListInfoHave = false
    if bankerListInfo ~= nil then
        for k,v in pairs(bankerListInfo) do
            if v["guid"] == myUserInfo["guid"] then
                --todo
                isMyBankerListInfoHave = true
                break;
            end
        end
    end

    if bankerListInfo == nil then
        for i=1,2 do
            local item = tolua.cast(CustomHelper.seekNodeByName(self.bankerListOn, "itemS_"..i), "ccui.Layout");
            if item~=nil then
                item:setVisible(false)
            end
        end
    else    
        for i=1,2 do 
            local item = tolua.cast(CustomHelper.seekNodeByName(self.bankerListOn, "itemS_"..i), "ccui.Layout");
            item:setVisible(true)
            local v = bankerListInfo[i]
            if v~=nil then
                local name = tolua.cast(CustomHelper.seekNodeByName(item, "name"), "ccui.Text");
                name:setString(v["nickname"])
                local moeny = tolua.cast(CustomHelper.seekNodeByName(item, "money"), "ccui.Text");
                moeny:setString(CustomHelper.moneyShowStyleNone(v["money"]))
            else
               item:setVisible(false) 
            end
        end
    end

    ----自己是庄家 或者 自己申请庄家列表里面
    if (self.brnnGameManager:getDataManager():isMyBanker() == true) or isMyBankerListInfoHave == true then

        self.bankerOn:setVisible(false)

        ---自己是庄家的情况下 显示申请下庄按钮
        self.bankerCancel_0:setEnabled(true);

        self.bankerCancel_0:setVisible(true)

        ---自己是庄家 同时 申请上庄列表是打开的
        if self.brnnGameManager:getDataManager():isMyBanker() == true and self.bankerListCancel:isVisible() == true  then
            
            ---关闭申请上庄列表
            self.bankerListCancel:setVisible(false);
            ---打开小的上庄列表
            self.bankerListOn:setVisible(true)
        end
    else 
        ---上庄按钮
        self.bankerOn:setEnabled(true)

        self.bankerOn:setVisible(true)
        ---下庄
        self.bankerCancel_0:setVisible(false)

        print("------2")
    end

end


----上庄玩家列表
function BrnnGameScene:setBankerList(tablePlayer)

    local bankerListItem = tolua.cast(CustomHelper.seekNodeByName(self.bankerListCancel, "bankerListItem"), "ccui.Layout")
    local bankerListView = tolua.cast(CustomHelper.seekNodeByName(self.bankerListCancel, "ListView_1"), "ccui.ListView")
    bankerListView:removeAllItems();

    for i=1,2 do 
        local item = tolua.cast(CustomHelper.seekNodeByName(self.bankerListOn, "itemS_"..i), "ccui.Layout");
        item:setVisible(true)
        if tablePlayer==nil then
            item:setVisible(false) 
        else
            local v = tablePlayer[i]
            if v~=nil then
                local name = tolua.cast(CustomHelper.seekNodeByName(item, "name"), "ccui.Text");
                name:setString(v["nickname"])
                local moeny = tolua.cast(CustomHelper.seekNodeByName(item, "money"), "ccui.Text");
                moeny:setString(CustomHelper.moneyShowStyleNone(v["money"]))
            else
                item:setVisible(false) 
            end
        end
    end

    if tablePlayer==nil then
        return
    end

    for k, v  in pairs(tablePlayer) do
        if k > 8 then
            break;
        end
        local node = bankerListItem:clone();
        node:setVisible(true)

        local name = tolua.cast(CustomHelper.seekNodeByName(node, "name"), "ccui.Text");
        name:setString(v["nickname"])

        local moeny = tolua.cast(CustomHelper.seekNodeByName(node, "money"), "ccui.Text");
        moeny:setString(CustomHelper.moneyShowStyleNone(v["money"]))
        bankerListView:pushBackCustomItem(node)
    end
end

function BrnnGameScene:initJuluUI()
    
end


----显示记录UI
function BrnnGameScene:showJiluUI()

    local data = self.brnnGameManager:getDataManager():getRecordData()
    local listView = tolua.cast(CustomHelper.seekNodeByName(self.panel_JiLuList, "jiLuListsView"), "ccui.ListView")
    local count = 1
    if data ~= nil then
         count = #data 
    end
    
    for i=1,10 do
        local node = listView:getItem(i-1)
        local v = nil
        if data ~= nil then
           v = data[count] 
        end
        if v == nil then
            for j = 1,4 do
                local imageBg = tolua.cast(CustomHelper.seekNodeByName(node, "Image_"..j), "ccui.ImageView");
                if imageBg ~= nil then
                    imageBg:setVisible(false)
                end
            end
        else
            local result = v["result"]
            for _i,_v in ipairs(result) do
                local imageBg = tolua.cast(CustomHelper.seekNodeByName(node, "Image_".._i), "ccui.ImageView");
                imageBg:setVisible(true)
                if _v == true then
                    imageBg:loadTexture(CustomHelper.getFullPath("game_res/zh_brnn_v.png"))
                else
                    imageBg:loadTexture(CustomHelper.getFullPath("game_res/zh_brnn_x.png"))
                end
            end
        end
        count = count-1
    end
end



---下注条件判断
function BrnnGameScene:brnnBetCondition(alreadyBetCoin,coinChoice)

    ---我能下注 1 我的钱/10 

    local bankerInfo = self.brnnGameManager:getDataManager():getBankerInfo()
    local myInfo = self.brnnGameManager:getDataManager():getMyUserInfo()


    ---庄家不能下注
    if bankerInfo~=nil and (bankerInfo["guid"] == myInfo["guid"])   then
        --MyToastLayer.new(self, "庄家不能下注!!!")
        return true
    end

    -- if self.brnnGameManager:getDataManager():getMyMoney()/10 < coinChoice + alreadyBetCoin then
    --     --MyToastLayer.new(self, "已达到下注上限!!")
    --     return true
    -- end
	
	--local x = self.brnnGameManager:getDataManager():getMyMoney() - (chipNum*9)
     --       if x/10 < self._initChioseAllPoints[i]  then

    if self._coinChoice > self.brnnGameManager:getDataManager():getLeftMoenyBet()  then
        --MyToastLayer.new(self, "下注数大于剩余下注数!!!")
        return true
    end


    if self._coinChoice > self.brnnGameManager:getDataManager():getMyMoney() then
        MyToastLayer.new(self, "金币不足!!")
        return true
    end

    ---当前选择的筹码


    return false
end

----中间桌子上的下注按钮
function BrnnGameScene:initCentreBtn()
    
    ---下注按钮
    for i=1,4 do
        local btn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn"..(i-1)), "ccui.Button");
        local areaTotalCoin = tolua.cast(CustomHelper.seekNodeByName(btn, "Label_Total"), "ccui.TextAtlas");
        local areaMeCoin = tolua.cast(CustomHelper.seekNodeByName(btn, "Label_Me"), "ccui.TextAtlas");
        areaTotalCoin:setString(0);
        areaMeCoin:setString(0);
        -- self._areaCoins[i] = 0 --每个区域的下注总额
        -- self._areaMeCoins[i] = 0
        self._areaCoinLabs[i] = areaTotalCoin;
        self._areaMeCoinLabs[i] = areaMeCoin;
        btn:addClickEventListener(function ()

            if self.brnnGameManager:getDataManager():getGameStates() == 2 then

                local moeny = 0

                for k,v in pairs(self.brnnGameManager:getDataManager()._tempAreaCoins) do

                    moeny = moeny+v

                end

                ---当前选择的筹码 已经不能下注
                local isChipBtnBet = true

                for i,v in ipairs(self._coinBtns) do

                    local tipsIcon = tolua.cast(CustomHelper.seekNodeByName(v, "tipsIcon"), "ccui.ImageView");

                    if v:isEnabled() == false and tipsIcon:isVisible() == true then

                        isChipBtnBet = false
                        
                        break
                    end
                end

                if self:brnnBetCondition(moeny,self._coinChoice) == false and isChipBtnBet == true then  --and self._isBet == true 

                    self.brnnGameManager:sendOxAddScore(i,self._coinChoice)
                    ---添加动画
                    self:showCoin(i,self._coinChoice,self._chipMoveTime)

                    --MusicAndSoundManager:getInstance():playerSoundWithFile("brnnSound/"..gameBrnn.Sound.brnn_jetton)

                    self._isBet = false

                    --下注点击动画
                    local an = {[1] = 8,[2] = 6,[3] = 5,[4] = 7}
                    local anpos = {[1] = {x = 328, y = 375},[2] = {x = 404, y = 328},[3] = {x = 872, y = 328},[4] = {x = 953, y = 375}}
                    local aniFile = "dkj_brnn_ui"
                    local aniName = "ani_0"..an[i]
                    
                    local node = ccs.Armature:create(aniFile)
                    node:getAnimation():setMovementEventCallFunc(function(sender, _type, id)
                        if _type == ccs.MovementEventType.start then
                        elseif _type == ccs.MovementEventType.complete then
                            node:removeFromParent()
                        elseif _type == 2 then
                        end
                    end)
                    node:getAnimation():play(aniName)
                    self._table:addChild(node)
                    node:setPosition(anpos[i])

                end

            elseif self.brnnGameManager:getDataManager():getGameStates() == 1 or self.brnnGameManager:getDataManager():getGameStates() == 3 then
                --MyToastLayer.new(self, "不是下注时间,不能下注")
            end
        end)
    end
end


----更新牌桌上面的8个人
function BrnnGameScene:updatePlayerIcon(isShow)

    local tableBg = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "tableImgBg"), "ccui.ImageView");
    local _userList = self.brnnGameManager:getDataManager():getUserList()
    for i=8,1,-1 do
        local player = tolua.cast(CustomHelper.seekNodeByName(tableBg, "player"..(i-1)),"ccui.ImageView");
        local headIcon = tolua.cast(CustomHelper.seekNodeByName(player, "headIcon"), "ccui.ImageView");
        local coin = tolua.cast(CustomHelper.seekNodeByName(player, "coin"), "ccui.Text");
        player:setVisible(false)
        if _userList ~= nil and _userList[i]~= nil then
            local info =  _userList[i]
            
            coin:setString(CustomHelper.moneyShowStyleAB(info["money"]))
            player:setVisible(true)
            local head_id = info["head_id"] or 1
            headIcon:loadTexture(CustomHelper.getFullPath("hall_res/head_icon/"..(head_id)..".png"))
        end
    end
end

----禁止上注
function BrnnGameScene:noMyFilling(num)
    
    self.noTouch:setVisible(true)

    ---自己是庄家
    if self.brnnGameManager:getDataManager():isMyBanker() == true then
        
        local info = self.brnnGameManager:getDataManager():getBankerInfo()
        local bankerNum = tolua.cast(CustomHelper.seekNodeByName(self.noTouch, "text_num"), "ccui.Text");
        local x = 5 - info["bankertimes"]
        bankerNum:setString(x)

        local gameEndTips = tolua.cast(CustomHelper.seekNodeByName(self.noTouch, "Image_8"), "ccui.ImageView");
        gameEndTips:setVisible(false)

    elseif num == 1 then

        local gameEndTips = tolua.cast(CustomHelper.seekNodeByName(self.noTouch, "Image_8"), "ccui.ImageView");
        gameEndTips:setVisible(true)

        local bankerNum = tolua.cast(CustomHelper.seekNodeByName(self.noTouch, "Image_9"), "ccui.ImageView");
        bankerNum:setVisible(false)

    else
        self.noTouch:setVisible(false)
    end
end


----更新自己的信息
function BrnnGameScene:updateMyInfo()

    local myInfo = self.brnnGameManager:getDataManager():getMyUserInfo()
    if myInfo ~= nil then
        --local myMoney = string.format("%0.2f", myInfo["money"]/100)
        self.playerCoin:setString(CustomHelper.moneyShowStyleAB(myInfo["money"]))
        self.playerName:setString(myInfo["nickname"])
    end
end

----自己的信息
function BrnnGameScene:initMyInfo()

    local xiadi = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "xiadi"), "ccui.ImageView");
    local headIcon = tolua.cast(CustomHelper.seekNodeByName(xiadi, "headIcon"), "ccui.ImageView");
    self.playerCoin = tolua.cast(CustomHelper.seekNodeByName(xiadi, "playerCoin"), "ccui.Text");
    local levelNum = tolua.cast(CustomHelper.seekNodeByName(xiadi, "levelNum"), "ccui.TextAtlas");
    self.playerName = tolua.cast(CustomHelper.seekNodeByName(xiadi, "playerName"), "ccui.Text");
    local diandian = tolua.cast(CustomHelper.seekNodeByName(xiadi, "diandian"), "ccui.ImageView");

    local myInfo = self.brnnGameManager:getDataManager():getMyUserInfo()
    if myInfo ~= nil then
        local myMoney = CustomHelper.moneyShowStyleAB(myInfo["money"])
        self.playerCoin:setString(myMoney)
        self.playerName:setString(myInfo["nickname"])
    end
    headIcon:loadTexture(GameManager:getInstance():getHallManager():getPlayerInfo():getSquareHeadIconPath())


    ---规则
    local guiZeBtn = tolua.cast(CustomHelper.seekNodeByName(xiadi, "guiZeBtn"), "ccui.Button");
    CustomHelper.addPressedDarkAnimForBtn(guiZeBtn)
    guiZeBtn:addClickEventListener(function ()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        local _gameTipsLayer = requireForGameLuaFile("BrnnGameTips");
        self.gameTipsLayer = _gameTipsLayer:create()
		
		self.gameTipsLayer:setguizeTexture(self.brnnGameManager.gameDetailInfoTab["second_game_type"])
		
        self:addChild(self.gameTipsLayer, 100)
    end)

    ---续投
    self.xuTouBtn = tolua.cast(CustomHelper.seekNodeByName(xiadi, "xuTouBtn"), "ccui.Button");
    --CustomHelper.addPressedDarkAnimForBtn(self.xuTouBtn)
    self.xuTouBtn:addClickEventListener(function ()

        if self.brnnGameManager:getDataManager():getGameStates() == 2 then
            local moeny = 0
            for k,v in pairs(self.brnnGameManager:getDataManager():getMySreaCoins()) do
                moeny = moeny+v
            end

            GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
            --if self:brnnBetCondition(moeny,0) == false then
			if self:brnnBetCondition(moeny,0) == false then
                self._isXuTou = true
                self.brnnGameManager:sendXuTou()
                self.xuTouBtn:setEnabled(false)

                ---筹码动画
                local stakeData1 = self.brnnGameManager:getDataManager():getMySreaCoins();
                for k,v in pairs(stakeData1) do
                    if v == self._initChioseAllPoints[1] then
                        self:showCoin(k,v,self._chipMoveTime)
                    elseif v == self._initChioseAllPoints[2] then
                        self:showCoin(k,v,self._chipMoveTime)
                    elseif v == self._initChioseAllPoints[3] then
                        self:showCoin(k,v,self._chipMoveTime)
                    elseif v == self._initChioseAllPoints[4] then
                        self:showCoin(k,v,self._chipMoveTime)
                    elseif v == self._initChioseAllPoints[5] then
                        self:showCoin(k,v,self._chipMoveTime)
                    else
                       self:showXuTouChipIcon(k,v,true)
                    end
                end

            end
        end
    end)
    ---自己没有下注 就不能点击
    if #self.brnnGameManager:getDataManager():getMySreaCoins() <= 0 then
        self.xuTouBtn:setEnabled(false)
    end  

    ---筹码按钮
    self:userCoin(1)
     for i=1, 5 do
        self._coinBtns[i] = tolua.cast(CustomHelper.seekNodeByName(xiadi, "coinBtn"..(i-1)), "ccui.Button") --layerInventory:getChildByName("bottomBg"):getChildByName("coinBtn"..(i-1))
        ---CustomHelper.addPressedDarkAnimForBtn(self._coinBtns[i])
        self._coinBtns[i]:addClickEventListener(function(sender, eventType)
                GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
                self:userCoin(i)
                ---记录选中的下注筹码
                for j=1,5 do
                    -- self._coinBtns[j] = tolua.cast(CustomHelper.seekNodeByName(xiadi, "coinBtn"..(j-1)), "ccui.Button")-- layerInventory:getChildByName("bottomBg"):getChildByName("coinBtn"..(j-1))
                    -- self._coinBtns[j]:setPositionY(43)
                    local tipsIcon = tolua.cast(CustomHelper.seekNodeByName(self._coinBtns[j], "tipsIcon"), "ccui.ImageView");
                    tipsIcon:setVisible(false);
                end
                local tipsIcon = tolua.cast(CustomHelper.seekNodeByName(self._coinBtns[i], "tipsIcon"), "ccui.ImageView");
                tipsIcon:setVisible(true);
                ---进入游戏时的状态lf._coinBtns[i]:setPositionY(75)
        end)
    end 

    ---noTouch
    self.noTouch = tolua.cast(CustomHelper.seekNodeByName(xiadi, "noTouch"), "ccui.Layout");
    self.noTouch:setVisible(false)
end

----闹钟倒计时
function BrnnGameScene:initClock()
    -- body
    self.clock = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "clock"), "ccui.ImageView");
    self.timeLabel = tolua.cast(CustomHelper.seekNodeByName(self.clock,"timeLabel"), "ccui.TextAtlas");

    -- 倒计时闹钟 --
    local icon_clock_mask = self.clock:getChildByName("icon_clock_mask")
    icon_clock_mask:setVisible(false)
    local iconName =  CustomHelper.getFullPath("game_res/zh_brnn_icon_clock_mask.png") 
    local spriteProgress = cc.Sprite:create(iconName)
    local progressTimer = cc.ProgressTimer:create(spriteProgress)
    progressTimer:setAnchorPoint(0.5, 0.5)
    progressTimer:setPosition(cc.p(icon_clock_mask:getPosition()))
    progressTimer:setReverseDirection(true)
    progressTimer:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    progressTimer:setPercentage(100)
    self.clock:addChild(progressTimer)
    self.icon_clock_progressTimer = progressTimer


    -- 创建定时任务 --
    self._scheduler = scheduler:scheduleScriptFunc(function(dt)
            self:_onInterval(dt)
            end, 1, false);
end

---- 闹钟倒计时动画
function BrnnGameScene:clockOutTime( ... )
    local function daojishiOver()
        self.icon_clock_progressTimer:stopAllActions();
    end
    local _atcoin = cc.Sequence:create(cc.ProgressFromTo:create(self._gameStatuTimeTotal, 100, 0), cc.CallFunc:create(daojishiOver))
    self.icon_clock_progressTimer:runAction(_atcoin)
end
----时间计时
function BrnnGameScene:_onInterval(dt)
	
	if dt >= 1.1 then
		local tt = 0
	end
  
    if self._gameStatuTime < 0  then
        self.icon_clock_progressTimer:stopAllActions();
        return;
    end

   
 
    -- local percent = self._gameStatuTime / self._gameStatuTimeTotal
    -- self.icon_clock_progressTimer:setPercentage(math.floor(percent * 100))
    self.timeLabel:setString(self._gameStatuTime)
    self._gameStatuTime = self._gameStatuTime - 1

    if self.brnnGameManager:getDataManager():getGameStates() == 3 and self._gameStatuTime == 1 then
        self:isContinueGameConditions()
    end   
    --self._gameStatuTime =  self._countdown - math.floor(os.clock())
    ----3秒时间删除区域动画
    if self._starAreaWinAction == true then
        self._showAreaActionTime = self._showAreaActionTime + 1
        if self._showAreaActionTime == 4  then
           self._starAreaWinAction = false
           local count = #self._areaWinActionNode
           for j=count,1,-1 do
                self._table:removeChild(self._areaWinActionNode[j])
           end
        end
    end
end


----设置筹码按钮可以点击
function BrnnGameScene:updateChipBtnTouch()
    -- body
    local chipNum = 0
    local stakeData = self.brnnGameManager:getDataManager():getAreaMeCoins()
    for k, v in pairs(stakeData) do
        chipNum = chipNum + v
    end

    local isCan = false

    for i = 1, 5 do
        --- 自己是庄家
        if self.brnnGameManager:getDataManager():isMyBanker() == true or self.isGuanzhan == true then
            self._coinBtns[i]:setEnabled(false)
            self.xuTouBtn:setEnabled(false)
        else
            self._coinBtns[i]:setEnabled(true)
            local t = 0
            if self.willCoin ~= nil then
                t = self.willCoin
            end
            --[[
            local b = self.brnnGameManager:getDataManager():getMyMoney()+chipNum > (self._initChioseAllPoints[i]+(chipNum+t))*self.brnnGameManager.gameDetailInfoTab["beishu"]
            if b == true then
                self._coinBtns[i]:setEnabled(false)
            else
                isCan = true
            end
            --]]

            local x = self.brnnGameManager:getDataManager():getMyMoney()
                    - t - ((chipNum + t) * (self.brnnGameManager.gameDetailInfoTab["beishu"]))

            print("-----t111:", self._initChioseAllPoints[i])
            print("-----t:", t)
            print("-----x:", x)
            print("-----s:", x / self.brnnGameManager.gameDetailInfoTab["beishu"])

            if x / self.brnnGameManager.gameDetailInfoTab["beishu"] < self._initChioseAllPoints[i] then
                self._coinBtns[i]:setEnabled(false)
            else
                isCan = true
            end
        end
    end

    if isCan == false then
        self.xuTouBtn:setEnabled(false);
    end
end


---取一个数整数
function BrnnGameScene:getIntPart(x)
    if x <= 0 then
       return math.ceil(x);
    end

    if math.ceil(x) == x then
       x = math.ceil(x);
    else
       x = math.ceil(x) - 1;
    end
    return x;
end

--- 还原桌子上面有多少筹码
function BrnnGameScene:showXuTouChipIcon(k, v, isMyBet)
    local data = clone(self._initChioseAllPoints)  or {}
    table.sort(data, function(a, b)
        return a > b
    end)

    for kk, vv in ipairs(data) do
        if vv <= 0 then break end

        local over = v % vv
        local num = math.floor(v / vv)

        for i = 1, num do
            if isMyBet == true then
                self:showCoin(k, vv, 0)
            else
                self:coinMoveTo(k, vv)
            end
        end
		
		if num >= 2 then
			MusicAndSoundManager:getInstance():playerSoundWithFile("brnnSound/multybet.mp3")
		end
		

        if over < data[#data] then
            break
        end

        v = over
    end
end



----更新下注信息
function BrnnGameScene:updateMyStakeData()

    ---更新自己的钱
    local myMoney = CustomHelper.moneyShowStyleAB(self.brnnGameManager:getDataManager():getMyMoney())
    self.playerCoin:setString(myMoney)

    ---更新每个区域自己下的注
    if self.brnnGameManager:getDataManager():getMyMoenyBet() == true then

        ---本轮没有续投过 才能打开续投按钮
        if self._isXutou == false then
            ---self.xuTouBtn:setEnabled(true);
        end

        local stakeData = self.brnnGameManager:getDataManager():getAreaMeCoins()
        for k,v in pairs(stakeData) do
            self._areaMeCoinLabs[k]:setString(CustomHelper.moneyShowStyleNone(v))  
        end

        --本次下注
         local stakeData1 = self.brnnGameManager:getDataManager():getCurrentAreaMoeny();
         for k,v in pairs(stakeData1) do
			
			if self.willCoin == nil then
				self.willCoin = 0
			end
			self.willCoin = self.willCoin-v
			if self.willCoin < 0 then
				self.willCoin = 0
			end
			--[[
             if v == self._initChioseAllPoints[1] then
                 self:showCoin(k,v,self._chipMoveTime)
             elseif v == self._initChioseAllPoints[2] then
                 self:showCoin(k,v,self._chipMoveTime)
             elseif v == self._initChioseAllPoints[3] then
                 self:showCoin(k,v,self._chipMoveTime)
             elseif v == self._initChioseAllPoints[4] then
                 self:showCoin(k,v,self._chipMoveTime)
             elseif v == self._initChioseAllPoints[5] then
                 self:showCoin(k,v,self._chipMoveTime)
			 else
                self:showXuTouChipIcon(k,v,true)
             end
			--]]
         end
    else ---其它人下的注
        local stakeData = self.brnnGameManager:getDataManager():getCurrentAreaMoeny()
        for k,v in pairs(stakeData) do
            ---动画
            if v == self._initChioseAllPoints[1] then
                self:coinMoveTo(k,v)
            elseif v == self._initChioseAllPoints[2] then
                self:coinMoveTo(k,v)
            elseif v == self._initChioseAllPoints[3] then
                self:coinMoveTo(k,v)
            elseif v == self._initChioseAllPoints[4] then
                self:coinMoveTo(k,v)
            elseif v == self._initChioseAllPoints[5] then
                self:coinMoveTo(k,v)
            else
               self:showXuTouChipIcon(k,v,false)
            end
        end
    end
end

----更新每个区域总
function BrnnGameScene:updateEachTranslateTotalMoeny(isEnterIntoGame)

    ---更新每个区域的总注
    local stakeData = self.brnnGameManager:getDataManager():getEachTranslateTotalMoeny()
    for k,v in pairs(stakeData) do
        if isEnterIntoGame == true then
            if v == self._initChioseAllPoints[1] then
                self:coinMoveTo(k,v)
            elseif v == self._initChioseAllPoints[2] then
                self:coinMoveTo(k,v)
            elseif v == self._initChioseAllPoints[3] then
                self:coinMoveTo(k,v)
            elseif v == self._initChioseAllPoints[4] then
                self:coinMoveTo(k,v)
            elseif v == self._initChioseAllPoints[5] then
                self:coinMoveTo(k,v)
            else
               self:showXuTouChipIcon(k,v,false)
            end
            self._areaCoinLabs[k]:setString(CustomHelper.moneyShowStyleNone(v))
        else
            self._areaCoinLabs[k]:setString(CustomHelper.moneyShowStyleNone(v))
        end
    end
end

----更新还能下注多少
function BrnnGameScene:initMaxBetScore()

    local panel_score = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "panel_score"), "ccui.Layout");
    local max_bet_scoreValueText = tolua.cast(CustomHelper.seekNodeByName(panel_score, "max_bet_scoreValueText"), "ccui.Text");
    local max_betMoeny = CustomHelper.moneyShowStyleNone(self.brnnGameManager:getDataManager():getTotalAllAreaBetMoeny())
    max_bet_scoreValueText:setString(max_betMoeny)

    ---剩余下注
    local left_money_betValueText = tolua.cast(CustomHelper.seekNodeByName(panel_score, "left_money_betValueText"), "ccui.Text");
    local left_money = CustomHelper.moneyShowStyleNone(self.brnnGameManager:getDataManager():getLeftMoenyBet())
    left_money_betValueText:setString(left_money)

    ----如果是系统当庄 就不显示剩余下注
    if self._isSystemBanker == true then
        left_money_betValueText:setString("--")
    end
end


----更新桌面状态
function BrnnGameScene:updateTabelState()
    
    for i=1,4 do
        self._areaCoinLabs[i]:setString(0)
        self._areaMeCoinLabs[i]:setString(0)
    end
    print("self._table:removeAllChildren()-2")
	self:stopActionByTag(100)
    self._table:removeAllChildren();

    local bankerInfo = self.brnnGameManager:getDataManager():getBankerInfo()
    local myInfo = self.brnnGameManager:getDataManager():getMyUserInfo()
    if bankerInfo ~= nil then
        ---自己不是庄家 申请上庄可点击
        if myInfo~=nil and (myInfo["guid"] ~= bankerInfo["guid"]) then
            --self.bankerOn:setEnabled(true)
        end
    end
    if self.panel_gameOver then
        --增加是否弹出维护通知

        self.panel_gameOver:setVisible(false)
    end
    self._tableCoinSprite = {}
end

----设置比赛使用硬币的大小
function BrnnGameScene:setInitChioseAllPoints(nums)
    dump(nums,"setInitChioseAllPoints")
    if #nums <=0 or nums == nil then
        return;
    end
    for i=1,5 do
        self._initChioseAllPoints[i]=nums[i]
    end
	
	for i=1, 5 do
		if self._coinBtns[i] ~= nil then
            local label = self._coinBtns[i]:getChildByName("AtlasLabel_num")
			label:setString(CustomHelper.moneyShowStyleNone(nums[i]))
            label:setScale(math.min(1,78 / label:getContentSize().width))
		end
        
        
    end
	
	
end

----选择金币
function BrnnGameScene:userCoin(num)
    if num == 1 then
        self._userCoin= CustomHelper.getFullPath("game_res/zh_brnn_chouma7.png") 
    elseif num == 2 then
        self._userCoin= CustomHelper.getFullPath("game_res/zh_brnn_chouma8.png")
    elseif num == 3 then
        self._userCoin= CustomHelper.getFullPath("game_res/zh_brnn_chouma9.png")
    elseif num == 4 then
        self._userCoin= CustomHelper.getFullPath("game_res/zh_brnn_chouma10.png")
    elseif num == 5 then
        self._userCoin= CustomHelper.getFullPath("game_res/zh_brnn_chouma11.png")
    end
   
    self._coinChoice = self._initChioseAllPoints[num]
	local tt = self._coinChoice
	
	local aa = 0
end

----玩家下硬币动画
function BrnnGameScene:showCoin(area, coin,time)
	if self.willCoin == nil then
		self.willCoin = 0
	end
	self.willCoin = self.willCoin+coin
	
    local sp1=cc.Sprite:create(self:getChipIcon(coin))
    self._table:addChild(sp1)
	
	local t1 = self.csNode:getChildByName("AtlasLabel_1"):clone()
	t1:setString( CustomHelper.moneyShowStyleNone(coin) )
    t1:setScale(math.min(30 / t1:getContentSize().width ,1))
	sp1:addChild(t1)
	t1:setPosition(cc.p(24,25) )

    --设置硬币初始位置
    for i=1,5 do
        if coin == self._initChioseAllPoints[i] then
            sp1:setPosition(self._coinBtns[i]:getPosition())
            table.insert(self._chipSprite, sp1);
            break;
        end
    end
    if area == 1 or area == 4 then
        time = time*0.3
    end
    self:coinPosMove(sp1, area,time,true)
	
	self:updateChipBtnTouch()
end
----其他人下注筹码
----参数1，ID起始,2，移动到的区域,3，金币数
function BrnnGameScene:coinMoveTo(num,coin)
    -- 添加随机的下注，增强下注动画效果 --
    local time = self._chipMoveTime
    if num == 1 or num == 4 then
        time = time * 0.3
    end
    --AtlasLabel_1
    local sp1 = cc.Sprite:create(self:getChipIcon(coin))
    self._table:addChild(sp1)
    sp1:setPosition(self:getCoinMoveFromPt()) --设置起始位置

    local t1 = self.csNode:getChildByName("AtlasLabel_1"):clone()
    t1:setString(CustomHelper.moneyShowStyleNone(coin))
    t1:setScale(math.min(30 / t1:getContentSize().width, 1))
    sp1:addChild(t1)
    t1:setPosition(cc.p(24, 25))

    self:coinPosMove(sp1, num, time)
end


----下注硬币移动coin移动
function BrnnGameScene:coinPosMove(sp1,num,time,ismy)
    --创建随机位置
    local isnumx=math.random(1,10)
    local isnumy=math.random(1,10)
    local numx=math.random(0,60)--60
    local numy=math.random(0,60)--30
    if isnumx<=5 then
        numx=numx*(-1)
    end
    if isnumy<=5 then
        numy=numy*(-1)
    end

    --根据点击设置位置
    local cX=sp1:getPositionX()
    local cY=sp1:getPositionY()
    local sp=1150
    local time=0
    if num==1 then
        numx=330+numx
        numy=480+numy
    elseif num==2 then
        numx=500+numx
        numy=340+numy
    elseif num==3 then
        numx=753+numx
        numy=340+numy
    elseif num==4 then
        numx=950+numx
        numy=480+numy
    end
    time=math.sqrt((numx-cX)*(numx-cX)+(numy-cY)*(numy-cY))/sp

    --print("time:",time)
    --播放音效
    local function unReversal1()
        --下注
       --BrnnGameScene:playsound("brnnSound/"..gameBrnn.Sound.brnn_ct_wuxiaoniu)
		if ismy == true then
			MusicAndSoundManager:getInstance():playerSoundWithFile("brnnSound/onebet.mp3")
			--BrnnGameScene:playsound("brnnSound/onebet.mp3")
		else
			BrnnGameScene:playsound("brnnSound/onebet.mp3")
		end
    end

    local callfunc1 = cc.CallFunc:create(unReversal1)
    sp1:runAction(cc.Sequence:create(cc.MoveTo:create(time,cc.p(numx,numy)),callfunc1))

end

function BrnnGameScene:getChipIcon(coin)
    local icon = CustomHelper.getFullPath("game_res/zh_brnn_chouma7.png")
    if coin == self._initChioseAllPoints[1] then
        icon = CustomHelper.getFullPath("game_res/zh_brnn_chouma7.png") 
    elseif coin == self._initChioseAllPoints[2] then
        icon = CustomHelper.getFullPath("game_res/zh_brnn_chouma8.png")
    elseif coin == self._initChioseAllPoints[3] then
        icon = CustomHelper.getFullPath("game_res/zh_brnn_chouma9.png")
    elseif coin == self._initChioseAllPoints[4] then
        icon = CustomHelper.getFullPath("game_res/zh_brnn_chouma10.png")
    elseif coin == self._initChioseAllPoints[5] then
        icon = CustomHelper.getFullPath("game_res/zh_brnn_chouma11.png")
    end
    --print("icon:",icon)
    return  icon
end



function BrnnGameScene:getCoinMoveFromPt()
    --随机区域，左边为区域1，下面为区域2，右边为区域3
    local ranNum = math.random(3)
    if ranNum == 1 then
        return cc.p(100, math.random(600))
    elseif ranNum == 2 then
        return cc.p(math.random(1200), 100)
    elseif ranNum == 3 then
        return cc.p(1150, math.random(600))
    end
    return cc.p(640, 800)
end


--发牌逻辑
-------------------------------------发牌动画---------------------------------------------------------------
function BrnnGameScene:dealMessage()
    ----关闭规则界面
    if self.gameTipsLayer~=nil then
        self:removeChild(self.gameTipsLayer)
        self.gameTipsLayer = nil
    end
    local zhuangCards = {};
    local tianCards = {};
    local diCards = {}
    local xuanCards = {}
    local huangCards = {};

    local fapainode = self.csNode:getChildByName("fapaiqi")
    --fapainode:setVisible(true)

    local x = 300
    local y = 430
    local time = 0
    local cards  = self.brnnGameManager:getDataManager():getCards()
    for i=1,5 do
       for _i,v in ipairs(cards) do
            local  card_v = v[i]
            local pokercard = NNPoker.new(false, card_v)
            pokercard:setScale(0.4)
            pokercard:setVisible(true)
            pokercard:setPosition(cc.p(200, 600))
            self._table:addChild(pokercard,20+i)
			
			if i == 5 then
				pokercard:addAnimation()
			end
			
            time = time+0.1
            if _i == 1 then
                x = 1280*0.5-60 +20*i;
                y = 550
                 table.insert(zhuangCards, pokercard)
            else
                y = 330
                if _i == 2 then
                    x = 168+20*i
                    table.insert(tianCards, pokercard)
                elseif _i == 3 then
                    x = 315+20*i
                    y = 227
                    table.insert(diCards, pokercard)
                elseif _i == 4 then
                    x = 830+20*i
                    y = 227
                    table.insert(xuanCards, pokercard)
                elseif _i == 5 then
                    x = 1000+20*i
                    table.insert(huangCards, pokercard)
                end
            end
            if self._gameEnterGameState == 3 then
				--明牌
				if i ~= 5 then
					pokercard:showTexture()
				else
					pokercard:setRotation(90)
				end
                pokercard:setPosition(cc.p(x,y))
            else
                local move = cc.MoveTo:create(0.2,cc.p(x,y))
				
				
                local seq = cc.Sequence:create( cc.DelayTime:create(time),
                                                cc.CallFunc:create(function()
                                                    MusicAndSoundManager:getInstance():playerSoundWithFile("brnnSound/fapai.mp3")
													
													--明牌
													if i ~= 5 then
														pokercard:showTexture()
													else
														pokercard:setRotation(90)
													end
													
                                                end),move)

                pokercard:runAction(seq)
            end
       end
    end

    -------------------------------------翻牌动画---------------------------------------------------------------
    self.addAction = false
    local function opengZhuangCards() ---true 不添加动画 false 添加动画
        for i,v in ipairs(zhuangCards) do
            zhuangCards[i]:openBackAction(self.addAction)
        end
        self:niuniuShow(1,cc.p(1280*0.5,540)) 
    end

    local function opengTianCards()
        for i,v in ipairs(tianCards) do
            tianCards[i]:openBackAction(self.addAction)
        end
        self:niuniuShow(2,cc.p(230,320))
    end

    local function opengDiCards()
        for i,v in ipairs(diCards) do
            diCards[i]:openBackAction(self.addAction)
        end
        self:niuniuShow(3,cc.p(375,217))
    end

    local function opengXuanCards()
        for i,v in ipairs(xuanCards) do
            xuanCards[i]:openBackAction(self.addAction)
        end
        self:niuniuShow(4,cc.p(890,217))
    end

    local function opengHuangCards()
        for i,v in ipairs(huangCards) do
            huangCards[i]:openBackAction(self.addAction)
        end
        self:niuniuShow(5,cc.p(1060,320))
    end

    local function showWinActoin()
        self._areaWinActionNode = {}
        local isHave = false
        local compareResult  = self.brnnGameManager:getDataManager():getCompareResult()
        ---动画区域是从左到右 3 1 2 4
        ---天地玄黄 1 2 3 4
        local _areaActoinNum = 1
        for i,v in ipairs(compareResult) do
            local result = v["result"]
            local area = v["area_"]
            if result == true then
                isHave = true
                if area == 1 then  
                    _areaActoinNum = 3
                elseif area == 2 then
                    _areaActoinNum = 1
                elseif area == 3 then
                    _areaActoinNum = 2
                elseif area == 4 then
                    _areaActoinNum = 4
                end
                self:showAreaWinAction(_areaActoinNum)
            end
        end
        if isHave == true then
            self._showAreaActionTime = 0
            self._starAreaWinAction = true
        end
    end 

    local delayTime1 = 0.5
    local delayTime2 = 1
    ---如果进来就是开牌状态 就不要动画
    if self._gameEnterGameState == 3 then
        self.addAction = false
        opengZhuangCards()
        opengTianCards()
        opengDiCards()
        opengXuanCards()
        opengHuangCards()
    else
        self.addAction = true
        local fun1 = cc.CallFunc:create(opengZhuangCards)
        local fun2 = cc.CallFunc:create(opengTianCards)
        local fun3 = cc.CallFunc:create(opengDiCards)
        local fun4 = cc.CallFunc:create(opengXuanCards)
        local fun5 = cc.CallFunc:create(opengHuangCards)
        local fun6 = cc.CallFunc:create(showWinActoin)
        local seq = cc.Sequence:create(cc.DelayTime:create(time+delayTime1),fun1,
                                       cc.DelayTime:create(delayTime2),fun2,
                                       cc.DelayTime:create(delayTime2),fun3,
                                       cc.DelayTime:create(delayTime2),fun4,
                                       cc.DelayTime:create(delayTime2),fun5,cc.DelayTime:create(delayTime1+2),fun6)
		seq:setTag(100)
        self:runAction(seq)
    end
    self:gameEnd();
end


----牛牛展示
function BrnnGameScene:niuniuShow(index,pot)

    local function niuniuTypeShow()
        local sp = cc.Sprite:create()
        local data = self.brnnGameManager:getDataManager():getCardsTypeResult()
        local info = data[index]

        local card_type = info["card_type"]
        local card_times = info["card_times"]
        --有牛
        if card_type == BrnnGameManager.CardType.OX_CARD_TYPE_OX_ONE then

            local num = (card_times)
            sp:setTexture(CustomHelper.getFullPath("game_res/niuniupic/zh_brnn_niu"..num..".png"))
            local soundKey  = "brnn_ct_niu_"..num..".mp3"
            if self.addAction == true then
                MusicAndSoundManager:getInstance():playerSoundWithFile("brnnSound/"..soundKey)
            end
    
        --牛牛
        elseif card_type == BrnnGameManager.CardType.OX_CARD_TYPE_OX_TWO then
            sp:setTexture(CustomHelper.getFullPath("game_res/niuniupic/zh_brnn_niuniu.png"))
            if self.addAction == true then
                MusicAndSoundManager:getInstance():playerSoundWithFile("brnnSound/"..gameBrnn.Sound.brnn_ct_niuniu)
            end
            
        --4花牛    
        elseif card_type == BrnnGameManager.CardType.OX_CARD_TYPE_FOUR_KING then
            sp:setTexture(CustomHelper.getFullPath("game_res/niuniupic/zh_brnn_sihuaniu.png"))
            if self.addAction == true then
                MusicAndSoundManager:getInstance():playerSoundWithFile("brnnSound/"..gameBrnn.Sound.brnn_ct_sihuaniu)
            end
            
        --5花牛   
        elseif card_type == BrnnGameManager.CardType.OX_CARD_TYPE_FIVE_KING then
            sp:setTexture(CustomHelper.getFullPath("game_res/niuniupic/zh_brnn_wuhuaniu.png"))
            if self.addAction == true then
                MusicAndSoundManager:getInstance():playerSoundWithFile("brnnSound/"..gameBrnn.Sound.brnn_ct_niuking)
            end
            
        --4炸   
        elseif card_type == BrnnGameManager.CardType.OX_CARD_TYPE_FOUR_SAMES then
            sp:setTexture(CustomHelper.getFullPath("game_res/niuniupic/zh_brnn_zhandanniu.png"))
            if self.addAction == true then
                MusicAndSoundManager:getInstance():playerSoundWithFile("brnnSound/"..gameBrnn.Sound.brnn_ct_bomebome)
            end
            
        --5小牛
        elseif card_type == BrnnGameManager.CardType.OX_CARD_TYPE_FIVE_SAMLL then
            sp:setTexture(CustomHelper.getFullPath("game_res/niuniupic/zh_brnn_wuxiaoniu.png"))  
            if self.addAction == true then
                MusicAndSoundManager:getInstance():playerSoundWithFile("brnnSound/"..gameBrnn.Sound.brnn_ct_wuxiaoniu)
            end
            
        --无牛
        elseif card_type == BrnnGameManager.CardType.OX_CARD_TYPE_OX_NONE then
            sp:setTexture(CustomHelper.getFullPath("game_res/niuniupic/zh_brnn_wuniu.png")) 
            if self.addAction == true then
                MusicAndSoundManager:getInstance():playerSoundWithFile("brnnSound/"..gameBrnn.Sound.brnn_ct_none)
            end
             
        end
        sp:setScale(1)
        self._table:addChild(sp, 50)
        sp:setPosition(pot)
    end

    if self.addAction == true then
        local seq = cc.Sequence:create(cc.DelayTime:create(1.5),cc.CallFunc:create(niuniuTypeShow))
        self:runAction(seq)  
    else
        niuniuTypeShow();
    end
end


function BrnnGameScene:showAreaWinAction(ActionNum)
    if self.brnnGameManager:getDataManager():getGameStates() ~= 3 then
        return;
    end
    local aniFile = "dkj_brnn_ui"
    local aniName = "ani_0"..ActionNum
    
    local node = ccs.Armature:create(aniFile)
    node:getAnimation():setMovementEventCallFunc(function(sender, _type, id)
        if _type == ccs.MovementEventType.start then
        elseif _type == ccs.MovementEventType.complete then
        elseif _type == 2 then
        end
    end)
    node:getAnimation():play(aniName)
    self._table:addChild(node)
    if ActionNum == 1 then
        self.ani_1 = 0;
        node:setPosition(cc.p(404.5, 328))
    elseif ActionNum == 2 then
        self.ani_2 = 0;
        node:setPosition(cc.p(872.5, 328))
    elseif ActionNum == 3 then
        self.ani_3 = 0;
        node:setPosition(cc.p(328, 375))
    elseif ActionNum == 4 then
        self.ani_4 = 0;
        node:setPosition(cc.p(953, 375))
    end
    table.insert(self._areaWinActionNode, node)
end


----游戏结束
function BrnnGameScene:gameEnd()
    --结算动画

    local time = self._gameStatuTime - 5

    local function unReversal()
        if self.brnnGameManager:getDataManager():getGameStates() ~= 3 then
            return;
        end
        -- self.gameEnd = BrnnGameEnd:create()
        -- self.gameEnd:setTag(999999)
        -- self.gameEnd:show(self.brnnGameManager:getDataManager():getGameEndData())
        -- self:addChild(self.gameEnd, 100)

        ---
        self.timeImg:loadTexture(CustomHelper.getFullPath("game_res/stockDater.png"))

        ---更新庄家信息
        self:initBankerInfo(true)

        ---更新8位用户 
        self:updatePlayerIcon()


        self.panel_gameOver = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "panel_gameOver"), "ccui.Layout")
        self.panel_gameOver:setAnchorPoint(cc.p(0.5,0.5))
        self.panel_gameOver:setPosition(cc.p(1280*0.5,720*0.5));

        local gameOverBg = tolua.cast(CustomHelper.seekNodeByName(self.panel_gameOver, "gameoverBg"), "ccui.ImageView")
       
        ---设置钱
        local myMoney = CustomHelper.moneyShowStyleAB(self.brnnGameManager:getDataManager():getMyMoney())
        self.playerCoin:setString(myMoney)


        local gameEndInfo = self.brnnGameManager:getDataManager():getGameEndData()

        ----图标
        local gameOverTypeIcon = tolua.cast(CustomHelper.seekNodeByName(self.panel_gameOver, "gameOverTypeIcon"), "ccui.ImageView")
        if gameEndInfo["all_win_or_lose_flag"] == 1 then ---通杀
            gameOverTypeIcon:loadTexture(CustomHelper.getFullPath("game_res/zh_brnn_tongsha.png"))
        elseif gameEndInfo["all_win_or_lose_flag"] == 2 then ---通赔
            gameOverTypeIcon:loadTexture(CustomHelper.getFullPath("game_res/zh_brnn_tongpei.png"))
        else
            gameOverTypeIcon:loadTexture(CustomHelper.getFullPath("game_res/zh_brnn_jiesuan.png"))
        end
            
        ----自己的输赢
        local myChip = tolua.cast(CustomHelper.seekNodeByName(self.panel_gameOver, "myChip"), "ccui.Text");
        local earn_score = gameEndInfo["earn_score"] or 0
        myChip:setString(earn_score)
        myChip:setColor(cc.c3b(255,0,0))
        if earn_score >= 0  then
            myChip:setColor(cc.c3b(255,231,141))
            myChip:setString(CustomHelper.moneyShowStyleNone(earn_score))
            if earn_score > 0 then
                MusicAndSoundManager:getInstance():playerSoundWithFile("brnnSound/"..gameBrnn.Sound.brnnWin)
            end
        elseif earn_score < 0   then
            myChip:setString(CustomHelper.moneyShowStyleNone(earn_score))
            MusicAndSoundManager:getInstance():playerSoundWithFile("brnnSound/"..gameBrnn.Sound.brnnLose)
        end

        ----庄家的输赢
        local zhuangChip = tolua.cast(CustomHelper.seekNodeByName(self.panel_gameOver, "zhuangChip"), "ccui.Text");
        local banker_score = gameEndInfo["banker_score"] or 0
        zhuangChip:setString(banker_score)
        zhuangChip:setColor(cc.c3b(255,0,0))
        if banker_score >= 0  then
            zhuangChip:setColor(cc.c3b(255,231,141))
            zhuangChip:setString(CustomHelper.moneyShowStyleNone(banker_score))
        elseif banker_score < 0 then
            zhuangChip:setString(CustomHelper.moneyShowStyleNone(banker_score))
        end

        ----税
        self.taxText = tolua.cast(CustomHelper.seekNodeByName(self.panel_gameOver, "taxText"),"ccui.Text");
        self.taxText:setVisible(false);

        local tax_show_flag = gameEndInfo["tax_show_flag"] or 0
        if gameEndInfo["system_tax"] ~= nil and tax_show_flag == 1 then
            self.taxText:setVisible(true)
            self.taxText:setString("扣税:"..CustomHelper.moneyShowStyleNone(gameEndInfo["system_tax"]));
        end

        gameOverBg:setScale(0)
        local scale = cc.ScaleTo:create(0.3,1)
        self.panel_gameOver:setVisible(true)
        gameOverBg:runAction(scale)
    end

    local function removeEndUI()
        -- self:removeChild(self.gameEnd, true)
        -- self.gameEnd = nil
        self.panel_gameOver:setVisible(false)
    end

    local callfunc = cc.CallFunc:create(unReversal)

    local callfuncEnd = cc.CallFunc:create(removeEndUI)--,cc.DelayTime:create(4.0),callfuncEnd
    if self._gameEnterGameState ~= 3 then
        self:runAction(cc.Sequence:create(cc.DelayTime:create(10),callfunc))
    else
        ---更新庄家信息
        self:initBankerInfo(true)

        ---更新8位用户 
        self:updatePlayerIcon()
        unReversal()
        --self:runAction(callfunc)
        --self:runAction(cc.Sequence:create(cc.DelayTime:create(1.0),callfunc,cc.DelayTime:create(4.0),callfuncEnd))
    end
end
return BrnnGameScene