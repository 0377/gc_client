
local DdzReadyView = class("DdzReadyView", cc.Node)

function DdzReadyView:ctor()    
    self:_initData()
	self:_initView()
    self:showListView()
end

function DdzReadyView:_initData()
    self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
end

function DdzReadyView:_initView()
    local CCSLuaNode =  requireForGameLuaFile("ddzGameReadyLayerCCS")
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

    -- ready btn
    local readyBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_Ready"), "ccui.Button")
    readyBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        DdzGameManager:getInstance():sendGameReady()
    end)
    self._readyBtn = readyBtn

    self._listView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "ListView_Player"), "ccui.ListView")
end

function DdzReadyView:showListView()
    self._listView:removeAllItems()

    dump(GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getChairs())

    local tmpData = clone(GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getChairs())
    local data = {}
    for k, v in pairs(tmpData) do
        table.insert(data, v)
    end

    local item = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "ListView_Item"), "ccui.Widget")
    item:setVisible(false)
    self._listView:setItemModel(item)

    for i = 1, table.getn(data) do
        self._listView:pushBackDefaultItem()

        local item = self._listView:getItem(i - 1)
        item:setVisible(true)

        local itemData = data[i]

        -- item:getChildByName("Text_Name"):setString(itemData["name"])
        -- player:getGameState() == gameDdz.SUB_S_GAME_CONCLUDE
        -- gameDdz.US_READY
        dump(itemData:getGameState())

        item:getChildByName("Text_Name"):setString(itemData:getNickName())

        -- kick btn
        local kickBtn = item:getChildByName("Button_Kick")
        kickBtn:setVisible(GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateOwner(self.myPlayerInfo:getGuid()))
        if GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateOwner(itemData:getGuid()) then
            kickBtn:setVisible(false)
        end
        kickBtn:addClickEventListener(function()
            GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)

            CustomHelper.showAlertView(
                    string.format("您确定要将“%s”踢出房间吗？", itemData:getNickName()),
                    false,
                    true,
                function(tipLayer)
                    tipLayer:removeSelf()
                end,
                function(tipLayer)
                    DdzGameManager:getInstance():sendKickPlayer(itemData:getChairId())

                    tipLayer:removeSelf()
                end)
        end)

        -- head
        local headParentView = item:getChildByName("Image_Head")

        local headSpr = nil
        if (itemData:getGuid() ~= self.myPlayerInfo:getGuid()) then
            headSpr = cc.Sprite:create(self.myPlayerInfo:getSquareHeadIconPathByIconNum(itemData:getHeadIconNum()))
        else
            headSpr = cc.Sprite:create(self.myPlayerInfo:getSquareHeadIconPath())
        end
        headSpr:setScale(headParentView:getContentSize().width/headSpr:getContentSize().width)
        --将正方形头像截取圆角
        local clipperNode = cc.ClippingNode:create()
        clipperNode:setStencil(cc.Sprite:create(CustomHelper.getFullPath("hall_res/setting/bb_grxx_txk.png")))
        --clipperNode:setAlphaThreshold(0.0)
        clipperNode:setScale(0.93)
        clipperNode:addChild(headSpr)
        clipperNode:setName(headNodeName)
        headParentView:addChild(clipperNode)
        clipperNode:setPosition(cc.p(clipperNode:getParent():getContentSize().width/2, clipperNode:getParent():getContentSize().height/2))

        -- ower icon
        local owerIcon = item:getChildByName("Image_Owner_Icon")
        owerIcon:setVisible(GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateOwner(itemData:getGuid()))

        -- ready icon
        local readyIcon = item:getChildByName("Image_Ready_Icon")
        readyIcon:setVisible((itemData["playerInfoTab"]["is_ready"] ~= nil and itemData["playerInfoTab"]["is_ready"]))

        if (itemData:getGuid() == self.myPlayerInfo:getGuid()) then
            self._readyBtn:setVisible(not (itemData["playerInfoTab"]["is_ready"] ~= nil and itemData["playerInfoTab"]["is_ready"]))
        end
    end
end

return DdzReadyView