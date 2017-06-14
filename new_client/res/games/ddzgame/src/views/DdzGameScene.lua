import(".DdzConfig")
local SubGameBaseScene = requireForGameLuaFile("SubGameBaseScene")
local DdzGameScene = class("DdzGameScene",SubGameBaseScene);
local scheduler = cc.Director:getInstance():getScheduler()
local DeviceUtils = requireForGameLuaFile("DeviceUtils")
local OTHER_CARD_INTERVAL = 30
local MY_CARD_INTERVAL = 50
local MY_CARD_SCALE = 0.8
local OTHER_CARD_SCALE = 0.6

local ZORDER_PRIVATE_ROOM = 10
local ZORDER_MENU = 11

----初始化要加载的资源
function DdzGameScene.getNeedPreloadResArray()
    -- body
    local  res = {
        -- CustomHelper.getFullPath("anim/ddz_aircraft_eff/ddz_aircraft_eff.ExportJson"),
        -- CustomHelper.getFullPath("anim/ddz_bomb_eff/ddz_bomb_eff.ExportJson"),
        -- CustomHelper.getFullPath("anim/ddz_loong_eff/ddz_loong_eff.ExportJson"),
        -- CustomHelper.getFullPath("anim/ddz_rocket_eff/ddz_rocket_eff.ExportJson"),
        -- CustomHelper.getFullPath("anim/ddz_straight_eff/ddz_straight_eff.ExportJson"),
        ---CustomHelper.getFullPath("anim/ddz_ui_eff/ddz_ui_eff.ExportJson"),

        CustomHelper.getFullPath("anim/ddz_new_man_ani/ddz_new_man_ani.ExportJson"),
        CustomHelper.getFullPath("anim/ddz_new_woman_ani/ddz_new_woman_ani.ExportJson"),
        CustomHelper.getFullPath("anim/dkj_ddz_paixing_eff.ExportJson"),
        CustomHelper.getFullPath("game_res/bg_result.png"),
        CustomHelper.getFullPath("game_res/bg_tip.png"),
        CustomHelper.getFullPath("game_res/icon_background.png"),
        CustomHelper.getFullPath("game_res/icon_desktop.png"),
        CustomHelper.getFullPath("game_res/info/ddz_tanchuang_dikuang.png"),
        CustomHelper.getFullPath("game_res/ddz_tuoguan_zhezao.png"),
        CustomHelper.getFullPath("game_res/icon_card_tip.png")
    }
    return res
end


---消息超时
function DdzGameScene:receiveMsgRequestErrorEvent(event)
    DdzGameScene.super.receiveMsgRequestErrorEvent(self,event)
end

----注册消息
function DdzGameScene:registerNotification()
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_Ready) ---准备消息
    self:addOneTCPMsgListener(DdzGameManager.MsgName.SC_NotifySitDown) ----通知坐下
    self:addOneTCPMsgListener(DdzGameManager.MsgName.SC_NotifyStandUp) ----同桌站起
    self:addOneTCPMsgListener(DdzGameManager.MsgName.SC_LandStart) ---发牌
    self:addOneTCPMsgListener(DdzGameManager.MsgName.SC_LandCallScore) ---叫分
    self:addOneTCPMsgListener(DdzGameManager.MsgName.SC_LandInfo) ---地主信息
    self:addOneTCPMsgListener(DdzGameManager.MsgName.SC_LandCallDouble) --加倍
    self:addOneTCPMsgListener(DdzGameManager.MsgName.SC_LandCallDoubleFinish) ---加倍后第一个出牌玩家
    self:addOneTCPMsgListener(DdzGameManager.MsgName.SC_LandOutCard) ---出牌
    self:addOneTCPMsgListener(DdzGameManager.MsgName.SC_LandPassCard) ----不出
    self:addOneTCPMsgListener(DdzGameManager.MsgName.SC_LandConclude) ----游戏结束
    self:addOneTCPMsgListener(DdzGameManager.MsgName.SC_LandTrusteeship) ---托管
    self:addOneTCPMsgListener(DdzGameManager.MsgName.SC_PlayerReconnection) --- 断线重连玩具数据
    self:addOneTCPMsgListener(DdzGameManager.MsgName.SC_LandRecoveryPlayerCard) ---断线重连 牌数据
    self:addOneTCPMsgListener(DdzGameManager.MsgName.SC_LandRecoveryPlayerCallScore) --
    self:addOneTCPMsgListener(DdzGameManager.MsgName.SC_LandRecoveryPlayerDouble) ---断线重连 加倍情况
    self:addOneTCPMsgListener(DdzGameManager.MsgName.SC_ChangeTable) ---切换桌子
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_StandUpAndExitRoom)---退出房间
    self:addOneTCPMsgListener(DdzGameManager.MsgName.SC_PrivateConfigChange)  ---私人房间设置
    self:addOneTCPMsgListener(DdzGameManager.MsgName.SC_TabVoteInfo)  ---私人房间投票
    self:addOneTCPMsgListener(DdzGameManager.MsgName.SC_TotalScoreInfo)  -- 私人房间结算
    self:addOneTCPMsgListener(DdzGameManager.MsgName.SC_TabVoteArray)  -- 私人房间投票信息
    self:addOneTCPMsgListener(DdzGameManager.MsgName.SC_TickNotify)  -- 私人房间通知踢人

    self:addOneTCPMsgListener(DdzGameManager.MsgName.CS_LandOutCard,{DdzGameManager.MsgName.SC_LandOutCard})
    DdzGameScene.super.registerNotification(self);
end


function DdzGameScene:receiveServerResponseSuccessEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    print("[DdzGameScene] msgName:%s", msgName)

    ---收到准备消息
    if msgName == HallMsgManager.MsgName.SC_Ready then
        self:showPlayerSitDownInfo()

        if GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateRoom() then
            if self._ddzReadyView then
                self._ddzReadyView:showListView()
            end
        end

    ----切换桌子
    elseif MsgName == DdzGameManager.MsgName.SC_ChangeTable then

        MyToastLayer.new(self, "切换桌子成功!")

        self:showPlayerSitDownInfo()

        for i=1,3 do
            self:OnPlayerExit(i)
        end

    ---通知同桌坐下 ---刷新界面
    elseif msgName == DdzGameManager.MsgName.SC_NotifySitDown then
        self:showPlayerSitDownInfo()

        if GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateRoom() then
            if self._ddzReadyView then
                self._ddzReadyView:showListView()
            end
        end

    ---同桌站起
    elseif msgName == DdzGameManager.MsgName.SC_NotifyStandUp then
        
        local info  = self._logic:getNotifySitDown()
        if self._logic._isPlaying == true then
            return
        end

        for k,v in pairs(self._logic._chairs) do
            if v:getGameState() == gameDdz.US_PLAYING then
                break
            end
            if v:getChairId() == info.chair_id and self._logic._userInfo:getChairId() ==  info.chair_id then
                self:jumpToHallScene()
            else
                self:OnPlayerExit(self._logic:ConvertChairIdToIndex(info.chair_id))

                if GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateRoom() then
                    GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():removeChair(info.chair_id)
                end
            end
        end

        -- 私人房间处理
        if GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateRoom() then
            if self._ddzReadyView then
                self._ddzReadyView:showListView()
            end
        end

    ----发牌
    elseif msgName == DdzGameManager.MsgName.SC_LandStart then

        self:UpdateMul(0)
        
        self:UpdateCardRecord();

        self:OnGameStart(msgTab)

    ---用户叫分
    elseif msgName == DdzGameManager.MsgName.SC_LandCallScore then

        ---更新倍数
        self:UpdateMul(self._logic:getCallDouble());
        local info = self._logic:getLandCallScoreMsg()
        local call_score = info.call_score or 0
        if info["call_chair_id"] ~= nil then

             self:OnGameCalled(self._logic:ConvertChairIdToIndex(info.call_chair_id),call_score)

            ---当前叫分玩家
            if info.cur_chair_id ~= nil then
                self:OnGameCallLand(self._logic:ConvertChairIdToIndex(info.cur_chair_id),self._logic._callScore)
            end
        end
    
    ----地主
    elseif msgName == DdzGameManager.MsgName.SC_LandInfo then

        local info = self._logic:getLandInfo()
        ---更新倍数
        self:UpdateMul(self._logic:getCallDouble());

        ---显示动画
        self:_doAni_DealLandCard(self._logic:ConvertChairIdToIndex(self._logic._LandChairId), info.cards)

        ---设置地主牌
        self:OnGameSetLand(self._logic:ConvertChairIdToIndex(self._logic._LandChairId))

        ---设置显示双倍按钮
        if self._logic._LandChairId == self._logic._myChairId then

            self:OnGameSetDouble(true,true)
        else
            self:OnGameSetDouble(true,false)
        end

    ----加倍
    elseif msgName == DdzGameManager.MsgName.SC_LandCallDouble then

        local callDoubleInfo  = self._logic:getLandCallDouble();

        self:showPlayerDoubleIcon(self._logic:ConvertChairIdToIndex(callDoubleInfo.call_chair_id),callDoubleInfo["is_double"],0,false)

        local index = self._logic:getNextDoubleUser()
        print("index:",index);
        if  index ~= 0 and index ~= nil then
            self:DoCountDown(15, index, "call_double")
        end
    
    ----加倍后第一个出牌玩家
    elseif msgName == DdzGameManager.MsgName.SC_LandCallDoubleFinish then

        local info  = self._logic:getLandCallDoubleFinish()

        self:OnGameSetDouble(false)
        
        self:OnGameCall(self._logic:ConvertChairIdToIndex(info.land_chair_id), true,true)

    ----玩家出牌
    elseif msgName == DdzGameManager.MsgName.SC_LandOutCard then
        local info = self._logic:getGameOutCards();

        ----显示牌
        self:OnGamePlayerOutCard(info.indexOut,info.cards,self._logic._lastCardsTemp,self._logic._cardCount[info.out_chair_id],info.cur_chair_id == INVALID_CHAIR)
        
        ----更新玩家的牌
        self:UpdatePlayerCardNum(info.indexOut, self._logic._cardCount[info.out_chair_id])
        
        ---更新扑克记录
        self:UpdateCardRecord();

        ---更新倍数
        self:UpdateMul(self._logic:getCallDouble())

        ---谁出牌
        if info.cur_chair_id == info.out_chair_id then
        
            ----隐藏按钮
            self:setGameMenuVisible()
            self.OutCardScheduler = scheduler:scheduleScriptFunc(function(dt)
                self:onGameOverTure()
                self._logic._lastCardsTemp = nil
                self._logic._lastCards = nil
                self._logic._helpCards = nil
                if self._logic:IsGamePlaying() == true then
                    self:OnGameCall(info.index, true)
                end
                if self.OutCardScheduler then
                    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.OutCardScheduler)   
                    self.OutCardScheduler = nil
                end
            end, 1, false);
        else
            if info.cur_chair_id ~= INVALID_CHAIR then

                self:OnGameCall(info.index)
            end
        end

    ----放弃出牌 不出
    elseif msgName == DdzGameManager.MsgName.SC_LandPassCard then

        local info = self._logic:getPassOutCard()

        local turn_over = false
        if info.turn_over ~= nil then
            self:onGameOverTure();
            turn_over = true
        end

        local indexPass = self._logic:ConvertChairIdToIndex(info.pass_chair_id)

        ----放弃出牌
        self:OnGamePlayerOutCard(indexPass)

        if indexPass == 1 then

            ----选起的牌全都放下
            self:DoPutDownAllCards()
        
        end
        ----谁出牌
        self:OnGameCall(self._logic:ConvertChairIdToIndex(info.cur_chair_id),turn_over)

    ---游戏结束
    elseif msgName == DdzGameManager.MsgName.SC_LandConclude then

        local result = self._logic:getGameOverData()

        ---更新倍数
        self:UpdateMul(self._logic:getCallDouble())

        self:UpdateCardRecord()

        self:OnGameEnd(result)

    ---托管
    elseif msgName == DdzGameManager.MsgName.SC_LandTrusteeship then

        local info = self._logic:getUpdateHostingMsg()
        if info~=nil then
            self:OnUpdateHosting(self._logic:ConvertChairIdToIndex(info.chair_id), info.isTrusteeship or false)
        end


    ---断线重连玩家数据
    elseif msgName == DdzGameManager.MsgName.SC_PlayerReconnection then
        self:showPlayerSitDownInfo()

        --todo
    ----断线重连
    elseif msgName == DdzGameManager.MsgName.SC_LandRecoveryPlayerCard then

        local info = self._logic:getLandRecoveryPlayerCardMsg()

        self:UpdateMul(self._logic:getCallDouble())

        self:SetShowInfoVisable(false)

        for k,v in ipairs(info.pb_msg) do

            local chairId = v["chair_id"]

            self:OnUpdateHosting(self._logic:ConvertChairIdToIndex(chairId), v["isTrusteeship"])

            self:UpdatePlayerCardNum(self._logic:ConvertChairIdToIndex(chairId),self._logic._cardCount[chairId])
        end

        self:OnGameSetLand(self._logic:ConvertChairIdToIndex(self._logic._LandChairId))

        if self:getIsPanel_doubleVisible() == false then

            self:OnGameCall(self._logic:ConvertChairIdToIndex(info.outcardid), #self._logic._lastCards == 0)
        
        end
        
        ---更新扑克记录
        self:UpdateCardRecord()

        self:onGameStatusPlayer(info)

    ----叫分阶段掉线
    elseif msgName == DdzGameManager.MsgName.SC_LandRecoveryPlayerCallScore then

        local info = self._logic:getGameRecoveryPlayerCallScoreMsg()


        self:UpdateCardRecord()

        self:SetShowInfoVisable(false)

        for i = 1,3 do
            self:UpdatePlayerCardNum(i,17)
        end
        --self:initPanel_TimeoutWait(0)

        self:UpdateCardRecord()

        self:OnGameRecoveryPlayerCallScore(info)

        self:OnGameRecoveryShowLandPoker()

        ---更新倍数
        self:UpdateMul(self._logic:getCallDouble());

        local info = self._logic:getLandCallScoreMsg()

        local call_score = info.call_score or 0
        

        if info["call_chair_id"] ~= nil then

            self:OnGameCalled(self._logic:ConvertChairIdToIndex(info.call_chair_id),call_score)

            ---当前叫分玩家
            if info.cur_chair_id ~= nil then
                self:OnGameCallLand(self._logic:ConvertChairIdToIndex(info.cur_chair_id),self._logic._callScore)
            end
        elseif info["cur_chair_id"]~=nil then
            self:OnGameCallLand(self._logic:ConvertChairIdToIndex(info.cur_chair_id),0)
        end


    ----断线后加倍情况
    elseif msgName == DdzGameManager.MsgName.SC_LandRecoveryPlayerDouble then

        local info = self._logic:getLandRecoveryPlayerDoubleMsg()

        if info["pb_double_state"]~=nil then

            local double_count_down = info["double_count_down"] or 0

            for k,v in pairs( info["pb_double_state"]) do
                self:showPlayerDoubleIcon(self._logic:ConvertChairIdToIndex(v.chair_id),v["is_double"],double_count_down,true)
            end
            for k,v in pairs( info["pb_double_state"]) do

                if v["is_double"] == 3 and self._logic._LandChairId == self._logic._myChairId then

                    self:OnGameSetDouble(true,true)

                    self:setGaneDobleCountDown(10)

                    break
                end 
            end
        end

    elseif msgName == HallMsgManager.MsgName.SC_StandUpAndExitRoom then

        self:jumpToHallScene();

    ---游戏停服通知
    elseif msgName == HallMsgManager.MsgName.SC_GameMaintain then
        if self._logic:IsGamePlaying() == false and self._gameStatus == nil then
            self:isContinueGameConditions()
        end
    elseif msgName == DdzGameManager.MsgName.SC_PrivateConfigChange then
        print("[DdzGameScene] SC_PrivateConfigChange")
        dump(userInfo)
        if GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateRoom() then
            if userInfo["nreason"] == 1 then
                MyToastLayer.new(self, "房主新设定了房间属性，下局游戏生效。")
            else
                if self._ddzPropertyView then
                    self._ddzPropertyView:showListView(userInfo)
                else
                    if self:_isPrivateShowingReady() then
                        self:_showReadyView()
                    end
                end

                self:_showPrivateRoomId()
            end
        end
    elseif msgName == DdzGameManager.MsgName.SC_TabVoteInfo then
        print("[DdzGameScene] SC_TabVoteInfo")
        if GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateRoom() then
            if (userInfo["bret"]) then
                GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():setVoteInfo(userInfo)
                GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():setVoteOriginator(userInfo["vote_chairid"])
                if self._ddzDismissView then
                    self._ddzDismissView:showListView()
                else
                    self:_showDismissView()
                end
            else
                GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():cleanVoteInfo()
                GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():setVoteOriginator(0)
                if self._ddzDismissView then
                    self._ddzDismissView:removeSelf()
                    self._ddzDismissView = nil
                end

                local chairId = userInfo["chair_id"]
                MyToastLayer.new(self, string.format("%s拒绝解散房间", (GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getChairs()[chairId]):getNickName()))
            end
        end
    elseif msgName == DdzGameManager.MsgName.SC_TabVoteArray then
        print("[DdzGameScene] SC_TabVoteArray")
        dump(userInfo)
        if GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateRoom() then
            if userInfo["votechairid"] then
                GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():setVoteOriginator(userInfo["votechairid"])
            else
                GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():setVoteOriginator(0)
            end
        end
    elseif msgName == DdzGameManager.MsgName.SC_TotalScoreInfo then
        print("[DdzGameScene] SC_TotalScoreInfo")
        if GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateRoom() then
            self:_showStatisticsView(userInfo)
        end
    elseif msgName == DdzGameManager.MsgName.SC_TickNotify then
        print("[DdzGameScene] SC_TickNotify")
        if GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateRoom() then
            if userInfo["tickchairid"] and (userInfo["tickchairid"] == DdzGameManager:getInstance():getDataManager():getMyChairID()) then
                self:jumpToHallScene()
            end
        end
    end

    DdzGameScene.super.receiveServerResponseSuccessEvent(self,event)
end

----收到服务器返回的失败的通知，如果登录失败，密码错误
function DdzGameScene:receiveServerResponseErrorEvent(event)
local userInfo = event.userInfo;
    local msgName = userInfo["msgName"]
    if msgName == HallMsgManager.MsgName.SC_StandUpAndExitRoom then
        
        if userInfo["result"] == 1 then
            CustomHelper.removeIndicationTip()
        else
            self:jumpToHallScene()
        end
    elseif msgName == HallMsgManager.MsgName.SC_GameMaintain then
        if self._logic:IsGamePlaying() == false and self._gameStatus == nil then
            self:isContinueGameConditions()
        end
    end
    ---退出房间失败 然后客户端强制退出
    DdzGameScene.super.receiveServerResponseErrorEvent(self,event);
end

---重新连接成功
function DdzGameScene:callbackWhenReloginAndGetPlayerInfoFinished()
    print("重新连接成功")
    local gameingInfoTable = GameManager:getInstance():getHallManager():getPlayerInfo():getGamingInfoTab()
    if gameingInfoTable == nil and self._logic:IsGamePlaying() == true then
       CustomHelper.showAlertView(
                "本局已经结束,退回到大厅!!!",
                false,
                true,
                function(tipLayer)
                    self:jumpToHallScene()
                end,
                function(tipLayer)
                    self:jumpToHallScene();
                end
        )
       return;
    end
    if self._logic:IsGamePlaying() == false then
        --todo
         CustomHelper.showAlertView(
                "请重新进入房间!!!",
                false,
                true,
            function(tipLayer)
                 self:jumpToHallScene()
            end,
            function(tipLayer)
                 self:jumpToHallScene();

        end)
    else 
        --DdzGameManager:getInstance():sendMsgReconnectionPlay()
    end
    DdzGameScene.super.callbackWhenReloginAndGetPlayerInfoFinished(self,event);
end


function DdzGameScene:ctor()

    self._sound = gameDdz.DdzSound.new()
    self._logic = DdzGameManager:getInstance():getDataManager()
    self.rootPath = DdzGameManager:getInstance():getPackageRootPath();
    local CCSLuaNode =  requireForGameLuaFile("ddzGameLayerCSS_new")
    self.m_widget = CCSLuaNode:create().root;

    self.csNode = self.m_widget
    self:addChild(self.csNode);

    self.touchNum = 1;
    --调用父类，必须调用
    DdzGameScene.super.ctor(self);
    self._countdownTotal = 0
    self._countdown = 0
    self._countdownType = nil
    self._countdownErrorTime = 0
    self._mul = 0
    self._landCards = {}
    self._myCards = {}
    self._cardsTypeHelpIndex = 1;
    self._gameStatus = nil
    self._gameWaitTime = 0 ---超时倒计时
    self.gameEndCardsNode = {};
    self._isTrusteeship = false --托管状态  ture 托管
    self._currentOutCardPlayer = 0; ---当前出牌玩家
    self._sendOutCardsNum = 100 --- 发送出牌计数

 

    -- init --
    self._panelPlayers = { {}, {}, {} }
    self:initBackground()

    self:initUI()
    self:initUIControl()
    self:initCardTip()
    self:initUIUp()
    self:initAni()
    self:initResult()
    
    self:initPanelInfo()
    self:initPanelshadow()
    self:initPanel_TimeoutWait(0)
    self:initDeviceUtilInfo()
    self:initMenu()
    self:SetDeviceUtilInfo()
    --self:SetShowInfoVisable(false)
    --self:_onBtnTouched_game_call()


local myCards = {24, 25, 26, 27, 28, 29, 30, 31}---4个4

---local outCards = {48, 49, 50, 51, 6, 7, 12, 13,}
local outCards = {24, 25, 26, 27,29,30, 32, 33}
local myCardsTable = gameDdz.DdzRules.getNewCardType(myCards);
dump(myCardsTable,"---myCardsTable:");
local lastCardsTable = gameDdz.DdzRules.getNewCardType(outCards);
dump(lastCardsTable,"---lastCardsTable:");

-- local tempCards = gameDdz.DdzRules.NewSearchOutCardForHelp(myCards,outCards)
-- dump(tempCards,"---cards:");
-- -- 0 1 2 3     3  1
-- 4 5 6 7     4  2
-- 8 9 10 11   5  3
-- 12 13 14 15 6  4
-- 16 17 18 19 7  5
-- 20 21 22 23 8  6
-- 24 25 26 27 9  7
-- 28 29 30 31 10 8 
-- 32 33 34 35 j  9
-- 36 37 38 39 Q  10
-- 40 41 42 43 k  j
-- 44 45 46 47 A  Q
-- 48 49 50 51 2  K
-- 52             小王
-- 53             大王

    
-- self:_doAni_DealCard(1)

-- 聊天栏 --
-- self.layerTalk = TalkLayer.new(true, handler(self, self._onMessageCountChanged)):addTo(self, 999)
end


function DdzGameScene:onEnter()

    ---先检查是否可以游戏
    self:isContinueGameConditions()
    ---第一次进来直接发准备
    local gameingInfoTable = GameManager:getInstance():getHallManager():getPlayerInfo():getGamingInfoTab()
    if gameingInfoTable == nil then
        ---显示已经坐下的玩家
        DdzGameManager:getInstance():showPlayerSitDownInfo()
        ---发送准备（非私人房间）
        if not GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateRoom() then
            DdzGameManager:getInstance():sendGameReady()
        end
    else
        DdzGameManager:getInstance():sendMsgReconnectionPlay()
    end
    
    -- 创建定时任务 --
    self._scheduler = scheduler:scheduleScriptFunc(function(dt)
            self:_onInterval()
            end, 1, false);

        -- 创建定时任务 --
    self._scheduler_Device = scheduler:scheduleScriptFunc(function(dt)
            self:SetDeviceUtilInfo()
            end, 5, false);
    -- 播放背景音乐 --
    self._sound:PlayBgm()

    -- 初始化声音按钮状态 --
    local soundOpen = false
    local musicOn = false
    if GameManager:getInstance():getMusicAndSoundManager():getMusicSwitch() == true then
        musicOn = true
    end
     if GameManager:getInstance():getMusicAndSoundManager():getSoundSwitch() == true then
        soundOpen = true
    end

    self:OnUpdateMusicSwitch(musicOn)

    self:OnUpdateSoundSwitch(soundOpen)
end

function DdzGameScene:onExit()

    self._sound:Clear()

    if self._scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scheduler)   
        self._scheduler = nil
    end

    if self._scheduler_Device then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scheduler_Device)   
        self._scheduler_Device = nil
    end

    ---释放资源
    local needLoadResArray = DdzGameScene.getNeedPreloadResArray();
    for i,v in ipairs(needLoadResArray) do
        if string.find(v,".ExportJson") then
        --todo
            ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(v);
        end
    end
end

---初始化桌子
function DdzGameScene:initBackground()
    local background = self.m_widget:getChildByName("background")

    local desktop = background:getChildByName("desktop")
    local panel_player_ani = background:getChildByName("panel_player_ani")
    self.panel_cards = background:getChildByName("panel_cards")

    for i = 1, 2 do
        local bg_card = desktop:getChildByName("bg_card_" .. i)
        
        local label_num = bg_card:getChildByName("label_num")
        label_num:setString(0)
        bg_card:setVisible(false)
        

        self._panelPlayers[i + 1].bg_card = bg_card
        self._panelPlayers[i + 1].label_card = label_num
    end

    self.panel_player_ani = panel_player_ani

    self.panel_land_card = background:getChildByName("panel_land_card")

    for i = 1, gameDdz.GAME_PLAYER do
        self["panel_cards_" .. i] = background:getChildByName("panel_cards_" .. i)
        self["panel_land_card_" .. i] = self.panel_land_card:getChildByName("card_" .. i)
    end
    
    local roomInfo = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab();
    local Label_room_name = background:getChildByName("Label_room_name")
    Label_room_name:setString(roomInfo[HallGameConfig.SecondRoomNameKey])
    Label_room_name:setTextColor(cc.c3b(237,217,150))
    --底注----
    local minJettonLimitString = CustomHelper.moneyShowStyleNone(roomInfo[HallGameConfig.SecondRoomMinJettonLimitKey])
    minJettonLimitString = string.gsub(minJettonLimitString, "%.",".")

    local Label_room_dizhu = background:getChildByName("Label_room_dizhu")
    Label_room_dizhu:setString("底注:"..minJettonLimitString)
    Label_room_dizhu:setTextColor(cc.c3b(237,217,150))
end


---初始化旁边的按钮
function DdzGameScene:initMenu()
    local CCSLuaNode =  requireForGameLuaFile("ddzGameMenuNodeCCS")
    local menuNode = CCSLuaNode:create().root;

    self:addChild(menuNode, ZORDER_MENU)
    menuNode:setPosition(cc.p(display.width,display.height))
    local menu = menuNode:getChildByName("menu")
    local btn_menu = menu:getChildByName("btn_menu")
    local bg_menu = menu:getChildByName("bg_menu")

    local btn_quit = bg_menu:getChildByName("btn_quit")
    local btn_music = bg_menu:getChildByName("btn_yingyue")
    local btn_sound = bg_menu:getChildByName("btn_sound")
    local btn_info = bg_menu:getChildByName("btn_info")
    local btn_property = bg_menu:getChildByName("btn_property")

    local bExpand = false
    --- @tip 菜单按钮/弹出
    btn_menu:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        elseif eventType == ccui.TouchEventType.ended then
            bExpand = not bExpand

            if bExpand then
                bg_menu:stopAllActions()
                 btn_quit:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function ( ... )
                     btn_quit:setVisible(true)
                 end)))

                 btn_music:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function ( ... )
                     btn_music:setVisible(true)
                 end)))
                 
                 btn_sound:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function ( ... )
                     btn_sound:setVisible(true)
                 end)))

                 btn_info:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function ( ... )
                     btn_info:setVisible(true)
                 end)))

                 btn_property:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function ( ... )
                     btn_property:setVisible(GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateRoom())
                 end)))

                --btn_sound:runAction(cc.Sequence:create(cc.DelayTime:create(0.3),moveTo_4))

                --bg_menu:runAction(cc.ScaleTo:create(0.2,1,0))

                btn_menu:setScaleY(-1)
            else
                bg_menu:stopAllActions()

                --bg_menu:runAction(cc.ScaleTo:create(0.2,1,1))
                btn_quit:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function ( ... )
                     btn_quit:setVisible(false)
                 end)))

                 btn_music:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function ( ... )
                     btn_music:setVisible(false)
                 end)))
                 
                 btn_sound:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function ( ... )
                     btn_sound:setVisible(false)
                 end)))

                 btn_info:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function ( ... )
                     btn_info:setVisible(false)
                 end)))

                 btn_property:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function ( ... )
                     btn_property:setVisible(false)
                 end)))

                btn_menu:setScaleY(1)
            end
        end
    end)

    btn_music:addTouchEventListener(handler(self, self._onBtnTouched_menu_music))
    btn_quit:addTouchEventListener(handler(self, self._onBtnTouched_menu_quit))
    btn_sound:addTouchEventListener(handler(self, self._onBtnTouched_menu_sound))
    btn_info:addTouchEventListener(handler(self, self._onBtnTouched_menu_info))
    btn_property:addTouchEventListener(handler(self, self._onBtnTouched_menu_property))

    self.btn_music = btn_music
    self.btn_sound = btn_sound
   
end

---初始化桌面
function DdzGameScene:initUI()
    local CCSLuaNode =  requireForGameLuaFile("ddzGameTimeOutWaitCCS")
    local timeOutNode = CCSLuaNode:create().root;

    self:addChild(timeOutNode)
    timeOutNode:setPosition(cc.p(0,0))
    self.panel_TimeoutWait = timeOutNode:getChildByName("panel_TimeoutWait")
    self.text_outTime = tolua.cast(CustomHelper.seekNodeByName(self.panel_TimeoutWait, "text_outTime"), "ccui.Text")

    local ui = self.m_widget:getChildByName("ui")

    for i = 1, 2 do
        local bg_player = ui:getChildByName("bg_player_" .. i)
        local label_name = bg_player:getChildByName("label_name")
        local label_gold = bg_player:getChildByName("label_gold")
        local image_double = bg_player:getChildByName("image_double")
        bg_player:setVisible(false)

        self._panelPlayers[i + 1].bg_player = bg_player
        self._panelPlayers[i + 1].label_name = label_name
        self._panelPlayers[i + 1].label_gold = label_gold
        self._panelPlayers[i + 1].image_double = image_double
    end


    local bg_bottom = ui:getChildByName("bg_bottom")
    self._panelPlayers[1].label_name = bg_bottom:getChildByName("label_name")
    self._panelPlayers[1].label_gold = bg_bottom:getChildByName("label_gold")
    self._panelPlayers[1].image_double = bg_bottom:getChildByName("image_double")

    self.label_mul_1 = bg_bottom:getChildByName("label_mul_1")
    self.label_mul_2 = bg_bottom:getChildByName("label_mul_2")
    self.label_time = bg_bottom:getChildByName("label_time")
    self._panelPlayers[1].icon_head = bg_bottom:getChildByName("icon_head")


    ----自己的头像
    local myHeadIcon = bg_bottom:getChildByName("icon_head")
    myHeadIcon:loadTexture(GameManager:getInstance():getHallManager():getPlayerInfo():getSquareHeadIconPath())

    ----聊天按钮
    local btn_message = tolua.cast(CustomHelper.seekNodeByName(bg_bottom, "btn_message"), "ccui.Button")
     btn_message:addClickEventListener(function ( )
        self:_onBtnTouched_message()
    end)

    ---功能没开放 所以隐藏
    btn_message:setVisible(false)

    ----牌记录按钮
    local btn_record = tolua.cast(CustomHelper.seekNodeByName(bg_bottom, "btn_record"), "ccui.Button")
    btn_record:addClickEventListener(function ( )
        -- body
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        self:_onBtnTouched_record()
    end)

    --托管按钮
    self.btn_robot = tolua.cast(CustomHelper.seekNodeByName(bg_bottom, "btn_robot"), "ccui.Button")
    self.btn_robot:addClickEventListener(function (sender )
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        if sender:isBright() then

            if self._gameStatus == "stoped_result" or self._gameStatus == "stoped"  then
                return
            end

            DdzGameManager:getInstance():sendMsgLandTrusteeship();
            self:OnUpdateHosting(1, true)
        else

            if self._gameStatus == "stoped_result" or self._gameStatus == "stoped"  then
                return
            end
            
            DdzGameManager:getInstance():sendMsgLandTrusteeship();
            self:OnUpdateHosting(1, false)
        end
    end)


    CustomHelper.addPressedDarkAnimForBtn(btn_message)
    CustomHelper.addPressedDarkAnimForBtn(btn_record)

    local label = btn_message:getChildByName("label")
    local icon = btn_message:getChildByName("icon")
    local icon_01 = btn_message:getChildByName("icon_1")

    self.btn_message_label = label
    self.btn_message_icon = icon
    self.btn_message_icon_01 = icon_01

    -- 玩家牌的位置 --ss
    self.panel_card_start = ui:getChildByName("panel_card_start")

    ---触摸事件
    local panel_cards_touch = ui:getChildByName("panel_cards_touch")
    panel_cards_touch:setTouchEnabled(true)
    panel_cards_touch:setSwallowTouches(false)
    panel_cards_touch:addTouchEventListener(handler(self, self._onBtnTouched_cardControl))

    self._icon_player_identity = {}
    self._panel_tip = {}
    self._panel_tip_label = {}
    self._icon_status = {}
    for i = 1, gameDdz.GAME_PLAYER do
        local Image_land = ccui.ImageView:create(CustomHelper.getFullPath("game_res/ddz_nongmin.png"))
        Image_land:setTag(10086)
        self._icon_player_identity[i] = ui:getChildByName("icon_player_identity_" .. i)
        self._icon_player_identity[i]:setVisible(true)
        self._icon_player_identity[i]:addChild(Image_land)

        self._panel_tip[i] = ui:getChildByName("panel_tip_" .. i)
        self._panel_tip[i]:setVisible(false)
        self._panel_tip_label[i] = self._panel_tip[i]:getChildByName("label")

        self._icon_status[i] = ui:getChildByName("icon_status_" .. i)
        self._icon_status[i]:setVisible(false)
    end

    -- -- TODO
    print("[DdzGameScene] DdzReadyView")
    dump(GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateRoom())

    if GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateRoom() then
        DdzGameManager:getInstance():sendGetPrivateConfig()

        DdzGameManager:getInstance():sendGetTabVoteArray()
    end
end

function DdzGameScene:_showPrivateRoomId()
    -- 展示房间号
    if self._privateRoomIdLable == nil then
        self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
        if GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateOwner(self.myPlayerInfo:getGuid()) then
            self._privateRoomIdLable = cc.Label:create()
            self._privateRoomIdLable:setSystemFontSize(24)
            self._privateRoomIdLable:setTextColor(cc.c3b(249, 239, 140))
            -- self._privateRoomIdLable:setString(string.format("房间号：%d", GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getPrivateRoomId()))
            self._privateRoomIdLable:align(display.LEFT_CENTER, 100, cc.Director:getInstance():getWinSize().height - 26)
            self:addChild(self._privateRoomIdLable, ZORDER_MENU)
        end
    end
end

function DdzGameScene:_showReadyView()
    local DdzReadyView = requireForGameLuaFile("DdzReadyView")
    local layer = DdzReadyView:create()
    self:addChild(layer, ZORDER_PRIVATE_ROOM)
    self._ddzReadyView = layer
end

function DdzGameScene:_hideReadyView()
    if self._ddzReadyView then
        self._ddzReadyView:removeSelf()
        self._ddzReadyView = nil
    end
end

function DdzGameScene:_showPropertyView(data)
    local DdzPropertyView = requireForGameLuaFile("DdzPropertyView")
    local layer = DdzPropertyView:create(function ()
        self._ddzPropertyView = nil
    end)
    self:addChild(layer, ZORDER_PRIVATE_ROOM)
    self._ddzPropertyView = layer
end

function DdzGameScene:_showDismissView()
    local DdzDismissView = requireForGameLuaFile("DdzDismissView")
    local layer = DdzDismissView:create()
    self:addChild(layer, ZORDER_PRIVATE_ROOM)
    self._ddzDismissView = layer
end

function DdzGameScene:_showStatisticsView(data)
    local DdzStatisticsView = requireForGameLuaFile("DdzStatisticsView")
    local layer = DdzStatisticsView:create(self, data)
    self:addChild(layer, ZORDER_PRIVATE_ROOM)
end

---初始化控制按钮
function DdzGameScene:initUIControl()
    local CCSLuaNode =  requireForGameLuaFile("ddzGameUIControlLayerCCS")
    local uiControlNode = CCSLuaNode:create().root;

    self:addChild(uiControlNode)
    uiControlNode:setPosition(cc.p(0,0))
    
    local ui_control = uiControlNode:getChildByName("ui_control")
    local panel_start_game = ui_control:getChildByName("panel_start_game") ---换桌 开始游戏 名牌按钮
    local panel_call_land = ui_control:getChildByName("panel_call_land")  ----叫分
    local panel_game = ui_control:getChildByName("panel_game") ----不出 提示 要不起
    local icon_clock = ui_control:getChildByName("icon_clock") ----闹钟


    panel_start_game:setVisible(false)
    panel_call_land:setVisible(false)
    panel_game:setVisible(false)
    icon_clock:setVisible(false)

    -- 开始按钮 --
    ---local btn_game_start_empty = panel_start_game:getChildByName("btn_game_start_empty")
    ---明牌
    self.btn_game_start_empty = tolua.cast(CustomHelper.seekNodeByName(panel_start_game, "btn_game_start_empty"), "ccui.Button");
    self.btn_game_start_empty:addClickEventListener(function()

    end);

    ---开始
    self.btn_game_start = tolua.cast(CustomHelper.seekNodeByName(panel_start_game, "btn_game_start"),"ccui.Button");
    self.btn_game_start:addClickEventListener(function ( ... )
        -- body
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        DdzGameManager:getInstance():sendGameReady()
    end)

    ---换桌
    self.btn_game_change_table = tolua.cast(CustomHelper.seekNodeByName(panel_start_game, "btn_game_change_table"), "ccui.Button");
    self.btn_game_change_table:addClickEventListener(function ( ... )
        -- body
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        DdzGameManager:getInstance():sendMsgChangeTable()
        self:SetShowInfoVisable(true);

    end)
    CustomHelper.addPressedDarkAnimForBtn(self.btn_game_start_empty)
    CustomHelper.addPressedDarkAnimForBtn(self.btn_game_start)
    CustomHelper.addPressedDarkAnimForBtn(self.btn_game_change_table)


    -- 叫地主操作界面 --
    self.btn_land_call = tolua.cast(CustomHelper.seekNodeByName(panel_call_land, "btn_land_call"), "ccui.Button")
    self.btn_land_call:addClickEventListener(function ()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        DdzGameManager:getInstance():sendCS_LandCallScore(1)
    end)

    --不叫
    self.btn_land_nocall = tolua.cast(CustomHelper.seekNodeByName(panel_call_land, "btn_land_nocall"), "ccui.Button")
    self.btn_land_nocall:addClickEventListener(function ()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        DdzGameManager:getInstance():sendCS_LandCallScore(0)
    end)

    --1分
    self.btn_land_call_1 = tolua.cast(CustomHelper.seekNodeByName(panel_call_land, "btn_land_call_1"), "ccui.Button")
    self.btn_land_call_1:addClickEventListener(function ()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        DdzGameManager:getInstance():sendCS_LandCallScore(1)
    end)

    --2分
    self.btn_land_call_2 = tolua.cast(CustomHelper.seekNodeByName(panel_call_land, "btn_land_call_2"), "ccui.Button")
    self.btn_land_call_2:addClickEventListener(function ()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        DdzGameManager:getInstance():sendCS_LandCallScore(2)
    end)

    --3分
    self.btn_land_call_3 = tolua.cast(CustomHelper.seekNodeByName(panel_call_land, "btn_land_call_3"), "ccui.Button")
    self.btn_land_call_3:addClickEventListener(function ()
        
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        DdzGameManager:getInstance():sendCS_LandCallScore(3)
    end)

    CustomHelper.addPressedDarkAnimForBtn(self.btn_land_call)
    CustomHelper.addPressedDarkAnimForBtn(self.btn_land_nocall)
    CustomHelper.addPressedDarkAnimForBtn(self.btn_land_call_1)
    CustomHelper.addPressedDarkAnimForBtn(self.btn_land_call_2)
    CustomHelper.addPressedDarkAnimForBtn(self.btn_land_call_3)


    -- 游戏中的操作界面 --
    self.icon_tip_no_bnig_card = panel_game:getChildByName("icon_tip_no_bnig_card")

    ----出牌
    self.btn_game_call = tolua.cast(CustomHelper.seekNodeByName(panel_game, "btn_game_call"), "ccui.Button")
    self.btn_game_call:addClickEventListener(function ( )
        self:_onBtnTouched_game_call()

    end)

    --提示
    self.btn_game_help = tolua.cast(CustomHelper.seekNodeByName(panel_game, "btn_game_help"), "ccui.Button")
    self.btn_game_help:addClickEventListener(function ( )
        self:_onBtnTouched_game_help()
    end)

    --- 不要
    self.btn_game_pass = tolua.cast(CustomHelper.seekNodeByName(panel_game, "btn_game_pass"), "ccui.Button")
    self.btn_game_pass:addClickEventListener(function ( )
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        if self._logic._lastCards == nil then
            MyToastLayer.new(self, "请选择自己需要出的牌!")
            return
        end
        self._logic:setMyOutCards(nil)
        DdzGameManager:getInstance():sendCS_LandPassCard()
    end)

    self.btn_game_pass_2 = tolua.cast(CustomHelper.seekNodeByName(panel_game, "btn_game_pass_2"), "ccui.Button")
    self.btn_game_pass_2:addClickEventListener(function ( )
        DdzGameManager:getInstance():sendCS_LandPassCard()
    end)

    CustomHelper.addPressedDarkAnimForBtn(self.btn_game_call)
    CustomHelper.addPressedDarkAnimForBtn(self.btn_game_help)
    CustomHelper.addPressedDarkAnimForBtn(self.btn_game_pass)
    CustomHelper.addPressedDarkAnimForBtn(self.btn_game_pass_2)


    ----加倍
    self.panel_double = tolua.cast(CustomHelper.seekNodeByName(ui_control, "panel_double"), "ccui.Layout")
    self.btn_double = tolua.cast(CustomHelper.seekNodeByName(self.panel_double, "doubleBtn"), "ccui.Button")
    self.btn_double:addClickEventListener(function ( )
        DdzGameManager:getInstance():sendMsgLandCallDouble(2)
        self._sound:PlayerEffect_Double(self:IsMan(1),true)
    end)

    ---不加倍
    self.btn_noDouble = tolua.cast(CustomHelper.seekNodeByName(self.panel_double, "noDoubleBtn"), "ccui.Button")
    self.btn_noDouble:addClickEventListener(function ( )
        DdzGameManager:getInstance():sendMsgLandCallDouble(1)
        self._sound:PlayerEffect_Double(self:IsMan(1),false)
    end)
    CustomHelper.addPressedDarkAnimForBtn(self.btn_double)
    CustomHelper.addPressedDarkAnimForBtn(self.btn_noDouble)

    self.panel_double:setVisible(false)


    ----加班提示
    self.dobuleTips = tolua.cast(CustomHelper.seekNodeByName(ui_control, "dobuleTips"), "ccui.Text");
    self.dobuleTips:setVisible(false)

    -- 倒计时闹钟 --
    local icon_clock_mask = icon_clock:getChildByName("icon_clock_mask")
    local icon_clockwise = icon_clock:getChildByName("icon_clockwise")
    icon_clock_mask:setVisible(false)
    local spriteProgress = cc.Sprite:create(CustomHelper.getFullPath("game_res/icon_clock_mask.png"))
    local progressTimer = cc.ProgressTimer:create(spriteProgress)
    progressTimer:setAnchorPoint(0.5, 0.5)
    progressTimer:setPosition(cc.p(icon_clock_mask:getPosition()))
    progressTimer:setReverseDirection(true)
    progressTimer:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    progressTimer:setPercentage(100)
    icon_clock:addChild(progressTimer)

    -- 闹钟位置 --
    self._node_clock = {}
    for i = 1, gameDdz.GAME_PLAYER do
        self._node_clock[i] = ui_control:getChildByName("node_clock_" .. i)
    end


    self.panel_start_game = panel_start_game
    self.panel_call_land = panel_call_land
    self.panel_game = panel_game
    self.icon_clock = icon_clock
    self.icon_clock_progressTimer = progressTimer
    self.icon_clockwise = icon_clockwise

end

---初始化托管
function DdzGameScene:initUIUp()
    local CCSLuaNode =  requireForGameLuaFile("ddzGameUIUpLayerCCS")
    local uiupNode = CCSLuaNode:create().root;    
    self:addChild(uiupNode)
    uiupNode:setPosition(cc.p(0,0))
    
    local ui_up = uiupNode:getChildByName("ui_up")
    ui_up:setTouchEnabled(false)

    self.panel_tuoguan = ui_up:getChildByName("panel_tuoguan")
    self.panel_tuoguan_bg = self.panel_tuoguan:getChildByName("bg")
    self.panel_tuoguan_bg:setVisible(false)

    ---取消托管
    self.btn_cancel_tuoguan = self.panel_tuoguan_bg:getChildByName("btn_cancel_tuoguan")
    self.btn_cancel_tuoguan:setVisible(false)
    self.btn_cancel_tuoguan:addClickEventListener(function ()

        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        DdzGameManager:getInstance():sendMsgLandTrusteeship();
        self:OnUpdateHosting(1, false)

    end)
    
    local btn_touch = tolua.cast(CustomHelper.seekNodeByName(self.panel_tuoguan_bg, "btn_touch"), "ccui.Button")
    btn_touch:addClickEventListener(function ()

    end)

    self.panel_tuoguan_icon = {}
    for i = 1, gameDdz.GAME_PLAYER do
        self.panel_tuoguan_icon[i] = self.panel_tuoguan:getChildByName("icon_tuoguan_" .. i)
        self.panel_tuoguan_icon[i]:setVisible(false)
    end
end

---动画层
function DdzGameScene:initAni()
    self._ani = self.m_widget:getChildByName("ani")
end

---初始化结束界面
function DdzGameScene:initResult()
    local CCSLuaNode =  requireForGameLuaFile("ddzGameResultLayerCCS")
    local gameresultNode = CCSLuaNode:create().root;     
    self:addChild(gameresultNode)
    gameresultNode:setPosition(cc.p(0,0))
    
    --local result = self.m_widget:getChildByName("result")
    local bg_result = gameresultNode:getChildByName("bg_result")
    local icon_title = bg_result:getChildByName("icon_title")
    local btn_close = bg_result:getChildByName("btn_close")
    local label_result = bg_result:getChildByName("label_result")
    --local btn_change_table = bg_result:getChildByName("btn_change_table")
    local btn_ready = bg_result:getChildByName("btn_ready")
    local label_time = btn_ready:getChildByName("label_time")
    local playerCard_1 = bg_result:getChildByName("playerCard_1")
    local playerCard_2 = bg_result:getChildByName("playerCard_2")
    bg_result:setPosition(cc.p(1280*0.5,720*0.5))
    bg_result:setVisible(false)
    btn_close:addTouchEventListener(handler(self, self._onBtnTouched_result_close))

    ---换桌
    local btn_change_table = tolua.cast(CustomHelper.seekNodeByName(bg_result, "btn_change_table"), "ccui.Button");
    if GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateRoom() then
        btn_change_table:setVisible(false)
    end
    btn_change_table:addClickEventListener(function ()

        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        if self:isContinueGameConditions() == true then
            DdzGameManager:getInstance():sendMsgChangeTable()
            DdzGameManager:getInstance():sendGameReady()
            self:HideResult()
            self:setRecordVisibility(false)
            self:SetShowInfoVisable(true)
        end
    end)

    ---准备
    if GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateRoom() then
        btn_ready:setPositionX(435)
    end
    btn_ready:addClickEventListener(function ()

        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        if self:isContinueGameConditions() == true then
            self._gameStatus = nil
            DdzGameManager:getInstance():sendGameReady()
            self:HideResult() 
            self:SetShowInfoVisable(true)
        end
    end)

    local _temp = {}
    _temp.self = bg_result --result
    _temp.bg_result = bg_result
    _temp.bg_result_pos = { bg_result:getPosition() }
    _temp.icon_title = icon_title
    _temp.btn_close = btn_close
    _temp.label_result = label_result
    _temp.label_time = label_time
   -- _temp.icon_slef_highlight = icon_slef_highlight
    _temp.playerCard_1 = playerCard_1
    _temp.playerCard_2 = playerCard_2

    for i = 0, gameDdz.GAME_PLAYER do
        _temp["labbel_name_" .. i] = bg_result:getChildByName("label_name_" .. i)
        _temp["label_value_" .. i] = bg_result:getChildByName("label_value_" .. i)
        _temp["label_tax_" .. i] = bg_result:getChildByName("label_tax_" .. i)
        _temp["label_self_" .. i] = bg_result:getChildByName("label_self_" .. i)
        _temp["label_double_"..i] = bg_result:getChildByName("label_double_" .. i) 
        _temp["icon_slef_highlight_"..i] = bg_result:getChildByName("icon_slef_highlight_" .. i) 
        _temp["label_tax_" .. i]:setVisible(false)
    end

    self._result = _temp
end

---初始化牌记录器
function DdzGameScene:initCardTip()
    local CCSLuaNode =  requireForGameLuaFile("ddzGameCardTipCCS")
    local cardTipNode = CCSLuaNode:create().root;       
    self:addChild(cardTipNode)
    local btnRecord = CustomHelper.seekNodeByName(self.m_widget,"btn_record")
    local pos = self.m_widget:convertToWorldSpace(cc.p(btnRecord:getPositionX() - btnRecord:getContentSize().width,btnRecord:getPositionY()))
    cardTipNode:setPosition(pos)

    local panel_card_tip = cardTipNode:getChildByName("panel_card_tip")
    panel_card_tip:setTouchEnabled(false)
    panel_card_tip:setSwallowTouches(true)

    local bg = panel_card_tip--:getChildByName("bg")
    panel_card_tip:setVisible(false)

    local pokers = {}
    local label_nums = {}
    for i = 1, 15 do
        local value = gameDdz.DdzRules.GetCardByRValue(i-1)*4
        if i == 14 then
            value = 52
        elseif i == 15 then
            --todo
            value = 53
        end
        --print("value444444444",value)
        local poker0 = gameDdz.DdzPoker.new(true, value)
        poker0:setScale(53 / poker0:getContentSize().width)
        poker0:setPosition(cc.p(963- 63 * (i-1),90))
        --poker0:pos(255 - 63 * (i-1) + 60 / 2, 93)

        bg:addChild(poker0)
        local label_num = cc.LabelTTF:create("0张", "Arial", 24)
        label_num:setColor(cc.c3b(0xED, 0xE7, 0xB4))
        label_num:align(display.CENTER, 963- 63 * (i-1) , 146)
        bg:addChild(label_num)
        pokers[i] = poker0
        label_nums[i] = label_num
    end

    self.panel_card_tip = {
        self = panel_card_tip,
        pokers = pokers,
        label_nums = label_nums,
    }
end

---初始化规则
function DdzGameScene:initPanelInfo()
    local CCSLuaNode =  requireForGameLuaFile("ddzGameInfoLayerCCS")
    local infoNode = CCSLuaNode:create().root;      
    self:addChild(infoNode,100)
    infoNode:setPosition(cc.p(0,0))
    
    local panel_info = infoNode:getChildByName("panel_info")
    panel_info:setVisible(false)
    panel_info:addTouchEventListener(handler(self, self._onBtnTouched_hideInfo))
    panel_info:setTouchEnabled(true)

    local bg = panel_info:getChildByName("bg")
    bg:setTouchEnabled(true)
    local btn_close = bg:getChildByName("bnt_close")
    btn_close:addTouchEventListener(handler(self, self._onBtnTouched_hideInfo))

    local config = {
        {
            btn = "btn_paixing",
            scrollview = "scrollview_paixing",
            text = "火箭：即大王和小王，最大的牌。\n" ..
                    "炸弹：四张同数值的牌（如四个7）。\n" ..
                    "单牌：单张牌。\n" ..
                    "对牌：数值相同的两张牌。\n" ..
                    "三张牌：数值相同的三张牌。\n" ..
                    "三带一：数值相同的三张牌..一张单牌或一对牌。例如：3 3 3 + 6 或者 4 4 4 + 9 9。\n" ..
                    "顺子：五张或更多的连续单牌（如：3 4 5 6 7 或 7 8 9 10 J Q K A）。不能包括2和大王、小王。\n" ..
                    "连对：三对或更多的连续对牌（如：3 3 4 4 5 5、7 7 8 8 9 9 10 10 J J）。不能包括2和大王、小王。\n" ..
                    "飞机：两个或更多的连续三张牌，可以带或者不带同数量的单牌或对牌。例如：4 4 4 5 5 5、3 3 3 4 4 4 5 5 5.. 8 9 10。 \n" ..
                    "四带二：四张牌..两个单张或两个对子。例如：5 5 5 5 + 3 + 8或 4 4 4 4 + 5 5 + 7 7。四带二不是炸弹。"
        },
        {
            btn = "btn_rules",
            scrollview = "scrollview_rules",
            text = "1.发牌：一副牌54张，一人17张，留3张做底牌，在确定地主之前玩家不能看底牌。\n" ..
                    "2.叫牌：叫牌按出牌的顺序轮流进行，叫牌时可以选择“1分”“2分”“3分”“不叫”。下家只能叫比上家更高的分或者不叫，有玩家叫3分则直接确定这名玩家为地主。如果3人都不叫地主，则重新发牌，重新叫牌，直到有人叫分确定地主为止。此情况持续至第三轮时，由发牌时的第一家作为地主。\n" ..
                    "3.第一个叫牌的玩家：第一个叫牌玩家由系统随机选出。\n" ..
                    "4.每次任意一名玩家使用炸弹都会使游戏的倍数翻倍，游戏的倍数与结算时的金币有关。\n"..
                    "5.选择加倍的玩家最终得分x2，同时失败时扣分也是原来的2倍.",
        },
    }

    for k, v in ipairs(config) do
        local index = k
        local btn = bg:getChildByName(v.btn)
        local scrollview = bg:getChildByName(v.scrollview)
        local label = cc.LabelTTF:create(v.text, "Arial", 20,cc.size(scrollview:getContentSize().width,0),cc.TEXT_ALIGNMENT_LEFT)
        label:setColor(cc.c3b(0xFC, 0xF9, 0xC4))
        local width = scrollview:getContentSize().width
        local height = math.max(scrollview:getContentSize().height, label:getContentSize().height)
        --dump(width)
        --dump(height)
        label:align(display.LEFT_TOP, 0, height):addTo(scrollview)
        scrollview:setInnerContainerSize(cc.size(width, height))

        btn:setBright(k == 1)
        scrollview:setVisible(k == 1)
        label:setString(v.text)

        v.index = index
        v.nodeBtn = btn
        v.nodescrollview = scrollview
        btn:addTouchEventListener(function()
            for k, v in ipairs(config) do
                v.nodeBtn:setBright(v.index == index)
                v.nodescrollview:setVisible(v.index == index)
            end
        end)
    end

    self.panel_info = panel_info
    self.panel_info_bg = bg
    self.panel_info_bg_pos = { bg:getPosition() }
end

function DdzGameScene:initPanelshadow()
    local CCSLuaNode =  requireForGameLuaFile("ddzGameShadowLayerCCS")
    local shadowNode = CCSLuaNode:create().root;

    self:addChild(shadowNode)
    shadowNode:setPosition(cc.p(0,0))
    self.panel_shadow = shadowNode:getChildByName("panel_shadow")
end

----初始化掉线界面
function DdzGameScene:initPanel_TimeoutWait(outTime)
    -- body

    if outTime ~= nil and outTime > 0  then
        --todo
        self.panel_TimeoutWait:setVisible(true)
        self._gameWaitTime = outTime + self._gameWaitTime 
     elseif outTime == 0 then
        self._gameWaitTime = 0;
        self.panel_TimeoutWait:setVisible(false)
    end

    ----牌记录按钮
    local but_touch = tolua.cast(CustomHelper.seekNodeByName(self.panel_TimeoutWait, "but_touch"), "ccui.Button")
    but_touch:addClickEventListener(function ( )
        -- body
    end)
end


---倒计时刷新
function DdzGameScene:_onInterval()

    if self._countdown > 0  and (self._gameWaitTime == nil or self._gameWaitTime == 0) then
        if self._countdown <= 5 then
           MusicAndSoundManager:getInstance():playSound("sound/NaoZhongZou")
        end

        self.label_time:setString(string.format("%02d:%02d", math.floor(self._countdown / 60), self._countdown % 60))
        self._countdown = self._countdown - 1

        --self.icon_clock:setVisible(true)

        local percent = self._countdown / self._countdownTotal
        self.icon_clock_progressTimer:setPercentage(math.floor(percent * 100))
        self.icon_clockwise:setRotation(percent * -360)


        ---自己发送自己出牌的消息 补发最多7次
        if self._countdown > 3 and self._sendOutCardsNum  < 6  and self._logic._myOutCards~=nil  then
            self._sendOutCardsNum = self._sendOutCardsNum + 1
            DdzGameManager:getInstance():sendCS_LandOutCard(self._logic._myOutCards)
        end


    else
        if self._countdownType then
            self._countdownType = nil
        end

        self.label_time:setString("00:00")

        self.icon_clock:setVisible(false)
    end
    if  self._gameWaitTime ~=nil and self._gameWaitTime > 0 then
        self._gameWaitTime = self._gameWaitTime-1
        self.text_outTime:setString(self._gameWaitTime)
        if self._gameWaitTime == 0 then
            self:initPanel_TimeoutWait(0)
        end
    end

end


---退出按钮
function DdzGameScene:_onBtnTouched_menu_quit(sender, eventType)

    if eventType == ccui.TouchEventType.began then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    elseif eventType == ccui.TouchEventType.ended then

        if GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateRoom() then

            if self:_isPrivateShowingReady() then
                self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
                if GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateOwner(self.myPlayerInfo:getGuid()) then
                    CustomHelper.showAlertView(
                        "“返回大厅”会解散房间并退返房费，确认要退出吗？",
                        true,
                        true,
                    function(tipLayer)
                        tipLayer:removeSelf()
                    end,
                    function(tipLayer)
                        CustomHelper.addIndicationTip("正在退出房间,请稍后!!!",cc.Director:getInstance():getRunningScene(),0);
                        DdzGameManager:getInstance():sendStandUpAndExitRoomMsg();
                    end)
                    return
                end
            else
                CustomHelper.showAlertView(
                    "您正处于私人房游戏中，要发起解散房间投票吗？",
                    true,
                    true,
                function(tipLayer)
                    tipLayer:removeSelf()
                end,
                function(tipLayer)
                    self:_showDismissView()
                    tipLayer:removeSelf()
                end)
                return
            end
        end

        if self._gameStatus == "stoped_result" and self._isTrusteeship == true then
            
            self:jumpToHallScene()

        elseif self._logic:IsGamePlaying() == true then
            CustomHelper.showAlertView(
                "您正在游戏中，退出游戏后将由电脑托管您继续完成游戏，您可以重进游戏继续该局游戏。",
                true,
                true,
            function(tipLayer)
                tipLayer:removeSelf()
            end,
            function()
                self._logic:setGamePlaying()
                DdzGameManager:getInstance():sendMsgTrusteeship()
                self:jumpToHallScene();
            end)
        else
            local status = GameManager:getInstance():getHallManager():getHallDataManager():getConnectionStatus()
            if status == NetworkManager.TCPConnectionStatus.TCPConnectionStatus_Close then
                self:jumpToHallScene();
            else
                CustomHelper.addIndicationTip("正在退出房间,请稍后!!!",cc.Director:getInstance():getRunningScene(),0);
                DdzGameManager:getInstance():sendStandUpAndExitRoomMsg();
            end
        end
    end
end

function DdzGameScene:_onBtnTouched_menu_music(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    elseif eventType == ccui.TouchEventType.ended then
        self:SetMusicOn(not sender:isBright())
    end
end
---
function DdzGameScene:_onBtnTouched_menu_sound(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    elseif eventType == ccui.TouchEventType.ended then
        self:SetSoundOn(not sender:isBright())
    end
end

function DdzGameScene:_onBtnTouched_menu_info(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    elseif eventType == ccui.TouchEventType.ended then
        self:ShowHelp(true)
    end
end

function DdzGameScene:_onBtnTouched_menu_property(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    elseif eventType == ccui.TouchEventType.ended then
        self:_showPropertyView()
    end
end

function DdzGameScene:_onBtnTouched_hideInfo(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    elseif eventType == ccui.TouchEventType.ended then
        self:ShowHelp(false)
    end
end

---聊天
function DdzGameScene:_onBtnTouched_message(sender, eventType)
    -- if eventType == ccui.TouchEventType.began then
    --     MusicAndSoundManager:getInstance():playSound(SOUND_HALL_TOUCH)
    -- elseif eventType == ccui.TouchEventType.ended then
    --     self.layerTalk:Show()
    -- end
end

---牌纪录
function DdzGameScene:_onBtnTouched_record(sender, eventType)
   
    GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)

    self._recordVisible = not self._recordVisible
    self:setRecordVisibility(self._recordVisible)
end

--- 出牌
function DdzGameScene:_onBtnTouched_game_call(sender, eventType)
   
    GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
   
    local cards = {}
    for k, v in ipairs(self._myCards) do
        if v:IsSelected() then
            table.insert(cards, v:GetPoint())
        end
    end
    -- local cards = {40, 41, 42, 43, 0, 1, 2, 3}---4个
    -- local outCards = {24, 25, 26, 27,29,30, 32, 33}
    -- self._logic._lastCards = outCards
    --出牌判定
    if table.getn(cards) == 0 then
        MyToastLayer.new(self, "请选择要出的牌")
        return
    end

    --牌型有错
    local myCardsTable = gameDdz.DdzRules.getNewCardType(cards);
    local lastCardsTable = gameDdz.DdzRules.getNewCardType(self._logic._lastCards);

    -- print("myCardsTable.cardType:",myCardsTable.cardType)
    -- print("lastCardsTable.cardType:",lastCardsTable.cardType)
    -- print("myCardsTable.beg:",myCardsTable.beg)
    -- print("lastCardsTable.beg:",lastCardsTable.beg)

    if myCardsTable.cardType == gameDdz.DdzRules.CT_ERROR then
        print("牌型出错")
        MyToastLayer.new(self, "请选择正确的牌型")
        return
    end
    
    self._logic:setMyOutCards(nil)
    --上家出牌
    if  self._logic._lastCards ~= nil  and #self._logic._lastCards > 0 then
        --自己不是火箭
        if myCardsTable.cardType ~= gameDdz.DdzRules.CT_MISSILE_CARD then
            --自己不是炸弹
            if myCardsTable.cardType ~= gameDdz.DdzRules.CT_BOMB_CARD then
                if myCardsTable.cardType ~= lastCardsTable.cardType then
                    print("牌型不对")
                    MyToastLayer.new(self, "请选择和上家一致的牌型")
                    return
                end
                if myCardsTable.beg <= lastCardsTable.beg then --myCardsTable.value <= lastCardsTable.value 
                    print("比上家牌小")
                    MyToastLayer.new(self, "请选择比上家更大的牌!")
                    return
                end
            else
                if myCardsTable.cardType == lastCardsTable.cardType and myCardsTable.beg <= lastCardsTable.beg then
                    print("比上家牌小")
                    MyToastLayer.new(self, "请选择比上家更大的牌!")
                    return
                end
            end
        end
    end
    self._sendOutCardsNum = 0
    --self._logic:setMyOutCards(cards)
    --self:showMyOutCards(cards)
    --dump(cards,"出牌")
    DdzGameManager:getInstance():sendCS_LandOutCard(cards)
    -- self.panel_game:setVisible(false)
end


--- 提示
function DdzGameScene:_onBtnTouched_game_help(sender, eventType)

    GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)

    -- TODO 提示
    local have = false
    local cards =  self._logic:SearchOutCardForHelp()
    if #cards == 0 then
        --todo
        return;
    end
   
    for k, v in ipairs(self._myCards) do
        v:SetSelected(false)
    end
    local v = cards[self._cardsTypeHelpIndex]
        for k1,v1 in pairs(v) do
            for k2,v2 in pairs(self._myCards) do
                if v1 == v2:GetPoint() then
                    v2:SetSelected(true)
                end
            end
        end
        self._cardsTypeHelpIndex = self._cardsTypeHelpIndex+1
        --break
    --end
    if self._cardsTypeHelpIndex >#cards then
        --todo
        self._cardsTypeHelpIndex = 1
    end
    
end

function DdzGameScene:_onBtnTouched_result_close(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    elseif eventType == ccui.TouchEventType.ended then
            ---发送离开消息
        DdzGameManager:getInstance():sendStandUpAndExitRoomMsg();
        self:HideResult()
    end
end


----牌触摸监控
function DdzGameScene:_onBtnTouched_cardControl(sender, eventType)

    if eventType == ccui.TouchEventType.began then
        if self.touchNum == 1 then
            local hitCard = self:HitTestAtCard(sender:getTouchBeganPosition())
            if hitCard then
                hitCard:SetSelected(not hitCard:IsSelected())
            else
                self:DoPutDownAllCards()
            end
            self._hitCard = hitCard
        end
        self.touchNum = self.touchNum+1;
    elseif eventType == ccui.TouchEventType.moved then
        if not self._hitCard then 
            return 
        end

        local hitCard = self:HitTestAtCard(sender:getTouchMovePosition())

        if hitCard then
            hitCard:SetSelected(self._hitCard:IsSelected())
        end
    elseif eventType == ccui.TouchEventType.ended then
         self.touchNum = 1
        if self._hitCard ~=nil then
            self._hitCard = nil
            return
        end
        local hitCard = self:HitTestAtCard(sender:getTouchEndPosition())
        if hitCard and self._hitCard ~= nil then
            hitCard:SetSelected(self._hitCard:IsSelected())
        end
    end
end
function DdzGameScene:_onTouched_poker(poker)
    --    poker:SetSelected(not poker:IsSelected())
end
function DdzGameScene:setRecordVisibility(visible)
    self._recordVisible = visible
    self.panel_card_tip.self:setVisible(visible)
    self:UpdateCardRecord()
end

function DdzGameScene:_onMessageCountChanged(count)
    if count > 0 then
        local text = count
        if count >= 10 then
            self.btn_message_icon:setVisible(false)
            self.btn_message_icon_01:setVisible(true)
        else
            self.btn_message_icon:setVisible(true)
            self.btn_message_icon_01:setVisible(false)
            if count > 99 then
                text = "99+"
            end
        end
        self.btn_message_label:setVisible(true)
        self.btn_message_label:setString(text)

    else
        self.btn_message_label:setVisible(false)
        self.btn_message_icon:setVisible(false)
        self.btn_message_icon_01:setVisible(false)
    end
end

---发牌动画
function DdzGameScene:_doAni_DealCard(index)
    self.panel_card_start:removeAllChildren()
    self.panel_cards:removeAllChildren()
    self.panel_land_card_1:removeAllChildren()
    self.panel_land_card_2:removeAllChildren()
    self.panel_land_card_3:removeAllChildren()

    self._passAni2 = false

    self._landCards = {}
    self._myCards = {}

    local tempCards = {}
    -- 创建牌堆 --
    for i = 1, 54 do
        local sprite = display.newSprite("public/poker/poker_back.png")
        sprite:align(display.CENTER, 0.1 * i, 0.125 * i):addTo(self.panel_card_start, i)
        sprite:setRotation3D(cc.vec3(0.5, 0.5, 0.5))
        sprite:setSkewX(-2)
        sprite:setSkewY(2)
        sprite:setScaleY(0.4)
        sprite:setScaleX(0.5)
        sprite:setVisible(false)
        table.insert(tempCards, sprite)
    end

    local moveTime = 0.1
    self.panel_card_start:runAction(ccext.FuncAction:create(0.5, function(sender, percent)
        for i = 1, math.ceil(percent * 54) do
            tempCards[i]:setVisible(true)
        end 
        if percent == 1 then
            for i = 1, 54 do
                local sprite = tempCards[55 - i]

                local _actions = {}
                table.insert(_actions, cc.DelayTime:create(i * 0.05))--0.05
                table.insert(_actions, cc.CallFunc:create(function()
                       self._sound:PlayEffect_fapai() 
                end))

                local x, y = 0, 0
                if i >= 52 then
                    -- 发地主牌 --
                    local node = self["panel_land_card_" .. (i - 51)]
                    local point = self.panel_card_start:convertToNodeSpace(node:convertToWorldSpace(cc.p(0, 0)))
                    x, y = point.x + node:getContentSize().width / 2, point.y + node:getContentSize().height / 2

                    table.insert(_actions, cc.Spawn:create({
                        cc.MoveTo:create(moveTime, cc.p(x, y)),
                        cc.RotateBy:create(moveTime, 720),
                        cc.ScaleTo:create(moveTime, math.min(node:getContentSize().width / sprite:getContentSize().width,
                            node:getContentSize().height / sprite:getContentSize().height))
                    }))

                    local poker0 = gameDdz.DdzPoker.new(false, 0)
                    poker0:setScale(math.min(node:getContentSize().width / poker0:getContentSize().width,node:getContentSize().height / poker0:getContentSize().height))
                    poker0:setPosition(cc.p(poker0:getContentSize().width * poker0:getScale() / 2,poker0:getContentSize().height * poker0:getScale() / 2))
                    poker0:setVisible(false)
                    node:addChild(poker0)

                    table.insert(self._landCards, poker0)

                    table.insert(_actions, cc.CallFunc:create(function(sender)
                        poker0:setVisible(true)
                    end))
                else
                    local _index = ((i - 1) % 3 + index - 1) % 3 + 1
                    if _index == 1 then
                        local poker0 = gameDdz.DdzPoker.new(false, 0)
                        poker0:setScale(MY_CARD_SCALE)
                        --poker0:SetTouchDelegate(handler(self, self._onTouched_poker))

                        local widthCard = poker0:getContentSize().width * poker0:getScale()
                        local heightCard = poker0:getContentSize().height * poker0:getScale()
                        local offsetX = -(16 * MY_CARD_INTERVAL + widthCard) / 2

                        poker0:pos(offsetX + #self._myCards * MY_CARD_INTERVAL + widthCard / 2,heightCard / 2)
                        poker0:setVisible(false)
                        self.panel_cards:addChild(poker0)

                        local point = self.panel_card_start:convertToNodeSpace(self.panel_cards:convertToWorldSpace(cc.p(0, 0)))
                        --x = offsetX + point.x + #self._myCards * MY_CARD_INTERVAL, point.y + widthCard / 2 - 1280/2
                        x = offsetX + #self._myCards * MY_CARD_INTERVAL + widthCard / 2
                        y = point.y + heightCard / 2

                        ---print("-------------------444444444---：" ,x);
                        table.insert(self._myCards, poker0)


                        table.insert(_actions, cc.Spawn:create({
                            cc.MoveTo:create(moveTime, cc.p(x, y)),
                            cc.RotateBy:create(moveTime * 0.8, 720),
                            cc.ScaleTo:create(moveTime, 1)
                        }))
                        table.insert(_actions, cc.CallFunc:create(function(sender)
                            poker0:setVisible(true)
                        end))
                    elseif _index == 2 or _index == 3 then
                        local point = self.panel_card_start:convertToNodeSpace(self._panelPlayers[_index].bg_card:convertToWorldSpace(cc.p(0, 0)))
                        x, y = point.x, point.y

                        table.insert(_actions, cc.Spawn:create({
                            cc.MoveTo:create(moveTime, cc.p(x, y)),
                            cc.RotateBy:create(moveTime, 720)
                        }))

                        table.insert(_actions, cc.CallFunc:create(function(sender)
                            self._panelPlayers[_index].label_card:setString(math.ceil(i / 3))
                        end))
                    end
                end

                table.insert(_actions, cc.CallFunc:create(function(sender)
                    sender:removeSelf()
                    if i == 54 then
                        self:_doAni_DealCard_2_Show()
                    end
                end))
                sprite:runAction(transition.sequence(_actions))
            end
        end
    end))
end

---发牌动画
function DdzGameScene:_doAni_DealCard_2_Show()
    if self._passAni2 then return end

    local _tempCards = {}
    for i = 1, 17 do
        table.insert(_tempCards, DdzGameManager:getInstance():getDataManager()._cards[i])
    end

    -- 翻牌 --
    print("------------翻牌------------")
    for k, v in ipairs(self._myCards) do
        local value = _tempCards[k]
        v:stopAllActions()
        v:runAction(transition.sequence({
            cc.DelayTime:create(k * 0.05),
            cc.CallFunc:create(function(sender)
                sender:reversal(0.1, value)
            end),
            cc.DelayTime:create(0.1),
            cc.CallFunc:create(function(sender)
                if k == #self._myCards then
                    self:_doAni_DealCard_3_Show()
                end
            end),
        }))
    end
end

---发牌动画
function DdzGameScene:_doAni_DealCard_3_Show()
    -- 洗牌 --
    local tempCards = {}
    for k,v in ipairs(DdzGameManager:getInstance():getDataManager()._cards) do
        table.insert(tempCards, v)
    end

    local widthCard = gameDdz.DdzPoker.WIDTH * MY_CARD_SCALE
    local heightCard = gameDdz.DdzPoker.HEIGHT * MY_CARD_SCALE
    local offsetX = -((#self._myCards - 1) * MY_CARD_INTERVAL + widthCard) / 2
    for k, v in ipairs(self._myCards) do
        v:StopReversal()
        v:stopAllActions()

        local moveto_1 = cc.MoveTo:create(0.2, cc.p(640 + widthCard / 2, heightCard / 2))
        local callfunc = cc.CallFunc:create(function()
                local value = tempCards[k]
                v:setContent(true, value)
            end)
        local moveto_2 = cc.MoveTo:create(0.2, cc.p(offsetX + (k - 1) * MY_CARD_INTERVAL + widthCard / 2+640, heightCard / 2));
        local callfunc_2 = cc.CallFunc:create(function(sender)
                --print("offsetX + (k - 1) * MY_CARD_INTERVAL + widthCard / 2:",offsetX + (k - 1) * MY_CARD_INTERVAL + widthCard / 2);
                sender:pos(offsetX + (k - 1) * MY_CARD_INTERVAL + widthCard / 2, heightCard / 2)
                --sender:SetSelected(false)
            end)
        local seq  = cc.Sequence:create(moveto_1,callfunc,moveto_2,callfunc_2)

        v:runAction(seq);
    end
end

---抢到地主然后洗手牌动画
function DdzGameScene:_doAni_DealLandCard(index, cards)
    for k, v in ipairs(self._landCards) do
        local value = cards[k]
        v:reversal(0.1, value)
    end
    if index == 1 then
        self._passAni2 = true

        for k, v in ipairs(cards) do
            local value = cards[k]
            local poker0 = gameDdz.DdzPoker.new(true, value)
            poker0:setScale(MY_CARD_SCALE)
            --poker0:SetTouchDelegate(handler(self, self._onTouched_poker))
            self.panel_cards:addChild(poker0)
            table.insert(self._myCards, poker0)
        end
        local widthCard = gameDdz.DdzPoker.WIDTH * MY_CARD_SCALE
        local heightCard = gameDdz.DdzPoker.HEIGHT * MY_CARD_SCALE
        local offsetX = -((#self._myCards - 1) * MY_CARD_INTERVAL + widthCard) / 2
        for k, v in ipairs(self._myCards) do
            v:setVisible(true)
            v:stopAllActions()
            if k > 17 then
                v:pos(offsetX + (k - 1) * MY_CARD_INTERVAL + heightCard / 2, heightCard / 2 + 30)
                v:stopAllActions()
                v:runAction(transition.sequence({
                    cc.DelayTime:create(1),
                    cc.MoveBy:create(0.2, cc.p(0, -30)),
                    cc.CallFunc:create(function()
                        if k == 20 then
                            self:_doAni_DealCard_3_Show()
                        end
                    end)
                }))
            else
                v:pos(offsetX + (k - 1) * MY_CARD_INTERVAL + heightCard / 2, heightCard / 2)
            end
        end
    end
end

---出牌的类型播放动画
function DdzGameScene:_doAni_PlayerOutCardEff(cards)
    -- 播放动画 --
    if not cards then return end
    local outCards = gameDdz.DdzRules.getNewCardType(cards) -- { cardType = card_type, beg = ret.beg, len = ret.len };
    local aniFile, aniName
    local imageFile
    if outCards.cardType == gameDdz.DdzRules.CT_MISSILE_CARD then
        -- 火箭 --
        aniFile = "dkj_ddz_paixing_eff"
        aniName = "ani_03"

        -- imageFile = self.rootPath.."ddz_paixing_huojian.png"

        self._sound:PlayEffect_cardEff(2)

        self:ShakeScreen(1, 5,0.5)
    elseif outCards.cardType == gameDdz.DdzRules.CT_BOMB_CARD then
        -- 炸弹 --
        aniFile = "dkj_ddz_paixing_eff"
        aniName = "ani_01"

        -- imageFile = self.rootPath.."ddz_paixing_zhadan.png"

        self._sound:PlayEffect_cardEff(5)

        self:ShakeScreen(0.7, 4,0.3)
    elseif outCards.cardType == gameDdz.DdzRules.CT_SINGLE_LINE or outCards.cardType == gameDdz.DdzRules.CT_DOUBLE_LINE then
        -- 龙顺 --
        if outCards.beg == 1 and outCards.len == 12 then
            aniFile = "dkj_ddz_paixing_eff"
            aniName = "ani_02"

            -- imageFile = "ddz_paixing_longshun.png"
        else
            aniFile = "dkj_ddz_paixing_eff"
            if outCards.cardType == gameDdz.DdzRules.CT_SINGLE_LINE then
                aniName = "ani_02"
                -- imageFile = "ddz_paixing_shunzi.png"
            else
                aniName = "ani_05"
                -- imageFile = "ddz_paixing_liandui.png"
            end
        end
        ---连队
        if outCards.cardType == gameDdz.DdzRules.CT_SINGLE_LINE then
            self._sound:PlayEffect_cardEff(4)
        else
            self._sound:PlayEffect_cardEff(3)
        end
    elseif outCards.cardType == gameDdz.DdzRules.CT_THREE_TAKE_ONE or outCards.cardType == gameDdz.DdzRules.CT_THREE_TAKE_TWO
            or outCards.cardType == gameDdz.DdzRules.CT_THREE_LINE or outCards.cardType == gameDdz.DdzRules.CT_FEIJI_ONE 
            or outCards.cardType == gameDdz.DdzRules.CT_FEIJI_TWO then
    

        -- 飞机 --
        if outCards.len > 1 then
            aniFile = "dkj_ddz_paixing_eff"
            aniName = "ani_04"

            -- imageFile = "ddz_paixing_feiji.png"

            self._sound:PlayEffect_cardEff(1)
        end
    end

    --dump(aniFile)
    --dump(aniName)
    if aniFile and aniName then
        --local iconAni = display.newSprite(imageFile):align(display.CENTER, display.cx, display.cy):addTo(self._ani, 1)
        local node = ccs.Armature:create(aniFile)
        node:getAnimation():setMovementEventCallFunc(function(sender, type, id)
            if type == ccs.MovementEventType.complete then
                sender:removeSelf()
                --iconAni:removeSelf()
            end
        end)
        node:getAnimation():play(aniName)
        node:setPosition(cc.p(display.cx, display.cy))
        --pos(display.cx, display.cy)
        self._ani:addChild(node)
    end
end

---屏幕抖动
function DdzGameScene:ShakeScreen(time,range,delaytime)
    -- time = time or 0
    -- range = range or 0
    -- delaytime = delaytime or 0
    -- local scene = display.getRunningScene()
    -- local node = display.newNode():addTo(scene)
    -- node:runAction(transition.sequence({
    --     cc.DelayTime:create(delaytime),
    --     custom.FuncAction:create(time,function(sender,percent)
    --         if percent == 1 then
    --             sender:setPosition(0, 0)
    --         else
    --             local _time = time * (1 - percent)
    --             local base = math.max(1, 20 * range * _time)
    --             local base_2 = base * 0.5
    --             sender:setPosition(math.random() * base - base_2,math.random() * base - base_2)
    --         end
    --     end),
    --     cc.CallFunc:create(function(sender)
    --         sender:removeSelf()
    --     end)
    -- }))
end

---玩家进入牌桌 人物动画
function DdzGameScene:OnPlayerEnter(index, player)

    --dump(player,"玩家进入牌桌")
    
    local panelPlayer = self._panelPlayers[index]

    if panelPlayer.bg_player then
        panelPlayer.bg_player:setVisible(true)
    end
    if panelPlayer.bg_card then
        panelPlayer.bg_card:setVisible(true)
    end
    panelPlayer.label_name:setVisible(true)
    panelPlayer.label_gold:setVisible(true)
    panelPlayer.label_name:setString(player:getIpArea())
    --panelPlayer.label_name:setString(player.nickName)
    --panelPlayer.label_gold:setString(CustomHelper.moneyShowStyleNone(player.money))

    print("index:",index)
    if index == 1 then

    else
        
        local node = self["player_ani_" .. index]
        if node then
            node:removeSelf()
        end
        --dump(player)
        local headIcon = player:getHeadIconNum()--app.utils.game.GetOtherHeadIcon(player.wFaceID)
        local isWoman = headIcon < 6
        local aniName = ""
        if isWoman then
            -- 女 --
            aniName = "ddz_new_woman_ani"
        else
            aniName = "ddz_new_man_ani"
        end
        --print("-------------------3345454---------------------------------",aniName)
        node = ccs.Armature:create(aniName)
        --print("-------------------11111111---------------------------------",index)
        node._isWoman = isWoman
        if isWoman then
            node:getAnimation():setMovementEventCallFunc(function(sender, type, id)
                if type == ccs.MovementEventType.complete then
                    if id == "ani_showhand" then
                        sender:getAnimation():play("ani_stay")
                    elseif id == "ani_lose" then
                        sender:getAnimation():play("ani_lose")
                    elseif id == "ani_win" then
                        sender:getAnimation():play("ani_win")
                    end
                end
            end)
        else
            node:getAnimation():setMovementEventCallFunc(function(sender, type, id)
                if type == ccs.MovementEventType.complete then
                    if id == "ani_showhand" then
                        sender:getAnimation():play("ani_stay")
                    elseif id == "ain_lose" then
                        sender:getAnimation():play("ain_lose")
                    elseif id == "ain_left" then
                        sender:getAnimation():play("ain_left")
                    elseif id == "ain_right" then
                        sender:getAnimation():play("ain_right")
                    end
                end
            end)
        end
        print("-------------------55555---------------------------------",index)
        node:getAnimation():play("ani_stay")
        self.panel_player_ani:addChild(node)
        self["player_ani_" .. index] = node
        print("player_ani_:",index)

        -- node:setPosition(cc.p(241.42,498.52))
        -- if index == 2 then
        --     node:setScaleX(-1)
        --     node:setPosition(cc.p(1048.49, 510.50))
        -- end

        ----女人
        if isWoman == true and index == 2   then
            
            node:setPosition(cc.p(1048.49, 505.50))
        elseif isWoman == true and index == 3 then
             node:setPosition(cc.p(241.42,505.52))
            node:setScaleX(-1)
        ---男
        elseif isWoman == false and index == 2 then
            node:setPosition(cc.p(1048.49, 505.50))
            node:setScaleX(-1)

        elseif isWoman == false and index == 3 then
            
            node:setPosition(cc.p(241.42,505.52))
        end
    end
    self:OnPlayerUpdate(index, player)
end

---刷新牌桌上面的玩家户状态
function DdzGameScene:OnPlayerUpdate(index, player)

    local panelPlayer = self._panelPlayers[index]
    if panelPlayer.bg_player then
        panelPlayer.bg_player:setVisible(true)
    end
       -- 玩家准备状态 --
    print("player:getGameState():",player:getGameState())
    if player:getGameState() < 2 then ---没有准备
        self._icon_status[index]:setVisible(false)
    elseif player:getGameState() == 3 and self._logic:IsGamePlaying() == false  then ---已经准备
        self._icon_status[index]:setVisible(true)
    end
    panelPlayer.label_name:setString(player:getIpArea())
    --panelPlayer.label_name:setString(player.nickName)
    panelPlayer.label_gold:setString(CustomHelper.moneyShowStyleNone(player.money))
    panelPlayer.label_name:setScale(math.min(1, 170 / panelPlayer.label_name:getContentSize().width))
    panelPlayer.label_gold:setScale(math.min(1, 120 / panelPlayer.label_gold:getContentSize().width))

    ---不是自己就隐藏起来
    if index ~= 1 then
        ----暂时不显示
        panelPlayer.label_gold:setVisible(false)
        ----把名字放到中间来
        panelPlayer.label_name:setPositionY(38);  
    end

    if player:getChairId() == self._logic:getMyChairID() then 

        if player:getGameState() == gameDdz.SUB_S_GAME_CONCLUDE then
     
        else 
            self.panel_start_game:setVisible(false)
        end
    end
end

---玩家离开桌子
function DdzGameScene:OnPlayerExit(index)

    local panelPlayer = self._panelPlayers[index]


    if self._gameStatus ~= "stoped_result" and self._gameStatus ~= "stoped"  then
        self:SetShowInfoVisable(true);
    end
    

    if panelPlayer.bg_player then
        panelPlayer.bg_player:setVisible(false)
    end
    panelPlayer.label_name:setVisible(false)
    panelPlayer.label_gold:setVisible(false)

    self:OnUpdateHosting(index,false)

    --- 隐藏地主图标
    self._icon_player_identity[index]:setVisible(false)

    -- 清除准备状态标签 --
    self._icon_status[index]:setVisible(false)

    if self._panelPlayers[index].bg_card then
        self._panelPlayers[index].bg_card:setVisible(false)
    end

    -- 删除玩家动画 --
    if self["player_ani_" .. index] then
        self["player_ani_" .. index]:removeSelf()
        self["player_ani_" .. index] = nil
    end
end

---开始发牌 动画
function DdzGameScene:OnGameStart(msg)
    self._gameStatus = "started"
    -- 关闭结果界面 --
    self:HideResult()
    self:_hideReadyView()

    self:SetShowInfoVisable(false);

    for i=1,3 do
        self._panel_tip_label[i]:setString("")
        self._panel_tip[i]:setVisible(false)
        self._icon_status[i]:setVisible(false)
    end

    self.panel_start_game:setVisible(false)---开始游戏
    self.panel_call_land:setVisible(false) --- 叫分
    self.panel_game:setVisible(false) ---提示不出
    self.icon_clock:setVisible(false) ---闹钟

    self.panel_cards_1:removeAllChildren()
    self.panel_cards_2:removeAllChildren()
    self.panel_cards_3:removeAllChildren()

    for k, v in ipairs(self._icon_player_identity) do
        v:setVisible(false)
    end

    for i = 2, 3 do
        local panelPlayer = self._panelPlayers[i]
        if panelPlayer.bg_card then
            panelPlayer.bg_card:setVisible(true)
        end
        if panelPlayer.label_card then
            panelPlayer.label_card:setString(0)
        end
    end


    -- 发牌动画 --
    local myIndex  = DdzGameManager:getInstance():getDataManager():getMyChairID()
    local startIndex = DdzGameManager:getInstance():getDataManager():ConvertChairIdToIndex(myIndex)
    self:_doAni_DealCard(startIndex)

    self:runAction(transition.sequence({
        cc.DelayTime:create(4),
        cc.CallFunc:create(function()
            if self._gameStatus == "started" then
                self:OnGameCallLand(self._logic:getPlayerScoreIndex(), 0)
            end
        end)
    }))
end

---设置地主
function DdzGameScene:OnGameSetLand(index)
    self._gameStatus = "gamming"

    for i = 1, gameDdz.GAME_PLAYER do
        self._panel_tip[i]:setVisible(false)
    end


    for k, v in ipairs(self._icon_player_identity) do
        v:setVisible(true)
        local land_icon = v:getChildByTag(10086)
        land_icon:loadTexture("game_res/ddz_nongmin.png")
        if k == index then
            land_icon:loadTexture("game_res/ddz_dizhu.png")
        end
    end
end

---叫分
function DdzGameScene:OnGameCalled(index, score)
    print("index-----",index,"mul----",score);
    if index == 1 then
        self._gameStatus = "started_called"
    end

    local text = ""
    if score >= 1 and score ~= 0 then
        local config = {
            [1] = "1fen",
            [2] = "2fen",
            [3] = "3fen",
        }
        self._sound:PlayEffect_playerSound(self:IsMan(index), config[score])

        text = score .. "分"
    else
        self._sound:PlayEffect_playerSound(self:IsMan(index), "bujiao")
        text = "不叫"
    end

    self._panel_tip_label[index]:setString(text)
    self._panel_tip[index]:setVisible(true)
end

--- 设置玩家叫地主操作
function DdzGameScene:OnGameCallLand(index, mul)
    print("index-----",index,"mul----",mul);
    self:DoCountDown(15, index, "call_land")

    self.panel_call_land:setVisible(index == 1)
    self.btn_land_call:setVisible(false) ---叫地主
    self.btn_land_nocall:setVisible(true) ---不叫
    self.btn_land_call_1:setVisible(mul < 1)
    self.btn_land_call_2:setVisible(mul < 2)
    self.btn_land_call_3:setVisible(mul < 3)

    ---托管状态自动不叫
    if index == 1 and self._isTrusteeship == true then
        DdzGameManager:getInstance():sendCS_LandCallScore(0)
    end
 
end


---设置加倍按钮
function DdzGameScene:OnGameSetDouble(isVisible,isMyLand)
    self.panel_double:setVisible(isVisible)
    if isVisible == true and isMyLand == false then
        self:DoCountDown(15, 1, "call_double")
        self.panel_call_land:setVisible(false)
        self.panel_game:setVisible(false)
        
        ---托管状态自动不叫
        if  self._isTrusteeship == true then
            DdzGameManager:getInstance():sendMsgLandCallDouble(1)
        end
    end
    if isMyLand == true then
        self.dobuleTips:setVisible(true)
        self.panel_double:setVisible(false)
        self.panel_call_land:setVisible(false)
        self.panel_game:setVisible(false)
        print("不显示")
    end
end

function DdzGameScene:setGaneDobleCountDown(doubleCountDown)
    self:DoCountDown(doubleCountDown, 1, "call_double")
end

----显示加倍标志
function DdzGameScene:showPlayerDoubleIcon(index,isDouble,doubleCountDown,isRecovery)
    
    if index ~= 1 and (isDouble==1 or isDouble==2) and isRecovery == false then -- 播放不是自己的加倍音效 isDouble 1是false    2是true
        self._sound:PlayerEffect_Double(self:IsMan(index),isDouble==2)
    end
    ---自己没有加倍 同时还在加班倒计时内
    if index == 1 and isDouble == 3 and doubleCountDown > 0 then
        self:DoCountDown(doubleCountDown - 1, 1, "call_double")
        self.panel_double:setVisible(true)
    else
        if index == 1 then

            self:OnGameSetDouble(false,false)
        end
    end

    if isDouble == 1 then
        self._panelPlayers[index].image_double:setVisible(false)
    elseif isDouble == 2 then
        --todo
        self._panelPlayers[index].image_double:setVisible(true)
    end
    if doubleCountDown > 0 then
        self:DoCountDown(doubleCountDown - 1, 1, "call_double")
    end
end

---加倍按钮是否显示状态
function DdzGameScene:getIsPanel_doubleVisible(  )
    -- body
    return self.panel_double:isVisible()
end

--- 设置该谁出牌
function DdzGameScene:OnGameCall(index, cbTurnOver,bstart)

    self.dobuleTips:setVisible(false)
    self._cardsTypeHelpIndex = 1

    ---当前出牌玩家
    self._currentOutCardPlayer = index

    if bstart then
        self:DoCountDown(15, index, "call_game_first")
        self:UpdatePlayerCardNum(index, 20)
    else
        if cbTurnOver then
            self:DoCountDown(15, index, "call_game_first")
        else
            self:DoCountDown(15, index, "call_game")
        end
    end

    self.panel_call_land:setVisible(false)
    self.panel_game:setVisible(index == 1)
    self.btn_game_call:setVisible(true)
    self.btn_game_help:setVisible(true)
    self.btn_game_pass:setVisible(true)
    self.btn_game_pass_2:setVisible(false)
    self.icon_tip_no_bnig_card:setVisible(false)

    if index == 1 then
        --
        --dump(tempCards, "desciption, nesting")
        --dump(self._logic._lastCards, "self._logic._lastCards")
        local cards = gameDdz.DdzRules.NewSearchOutCardForHelp(self._logic._cards,self._logic._lastCards) 
        

        if cbTurnOver or (cards and #cards > 0) then --
            self.btn_game_call:setVisible(true)
            self.btn_game_help:setVisible(true)
            self.btn_game_pass:setVisible(not cbTurnOver)
            self.btn_game_pass_2:setVisible(false)
            self.icon_tip_no_bnig_card:setVisible(false)
        else
            self.btn_game_call:setVisible(false)
            self.btn_game_help:setVisible(false)
            self.btn_game_pass:setVisible(false)
            self.btn_game_pass_2:setVisible(true)
            self.icon_tip_no_bnig_card:setVisible(true)
            --self:DoPutDownAllCards();

            local time = math.random(5,10)
            self:runAction(transition.sequence({
                cc.DelayTime:create(time),
                cc.CallFunc:create(function()
                    if self.btn_game_pass_2:isVisible() == true then
                        -- 打不过后自动PASS --
                        DdzGameManager:getInstance():sendCS_LandPassCard()
                    end
                end)
            }))
        end
        ---托管状态不显示按钮
        if self._isTrusteeship == true then
            --todo
            self.panel_game:setVisible(false)
        end
    end
    local node = self["panel_cards_" .. index]
    node:removeAllChildren()
    print("要显示-------")
end

---隐藏出牌按钮
function DdzGameScene:setGameMenuVisible()
    -- body
    self.panel_game:setVisible(false)
end

----
function DdzGameScene:onGameOverTure()
    for i = 1, gameDdz.GAME_PLAYER do
        self._panel_tip[i]:setVisible(false)
        local node = self["panel_cards_" .. i]
        if node then
            node:removeAllChildren()
        end
    end
end


----显示自己的手牌
function DdzGameScene:showMyCards()

    MyToastLayer.new(self, "你的网络不好,托管出牌!!!");
   -- 更新手牌 --
    for _,v in ipairs(self._myCards) do
        v:removeSelf()
    end
    self._myCards = {}

    local tempCards = {}
    for _,v in ipairs(self._logic._cards) do
        table.insert(tempCards,v)
    end
    gameDdz.DdzHelper.SortCard(tempCards)

    local widthCard = gameDdz.DdzPoker.WIDTH * MY_CARD_SCALE
    local heightCard = gameDdz.DdzPoker.HEIGHT * MY_CARD_SCALE
    local offsetX = -((#tempCards - 1) * MY_CARD_INTERVAL + gameDdz.DdzPoker.WIDTH * MY_CARD_SCALE) / 2
    for k,v in ipairs(tempCards) do
        local poker0 = gameDdz.DdzPoker.new(true, v)
        poker0:setScale(MY_CARD_SCALE)
        poker0:pos(offsetX + (k - 1) * MY_CARD_INTERVAL + widthCard / 2, heightCard / 2)
        self.panel_cards:addChild(poker0)
        table.insert(self._myCards, poker0)
    end
end

----显示自己出的牌
function DdzGameScene:showMyOutCards(cards)

    local leftCardNum = self._logic._cardCount[self._logic._myChairId] - #cards
    self:OnGamePlayerOutCard(1,cards,self._logic._lastCards, leftCardNum,false)
end

---显示谁出的牌
function DdzGameScene:OnGamePlayerOutCard(index, cards, lastCards, leftCardNum, noNextPlayer)
    -- 播放玩家出牌动画 --
    --print("OnGamePlayerOutCard:",index)
    local amature = self["player_ani_" .. index]
    if cards and amature then
        amature:getAnimation():play("ani_showhand")
    end
    local text = ""

    -- 播放音乐 --
    -- if not noNextPlayer then
    local randomKey = math.random(100)
    text = self._sound:PlayerEffect_cardSound(self:IsMan(index), cards, lastCards, leftCardNum, randomKey)
    
    -- 播放特殊的牌型动画 --
    self:_doAni_PlayerOutCardEff(cards)


    local newCardType = gameDdz.DdzRules.getNewCardType(cards)
    --dump(newCardType,"newCardType")

    -- ----3带
    -- local cardType = gameDdz.DdzRules.getNewCardType(cards)
    --  dump(cardType,"cardType")

    if newCardType.cardType == gameDdz.DdzRules.CT_THREE_TAKE_ONE or newCardType.cardType == gameDdz.DdzRules.CT_THREE_TAKE_TWO 
        or newCardType.cardType ==  gameDdz.DdzRules.CT_FEIJI_ONE or newCardType.cardType ==  gameDdz.DdzRules.CT_FEIJI_TWO then

        cards = gameDdz.DdzRules.showCardsTypeSort(cards)
    ---4带2
    elseif newCardType.cardType == gameDdz.DdzRules.CT_FOUR_TAKE_ONE or newCardType.cardType == gameDdz.DdzRules.CT_FOUR_TAKE_TWO then -- 四带两对 then
        cards = gameDdz.DdzRules.showCardsTypeSort(cards)
    else
        if cards~=nil and  #cards > 2 then
            gameDdz.DdzHelper.SortCard(cards)
        end
    end


    local node = self["panel_cards_" .. index]
    node:removeAllChildren()

    for i = 1, gameDdz.GAME_PLAYER do
        self._panel_tip[i]:setVisible(false)
    end
   
    if cards then
        for k, v in ipairs(cards) do
           local poker0 = gameDdz.DdzPoker.new(true, v)
            poker0:setScale(OTHER_CARD_SCALE)
            if index == 1 then
                poker0:setPosition(cc.p(-((#cards - 1) * OTHER_CARD_INTERVAL + poker0:getContentSize().width * poker0:getScale()) / 2
                        + (k - 1) * OTHER_CARD_INTERVAL + poker0:getContentSize().width * poker0:getScale() / 2, 0))
            elseif index == 2 then
                poker0:setAnchorPoint(1, 0)
                poker0:setPosition(cc.p(-(#cards - k) * OTHER_CARD_INTERVAL, -5))
            elseif index == 3 then
                poker0:setAnchorPoint(0, 0)
                poker0:setPosition(cc.p((k - 1) * OTHER_CARD_INTERVAL, -10))
            end

            node:addChild(poker0)
        end

        if index == 1 then
            for k, v in ipairs(cards) do
                for kk, vv in ipairs(self._myCards) do
                    vv:stopAllActions()

                    if vv:GetPoint() == v then
                        vv:removeSelf()
                        table.remove(self._myCards, kk)
                        break
                    end
                end
            end

            local offsetX = -((#self._myCards - 1) * MY_CARD_INTERVAL + gameDdz.DdzPoker.WIDTH * MY_CARD_SCALE) / 2
            for k, v in ipairs(self._myCards) do
                v:pos(offsetX + (k - 1) * MY_CARD_INTERVAL + v:getContentSize().width * v:getScale() / 2,
                v:getContentSize().height * v:getScale() / 2)
            end
        end
    else
        self._panel_tip_label[index]:setString(text or "")
        self._panel_tip[index]:setVisible(true)
    end
end

---游戏结束
function DdzGameScene:OnGameEnd(result)

    dump(result,"result----1")
    ---设置断线重连数据为
    GameManager:getInstance():getHallManager():getPlayerInfo():setGamingInfoTab(nil)

    ---取消托管
    for i=1,3 do
        self.panel_tuoguan_icon[i]:setVisible(false)
    end
    if self._isTrusteeship == true then
        DdzGameManager:getInstance():sendMsgLandTrusteeship();
        self:OnUpdateHosting(1, false)
    end

    self.icon_clock:setVisible(false)

    self.panel_tuoguan_bg:setVisible(false)
   
    self:SetDoubleIconVisable(false)

    self._gameWaitTime = 0

    self:initPanel_TimeoutWait(0)
    
    self._gameStatus = "stoped"

    -- 终止倒计时 --
    self:DoResetCountDown()

    -- 只播放自己的声音 --
    if result.scoreIndex[1].value > 0 then
        self._sound:PlayEffect_playerSound(self:IsMan(1), "win")
    end

    for index = 2, 3 do
        local amature = self["player_ani_" .. index]
        if amature then
            local aniName = "ani_lose"
            if result.scoreIndex[index].value > 0 then
                aniName = "ani_win"
            end

            if not amature._isWoman and result.scoreIndex[index].value > 0 then
                amature:getAnimation():play("ani".. (index == 2 and "_right" or "_left"))
            else
                amature:getAnimation():play(aniName)
            end
        end
    end

    self.panel_game:setVisible(false)
    self.btn_game_start_empty:setVisible(false)
    self.btn_game_start:setVisible(false)
    self.btn_game_change_table:setVisible(false)

    self.panel_start_game:setVisible(false)

    --显示牌的数目为0
    local background = self.m_widget:getChildByName("background")
    local desktop = background:getChildByName("desktop")
    for i = 1, 2 do
        local bg_card = desktop:getChildByName("bg_card_" .. i)
        local label_num = bg_card:getChildByName("label_num")
        label_num:setString(0)
    end

    self:runAction(transition.sequence({
        cc.DelayTime:create(1),
        cc.CallFunc:create(function()
            self._gameStatus = "stoped_result"
            self:ShowResult(result, function()

                for index = 2, 3 do
                    local amature = self["player_ani_" .. index]
                    if amature then
                        amature:getAnimation():play("stay")
                    end
                end

                if self._gameStatus == "stoped_result" then
                    for k, v in ipairs(self._icon_player_identity) do
                        v:setVisible(false)
                    end
                    -- 清除桌面 --
                    self._myCards = {}
                    self.panel_cards:removeAllChildren()
                    self.panel_land_card_1:removeAllChildren()
                    self.panel_land_card_2:removeAllChildren()
                    self.panel_land_card_3:removeAllChildren()

                    for i = 1, gameDdz.GAME_PLAYER do
                        self._panel_tip[i]:setVisible(false)
                        local node = self["panel_cards_" .. i]
                        if node then
                            node:removeAllChildren()
                        end
                    end

                    self.btn_game_change_table:setVisible(false)
                    self.panel_call_land:setVisible(false)

                    if self._logic._userInfo:getGameState()  == gameDdz.SUB_S_GAME_CONCLUDE then
   
                    end
                    self.panel_game:setVisible(false)
                end
            end)
        end),
    }))
end

---叫分阶段掉线重连要初始化上面的地主牌
function DdzGameScene:OnGameRecoveryShowLandPoker( )
    for i = 52,54 do
        local node = self["panel_land_card_" .. (i - 51)]
        local poker0 = gameDdz.DdzPoker.new(false, 0)
        poker0:setScale(math.min(node:getContentSize().width / poker0:getContentSize().width,node:getContentSize().height / poker0:getContentSize().height))
        poker0:setPosition(cc.p(poker0:getContentSize().width * poker0:getScale() / 2,poker0:getContentSize().height * poker0:getScale() / 2))
        poker0:setVisible(true)
        node:addChild(poker0,100)
        table.insert(self._landCards, poker0)
    end
end

--- 玩家掉线托管后重新进入的场景消息处理
function DdzGameScene:onGameStatusPlayer(msg)
    -- 更新地主牌 --
    for k,v in ipairs(msg.landcards) do
        local node = self["panel_land_card_" .. k]
        local poker0 = gameDdz.DdzPoker.new(true, v)
        poker0:setScale(math.min(node:getContentSize().width / poker0:getContentSize().width,node:getContentSize().height / poker0:getContentSize().height))
        poker0:pos(poker0:getContentSize().width * poker0:getScale() / 2-640,poker0:getContentSize().height * poker0:getScale() / 2)
        node:addChild(poker0,100)
        table.insert(self._landCards, poker0)
    end
    -- 更新手牌 --
    for _,v in ipairs(self._myCards) do
        v:removeSelf()
    end
    self._myCards = {}

    local tempCards = {}
    for _,v in ipairs(msg.cards) do
        table.insert(tempCards,v)
    end
    gameDdz.DdzHelper.SortCard(tempCards)

    local widthCard = gameDdz.DdzPoker.WIDTH * MY_CARD_SCALE
    local heightCard = gameDdz.DdzPoker.HEIGHT * MY_CARD_SCALE
    local offsetX = -((#tempCards - 1) * MY_CARD_INTERVAL + gameDdz.DdzPoker.WIDTH * MY_CARD_SCALE) / 2
    for k,v in ipairs(tempCards) do
        local poker0 = gameDdz.DdzPoker.new(true, v)
        poker0:setScale(MY_CARD_SCALE)
        poker0:pos(offsetX + (k - 1) * MY_CARD_INTERVAL + widthCard / 2, heightCard / 2)
        self.panel_cards:addChild(poker0)
        table.insert(self._myCards, poker0)
    end

    -- 更新上一个玩家出的牌 --
    local cbCardData = {}
    if msg.lastCards ~= nil then
        for _,v in ipairs(msg.lastCards) do
            table.insert(cbCardData,v)
        end
    end


    local curUser = self._logic:ConvertChairIdToIndex(msg.lastcardid)
    print(curUser,"curUser-1")
    local x  = (curUser - 1 + 3 - 1) % 3 + 1
    print(x,"curUser-2")

    local node = self["panel_cards_" .. curUser]
    node:removeAllChildren()
    if #cbCardData > 0 then
        for k, v in ipairs(cbCardData) do
            local poker0 = gameDdz.DdzPoker.new(true, v)
            poker0:setScale(OTHER_CARD_SCALE)
            if curUser == 1 then
                poker0:setPosition(cc.p(-((#cbCardData - 1) * OTHER_CARD_INTERVAL + poker0:getContentSize().width * poker0:getScale()) / 2
                        + (k - 1) * OTHER_CARD_INTERVAL + poker0:getContentSize().width * poker0:getScale() / 2, 0))
                print(-((#cbCardData - 1) * OTHER_CARD_INTERVAL + poker0:getContentSize().width * poker0:getScale()) / 2
                        + (k - 1) * OTHER_CARD_INTERVAL + poker0:getContentSize().width * poker0:getScale() / 2,"----------3")
            elseif curUser == 2 then
                poker0:setAnchorPoint(1, 0)
                poker0:setPosition(cc.p(-(#cbCardData - k) * OTHER_CARD_INTERVAL, 0))
            elseif curUser == 3 then
                poker0:setAnchorPoint(0, 0)
                poker0:setPosition(cc.p((k - 1) * OTHER_CARD_INTERVAL, 0))
            end
            node:addChild(poker0)
        end
    end
end

function DdzGameScene:OnGameRecoveryPlayerCallScore(msg)
    -- body
     -- 更新手牌 --
    for _,v in ipairs(self._myCards) do
        v:removeSelf()
    end
    self._myCards = {}

    local tempCards = {}
    for _,v in ipairs(msg.cards) do
        if v >= 0 then
            table.insert(tempCards,v)
        end
    end
    gameDdz.DdzHelper.SortCard(tempCards)

    local widthCard = gameDdz.DdzPoker.WIDTH * MY_CARD_SCALE
    local heightCard = gameDdz.DdzPoker.HEIGHT * MY_CARD_SCALE
    local offsetX = -((#tempCards - 1) * MY_CARD_INTERVAL + gameDdz.DdzPoker.WIDTH * MY_CARD_SCALE) / 2
    for k,v in ipairs(tempCards) do
        local poker0 = gameDdz.DdzPoker.new(true, v)
        poker0:setScale(MY_CARD_SCALE)
        --poker0:SetTouchDelegate(handler(self, self._onTouched_poker))
        poker0:pos(offsetX + (k - 1) * MY_CARD_INTERVAL + widthCard / 2, heightCard / 2)
        self.panel_cards:addChild(poker0)
        table.insert(self._myCards, poker0)
    end

end



function DdzGameScene:OnUpdateHosting(chairIndex, enabled)

    print(chairIndex,"chairIndex:",enabled)
    if chairIndex == 1 then
        self._countdownErrorTime = 0

        self.btn_robot:setBright(not enabled)
        ---保存状态
        self._isTrusteeship = enabled

        self.panel_tuoguan_bg:setVisible(enabled)

        self.btn_cancel_tuoguan:setVisible(enabled)
        ---隐藏闹钟
        self:showClock(chairIndex)

        ----
        if self._currentOutCardPlayer == 1  then
            if self._logic:IsGmaeDobule() == true then
                print("托管走这里-------11111")
                self.panel_game:setVisible(false)
            else
                 print("托管走这里-------")
                self.panel_game:setVisible(not enabled)
            end
        end

        if self._logic:IsGamePlaying() == false then
            self.panel_game:setVisible(false)
        end
    end

    self.panel_tuoguan_icon[chairIndex]:setVisible(enabled)
end

function DdzGameScene:DoPutDownAllCards()
    for k, v in ipairs(self._myCards) do
        v:SetSelected(false)
    end
end

function DdzGameScene:DoResetCountDown()
    self._countdownTotal = 0
    self._countdown = 0
    self._countdownType = nil
    self:_onInterval()
end

function DdzGameScene:DoCountDown(time, index, type)
    print("33331111111:---")
    if 1 <= index and index <= gameDdz.GAME_PLAYER then
        self._countdownTotal = time
        self._countdown = time
        if index == 1 then
            self._countdownType = type
        end

        self.icon_clock:setVisible(true)
        ---自己托管就隐藏闹钟

        self.icon_clock:setPosition(self._node_clock[index]:getPosition()) --pos(self._node_clock[index]:getPosition())

        self:_onInterval() 

        ---自己是不是托管状态 显示闹钟
        self:showClock(index)
    end
end

function DdzGameScene:IsMan(index)
    if index == 1 then
        local headIcon =  GameManager:getInstance():getHallManager():getPlayerInfo():getHeadIconNum() --app.utils.game.GetHeadIcon()
        return headIcon > 5
    else
        local node = self["player_ani_" .. index]
        return node and not node._isWoman
    end
end

---退出游戏界面
function DdzGameScene:jumpToHallScene()
    DdzGameManager:getInstance():clearLoadedOneGameFiles()
    DdzGameScene.instance = nil
    SceneController.goHallScene();
    local subGameManager = GameManager:getInstance():getHallManager():getSubGameManager();
    if subGameManager ~= nil then
        subGameManager:onExit();
    end
end

---更新用户牌数量
function DdzGameScene:UpdatePlayerCardNum(index, num)
    if self._panelPlayers[index].label_card then
        self._panelPlayers[index].label_card:setString(num)
    end
end

function DdzGameScene:UpdateMul(mul, force)
    local old_Mul = self._mul
    print("mul:",mul,"force:",fprce)
    self._mul = mul


    mul = mul % 100
    local _s = math.floor(mul / 10)
    local _g = mul % 10
    if force then
        self.label_mul_1:setString(_s)
        self.label_mul_2:setString(_g)
    else
        local _mm = self._mul - old_Mul
        local time = 0.5
        if _mm == 1 or _mm == -1 then
            time = 0
        end
        self.label_mul_1:runAction(ccext.FuncAction:create(time, function(sender, percent)
            local value = old_Mul + math.floor(_mm * percent)
            value = value % 100
            local _s = math.floor(value / 10)
            local _g = value % 10

            self.label_mul_1:setString(_s)
            self.label_mul_2:setString(_g)
        end))
    end
end


function DdzGameScene:UpdateCardRecord()
    if self._recordVisible then
        local records = self._logic:GetCardsRecord()
        local myCards =  self._logic._cards
        --dump(records , "records")
        --dump(myCards , "myCards")
        local restRecords = {}
        for i=1,15 do
            restRecords[i] = records[i]
        end
        for k,v in pairs(myCards) do
            local cardValue = gameDdz.DdzRules.GetCardValue(v)
            print("cardValue = "..cardValue.." v = "..v)

            restRecords[gameDdz.DdzRules.VALUE_TABLE[cardValue]] = restRecords[gameDdz.DdzRules.VALUE_TABLE[cardValue]]-1
        end
        --dump(restRecords , "restRecords")

        for i = 1, 15 do
            self.panel_card_tip.label_nums[i]:setString(string.format("%d张", restRecords[i] or 0))
        end
    end
end

---游戏结束更新数据
function DdzGameScene:UpdateResult(data)

    self._result.icon_title:loadTexture(data.landWin and CustomHelper.getFullPath("icon_win_land.png")
            or CustomHelper.getFullPath("icon_win_farmer.png"))
    for k, v in ipairs(data.score) do
        self._result["labbel_name_" .. k]:setString(v.name)
        self._result["label_value_" .. k]:setString(CustomHelper.moneyShowStyleNone(v.value))

        --税收
        self._result["label_tax_" .. k]:setString(0)
        if  v.tax ~= 0  then
            self._result["label_tax_" .. k]:setString(CustomHelper.moneyShowStyleNone(v.tax))
            self._result["label_tax_" .. k]:setVisible(true)
        else
            self._result["label_tax_" .. k]:setVisible(false)
        end


        ---加倍
        if v.double == 1 then
            self._result["label_double_" .. k]:setVisible(true)
        else
            self._result["label_double_" .. k]:setVisible(false)
        end
        
        self._result["label_self_" .. k]:setVisible(data.isSelf[k])

        if data.isSelf[k] then
            --self._result.icon_slef_highlight:setPositionY(self._result["label_self_" .. k]:getPositionY())
            self._result["icon_slef_highlight_"..k]:loadTexture("game_res/bg_self_highlight.png")
        end

        if v.value > 0 then
            self._result["label_value_" .. k]:setColor(cc.c3b(0xFC, 0xF9, 0xC4))
        else
            self._result["label_value_" .. k]:setColor(cc.c3b(0xFF, 0x00, 0x1E))
        end
    end

    self._result.label_result:setString(data.cardInfoText or "")

    local count = #self.gameEndCardsNode
    for i=count,1,-1 do
        self._result.bg_result:removeChild(self.gameEndCardsNode[i])
    end
    self.gameEndCardsNode = {};
    ---显示卡牌

    local index = 0;
    for i=1,3 do
        if data.cards[i] ~= 0 then
            local userCards = data.cards[i]
            print("data.palyerName[i]:",data.palyerName[i])
            if index == 0 then
                --gameDdz.DdzHelper.SortAscenCard(userCards)
                gameDdz.DdzHelper.SortCard(userCards)
                self._result.playerCard_1:setString( data.palyerName[i])

            else
                gameDdz.DdzHelper.SortCard(userCards)
                self._result.playerCard_2:setString( data.palyerName[i])
                
            end
            for k,v in ipairs(userCards) do
                local poker0 = gameDdz.DdzPoker.new(true, v)
                self._result.bg_result:addChild(poker0,100)
                poker0:setScale(0.25)
                 if index == 1 then
                    poker0:setPosition(cc.p(540+k*13,440))--420
                    self._result.bg_result:getParent():reorderChild(poker0,100+k)
                    if k > 10 then
                        poker0:setPosition(cc.p(540+(k-10)*13,410))
                    end
                else
                    poker0:setPosition(cc.p(120+k*13,440)) ---270
                    self._result.bg_result:getParent():reorderChild(poker0,100+k)
                    if k > 10 then
                        poker0:setPosition(cc.p(120+(k-10)*13,410))
                    end
                end
                --poker0:setPosition(cc.p(450+index*270+k*10,400))
                
                table.insert(self.gameEndCardsNode , poker0)
            end
            index = index+1
        end
    end
end

----关闭结束界面同时退出游戏
function DdzGameScene:HideResult()
    self._result.label_time:stopAllActions()

    if not self._bShow then
        return
    end
    self._bShow = false
    self._result.self:setTouchEnabled(false)
    self._result.self:setSwallowTouches(false)

    self._result.self:stopAllActions()
    self._result.self:runAction(cc.FadeOut:create(0.1))

    self._result.bg_result:stopAllActions()
    self._result.bg_result:runAction(transition.sequence({
        cc.MoveBy:create(0.1, cc.p(0, display.height)),
        cc.CallFunc:create(function(sender)
            self._result.self:setVisible(false)
            if self._resultHandler then
                self._resultHandler()
            end
        end)
    }))
    return true
end


function DdzGameScene:OnUpdateSoundSwitch(enabled)
    self.btn_sound:setBright(enabled)
end

function DdzGameScene:SetSoundOn(bSoundOn)
    if bSoundOn then
        GameManager:getInstance():getMusicAndSoundManager():setSoundSwitch(true)
    else
        GameManager:getInstance():getMusicAndSoundManager():setSoundSwitch(false)
        GameManager:getInstance():getMusicAndSoundManager():stopAllSound()
    end
    self:OnUpdateSoundSwitch(bSoundOn)
end

function DdzGameScene:OnUpdateMusicSwitch(enabled)
    self.btn_music:setBright(enabled)
end

function DdzGameScene:SetMusicOn(bMusicOn)
    if bMusicOn then
        GameManager:getInstance():getMusicAndSoundManager():setMusicSwitch(true)
        self._sound:PlayBgm()
    else
        GameManager:getInstance():getMusicAndSoundManager():setMusicSwitch(false)
        GameManager:getInstance():getMusicAndSoundManager():stopMusic()
    end
    self:OnUpdateMusicSwitch(bMusicOn)
end

function DdzGameScene:ShowResult(msg, handler)
    self._resultHandler = handler

    self._result.self:setVisible(true)
    self._result.self:setTouchEnabled(true)
    self._result.self:setSwallowTouches(true)

    self._result.self:stopAllActions()
    self._result.self:runAction(cc.FadeIn:create(0.1))

    self._result.bg_result:stopAllActions()
    self._result.bg_result:runAction(transition.sequence({
        cc.CallFunc:create(function(sender)
            sender:setPosition(cc.p(self._result.bg_result_pos[1], self._result.bg_result_pos[2] + display.height))
        end),
        cc.MoveTo:create(0.3, cc.p(self._result.bg_result_pos[1], self._result.bg_result_pos[2])),
        cc.MoveBy:create(0.05, cc.p(0, 20)),
        cc.MoveBy:create(0.04, cc.p(0, -20)),
         cc.CallFunc:create(function()
            self._bShow = true
         end)

    }))
    --托管暂时没有
    --self._logic:SendMsg_CacelHosting()

    local countDown = 15
    self._result.label_time:runAction(cc.Repeat:create(transition.sequence({
        cc.CallFunc:create(function(sender)
            sender:setString(countDown .. "S")
            countDown = countDown - 1
            if countDown < 0 then
                -- 私人房默认准备
                if GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateRoom() then
                    self:_resultAutoReady()
                else
                    if self:isContinueGameConditions() == true then
                        --是托管都T掉
                        if self._isTrusteeship == true then

                            DdzGameManager:getInstance():sendStandUpAndExitRoomMsg();
                        else
                            ---自动准备
                            -- DdzGameManager:getInstance():sendGameReady()
                            -- self:HideResult()
                            -- self:SetShowInfoVisable(true)
                            DdzGameManager:getInstance():sendStandUpAndExitRoomMsg();
                        end
                    end
                end
            end
        end),
        cc.DelayTime:create(1.0),
    }),countDown + 1))

    -- 更新界面 --
    self:UpdateResult(msg)
end

function DdzGameScene:_resultAutoReady()
    if self:isContinueGameConditions() == true then
        self._gameStatus = nil
        DdzGameManager:getInstance():sendGameReady()
        self:HideResult() 
        self:SetShowInfoVisable(true)
    end
end

function DdzGameScene:ShowHelp(bShow)
    if bShow then
        self.panel_info:setVisible(true)
        self.panel_info:stopAllActions()
        self.panel_info:runAction(transition.sequence({
            cc.FadeIn:create(0.2),
        }))

        self.panel_info_bg:setPosition(cc.p(self.panel_info_bg_pos[1], self.panel_info_bg_pos[2] + display.height))
        self.panel_info_bg:stopAllActions()
        self.panel_info_bg:runAction(transition.sequence({
            cc.MoveTo:create(0.3, cc.p(self.panel_info_bg_pos[1], self.panel_info_bg_pos[2])),
            cc.MoveBy:create(0.05, cc.p(0, 20)),
            cc.MoveBy:create(0.04, cc.p(0, -20)),
        }))
    else
        self.panel_info:stopAllActions()
        self.panel_info:runAction(transition.sequence({
            cc.FadeOut:create(0.2),
            cc.CallFunc:create(function(sender)
                sender:setVisible(false)
            end)
        }))

        self.panel_info_bg:stopAllActions()
        self.panel_info_bg:runAction(transition.sequence({
            cc.MoveTo:create(0.1, cc.p(self.panel_info_bg_pos[1], self.panel_info_bg_pos[2] + display.height)),
        }))
    end
end

function DdzGameScene:HitTestAtCard(pos)
    local hitCard = nil
    for i = 1, #self._myCards do
        local index = #self._myCards - i + 1
        local card = self._myCards[index]
        local rect = card:getBoundingBox();
        rect.y = 79
        rect.width = 138
        rect.height = 179
        local contains = cc.rectContainsPoint(rect, cc.p(pos.x, pos.y)) 
        if contains  then --card:hitTest(pos)
            hitCard = card
            break
        end
    end
    return hitCard
end


---如果自己托管就不显示倒计时钟
function DdzGameScene:showClock(index)

    print("index:",index);
    if self._isTrusteeship == true and self._currentOutCardPlayer == 1 then
        self.icon_clock:setVisible(false)
    else 
        if self._logic:IsGamePlaying() == true then
            self.icon_clock:setVisible(true)
        end
    end
end

---显示
function DdzGameScene:SetShowInfoVisable(bvisable)
    if bvisable == nil then return end
    self.panel_shadow:setVisible(bvisable)
   
end

---设置加倍是否显示
function DdzGameScene:SetDoubleIconVisable(isVisible)
    for i=1,3 do
        self._panelPlayers[i].image_double:setVisible(isVisible)
    end
end

---电量信号UI
function DdzGameScene:initDeviceUtilInfo( )
    local CCSLuaNode =  requireForGameLuaFile("ddzGameDeviceInfoCCS")
    deviceInfoNode = CCSLuaNode:create().root;

    self:addChild(deviceInfoNode)
    deviceInfoNode:setPosition(cc.p(0,display.height))
    
    local Panel_DeviceUtil = deviceInfoNode:getChildByName("Panel_DeviceUtil")
    self.batteryLevelNode = tolua.cast(CustomHelper.seekNodeByName(Panel_DeviceUtil, "dianliang"), "ccui.ImageView")
    self.chargeNode = tolua.cast(CustomHelper.seekNodeByName(Panel_DeviceUtil, "chongdian"), "ccui.ImageView")

    ---wifi信号
    self.wifi_bg = tolua.cast(CustomHelper.seekNodeByName(Panel_DeviceUtil, "wifi_bg"), "ccui.ImageView")
    self.wifiNode = {}
    for i = 1,3 do
        local wifiImage = tolua.cast(CustomHelper.seekNodeByName(self.wifi_bg, "wifi_"..i), "ccui.ImageView");
        table.insert(self.wifiNode,wifiImage)
    end

    ---移动信号
    self.mobil_bg = tolua.cast(CustomHelper.seekNodeByName(Panel_DeviceUtil, "liuliang_bg"), "ccui.ImageView")
    self.mobilNode = {}
    for i=1,2 do
        local mobilImage = tolua.cast(CustomHelper.seekNodeByName(self.mobil_bg , "liuliang_"..i), "ccui.ImageView");
        table.insert(self.mobilNode,mobilImage)
    end

end

---电量显示
function DdzGameScene:SetDeviceUtilInfo()

    ---电量
    local batteryLevel = DeviceUtils.getBatteryLevel()
    if batteryLevel > 0 then
        self.batteryLevelNode:setScaleX(batteryLevel/100);
    else
        self.batteryLevelNode:setVisible(false)
    end
    

    ---是否充电
    local  batteryStatus =  DeviceUtils.getBatteryStatus()
    if batteryStatus == true then
        self.chargeNode:setVisible(true);
    else
        self.chargeNode:setVisible(false)
    end

    ----信号类型
    local  onnectivityType = DeviceUtils.getConnectivityType()

    if onnectivityType == 0  then --none
        for i,v in ipairs(self.wifiNode) do
            self.wifiNode[i]:setVisible(false)
        end
        for i,v in ipairs(self.mobilNode) do
            self.mobilNode[i]:setVisible(false)
        end
        self.wifi_bg:setVisible(true)
        self.mobil_bg:setVisible(false)

    elseif onnectivityType == 2 then ---mobil
        self.wifi_bg:setVisible(false)
        self.mobil_bg:setVisible(true)
        local mobileSignalLevel = DeviceUtils.getMobileSignalLevel();
        
        if mobileSignalLevel == 0 then
            for i,v in ipairs(self.mobilNode) do
                self.mobilNode[i]:setVisible(false)
            end
        
        elseif mobileSignalLevel >=3 then
            for i,v in ipairs(self.mobilNode) do
                self.mobilNode[i]:setVisible(true)
            end

        elseif mobileSignalLevel <=2   then
            self.mobilNode[1]:setVisible(true)
            self.mobilNode[2]:setVisible(false)
        end

    elseif onnectivityType == 1 then ---wifi

        self.wifi_bg:setVisible(true)
        self.mobil_bg:setVisible(false)
        local wifiSignalLevel = DeviceUtils.getWifiSignalLevel();
        if wifiSignalLevel == 0 then
            for i,v in ipairs(self.wifiNode) do
                self.wifiNode[i]:setVisible(false)
            end
        ---3格信号以上
        elseif wifiSignalLevel >=3 then
            for i,v in ipairs(self.wifiNode) do
                self.wifiNode[i]:setVisible(true)
            end
        ---2格信号
        elseif wifiSignalLevel == 2   then
            self.wifiNode[1]:setVisible(true)
            self.wifiNode[2]:setVisible(true)
            self.wifiNode[3]:setVisible(false)
        ---1格信号
        elseif wifiSignalLevel == 1 then
            self.wifiNode[1]:setVisible(true)
            self.wifiNode[2]:setVisible(false)
            self.wifiNode[3]:setVisible(false)
        end
    end
end


---显示坐下玩家
function DdzGameScene:showPlayerSitDownInfo()

    for k,v in pairs(self._logic._chairs) do
        self:OnPlayerEnter(self._logic:ConvertChairIdToIndex(k), v)
    end
end

----是否可以继续游戏判断条件
function DdzGameScene:isContinueGameConditions()
    if GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateRoom() then
        return true
    end

    if DdzGameScene.super.isContinueGameConditions(self) == false then
        self:alertAlertViewWhenServerMaintain();
        return false
    end
    local roomInfo = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab();
    if roomInfo[HallGameConfig.SecondRoomMinMoneyLimitKey] then
        if GameManager:getInstance():getHallManager():getPlayerInfo():getMoney() < roomInfo[HallGameConfig.SecondRoomMinMoneyLimitKey] then
            CustomHelper.showAlertView(
                "金币不足，退出房间!!!",
                false,
                true,
                function(tipLayer)
                    self:jumpToHallScene()
                end,
                function(tipLayer)
                    self:jumpToHallScene();
                end)
            return false
        end
    end
    --DdzGameManager:getInstance():sendMsgChangeTable()
    return true
end

function DdzGameScene:_isPrivateShowingReady()
    if self._gameStatus == nil or self._gameStatus == "stoped_result" or self._gameStatus == "stoped"  then
        return true
    else
        return false
    end
end

return DdzGameScene;
