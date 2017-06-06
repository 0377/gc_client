local FishGameRuleLayer = class("FishGameRuleLayer", function()
    return display.newLayer()
end)

function FishGameRuleLayer:ctor()
    self:setTouchEnabled(true)
    CustomHelper.addWholeScrennAnim(self)


    self._mainWnd = requireForGameLuaFile("FishGameRuleCCS"):create().root:addTo(self)


    self._pnlRuleWnd = tolua.cast(CustomHelper.seekNodeByName(self._mainWnd, "RuleView"), "ccui.Layout")


    self._btnClose = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "rule_btn_close"), "ccui.Button")
    self._btnClose:addTouchEventListener(handler(self, self.onBtnRuleClose))

    self._btnNormal = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "rule_btn_normal"), "ccui.Button")
    self._btnNormal:addTouchEventListener(handler(self, self.onBtnRuleNormal))

    self._btnBigFish = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "rule_btn_big"), "ccui.Button")
    self._btnBigFish:addTouchEventListener(handler(self, self.onBtnRuleBigFish))

    self._btnSpecial = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "rule_btn_special"), "ccui.Button")
    self._btnSpecial:addTouchEventListener(handler(self, self.onBtnRuleSpecial))

    self._btnBoss = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "rule_btn_boss"), "ccui.Button")
    self._btnBoss:addTouchEventListener(handler(self, self.onBtnRuleBoss))

    self._pnlNormal = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "panel_normal"), "ccui.Layout")

    self._pnlBigFish = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "panel_bigfish"), "ccui.Layout")

    self._pnlSpecial = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "panel_special"), "ccui.Layout")

    self._pnlBoss = tolua.cast(CustomHelper.seekNodeByName(self._pnlRuleWnd, "panel_boss"), "ccui.Layout")

    self:dealRuleSelect(FishGameConfig.RULE_SELECT.NORMAL)
end

function FishGameRuleLayer:onBtnRuleClose(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);

        self:removeSelf()
    end
end

function FishGameRuleLayer:onBtnRuleNormal(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);

        self:dealRuleSelect(FishGameConfig.RULE_SELECT.NORMAL)
    end
end

function FishGameRuleLayer:onBtnRuleBigFish(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);

        self:dealRuleSelect(FishGameConfig.RULE_SELECT.BIGFISH)
    end
end

function FishGameRuleLayer:onBtnRuleSpecial(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);

        self:dealRuleSelect(FishGameConfig.RULE_SELECT.SPECIAL)
    end
end

function FishGameRuleLayer:onBtnRuleBoss(sender, eventType)
    if eventType == ccui.TouchEventType.began then
    elseif eventType == ccui.TouchEventType.ended then
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);

        self:dealRuleSelect(FishGameConfig.RULE_SELECT.BOSS)
    end
end


function FishGameRuleLayer:dealRuleSelect(sel)
    self._ruleWndSelect = sel
    if sel == FishGameConfig.RULE_SELECT.NORMAL then

        self._btnNormal:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_N)
        self._btnBigFish:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)
        self._btnBoss:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)
        self._btnSpecial:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)

        self._pnlNormal:setVisible(true)
        self._pnlBigFish:setVisible(false)
        self._pnlBoss:setVisible(false)
        self._pnlSpecial:setVisible(false)

    elseif sel == FishGameConfig.RULE_SELECT.BIGFISH then

        self._btnNormal:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)
        self._btnBigFish:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_N)
        self._btnBoss:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)
        self._btnSpecial:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)

        self._pnlNormal:setVisible(false)
        self._pnlBigFish:setVisible(true)
        self._pnlBoss:setVisible(false)
        self._pnlSpecial:setVisible(false)

    elseif sel == FishGameConfig.RULE_SELECT.SPECIAL then

        self._btnNormal:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)
        self._btnBigFish:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)
        self._btnBoss:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)
        self._btnSpecial:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_N)

        self._pnlNormal:setVisible(false)
        self._pnlBigFish:setVisible(false)
        self._pnlBoss:setVisible(false)
        self._pnlSpecial:setVisible(true)

    elseif sel == FishGameConfig.RULE_SELECT.BOSS then

        self._btnNormal:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)
        self._btnBigFish:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)
        self._btnBoss:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_N)
        self._btnSpecial:loadTextureNormal(FishGameConfig.BTN_IMG.RULE_P)

        self._pnlNormal:setVisible(false)
        self._pnlBigFish:setVisible(false)
        self._pnlBoss:setVisible(true)
        self._pnlSpecial:setVisible(false)
    end
end

return FishGameRuleLayer