
local DdzDismissView = class("DdzDismissView", cc.Node)

local str = "<font size='25' face='' color='#fe000000'>%s</font><font size='25' face='' color='#ffffff'>发起</font><font size='25' face='' color='#fe0000'>解散房间</font><font size='25' face='' color='#ffffff'>投票</font>"

function DdzDismissView:ctor()    
    self:_initData()
	self:_initView()
	self:showListView()

    if GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getVoteOriginator() <= 0 then
        DdzGameManager:getInstance():sendVote(true)
    end
end

function DdzDismissView:_initData()
    self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
end

function DdzDismissView:_initView()
	local CCSLuaNode =  requireForGameLuaFile("ddzGameDismissLayerCCS")
    self.csNode = CCSLuaNode:create().root
    self:addChild(self.csNode)

    local alertPanel = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "panel_info"), "ccui.Widget")
    CustomHelper.addAlertAppearAnim(alertPanel)

    local text = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Text_Prompt"), "ccui.Text")
    local HtmlText = requireForGameLuaFile("ui/HtmlText")
    self._createPayText = HtmlText.new({lineWidth = 500, fontSize = 25})
    -- self._createPayText:setString(string.format(str, "Shanks"))
    -- self._createPayText:setPosition(cc.p(text:getPositionX() - self._createPayText:getContentSize().width * 0.5, 
    --     text:getPositionY() - self._createPayText:getContentSize().height * 0.5))
    text:getParent():addChild(self._createPayText)

    -- close btn
    local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_close"), "ccui.Button")
    closeBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        self:removeSelf()
    end)

    -- agree btn
    local agreeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_Agree"), "ccui.Button")
    agreeBtn:addClickEventListener(function()
    	print("[DdzDismissView] click agree")
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        DdzGameManager:getInstance():sendVote(true)
    end)
    self._agreeBtn = agreeBtn

    -- refuse btn
    local refuseBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_Refuse"), "ccui.Button")
    refuseBtn:addClickEventListener(function()
    	print("[DdzDismissView] click refuse")
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        DdzGameManager:getInstance():sendVote(false) 
    end)
    self._refuseBtn = refuseBtn

    self._listView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "ListView_Dismiss"), "ccui.ListView")
end

function DdzDismissView:showListView()
    self._listView:removeAllItems()

    local data = clone(GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getChairs())

    -- print("[DdzDismissView] showListView")
    -- dump(data)

    local item = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "ListView_Item"), "ccui.Widget")
    item:setVisible(false)
    self._listView:setItemModel(item)

    for i = 1, table.getn(data) do
        self._listView:pushBackDefaultItem()

        local item = self._listView:getItem(i - 1)
        item:setVisible(true)

        local itemData = data[i]

        item:getChildByName("Text_Item_Name"):setString(itemData:getNickName())

        if i == GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getVoteOriginator() then
            self._createPayText:setString(string.format(str, itemData:getNickName()))
            local text = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Text_Prompt"), "ccui.Text")
            self._createPayText:setPosition(cc.p(text:getPositionX() - self._createPayText:getContentSize().width * 0.5, 
                text:getPositionY() - self._createPayText:getContentSize().height * 0.5))
        end

        -- head
        local headParentView = item:getChildByName("Image_Head")

        self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
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

        -- agree or refuse icon
        local itemIcon = item:getChildByName("Image_Select_Icon")
        if itemData["vote"] == nil then
            itemIcon:loadTexture("game_res/ddz_transparent.png")
        else    
            if itemData["vote"] then
                itemIcon:loadTexture("game_res/ddz_tongyi.png")
            else
                itemIcon:loadTexture("game_res/ddz_jujue.png")
            end

            if (itemData:getGuid() == self.myPlayerInfo:getGuid()) then
                self._agreeBtn:setVisible(false)
                self._refuseBtn:setVisible(false)
            end
        end
    end
end

return DdzDismissView