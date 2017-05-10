LhjGameTips = class("LhjGameTips", function()
    return display.newLayer()
end)

function LhjGameTips:ctor()

    local csNodePath = CustomHelper.getFullPath("LhjGameTips.csb")
    self._uiLayer = cc.CSLoader:createNode(csNodePath)
    self:addChild(self._uiLayer)


    self.pageView= tolua.cast(CustomHelper.seekNodeByName(self._uiLayer,"pageView"), "ccui.ListView")
    local page = ccui.ImageView:create("game_res/wz_yxgz_2.png")
     self.pageView:addChild(page)
    local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self._uiLayer, "btn_close"), "ccui.Button")
    closeBtn:addClickEventListener(function (  )
        -- body
         self:removeFromParent()
    end)
end
return LhjGameTips

