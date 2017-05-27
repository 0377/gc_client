
local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local PrivateRoomHelp = requireForGameLuaFile("privateroom/PrivateRoomHelp")
local PrivateRoomSwitch = requireForGameLuaFile("privateroom/PrivateRoomSwitch")
local PrivateRoomPrompt = requireForGameLuaFile("privateroom/PrivateRoomPrompt")
local PrivateRoomUpdate = requireForGameLuaFile("privateroom/PrivateRoomUpdate")
local PrivateRoomModel = requireForGameLuaFile("PrivateRoomModel")
local HtmlText = requireForGameLuaFile("ui/HtmlText")

local PrivateRoomView = class("PrivateRoomView", CustomBaseView)

local InfoType = 
    {
        ["NONE"] = 0,
        ["WATCH_GAME"] = 1,
        ["PLAYER_NUM"] = 2,
        ["BET_MIN"]   = 3
    }

local payStr = "<font size='33' face='' color='#ff000000'>%s</font><font size='33' face='' color='#ffffff'>金</font>"

function PrivateRoomView:ctor()
    self:_initData()

    self:onCreateContent()

    PrivateRoomView.super.ctor(self)
    CustomHelper.addWholeScrennAnim(self)

    -- PrivateRoomView.super:setIsShowErr(false)

    GameManager:getInstance():getHallManager():getHallMsgManager():sendPrivateRoomInfoMsg()
end

function PrivateRoomView:onEnter()
    self:addCustomEventListener("PrivateRoom_SwitchGame", handler(self, self._onSwitchGame))
end

function PrivateRoomView:onExit()
    self:removeAllEventListeners()

    PrivateRoomModel:getInstance():cleanUp()

    PrivateRoomView.super.onExit(self)
end

function PrivateRoomView:registerNotification()
    self:addOneTCPMsgListener(HallMsgManager.MsgName.CS_PrivateRoomInfo)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_PrivateRoomInfo)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.CS_ChangeGame)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_EnterRoomAndSitDown)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.CS_JoinPrivateRoom)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_JoinPrivateRoomFailed)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_BankDeposit)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_BankDraw)
    print("[PrivateRoomView] registerNotification")
    dump(self)
    PrivateRoomView.super.registerNotification(self)
end

function PrivateRoomView:receiveServerResponseSuccessEvent(event)
    -- print("[PrivateRoomView] receiveServerResponseSuccessEvent")
    -- dump(event)
    local userInfo = event.userInfo
    local msgName = userInfo["msgName"]
    if msgName == HallMsgManager.MsgName.SC_PrivateRoomInfo then
        PrivateRoomModel:getInstance():setInfo(userInfo["pb_info"])

        self._checkBoxGroup:setSelectedIndex(self._data.index)
        self:_refreshContent()
    elseif msgName == HallMsgManager.MsgName.SC_EnterRoomAndSitDown then
        if self._enterRoomBtn then
            self._enterRoomBtn:setTouchEnabled(true)
        end
        if self._createRoomConfirmBtn then
            self._createRoomConfirmBtn:setTouchEnabled(true)
        end
    elseif msgName == HallMsgManager.MsgName.SC_BankDeposit then
        if self._data.operateType == PrivateRoomModel.OperateType.ENTER_PRIVATE_ROOM then
            self:_requestEnterRoom()
        elseif self._data.operateType == PrivateRoomModel.OperateType.CREATE_PRIVATE_ROOM then
            self:_enterCreateRoom()
        end
    elseif msgName == HallMsgManager.MsgName.SC_BankDraw then
        if self._data.operateType == PrivateRoomModel.OperateType.ENTER_PRIVATE_ROOM then
            self:_requestEnterRoom()
        elseif self._data.operateType == PrivateRoomModel.OperateType.CREATE_PRIVATE_ROOM then
            self:_enterCreateRoom()
        end
    end
    PrivateRoomView.super.receiveServerResponseSuccessEvent(self, event)
end

function PrivateRoomView:receiveServerResponseErrorEvent(event)
    -- print("[PrivateRoomView] receiveServerResponseErrorEvent")
    local userInfo = event.userInfo;

    -- -- TODO
    -- userInfo["msgName"] = HallMsgManager.MsgName.SC_EnterRoomAndSitDown
    -- userInfo["result"] = PrivateRoomModel.MoneyNotEnoughType.JOIN_PRIVATE_ROOM_MONEY
    -- userInfo["balance_money"] = 600

    local msgName = userInfo["msgName"];

    if self._enterRoomBtn then
        self._enterRoomBtn:setTouchEnabled(true)
    end
    if self._createRoomConfirmBtn then
        self._createRoomConfirmBtn:setTouchEnabled(true)
    end
    
    if msgName == HallMsgManager.MsgName.SC_EnterRoomAndSitDown then
        if userInfo["result"] == PrivateRoomModel.MoneyNotEnoughType.JOIN_PRIVATE_ROOM_ALL or 
            userInfo["result"] == PrivateRoomModel.MoneyNotEnoughType.CREATE_PRIVATE_ROOM_ALL then
            MyToastLayer.new(self, "金币不足，建议充值后再尝试")
        elseif userInfo["result"] == PrivateRoomModel.MoneyNotEnoughType.JOIN_PRIVATE_ROOM_MONEY or 
            userInfo["result"] == PrivateRoomModel.MoneyNotEnoughType.JOIN_PRIVATE_ROOM_BANK or
            userInfo["result"] == PrivateRoomModel.MoneyNotEnoughType.CREATE_PRIVATE_ROOM_MONEY or
            userInfo["result"] == PrivateRoomModel.MoneyNotEnoughType.CREATE_PRIVATE_ROOM_BANK then
            if userInfo["balance_money"] and userInfo["balance_money"] > 0 then
                local layer = PrivateRoomPrompt:create(userInfo["result"], userInfo["balance_money"])
                cc.Director:getInstance():getRunningScene():addChild(layer)
            end
        end
    else
        PrivateRoomPrompt.super.receiveServerResponseErrorEvent(self,event)
    end
end

function PrivateRoomView:_initData()
    self._data = {}
    self._data.roomNumDefault = ""
    self._data.roomNum = ""
    self._data.index = 1
    self._data.operateType = PrivateRoomModel.OperateType.NONE
    self._data.initedEnterRoom = false
    self._data.initedCreateRoom = false
    self._data.selectedInfoType = InfoType.NONE

    self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
end

function PrivateRoomView:onCreateContent()
    local CCSLuaNode =  requireForGameLuaFile("PrivateRoomLayerCCS")
    self.csNode = CCSLuaNode:create().root
    self:addChild(self.csNode)

    -- close btn
    local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_Close"), "ccui.Button")
    closeBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        self:removeSelf()
    end)

    -- help btn
    local helpBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_Help"), "ccui.Button")
    helpBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)

        local layer = PrivateRoomHelp:create()
        cc.Director:getInstance():getRunningScene():addChild(layer)
    end)

    self._enterRoomPanel = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Panel_Enter_Room"), "ccui.Widget")
    self._createRoomPanel = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Panel_Create_Room"), "ccui.Widget")

    self:_initCheckBox()
end

function PrivateRoomView:_initCheckBox()
    local CheckBoxGroup = requireForGameLuaFile("ui/CheckBoxGroup")
    self._checkBoxGroup = CheckBoxGroup:create()

    for i = 1, 2 do
        local function selectedEvent(sender,eventType)
            if eventType == ccui.CheckBoxEventType.selected then
                GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)

                self._data.index = i
                if self._data.index == 1 then
                    self._data.operateType = PrivateRoomModel.OperateType.ENTER_PRIVATE_ROOM
                else
                    self._data.operateType = PrivateRoomModel.OperateType.CREATE_PRIVATE_ROOM
                end
                self._checkBoxGroup:setSelectedIndex(self._data.index)
                self:_refreshContent()
            elseif eventType == ccui.CheckBoxEventType.unselected then

            end
        end  
            
        local checkBox = tolua.cast(CustomHelper.seekNodeByName(self.csNode, string.format("CheckBox_%d", i)), "ccui.CheckBox")
        checkBox:setTouchEnabled(false)
        checkBox:addEventListener(selectedEvent)  

        self._checkBoxGroup:addCheckBox(checkBox)
    end

    -- self._checkBoxGroup:setSelectedIndex(self._data.index)
    -- self:_refreshContent()
end

function PrivateRoomView:_refreshContent()
    self._enterRoomPanel:setVisible(false)
    self._createRoomPanel:setVisible(false)
    if self._data.index == 1 then
        self._enterRoomPanel:setVisible(true)
        if not self._data.initedEnterRoom then
            self._data.initedEnterRoom = true
            self:_initEnterRoom()
        end
    elseif self._data.index == 2 then
        self._createRoomPanel:setVisible(true)
        if not self._data.initedCreateRoom then
            self._data.initedCreateRoom = true
            self:_initCreateRoom()
        end
    end
end

function PrivateRoomView:_initEnterRoom()
    -- room num
    self._roomNumText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Text_Num_Room"), "ccui.Text")
    self._data.roomNumDefault = self._roomNumText:getString()

    -- num btn
    for i = 1, 10 do
        local num = i - 1
        local numBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, string.format("Button_Number_%d", num)), "ccui.Button")
        numBtn:setTag(num)
        numBtn:addClickEventListener(function()
            GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
            self._data.roomNum = self._data.roomNum .. tostring(numBtn:getTag())
            self:_refreshRoomNum()
        end)
    end

    -- clean btn
    local cleanBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_Number_Clean"), "ccui.Button")
    cleanBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        self._data.roomNum = ""
        self:_refreshRoomNum()
    end)

    -- delete btn
    local deleteBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_Number_Delete"), "ccui.Button")
    deleteBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        self._data.roomNum = string.sub(self._data.roomNum, 1, -2)
        self:_refreshRoomNum()
    end)

    -- confirm btn
    local confirmBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_Confirm"), "ccui.Button")
    confirmBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        self:_enterRoomHandle()
    end)
    self._enterRoomBtn = confirmBtn
end

function PrivateRoomView:_enterRoomHandle()
    if not self:_checkInputRoomNum() then
        -- MyToastLayer.new(self, "输入2-6位房间号")
        MyToastLayer.new(self, "请输入正确的房间号")
    else
        self:_requestEnterRoom()
    end
end

function PrivateRoomView:_checkInputRoomNum()
    -- if ((string.len(self._data.roomNum) >= 2) and (string.len(self._data.roomNum) <= 6)) then
    if (string.len(self._data.roomNum) >= 1) then
        return true
    end
    return false
end

function PrivateRoomView:_refreshRoomNum()
    if self._data.roomNum ~= "" then
        self._roomNumText:setString(self._data.roomNum)
    else
        self._roomNumText:setString(self._data.roomNumDefault)
    end
end

function PrivateRoomView:_requestEnterRoom()
    self._enterRoomBtn:setTouchEnabled(false)

    GameManager:getInstance():getHallManager():getHallMsgManager():sendEnterPrivateRoomMsg(tonumber(self._data.roomNum))
end

------------------------------------------------------------------ create room start ---------------------------------------------------------------

function PrivateRoomView:_initCreateRoom()
    self._switchGameImage = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Image_Swith_Game"), "ccui.ImageView")
    self._switchGameImage:getChildByName("Image_Icon"):ignoreContentAdaptWithSize(true)

    self._watchGameText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Text_Watch_Game"), "ccui.Text")
    self._playerNumText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Text_Player_Num"), "ccui.Text")
    self._minBetText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Text_Min_Bet"), "ccui.Text")

    local text = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Text_Create_Pay"), "ccui.Text")

    self._createPayText = HtmlText.new({lineWidth = 200, fontSize = 33})
    self._createPayText:setPosition(cc.p(text:getPositionX(), 
        text:getPositionY() - self._createPayText:getContentSize().height * 0.5))
    text:getParent():addChild(self._createPayText)

    -- switch game btn
    local switchGameBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_Switch_Game"), "ccui.Button")
    switchGameBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)

        local layer = PrivateRoomSwitch:create()
        cc.Director:getInstance():getRunningScene():addChild(layer)
    end)

    -- watch game btn
    local watchGameImg = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Image_Watch_Game"), "ccui.ImageView")
    local watchGameBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_Watch_Game"), "ccui.Button")
    watchGameBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)

        self:_createDropdownMenu(cc.p(watchGameImg:getPositionX(), watchGameImg:getPositionY() - watchGameImg:getContentSize().height * 0.5), InfoType.WATCH_GAME)
    end)
    watchGameBtn:setVisible(false)

    -- player num btn
    local playerNumImg = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Image_Player_Num"), "ccui.ImageView")
    local playerNumBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_Player_Num"), "ccui.Button")
    playerNumBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)

        self:_createDropdownMenu(cc.p(playerNumImg:getPositionX(), playerNumImg:getPositionY() - playerNumImg:getContentSize().height * 0.5), InfoType.PLAYER_NUM)
    end)
    self._playerNumBtn = playerNumBtn

    -- min bet btn
    local minBetImg = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Image_Min_Bet"), "ccui.ImageView")
    local minBetBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_Min_Bet"), "ccui.Button")
    minBetBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)

        self:_createDropdownMenu(cc.p(minBetImg:getPositionX(), minBetImg:getPositionY() - minBetImg:getContentSize().height * 0.5), InfoType.BET_MIN)
    end)
    self._minBetBtn = minBetBtn

    -- create room confirm btn
    local createRoomConfirmBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_Create_Confirm"), "ccui.Button")
    createRoomConfirmBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)

        self:_checkGameStatus()
    end)
    self._createRoomConfirmBtn = createRoomConfirmBtn

    self._dropdownMenu = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Image_Dropdown_Menu"), "ccui.ImageView")
    self._dropdownMenu:setZOrder(1)

    self:_refreshSwitchGame()
end

function PrivateRoomView:_checkGameStatus()
    local gameType = PrivateRoomModel:getInstance():getSelectedGtype()
    local needUpdateInfoTab = GameManager:getInstance():getVersionManager():getNeedUpdateInfoTabForOneGame(gameType)
    if needUpdateInfoTab == nil or table.nums(needUpdateInfoTab) == 0 then
        print("[PrivateRoomView] 不需要更新")
        self:_enterCreateRoom()
    else
        print("[PrivateRoomView] 需要更新")
        local layer = PrivateRoomUpdate:create(function ()
            self:_enterCreateRoom()
        end)
        cc.Director:getInstance():getRunningScene():addChild(layer)
    end
end

function PrivateRoomView:_enterCreateRoom()
    print("[PrivateRoomView] _enterCreateRoom")

    self._createRoomConfirmBtn:setTouchEnabled(false)

    -- CustomHelper.addIndicationTip(HallUtils:getDescriptionWithKey("entering_gamescene_tip"));

    local gameType = PrivateRoomModel:getInstance():getSelectedGtype()
    local betMin = PrivateRoomModel:getInstance():getSelectedBetMin()
    local roomId = PrivateRoomModel:getInstance():getBetMinIndex(gameType, betMin)
    local guid = self.myPlayerInfo:getGuid()
    local playerNum = PrivateRoomModel:getInstance():getSelectedPlayerNum()
    GameManager:getInstance():getHallManager():getHallMsgManager():sendCreatePrivateRoomMsg(gameType, roomId, guid, playerNum)
end

function PrivateRoomView:_onSwitchGame()
    -- print("[PrivateRoomView] _onSwitchGame")
    self:_refreshSwitchGame()
end

function PrivateRoomView:_refreshSwitchGame()
    self._switchGameImage:getChildByName("Image_Icon"):loadTexture(CustomHelper.getFullPath(PrivateRoomModel:getInstance():getImgByGtype(PrivateRoomModel:getInstance():getSelectedGtype())))

    self:_refreshCreateRoomOptions()
end

function PrivateRoomView:_createDropdownMenu(pos, infoType)
    -- print("[PrivateRoomView] _self._data.selectedInfoType:%d", self._data.selectedInfoType)
    -- print("[PrivateRoomView] infoType:%d", infoType)
    if infoType == self._data.selectedInfoType then
        self._dropdownMenu:setVisible(false)
        self._data.selectedInfoType = InfoType.NONE
        return
    end

    self._data.selectedInfoType = infoType

    self._dropdownMenu:setPosition(pos)
    self._dropdownMenu:removeAllChildren()
    self._dropdownMenu:setVisible(true)

    local data = PrivateRoomModel:getInstance():getInfoByGtype(PrivateRoomModel:getInstance():getSelectedGtype())

    if infoType == InfoType.PLAYER_NUM then
        data = data["table_count"]
    elseif infoType == InfoType.BET_MIN then
        data = data["cell_money"]
    end

    local itemDefault = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_Dropdown_Item"), "ccui.Button")

    local itemHeight = itemDefault:getContentSize().height
    local spaceY = 10

    -- calculate dropdown menu height 
    local dropdownMenuHeight = 0
    dropdownMenuHeight = spaceY * (table.getn(data) + 1) + itemHeight * (table.getn(data))
    self._dropdownMenu:setContentSize(cc.size(self._dropdownMenu:getContentSize().width, dropdownMenuHeight))

    for i = 1, table.getn(data) do
        local itemData = data[i]

        local item = itemDefault:clone()
        item:setVisible(true)
        
        item:setPosition(cc.p(self._dropdownMenu:getContentSize().width * 0.5, dropdownMenuHeight - itemHeight * (i - 0.5) - spaceY * i))
        self._dropdownMenu:addChild(item)

        item:addClickEventListener(function()
            GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
            -- print("[PrivateRoomView] click item type:%d", t)

            self._dropdownMenu:setVisible(false)
            self._data.selectedInfoType = InfoType.NONE

            if infoType == InfoType.PLAYER_NUM then
                PrivateRoomModel:getInstance():setSelectedPlayerNum(itemData)
            elseif infoType == InfoType.BET_MIN then
                PrivateRoomModel:getInstance():setSelectedBetMin(itemData)
            end

            self:_refreshCreateRoomOptions()
        end)

        if infoType == InfoType.PLAYER_NUM then
            item:getChildByName("Text_Dropdown_Item"):setString(tostring(itemData))
        elseif infoType == InfoType.BET_MIN then
            item:getChildByName("Text_Dropdown_Item"):setString(CustomHelper.moneyShowStyleNone(itemData))
        end
    end
end

-- 刷新要创建的房间的选项
function PrivateRoomView:_refreshCreateRoomOptions()
    local data = PrivateRoomModel:getInstance():getInfoByGtype(PrivateRoomModel:getInstance():getSelectedGtype())

    self._playerNumBtn:setVisible(table.getn(data["table_count"]) > 1)
    self._playerNumText:setString(PrivateRoomModel:getInstance():getSelectedPlayerNum())

    self._minBetBtn:setVisible(table.getn(data["cell_money"]) > 1)
    self._minBetText:setString(CustomHelper.moneyShowStyleNone(PrivateRoomModel:getInstance():getSelectedBetMin()))

    self._createPayText:setString(string.format(payStr, CustomHelper.moneyShowStyleNone(PrivateRoomModel:getInstance():getSelectedPlayerNum() * PrivateRoomModel:getInstance():getSelectedBetMin())))

    self._dropdownMenu:setVisible(false)
    self._data.selectedInfoType = InfoType.NONE
end

------------------------------------------------------------------ create room end -----------------------------------------------------------------

return PrivateRoomView