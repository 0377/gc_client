--[[
	用户存储玩家信息
]]
local GFlowerPlayerInfo = class("GFlowerPlayerInfo",PlayerInfo);

-- // 其他玩家可见信息
-- message PlayerVisualInfo {
-- 	optional int32 chair_id = 1;					// 座位
-- 	optional int32 guid = 2;						// 玩家的guid
-- 	optional string account = 3;					// 账号
-- 	optional string nickname = 4;					// 昵称
-- 	optional int32 level = 5[default = 1];			// 玩家等级
-- 	optional int64 money = 6[default = 0]; 			// 有多少钱
-- }
--     --用户状态
-- US_NULL                     =   0                                --没有状态
-- US_FREE                     =   1                                --站立状态
-- US_SIT                      =   2                                --坐下状态
-- US_READY                    =   3                                --同意状态
-- US_LOOKON                   =   4                                --旁观状态
-- US_PLAYING                  =   5                                --游戏状态
-- US_OFFLINE                  =   6                                --断线状态

function GFlowerPlayerInfo:ctor()
   GFlowerPlayerInfo.super.ctor(self)
   CustomHelper.addSetterAndGetterMethod(self,"gameState",0);   --游戏状态
   CustomHelper.addSetterAndGetterMethod(self,"chairId",0);     --坐位ID
   CustomHelper.addSetterAndGetterMethod(self,"clientChairId", 0)
   CustomHelper.addSetterAndGetterMethod(self,"playerOrder", 0)
   CustomHelper.addSetterAndGetterMethod(self,"roundNum", 0)
   CustomHelper.addSetterAndGetterMethod(self,"downMoney", 0)
end

--初始化登录属性
function GFlowerPlayerInfo:updatePlayerPropertyWithInfoTab(infoTab)
	GFlowerPlayerInfo.super.updatePlayerPropertyWithInfoTab(self,infoTab)
	self:setOnePropertyWithKey(infoTab,"chair_id","chairId");
    self:setOnePropertyWithKey(infoTab,"serverChairId", "clientChairId")
    local name = sx_SubStringUTF8(self.ip_position, 12)
    self.nickName = name
end

function GFlowerPlayerInfo:copyMyPlayerInfo(playerInfo)
	-- body
  self:setMoney(playerInfo:getMoney())
  self:setGuid(playerInfo:getGuid())
  self:setLevel(playerInfo:getLevel())
  self:setNickName(playerInfo:getNickName())

end

function GFlowerPlayerInfo:clearInfo()
              
end

return GFlowerPlayerInfo;