
local DdzPropertyView = class("DdzPropertyView", cc.Node)

local ROW_ITEM_NUMBER = 2

local baseData = 
{
    [1] = {["key"] = "nallowDouble", ["desc"] = "允许加倍", ["status"] = false},
    [2] = {["key"] = "nlimitbeishu", ["desc"] = "限制最高倍数32倍", ["status"] = false},
    [3] = {["key"] = "nallowYiXiaoBoda", ["desc"] = "允许以小博大", ["status"] = false}
}

function DdzPropertyView:ctor(callBack)
    self._callBack = callBack

    self:_initData()
	self:_initView()
    self:_requestGetProperty()
end

function DdzPropertyView:_initData()
    self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
    self._data = {}
    self._data.serverProperty = {}
end

function DdzPropertyView:_initView()
	local CCSLuaNode =  requireForGameLuaFile("ddzGamePropertyLayerCCS")
    self.csNode = CCSLuaNode:create().root
    self:addChild(self.csNode)

    local alertPanel = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "panel_info"), "ccui.Widget")
    CustomHelper.addAlertAppearAnim(alertPanel)

    -- title
    local title = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Image_Title"), "ccui.ImageView")
    if GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateOwner(self.myPlayerInfo:getGuid()) then
        title:loadTexture("game_res/ddz_fangjianshuxingzi_1.png")
    else
        title:loadTexture("game_res/ddz_fangjianshuxingzi.png")
    end

    -- close btn
    local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_close"), "ccui.Button")
    closeBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        self:removeSelf()
    end)

    -- confirm btn
    local confirmBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_Confirm"), "ccui.Button")
    confirmBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        if self:_judgeNeedSet() then
            self:_requestSetProperty()
        end

        if self._callBack then
            self._callBack()
        end

        self:removeSelf()
    end)

    self._listView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "ListView_Property"), "ccui.ListView")
end

function DdzPropertyView:_requestGetProperty()
    DdzGameManager:getInstance():sendGetPrivateConfig()
end

function DdzPropertyView:_requestSetProperty()
    local msgTab = {}
    for _, v in ipairs(baseData) do
        local key = v["key"]
        msgTab[key] = self:_getStatusInt(v["status"])
    end
    DdzGameManager:getInstance():sendSetPrivateConfig(msgTab)
end

function DdzPropertyView:showListView(sp)
    self._listView:removeAllItems()

    self._data.serverProperty = sp
    print("[DdzPropertyView] showListView")
    dump(self._data.serverProperty)

    local item = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "ListView_Item"), "ccui.Widget")
    item:setVisible(false)
    item:getChildByName("Image_Item_1"):setVisible(false)
    item:getChildByName("Image_Item_2"):setVisible(false)
    self._listView:setItemModel(item)

    local rowNum = math.ceil(table.getn(baseData) / ROW_ITEM_NUMBER)
    for i = 1, rowNum do
        self._listView:pushBackDefaultItem()

        local item = self._listView:getItem(i - 1)
        item:setVisible(true)

        for j = 1, ROW_ITEM_NUMBER do
            local index = (i - 1) * ROW_ITEM_NUMBER + j
            if (index > table.getn(baseData)) then
                break
            end

            local itemData = baseData[index]
            item:getChildByName(string.format("Image_Item_%d", j)):setVisible(true)
            item:getChildByName(string.format("Image_Item_%d", j)):getChildByName("Text_Item_Desc"):setString(itemData["desc"])

            local function selectedEvent(sender,eventType)
            if eventType == ccui.CheckBoxEventType.selected then
                    GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
                    baseData[index]["status"] = true
                elseif eventType == ccui.CheckBoxEventType.unselected then
                	GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
                    baseData[index]["status"] = false
                end
            end  
                
            local checkBox = item:getChildByName(string.format("Image_Item_%d", j)):getChildByName("CheckBox_Item")
            checkBox:setTouchEnabled(GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():getIsPrivateOwner(self.myPlayerInfo:getGuid()))
            checkBox:setSelected(self:_getStatusBool(itemData["key"]))
            baseData[index]["status"] = self:_getStatusBool(itemData["key"])
            checkBox:addEventListener(selectedEvent)  
        end
    end
end

-- 服务器要求：1，false; 2, true
function DdzPropertyView:_getStatusBool(key)
    return (self._data.serverProperty[key] ~= 1)
end

function DdzPropertyView:_getStatusInt(status)
    if status then
        return 2
    else
        return 1
    end
end

function DdzPropertyView:_judgeNeedSet()
    for _, v in ipairs(baseData) do
        local key = v["key"]
        if v["status"] ~= self:_getStatusBool(key) then
            return true
        end
    end
    return false
end

return DdzPropertyView