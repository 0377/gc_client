--
-- Author: Your Name
-- Date: 2016-12-29 15:07:41
-- 数据管理器  本类主要操作游戏数据
--

FishGameDataManager = class("FishGameDataManager")
local FishGameScene = requireForGameLuaFile("FishGameScene")
local FishGamePlayerInfo = requireForGameLuaFile("FishGamePlayerInfo")
local FishGameConfig     = requireForGameLuaFile("FishGameConfig")
--
-- start 引入数据对象  
--

-- end
local schedule  = cc.Director:getInstance():getScheduler()

-- 类的初始化方法，自动调用
function FishGameDataManager:ctor()
	-- body
    CustomHelper.addSetterAndGetterMethod(self,"myChairId",0)
    CustomHelper.addSetterAndGetterMethod(self,"serverTimeInterval",0xFFFFFFFF)
    CustomHelper.addSetterAndGetterMethod(self, "allowFire", false)
    CustomHelper.addSetterAndGetterMethod(self, "lockedFishId", 0)
    CustomHelper.addSetterAndGetterMethod(self, "startTime", socket.gettime())
	CustomHelper.addSetterAndGetterMethod(self, "mirrorShow", false)

    CustomHelper.addSetterAndGetterMethod(self, "fireInterval", 1000)
    CustomHelper.addSetterAndGetterMethod(self, "maxBulletCount", 20)
    CustomHelper.addSetterAndGetterMethod(self, "maxCannon", 100)
    CustomHelper.addSetterAndGetterMethod(self, "gameConfig", nil)

    self._players = {}
    self._bulletSet = {}
end

function FishGameDataManager:getServerTime()
    local interval = self:getServerTimeInterval()
    return interval + self:getClientTime()
end

function FishGameDataManager:getClientTime()
    return math.floor((socket.gettime() - self:getStartTime()) * 1000)
end

--- 通过座位号获取玩家
function FishGameDataManager:getPlayerByChairId(chairId)

    return self._players[chairId]
end

function FishGameDataManager:onFishMul(msgTab)
end

function FishGameDataManager:onAddBuffer(msgTab)
    game.fishgame2d.FishObjectManager:GetInstance():AddFishBuff(msgTab.buffer_type,msgTab.buffer_param,msgTab.buffer_time)

end

function FishGameDataManager:onBulletSet(msgTab)
    table.insert(self._bulletSet,{
        cannon_type = msgTab.cannon_type,
        bullet_size = msgTab.bullet_size,
        catch_radio = msgTab.catch_radio,
        max_catch = msgTab.max_catch,
        first = msgTab.first,
        mulriple = msgTab.mulriple,
        speed = msgTab.speed,
    })

end

function FishGameDataManager:onSendDes(msgTab)
end

function FishGameDataManager:onLockFish(msgTab)
    local player = self:getPlayerByChairId(msgTab.chair_id)
	if player ~= nil then
		player:setLockedFishId(msgTab.lock_id)
	end
end

function FishGameDataManager:onAllowFire(msgTab)
    self:setAllowFire(msgTab.allow_fire == 1)
end

function FishGameDataManager:onSwitchScene(msgTab)
end

function FishGameDataManager:onKillBullet(msgTab)
end

function FishGameDataManager:onKillFish(msgTab)
end

function FishGameDataManager:onSendBullet(msgTab)
end

function FishGameDataManager:onCannonSet(msgTab)
	local player = self:getPlayerByChairId(msgTab.chair_id)
	if player ~= nil then
		if msgTab.cannon_type == nil then
			player:setCannonType(0)
		else
			player:setCannonType(msgTab.cannon_type)
		end
		
		if msgTab.cannon_mul == nil then
			player:setCannonMul(0)
		else
			player:setCannonMul(msgTab.cannon_mul)
		end
		
		if msgTab.cannon_set == nil then
			player:setCannonSet(0)
		else
			player:setCannnnSet(msgTab.cannon_set)
		end
	end
end

function FishGameDataManager:onChangeScore(msgTab)
	
end

function FishGameDataManager:onUserInfo(msgTab)
	dump(msgTab,"msgTab")
	local player = self:getPlayerByChairId(msgTab.chair_id)
	if player ~= nil then
		player:setScore(msgTab.score)
	end
end

function FishGameDataManager:onSendFish(msgTab)
    local player = self:getPlayerByChairId(msgTab.chair_id)
    if player ~= nil then
        player:setLockedFishId(msgTab.fish_id)
    end
end

function FishGameDataManager:onSendFishList(msgTab)
end

function FishGameDataManager:onGameConfig(msgTab)
    dump(msgTab)

    self:setFireInterval(msgTab.fire_interval)
    self:setMaxBulletCount(msgTab.max_bullet_count)
    self:setMaxCannon(msgTab.max_cannon)
    self:setGameConfig(msgTab)
end

function FishGameDataManager:onTimeSync(msgTab)
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

function FishGameDataManager:onSystemMessage(msgTab)
end

function FishGameDataManager:getFireInterval()
	local cof  = self:getGameConfig()
	if cof ~= nil then
		return cof.fire_interval
	end
end

function FishGameDataManager:_onMsg_EnterRoomAndSitDownInfo(infoTab)
    dump(infoTab,"infoTab")

    infoTab = infoTab or {}
    self:setMyChairId(infoTab.chair_id)

    local player = FishGamePlayerInfo:create()
	local playerInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
    player:setChairId(infoTab.chair_id)
	player:setNickName(playerInfo:getNickName())
    player:updatePlayerPropertyWithInfoTab(infoTab)

    self._players[infoTab.chair_id] = player
	
	--  上面的玩家要做镜像
	chair_id = infoTab.chair_id - 1
	if chair_id == FishGameConfig.PLAYER.LEFTTOP or 
	   chair_id == FishGameConfig.PLAYER.RIGHTTOP then
	   self:setMirrorShow(true)
	end

    -- 已经在房间内的玩家
    local players = infoTab.pb_visual_info
    if players ~= nil then
        for k, player in pairs(players) do

            local othergfPlayer = FishGamePlayerInfo:create()
            othergfPlayer:updatePlayerPropertyWithInfoTab(player)
            othergfPlayer:setChairId(player.chair_id)
			othergfPlayer:setNickName(player.nickname)
            if othergfPlayer:getHeadIconNum() == 0 then
                othergfPlayer:setHeadIconNum(1)            -- 默认头像为1
            end

            self._players[othergfPlayer:getChairId()] = othergfPlayer
        end
    end
end

--  根据收到的座位ID，镜像获得要操作的座位ID
function FishGameDataManager:getOperateChair(recChair)
	if self:getMirrorShow() == true then
		if recChair == FishGameConfig.PLAYER.LEFTTOP then
			return FishGameConfig.PLAYER.LEFTBOTTOM 
		elseif recChair == FishGameConfig.PLAYER.RIGHTTOP then
			return FishGameConfig.PLAYER.RIGHTBOTTOM
		elseif recChair == FishGameConfig.PLAYER.LEFTBOTTOM then
			return FishGameConfig.PLAYER.LEFTTOP
		elseif recChair == FishGameConfig.PLAYER.RIGHTBOTTOM then
			return FishGameConfig.PLAYER.RIGHTTOP
		end
	end
	
	return recChair
end

return FishGameDataManager