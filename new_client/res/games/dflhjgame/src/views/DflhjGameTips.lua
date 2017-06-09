DflhjGameTips = class("DflhjGameTips", function()
    return display.newLayer()
end)

function DflhjGameTips:ctor()
    local CCSLuaNode =  requireForGameLuaFile("DflhjGameTipsCCS")
    self.csNode = CCSLuaNode:create().root;
    self:addChild(self.csNode);
    
    self.pageView= tolua.cast(CustomHelper.seekNodeByName(self.csNode,"pageView"), "ccui.ListView")
    local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_close"), "ccui.Button")
    closeBtn:addClickEventListener(function (  )
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        self:removeFromParent()
    end)
end
return DflhjGameTips

