local CustomBaseView = requireForGameLuaFile("CustomBaseView")
local ExchangeEnsureLayer = class("ExchangeEnsureLayer", CustomBaseView)
function ExchangeEnsureLayer:ctor(args)
	dump(args, "args", nesting)
    self.needExchangeNum = args.needExchangeNum;
    self.ratio = args.ratio
    self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
    self.alipayName = self.myPlayerInfo:getAlipayName();
    self.alipayAccount = self.myPlayerInfo:getAlipayAccount();
    self.csNode = cc.CSLoader:createNode(CustomHelper.getFullPath("ExchangeEnsureLayer.csb"));
    self:addChild(self.csNode);
    local alertPanel = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "alert_panel"), "ccui.Widget");
    CustomHelper.addAlertAppearAnim(alertPanel);
    local cancelBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "cancel_btn"), "ccui.Button");
    cancelBtn:addClickEventListener(function()
		GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
		self:removeSelf();
    end);
    self.confirmBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "confirm_btn"), "ccui.Button");
    self.confirmBtn:addClickEventListener(function()
    	GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
    	self:clickEnsureBtn();
    end); 
    local closeBtn = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "btn_close"), "ccui.Button");
    closeBtn:addClickEventListener(function()
        GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
        self:removeSelf();
    end);
    local nameText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "name_text"), "ccui.Text");
    nameText:setString(self.alipayName);
    local accountText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "account_text"), "ccui.Text");
    accountText:setString(self.alipayAccount);

    local tipText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Text_3"), "ccui.Text");
    tipText:setString(string.format(tipText:getString(), self.needExchangeNum))

    ExchangeEnsureLayer.super.ctor(self)

    -- local testText = tolua.cast(CustomHelper.seekNodeByName(self.csNode, "Text_11"), "ccui.Text");
    -- local richText = myLua.HLCustomRichText:create();
    -- local str = "对目标\n周围敌人造成<p><color>abcdef</color><key>500</key><underline>ABABAC#5</underline></p>点伤害，并眩晕<p><key>2</key><color>325633</color></p>秒，同时使所有敌人造成虚无状态，虚无状态下敌人防御降低<p><key>50%</key><color>FF0000</color></p>，生命上限降低<p><key>50%</key><color>FF0000</color></p>，怒气值降低至<p><key>50%</key><color>FF0000</color></p>，<p><key>10</key><color>FF0000</color></p>分钟内无法使用药水，<p><key>50</key><color>FF0000</color></p>"
    -- local testRichText = myLua.LuaBridgeUtils:createHLCustomRichTextWithNode(str,testText,1);

    -- if testText:getParent():getChildByName(testRichText:getName()) then
    --     --todo
    --     --print("delete skill description richtext");
    --     testText:getParent():removeChildByName(testRichText:getName(), true);
    -- end
    -- testRichText:formatText();
    -- testText:getParent():addChild(testRichText)

end
function ExchangeEnsureLayer:clickEnsureBtn()
    self.confirmBtn:setTouchEnabled(false)
    local msgTab = {
        money = self.ratio * self.needExchangeNum
    }
    GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(HallMsgManager.MsgName.CS_CashMoney,msgTab,true)
end

function ExchangeEnsureLayer:registerNotification()
    local dispatcher = cc.Director:getInstance():getEventDispatcher();
    ---增加服务器消息监听 ,只有增加了的命令，才会回调对应成功监听函数
    self:addOneTCPMsgListener(HallMsgManager.MsgName.CS_CashMoney);
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_CashMoneyResult)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_CashMaintain)
    ExchangeEnsureLayer.super.registerNotification(self);
end
-- --请求失败通知，网络连接状态变化
-- function SecondarySelectLayer:callbackWhenConnectionStatusChange(event)
--     local status = event.userInfo.status;
--     if status == NetworkManager.TCPConnectionStatus.TCPConnectionStatus_Close then
--      self:setTouchEnabled(true)
--     end
--     SecondarySelectLayer.super.callbackWhenConnectionStatusChange(self,event);
-- end
function ExchangeEnsureLayer:showExchangeResult(isSuccess,tipStr)
    if self.resultLayer == nil then
        --todo
        self.resultLayer = cc.CSLoader:createNode(CustomHelper.getFullPath("ExchangeResultLayer.csb"));
        self:getParent():addChild(self.resultLayer);
        self.goExchangeListViewBtn = tolua.cast(CustomHelper.seekNodeByName(self.resultLayer, "go_exchange_list_btn"), "ccui.Button");
        self.goExchangeListViewBtn:addClickEventListener(function()
            GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
            CustomHelper.postOneNotify("go_exchange_listview_notify")
            self.resultLayer:removeSelf();
            self.resultLayer = nil;
            self:removeSelf();
        end)
        self.closeResultLayerBtn = tolua.cast(CustomHelper.seekNodeByName(self.resultLayer, "btn_close"), "ccui.Button");
        self.closeResultLayerBtn:addClickEventListener(function()
            GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
            self.resultLayer:removeSelf();
            self.resultLayer = nil;
            self:removeSelf();
        end);

        self.cancelResultLayerBtn = tolua.cast(CustomHelper.seekNodeByName(self.resultLayer, "close_btn"), "ccui.Button");
        self.cancelResultLayerBtn:addClickEventListener(function()
            GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)
            self.resultLayer:removeSelf();
            self.resultLayer = nil;
            self:removeSelf();
        end);
    end
    local titleView = tolua.cast(CustomHelper.seekNodeByName(self.resultLayer, "title_view"), "ccui.ImageView")
    local titleImageName = "hall_res/tixian/bb_confirmation_box/baobo_popupview_txcg.png"
    --提现请求成功！
    if not isSuccess then
        titleImageName = "hall_res/tixian/bb_confirmation_box/baobo_popupview_qingqiushibai.png"
    end
    titleView:ignoreContentAdaptWithSize(true);
    titleView:loadTexture(CustomHelper.getFullPath(titleImageName))

    local  tipTextParentNode = tolua.cast(CustomHelper.seekNodeByName(self.resultLayer, "text_parent_node"), "ccui.Text");   
    local richText = myLua.LuaBridgeUtils:createHLCustomRichTextWithNode(tipStr,tipTextParentNode,0);
    if tipTextParentNode:getParent():getChildByName(richText:getName()) then
        --todo
        --print("delete skill description richtext");
        tipTextParentNode:getParent():removeChildByName(richText:getName(), true);
    end
    richText:formatText();
    tipTextParentNode:getParent():addChild(richText)
    CustomHelper.addAlertAppearAnim(self.resultLayer);
    return richText;
end
--消息发送失败
function ExchangeEnsureLayer:receiveMsgRequestErrorEvent(event)
    self.confirmBtn:setTouchEnabled(true)
    ExchangeEnsureLayer.super.receiveMsgRequestErrorEvent(self,event)
end
function ExchangeEnsureLayer:receiveServerResponseErrorEvent(event)
    --print("ExchangeEnsureLayer:receiveServerResponseErrorEvent(event)")
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == HallMsgManager.MsgName.SC_CashMoneyResult then
        --todo
        local tipStr = "<p><color>ff0000</color><key>提现请求失败</key></p>"
        local richText = self:showExchangeResult(false,tipStr)
        richText:setTextHorizontalAlign(1)
        richText:setTextVerticalAlign(1);
        richText:formatText();
        return;
    elseif msgName == HallMsgManager.MsgName.SC_CashMaintain then
        --todo
        self.confirmBtn:setTouchEnabled(true)
    end
    ExchangeEnsureLayer.super.receiveServerResponseErrorEvent(self,event)
end--收到服务器处理成功通知函数
function ExchangeEnsureLayer:receiveServerResponseSuccessEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == HallMsgManager.MsgName.SC_CashMoneyResult then
        --todo
        -- MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "提现成功")
        local tipStr = "提现请求<p><color>00ff00</color><key>成功</key></p>！\n自此提现从您的银行金币中扣除<p><color>ff0000</color><key>"..self.needExchangeNum.."</key></p>可以在提现进度中查看相关记录";
        self:showExchangeResult(true,tipStr)
        self.confirmBtn:setTouchEnabled(true)
        -- self:removeSelf();
        self:setVisible(false)
    end
    ExchangeEnsureLayer.super.receiveServerResponseSuccessEvent(self,event)
end
return ExchangeEnsureLayer;