local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local AccountBindTipLayer = class("AccountBindTipLayer", CustomBaseView)

function AccountBindTipLayer:ctor(confirmCallback)
    self.confirmCallback = confirmCallback
    local CCSLuaNode =  requireForGameLuaFile("AccountBindTipLayerCCS")
    self.csNode = CCSLuaNode:create().root;
    self:addChild(self.csNode);
    self.alertView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alert_view"), "ccui.Widget");
    local cancelBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "canel_btn"), "ccui.Button");
    cancelBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
        self:closeView();
    end);

    local confirmBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "bind_btn"), "ccui.Button");
    confirmBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch);
        self:closeView();
        if confirmCallback ~= nil then
            confirmCallback();
        end
    end);
    AccountBindTipLayer.super.ctor(self)
    CustomHelper.addAlertAppearAnim(self.alertView)
    self:initTipData()
end

function AccountBindTipLayer:initTipData()
    local playerInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
    --�Ƿ����֧����
    local checkBox = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "CheckBox_alipay"), "ccui.CheckBox")
    if checkBox then
        checkBox:setSelected(playerInfo:getIsBindAlipay())
    end
    --�Ƿ�Ϊע���û�
    checkBox = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "CheckBox_phone"), "ccui.CheckBox")
    if checkBox then
        checkBox:setSelected(not playerInfo:getIsGuest())
    end
end

function AccountBindTipLayer:closeView()
    CustomHelper.addCloseAnimForAlertView(self.alertView,
        function()
            self:removeSelf();
        end)
end

return AccountBindTipLayer;