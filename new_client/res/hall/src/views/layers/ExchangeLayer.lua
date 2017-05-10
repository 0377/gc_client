local FeedbackLayerNew = requireForGameLuaFile("FeedbackLayerNew");
local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local ExchangeLayer = class("ExchangeLayer", CustomBaseView)
--提现帮助提示界面
local ExchangeHelpLayer = class("ExchangeHelpLayer", CustomBaseView)
function ExchangeHelpLayer:ctor()
    ExchangeHelpLayer.super.ctor(self)
    self:onCreateContent()
    
end
function ExchangeHelpLayer:onCreateContent()
    local csNodePath = cc.FileUtils:getInstance():fullPathForFilename("ExchangeHelpLayer.csb");
    self.csNode = cc.CSLoader:createNode(csNodePath):addTo(self)
    local alertViewNode = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alert_view"), "ccui.Widget");
    local btnClose = alertViewNode:getChildByName("btn_close")
    btnClose:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        self:removeSelf()
    end);
    local confirmBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "confirm_btn"), "ccui.Button");
    confirmBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        self:removeSelf()
    end);
    
    CustomHelper.addAlertAppearAnim(alertViewNode);
end
--提现界面
function ExchangeLayer:ctor()
    ExchangeLayer.super.ctor(self)
    self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
    CustomHelper.addWholeScrennAnim(self)
    self:initView()
end
function ExchangeLayer:initView()
    local csNodePath = cc.FileUtils:getInstance():fullPathForFilename("ExchangeLayer.csb");
    self.csNode = cc.CSLoader:createNode(csNodePath):addTo(self)
    local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "close_btn"), "ccui.Button");
    closeBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        self:removeSelf()
    end);
    -- tab btns --
    local tabBtns = {
        { name = "enter_exchange_btn", viewNames = { "exchange_panel" } },
        { name = "enter_all_exchange_panel_btn", viewNames = { "all_exchange_panel" } },
    }
    local btns = {}
    for _, v in ipairs(tabBtns) do
        local btn = tolua.cast(CustomHelper.seekNodeByName(self.csNode,v.name), "ccui.Button");
        btn:addClickEventListener(function()
            GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
            self:clickEnterOneViewBtn(btn);
        end);
        btn.views = {};
        for i,_viewName in ipairs(v.viewNames) do
            local tempView = tolua.cast(CustomHelper.seekNodeByName(self.csNode, _viewName), "ccui.Widget");
            table.insert(btn.views,tempView);
        end
		table.insert(btns,btn);
    end
    self.btn_tabs = btns
    self:clickEnterOneViewBtn(self.btn_tabs[1]);
end
function ExchangeLayer:clickEnterOneViewBtn(sender)
    for _, v in ipairs(self.btn_tabs) do
        v:setBright(sender ~= v)
        for __, vv in ipairs(v.views) do
            vv:setVisible(sender == v)
        end
    end
    local name = sender:getName()
    if name == "enter_exchange_btn" then
        self:enterExchangePanel();
    elseif name == "enter_all_exchange_panel_btn" then
        if true then
            --todo
            local msgTab = {
                
            }
            GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(HallMsgManager.MsgName.CS_CashMoneyType,msgTab,true)

        end
        --dump(exchangeListData, "exchangeListData", nesting)
        --[[
    message CashMoneyType{
        optional int32 money = 1;                       //提现金额
        optional string created_at = 2;                 //提现时间
        optional int32  status = 3;                     //提现状态
    }

        ]]

        self:enterAllExchangeListView();
    end
end
--初始化提现界面
function ExchangeLayer:enterExchangePanel()
    -- 提现界面 --
    if self.exchangePanel == nil then
        --todo
        self.exchangePanel = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "exchange_panel"), "ccui.Widget");
    end
    if self.exchangeNumTF == nil then
        --todo
        local inputTipText = tolua.cast(CustomHelper.seekNodeByName(self.exchangePanel, "input_text"), "ccui.Text");
        inputTipText:setVisible(false);
        local bgName = "bank_file";
        self.exchangeNumTF = ccui.EditBox:create(inputTipText:getContentSize(),bgName)
        self.exchangeNumTF:setPosition(cc.p(inputTipText:getPositionX(),inputTipText:getPositionY()))
        self.exchangeNumTF:setAnchorPoint(inputTipText:getAnchorPoint())
        self.exchangeNumTF:setFontName("Helvetica-Bold")
        self.exchangeNumTF:setFontSize(36)
        self.exchangeNumTF:setFontColor(cc.c3b(114, 130, 138))
        self.exchangeNumTF:setPlaceHolder(inputTipText:getString())
        self.exchangeNumTF:setPlaceholderFontColor(cc.c3b(0xad,0xad,0xad))
        self.exchangeNumTF:setPlaceholderFontSize(36)
        -- self.exchangeNumTF:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD);
        self.exchangeNumTF:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
        self.exchangeNumTF:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
        inputTipText:getParent():addChild(self.exchangeNumTF)
        self.exchangeNumTF:registerScriptEditBoxHandler(function(eventType)
            if eventType == "ended" then
                -- --todo
                -- local needExchangeNumStr = self.exchangeNumTF:getText();
                -- local needExchangeNum = CustomHelper.tonumber(needExchangeNumStr)
                -- --needExchangeNum ,只能是50的倍数
                -- local needExchangeNum = math.floor(needExchangeNum/50) * 50
                -- self.exchangeNumTF:setText(needExchangeNum.."");

                local needExchangeNum = CustomHelper.tonumber(self.exchangeNumTF:getText())
                if ((needExchangeNum % 50) ~= 0) then
                    MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "请输入50的整倍数")
                    self.exchangeNumTF:setText("")
                end

                self:_refreshCoinBtns()
            end
            print("print:",eventType)
        end)
    end

    -- 清零
    local setZeroBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Button_Set_Zero"), "ccui.Button")
    setZeroBtn:addClickEventListener(function ()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        self:_setZero()
    end)

    self:_initCoinBtns()

    --提现帮助按钮
    if self.helpBtn == nil then
         --todo
        self.helpBtn = tolua.cast(CustomHelper.seekNodeByName(self.exchangePanel, "help_btn"), "ccui.Button");
            self.helpBtn:addClickEventListener(function()
            GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
            ExchangeHelpLayer.new():addTo(self)
        end);
    end 
    if self.exchangeBtn == nil then
		self.exchangeBtn = tolua.cast(CustomHelper.seekNodeByName(self.exchangePanel,"go_ensure_exchange_btn"),"ccui.Button");
        self.exchangeBtn:addClickEventListener(function()
            GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
            --弹出提现确认提示框
            self:clickGoExchangeEnsureBtn(); 
        end);
    end
    if self.moneyText == nil then
        --todo
        self.moneyText = tolua.cast(CustomHelper.seekNodeByName(self.exchangePanel, "money_text"), "ccui.Text");
    end
    if self.bankText == nil then
        --todo
        self.bankText = tolua.cast(CustomHelper.seekNodeByName(self.exchangePanel, "bank_text"), "ccui.Text");
    end
    self:showMoneyInfo();
end

function ExchangeLayer:_initCoinBtns()
    local coinValues = {50, 100, 500, 1000, 5000}
    self._coinValues = coinValues
    self._coinBtns = {}

    for i = 1, 5 do
        local coinBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, string.format("Button_Coin_%d", i)), "ccui.Button")
        self._coinBtns[i] = coinBtn
        coinBtn:addClickEventListener(function ()
            GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
            self:_addCoin(coinValues[i])
        end)
    end
end

--点击进入确认提现界面
function ExchangeLayer:clickGoExchangeEnsureBtn()
    --检测是否有未完成游戏，如有，则不能存钱
    local gamingInfoTab = self.myPlayerInfo:getGamingInfoTab()
    if gamingInfoTab ~= nil then

        -- if GameManager:getInstance():getHallManager():getPlayerInfo():getFreezeAccount() == 1 then
        --     CustomHelper.showAlertView("账号被冻结，请联系客服",false,true,nil,nil)
        --     return
        -- end

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


    local needExchangeNumStr = self.exchangeNumTF:getText();
    local errorStr = nil
    --判断是不是数字
    local needExchangeNum = CustomHelper.tonumber(needExchangeNumStr)
    if errorStr == nil and (needExchangeNumStr == "" or needExchangeNum == 0 ) then
        --todo
        errorStr = "请输入需要提现的金额";
    end
    local needExchangeNumStr = tonumber(needExchangeNumStr)
    local needExchangeNum = math.floor(needExchangeNum/50) * 50

    local minRemainMoneyStr = CustomHelper.getOneHallGameConfigValueWithKey("exchange_min_remain_money")
    local minRemainMoneyNum = CustomHelper.tonumber(minRemainMoneyStr);--最低保本6元

    local moneyStr = CustomHelper.moneyShowStyleNone(self.myPlayerInfo:getMoney());
    local bankMoneyStr = CustomHelper.moneyShowStyleNone(self.myPlayerInfo:getBank());
    local ratio = CustomHelper.goldToMoneyRate()
    -- if needExchangeNum > minRemainMoneyNum + self.myPlayerInfo:getMoney()/ratio + self.myPlayerInfo:getBank()/ratio  then
    if needExchangeNum > (self.myPlayerInfo:getMoney()/ratio + self.myPlayerInfo:getBank()/ratio - minRemainMoneyNum) then
        --todo
       errorStr = "当前拥有金币数量不足以提现"; 
    end
    if errorStr ~= nil then
        --todo
        MyToastLayer.new(cc.Director:getInstance():getRunningScene(), errorStr)
        return
    end

    print("needExchangeNum")
    local ExchangeEnsureLayer = requireForGameLuaFile("ExchangeEnsureLayer");
    local args = {
        needExchangeNum = needExchangeNum,
        ratio = ratio
    }
    local layer = ExchangeEnsureLayer:create(args)
    self:addChild(layer);
end
--- 更新金币
function ExchangeLayer:showMoneyInfo()
    -- local moneyStr = CustomHelper.moneyShowStyleNone(self.myPlayerInfo:getMoney());
    -- local bankMoneyStr = CustomHelper.moneyShowStyleNone(self.myPlayerInfo:getBank());

    -- 当前持有金币（身上携带 + 银行金币）
    self.moneyText:setString(CustomHelper.moneyShowStyleNone(self.myPlayerInfo:getMoney() + self.myPlayerInfo:getBank()))
    -- self.bankText:setString(bankMoneyStr)

    local canExchageMoney = self:_getCanExchangeMoney()
    self.bankText:setString(CustomHelper.moneyShowStyleNone(canExchageMoney))

    self:_refreshCoinBtns()
end
--初始化提现列表界面
function ExchangeLayer:enterAllExchangeListView()

    if self.allExchangePanel == nil then
        --todo
        self.allExchangePanel = tolua.cast(CustomHelper.seekNodeByName(self.csNode,"all_exchange_panel"), "ccui.Widget")
        local customServiceBtn = tolua.cast(CustomHelper.seekNodeByName(self.allExchangePanel, "customService_btn"), "ccui.Button");
        customServiceBtn:addClickEventListener(function()
            GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
            -- CustomServiceLayer.new():addTo(self)
            ViewManager.setForceAlertOneView(true)
            ViewManager.enterOneLayerWithClassName("FeedbackLayerNew")
        end);
        self.exchangeListView = tolua.cast(CustomHelper.seekNodeByName(self.allExchangePanel, "listview"),"ccui.ListView");
        self.defaultItemNode = tolua.cast(CustomHelper.seekNodeByName(self.allExchangePanel, "cell"), "ccui.Widget");
        self.defaultItemNode:setVisible(false)
        self.exchangeListView:removeAllItems()
    end
    --self.exchangeListView:removeAllItems()
    local exchangeListData = GameManager:getInstance():getHallManager():getHallDataManager():getExchangeListData();

    --if exchangeListData == nil then --还未请求
    
    if exchangeListData ~= nil then

        dump(exchangeListData, "exchangeListData", nesting)

        local ishaveItems = self.exchangeListView:getItem(0)
        --todo
        local account = self.myPlayerInfo:getAlipayAccount();
        for k,v in pairs(exchangeListData) do
            print(k,v)
            local itemNode = self.exchangeListView:getChildByName(v.created_at)
            if itemNode == nil then
                itemNode = self.defaultItemNode:clone();
                itemNode:setVisible(true)
                if ishaveItems == nil then
                    self.exchangeListView:pushBackCustomItem(itemNode);
                else
                    self.exchangeListView:insertCustomItem(itemNode,0);
                end
            end

            local accountText = tolua.cast(CustomHelper.seekNodeByName(itemNode, "label_account"), "ccui.Text");
            accountText:setString(account)
            local exchangeNumText = tolua.cast(CustomHelper.seekNodeByName(itemNode, "label_gold"), "ccui.Text");
            exchangeNumText:setString(string.format("%.2f",v.money));
            local exchangeDateText = tolua.cast(CustomHelper.seekNodeByName(itemNode, "label_date"), "ccui.Text");
            exchangeDateText:setString(v.created_at);
            local status = v.status
            local statusText = tolua.cast(CustomHelper.seekNodeByName(itemNode, "label_status"), "ccui.Text");
            local statusStr = "审核中"
            if status == 0 or status == 1  then
                --todo
                statusStr = "审核中"
            elseif status == 2 or status == 3  then
                --todo
                statusStr = "审核失败"
            elseif status == 4 then
                --todo
                statusStr = "已完成"
            end
            statusText:setString(statusStr)
            itemNode:setName(v.created_at)
        end
    end
end
--刷新用户信息通知处理
function ExchangeLayer:receiveRefreshPlayerInfoNotify()
    self:showMoneyInfo()
end
function ExchangeLayer:registerNotification()
    local dispatcher = cc.Director:getInstance():getEventDispatcher();
    ---增加服务器消息监听 ,只有增加了的命令，才会回调对应成功监听函数
    self:addOneTCPMsgListener(HallMsgManager.MsgName.CS_CashMoneyType);
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_CashMoneyType)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_Gamefinish)
    ExchangeLayer.super.registerNotification(self);
    --监听进入兑换列表界面通知
    local goExchangeListViewListener = cc.EventListenerCustom:create("go_exchange_listview_notify",function(event)
        print("receive go exchange listview")
        self:clickEnterOneViewBtn(self.btn_tabs[2]);
    end);
    self.eventDispatcher:addEventListenerWithSceneGraphPriority(goExchangeListViewListener,self);
end
--消息发送失败
function ExchangeLayer:receiveMsgRequestErrorEvent(event)
    ExchangeLayer.super.receiveMsgRequestErrorEvent(self,event)
end
function ExchangeLayer:receiveServerResponseErrorEvent(event)
    --print("CustomBaseView:receiveServerResponseErrorEvent(event)")
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == HallMsgManager.MsgName.SC_CashMoneyType then
        --todo
        
    end
    ExchangeLayer.super.receiveServerResponseErrorEvent(self,event)
end--收到服务器处理成功通知函数
function ExchangeLayer:receiveServerResponseSuccessEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == HallMsgManager.MsgName.SC_CashMoneyType then
        --todo
        self:enterAllExchangeListView()
    elseif msgName == HallMsgManager.MsgName.SC_Gamefinish then --关闭提示框
        --todo
        -- print("12312312311111111111111111111111")
        if self.gamingTipLayer then
            --todo
            -- print("123123123123123123")
            self.gamingTipLayer:removeSelf();
            self.gamingTipLayer = nil;
        end
    end
    ExchangeLayer.super.receiveServerResponseSuccessEvent(self,event)
end

function ExchangeLayer:_setZero()
    self.exchangeNumTF:setText("")

    self:_refreshCoinBtns()
end

function ExchangeLayer:_addCoin(addValue)
    local value = CustomHelper.tonumber(self.exchangeNumTF:getText())
    self.exchangeNumTF:setText(tostring(value + addValue))

    self:_refreshCoinBtns()
end

function ExchangeLayer:_getCanExchangeMoney()
    -- 可兑换金币：当前持有金币-6 ， 然后再减去50的余数
    local canExchageMoney = self.myPlayerInfo:getMoney() + self.myPlayerInfo:getBank()
    canExchageMoney = canExchageMoney - 6 * CustomHelper.goldToMoneyRate()
    if canExchageMoney <= 0 then
        canExchageMoney = 0
    end
    canExchageMoney = math.floor(canExchageMoney / (50 * CustomHelper.goldToMoneyRate())) * (50 * CustomHelper.goldToMoneyRate())
    return canExchageMoney
end

function ExchangeLayer:_refreshCoinBtns()
    local canExchageMoney = self:_getCanExchangeMoney()
    local hasInputMoney = CustomHelper.tonumber(self.exchangeNumTF:getText())
    canExchageMoney = (canExchageMoney / CustomHelper.goldToMoneyRate()) - hasInputMoney
    for i, v in ipairs(self._coinBtns) do
        v:setEnabled(self._coinValues[i] <= canExchageMoney)
    end
end

return ExchangeLayer