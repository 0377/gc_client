local FishGameRuleLayer = class("FishGameRuleLayer", function()
    return display.newLayer()
end)

local Config_btns = {
    "rule_btn_normal",
    "rule_btn_big",
    "rule_btn_boss",
    "rule_btn_special",
}

function FishGameRuleLayer:ctor()
    self:setContentSize(display.width, display.height)
    self:setTouchEnabled(true)
    self:setSwallowsTouches(true)
    self:registerScriptTouchHandler(handler(self, self._onTouched_TTTTT))
    CustomHelper.addWholeScrennAnim(self)

    self._mainWnd = requireForGameLuaFile("FishGameRuleCCS"):create().root:addTo(self)

    self._pnlRuleWnd = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "RuleView"), "ccui.Layout")

    local pageview = CustomHelper.seekNodeByName(self._pnlRuleWnd, "PageView_1")
    pageview:addEventListener(handler(self, self.onPageviewEvent))
    self._pageview = pageview

    local btn_close = CustomHelper.seekNodeByName(self._pnlRuleWnd, "rule_btn_close")
    btn_close:addTouchEventListener(handler(self, self.onBtnRuleClose))

    for k, v in ipairs(Config_btns) do
        local btn = CustomHelper.seekNodeByName(self._pnlRuleWnd, v)
        btn:addTouchEventListener(function(sender, eventType)
            if eventType == ccui.TouchEventType.began then
            elseif eventType == ccui.TouchEventType.ended then
                GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
                self._pageview:scrollToPage(k - 1)
                self:updateSelectedTab(k)
            end
        end)
    end

    self:updateSelectedTab(1)
end

function FishGameRuleLayer:_onTouched_TTTTT(eventType, x, y)
    if eventType == "began" then
        return true
    elseif eventType == "ended" then
        self:removeSelf()
    end
end

function FishGameRuleLayer:onBtnRuleClose(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);

        self:removeSelf()
    end
end

function FishGameRuleLayer:onPageviewEvent(sender, ...)
    local index = sender:getCurrentPageIndex() + 1

    self:updateSelectedTab(index > #Config_btns and #Config_btns or index)
end

function FishGameRuleLayer:updateSelectedTab(index)
    for k, v in ipairs(Config_btns) do
        local btn = CustomHelper.seekNodeByName(self._pnlRuleWnd, v)
        if k == index then
            btn:setEnabled(false)
        else
            btn:setEnabled(true)
        end
    end
end

return FishGameRuleLayer