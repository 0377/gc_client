
local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local HtmlText = requireForGameLuaFile("ui/HtmlText")
local PrivateRoomModel = requireForGameLuaFile("PrivateRoomModel")

local PrivateRoomPrompt = class("PrivateRoomPrompt", CustomBaseView)

local langStr1 = "<font size='27' face='' color='#ffffff'>您携带的金币还差</font><font size='40' face='' color='#ff0000'>%s</font><font size='27' face='' color='#ffffff'>才能进入，</font>"
local langStr2 = "<font size='27' face='' color='#ffffff'>确认从银行取出%s金并进入房间吗？</font>"
local langStr3 = "<font size='27' face='' color='#ffffff'>您银行金币还差</font><font size='40' face='' color='#ff0000'>%s</font><font size='27' face='' color='#ffffff'>才能进入，</font>"
local langStr4 = "<font size='27' face='' color='#ffffff'>确定将%s金币存入银行并进入房间吗？</font>"
local langStr5 = "<font size='27' face='' color='#ffffff'>您携带的金币还差</font><font size='40' face='' color='#ff0000'>%s</font><font size='27' face='' color='#ffffff'>才能进入，</font>"
local langStr6 = "<font size='27' face='' color='#ffffff'>确认从银行取出%s金并进入房间吗？</font>"
local langStr7 = "<font size='27' face='' color='#ffffff'>您银行金币还差</font><font size='40' face='' color='#ff0000'>%s</font><font size='27' face='' color='#ffffff'>才能进入，</font>"
local langStr8 = "<font size='27' face='' color='#ffffff'>确定将%s金币存入银行并进入房间吗？</font>"

function PrivateRoomPrompt:ctor(result, money)
    PrivateRoomPrompt.super.ctor(self)

    self:_initData(result, money)
	self:_initView()
end

function PrivateRoomPrompt:registerNotification()
	self:addOneTCPMsgListener(HallMsgManager.MsgName.CS_BankDeposit)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_BankDeposit)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.CS_BankDraw)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_BankDraw)

    PrivateRoomPrompt.super.registerNotification(self)
end

function PrivateRoomPrompt:receiveServerResponseSuccessEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == HallMsgManager.MsgName.SC_BankDeposit then
        self._enterRoomBtn:setTouchEnabled(true)
        self:removeSelf()
    elseif msgName == HallMsgManager.MsgName.SC_BankDraw then
        self._enterRoomBtn:setTouchEnabled(true)
        self:removeSelf()
    end

    PrivateRoomPrompt.super.receiveServerResponseSuccessEvent(self,event)
end

function PrivateRoomPrompt:receiveServerResponseErrorEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == HallMsgManager.MsgName.SC_BankDeposit then
        self._enterRoomBtn:setTouchEnabled(true)
    elseif msgName == HallMsgManager.MsgName.SC_BankDraw then
        self._enterRoomBtn:setTouchEnabled(true)
    end
    PrivateRoomPrompt.super.receiveServerResponseErrorEvent(self,event)
end

function PrivateRoomPrompt:_initData(result, money)
    self._data = {}
    self._data.result = result
    self._data.money = money

    self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
end

function PrivateRoomPrompt:_initView()
	local CCSLuaNode =  requireForGameLuaFile("PrivateRoomPromptCCS")
    self.csNode = CCSLuaNode:create().root
    self:addChild(self.csNode)

    local alertPanel = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alert_panel"), "ccui.Widget")
    CustomHelper.addAlertAppearAnim(alertPanel)

    self._container = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Image_Prompt_Container"), "ccui.ImageView")

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

    -- enter room btn
    local enterRoomBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_Enter_Room"), "ccui.Button")
    enterRoomBtn:addClickEventListener(function ()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)

        if self._data.result == PrivateRoomModel.MoneyNotEnoughType.JOIN_PRIVATE_ROOM_MONEY or
            self._data.result == PrivateRoomModel.MoneyNotEnoughType.CREATE_PRIVATE_ROOM_MONEY then
            self:_moneyBankToGame()
        elseif self._data.result == PrivateRoomModel.MoneyNotEnoughType.JOIN_PRIVATE_ROOM_BANK or
            self._data.result == PrivateRoomModel.MoneyNotEnoughType.CREATE_PRIVATE_ROOM_BANK then
            self:_moneyGameToBank()
        end
    end)
    self._enterRoomBtn = enterRoomBtn

    -- game money
    self._gameMoneyText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "top_gold_text"), "ccui.TextAtlas")
    local moneyStr = CustomHelper.moneyShowStyleNone(self.myPlayerInfo:getMoney())
    moneyStr = string.gsub(moneyStr, "%.", "/")
    self._gameMoneyText:setString(moneyStr)

    -- bank money
    self._bankMoneyText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "top_bank_text"), "ccui.TextAtlas")
    local bankMoneyStr = CustomHelper.moneyShowStyleNone(self.myPlayerInfo:getBank())
    bankMoneyStr = string.gsub(bankMoneyStr, "%.", "/")
    self._bankMoneyText:setString(bankMoneyStr)

    self:_enterRoomHandle()
end

function PrivateRoomPrompt:_enterRoomHandle()
    if self._data.result == PrivateRoomModel.MoneyNotEnoughType.JOIN_PRIVATE_ROOM_MONEY then
        local promptText = HtmlText.new({lineWidth = 760, fontSize = 27, lineSpace = 4})
        promptText:setString(string.format(langStr1, CustomHelper.moneyShowStyleNone(self._data.money)))
        promptText:setPosition(cc.p(- promptText:getContentSize().width * 0.5, 
            - promptText:getContentSize().height * 0.5 + 30))
        self._container:addChild(promptText)

        local promptText2 = HtmlText.new({lineWidth = 760, fontSize = 27, lineSpace = 4})
        promptText2:setString(string.format(langStr2, CustomHelper.moneyShowStyleNone(self._data.money)))
        promptText2:setPosition(cc.p(- promptText2:getContentSize().width * 0.5, 
            - promptText2:getContentSize().height * 0.5 - 20))
        self._container:addChild(promptText2)
    elseif self._data.result == PrivateRoomModel.MoneyNotEnoughType.JOIN_PRIVATE_ROOM_BANK then
        local promptText = HtmlText.new({lineWidth = 760, fontSize = 27, lineSpace = 4})
        promptText:setString(string.format(langStr3, CustomHelper.moneyShowStyleNone(self._data.money)))
        promptText:setPosition(cc.p(- promptText:getContentSize().width * 0.5, 
            - promptText:getContentSize().height * 0.5 + 30))
        self._container:addChild(promptText)

        local promptText2 = HtmlText.new({lineWidth = 760, fontSize = 27, lineSpace = 4})
        promptText2:setString(string.format(langStr4, CustomHelper.moneyShowStyleNone(self._data.money)))
        promptText2:setPosition(cc.p(- promptText2:getContentSize().width * 0.5, 
            - promptText2:getContentSize().height * 0.5 - 20))
        self._container:addChild(promptText2)
    elseif self._data.result == PrivateRoomModel.MoneyNotEnoughType.CREATE_PRIVATE_ROOM_MONEY then
        local promptText = HtmlText.new({lineWidth = 760, fontSize = 27, lineSpace = 4})
        promptText:setString(string.format(langStr5, CustomHelper.moneyShowStyleNone(self._data.money)))
        promptText:setPosition(cc.p(- promptText:getContentSize().width * 0.5, 
            - promptText:getContentSize().height * 0.5 + 30))
        self._container:addChild(promptText)

        local promptText2 = HtmlText.new({lineWidth = 760, fontSize = 27, lineSpace = 4})
        promptText2:setString(string.format(langStr6, CustomHelper.moneyShowStyleNone(self._data.money)))
        promptText2:setPosition(cc.p(- promptText2:getContentSize().width * 0.5, 
            - promptText2:getContentSize().height * 0.5 - 20))
        self._container:addChild(promptText2)
    elseif self._data.result == PrivateRoomModel.MoneyNotEnoughType.CREATE_PRIVATE_ROOM_BANK then
        local promptText = HtmlText.new({lineWidth = 760, fontSize = 27, lineSpace = 4})
        promptText:setString(string.format(langStr7, CustomHelper.moneyShowStyleNone(self._data.money)))
        promptText:setPosition(cc.p(- promptText:getContentSize().width * 0.5, 
            - promptText:getContentSize().height * 0.5 + 30))
        self._container:addChild(promptText)

        local promptText2 = HtmlText.new({lineWidth = 760, fontSize = 27, lineSpace = 4})
        promptText2:setString(string.format(langStr8, CustomHelper.moneyShowStyleNone(self._data.money)))
        promptText2:setPosition(cc.p(- promptText2:getContentSize().width * 0.5, 
            - promptText2:getContentSize().height * 0.5 - 20))
        self._container:addChild(promptText2)
    end
end

function PrivateRoomPrompt:_moneyGameToBank()
    --检测是否有未完成游戏，如有，则不能存钱
    local gamingInfoTab = self.myPlayerInfo:getGamingInfoTab()
    if gamingInfoTab ~= nil then
        self.gamingTipLayer = CustomHelper.showAlertView(
            "您正处于游戏中，无法进行此项操作",
            false,
            true,
            function()
                self.gamingTipLayer:removeSelf();
                self.gamingTipLayer = nil;
            end,
            function()          
                self.gamingTipLayer:removeSelf();
                self.gamingTipLayer = nil;
            end
        )
        return;
    end

    self._enterRoomBtn:setTouchEnabled(false)

    local info = {}
    info.money = self._data.money
    GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(HallMsgManager.MsgName.CS_BankDeposit, info)
end

function PrivateRoomPrompt:_moneyBankToGame()
    self._enterRoomBtn:setTouchEnabled(false)

    local info = {}
    info.money = self._data.money
    GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(HallMsgManager.MsgName.CS_BankDraw, info)
end

return PrivateRoomPrompt