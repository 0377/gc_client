-------------------------------------------------------------------------
-- Desc:    子游戏公用Scene基类
-- Author:  zzx
-- Date:    2017.3.24
-- Last: 
-- Content:  所有字游戏的场景都需要继承该类
--			主要集中处理各个游戏的公告
--    尽量使用sslog _cclog虽然可以用，但是不建议使用
-- Copyright (c) shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local SubGameBaseScene = class("SubGameBaseScene",requireForGameLuaFile("CustomBaseScene"))
local dispatcher = cc.Director:getInstance():getEventDispatcher()

function SubGameBaseScene:ctor()
	self.logTag = self.__cname..".lua"
	if SubGameBaseScene.super and SubGameBaseScene.super.ctor then
		SubGameBaseScene.super.ctor(self)
	end
end

function SubGameBaseScene:registerNotification()
    self:addOneTCPMsgListener(HallMsgManager.MsgName.GC_GameServerCfg);
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_StandUpAndExitRoom);
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_GameMaintain);
	--监听游戏公告和系统公告
	local noticeShowListener =  cc.EventListenerCustom:create(HallMsgManager.kNotifyName_NeedShowNotice,handler(self,self.showNoticeTip))
    dispatcher:addEventListenerWithSceneGraphPriority(noticeShowListener,self)
	SubGameBaseScene.super.registerNotification(self)
end
--游戏公告处理
-- event.userInfo._Content.content_type 表示公告类型
-- 2大厅公告
-- 3跑马灯
-- 4全服公告
-- 5游戏房间公告
function SubGameBaseScene:showNoticeTip(event)
	if not event.userInfo or not event.userInfo._Content  then
		return
	end
	local HallDataManager = GameManager:getInstance():getHallManager():getHallDataManager();
	if event.userInfo._Content.content_type and 
	tonumber(event.userInfo._Content.content_type) ==  HallDataManager.NOTICE_TYPE.GLOBAL_NOTICE  or 
	tonumber(event.userInfo._Content.content_type) == HallDataManager.NOTICE_TYPE.GAME_NOTICE then
		ViewManager.showNotice(event.userInfo)
	end
	
end
--收到服务器处理成功通知函数
function SubGameBaseScene:receiveServerResponseSuccessEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    -- print("12222223123123123")
    if msgName == HallMsgManager.MsgName.GC_GameServerCfg then --关闭提示框
        --todo
       	--判断当前游戏是否开放
     --   	local hallDataManager = GameManager:getInstance():getHallManager():getHallDataManager();
     --   	local detailGameInfoTab = hallDataManager:getCurSelectedGameDetailInfoTab();
     --   	local serverIDKey = "game_id"
     --   	local serverID = detailGameInfoTab[serverIDKey];
     --   	local allOpenServerListTab = hallDataManager:getGameServerList();
     --   	local serverIsClosed = true;
     --   	if allOpenServerListTab then
     --   		--todo
     --   		for i,v in ipairs(allOpenServerListTab) do
     --   			local openServerID = v[serverIDKey]
     --   			if openServerID == serverID then
     --   				--todo
					-- serverIsClosed = false;
     --   				break
     --   			end
     --   		end
     --   	end
     --   	if serverIsClosed then --该服务器已经关闭
     --   		--todo
     --   		local gameName = detailGameInfoTab[HallGameConfig.GameNameKey] or ""
     --   		CustomHelper.showAlertView(
    	-- 			gameName.."游戏升级维护中，请尝试其他游戏",
    	-- 			false,
    	-- 			true,
    	-- 			function(tipLayer)
    	-- 				-- body
    	-- 				tipLayer:removeSelf();
    	-- 				SceneController.goHallScene();
    	-- 			end,
    	-- 			function(tipLayer)
    	-- 				-- body
    	-- 				tipLayer:removeSelf();
    	-- 				SceneController.goHallScene();
    	-- 			end
    	-- 		)
     --    end
    end
    if SubGameBaseScene.super then
    	--todo
      SubGameBaseScene.super.receiveServerResponseSuccessEvent(self,event);
    end
end
--弹出游戏维护提示框
function SubGameBaseScene:alertAlertViewWhenServerMaintain()
  local tipStr =HallUtils:getDescWithMsgNameAndRetNum(HallMsgManager.MsgName.SC_GameMaintain,14)
  CustomHelper.showAlertView(
    tipStr,
    false,
    true,
    function()
    self:jumpToHallScene();    
    end,
    function()
    self:jumpToHallScene();
    end
  );
end
function SubGameBaseScene:receiveServerResponseErrorEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"]
    local result = userInfo["result"]
    ---退出房间失败 然后客户端强制退出
    if msgName == HallMsgManager.MsgName.SC_StandUpAndExitRoom then
		if userInfo["result"] == 1 then --在游戏中不能退出游戏
            MyToastLayer.new(self, "你已经在游戏中无法退出房间");
        else
            self:jumpToHallScene();
        end
        return;
        -- end
    elseif msgName == HallMsgManager.MsgName.SC_GameMaintain then
        --todo
        self:alertAlertViewWhenServerMaintain();
        return;
    end
    SubGameBaseScene.super.receiveServerResponseErrorEvent(self,event);
end
--跳转到HallScene
function SubGameBaseScene:jumpToHallScene()

end
--检测是否需要弹出游戏维护提示框
function SubGameBaseScene:checkIsNeedAlertGameMaintainTipView()
    local subGameManager = GameManager:getInstance():getHallManager():getSubGameManager()
    if subGameManager then
        --todo
        local gameSwitchStatus = subGameManager:getGameSwitchStatus()
        if gameSwitchStatus == GameMaintainStatus.On then
            --todo
            return true;
        end
    end
    return false;
end
function SubGameBaseScene:isContinueGameConditions()
    if self:checkIsNeedAlertGameMaintainTipView() == true then
        --todo
        self:alertAlertViewWhenServerMaintain();
        return false;
    end
    return true;
end
return SubGameBaseScene