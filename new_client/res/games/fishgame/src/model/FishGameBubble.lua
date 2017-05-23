local FishGameXMLConfigManager = requireForGameLuaFile("FishGameXMLConfigManager")


local FishGameBubble = class("FishGameBubble",function()
    return display.newNode()
end)

function FishGameBubble:ctor(index)
--    self:onUpdate(handler(self, self._onInterval))

    self._index = index
    self._dataMng = FishGameManager:getInstance():getDataManager()
    local x, y = FishGameXMLConfigManager:getInstance():getCannonPosition(index - 1)

    self._main = nil
    self._subs = {}
    self._cannonPos = { x = x, y = y }
end

function FishGameBubble:_onInterval(dt)
    local player = self._dataMng:getPlayerByChairId(self._index)

    if not player then
        self:hide()
        return
    end

    local fishId = player:getLockedFishId()
    if not (fishId and fishId ~= 0 ) then
        self:hide()
        return
    end

    local fish = game.fishgame2d.FishObjectManager:GetInstance():FindFish(fishId)
    if not fish then
        self:hide()
        self:reset()

        player:setLockedFishId(0)
        return
    end

    self:show()

    if tolua.isnull(self._main) then
        local main = display.newSprite("ui/icon_lock_line.png")
        main:setScale(1.5)
        self:addChild(main, 1)

        self._main = main
    end


    local x, y = fish:getPosition().x, fish:getPosition().y


    self._main:move(x,y)

    local distance = game.fishgame2d.MathAide:CalcDistance(self._cannonPos.x, self._cannonPos.y, x, y) - 50
    local angle = math.atan((self._cannonPos.y - y) / (self._cannonPos.x - x))
    if self._cannonPos.x - x > 0 then
        angle = angle + math.pi
    end

    local index = distance / 50
    for i = 1, math.max(index, #self._subs) do
        local bubble = self._subs[i]
        if i > index then
            if not tolua.isnull(bubble) then
                bubble:removeSelf()
                self._subs[i] = nil
            end
        else
            if tolua.isnull(bubble) then
                bubble = display.newSprite("ui/icon_lock_line.png")
                self:addChild(bubble, 100)
            end
            self._subs[i] = bubble
            bubble:setPosition(self._cannonPos.x + math.cos((angle)) * (distance * i / index + 50),
                self._cannonPos.y + math.sin((angle)) * (i / index * distance + 50))
        end
    end

end

function FishGameBubble:reset()
    self:removeAllChildren()
    self._main = nil
    self._list = {}
end

return FishGameBubble