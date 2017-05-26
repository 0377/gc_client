
local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local HallGameNode = requireForGameLuaFile("HallGameNode")
local PrivateRoomModel = requireForGameLuaFile("PrivateRoomModel")

local PrivateRoomUpdate = class("PrivateRoomUpdate", CustomBaseView)

function PrivateRoomUpdate:ctor(callback)
    PrivateRoomUpdate.super.ctor(self)
    
    self._downloadCompleteCallback = callback

    self:_initData()
	self:_initView()
end

function PrivateRoomUpdate:registerNotification()
	
end

function PrivateRoomUpdate:receiveServerResponseSuccessEvent(event)
    
end

function PrivateRoomUpdate:_initData()
    self._data = {}  
end

function PrivateRoomUpdate:_initView()
	local CCSLuaNode =  requireForGameLuaFile("PrivateRoomUpdateCCS")
    self.csNode = CCSLuaNode:create().root
    self:addChild(self.csNode)

    local alertPanel = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alert_panel"), "ccui.Widget")
    CustomHelper.addAlertAppearAnim(alertPanel)

    local tmpGameNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "defaultGameItem"), "ccui.Layout")
    tmpGameNode:setVisible(false)

    --游戏开放列表
    local openGameTab = GameManager:getInstance():getHallManager():getHallDataManager():getAllOpenGamesDeatilTab()
    local gameType = PrivateRoomModel:getInstance():getSelectedGtype()

    local gameNode = tmpGameNode:clone()
    gameNode:setVisible(true)
    local itemNode = HallGameNode:create(gameNode, openGameTab[gameType])
    itemNode:setVisible(true)
    itemNode:setSwallowTouches(false)
    itemNode:setPosition(cc.p(420, 180))
    alertPanel:addChild(itemNode)

    itemNode.selectBtn:addTouchEventListener(
        function(sender,event)
            if event == ccui.TouchEventType.ended then
                itemNode:touchGameNode()
            end
        end
    )

    itemNode:setDownloadCompleteCallback(function ()
        if self._downloadCompleteCallback then
            self._downloadCompleteCallback()
        end

        self:removeSelf()
    end)

    -- 默认开始下载
    itemNode:touchGameNode()
end

return PrivateRoomUpdate