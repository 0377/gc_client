
local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local PrivateRoomModel = requireForGameLuaFile("PrivateRoomModel")

local PrivateRoomSwitch = class("PrivateRoomSwitch", CustomBaseView)

local ROW_ITEM_NUMBER = 3

function PrivateRoomSwitch:ctor()
    PrivateRoomSwitch.super.ctor(self)
    
    self:_initData()
	self:_initView()
    self:_initListView()
end

function PrivateRoomSwitch:registerNotification()
	
end

function PrivateRoomSwitch:receiveServerResponseSuccessEvent(event)
    
end

function PrivateRoomSwitch:_initData()
    self._data = {}

    local data = PrivateRoomModel:getInstance():getInfo()
    for i, v in ipairs(data) do
        if v["first_game_type"] == PrivateRoomModel:getInstance():getSelectedGtype() then
            self._data.index = i
            self._data.selectedGtype = v["first_game_type"]
        end
    end    
end

function PrivateRoomSwitch:_initView()
	local CCSLuaNode =  requireForGameLuaFile("PrivateRoomSwitchCCS")
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

        PrivateRoomModel:getInstance():setSelectedGtype(self._data.selectedGtype)

        local event = cc.EventCustom:new("PrivateRoom_SwitchGame")
        cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)

        self:removeSelf()
    end)

    self._listView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "ListView_Game"), "ccui.ListView")
end

function PrivateRoomSwitch:_initListView()
    local CheckBoxGroup = requireForGameLuaFile("ui/CheckBoxGroup")
    self._checkBoxGroup = CheckBoxGroup:create()

    local data = PrivateRoomModel:getInstance():getInfo()

    local item = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "ListView_Item"), "ccui.Widget")
    item:setVisible(false)
    self._listView:setItemModel(item)

    local rowNum = math.ceil(table.getn(data) / ROW_ITEM_NUMBER)
    for i = 1, rowNum do
        -- print("[PrivateRoomSwitch] i:%d", i)
        self._listView:pushBackDefaultItem()

        local item = self._listView:getItem(i - 1)
        item:setVisible(true)

        for j = 1, ROW_ITEM_NUMBER do
            local index = (i - 1) * ROW_ITEM_NUMBER + j
            if (index > table.getn(data)) then
                break
            end

            local itemData = data[index]
            item:getChildByName(string.format("CheckBox_Item_%d", j)):setVisible(true)
            item:getChildByName(string.format("CheckBox_Item_%d", j)):getChildByName("Image_Icon"):ignoreContentAdaptWithSize(true)
            item:getChildByName(string.format("CheckBox_Item_%d", j)):getChildByName("Image_Icon"):loadTexture(CustomHelper.getFullPath(PrivateRoomModel:getInstance():getImgByGtype(itemData["first_game_type"])))
            item:getChildByName(string.format("CheckBox_Item_%d", j)):getChildByName("Image_Icon"):ignoreContentAdaptWithSize(true)

            local function selectedEvent(sender,eventType)
            if eventType == ccui.CheckBoxEventType.selected then
                    GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)

                    self._data.index = index
                    self._checkBoxGroup:setSelectedIndex(self._data.index)
                    self._data.selectedGtype = itemData["first_game_type"]
                elseif eventType == ccui.CheckBoxEventType.unselected then

                end
            end  
                
            local checkBox = item:getChildByName(string.format("CheckBox_Item_%d", j))
            checkBox:addEventListener(selectedEvent)  

            self._checkBoxGroup:addCheckBox(checkBox)
        end
    end

    self._checkBoxGroup:setSelectedIndex(self._data.index)
end

return PrivateRoomSwitch