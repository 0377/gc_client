local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local CustomServiceLayer = class("CustomServiceLayer", CustomBaseView);

function CustomServiceLayer:ctor()
    CustomServiceLayer.super.ctor(self)

    self:onCreateContent()
end

function CustomServiceLayer:onCreateContent()
    local CCSLuaNode =  requireForGameLuaFile("CustomServiceLayerCCS")
    self.csNode = CCSLuaNode:create().root;
    self:addChild(self.csNode)


    local background = self.csNode:getChildByName("background")
    background:setTouchEnabled(true)
    self.background = background
    local btn_close = background:getChildByName("btn_close")
    btn_close:addClickEventListener(handler(self, self._onBtnClicked_close))

    local bg_content = background:getChildByName("bg_content")
    local customServiceURL = CustomHelper.getOneHallGameConfigValueWithKey("custom_service_url")
    if ccexp.WebView then
        local webview = ccexp.WebView:create()
        webview:setScalesPageToFit(true)
        webview:loadURL(customServiceURL)
        webview:setContentSize(cc.size(bg_content:getContentSize().width - 20,
            bg_content:getContentSize().height - 20))
        webview:reload()
        webview:align(display.CENTER, bg_content:getContentSize().width / 2,
            bg_content:getContentSize().height / 2):addTo(bg_content)
    else
        local labelTemp = cc.Label:create()
        labelTemp:setString("请在真机上测试。。。")
        labelTemp:setSystemFontSize(36)
        labelTemp:align(display.CENTER, bg_content:getContentSize().width / 2, bg_content:getContentSize().height / 2):addTo(bg_content)
    end
end

function CustomServiceLayer:onEnter()
    CustomHelper.addAlertAppearAnim(self.background);
end

function CustomServiceLayer:_onBtnClicked_close(sender, eventType)
    GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    self:removeSelf()
end

return CustomServiceLayer
