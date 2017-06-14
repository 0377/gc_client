--[[
    用于控制testgame中相关数据
]]
DdzGameDataManager = class("DdzGameDataManager");
local DdzGameScene = import("..views.DdzGameScene");
local DdzPlayerInfo = import("..model.DdzPlayerInfo")
import("..views.DdzHelper")
import("..views.DdzMsgId")
local scheduler = cc.Director:getInstance():getScheduler() 

function DdzGameDataManager:initData()
    
    self._myChairId = 0;

    self._LandChairId = 0;---地主ID

    self._userInfo = nil;

    self._callScoreTimes = 0 --第几人叫地主
    -- 桌子上玩家的信息 --
    self._chairs = {}

    self._cards = {}

    self._cardCount = {}

    self._cardRecords = {}

    self._outPlayerInfo = {};

    self._landInfo = nil; --- 地主

    self._landCallScoreMsg = nil ---叫分

    self._isPlaying = false

    self._callScore = 0

    self._playerGoRoomInfo = nil;

    self._tempMulBomb = 0

    self._playerBoubleInfo = {} ---保存加倍情况

    self._isDouble = false;

    self._myOutCards = nil;

    self._callDouble = 0; --倍数

    self._LandCallDouble = nil; ---加倍数据

    self._landCallDoubleFinish = nil;  ---加倍结束第1个出牌玩家

    self._lastCardsTemp = nil; ---临时保存出的牌 用于播放声音

    self._lastCards = nil ---玩家出牌

    self.outCardsInfo = {
        out_chair_id = 0,
        cur_chair_id = 0,
        index = 0,
        indexOut = 0,
        cards = {},
    }

    self._passOutCard = nil;

    self._result = nil;

    self._notifySitDownMsg = nil;

    self._hostingMsg = nil;  ---托管消息

    self._landRecoveryPlayerCardMsg = nil ; ---断线重连 玩家的数据

    self._landRecoveryPlayerDoubleMsg = nil; ---断线重连 加倍数据

    self._landRecoveryPlayerCallScoreMsg = nil;
    -- body

    self._privateIsPrivateRoom = false
    self._privateRoomId = 0
    self._privateOwnerInfo = {}
    self._privateOriginator = 0
end

function DdzGameDataManager:ctor()
    self._enterRoomAndSitDownInfo = nil; ---保存坐下的消息
    self:initData()
end


function DdzGameDataManager:ShowPlayersInfo()
    ---这里进去
    for k,v in pairs(self._chairs) do
        --dump(v, "v")
        --DdzGameScene:getInstance():OnPlayerEnter(self:ConvertChairIdToIndex(k), v)
    end
end

---保存坐下的消息
function DdzGameDataManager:_onMsg_EnterRoomAndSitDownInfo(infoTab)

    ---保存房间信息用于重连用
    self._enterRoomAndSitDownInfo = infoTab

    self:_onMsg_SetMySitDownInfo(infoTab)

    if self._enterRoomAndSitDownInfo["private_room_id"] then
        self._privateRoomId = self._enterRoomAndSitDownInfo["private_room_id"]
    end

    if self._enterRoomAndSitDownInfo["private_room"] then
        self._privateIsPrivateRoom = self._enterRoomAndSitDownInfo["private_room"]
    end
end

----
function DdzGameDataManager:setGameRoomInfo()
    -- body
    local pb_gmMessage = {}
    pb_gmMessage["chair_id"] = self._enterRoomAndSitDownInfo["chair_id"]
    pb_gmMessage["room_id"] = self._enterRoomAndSitDownInfo["room_id"]
    pb_gmMessage["table_id"] = self._enterRoomAndSitDownInfo["table_id"]
    pb_gmMessage["first_game_type"] = self._enterRoomAndSitDownInfo["first_game_type"]
    pb_gmMessage["second_game_type"] = self._enterRoomAndSitDownInfo["second_game_type"]
    GameManager:getInstance():getHallManager():getPlayerInfo():setGamingInfoTab(pb_gmMessage)
end

---初始化UI类
function DdzGameDataManager:initDdzSceneObj()
    -- body
    self._gameScene = DdzGameScene:getInstance()
end

---获取
function DdzGameDataManager:IsGamePlaying()
    return self._isPlaying
end
---设置
function DdzGameDataManager:setGamePlaying()
    self._isPlaying = false
end

function DdzGameDataManager:IsGmaeDobule()
    return self._isDouble
end

---服务器坐位编号转换对应UI坐位编号
function DdzGameDataManager:ConvertChairIdToIndex(chairId)
    --print("self._myChairId:",self._myChairId,"chairId:",chairId)
    return (chairId + gameDdz.GAME_PLAYER - self._myChairId) % gameDdz.GAME_PLAYER + 1
end


function DdzGameDataManager:ConvertIndexToChairId(index)
    return (self._userInfo.chair_id + index - 1) % gameDdz.GAME_PLAYER
end


function DdzGameDataManager:isReady()
    return self._userInfo.cbUserStatus == US_READY
end

function DdzGameDataManager:getPlayerScoreIndex()
    -- body
    return self.callPlayerScoreIndex
end

---自己的坐位编号
function DdzGameDataManager:getMyChairID( )
    return self._myChairId;
end

---获取牌记录数据
function DdzGameDataManager:GetCardsRecord()
    return self._cardRecords
end

function DdzGameDataManager:SearchOutCardForHelp()
    --dump(self._cards)
    --dump(self._lastCards)
    return gameDdz.DdzRules.NewSearchOutCardForHelp(self._cards, self._lastCards)
    --return gameDdz.DdzRules.SearchOutCardForHelp(self._cards, self._lastCards)
end

function DdzGameDataManager:setMyOutCards(cards)
    self._myOutCards = cards;
end

----保存玩家数据
function DdzGameDataManager:savePlayerSitDownInfo(msgTab,gameState)
    local ddzPlayerInfo = DdzPlayerInfo:create()
    ddzPlayerInfo:updatePlayerPropertyWithInfoTab(msgTab)
    dump(msgTab,"msgTab")
    self._chairs[msgTab["chair_id"]] = ddzPlayerInfo
    self._chairs[msgTab["chair_id"]]:setGameState(gameState)
    self._chairs[msgTab["chair_id"]]:setIpArea(msgTab["ip_area"])
end


---保存自己座下的信息
function DdzGameDataManager:_onMsg_SetMySitDownInfo(msgTab)

    ---自己的消息
    local ddzPlayerInfo = DdzPlayerInfo:create()
    ddzPlayerInfo:updatePlayerPropertyWithInfoTab(GameManager:getInstance():getHallManager():getPlayerInfo())
    ddzPlayerInfo:copyMyPlayerInfo(GameManager:getInstance():getHallManager():getPlayerInfo())
    ddzPlayerInfo:setChairId(msgTab.chair_id)
    ddzPlayerInfo:setIpArea(GameManager:getInstance():getHallManager():getPlayerInfo():getIp_position());--msgTab["ip_area"])
    ddzPlayerInfo:setGameState(2);
    self._chairs[msgTab.chair_id] = ddzPlayerInfo
    self._userInfo = ddzPlayerInfo
    self._myChairId = msgTab.chair_id

    ----其他人的消息
    dump(msgTab)
    if msgTab["pb_visual_info"] ~= nil then
        for i,v in ipairs(msgTab["pb_visual_info"]) do
            -- self:savePlayerSitDownInfo(v,3)
            if msgTab["private_room"] then
                self:savePlayerSitDownInfo(v,2)
            else
                self:savePlayerSitDownInfo(v,3)
            end
        end
    end

    if msgTab["private_room_id"] then
        self._privateRoomId = msgTab["private_room_id"]
    end

    if msgTab["private_room"] then
        self._privateIsPrivateRoom = msgTab["private_room"]
    end
end


---其他人进入房间
function DdzGameDataManager:_onMsg_SetSitDownPlayers(msgTab)

    local playerInfo = msgTab["pb_visual_info"]
    ---保存数据
    self:savePlayerSitDownInfo(playerInfo,2)
end

---保存准备状态
function DdzGameDataManager:_onMsg_SetPlayerReadyState(msgTab)

    ----初始化
    self._myOutCards = nil;
    self._isDouble = false;
    self._playerBoubleInfo = {}
    self._cards = {}
    self._cardRecords = {}
    -- 重置状态 --
    self._lastCardsTemp = nil
    self._lastCards = nil
    self._helpCards = nil

    -- 更新当前倍数 --
    self._mulBase = 0
    self._mulBomb = 0
    self._callScore = 0;
    self._callScoreTimes = 0;

    local index = self:ConvertChairIdToIndex(msgTab.ready_chair_id)
    if msgTab.is_ready then
        if self._chairs[msgTab.ready_chair_id]~=nil then
            self._chairs[msgTab.ready_chair_id]:setGameState(3)
            self._chairs[msgTab.ready_chair_id]["playerInfoTab"]["is_ready"] = true
        end
    end
end

---发牌
function DdzGameDataManager:_onMsg_GameStart( msgTab )

    for k,v in pairs(self._chairs) do
        v:setGameState(gameDdz.US_PLAYING)
    end
    -- body
    self._isPlaying = true

    -- 重置状态 --
    self._lastCardsTemp = nil
    self._lastCards = nil
    self._helpCards = nil

    -- 更新当前倍数 --
    self._mulBase = 0
    self._mulBomb = 0
    self._callScore = 0;
    self._callScoreTimes = 0;


    for i = 1, 15 do
        self._cardRecords[i] = i >= 14 and 1 or 4
    end

    -- 牌的数据 --
    for k,v in pairs(msgTab.cards) do
        self._cards[k] = v
    end

    gameDdz.DdzHelper.SortCard(self._cards)

    for i = 1, gameDdz.GAME_PLAYER do
        self._cardCount[i] = gameDdz.NORMAL_COUNT
    end
end

---获取倍数
function DdzGameDataManager:getCallDouble()
    return  self._callDouble
end

---获取叫分数据
function DdzGameDataManager:getLandCallScoreMsg()
    return self._landCallScoreMsg
end



----用户叫分返回数据
function DdzGameDataManager:_onMsg_gameCallScore(msg)

    self._landCallScoreMsg = msg;

    self._mulBase = msg.call_score or 0
    self._mulBomb = 0
    if self._mulBase > 0  then
        self._tempMulBomb = self._mulBase
    end
  
    self._callScoreTimes = self._callScoreTimes + 1
    if self._callScoreTimes == 3 then
        self._callScoreTimes = 0
        if self._mulBase * (2 ^ self._mulBomb) == 0 then
            self._callDouble = 1;
        else
            self._callDouble = self._tempMulBomb * (2 ^ self._mulBomb);
        end
    else
        self._callDouble = self._tempMulBomb * (2 ^ self._mulBomb)
    end

    local call_score = 0
    if msg.call_score ~= nil then
        call_score = msg.call_score
        self._callScore = msg.call_score
    end

    print("--------------------------------------1")
    if msg.call_chair_id ~= nil then ---叫分玩家

    else
        self.callPlayerScoreIndex = self:ConvertChairIdToIndex(msg.cur_chair_id)
    end 
end

---获取地主信息
function DdzGameDataManager:getLandInfo()

    return self._landInfo
end
---地主信息
function DdzGameDataManager:_onMsg_gameBankerInfo(msg)
    self._landInfo = msg;
    -- 更新当前倍数 --
    self._mulBase = msg.call_score or 0
    self._mulBomb = 0
    self._callDouble = self._mulBase * (2 ^ self._mulBomb)
    local landIndex = self:ConvertChairIdToIndex(msg.land_chair_id)

    -- 如果是我的地主 --
    if landIndex == 1 then
        for k,v in pairs(msg.cards) do
            table.insert(self._cards, v)
        end
        gameDdz.DdzHelper.SortCard(self._cards)
    end
    self._cardCount[msg.land_chair_id] = gameDdz.MAX_COUNT
    self._LandChairId = msg.land_chair_id

end

----获取加倍数据
function DdzGameDataManager:getLandCallDoubleFinish()
    -- body
    return self._landCallDoubleFinish
end
----加倍后谁出牌
function DdzGameDataManager:_onMsgLandCallDoubleFinish(msgTab)
    self._isDouble = false
    self._landCallDoubleFinish = msgTab
end


function DdzGameDataManager:getLandCallDouble()
    return self._LandCallDouble;
end
----加倍返回 显示桌面上的加倍标志
function DdzGameDataManager:_onMsgLandCallDouble(msgTab)
    self._LandCallDouble = msgTab
    self._playerBoubleInfo[msgTab.call_chair_id] = msgTab["is_double"]

    self._nextDoubleChairId = 0
    print("#self._playerBoubleInfo:",#self._playerBoubleInfo)
    if msgTab.call_chair_id == self._myChairId then
        print("123---------:")
        for i = 1,3 do
            if i ~= self._myChairId  and i ~= self._LandChairId then
                self._nextDoubleChairId = self:ConvertChairIdToIndex(i) 
                return  self._nextDoubleChairId
            end
        end
    end
end

----
function DdzGameDataManager:getNextDoubleUser()
    return self._nextDoubleChairId
end

---- 获取断线重连加倍数据
function DdzGameDataManager:getLandRecoveryPlayerDoubleMsg()
    return self._landRecoveryPlayerDoubleMsg;
end

---保存断线重连后 玩家加倍的情况
function DdzGameDataManager:_onMsgLandRecoveryPlayerDouble(msgTab)

    self._landRecoveryPlayerDoubleMsg = msgTab
    if msgTab["pb_double_state"]~=nil then
        local double_count_down = msgTab["double_count_down"] or 0
        for k,v in pairs( msgTab["pb_double_state"]) do
            self._playerBoubleInfo[v.chair_id] = v["is_double"]
        end
         for k,v in pairs( msgTab["pb_double_state"]) do
            if v["is_double"] == 3 and self._LandChairId == self._myChairId then
                self._isDouble = true;
                break
            end 
        end
    end
end


function DdzGameDataManager:getGameOutCards()
    -- body
    return self.outCardsInfo;
end
---用户出牌数据返回
function DdzGameDataManager:_onMsg_gameOutCard(msg)


    self.outCardsInfo  = {
        out_chair_id = 0,
        cur_chair_id = 0,
        indexOut = 0,
        index = 0,
        cards = {},
    }
    -- 出牌 --
    self.outCardsInfo.out_chair_id = msg.out_chair_id;
    self.outCardsInfo.cur_chair_id = msg.cur_chair_id;
    self.outCardsInfo.indexOut = self:ConvertChairIdToIndex(msg.out_chair_id)
    self.outCardsInfo.cards = msg.cards 
    self.outCardsInfo.index = self:ConvertChairIdToIndex(msg.cur_chair_id)

    local index = self:ConvertChairIdToIndex(msg.cur_chair_id)
    local indexOut = self:ConvertChairIdToIndex(msg.out_chair_id)
    if indexOut == 1 then
        for k, v in ipairs(msg.cards) do
            for kk, vv in ipairs(self._cards) do
                if v == vv then
                    table.remove(self._cards, kk)
                    break
                end
            end
        end
    end 

    ---刷新出牌玩家的牌数量
    if msg.out_chair_id ~= self:getMyChairID() then
        --todo
        local charid = msg.out_chair_id--self:ConvertChairIdToIndex(msg.out_chair_id)
        if self._cardCount[charid] ~= nil then
            --todo
            self._cardCount[charid] = self._cardCount[charid] - #msg.cards
        end
    end



    self._myOutCards = nil;
   
    self._helpCards = nil

    self._lastCardsTemp = self._lastCards;
    -- 重置状态 --
    self._lastCards = msg.cards

    -- 更新牌的记录，剩余牌数量  --
    for _, v in ipairs(msg.cards) do
        local value = gameDdz.DdzRules.GetCardLogicValue(v)
        self._cardRecords[value] = self._cardRecords[value] - 1
    end

    
    -- 更新当前倍数 --
    local cardType = gameDdz.DdzRules.GetCardType(msg.cards)
    if cardType.type >= gameDdz.DdzRules.CT_BOMB_CARD then
        self._mulBomb = self._mulBomb + 1
        self._callDouble = self._mulBase * (2 ^ self._mulBomb)
    end

end

function DdzGameDataManager:getPassOutCard()

    return self._passOutCard

end

---放弃出牌返回
function DdzGameDataManager:_onMsg_gamePassCard(msg)

    self._passOutCard = msg
    -- 回合结束
    local turn_over = false
    if msg.turn_over ~= nil then       
        self._lastCardsTemp = nil
        self._lastCards = nil
        self._helpCards = nil
    end
end

function DdzGameDataManager:getGameOverData()

    return self._result;
end
---- 游戏结束
function DdzGameDataManager:_onMsg_gameOver(msgTab)
    -- body
     self._isPlaying = false

    -- 更新牌的记录，剩余牌数量  --
    --self._CardRecord = {}

    local cardInfoText = "初始X"..self._mulBase
    print(" self._mulBase:", self._mulBase)
    print(" self._mulBase:", self._tempMulBomb)
    print(" self._mulBase:", self._mulBomb)
    -- 更新当前倍数 --
    self._mulBase = 0
    self._mulBomb = 0
    self._tempMulBomb = 0
    self._landInfo = nil

    self._callDouble = self._mulBase * (2 ^ self._mulBomb)

    
    local gameType = {
        "春天",
        "反春",
        "炸弹",
        "初始"
    }

    local _mul = {}

    if msgTab.chuntian ~=nil then
         cardInfoText = cardInfoText.."    ".."春天X2"
        table.insert(_mul, {
            gameType = 1,
            value = 2,
        })
    end
    if msgTab.fanchuntian ~=nil then
        cardInfoText = cardInfoText.."    ".."反春X2"
        table.insert(_mul, {
            gameType = 2,
            value = 2,
        })
    end

    local lineConf = {
        1,
        1,
        2,
        2,
        3
    }
    local line = lineConf[#lineConf] or 3

    local text = ""
    for k, v in ipairs(_mul) do
        text = text .. string.format("%-12s", gameType[v.gameType].."x"..v.value)
        if k % line == 0 then
            text = text .. "\n"
        end
    end
    ---修改游戏状态
    for k,v in pairs(self._chairs) do
        v:setGameState(gameDdz.SUB_S_GAME_CONCLUDE)
    end

    self._userInfo:setGameState(gameDdz.SUB_S_GAME_CONCLUDE)
        
    --dump(self._playerBoubleInfo)

    local result = {
        cardInfoText = cardInfoText,
        score = {},
        scoreIndex = {},
        landWin = false,
        text = text,
        isSelf = {},
        cards = {},
        palyerName = {}
    }

    local bomb_count = 0
    for i = 1, gameDdz.GAME_PLAYER do
        local chairId = i
        local _tax = 0
        local _score = msgTab.pb_conclude[i].score or 0
        local _cards = msgTab.pb_conclude[i].cards or 0;
        local _bombCount = msgTab.pb_conclude[i].bomb_count or 0
        local _flag =  msgTab.pb_conclude[i].flag or 0
        if _flag == 1 then
            _tax = msgTab.pb_conclude[i].tax or 0
        end
       

        local is_double = 0;
        if self._playerBoubleInfo[i]~=nil and self._playerBoubleInfo[i] == 2 then
            is_double = 1
        end
      
        if _tax ~= 0 then
           _tax = "-".._tax
        end

        bomb_count = bomb_count+_bombCount

        -----这里要观察 self._chairs[i] 为空
        local nickName = string.format("玩家_%d", i)
        if self._chairs[i] ~= nil then
            nickName = self._chairs[i]:getIpArea()
        end
        --dump(self._chairs[i],"self._chairs[i]")
        --print("444444:",self._chairs[i]:getIpArea().."(农民)")
        result.palyerName[i] =  self._chairs[i]:getIpArea().."(农民)"
        if chairId == self._LandChairId then
            result.landWin =  _score > 0
            result.palyerName[i] =  self._chairs[i]:getIpArea().."(地主)"
        end


        table.insert(result.score, {
            name = nickName,
            value = _score or 0, ---string.format("%0.2f",msgTab.pb_conclude[i].score/100),
            tax = _tax, --税收 ---msgTab.pb_conclude[i].cards,
            double = is_double
        }) 

        ----更新玩家的钱
        if self._chairs[chairId] ~= nil then
            self._chairs[chairId]:setMoney(self._chairs[chairId]:getMoney()+_score)
        end
        
        ---保存是否是自己
        table.insert(result.isSelf,self:ConvertChairIdToIndex(chairId) == 1)
        table.insert(result.cards,_cards)

        ---成绩
        result.scoreIndex[self:ConvertChairIdToIndex(chairId)] = {
            value = _score,
        }
    end
    --倍数的2次方
    if bomb_count>0 then
        local bomb_double = math.pow(2, bomb_count)
        cardInfoText = cardInfoText.."    ".."炸弹X"..(bomb_double)
    end
    result.cardInfoText = cardInfoText
    
    self._result = result;
    dump(self._result, "result")

end

function DdzGameDataManager:getNotifySitDown()
    
    return  self._notifySitDownMsg
end

--通知同桌站起
function DdzGameDataManager:_onMsg_NotifySitDown(msgTab)

    self._notifySitDownMsg = msgTab
end


---- 获取断线重连数据
function DdzGameDataManager:getLandRecoveryPlayerCardMsg()
    return  self._landRecoveryPlayerCardMsg
end
----游戏出牌阶段掉线
function DdzGameDataManager:_onMsg_GameStatusPlay(msg)

    self._landRecoveryPlayerCardMsg = msg;
    
    for k,v in pairs(self._chairs) do
        v:setGameState(gameDdz.US_PLAYING)
    end

    self._isPlaying = true
    -- 重置状态 --
    self._lastCardsTemp = nil
    self._lastCards = nil
    self._helpCards = nil
    self._landInfo = msg.landcards


    -- 更新当前倍数 --
    self._mulBase = msg.call_score
    self._mulBomb = msg.bomb or 0
    --print("self._mulBase * (2 ^ self._mulBomb)",self._mulBase * (2 ^ self._mulBomb))
    local double =  self._mulBase
    if self._mulBomb > 0 then
         double = self._mulBase * math.pow(2, self._mulBomb)
         
    end
    
    self._callDouble = double
    
    for i = 1, 15 do
        self._cardRecords[i] = i >= 14 and 1 or 4 
    end

    
    -- 更新玩家手牌数量 --
    for i=1,3 do
        self._cardCount[i] = gameDdz.NORMAL_COUNT
    end

    -- 更新玩家手牌数量 --
    for k,v in ipairs(msg.pb_msg) do
        local chairId = v["chair_id"]
        self._cardCount[chairId] = v["cardsnum"]
    end

    self._cardCount[self._myChairId] = #msg.cards

    -- 更新自己的手牌 --
    self._cards = {}
    for k,v in pairs(msg.cards) do
        self._cards[k] = v
    end
    gameDdz.DdzHelper.SortCard(self._cards)


    -- 更新地主 --
    self._LandChairId = msg.landchairid
  
    -- 更新该谁出牌 --
    self._helpCards = nil
    local cbCardData = {}
    if msg.lastCards ~= nil then
        for _,v in ipairs(msg.lastCards) do
            table.insert(cbCardData,v)
        end
    end

    self._lastCardsTemp = self._lastCards

    self._lastCards = cbCardData --#cbCardData > 0 and cbCardData


    -- 更新牌的1111记录，剩余牌数量  --
    for i = 1, 15 do
        self._cardRecords[i] = i >= 14 and 1 or 4
    end

    if msg.alreadyoutcards~=nil then
        for i=1,#msg.alreadyoutcards do
            local v = msg.alreadyoutcards[i]
            local value = gameDdz.DdzRules.GetCardLogicValue(v)
            self._cardRecords[value] = self._cardRecords[value] - 1
            if (self._cardRecords[value] - 1) <= 0 then
                --todo
                self._cardRecords[value] = 0
            end
        end
    end
  
end


---获取叫分阶段掉线数据
function DdzGameDataManager:getGameRecoveryPlayerCallScoreMsg( )
    return self._landRecoveryPlayerCallScoreMsg

end
----叫分阶段掉线
function DdzGameDataManager:_onMsg_GameRecoveryPlayerCallScore(msg)
    
    self._landRecoveryPlayerCallScoreMsg = msg
    for k,v in pairs(self._chairs) do
        v:setGameState(gameDdz.US_PLAYING)
    end
    ---刷新倍数
    self._isPlaying = true
    self._mulBase = msg.call_score or 0
    self._mulBomb = msg.call_score or 0
    self._tempMulBomb = msg.call_score or 0

    self._callDouble = self._mulBomb
    --self._gameScene:UpdateMul(self._mulBomb)
 
    -- 重置状态 --
    self._lastCards = nil
    self._lastCardsTemp = nil;
    self._helpCards = nil

    for i = 1, 15 do
        self._cardRecords[i] = i >= 14 and 1 or 4 
    end


    -- 更新自己的手牌 --
    self._cards = {}
    for k,v in pairs(msg.cards) do
        self._cards[k] = v
    end
    gameDdz.DdzHelper.SortCard(self._cards)

     -- 更新玩家手牌数量 --
    for i=1,3 do
        self._cardCount[i] = gameDdz.NORMAL_COUNT
    end


    ----还有其他玩家掉线
    if msg.pb_playerOfflineMsg~=nil then
        local offlineInfo = msg.pb_playerOfflineMsg[1]
        table.insert(self._outPlayerInfo,offlineInfo)
        local time = offlineInfo.outTimes
        --self._gameScene:initPanel_TimeoutWait(time)
    else
        --self._gameScene:initPanel_TimeoutWait(0)
    end


    --self._gameScene:UpdateCardRecord()

    --self._gameScene:OnGameRecoveryPlayerCallScore(msg)

    --self._gameScene:OnGameRecoveryShowLandPoker()

    self:_onMsg_gameCallScore(msg)
end

---显示玩家掉线界面
function DdzGameDataManager:_onMsg_GameShowTimeoutWait(msg)
    -- body
    table.insert(self._outPlayerInfo,msg)
    self._gameScene:initPanel_TimeoutWait(msg.wait_time)
end

---玩家上线隐藏掉线界面
function DdzGameDataManager:_onMsg_GamePlayerOnline(msg)
    -- body
    ---在出牌阶段掉线 就直接return
    -- if self._landInfo ~= nil then
    --     return;
    -- end

    -- ----叫分阶段
    -- for i,v in ipairs(self._outPlayerInfo) do
    --     if msg.cur_online_chair_id == v.cur_chair_id then
    --         --todo
    --         table.remove(self._outPlayerInfo,i)
    --         break;
    --     end
    -- end

    -- --dump(self._outPlayerInfo,"self._outPlayerInfo")
    -- ---叫分
    -- if (self._outPlayerInfo == nil or table.getn(self._outPlayerInfo) == 0) and msg.cur_chair_id ~= nil  then
    --     --todo
    --     print("叫分掉线")
    --     self._gameScene:OnGameCallLand(self:ConvertChairIdToIndex(msg.cur_chair_id),self._tempMulBomb)

    --     ---清除屏幕
    --     self._gameScene:initPanel_TimeoutWait(0)
    -- end
end



function DdzGameDataManager:getUpdateHostingMsg()

    return self._hostingMsg

end
---托管
function DdzGameDataManager:OnUpdateHosting(msgTab)
    self._hostingMsg = msgTab
    if self._myOutCards ~= nil then
        self._gameScene:showMyCards()
    end
    self._myOutCards = nil;
    -- body

end

----游戏停服消息
function DdzGameDataManager:OnMsg_GameServerStop(msgTab)
    self._gameSeverStop = msgTab
end

---获取自己游戏是否停服
function DdzGameDataManager:getMyGameSeverStop()
    local myGameStop = false
    local mygameSeverID = self._enterRoomAndSitDownInfo["game_id"]
    local gameSeverIDStop = self._gameSeverStop["game_id"]
    if mygameSeverID == gameSeverIDStop then
        myGameStop = true;
    end
    return myGameStop
end

function DdzGameDataManager:getPrivateRoomId()
    return self._privateRoomId
end

function DdzGameDataManager:getIsPrivateRoom()
    -- return self._enterRoomAndSitDownInfo["second_game_type"] == 99
    return self._privateIsPrivateRoom
end

function DdzGameDataManager:getChairs()
    return self._chairs
end

function DdzGameDataManager:removeChair(charid)
    self._chairs[charid] = nil
end

function DdzGameDataManager:setVoteInfo(msgTab)
    if self._chairs[msgTab["chair_id"]] then
        self._chairs[msgTab["chair_id"]]["vote"] = msgTab["bret"]
    end
end

function DdzGameDataManager:cleanVoteInfo()
    for k, v in pairs(self._chairs) do
        self._chairs[k]["vote"] = nil
    end 
end

function DdzGameDataManager:setPrivateOwnerInfo(msgTab)
    self._privateOwnerInfo = msgTab
end

function DdzGameDataManager:getIsPrivateOwner(uid)
    return self._privateOwnerInfo["nhosterguid"] == uid
end

function DdzGameDataManager:setVoteOriginator(charid)
    self._privateOriginator = charid
end

function DdzGameDataManager:getVoteOriginator()
    return self._privateOriginator
end