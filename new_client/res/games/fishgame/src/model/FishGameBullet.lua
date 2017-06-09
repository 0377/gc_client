

local FishGameBullet = class("FishGameBullet", function()
    return game.fishgame2d.Bullet:create()
end)

function FishGameBullet:ctor(data,player,parent)
    self:registerStatusChangedHandler(handler(self,self.onStateUpdated))
    self._player = player
    self._parent = parent


    local dataMng = GameManager:getInstance():getHallManager():getSubGameManager():getDataManager()

    local conf = dataMng:getBulletConfig(data.multiply)

    self:setId(data.id)
    self:setPosition(data.x_pos,data.y_pos)
    self:setCatchRadio(conf and conf.catch_radio or 30)
    self._isMine = dataMng:getMyChairId() == data.chair_id

    -- 路径
    local moveCompent = game.fishgame2d.MoveByDirection:create()
    moveCompent:setRebound(true)
    moveCompent:setSpeed(conf and conf.speed or 600)
    moveCompent:setPosition(data.x_pos,data.y_pos)
    moveCompent:setDirection(data.direction)

    self:setMoveCompent(moveCompent)


    local serverTime = GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getServerTime()
    self:onUpdate((serverTime - data.server_tick) / 1000,true)
    self:setState(EOS_LIVE)
end

function FishGameBullet:isMine()
    return self._isMine
end


function FishGameBullet:onStateUpdated(state)
    self:removeAllChildren()

    if state == EOS_LIVE then
        local cannonSet = self._player:getCannonSet()
        local cannonType = self._player:getCannonType()
        local cannonSet = FishGameXMLConfigManager:getInstance()._cannonSetVector[cannonSet]
        local cannon = cannonSet.Sets[cannonType]

        local t_animation = ccs.Armature:create(cannon.BulletSet.szResourceName)
        t_animation:getAnimation():play(cannon.BulletSet.Name)
        self._parent:addChild(t_animation)

        self:setVisualContent(t_animation)
    elseif state == EOS_DEAD then
        local cannonSet = self._player:getCannonSet()
        local cannonType = self._player:getCannonType()
        local cannonSet = FishGameXMLConfigManager:getInstance()._cannonSetVector[cannonSet]
        local cannon = cannonSet.Sets[cannonType]

        local t_animation = ccs.Armature:create( cannon.NetSet.szResourceName )
        t_animation:getAnimation():play(cannon.NetSet.Name )
        self._parent:addChild(t_animation)

        t_animation:getAnimation():setMovementEventCallFunc(function(sender, type, id)
            if type == ccs.MovementEventType.start then
            elseif type == ccs.MovementEventType.complete then
                sender:setVisible(false)
--                self:setState(EOS_DESTORED)
            end
        end)

        self:setVisualContent(t_animation)
    elseif state == EOS_DESTORED then
--        self:removeSelf()
    end
end

function FishGameBullet:addTo(parent)
    self._parent = parent

    return self
end

return FishGameBullet
