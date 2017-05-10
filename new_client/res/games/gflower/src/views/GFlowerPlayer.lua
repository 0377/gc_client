GFlowerPlayer = class("GFlowerPlayer")

-- 花色获取 --
local function GetCardColor(a_value)
    local t_val = math.floor(a_value / 16)
    -- if t_val == 0 then --方片
    --     return "f"
    -- elseif t_val == 1 then --梅花
    --     return "m"
    -- elseif t_val == 2 then --红桃
    --     return "x"
    -- elseif t_val == 3 then --黑桃
    --     return "h"
    -- end
    return t_val

end

-- 点数获取 --
local function GetCardValue(a_value)
    local t_val = math.floor(a_value / 16)
    return a_value - t_val * 16
end

-- 牌型计算 --
local function GetCardType(cards)
    if #cards ~= GFlowerConfig.CARD_COUNT then
        return 0
    end

    local _sameColor = true
    local _lineCard = true
    local _firstColor = GetCardColor(cards[1])
    local _firstValue = GetCardValue(cards[1])
    -- 牌型分析 --
    for i = 2, GFlowerConfig.CARD_COUNT do
        local _cardColor = GetCardColor(cards[i])
        local _cardValue = GetCardValue(cards[i])
        if _cardColor ~= _firstColor then
            _sameColor = false
        end
        if _cardValue - i + 1 ~= _firstValue then
            _lineCard = false
        end
        if not _sameColor and not _lineCard then
            break
        end
    end
    -- A23 --
    if not _lineCard then
        local _one, _two, _three
        for i = 1, GFlowerConfig.CARD_COUNT do
            local _cardValue = GetCardValue(cards[i])
            if _cardValue == 1 then
                _one = true
            elseif _cardValue == 2 then
                _two = true
            elseif _cardValue == 3 then
                _three = true
            end
            if _one and _two and _three then
                _lineCard = true
            end
        end
    end
    -- 顺金 --
    if _sameColor and _lineCard then
        return GFlowerConfig.CARD_TYPE.CT_SHUN_JIN
    end
    -- 顺子 --
    if not _sameColor and _lineCard then
        return GFlowerConfig.CARD_TYPE.CT_SHUN_ZI
    end
    -- 金花 --
    if _sameColor and not _lineCard then
        return GFlowerConfig.CARD_TYPE.CT_JIN_HUA
    end

    -- 牌型分析 --
    local _double = false
    local _panther = true
    -- 对牌分析 --
    for i = 1, GFlowerConfig.CARD_COUNT - 1 do
        for j = i+1, GFlowerConfig.CARD_COUNT do
            local _cardValueOne = GetCardValue(cards[i])
            local _cardValueTwo = GetCardValue(cards[j])
            if _cardValueOne == _cardValueTwo then
                _double = true
                break
            end
        end
        if _double then
            break
        end
    end
    -- 豹子分析 --
    for i = 2, GFlowerConfig.CARD_COUNT do
        local _cardValue = GetCardValue(cards[i])
        if _firstValue ~= _cardValue then
            _panther = false
        end
    end
    -- 豹子 对子 判断 --
    if _double then
        return (_panther and GFlowerConfig.CARD_TYPE.CT_BAO_ZI) or (_double and GFlowerConfig.CARD_TYPE.CT_DOUBLE)
    end
    -- 特殊235 --
    local _two, _three, _five
    for i = 1, GFlowerConfig.CARD_COUNT do
        local _cardValue = GetCardValue(cards[i])
        if _cardValue == 2 then
            _two = true
        elseif _cardValue == 3 then
            _three = true
        elseif _cardValue == 5 then
            _five = true
        end
    end
    if _two and _three and _five then
        return GFlowerConfig.CARD_TYPE.CT_SPECIAL
    end

    return GFlowerConfig.CARD_TYPE.CT_SINGLE
end

-- 牌型计算 --
local function GetCardType(cards)
    if #cards ~= GFlowerConfig.CARD_COUNT then
        return 0
    end

    local _sameColor = true
    local _lineCard = true
    local _firstColor = GetCardColor(cards[1])
    local _firstValue = GetCardValue(cards[1])
    local _cardvaluetemp = {}
    --判断顺子
    for k,v in pairs(cards) do
        table.insert( _cardvaluetemp,GetCardValue(v))
    end
    local sortFunc = function(A,B)
        return A < B
    end
    table.sort( _cardvaluetemp, sortFunc )
    if _cardvaluetemp[1] + 1 ~= _cardvaluetemp[2] or _cardvaluetemp[2] + 1 ~= _cardvaluetemp[3] then
        _lineCard = false
    end
    -- 牌型分析 --
    for i = 2, GFlowerConfig.CARD_COUNT do
        local _cardColor = GetCardColor(cards[i])
        local _cardValue = GetCardValue(cards[i])
        if _cardColor ~= _firstColor then
            _sameColor = false
            break
        end
    end


    -- 牌型分析 --
    local _double = false
    local _panther = true
    -- 对牌分析 --
    for i = 1, GFlowerConfig.CARD_COUNT - 1 do
        for j = i+1, GFlowerConfig.CARD_COUNT do
            local _cardValueOne = GetCardValue(cards[i])
            local _cardValueTwo = GetCardValue(cards[j])
            if _cardValueOne == _cardValueTwo then
                _double = true
                break
            end
        end
        if _double then
            break
        end
    end
    -- 豹子分析 --
    for i = 2, GFlowerConfig.CARD_COUNT do
        local _cardValue = GetCardValue(cards[i])
        if _firstValue ~= _cardValue then
            _panther = false
        end
    end
    -- 豹子 对子 判断 --
    if _double then
        return (_panther and GFlowerConfig.CARD_TYPE.CT_BAO_ZI) or (_double and GFlowerConfig.CARD_TYPE.CT_DOUBLE)
    end
    -- 特殊235 --
    local _two, _three, _five
    for i = 1, GFlowerConfig.CARD_COUNT do
        local _cardValue = GetCardValue(cards[i])
        if _cardValue == 2 then
            _two = true
        elseif _cardValue == 3 then
            _three = true
        elseif _cardValue == 5 then
            _five = true
        end
    end
    if _two and _three and _five then
        return GFlowerConfig.CARD_TYPE.CT_SPECIAL
    end

    -- A23 --
    if not _lineCard then
        local _one, _two, _three
        for i = 1, GFlowerConfig.CARD_COUNT do
            local _cardValue = GetCardValue(cards[i])
            if _cardValue == 12 then
                _one = true
            elseif _cardValue == 13 then
                _two = true
            elseif _cardValue == 1 then
                _three = true
            end
            if _one and _two and _three then
                _lineCard = true
            end
        end
    end
    -- 顺金 --
    if _sameColor and _lineCard then
        return GFlowerConfig.CARD_TYPE.CT_SHUN_JIN
    end
    -- 顺子 --
    if not _sameColor and _lineCard then
        return GFlowerConfig.CARD_TYPE.CT_SHUN_ZI
    end
    -- 金花 --
    if _sameColor and not _lineCard then
        return GFlowerConfig.CARD_TYPE.CT_JIN_HUA
    end

    return GFlowerConfig.CARD_TYPE.CT_SINGLE
end

-- 手牌排序 --
local function PokerSort(cards)
    table.sort(cards, function(a, b)
        return GetCardValue(a) < GetCardValue(b)
    end)
    return cards
end

function GFlowerPlayer:ctor(player)
    self._userId = nil         -- 玩家id
    self._lookCard = nil       -- 是否看牌
    self._dropCard = nil       -- 是否弃牌
    self._eliminate = nil      -- 是否淘汰
    self._cards = nil          -- 玩家手牌
    -- GFlowerPlayer._canLookCard = nil    -- 能否看牌
    self._ownScore = nil       -- 拥有金币数
    self._headIcon = nil       -- 头像
    self._nickName = nil       -- 昵称
    self._gameStatus = 0         -- 游戏状态
    self._isSelf = nil         -- 是否自己
    self._timeoutCount = nil   -- 超时次数
    self._wChairId = nil       -- webChairId
    self._chairId = nil        -- clientChairId
    self._addScore = nil       -- 下注数目
    self._gainScore = nil      -- 单局得分
    self._comparePlayer = nil  -- 比过牌的用户
    self._isWinner = nil       -- 是否胜者
    self._wPlayerInfo = nil    -- 服务器下发数据
    self._allScore = 0         -- 总下注
    self._wTableId = nil       -- webTableID
    self._wStatus = nil        -- webStatus
    self._cardType = nil       -- 牌型
    self._sex = nil            -- 性别
    self._headIconStr = {}    -- 头像路径
    self._wPlayerInfo = clone(player)
    self:UpdatePlayerInfo()
end

-- 数据重置 --
function GFlowerPlayer:ClearInfo()
    self._lookCard = false
    self._dropCard = false
    self._eliminate = false
    self._cards = {}
    self._canLookCard = false
    self._ownScore = 0
    self._headIcon = nil
    self._nickName = nil
    self._gameStatus = 0
    self._timeoutCount = nil
    self._addScore = 0
    self._gainScore = 0
    self._comparePlayer = {}
    self._isWinner = false
    self._wPlayerInfo = {}
    self._cardType = 0
    self._sex = nil
    self._headIconStr = {}
    self._address = nil
end

-- 玩家状态重置
function GFlowerPlayer:ResetStatus()
    self._lookCard = false
    self._dropCard = false
    self._eliminate = false
    self._isWinner = false
    self._comparePlayer = {}
    self._cards = {}
    self._gainScore = 0
    self._cardType = 0
end



-- 玩家 UserId --
function GFlowerPlayer:GetUserID()
    return self._userId
end

-- 玩家 UserId --
function GFlowerPlayer:GetUserAdress()
    return self._address
end

-- 客户端 椅子id --
function GFlowerPlayer:GetChairId()
    return self._chairId
end

-- 服务器 椅子id --
function GFlowerPlayer:GetwChairId()
    return self._wChairId
end

function GFlowerPlayer:UpdatewPlayerInfo(player)
    self._wPlayerInfo = clone(player)
    self:UpdatePlayerInfo()
end

function GFlowerPlayer:UpdatePlayerInfo()
    self._userId = self._wPlayerInfo.dwUserID
    if self:IsMySelf() then
        self._headIcon = app.utils.game.GetHeadIcon()
    else
        self._headIcon = app.utils.game.GetOtherHeadIcon(self._wPlayerInfo.wFaceID)
    end

    self._ownScore = self._wPlayerInfo.lScore
    self._nickName = self._wPlayerInfo.nickName
    self._wChairId = self._wPlayerInfo.wChairID
    self._wTableId = self._wPlayerInfo.wTableID
    self._wStatus = self._wPlayerInfo.cbUserStatus
    self._sex = self._wPlayerInfo.cbGender
    self._address = self._wPlayerInfo.szAddress

    -- 临时处理 --
    if not self._headIconStr or next(self._headIconStr) == nil then
        if self:IsMan() then
            self._headIconStr.Round = "headIcon/y" .. self._headIcon .. ".png"
        else
            self._headIconStr.Round = "headIcon/yy" .. self._headIcon % 15 + 1 .. ".png"
        end
        self._headIconStr.Square = "headIcon/" .. self._headIcon .. ".png"
    end

    -- if self._chairId == 1 then
    --     if self._headIcon <= 15 then
    --         self._headIconStr.Round = "GameGFlower/headIcon/y" .. self._headIcon .. ".png"
    --         self._headIconStr.Square = "GameGFlower/headIcon/s" .. self._headIcon .. ".png"
    --     else
    --         self._headIconStr.Round = "GameGFlower/headIcon/yy" .. (self._headIcon - 15) .. ".png"
    --         self._headIconStr.Square = "GameGFlower/headIcon/ss" .. (self._headIcon - 15) .. ".png"
    --     end
    --     print("fsodr we fdf   "..self._headIconStr.Square)
    -- end
    self:UpdateStatusBywStatus()
end

function GFlowerPlayer:UpdateStatusBywStatus()
    if self._wStatus == US_READY then
        self._gameStatus = GFlowerConfig.PLAYER_STATUS.READY
    elseif self._wStatus == US_SIT or self._wStatus == US_FREE then
        self._gameStatus = GFlowerConfig.PLAYER_STATUS.FREE
    elseif self._wStatus == US_LOOKON then
        self._gameStatus = GFlowerConfig.PLAYER_STATUS.STAND
    end
end

-- 加注 --
function GFlowerPlayer:AddGameScore(wScore)
    local _logic = GFlowerLogic.GetInstance()
    self._addScore = wScore
    self._allScore = self._allScore + wScore
    self._ownScore = self._ownScore - wScore
    _logic._allScore = _logic._allScore + wScore
    _logic._isAddScore = true
    _logic:SetCurrentPlayer(self._chairId)
    _logic._gameUI:PlayerAddGameScore(self._chairId, self._addScore)
end

-- 跟注 --
function GFlowerPlayer:FllowGameScore()
    local _logic = GFlowerLogic.GetInstance()
    if self._lookCard then
        self._addScore = _logic._minScore * 2
    else
        self._addScore = _logic._minScore
    end
    self._allScore = self._allScore + self._addScore
    self._ownScore = self._ownScore - self._addScore
    _logic._allScore = _logic._allScore + self._addScore
    _logic:SetCurrentPlayer(self._chairId)
    _logic._gameUI:PlayerFollowGameScore(self._chairId)
end

-- 全压 --
function GFlowerPlayer:AllInGameScore(coin)
    print("全压          "..coin)
    local _logic = GFlowerLogic.GetInstance()
    self._addScore = coin
    self._allScore = self._allScore + self._addScore
    self._ownScore = self._ownScore - coin
    _logic._allScore = _logic._allScore + self._addScore
    _logic:SetCurrentPlayer(self._chairId)
    _logic._gameUI:PlayerAllInGameScore(self._chairId)
end


-- 获取总加注 --
function GFlowerPlayer:SetGameScore(score)
    self._allScore = score
end
-- 获取总加注 --
function GFlowerPlayer:GetGameScore()
    return self._allScore
end

-- 获取单次加注 --
function GFlowerPlayer:GetRoundScore()
    return self._addScore
end

-- 单局得分 设置 --
function GFlowerPlayer:SetGainScore(wScore)
    self._gainScore = wScore
end

-- 比牌用户 更新 --
function GFlowerPlayer:UpdateComparePlayer(playerChairIds)
    self._comparePlayer = playerChairIds
end

-- 淘汰状态 设置 --
function GFlowerPlayer:SetEliminate(eliminate)
    self._eliminate = eliminate
end

-- 是否淘汰 --
function GFlowerPlayer:IsEliminate()
    return self._eliminate
end

-- 是否自身 --
function GFlowerPlayer:IsMySelf()
    return self._chairId == 1
end

-- 弃牌 --
function GFlowerPlayer:DropCard()
    self._dropCard = true
    self:UpdateGameStatus(GFlowerConfig.PLAYER_STATUS.DROP)
    GFlowerLogic.GetInstance()._gameUI:PlayerDropCard(self._chairId)
end

-- 看牌 --
function GFlowerPlayer:LookCard(wCardInfo)
    self:SetLookCard(true)
    self:UpdateCardInfo(wCardInfo)
    GFlowerLogic.GetInstance()._gameUI:PlayerLookCard(self._chairId)
end

-- 能否看牌 --
function GFlowerPlayer:CanLookCard()
end

-- 是否看牌 --
function GFlowerPlayer:IsLookCard()
    local _logic = GFlowerLogic.GetInstance()
    return self._lookCard
end

-- 卡牌 更新 --
function GFlowerPlayer:UpdateCardInfo(wCardInfo)
    self._cards = PokerSort(wCardInfo)
    self._cardType = GetCardType(self._cards)
end

-- 网络状态 更新 --
function GFlowerPlayer:UpdatewStatus(wStatus)
    self._status = wStatus
end

-- 游戏状态 更新 --
function GFlowerPlayer:UpdateGameStatus(status)
    self._gameStatus = status
end

-- 看牌状态 设置 --
function GFlowerPlayer:SetLookCard(wLookStatus)
    self._lookCard = wLookStatus
end

-- 弃牌或淘汰 --
function GFlowerPlayer:LostGame()
    return self._gameStatus >= GFlowerConfig.PLAYER_STATUS.DROP
end

-- 游戏中 --
function GFlowerPlayer:IsInGame()
    return self._gameStatus < GFlowerConfig.PLAYER_STATUS.DROP and self._gameStatus > GFlowerConfig.PLAYER_STATUS.READY
end

-- 观战中 --
function GFlowerPlayer:IsWatchGame()
    local _logic = GFlowerLogic.GetInstance()
    return _logic:GameIsPlaying() and self._gameStatus < GFlowerConfig.PLAYER_STATUS.WAIT
end

-- 离开游戏 --
function GFlowerPlayer:IsExit()
    return self._gameStatus == GFlowerConfig.PLAYER_STATUS.EXIT
end

-- 准备 --
function GFlowerPlayer:IsReady()
    local _logic = GFlowerLogic.GetInstance()
    return _logic:GameIsFree() and self._gameStatus == GFlowerConfig.PLAYER_STATUS.READY
end

-- 弃牌 --
function GFlowerPlayer:IsDrop()
    local _logic = GFlowerLogic.GetInstance()
    return _logic:GameIsPlaying() and self._gameStatus == GFlowerConfig.PLAYER_STATUS.DROP
end

-- 淘汰 --
function GFlowerPlayer:IsLose()
    local _logic = GFlowerLogic.GetInstance()
    return _logic:GameIsPlaying() and self._gameStatus == GFlowerConfig.PLAYER_STATUS.LOSE
end

-- 等待下注 --
function GFlowerPlayer:IsWaiting()
    local _logic = GFlowerLogic.GetInstance()
    return _logic:GameIsPlaying() and self._gameStatus == GFlowerConfig.PLAYER_STATUS.WAIT
end

-- 比牌中 --
function GFlowerPlayer:IsComparing()
    local _logic = GFlowerLogic.GetInstance()
    return _logic:GameIsPlaying() and self._gameStatus == GFlowerConfig.PLAYER_STATUS.COMPARE
end

-- 准备操作状态 --
function GFlowerPlayer:IsControl()
    local _logic = GFlowerLogic.GetInstance()
    return _logic:GameIsPlaying() and self._gameStatus == GFlowerConfig.PLAYER_STATUS.CONTROL
end

-- 空闲状态 --
function GFlowerPlayer:IsFree()
    local _logic = GFlowerLogic.GetInstance()
    return _logic:GameIsFree() and self._gameStatus == GFlowerConfig.PLAYER_STATUS.FREE
end

-- 下注数目 设置 --
function GFlowerPlayer:SetAddGameScore(wAddScore,badd)
    self._allScore = wAddScore
    if badd then
        self._ownScore = self._ownScore - wAddScore
    end
end

-- 单局下注 设置 --
function GFlowerPlayer:SetRoundGameScore(wScore)
    self._addScore = wScore
end

-- 网络状态 设置 --
function GFlowerPlayer:SetwStatus(wStatus)
    self._wStatus = wStatus
end

-- 网络状态 获取 --
function GFlowerPlayer:GetwStatus()
    return self._wStatus
end

-- 游戏状态 获取 --
function GFlowerPlayer:GetGameStatus()
    return self._gameStatus
end

-- 离开 --
function GFlowerPlayer:ExitGame(isMissed)
    local _logic = GFlowerLogic.GetInstance()
    if self:IsMySelf() then
        if app.table._standupByHandle then
            self:SetwStatus(US_FREE)
            self:UpdateGameStatus(GFlowerConfig.PLAYER_STATUS.FREE)
        else
            if isMissed == false then
                if self:ScoreEnough() then
                    _logic._gameUI:gfgotoGameChoice()
                else
                    _logic._gameUI:tipQueqian(9)
                end
            end
        end
    else
        self:UpdateGameStatus(GFlowerConfig.PLAYER_STATUS.EXIT)
        self:SetwStatus(US_NULL)
        print("玩家离开")
        _logic._gameUI:PlayerExitGame(self._chairId)
    end
end


-- 比牌加注 --
function GFlowerPlayer:CompareAddScore(addScore)
    local _logic = GFlowerLogic.GetInstance()
    local _allScore = self:GetGameScore() + addScore
    self:SetAddGameScore(_allScore)
    local _coinType = _logic._gameUI:GetCoinType(addScore)
    local _coinNum = self:GetCoinNum()
    _logic._gameUI:CoinFlyAction(self._chairId, _coinType, _coinNum)
end

-- 扔下筹码数量 --
function GFlowerPlayer:GetCoinNum()
    local _coinNum = 0
    local _logic = GFlowerLogic.GetInstance()
    if self._addScore == nil or _logic._currentTimes == nil or
        _logic._currentTimes == 0 then
        return _coinNum
    end
    return math.floor(self._addScore / (_logic._currentTimes * _logic._singleScore))
    -- if self:IsLookCard() then
    --     _coinNum = 2
    -- else
    --     _coinNum = 1
    -- end
    -- return _coinNum
end

-- 金币满足最低要求 --
function GFlowerPlayer:ScoreEnough()
    local _logic = GFlowerLogic.GetInstance()
    return self._ownScore >= _logic._singleScore * 20 and self._ownScore >= _logic._RoomenterScore
end

-- 玩家拥有金币 --
function GFlowerPlayer:GetOwnScore()
    return self._ownScore
end

-- 满足最小跟注要求 --
function GFlowerPlayer:AddSocreEnough()
    local _logic = GFlowerLogic.GetInstance()
    -- if self:IsLookCard() then
    --     return self:GetOwnScore() >= _logic._minScore * 2
    -- else
    --     return self:GetOwnScore() >= _logic._minScore
    -- end
    return self:GetOwnScore() >= _logic._minScore * 4
end

-- 胜利 --
function GFlowerPlayer:Win()
    self._isWinner = true
end

-- 是否胜者 --
function GFlowerPlayer:IsWinner()
    return self._isWinner
end

-- 头像 --
function GFlowerPlayer:GetHeadId()
    return self._headIcon
end

-- 桌子号 --
function GFlowerPlayer:GetTableId()
    return self._wTableId
end

-- 昵称 --
function GFlowerPlayer:GetNickName()
    return self._nickName
end

-- 单局得分 --
function GFlowerPlayer:GetGainScore()
    return self._gainScore
end

-- 是否参加上局游戏 --
function GFlowerPlayer:HasPlayedGame()
    return self._gainScore ~= nil and self._gainScore ~= 0
end

-- 手牌 获取 --
function GFlowerPlayer:GetPlayerCard()
    return self._cards
end

-- 牌型 --
function GFlowerPlayer:GetCardType()
    return self._cardType
end

-- 性别 --
function GFlowerPlayer:IsMan()
    return self._headIcon < 16
    -- return self._sex ~= 0
end

-- 头像路径 --
function GFlowerPlayer:GetHeadStr(headType)
    return self._headIconStr[headType]
end

return GFlowerPlayer