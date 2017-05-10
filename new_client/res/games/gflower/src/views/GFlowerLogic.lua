import(".GFlowerMsgId")
local GFlowerLogic = class("GFlowerLogic")

function GFlowerLogic:ctor()
    -- GFlowerLogic.super.ctor(self)
    -- 数据类型 --
    self._singleScore = 0              -- 单注
    self._allScore = 0                 -- 总注
    self._nowRound = 0                -- 轮数
    self._roomType = 0                -- 房间类型
    self._gameStatus = -1              -- 游戏状态
    -- GFlowerLogic._winChair = 0                -- 胜者
    self._maxScore = 0                 -- 最大下注
    self._taxScore = 0                 -- 税收
    self._currentTimes = 0            -- 当前倍数
    self._bankerUser = 0              -- 庄家
    self._gameUI = nil                  -- 游戏场景
    self._meUserId = 0                -- 自己id
    -- GFlowerLogic._meEnter = nil                 -- 自己进入
    -- GFlowerLogic._tempUserList = {}            -- 比自己先进入玩家
    self._winnerChairId = 0                -- 胜者椅子
    self._currentChairId = 0          -- 当前操作用户
    self._isSendready = true            -- 对战类游戏
    self._receive = false               -- 收到场景消息
    self._fangjianbiaozhi = 1           -- 房间标志
    self._minScore = 0                -- 当前轮最小下注
    self._MaxRound = 0                -- 最大轮数
    self._tableId = nil
    self._firstChairId = nil             -- 起始玩家
    self._isAddScore = nil               -- 是否有人加注
    self._isMissed = false              -- 自己是否被踢
    self._RoomenterScore = 0            -- 最小入场金币
    self._playerplaystatu = {0,0,0,0,0} -- 自己当前状态
    self._GameendInfo = nil             -- 玩家结束信息
    self._UserName = {}                 -- 玩家名称
    -- 座位 --
    self._pChairs = {}
    -- 游戏中途入场玩家 --
    self._halfWayPlayer = {}

    -- 走马灯文字 --
    self._gLanterns = {}
    self:onInit()

    -- 消息发送中(处理某些只能发送一次的消息) --
    self._msgIsSending = false
end

function GFlowerLogic:init(scene)
    self._messageDeal = MessageDeal.new()
    self._messageDeal:parseConf("gameMsg/GoldenFlower.json")

    self._meUserId = app.hallLogic._loginSuccessInfo["dwUserID"]

    if app.hallLogic._roomflag == 2 or app.hallLogic._roomflag == 3 then
        self._fangjianbiaozhi = 2
    elseif app.hallLogic._roomflag == 4 then
        self._fangjianbiaozhi = 3
    end

    self._RoomenterScore = app.hallLogic._meRoomentersore.lMinEnterScore
    self._singleScore = app.hallLogic._meRoomentersore.lCellScore
    dump(app.hallLogic._meRoomentersore)

    self._tableId = app.table._tableId
    self._gameUI = scene

    return self
end

-- 初始化消息回调
function GFlowerLogic:onInit()
    self.msg_callback = {}
    self.msg_callback[GF_SUB_S_GAME_START] = self.onMsgGameStart        -- 游戏开始
    self.msg_callback[GF_SUB_S_ADD_SCORE] = self.onMsgAddGold           -- 加注结果
    self.msg_callback[GF_SUB_S_GIVE_UP] = self.onMsgGiveUp              -- 放弃跟注
    self.msg_callback[GF_SUB_S_SEND_CARD] = self.onMsgSendCard          -- 发牌消息
    self.msg_callback[GF_SUB_S_GAME_END] = self.onMsgGameEnd            -- 游戏结束
    self.msg_callback[GF_SUB_S_COMPARE_CARD] = self.onMsgCompareCard    -- 比牌跟注
    self.msg_callback[GF_SUB_S_LOOK_CARD] = self.onMsgLookCard          -- 看牌跟注
    self.msg_callback[GF_SUB_S_PLAYER_EXIT] = self.onMsgPlayerExit      -- 用户强退
    self.msg_callback[GF_SUB_S_OPEN_CARD] = self.onMsgOpenCard          -- 开牌消息
    self.msg_callback[GF_SUB_S_WAIT_COMPARE] = self.onMsgWaitCompare    -- 等待比牌
    self.msg_callback[GF_SUB_S_LAST_COMPARE_DATA] = self.onMsgLastCompare    -- 等待比牌
    self.msg_callback[GF_SUB_S_NO_MONEY] = self.onMsgMeExit             -- 金币不足
end

-- 退出游戏清理 --
function GFlowerLogic.Clear()
    -- self._singleScore = 0              -- 单注
    -- self._allScore = 0                 -- 总注
    -- self._nowRound = 0                -- 轮数
    -- self._roomType = 0                -- 房间类型
    -- self._gameStatus = -1              -- 游戏状态
    -- -- self._winChair = 0                -- 胜者
    -- self._maxScore = 0                 -- 最大下注
    -- self._taxScore = 0                 -- 税收
    -- self._currentTimes = 0            -- 当前倍数
    -- self._bankerUser = 0              -- 庄家
    -- self._gameUI = nil                  -- 游戏场景
    -- self._meUserId = 0                -- 自己id
    -- self._winnerChairId = 0                -- 胜者椅子
    -- self._currentChairId = 0          -- 当前操作用户
    -- self._isSendready = true            -- 对战类游戏
    -- self._receive = false               -- 收到场景消息
    -- self._fangjianbiaozhi = 1           -- 房间标志
    -- self._firstChairId = -1
    -- self._isAddScore = nil
    -- self._pChairs = {}
--     self = nil
    -- self.super = nil
end

-- 换桌时 清理部分数据 --
function GFlowerLogic:ClearPart()
    self._singleScore = 0
    self._allScore = 0
    self._nowRound = 0
    self._gameStatus = -1
    self._winChair = 0
    self._maxScore = 0
    self._taxScore = 0
    self._currentTimes = 0
    self._bankerUser = 0
    self._winnerChairId = 0
    self._currentChairId = 0
    self._isSendready = true
    self._receive = false
    self._fangjianbiaozhi = 1
    self._firstChairId = -1
    self._isAddScore = false
    self._GameendInfo = nil             -- 玩家结束信息
    self._msgIsSending = false
    self._UserName = {}
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        self._playerplaystatu[i] = 0
    end
    self:UpdateHalfToDesk()
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        if i == 1 then
            self._pChairs[i]:ResetStatus()
        else
            self._pChairs[i] = nil
        end
    end
end

-- 游戏结束 数据重置 --
function GFlowerLogic:ResetDesk()
    self._gameStatus = GFlowerConfig.GAME_STATUS.GAME_FREE
    self._allScore = 0
    self._nowRound = 0
    self._maxScore = 0
    self._taxScore = 0
    self._currentTimes = 0
    self._currentChairId = 0
    self._firstChairId = -1
    self._isAddScore = false
    self._GameendInfo = nil             -- 玩家结束信息
    self._UserName = {}
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        self._playerplaystatu[i] = 0
    end
    self:UpdateHalfToDesk()
    for _, _player in pairs(self._pChairs) do
        if _player then
            _player:ResetStatus()
        end
    end
end

-- 更新中途加入玩家到桌面 --
function GFlowerLogic:UpdateHalfToDesk()
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        local _lookPlayer = self._halfWayPlayer[i]
        if _lookPlayer then
            self._pChairs[i] = clone(_lookPlayer)
            self._gameUI:PlayerExitGame(i)
        end
    end
    self._halfWayPlayer = {}
end

function GFlowerLogic:onUserEnterTable( player )
    local _userId = player.dwUserID
    local _player = GFlowerPlayer.new(player)

    if self._meUserId == _userId then
        -- 座位 --
        self._pChairs = {}
        -- 游戏中途入场玩家 --
        self._halfWayPlayer = {}
        self:ResetDesk()
        if self._gameUI then
            self._gameUI:ResetUI()
        end
        _player._chairId = 1
        self._pChairs[_player._chairId] = clone(_player)
        self._tableId = app.table._tableId
        self._gameUI:PlayerEnterGame(_player._chairId)
        print("自己的带状体            ".._player:GetGameStatus())
    elseif not self:GameIsPlaying() then
        local _wChairId = player.wChairID
        local _chairId = self:GetChairIdByWChairId(_wChairId)
        _player._chairId = _chairId
        self._pChairs[_chairId] = clone(_player)
        self._gameUI:PlayerEnterGame(_player._chairId)
    else
        local _wChairId = player.wChairID
        local _chairId = self:GetChairIdByWChairId(_wChairId)
        _player._chairId = _chairId
        if self._pChairs[_chairId] then
            self._halfWayPlayer[_chairId] = clone(_player)
        else
            self._pChairs[_chairId] = clone(_player)
        end
    end

end

-- 服务器消息 --
function GFlowerLogic:onDetailMessage(mainId, subId, msg)

    if not msg then return end

    local _mainId = msg:getMainID()
    local _subId = msg:getSubId()
    local _byteLen = msg:getMsgLen()

    printf("GFlowerLogic:onDetailMessage maindid:".._mainId.."   subID:".._subId.." bytelen:".._byteLen)
    -- 是否框架消息 --
    if _mainId == MDM_GF_FRAME then
        -- 场景消息 --
        if _subId == GF_GS_TK_FREE then
            printf("游戏场消息----：长度:".._byteLen)
            self:OnGameScene(msg, _byteLen)
        -- 系统消息 --
        elseif _subId == GF_SUB_GF_SYSTEM_MESSAGE then
            self:OnSystemMsg(msg)
        end
    -- 主命令 --
    elseif _mainId == MDM_GF_GAME then
        self._msgIsSending = false
        local msgDetail = self._messageDeal:decodeMessage(_mainId, _subId, msg)

        local _callBack = self.msg_callback[subId]
        if _callBack and self._receive == true then
            _callBack(self, msgDetail)
            print(" GFlowerLogic:onDetailMessage dealt===>>>", mainId, subId)
        else
            print(" GFlowerLogic client dont have relative function===>>>", mainId, subId)
        end
    elseif _mainId == MDM_GR_USER and subId == SUB_GR_S_KICK_USER_NO_MONEY then
        if _callBack then
            self.msg_callback[GF_SUB_S_NO_MONEY]()
        end
    end
end

-- 发消息 ---------------------
function GFlowerLogic:SendMessage(mainId, subId, msg)
    local msgStr = self._messageDeal:encodeMessage(mainId, subId, msg)
    app.table:sendDetailMessage(mainId, subId, msgStr)
end

-- 用户加注
function GFlowerLogic:SendMsgAddScore(lScore, wState, bAllIn)
    if self._msgIsSending then return end

    self._msgIsSending = true
    local info = {
        lScore = lScore,
        wState = wState,
        bAllIn = bAllIn
    }
    self:SendMessage(MDM_GF_GAME, GF_SUB_C_ADD_SCORE, info)
end

-- 放弃消息
function GFlowerLogic:SendMsgGiveUp()
    self:SendMessage(MDM_GF_GAME, GF_SUB_C_GIVE_UP, {})
end

-- 比牌消息
function GFlowerLogic:SendMsgCompareCard(wCompareUser)
    local info = {
        wCompareUser = wCompareUser
    }
    print("发送比牌小夏---------------------:"..wCompareUser.."自己的的："..self._pChairs[1]:GetwChairId())
    self:SendMessage(MDM_GF_GAME, GF_SUB_C_COMPARE_CARD, info)
end

-- 看牌消息
function GFlowerLogic:SendMsgLookCard()
    self:SendMessage(MDM_GF_GAME, GF_SUB_C_LOOK_CARD, {})
end

-- 开牌消息
function GFlowerLogic:SendMsgOpenCard()
    self:SendMessage(MDM_GF_GAME, GF_SUB_C_OPEN_CARD, {})
end

-- 等待比牌
function GFlowerLogic:SendMsgWaitCompare()
    self:SendMessage(MDM_GF_GAME, GF_SUB_C_WAIT_COMPARE, {})
end

-- 完成动画
function GFlowerLogic:SendMsgFinishFlash()
    self:SendMessage(MDM_GF_GAME, GF_SUB_C_FINISH_FLASH, {})
end

-- 准备 --
function GFlowerLogic:SendReady()
    app.table:sendReady()
end
---------------------------------

-- 收消息 -------------------------
-- -- 游戏空闲 --
-- function GFlowerLogic:onMsgGameFree(msgDetail)
--     dump(msgDetail)
--     -- struct CMD_S_StatusFree
--     -- {
--     --     LONGLONG                            lCellScore;                         //基础积分
--     -- };
-- end

-- 游戏开始 --
function GFlowerLogic:onMsgGameStart(msgDetail)
    -- struct CMD_S_GameStart
    -- {
    --     //下注信息
    --     LONGLONG                            lMaxScore;                          //最大下注
    --     LONGLONG                            lCellScore;                         //单元下注
    --     LONGLONG                            lCurrentTimes;                      //当前倍数
    --     LONGLONG                            lUserMaxScore;                      //分数上限

    --     //用户信息
    --     WORD                                wBankerUser;                        //庄家用户
    --     WORD                                wCurrentUser;                       //当前玩家
    --     BYTE                                cbPlayStatus[GAME_PLAYER];          //游戏状态
    --     BYTE                                cbCardData[GAME_PLAYER][MAX_COUNT]; //用户扑克
    -- };
    dump(msgDetail)
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        self._playerplaystatu[i] = 0
    end
    self._bankerUser = self:GetChairIdByWChairId(msgDetail.wBankerUser)
    self._currentChairId = self:GetChairIdByWChairId(msgDetail.wCurrentUser)
    self._maxScore = msgDetail.lMaxScore
    self._singleScore = msgDetail.lCellScore
    self._currentTimes = msgDetail.lCurrentTimes
    self._nowRound = msgDetail.wCurrentRound
    self._allScore = 0
    self._minScore = self._singleScore

    for i = 1, GFlowerConfig.CHAIR_COUNT do
        local _wChairId = i - 1
        local _chairId = self:GetChairIdByWChairId(_wChairId)
        local _status = msgDetail.cbPlayStatus[i]
        local _cards = {}
        for j = 1, GFlowerConfig.CARD_COUNT do
            local _card = msgDetail.cbCardData[_wChairId * GFlowerConfig.CARD_COUNT + j]
            table.insert(_cards, _card)
        end
        if self._pChairs[_chairId] then
            self._pChairs[_chairId]:UpdatewStatus(_status)
            self._pChairs[_chairId]:UpdateCardInfo(_cards)
            if _status >= US_FREE then
                local userinfo = {}
                userinfo.szNickName = self._pChairs[_chairId]:GetUserAdress()--GetNickName()
                userinfo.szHeadIcon = self._pChairs[_chairId]:GetHeadStr("Square")
                userinfo.wchairId = self._pChairs[_chairId]:GetwChairId()
                self._UserName[_chairId] = userinfo
                self._pChairs[_chairId]:UpdateGameStatus(GFlowerConfig.PLAYER_STATUS.WAIT)
                local _addScore = msgDetail.lCellScore * msgDetail.lCurrentTimes
                self._pChairs[_chairId]:SetAddGameScore(_addScore,true)
                self._allScore = self._allScore + _addScore
            else
                self._pChairs[_chairId]:UpdateGameStatus(GFlowerConfig.PLAYER_STATUS.STAND)
            end
        end
    end

    self:UpdateStatus(GFlowerConfig.GAME_STATUS.GAME_PLAY)

    -- 通知UI层
    self._gameUI:GameStart()
    print("--游戏开始消息-- onMsgGameStart")
end

-- 游戏进行 --
-- function GFlowerLogic:onStatusPlay(msgDetail)
--     dump(msgDetail)
--     -- struct CMD_S_StatusPlay
--     -- {
--     --     //加注信息
--     --     LONGLONG                            lMaxCellScore;                      //单元上限
--     --     LONGLONG                            lCellScore;                         //单元下注
--     --     LONGLONG                            lCurrentTimes;                      //当前倍数
--     --     LONGLONG                            lUserMaxScore;                      //用户分数上限

--     --     //状态信息
--     --     WORD                                wBankerUser;                        //庄家用户
--     --     WORD                                wCurrentUser;                       //当前玩家
--     --     BYTE                                cbPlayStatus[GAME_PLAYER];          //游戏状态
--     --     bool                                bMingZhu[GAME_PLAYER];              //看牌状态
--     --     LONGLONG                            lTableScore[GAME_PLAYER];           //下注数目

--     --     //扑克信息
--     --     BYTE                                cbHandCardData[3];                  //扑克数据

--     --     //状态信息
--     --     bool                                bCompareState;                      //比牌状态
--     -- };
-- end

-- 聊天消息 --
function GFlowerLogic:onTrumpetMessage(nickname, content)
    self._gameUI:onTrumpet(nickname, content)
end

-- 加注结果
function GFlowerLogic:onMsgAddGold(msgDetail)
    -- dump(msgDetail)
    -- struct CMD_S_AddScore
    -- {
    --     WORD                                wCurrentUser;                       //当前用户
    --     WORD                                wAddScoreUser;                      //加注用户
    --     WORD                                wCompareState;                      //比牌状态
    --     LONGLONG                            lAddScoreCount;                     //加注数目
    --     LONGLONG                            lCurrentTimes;                      //当前倍数
    --     LONGLONG                            bAllIn;
    -- };
    dump(msgDetail)
    self._nowRound = msgDetail.wCurrentRound
    self._currentTimes = msgDetail.lCurrentTimes
    local _wChairId = msgDetail.wAddScoreUser
    local _chairId = self:GetChairIdByWChairId(_wChairId)
    local _addScore = msgDetail.lAddScoreCount
    local _player = self._pChairs[_chairId]
    if _addScore <=0 then return end

    if msgDetail.bAllIn == 1 then
        dump(msgDetail)
        _player:AllInGameScore(msgDetail.lAddScoreCount)
    elseif msgDetail.wCompareState == 0 then
        local _minScore = 0
        if _player:IsLookCard() then
            _minScore = _addScore / 2
        else
            _minScore = _addScore
        end

        if self._minScore == _minScore then
            _player:FllowGameScore()
        else
            self._minScore = _minScore
            _player:AddGameScore(_addScore)
        end
    else
        _player:CompareAddScore(_addScore)
    end

    print("--游戏加注消息-- onMsgAddGold")
end

-- 放弃跟注
function GFlowerLogic:onMsgGiveUp(msgDetail)
    -- struct CMD_S_GiveUp
    -- {
    --     WORD                                wGiveUpUser;                        //放弃用户
    -- };
    local _userId = msgDetail.wGiveUpUser
    local _chairId = self:GetChairIdByWChairId(_userId)
    self._playerplaystatu[_chairId] = 2
    --self:SetCurrentPlayer(_chairId)
    self._pChairs[_chairId]:DropCard()
end

-- 发牌消息
function GFlowerLogic:onMsgSendCard(msgDetail)
    -- struct CMD_S_SendCard
    -- {
    --     BYTE                                cbCardData[GAME_PLAYER][MAX_COUNT]; //用户扑克
    -- };
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        local _wChairId = i - 1
        local _chairId = self:GetChairIdByWChairId(_wChairId)
        local _cards = {}
        for j = 1, GFlowerConfig.CARD_COUNT do
            local _card = msgDetail.cbCardData[(i-1) * GFlowerConfig.CARD_COUNT + j]
            table.insert(_cards, _card)
        end
        self._pChairs[_chairId]:UpdateCardInfo(_cards)
    end
    print("--游戏发牌消息-- onMsgSendCard")
end

-- 游戏结束
function GFlowerLogic:onMsgGameEnd(msgDetail)
    -- struct CMD_S_GameEnd
    -- {
    --     LONGLONG                            lGameTax;                           //游戏税收
    --     LONGLONG                            lGameScore[GAME_PLAYER];            //游戏得分
    --     BYTE                                cbCardData[GAME_PLAYER][3];         //用户扑克
    --     WORD                                wCompareUser[GAME_PLAYER][4];       //比牌用户
    --     WORD                                wEndState;                          //结束状态
    -- };
    self._GameendInfo = msgDetail             -- 玩家结束信息
    self._taxScore = msgDetail.lGameTax
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        local _wChairId = i - 1
        local _chairId = self:GetChairIdByWChairId(_wChairId)
        local _gainScore = msgDetail.lGameScore[i]
        if _gainScore > 0 then
            self:SetWinPlayer(_chairId)
        end
    end

    -- for i = 1, GFlowerConfig.CHAIR_COUNT do
    --     local _wChairId = i - 1
    --     local _chairId = self:GetChairIdByWChairId(_wChairId)
    --     local _gainScore = msgDetail.lGameScore[i]
    --     local _cards = {}
    --     for j = 1, GFlowerConfig.CARD_COUNT do
    --         local _card = msgDetail.cbCardData[_wChairId * GFlowerConfig.CARD_COUNT + j]
    --         table.insert(_cards, _card)
    --     end
    --     local _comparePlayers = {}
    --     for k = 1, 4 do
    --         local _wChairId = msgDetail.wCompareUser[(i-1) * 4 + k]
    --         local _chairId = self:GetChairIdByWChairId(_wChairId)
    --         table.insert(_comparePlayers, _chairId)
    --     end
    --     local _player = self._pChairs[_chairId]
    --     if _player then
    --         if _gainScore > 0 then
    --             self:SetWinPlayer(_chairId)
    --         end
    --         _player:SetGainScore(_gainScore)
    --         _player:UpdateCardInfo(_cards)
    --         _player:UpdateComparePlayer(_comparePlayers)
    --     end
    -- end

    self:UpdateStatus(GFlowerConfig.GAME_STATUS.GAME_END)
    self:GameEnd()

    print("--游戏结束消息-- onMsgGameEnd")
end

-- 比牌跟注
function GFlowerLogic:onMsgCompareCard(msgDetail)
    -- struct CMD_S_CompareCard
    -- {
    --     WORD                                wCurrentUser;                       //当前用户
    --     WORD                                wCompareUser[2];                    //比牌用户
    --     WORD                                wLostUser;                          //输牌用户
    -- };
    -- dump(msgDetail)
    local _loserId = self:GetChairIdByWChairId(msgDetail.wLostUser)
    self._nowRound = msgDetail.wCurrentRound
    local _compareChairId = {}
    for i = 1, 2 do
        local _wChairId = msgDetail.wCompareUser[i]
        local _chairId = self:GetChairIdByWChairId(_wChairId)
        _compareChairId[i] = _chairId
        if _chairId == _loserId then
            self._pChairs[_chairId]:SetEliminate(true)
        else
            self._pChairs[_chairId]:SetEliminate(false)
        end
        self._pChairs[_chairId]:UpdateGameStatus(GFlowerConfig.PLAYER_STATUS.COMPARE)
    end
    self._playerplaystatu[_loserId] = 1
    -- 玩家动作 --
    self._gameUI:PlayerCall(self._currentChairId, "BI_PAI")
    self._gameUI:CompareCard(_compareChairId,false)
    print("--游戏比牌消息-- onMsgCompareCard")
end

-- 看牌跟注
function GFlowerLogic:onMsgLookCard(msgDetail)
    -- struct CMD_S_LookCard
    -- {
    --     WORD                                wLookCardUser;                      //看牌用户
    --     BYTE                                cbCardData[MAX_COUNT];              //用户扑克
    -- };
    local _wChairId = msgDetail.wLookCardUser
    local _chairId = self:GetChairIdByWChairId(_wChairId)
    local _cardInfo = msgDetail.cbCardData
    self._pChairs[_chairId]:LookCard(_cardInfo)
    print("--游戏看牌消息-- onMsgLookCard")
end

-- 用户强退
function GFlowerLogic:onMsgPlayerExit(msgDetail)
    -- struct CMD_S_PlayerExit
    -- {
    --     WORD                                wPlayerID;                          //退出用户
    -- };
    local _userId = msgDetail.wPlayerID
    local _chairId = self:GetPlayerChairId(_userId)
    self._pChairs[_chairId]:ExitGame()
    print("--游戏用户强退消息-- onMsgPlayerExit")
end

-- 开牌消息
function GFlowerLogic:onMsgOpenCard(msgDetail)
    -- struct CMD_S_OpenCard
    -- {
    --     WORD                                wWinner;                            //胜利用户
    -- };
    local _winnerId = msgDetail.wWinner
    local _chairId = self:GetChairIdByWChairId(_winnerId)
    self:SetWinPlayer(_chairId)
    for _, _player in pairs(self._pChairs) do
        if _player:GetChairId() == _chairId then
            _player:Win()
        else
            _player:SetEliminate(true)
        end
    end
    self._gameUI:gfGameOpenCard()
    print("--游戏开牌消息-- onMsgOpenCard")
end

-- 等待比牌
function GFlowerLogic:onMsgWaitCompare(msgDetail)
    -- struct CMD_S_WaitCompare
    -- {
    --     WORD                                wCompareUser;                       //比牌用户
    -- };
    local _wChairId = msgDetail.wCompareUser
    local _chairId = self:GetChairIdByWChairId(_wChairId)
    -- self._pChairs[_chairId]:WaitCompare()
    print("--游戏等待比牌消息-- onMsgWaitCompare")
end

-- 等待比牌
function GFlowerLogic:onMsgLastCompare(msgDetail)
-- struct CMD_S_LastCompareData
-- {
--     WORD                                wCompareUser[2];                    //比牌用户
--     BYTE                                cbCardData[2][MAX_COUNT];           //用户扑克
-- };
    dump(msgDetail)
    local _compareChairId = {}
    for i = 1, 2 do
        local _wChairId = msgDetail.wCompareUser[i]
        local _chairId = self:GetChairIdByWChairId(_wChairId)
        _compareChairId[i] = _chairId
        local _cardInfo = {}
        for j=1,3 do
            _cardInfo[j] = msgDetail.cbCardData[(i-1)*3 + j]
        end
        self._pChairs[_chairId]:UpdateCardInfo(_cardInfo)
    end
    --self._gameUI:CompareCard(_compareChairId,true)
    -- local _wChairId = msgDetail.wCompareUser
    -- local _chairId = self:GetChairIdByWChairId(_wChairId)
    -- self._pChairs[_chairId]:WaitCompare()
    print("--游戏最后比牌消息-- onMsgLastCompare")
end

-- 没钱被踢
function GFlowerLogic:onMsgMeExit()
    self._isMissed = true
    self._gameUI:tipQueqian(5)
end

function GFlowerLogic:onPlayerUpdate(player)
    if app.table._tableId ~= player.wTableID then return end
    if player.wTableID == INVALID_TABLE then return end
    if player.wChairID == INVALID_CHAIR then return end

    if #self._pChairs <= 0 then
        return
    end

    local _userId = player.dwUserID
    local _wChairId = player.wChairID
    local _chairId = self:GetChairIdByWChairId(_wChairId)
    local _nowPlayer = self._pChairs[_chairId]
    if _nowPlayer then
        if _nowPlayer.iscompare and _nowPlayer:GetGameStatus() == GFlowerConfig.PLAYER_STATUS.EXIT then
            local _player = GFlowerPlayer.new(player)
            _player._chairId = _chairId

            -- if not self:GameIsPlaying() then
            --     self._pChairs[_chairId] = clone(_player)
            --     self._gameUI:PlayerEnterGame(_chairId)
            -- else
            self._halfWayPlayer[_chairId] = clone(_player)
            -- end
        else
            if _nowPlayer:GetwStatus() == US_FREE and _chairId ~= 1 then
                self:onPlayerExit(_nowPlayer:GetUserID())
            else
                self._pChairs[_chairId]:UpdatewPlayerInfo(player)
            end
        end
        -- if _nowPlayer:GetUserID() == _userId then
        --     self._pChairs[_chairId]:UpdatewPlayerInfo(player)
        -- else
        --     local _player = GFlowerPlayer.new(player)
        --     _player._chairId = _chairId

        --     if not self:GameIsPlaying() then
        --         self._pChairs[_chairId] = clone(_player)
        --         self._gameUI:PlayerEnterGame(_chairId)
        --     else
        --         self._halfWayPlayer[_chairId] = clone(_player)
        --     end
        -- end
    else
        local _player = GFlowerPlayer.new(player)
        _player._chairId = _chairId
        for k,v in pairs(self._pChairs) do
            if _player.dwUserID == v:GetUserID() then
                self._gameUI:PlayerExitGame(_chairId)
                break
            end
        end
        self._pChairs[_chairId] = clone(_player)
        self._gameUI:PlayerEnterGame(_chairId)
    end

    -- 界面更新 --
    self._gameUI:UpdatePlayerInfo(_chairId)

end

function GFlowerLogic:onPlayerExit(dwUserID)
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        local _nowPlayer = self._pChairs[i]
        if _nowPlayer and _nowPlayer:GetUserID() == dwUserID then
            dump("玩家离开....." .. _nowPlayer:GetChairId() .. i)
            _nowPlayer:ExitGame(self._isMissed)
        end
        local _halfPlayer = self._halfWayPlayer[i]
        if _halfPlayer and _halfPlayer:GetUserID() == dwUserID then
            self._halfWayPlayer[i] = nil
            dump("观战玩家离开....." .. _halfPlayer:GetChairId())
        end
    end
end

-- -- 更新玩家 --
-- function GFlowerLogic:UpdatePlayer(chairPlayer, player)

-- end

-- -- 添加玩家 --
-- function GFlowerLogic:AddPlayer(player)
--     if player.wTableID == INVALID_TABLE then return end
--     if player.wChairID == INVALID_CHAIR then return end
--     if app.table._tableId ~= player.wTableID then return end

--     local _newPlayer = GFlowerPlayer.new()
--     local _chairId = player.wChairID
--     self._pChairs[_chairId] = clone(_newPlayer)
-- end



-- 场景消息 --
function GFlowerLogic:OnGameScene(msg, byteLen)
    if not byteLen or bytelen == 0 then return end
    self._receive = true
    self._gameUI.Button_Change:setTouchEnabled(true)

    local msgDetail = nil
    -- local gf_isshowstart = true
    -- 空闲状态 --
    if byteLen == GF_GAME_FREE then
        msgDetail = self._messageDeal:decodeMessage(MDM_GF_FRAME, GF_GS_TK_FREE, msg)
        -- dump(msgDetail,"GF_GAME_FREE")
        --self._singleScore = msgDetail.lCellScore
        self._minScore = msgDetail.lCellScore
        self._maxScore = msgDetail.lMaxCellScore
        self._MaxRound = msgDetail.wMaxRound
        self:UpdateStatus(GFlowerConfig.GAME_STATUS.GAME_FREE)
        self:ActionByStatus()
    -- 进行中 --
    elseif byteLen == GF_GAME_PLAYING then
        msgDetail = self._messageDeal:decodeMessage(MDM_GF_FRAME, GF_GS_TK_PLAYING, msg)
        --dump(msgDetail,"GF_GAME_PLAYING")
        self._singleScore = msgDetail.lCellScore
        self._maxScore = msgDetail.lMaxCellScore
        self._currentTimes = msgDetail.lCurrentTimes
        self._nowRound = msgDetail.wCurrentRound
        self._currentChairId = self:GetChairIdByWChairId(msgDetail.wCurrentUser)
        self._minScore = self._singleScore * self._currentTimes
        self._MaxRound = msgDetail.wMaxRound

        for i = 1, GFlowerConfig.CHAIR_COUNT do
            local _wChairId = i - 1
            local _chairId = self:GetChairIdByWChairId(_wChairId)
            local _status = msgDetail.cbPlayStatus[i]
            local _lookCard = msgDetail.bMingZhu[i]
            local _addScore = msgDetail.lTableScore[i]
            if self._pChairs[_chairId] then
                self._pChairs[_chairId]:SetLookCard(_lookCard)
                if _addScore > 0 and _chairId ~= 1 then
                    self._allScore = self._allScore + _addScore
                    self._pChairs[_chairId]:UpdateGameStatus(GFlowerConfig.PLAYER_STATUS.LOSE)
                end
                if _status == 1 then
                    self._pChairs[_chairId]:UpdateGameStatus(GFlowerConfig.PLAYER_STATUS.WAIT)
                    self._pChairs[_chairId]:SetAddGameScore(_addScore)
                    local userinfo = {}
                    userinfo.szNickName = self._pChairs[_chairId]:GetUserAdress()--GetNickName()
                    userinfo.szHeadIcon = self._pChairs[_chairId]:GetHeadStr("Square")
                    userinfo.wchairId = self._pChairs[_chairId]:GetwChairId()
                    self._UserName[_chairId] = userinfo
                end
            end
        end
        if self._pChairs[self._currentChairId] then
            self._pChairs[self._currentChairId]:UpdateGameStatus(GFlowerConfig.PLAYER_STATUS.CONTROL)
        end
        self:UpdateStatus(GFlowerConfig.GAME_STATUS.GAME_PLAY)
        self:ActionByStatus()
    end

    self._gameUI:UpdateGameInfo()
    self._gameUI:InitOnce()
end

-- 系统消息 --
function GFlowerLogic:OnSystemMsg(msg)
    local msgDetail = self._messageDeal:decodeMessage(100, 200, msg)
    dump(msgDetail)
    if msgDetail and msgDetail["wType"] == SMT_TABLE_ROLL or msgDetail["wType"] == SMT_CHAT then
        local _chatStr = msgDetail["szString"]
        if _chatStr then
            table.insert(self._gLanterns, _chatStr)
        end
    end
end
---------------------------------------------------

-- 自己准备 --
function GFlowerLogic:SelfReady()
    self:sendReady()
    self._pChairs[1]:UpdateGameStatus(GFlowerConfig.PLAYER_STATUS.READY)
end

-- function GFlowerLogic:AddUserToTempList(player)
--     local _listLen = #self._tempUserList
--     self._tempUserList[_listLen+1] = clone(player)
-- end

-- function GFlowerLogic:FlashTempUserList()
--     if self._tempUserList or self._tempUserList ~= {} then
--         for _, _player in pairs(self._tempUserList) do
--             local _wChairId = _player:GetwChairId()
--             local _chairId = self:GetChairIdByWChairId(_wChairId)
--             _player._chairId = _chairId
--             self._pChairs[_chairId] = clone(_player)
--         end
--         self._tempUserList = {}
--     end
-- end

-- 超时 --
-- function GFlowerLogic:TimeOut()
-- end

-- 比牌 --
-- function GFlowerLogic:CompareCard(chairId1, chairId2)
-- end

-- 胜利用户 --
function GFlowerLogic:SetWinPlayer(chairId)
    self._winnerChairId = chairId
    self._pChairs[chairId]:Win()
end

-- 游戏结束 --
function GFlowerLogic:GameEnd()
    --临时使用
    self._gameUI:GameEnd()
end

-- 状态更新 --
function GFlowerLogic:UpdateStatus(wStatus)
    self._gameStatus = wStatus
    -- self:ActionByStatus()
end

-- 状态机 --
function GFlowerLogic:ActionByStatus()
    local _status = self._gameStatus
    if _status == GFlowerConfig.GAME_STATUS.GAME_FREE then
        self._gameUI:GameFree()
    elseif _status == GFlowerConfig.GAME_STATUS.GAME_PLAY then
        self._gameUI:GamePlaying()
    elseif _status == GFlowerConfig.GAME_STATUS.GAME_END then

    end
end

-- 用户椅子号获取
function GFlowerLogic:GetPlayerChairId(wUserId)
    for _, _player in pairs(self._pChairs) do
        local _userId = _player:GetUserID()
        if _userId == wUserId then
            return _player:GetChairId()
        end
    end
end

-- 能否跟注 --
function GFlowerLogic:CanFollowGameScore()
    -- local _firstPlayer = self._pChairs[self._firstChairId]
    -- if self._isAddScore then
    --     return true
    -- else
    --     return false
    -- end
    -- local _player = self._pChairs[1]
    -- if _player:ScoreEnough() then
    --     return true
    -- else
    --     return false
    -- end
    return true
end

-- 能否比牌 --
function GFlowerLogic:CanCompareCard()
    return self._nowRound and self._nowRound > 2
end

-- 能否加注 --
function GFlowerLogic:CanAddGameScore()
    return self._maxScore > self._minScore
end

-- 能否全压 --
function GFlowerLogic:CanAllIn()
    local gf_user_count = 0
    for k, v in pairs(self._pChairs) do
        if v and v:IsInGame() then
            gf_user_count = gf_user_count + 1
        end
    end
    if gf_user_count < 3 then
        return true
    else
        return false
    end
end

-- webChairId -> clientChairId
function GFlowerLogic:GetChairIdByWChairId(wChairId)
    local _playerSelf = self._pChairs[1]
    local _wChairId = _playerSelf:GetwChairId()
    return (wChairId + GFlowerConfig.CHAIR_COUNT - _wChairId) % GFlowerConfig.CHAIR_COUNT + 1
end

-- 游戏状态 --
function GFlowerLogic:GetGameStatus()
    return self._gameStatus
end

-- 游戏进行 --
function GFlowerLogic:GameIsPlaying()
    return self._gameStatus == GFlowerConfig.GAME_STATUS.GAME_PLAY
end

-- 游戏空闲 --
function GFlowerLogic:GameIsFree()
    return self._gameStatus == GFlowerConfig.GAME_STATUS.GAME_FREE
end

-- 游戏结束 --
function GFlowerLogic:GameIsEnd()
    return self._gameStatus == GFlowerConfig.GAME_STATUS.GAME_END
end

-- 获取下家 --
function GFlowerLogic:GetNextChairId()
    local _nextChairId = 0
    local NextChairId = nil
    NextChairId = function(currentChairId)
        -- print("wwwwwwwwwwwwwwwwwww当前chairid" .. currentChairId)
        if _nextChairId == self._currentChairId then
            dump("there is no user can control")
            return nil
        end
        if currentChairId == GFlowerConfig.CHAIR_COUNT then
            _nextChairId = 1
        else
            _nextChairId = currentChairId + 1
        end
        local _player = self._pChairs[_nextChairId]
        if _player and _player:IsInGame() then
            return _nextChairId
        else
            return NextChairId(_nextChairId)
        end
    end

    return NextChairId(self._currentChairId)

end

function GFlowerLogic:GetNext(showChair)
    local _nextChairId = 0
    local NextChairId = nil
    NextChairId = function(currentChairId)
        -- print("wwwwwwwwwwwwwwwwwww当前chairid" .. currentChairId)
        if _nextChairId == self._currentChairId then
            dump("there is no user can control")
            return nil
        end
        if currentChairId == GFlowerConfig.CHAIR_COUNT then
            _nextChairId = 1
        else
            _nextChairId = currentChairId + 1
        end
        local _player = self._pChairs[_nextChairId]
        if _player and _player:IsInGame() then
            return _nextChairId
        else
            return NextChairId(_nextChairId)
        end
    end

    return NextChairId(showChair)
end

-- 设置当前用户 --
function GFlowerLogic:SetCurrentPlayer(chairId)
    self._currentChairId = chairId
end

-- 游戏轮数 --
function GFlowerLogic:GetGameRound()
    return self._nowRound
end

-- 设置游戏轮数 --
function GFlowerLogic:SetGameRound(round)
    self._nowRound = round
end

-- 轮数 超界 --
function GFlowerLogic:IsMaxRound()
     return self._nowRound >= self._MaxRound and self:GetNextChairId() == 1
end

function GFlowerLogic.NoCloseOnStandup()
    return true
end

-- 获取游戏中金币最少玩家 --
function GFlowerLogic:GetMinMoneyPlayer()
    local _minScore = 0xFFFFFFFF
    local _chairId = nil
    for _, _player in pairs(self._pChairs) do
        if _player:IsInGame() then
            local _gameScore = _player:GetOwnScore()
            if _gameScore < _minScore then
                _minScore = _gameScore
                _chairId = _player:GetChairId()
            end
        end
    end
    return _chairId
end

-- 获取桌面上金币最少玩家 --
function GFlowerLogic:GetMinMoneyChair()
    local _minScore = 0xFFFFFFFF
    local _chairId = nil
    for _, _player in pairs(self._pChairs) do
        local _gameScore = _player:GetOwnScore()
        if _gameScore < _minScore then
            _minScore = _gameScore
            _chairId = _player:GetChairId()
        end
    end
    return _chairId
end

-- 游戏中人数 --
function GFlowerLogic:GetInGamePlayer()
    local _count = 0
    for _, _player in pairs(self._pChairs) do
        if _player:IsInGame() then
            _count = _count + 1
        end
    end
    return _count
end

-- 获取游戏玩家的状态 --
function GFlowerLogic:GetPlayerCaozuo()
    return self._playerplaystatu
end


return singleton(GFlowerLogic)
