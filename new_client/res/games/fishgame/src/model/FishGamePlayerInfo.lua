--
-- Author: Your Name
-- Date: 2017-01-05 10:54:54
-- 捕鱼玩家信息

local FishGamePlayerInfo = class("FishGamePlayerInfo", PlayerInfo)

function FishGamePlayerInfo:ctor()
    FishGamePlayerInfo.super.ctor(self)

    CustomHelper.addSetterAndGetterMethod(self,"chairId", 0)
    CustomHelper.addSetterAndGetterMethod(self,"lockedFishId", 0)
	CustomHelper.addSetterAndGetterMethod(self,"cannonType", 0)
    CustomHelper.addSetterAndGetterMethod(self,"cannonSet", 0)
	CustomHelper.addSetterAndGetterMethod(self,"cannonMul", 0)
	CustomHelper.addSetterAndGetterMethod(self,"score", 0)
end


function FishGamePlayerInfo:updatePlayerPropertyWithInfoTab(infoTab)
    FishGamePlayerInfo.super.updatePlayerPropertyWithInfoTab(self,infoTab)

    self:setOnePropertyWithKey(infoTab,"chair_id","chairId");
    self:setOnePropertyWithKey(infoTab,"serverChairId", "clientChairId")
end

return FishGamePlayerInfo