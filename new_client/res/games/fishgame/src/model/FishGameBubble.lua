local Fishes = requireForGameLuaFile("Fishes")
local Visual = requireForGameLuaFile("Visual")
local ConnonSet = requireForGameLuaFile("ConnonSet")

local FishGameBubble = class("FishGameBubble", function()
    return display.newNode()
end)

function FishGameBubble:ctor(index, nodeLockFish)
    self:onUpdate(handler(self, self._onInterval))

    self._index = index
    self._nodeLockFish = nodeLockFish
    self._dataMng = FishGameManager:getInstance():getDataManager()
    local pos = ConnonSet.cannonPos[index].pos

    self._main = nil
    self._subs = {}
    self._cannonPos = { x = pos[1], y = pos[2] }
end

function FishGameBubble:_onInterval(dt)
    local player = self._dataMng:getPlayerByOptIndex(self._index)
    if not player then
        self:hide()
        return
    end

    local fishId = player:getLockedFishId()
    if not (fishId and fishId ~= 0) then
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
    self:updateLockedFish(fish)

    if tolua.isnull(self._main) then
        local main = display.newSprite("ui/icon_lock_line.png")
        main:setScale(1.5)
        self:addChild(main, 1)

        self._main = main
    end

    local x, y = fish:getPosition().x, fish:getPosition().y
    self._main:move(x, y)

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
                self:addChild(bubble)
            end
            self._subs[i] = bubble
            bubble:setPosition(self._cannonPos.x + math.cos((angle)) * (distance * i / index + 50),
                self._cannonPos.y + math.sin((angle)) * (i / index * distance + 50))
        end
    end
end

function FishGameBubble:show()
    cc.Node.show(self)
    self._nodeLockFish:show()
end

function FishGameBubble:hide()
    cc.Node.hide(self)
    self._nodeLockFish:hide()
end

function FishGameBubble:reset()
    self:removeAllChildren()
    self._main = nil
    self._list = {}
end

function FishGameBubble:updateLockedFish(fish)
    local typeId = fish:getTypeId()
    if self._typeId == typeId then return end
    self._typeId = typeId

    if not tolua.isnull(self._visualNode) then
        self._visualNode:removeSelf()
    end

    local visualNode = display.newNode():addTo(self._nodeLockFish, -1)

    local fishConfig = Fishes[typeId]
    local visualConfig = Visual[fishConfig.visualId]
    local width, height = 0, 0
    for _, v in ipairs(visualConfig.live) do
        local t_animation = ccs.Armature:create(v.image)
        t_animation:setScale(v.scale)
        t_animation:getAnimation():play(v.name)
        t_animation:move(v.offset[1], v.offset[2])
        t_animation:addTo(visualNode)

        width = math.max(width, math.abs(v.offset[1]) + t_animation:getContentSize().width / 2)
        height = math.max(height, math.abs(v.offset[2]) + t_animation:getContentSize().height / 2)
    end
    visualNode:setScale(math.min(1, math.min(100 / width, 100 / height)))

    self._visualNode = visualNode
end

return FishGameBubble