--
-- Author: Your Name
-- Date: 2016-12-29 15:07:41
-- 数据管理器  本类主要操作游戏数据
--

local FishGameDataManager = class("FishGameDataManager")
local FishGameScene = requireForGameLuaFile("FishGameScene")
local FishGamePlayerInfo = requireForGameLuaFile("FishGamePlayerInfo")
local FishGameConfig = requireForGameLuaFile("FishGameConfig")
--
-- start 引入数据对象
--

-- end
local schedule = cc.Director:getInstance():getScheduler()

-- 类的初始化方法，自动调用
function FishGameDataManager:ctor()
    -- body
    CustomHelper.addSetterAndGetterMethod(self, "roomInfo", GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab())
    CustomHelper.addSetterAndGetterMethod(self, "myChairId", 0)
    CustomHelper.addSetterAndGetterMethod(self, "serverTimeInterval", 0xFFFFFFFF)
    CustomHelper.addSetterAndGetterMethod(self, "allowFire", false)
    CustomHelper.addSetterAndGetterMethod(self, "lockedFishId", 0)
    CustomHelper.addSetterAndGetterMethod(self, "startTime", socket.gettime())
    CustomHelper.addSetterAndGetterMethod(self, "mirrorShow", false)

    CustomHelper.addSetterAndGetterMethod(self, "fireInterval", 1000)
    CustomHelper.addSetterAndGetterMethod(self, "maxBulletCount", 20)
    CustomHelper.addSetterAndGetterMethod(self, "maxCannon", 100)
    CustomHelper.addSetterAndGetterMethod(self, "gameConfig", nil)

    self._playersOptIndex = {}
    self._players = {}
    self._bulletSet = {}
end

function FishGameDataManager:getBulletConfig(mulriple)
    return self._bulletSet[mulriple + 1]
end

function FishGameDataManager:getServerTime()
    local interval = self:getServerTimeInterval()
    return interval + self:getClientTime()
end

function FishGameDataManager:getClientTime()
    return math.floor((socket.gettime() - self:getStartTime()) * 1000)
end

function FishGameDataManager:getMyPlayerInfo()
    return self._players[self.myChairId]
end

function FishGameDataManager:getPlayeres()
    return self._players
end

--- 通过座位号获取玩家
function FishGameDataManager:getPlayerByChairId(chairId)

    return self._players[chairId]
end

function FishGameDataManager:getPlayerByOptIndex(optIndex)
    return self._playersOptIndex[optIndex]
end

---  根据收到的座位ID，镜像获得要操作的座位ID
function FishGameDataManager:getOperateChair(recChair)
    if self:getMirrorShow() == true then
        if recChair == FishGameConfig.PLAYER.LEFTTOP then
            return FishGameConfig.PLAYER.RIGHTBOTTOM
        elseif recChair == FishGameConfig.PLAYER.RIGHTTOP then
            return FishGameConfig.PLAYER.LEFTBOTTOM
        elseif recChair == FishGameConfig.PLAYER.LEFTBOTTOM then
            return FishGameConfig.PLAYER.RIGHTTOP
        elseif recChair == FishGameConfig.PLAYER.RIGHTBOTTOM then
            return FishGameConfig.PLAYER.LEFTTOP
        end
    end

    return recChair
end

function FishGameDataManager:getMyBulletId()
    local chairId = self:getMyChairId()
    if not self.m_bulletId then
        self.m_bulletId = 1
    end

    local bulletId = chairId * 20000 + self.m_bulletId
    self.m_bulletId = self.m_bulletId + 1

    if self.m_bulletId >= 20000 then
        self.m_bulletId = 1
    end

    return bulletId
end


function FishGameDataManager:on_SC_EnterRoomAndSitDownInfo(infoTab)
    dump(infoTab, "infoTab")

    infoTab = infoTab or {}
    --  上面的玩家要做镜像
    local chair_id = infoTab.chair_id
    if chair_id == FishGameConfig.PLAYER.LEFTTOP or
            chair_id == FishGameConfig.PLAYER.RIGHTTOP then
        self:setMirrorShow(true)
    end

    self:setMyChairId(infoTab.chair_id)

    local player = FishGamePlayerInfo:create()
    local playerInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
    player:setChairId(infoTab.chair_id)
    player:setNickName(playerInfo:getNickName())
    player:updatePlayerPropertyWithInfoTab(infoTab)
    player:setIsMyself(true)
    player:setOptIndex(self:getOperateChair(infoTab.chair_id))

    self._players[infoTab.chair_id] = player
    self._playersOptIndex[player:getOptIndex()] = player


    -- 已经在房间内的玩家
    local players = infoTab.pb_visual_info
    if players ~= nil then
        for k, player in pairs(players) do

            local othergfPlayer = FishGamePlayerInfo:create()
            othergfPlayer:updatePlayerPropertyWithInfoTab(player)
            othergfPlayer:setChairId(player.chair_id)
            othergfPlayer:setNickName(player.nickname)
            othergfPlayer:setOptIndex(self:getOperateChair(player.chair_id))

            if othergfPlayer:getHeadIconNum() == 0 then
                othergfPlayer:setHeadIconNum(1) -- 默认头像为1
            end

            self._players[othergfPlayer:getChairId()] = othergfPlayer
            self._playersOptIndex[othergfPlayer:getOptIndex()] = othergfPlayer
        end
    end
end

function FishGameDataManager:on_SC_NotifyStandUp(msgTab)
    local player = self._players[msgTab.chair_id]

    self._playersOptIndex[player:getOptIndex()] = nil
    self._players[msgTab.chair_id] = nil
end

function FishGameDataManager:on_SC_NotifySitDown(msgTab)
    local playerInfo = msgTab.pb_visual_info

    local othergfPlayer = FishGamePlayerInfo:create()
    othergfPlayer:updatePlayerPropertyWithInfoTab(playerInfo)
    othergfPlayer:setChairId(playerInfo.chair_id)
    othergfPlayer:setNickName(playerInfo.nickname)
    othergfPlayer:setOptIndex(self:getOperateChair(playerInfo.chair_id))
    if othergfPlayer:getHeadIconNum() == 0 then
        othergfPlayer:setHeadIconNum(1) -- 默认头像为1
    end

    self._players[othergfPlayer:getChairId()] = othergfPlayer
    self._playersOptIndex[othergfPlayer:getOptIndex()] = othergfPlayer
end

function FishGameDataManager:on_SC_FishMul(msgTab)
end

function FishGameDataManager:on_SC_AddBuffer(msgTab)
    game.fishgame2d.FishObjectManager:GetInstance():AddFishBuff(msgTab.buffer_type, msgTab.buffer_param, msgTab.buffer_time)
end

function FishGameDataManager:on_SC_BulletSet(msgTab)
    table.insert(self._bulletSet, {
        cannon_type = msgTab.cannon_type,
        bullet_size = msgTab.bullet_size,
        catch_radio = msgTab.catch_radio,
        max_catch = msgTab.max_catch,
        first = msgTab.first,
        mulriple = msgTab.mulriple,
        speed = msgTab.speed,
    })
end

function FishGameDataManager:on_SC_BulletSet_List(msgTab)
    for _,v in ipairs(msgTab.pb_bullets) do
        table.insert(self._bulletSet, {
            cannon_type = v.cannon_type,
            bullet_size = v.bullet_size,
            catch_radio = v.catch_radio,
            max_catch = v.max_catch,
            first = v.first,
            mulriple = v.mulriple,
            speed = v.speed,
        })
    end

end

function FishGameDataManager:on_SC_SendDes(msgTab)
end

function FishGameDataManager:on_SC_LockFish(msgTab)
        dump(msgTab)
    local player = self:getPlayerByChairId(msgTab.chair_id)
    if player ~= nil then
        player:setLockedFishId(msgTab.lock_id)
    end
end

function FishGameDataManager:on_SC_AllowFire(msgTab)
    self:setAllowFire(msgTab.allow_fire == 1)
end

function FishGameDataManager:on_SC_SwitchScene(msgTab)
end

function FishGameDataManager:on_SC_KillBullet(msgTab)
end

function FishGameDataManager:on_SC_KillFish(msgTab)
end

function FishGameDataManager:on_SC_SendBullet(msgTab)
end

function FishGameDataManager:on_SC_CannonSet(msgTab)
    local player = self:getPlayerByChairId(msgTab.chair_id)
    if player ~= nil then
        player:setCannonType(msgTab.cannon_type)
        player:setCannonMul(msgTab.cannon_mul)
        player:setCannonSet(msgTab.cannon_set)
    end
end

function FishGameDataManager:on_SC_ChangeScore(msgTab)
end

function FishGameDataManager:on_SC_UserInfo(msgTab)
    local player = self:getPlayerByChairId(msgTab.chair_id)
    if player ~= nil then
        player:setScore(msgTab.score)
    end
end

function FishGameDataManager:on_SC_SendFish(msgTab)
    local player = self:getPlayerByChairId(msgTab.chair_id)
    if player ~= nil then
        player:setLockedFishId(msgTab.fish_id)
    end
end

function FishGameDataManager:on_SC_SendFishList(msgTab)
end

function FishGameDataManager:on_SC_GameConfig(msgTab)
    dump(msgTab)

    self:setFireInterval(msgTab.fire_interval / 1000)
    self:setMaxBulletCount(msgTab.max_bullet_count)
    self:setMaxCannon(msgTab.max_cannon)
    self:setGameConfig(msgTab)
end

function FishGameDataManager:on_SC_TimeSync(msgTab)
    local interval = self:getServerTimeInterval()
    local intervalNew = msgTab.server_tick - msgTab.client_tick
    -- 获取最优的同步时间
    if (interval >= 0 and intervalNew >= 0)
            or (interval < 0 and intervalNew < 0) then
        self:setServerTimeInterval(math.min(interval, intervalNew))
    else
        if interval < 0 then
            self:setServerTimeInterval(interval)
        else
            self:setServerTimeInterval(intervalNew)
        end
    end
end

function FishGameDataManager:on_SC_SystemMessage(msgTab)
end


return FishGameDataManager