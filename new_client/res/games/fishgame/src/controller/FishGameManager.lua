--
-- Author: Your Name
-- Date: 2016-12-29 11:53:07
-- 游戏管理器
--

local SubGameBaseManager = requireForGameLuaFile("SubGameBaseManager")
FishGameManager = class("FishGameManager", SubGameBaseManager)
local FishGameDataManager = requireForGameLuaFile("FishGameDataManager")
local FishSoundManager = requireForGameLuaFile("FishSoundManager")

FishGameManager.MsgName = 
{
    SC_NotifyStandUp = 'SC_NotifyStandUp',
    SC_NotifySitDown = 'SC_NotifySitDown',


	CS_TreasureEnd = 'CS_TreasureEnd',
    CS_ChangeCannonSet = 'CS_ChangeCannonSet',
    CS_Netcast = 'CS_Netcast',
    CS_LockFish = 'CS_LockFish',
    CS_LockSpecFish = 'CS_LockSpecFish',
    CS_Fire = 'CS_Fire',
    CS_ChangeCannon = 'CS_ChangeCannon',
    CS_ChangeScore = 'CS_ChangeScore',
    CS_TimeSync = 'CS_TimeSync',

    SC_FishMul = 'SC_FishMul',
    SC_AddBuffer = 'SC_AddBuffer',
    SC_BulletSet = 'SC_BulletSet',
    SC_BulletSet_List = 'SC_BulletSet_List',
    SC_SendDes = 'SC_SendDes',
    SC_LockFish = 'SC_LockFish',
    SC_AllowFire = 'SC_AllowFire',
    SC_SwitchScene = 'SC_SwitchScene',
    SC_KillBullet = 'SC_KillBullet',
    SC_KillFish = 'SC_KillFish',
    SC_SendBullet = 'SC_SendBullet',
    SC_CannonSet = 'SC_CannonSet',
    SC_ChangeScore = 'SC_ChangeScore',
    SC_UserInfo = 'SC_UserInfo',
    SC_SendFish = 'SC_SendFish',
    SC_SendFishList = 'SC_SendFishList',
    SC_GameConfig = 'SC_GameConfig',
    SC_TimeSync = 'SC_TimeSync',
    SC_SystemMessage = 'SC_SystemMessage',
}

FishGameManager.instance = nil
function FishGameManager:getInstance()
    if FishGameManager.instance == nil then
        FishGameManager.instance = FishGameManager:create()
    end
    return FishGameManager.instance
end

function FishGameManager:destroyInstance()
    FishGameManager.instance = nil
end

function FishGameManager:ctor()
    -- body
    self.gameDetailInfoTab = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab()
    --游戏包根目录，在HallGameConfig中配置
    CustomHelper.addSetterAndGetterMethod(self,"packageRootPath",self.gameDetailInfoTab[HallGameConfig.GamePackageRootPathKey])
    --游戏数据管理器
    CustomHelper.addSetterAndGetterMethod(self,"dataManager",FishGameDataManager:create())
    CustomHelper.addSetterAndGetterMethod(self,"soundManager",FishSoundManager:create())

    self:registerPBProtocolToHallMsgManager()
end

--注册协议到协议解析中  
--继承自 SubGameBaseManager
function FishGameManager:registerPBProtocolToHallMsgManager()
    local pbFileTab = {}
    table.insert(pbFileTab, "common_msg_fishing.proto")
    local hallMsgManager = GameManager:getInstance():getHallManager():getHallMsgManager()
    for k,v in pairs(pbFileTab) do
        local filePath = v
        local pbFullPath = cc.FileUtils:getInstance():fullPathForFilename(filePath)
        hallMsgManager:registerProtoFileToPb(pbFullPath)
    end

    for k,v in pairs(FishGameManager.MsgName) do
        print(k.."-----".. v)
        hallMsgManager:registerMsgNameToMsgPBMananager(v)
    end

end

--增加消息处理监听函数
function FishGameManager:registerNotification()
    
end

function FishGameManager:onExit()
    self:destroyInstance()
end

-----------------  大厅消息
-- 玩家坐下
function FishGameManager:on_SC_EnterRoomAndSitDown(msgTab)
    --dump(msgTab, "----------------------进入 房间坐下")
	self:getDataManager():on_SC_EnterRoomAndSitDownInfo(msgTab)
end



function FishGameManager:on_SC_NotifyStandUp(msgTab)
dump(msgTab)
    self:getDataManager():on_SC_NotifyStandUp(msgTab)
end

function FishGameManager:on_SC_NotifySitDown(msgTab)
    dump(msgTab)
    self:getDataManager():on_SC_NotifySitDown(msgTab)
end
-----------------  捕鱼消息
-- 鱼增加值
function FishGameManager:on_SC_FishMul(msgTab)
    self:getDataManager():on_SC_FishMul(msgTab)
end

-- 添加BUFFER
function FishGameManager:on_SC_AddBuffer(msgTab)
    self:getDataManager():on_SC_AddBuffer(msgTab)
end

-- 返回子弹集信息
function FishGameManager:on_SC_BulletSet(msgTab)
    self:getDataManager():on_SC_BulletSet(msgTab)
end

-- 返回子弹集信息
function FishGameManager:on_SC_BulletSet_List(msgTab)
    self:getDataManager():on_SC_BulletSet_List(msgTab)
end

-- 鱼描述信息
function FishGameManager:on_SC_SendDes(msgTab)
    self:getDataManager():on_SC_SendDes(msgTab)
end

-- 锁定目标鱼
function FishGameManager:on_SC_LockFish(msgTab)
    self:getDataManager():on_SC_LockFish(msgTab)
end

-- 是否允许开火
function FishGameManager:on_SC_AllowFire(msgTab)
    self:getDataManager():on_SC_AllowFire(msgTab)
end

-- 切换场景
function FishGameManager:on_SC_SwitchScene(msgTab)
    self:getDataManager():on_SC_SwitchScene(msgTab)
end

-- 销毁子弹
function FishGameManager:on_SC_KillBullet(msgTab)
    self:getDataManager():on_SC_KillBullet(msgTab)
end

-- 销毁鱼
function FishGameManager:on_SC_KillFish(msgTab)
    self:getDataManager():on_SC_KillFish(msgTab)
end

-- 发出子弹
function FishGameManager:on_SC_SendBullet(msgTab)
    self:getDataManager():on_SC_SendBullet(msgTab)
end

-- 改变炮台返回
function FishGameManager:on_SC_CannonSet(msgTab)
    self:getDataManager():on_SC_CannonSet(msgTab)
end

-- 修改积分
function FishGameManager:on_SC_ChangeScore(msgTab)
    self:getDataManager():on_SC_ChangeScore(msgTab)
end

-- 玩家信息
function FishGameManager:on_SC_UserInfo(msgTab)
    self:getDataManager():on_SC_UserInfo(msgTab)
end

-- 增加鱼
function FishGameManager:on_SC_SendFish(msgTab)
    self:getDataManager():on_SC_SendFish(msgTab)
end

-- 增加鱼列表
function FishGameManager:on_SC_SendFishList(msgTab)
    self:getDataManager():on_SC_SendFishList(msgTab)
end

-- 游戏设置
function FishGameManager:on_SC_GameConfig(msgTab)
    self:getDataManager():on_SC_GameConfig(msgTab)
end

-- 同步时间
function FishGameManager:on_SC_TimeSync(msgTab)
    self:getDataManager():on_SC_TimeSync(msgTab)
end

-- 系统消息
function FishGameManager:on_SC_SystemMessage(msgTab)
    self:getDataManager():on_SC_SystemMessage(msgTab)
end

-------------------------- 发送消息
-- 打开宝箱
function FishGameManager:send_CS_TreasureEnd()
    local msgTab = {
        chair_id = 1,
        score = 1,
    }
    local msgName = FishGameManager.MsgName.CS_TreasureEnd;
    GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end

--- 改变大炮集
function FishGameManager:send_CS_ChangeCannonSet()
    local msgTab = {
        chair_id = 1,
        add = 1,
    }
    local msgName = FishGameManager.MsgName.CS_ChangeCannonSet;
    GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end

--- 发送渔网
function FishGameManager:send_CS_Netcast(data)
    local msgTab = {
        bullet_id = data.bullet_id,
        fish_id = data.fish_id,
        data = data.bullet_id,
    }
    local msgName = FishGameManager.MsgName.CS_Netcast;
    GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end

--- 锁定鱼
function FishGameManager:send_CS_LockFish(bLock)
    local msgTab = {
        chair_id= self:getDataManager():getMyChairId(),
        lock = bLock and 1 or 0,
    }
    local msgName = FishGameManager.MsgName.CS_LockFish;
    GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end

--- 锁定鱼
function FishGameManager:send_CS_LockSepcFish(fishId)
    local msgTab = {
        chair_id= self:getDataManager():getMyChairId(),
        fish_id = fishId,
    }
    local msgName = FishGameManager.MsgName.CS_LockSpecFish;
    GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end

--- 开火
function FishGameManager:send_CS_Fire(data)
    local msgTab = {
        chair_id= self:getDataManager():getMyChairId(),
        direction = data.direction,
        fire_time = data.fire_time,
        client_id = data.client_id,
        pos_x = data.pos_x,
        pos_y = data.pos_y,
    }

    local msgName = FishGameManager.MsgName.CS_Fire;
    GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end

--- 更换大炮
function FishGameManager:send_CS_ChangeCannon(isAdd)
    local msgTab = {
        chair_id= self:getDataManager():getMyChairId(),
        add = isAdd and 1 or 0,
    }
    dump(msgTab)
    local msgName = FishGameManager.MsgName.CS_ChangeCannon;
	dump(msgTab,"msgTab")
    GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end

--- 改变积分
function FishGameManager:send_CS_ChangeScore()
    local msgTab = {
        chair_id= self:getDataManager():getMyChairId(),
        add = 1,
        add_all = 1,
    }
    local msgName = FishGameManager.MsgName.CS_ChangeScore;
    GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end

--- 同步时间
function FishGameManager:send_CS_TimeSync()
    local msgTab = {
        chair_id = self:getDataManager():getMyChairId(),
        client_tick = self:getDataManager():getClientTime(),
    }
    local msgName = FishGameManager.MsgName.CS_TimeSync;
    GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end

-- 发送准备消息
function FishGameManager:sendGameReady()
	GameManager:getInstance():getHallManager():getHallMsgManager():sendGameReady();
end

return FishGameManager















