local CustomBaseView = class("CustomBaseView", cc.load("mvc").ViewBase);
local IndictationLayer = requireForGameLuaFile("IndictationLayer");
function CustomBaseView:ctor()
    --监听退出通知
    self.cmdSet = {};
    self.eventDispatcher = cc.Director:getInstance():getEventDispatcher();
    self:registerNotification();
    -- CustomHelper.addSetterAnd
    -- CustomHelper.addSetterAndGetterMethod(self,"touchEnabled",true)
    CustomBaseView.super.ctor(self);
end
function CustomBaseView:addCustomEventListener(eventName, listener)
    local dataErrorListener = cc.EventListenerCustom:create(eventName,function(event)
        listener(event.data)
    end)
    self.eventDispatcher:addEventListenerWithSceneGraphPriority(dataErrorListener,self)
end
function CustomBaseView:dispatchCustomEvent(eventName, data)
    local event = cc.EventCustom:new(eventName)
    if data then
        --todo
        event.data = data
    end
    self.eventDispatcher:dispatchEvent(event)
end
function CustomBaseView:removeAllEventListeners()
    self.eventDispatcher:removeEventListenersForTarget(self)
end
--增加一个消息监听
function CustomBaseView:addOneTCPMsgListener(msgName,responseArray,timeout)
    self.cmdSet[msgName] = msgName;
    if responseArray then
        --todo
        local hallMsgManager = GameManager:getInstance():getHallManager():getHallMsgManager();
        if hallMsgManager then
            --todo
            hallMsgManager:registerNeedTimeoutMsgName(msgName,responseArray,timeout);
        end
    end
end
-- 注册监听事件
function CustomBaseView:registerNotification()
    local connectionStatusListener =  cc.EventListenerCustom:create(HallMsgManager.kNotifyName_ConnectionStatusChange,function(event) 
        self:callbackWhenConnectionStatusChange(event);
            -- print("141241111111111111111111111111111")
    end);
    self.eventDispatcher:addEventListenerWithSceneGraphPriority(connectionStatusListener,self);
    --消息发送失败通知
    local requestErrorListener = cc.EventListenerCustom:create(HallMsgManager.kNotifyName_ConnectionClose,function(event) 
        self:receiveMsgRequestErrorEvent(event);
    end);
    
    self.eventDispatcher:addEventListenerWithSceneGraphPriority(requestErrorListener,self);
    --监听服务器返回错误结果通知
    local dataErrorListener = cc.EventListenerCustom:create(HallMsgManager.kNotifyName_MsgResponseError,function(event)
        local msgName = event.userInfo.msgName
        if self.cmdSet[msgName] then -- 如果当前类监听了该消息
            self:receiveServerResponseErrorEvent(event);
        end
    end);
    self.eventDispatcher:addEventListenerWithSceneGraphPriority(dataErrorListener,self);
    -- dump(self.cmdSet, "cmdSet", nesting);
    local allCmdSet = self.cmdSet;
    -- dump(allCmdSet, "allCmdSet", nesting);
    local responseSuccessListener = cc.EventListenerCustom:create(HallMsgManager.kNotifyName_MsgResponseSuccess,function(event)
        local msgName = event.userInfo.msgName
        if self.cmdSet[msgName] then -- 如果当前类监听了该消息
            self:receiveServerResponseSuccessEvent(event);
        end
    end);
    self.eventDispatcher:addEventListenerWithSceneGraphPriority(responseSuccessListener,self);
    --刷新用户信息监听
    local refreshPlayerInfoListener = cc.EventListenerCustom:create(HallMsgManager.kNotifyName_RefreshPlayerInfo,function()
        self:receiveRefreshPlayerInfoNotify();
    end);
    self.eventDispatcher:addEventListenerWithSceneGraphPriority(refreshPlayerInfoListener,self);
    self.eventDispatcher:resumeEventListenersForTarget(self)
end
function CustomBaseView:onExit()
    self.eventDispatcher:removeEventListenersForTarget(self);
end

--请求失败通知，网络连接状态变化
function CustomBaseView:callbackWhenConnectionStatusChange(event)
    local status = event.userInfo.status;
end
--消息发送失败
function CustomBaseView:receiveMsgRequestErrorEvent(event)

end
--收到服务器返回的失败的通知，如果登录失败，密码错误
function CustomBaseView:receiveServerResponseErrorEvent(event)
    --print("CustomBaseView:receiveServerResponseErrorEvent(event)")
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    local ret = userInfo["ret"] or userInfo["result"]; 
    local description = HallUtils:getDescWithMsgNameAndRetNum(msgName,ret);
    CustomHelper.showAlertView(description);
    CustomHelper.removeIndicationTip();
end
--收到服务器处理成功通知函数
function CustomBaseView:receiveServerResponseSuccessEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
end
function CustomBaseView:receiveRefreshPlayerInfoNotify()

end
return CustomBaseView;