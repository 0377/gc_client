--
-- Author: Your Name
-- Date: 2017-01-05 10:54:54
-- 捕鱼玩家信息

local FishGamePlayerInfo = class("FishGamePlayerInfo", PlayerInfo)

function FishGamePlayerInfo:ctor()
    FishGamePlayerInfo.super.ctor(self)

    CustomHelper.addSetterAndGetterMethod(self, "chairId", 0)
    CustomHelper.addSetterAndGetterMethod(self, "optIndex", 0)
    CustomHelper.addSetterAndGetterMethod(self, "lockedFishId", 0)
    CustomHelper.addSetterAndGetterMethod(self, "cannonType", 0)
    CustomHelper.addSetterAndGetterMethod(self, "cannonSet", 0)
    CustomHelper.addSetterAndGetterMethod(self, "cannonMul", 0)
    CustomHelper.addSetterAndGetterMethod(self, "score", 0)

    CustomHelper.addSetterAndGetterMethod(self, "tableUI", 0)
    CustomHelper.addSetterAndGetterMethod(self, "cannon", 0)
    CustomHelper.addSetterAndGetterMethod(self, "bubble", 0)
end


function FishGamePlayerInfo:updatePlayerPropertyWithInfoTab(infoTab)
    FishGamePlayerInfo.super.updatePlayerPropertyWithInfoTab(self, infoTab)

    self:setOnePropertyWithKey(infoTab, "chair_id", "chairId");
    self:setOnePropertyWithKey(infoTab, "serverChairId", "clientChairId")
end

function FishGamePlayerInfo:isMyself()
    return self.myself
end

function FishGamePlayerInfo:setIsMyself(beMyself)
    self.myself = beMyself
end

function FishGamePlayerInfo:setScore(score)
    self.score = score

    local labelMoney = self.tableUI.label_money
    labelMoney:setString(CustomHelper.moneyShowStyleNone(score))

    labelMoney:setScale(math.min(1,160 / labelMoney:getContentSize().width))
end

return FishGamePlayerInfo