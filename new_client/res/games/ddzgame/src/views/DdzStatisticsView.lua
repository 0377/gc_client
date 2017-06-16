
local DdzStatisticsView = class("DdzStatisticsView", cc.Node)

function DdzStatisticsView:ctor(scene, data)    
    self._scene = scene

    self:_initData(data)
	self:_initView()
	self:_initListView()
end

function DdzStatisticsView:_initData(data)
    self._data = {}
    self._data.statisticsData = data
end

function DdzStatisticsView:_initView()
	local CCSLuaNode =  requireForGameLuaFile("ddzGameStatisticsLayerCCS")
    self.csNode = CCSLuaNode:create().root
    self:addChild(self.csNode)

    local alertPanel = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "panel_info"), "ccui.Widget")
    CustomHelper.addAlertAppearAnim(alertPanel)

    -- -- close btn
    -- local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_close"), "ccui.Button")
    -- closeBtn:addClickEventListener(function()
    --     GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    --     self:removeSelf()
    -- end)

    -- confirm btn
    local confirmBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_Confirm"), "ccui.Button")
    confirmBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)

        if self._scene then
            self._scene:jumpToHallScene()
        end

        self:removeSelf()
    end)

    self._listView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "ListView_Statistics"), "ccui.ListView")
end

function DdzStatisticsView:_initListView()
    local data = self._data.statisticsData["totoalscore"]
    local chairs = clone(GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getChairs())

    local item = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "ListView_Item"), "ccui.Widget")
    item:setVisible(false)
    self._listView:setItemModel(item)

    for i = 1, table.getn(data) do
        if (chairs[i]) then
            self._listView:pushBackDefaultItem()

            local item = self._listView:getItem(i - 1)
            item:setVisible(true)

            local itemData = data[i]
        
            item:getChildByName("Text_Item_Name"):setString(chairs[i]:getNickName())

            if (itemData >= 0) then
            	-- item:getChildByName("Text_Item_Win"):setColor(cc.c3b(0x1e, 0xff, 0x00))
            	item:getChildByName("Text_Item_Win"):setString(string.format("+%s", CustomHelper.moneyShowStyleNone(itemData)))
            else
            	-- item:getChildByName("Text_Item_Lose"):setColor(cc.c3b(0xe2, 0x0b, 0x13))
            	item:getChildByName("Text_Item_Lose"):setString(string.format("%s", CustomHelper.moneyShowStyleNone(itemData)))
            end
        end
    end
end

return DdzStatisticsView