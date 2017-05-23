local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local MessageTipLayer = class("MessageTipLayer",CustomBaseView)

function MessageTipLayer:ctor()
    local CCSLuaNode =  requireForGameLuaFile("MessageTipLayerCCS")
    self.csNode = CCSLuaNode:create().root:addTo(self)
    local background = self.csNode:getChildByName("background")
    CustomHelper.addAlertAppearAnim(background)


    local btn_service = background:getChildByName("btn_service")
    local btn_confirm = background:getChildByName("btn_confirm")
    local btn_close = background:getChildByName("btn_close")
    local label_tip = background:getChildByName("label_tip")
    label_tip:setVisible(false)
    btn_service:addClickEventListener(handler(self,self._onBtnClicked_service))
    btn_confirm:addClickEventListener(handler(self,self._onBtnClicked_confirm))
    btn_close:addClickEventListener(handler(self,self._onBtnClicked_close))

    self.background = background
    self.btn_service = btn_service
    self.btn_confirm = btn_confirm
    self.btn_close = btn_close
    self.label_tip = label_tip
    MessageTipLayer.super.ctor(self)
end

function MessageTipLayer:_onBtnClicked_service(sender) end

function MessageTipLayer:_onBtnClicked_confirm(sender)
    self:removeSelf()
end

function MessageTipLayer:_onBtnClicked_close(sender)
    self:removeSelf()
end

function MessageTipLayer:updateWithMessage(message)
    if not tolua.isnull(self._label_tip) then
        self._label_tip:removeSelf()
    end
    local playInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
    local messageInfo = playInfo:getMessageInfo()

    local text = messageInfo:parseMessageDetailTip(message)
    local lableTip = myLua.LuaBridgeUtils:createHLCustomRichTextWithNode(text,self.label_tip)
    lableTip:setTextHorizontalAlign(1)
    lableTip:setTextVerticalAlign(1);
    lableTip:setVisible(true)
    lableTip:addTo(self.background)
    self._label_tip = lableTip

    -- if  not message.Readed then 
    --     local msgMng = GameManager:getInstance():getHallManager():getHallMsgManager()
    --     message.Readed = true
    --     msgMng:sendSetMsgReadFlag(message)
    -- end

end

function MessageTipLayer:createWithMessage(...)
    local node = self:create(...)
    node:updateWithMessage(...)
    node:addTo(cc.Director:getInstance():getRunningScene(),1000)
    return node
end

return MessageTipLayer;
