
local CustomBaseView = requireForGameLuaFile("CustomBaseView")

local PrivateRoomHelp = class("PrivateRoomHelp", CustomBaseView)

function PrivateRoomHelp:ctor()
    PrivateRoomHelp.super.ctor(self)
    
	self:_initView()
end

function PrivateRoomHelp:_initView()
	local CCSLuaNode =  requireForGameLuaFile("PrivateRoomHelpCCS")
    self.csNode = CCSLuaNode:create().root
    self:addChild(self.csNode)

    local alertPanel = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alert_panel"), "ccui.Widget")
    CustomHelper.addAlertAppearAnim(alertPanel)

 	-- close btn
    local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_Close"), "ccui.Button")
    closeBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        self:removeSelf()
    end)

    -- confirm btn
    local confirmBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_Confirm"), "ccui.Button")
    confirmBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        self:removeSelf()
    end)
end

return PrivateRoomHelp