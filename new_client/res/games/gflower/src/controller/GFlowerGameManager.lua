local SubGameBaseManager = requireForGameLuaFile("SubGameBaseManager");
GFlowerGameManager = class("GFlowerGameManager", SubGameBaseManager)
requireForGameLuaFile("GFlowerGameDataManager");


GFlowerGameManager.MsgName =
{
    --CS_EnterRoom = 'CS_EnterRoom', --进入房间 --不用
    SC_ZhaJinHuaStart = 'SC_ZhaJinHuaStart', --发牌
    CS_StandUpAndExitRoom = 'CS_StandUpAndExitRoom', --站起并退出房间

    CS_ZhaJinHuaAddScore = 'CS_ZhaJinHuaAddScore', --用户加注
    SC_ZhaJinHuaAddScore = 'SC_ZhaJinHuaAddScore', --用户加注

    CS_ZhaJinHuaGiveUp = 'CS_ZhaJinHuaGiveUp', --放弃跟注
    SC_ZhaJinHuaGiveUp = 'SC_ZhaJinHuaGiveUp', --放弃跟注

    CS_ZhaJinHuaLookCard = 'CS_ZhaJinHuaLookCard', --看牌
    SC_ZhaJinHuaLookCard = 'SC_ZhaJinHuaLookCard', --看牌
    SC_ZhaJinHuaNotifyLookCard = 'SC_ZhaJinHuaNotifyLookCard', --看牌

    CS_ZhaJinHuaCompareCard = 'CS_ZhaJinHuaCompareCard', --比牌
    SC_ZhaJinHuaCompareCard = 'SC_ZhaJinHuaCompareCard', --比牌

    SC_ZhaJinHuaEnd = 'SC_ZhaJinHuaEnd', -- 游戏结束

    CS_ChangeTable = "CS_ChangeTable", --切换桌子
    SC_ChangeTable = "SC_ChangeTable", ---切换桌子

    SC_ZhaJinHuaWatch = 'SC_ZhaJinHuaWatch', -- 玩家状态等信息
	CS_ZhaJinHuaGetPlayerStatus = 'CS_ZhaJinHuaGetPlayerStatus', -- 请求玩家状态等信息

    SC_ZhaJinHuaReConnect = 'SC_ZhaJinHuaReConnect', -- 重连
    CS_ReconnectionPlay = 'CS_ReconnectionPlay', ---断线重连发送消息

    CS_ZhaJinHuaGetSitDown = 'CS_ZhaJinHuaGetSitDown', ---断线重连请求房间信息
    SC_ZhaJinHuaGetSitDown = 'SC_ZhaJinHuaGetSitDown',

    SC_ShowTax = 'SC_ShowTax',  -- 税收开关

    SC_ZhaJinHuaLostCards = 'SC_ZhaJinHuaLostCards', --比牌向输家展示两家牌
    SC_ZhaJinHuaReadyTime = 'SC_ZhaJinHuaReadyTime', --服务器通知客户端准备剩余时间
    SC_ZhaJinHuaClientReadyTime = 'SC_ZhaJinHuaClientReadyTime', --服务器通知客户端准备剩余时间(客户端单独显示处理，服务器无实际逻辑)
}

GFlowerGameManager.instance = nil;
function GFlowerGameManager:getInstance()
    if GFlowerGameManager.instance == nil then
        --todo
        print("GFlowerGameManager:getInstance! !!!!!!!!!!!!!!!!!!!!!!!!")
        GFlowerGameManager.instance = GFlowerGameManager:create();
    end
    return GFlowerGameManager.instance;
end

function GFlowerGameManager:ctor()
    self.gameDetailInfoTab = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab();
    --dump(self.gameDetailInfoTab, "sx_self.gameDetailInfoTab", nesting)
    --增加属性
    CustomHelper.addSetterAndGetterMethod(self, "packageRootPath", self.gameDetailInfoTab[HallGameConfig.GamePackageRootPathKey]); --游戏包根目录，在HallGameConfig中配置
    CustomHelper.addSetterAndGetterMethod(self, "dataManager", GFlowerGameDataManager:create()); --游戏数据管理器
    --注册pb文件
    self:registerPBProtocolToHallMsgManager();
	GFlowerGameManager.super.ctor(self);
end

--注册协议到协议解析中
function GFlowerGameManager:registerPBProtocolToHallMsgManager()
    local pbFileTab = {};
    table.insert(pbFileTab, "common_msg_zhajinhua.proto");
    local hallMsgManager = GameManager:getInstance():getHallManager():getHallMsgManager();
    for k, v in pairs(pbFileTab) do
        local filePath = v;--self.packageRootPath .. "res/pb_files/" .. v
        local pbFullPath = cc.FileUtils:getInstance():fullPathForFilename(filePath);
        hallMsgManager:registerProtoFileToPb(pbFullPath);
    end

    --增加解析key
    for k, v in pairs(GFlowerGameManager.MsgName) do
        hallMsgManager:registerMsgNameToMsgPBMananager(v);
    end
end

-- --增加消息处理监听函数
-- function GFlowerGameManager:registerNotification()
-- end

--重连请求房间信息 CS_ZhaJinHuaGetSitDown
function GFlowerGameManager:sendMsgZhaJinHuaGetSitDown()  
    local  msgTab = {};
    local msgName = GFlowerGameManager.MsgName.CS_ZhaJinHuaGetSitDown;
    GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName, msgTab)
end

-- 获取重连信息返回 
function GFlowerGameManager:on_SC_ZhaJinHuaGetSitDown(msgTab)
    --dump(msgTab, "----------------------获取重连信息返回")
    self:getDataManager():_onMsg_ReConnectInfo(msgTab)
end

-- 玩家坐下
function GFlowerGameManager:on_SC_EnterRoomAndSitDown(msgTab)
    print("----------------------进入房间坐下")
    --dump(msgTab, "----------------------进入 房间坐下")
end

-- 请求玩家状态等信息
function GFlowerGameManager:send_CS_ZhaJinHuaGetPlayerStatus()
    -- 3秒不返回退出场景
    self:getDataManager().StandUp = true
    self:getDataManager():my_NotifyStandUp()

    local msgTab = {};
    local msgName = GFlowerGameManager.MsgName.CS_ZhaJinHuaGetPlayerStatus
    GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName, msgTab)
end

function GFlowerGameManager:on_SC_ZhaJinHuaWatch(msgTab)
    --dump(msgTab, "sx--新玩家进入--------------1-");
    -- 获取房间其他玩家状态
    self:getDataManager():S2C_ZhaJinHuaWatch(msgTab)
end

---切换桌子
function GFlowerGameManager:sendMsgChangeTable()
    self:getDataManager().huanzhuo = true
    local  msgTab = {};
    local msgName = GFlowerGameManager.MsgName.CS_ChangeTable;
    GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
end

---切换桌子成功并坐下
function GFlowerGameManager:on_SC_ChangeTable(msgTab)
    --dump(msgTab, "切换桌子成功并坐下")
    self:getDataManager():S2C_ChangeTable(msgTab)
end

-- 准备返回
function GFlowerGameManager:on_SC_Ready(msgTab)
    self:getDataManager():S2C_Ready(msgTab)
end

--通知其他人进入房间
function GFlowerGameManager:on_SC_NotifyEnterRoom(msgTab)
    --dump(msgTab, "通知其他人进入房间");
end         

---通知其他人离开房间
function GFlowerGameManager:on_SC_NotifyExitRoom(msgTab)
    --dump(msgTab, "---通知其他人离开房间");
end

--通知同桌坐下
function GFlowerGameManager:on_SC_NotifySitDown(msgTab)
    --print("-----------------------------------------------通知同桌坐下");
    self:getDataManager():S2C_NotifySitDown(msgTab)
end

--通知同桌站起
function GFlowerGameManager:on_SC_NotifyStandUp(msgTab)
    --dump(msgTab, "---通知同桌站起")
    self:getDataManager():S2C_NotifyStandUp(msgTab)
end

---站起并离开房间
function GFlowerGameManager:sendStandUpAndExitRoomMsg()
    GameManager:getInstance():getHallManager():getHallMsgManager():sendStandUpAndExitRoom()
end

function GFlowerGameManager:on_SC_StandUpAndExitRoom(msgTab)

    --dump(msgTab,"站起并离开房间")
    self:getDataManager():S2C_StandUpAndExitRoom(msgTab)
end

------------------上面是通用消息，下面是该游戏消息---------------------

-- 税收开关
function GFlowerGameManager:on_SC_ShowTax(msgTab)
    --dump(msgTab, "税收开关")
    self:getDataManager():S2C_ShowTax(msgTab)
end

--sx 发牌 --
function GFlowerGameManager:on_SC_ZhaJinHuaStart(msgTab)
    self:getDataManager():S2C_ZhaJinHuaStart(msgTab)
end

--sx 加注 全下
function GFlowerGameManager:send_CS_ZhaJinHuaShowHandScore(score)
    local msgTab = {};
    msgTab.score = score
    local msgName = GFlowerGameManager.MsgName.CS_ZhaJinHuaAddScore
    GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName, msgTab)
end

--sx 加注 跟注
function GFlowerGameManager:send_CS_ZhaJinHuaAddScore(score)
    local msgTab = {};
    msgTab.score = score
    local msgName = GFlowerGameManager.MsgName.CS_ZhaJinHuaAddScore
    GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName, msgTab)
end

--sx 放弃跟注
function GFlowerGameManager:send_CS_ZhaJinHuaGiveUp()
    local  msgTab = {};
    local msgName = GFlowerGameManager.MsgName.CS_ZhaJinHuaGiveUp
    GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName, msgTab)
end

--sx 看牌
function GFlowerGameManager:send_CS_ZhaJinHuaLookCard(msgTab)
    local  msgTab = {};
    local msgName = GFlowerGameManager.MsgName.CS_ZhaJinHuaLookCard
    GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName, msgTab)
end

--sx 比牌
function GFlowerGameManager:send_CS_ZhaJinHuaCompareCard(chair_id)
    local msgTab = {};
    msgTab.compare_chair_id = self:getDataManager():getServerChairId(chair_id)
    local msgName = GFlowerGameManager.MsgName.CS_ZhaJinHuaCompareCard
    GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName, msgTab)
end

--sx 加注 跟注 返回
function GFlowerGameManager:on_SC_ZhaJinHuaAddScore(msgTab)
    self:getDataManager():S2C_ZhaJinHuaAddScore(msgTab)
end

--sx 放弃跟注
function GFlowerGameManager:on_SC_ZhaJinHuaGiveUp(msgTab)
    self:getDataManager():S2C_ZhaJinHuaGiveUp(msgTab)
end

--sx 看牌返回
function GFlowerGameManager:on_SC_ZhaJinHuaLookCard(msgTab)
    self:getDataManager():S2C_ZhaJinHuaLookCard(msgTab)
end

--sx 别家看牌返回
function GFlowerGameManager:on_SC_ZhaJinHuaNotifyLookCard(msgTab)
    self:getDataManager():S2C_ZhaJinHuaNotifyLookCard(msgTab)
end

--sx 比牌返回
function GFlowerGameManager:on_SC_ZhaJinHuaCompareCard(msgTab)
    self:getDataManager():S2C_ZhaJinHuaCompareCard(msgTab)
end

--sx 比牌返回给输家
function GFlowerGameManager:on_SC_ZhaJinHuaLostCards(msgTab)
    --dump(msgTab, "输家展示-----------------")
    self:getDataManager():S2C_ZhaJinHuaLostCards(msgTab)
end

-- 准备倒计时时间
function GFlowerGameManager:on_SC_ZhaJinHuaReadyTime(msgTab)
    self:getDataManager():S2C_ZhaJinHuaReadyTime(msgTab)
end

-- 客户端准备倒计时
function GFlowerGameManager:on_SC_ZhaJinHuaClientReadyTime(msgTab)
   self:getDataManager():S2C_ZhaJinHuaClientReadyTime(msgTab)
end

--sx 游戏结束返回
function GFlowerGameManager:on_SC_ZhaJinHuaEnd(msgTab)
    self:getDataManager():S2C_ZhaJinHuaEnd(msgTab)
end

--重新连接Ui准备好后 发送这个消息
function GFlowerGameManager:sendMsgReconnectionPlay()
    local  msgTab = {};
    local msgName = GFlowerGameManager.MsgName.CS_ReconnectionPlay;
    GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(msgName,msgTab)
    --print("----------------------------------------------------------------发送重连")
end

return GFlowerGameManager;