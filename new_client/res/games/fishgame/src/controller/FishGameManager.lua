--
-- Author: Your Name
-- Date: 2016-12-29 11:53:07
-- 游戏管理器
--

local SubGameBaseManager = requireForGameLuaFile("SubGameBaseManager")
FishGameManager = class("FishGameManager", SubGameBaseManager)
import(".FishGameDataManager")

FishGameManager.MsgName = 
{
	CS_TreasureEnd = 'CS_TreasureEnd',
    CS_ChangeCannonSet = 'CS_ChangeCannonSet',
    CS_Netcast = 'CS_Netcast',
    CS_LockFish = 'CS_LockFish',
    CS_Fire = 'CS_Fire',
    CS_ChangeCannon = 'CS_ChangeCannon',
    CS_ChangeScore = 'CS_ChangeScore',
    CS_TimeSync = 'CS_TimeSync',

    SC_FishMul = 'SC_FishMul',
    SC_AddBuffer = 'SC_AddBuffer',
    SC_BulletSet = 'SC_BulletSet',
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

function FishGameManager:ctor()
    -- body
    self.gameDetailInfoTab = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab()
    --游戏包根目录，在HallGameConfig中配置
    CustomHelper.addSetterAndGetterMethod(self,"packageRootPath",self.gameDetailInfoTab[HallGameConfig.GamePackageRootPathKey])
    --游戏数据管理器
    CustomHelper.addSetterAndGetterMethod(self,"dataManager",FishGameDataManager:create())

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

return FishGameManager















