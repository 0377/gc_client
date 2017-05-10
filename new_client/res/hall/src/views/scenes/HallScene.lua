local CustomBaseScene = requireForGameLuaFile("CustomBaseScene")
local HallScene = class("HallScene",CustomBaseScene);
local HallSceneUILayer = requireForGameLuaFile("HallSceneUILayer");
function HallScene.getNeedPreloadResArray()
    local resArray = {};
    local uiLayerNeedResArray = HallSceneUILayer.getNeedPreloadResArray()
    for i,v in ipairs(uiLayerNeedResArray) do
        table.insert(resArray,v)
    end
    return resArray;
end
function HallScene:ctor()
	--添加uiLayer

    self.secondLayer = nil 
    self.isFirstEnter = self:checkIsFirstEnter()
    --local HallSceneUILayer = requireForGameLuaFile("HallSceneUILayer");
	self.uiLayer = HallSceneUILayer:create(self);
	self:addChild(self.uiLayer);

	HallScene.super.ctor(self);
    GameManager:getInstance():getMusicAndSoundManager():playMusicWithFile(HallSoundConfig.BgMusic.Hall);
    -- dump(HallScene, "HallScene", nesting)
	self:addCustomEventListener("kNotifyName_showGamingAlert",handler(self,self._showGamingAlertDialog))
end

function HallScene:setSecondLayer( secondLayer )
    self.secondLayer = secondLayer
end
--今天是否第一次
function HallScene:checkIsFirstEnter()
	local curTime = os.date("*t")
	curTime.min = 0
	curTime.sec = 0
	curTime.hour = 0
	local tt = os.time(curTime)
	local userDefault = cc.UserDefault:getInstance()
	local todayvalue = userDefault:getIntegerForKey(HallDataManager.SaveTodayKey,0)
	if todayvalue ~= tt then
		userDefault:setIntegerForKey(HallDataManager.SaveTodayKey,tt)
		userDefault:flush()
	end
	return todayvalue ~= tt
end

function HallScene:_showGamingAlertDialog()
		self.gameingTipLayer = CustomHelper.showAlertView(
		"您正处于游戏中，不能进行此操作",
		false,
		true,
		nil,nil)
end
function HallScene:onEnterTransitionFinish()
    self:callbackWhenReloginAndGetPlayerInfoFinished();
   local rechargeType =  CustomHelper.getOneHallGameConfigValueWithKey("recharge_types")
    if  device.platform == "ios" and  rechargeType.iospay then
            local PayHelper = requireForGameLuaFile("PayHelper")
            PayHelper.checkIOSPayOrders()
    end
    if HallScene.super and HallScene.super.onEnterTransitionFinish then
        --todo
        HallScene.super.onEnterTransitionFinish(self);
    end

    self:setUpdatePrompt(true)
    self:handleHotPrompt()



    dump(self.secondLayer)
   --目前只有二级界面（银行和商城） 更多级界面打开功能 在需要的时候添加
    for i,v in ipairs(self.secondLayer or {}) do
        if v.tag == ViewManager.SECOND_LAYER_TAG.BANK then
            local BankCenterLayer = requireForGameLuaFile("BankCenterLayer")
            local parme =  v.parme  or BankCenterLayer.ViewType.WithDraw
            if parme == BankCenterLayer.ViewType.WithDraw then
                print("enterBankWithDrawLayer")
                ViewManager.enterBankWithDrawLayer()
            elseif parme == BankCenterLayer.ViewType.Deposit then
                print("enterBankDepositLayer")
                ViewManager.enterBankDepositLayer()
            end
        elseif v.tag == ViewManager.SECOND_LAYER_TAG.STORY then
            print("enterStoreLayer")
            ViewManager.enterStoreLayer()
        end
    end



    self.secondLayer = nil
end
function HallScene:alertLogoutTipView()
    CustomHelper.showAlertView(
    "您确定要切换账号吗？",
    true,
    true,
    nil,
    function()
        self:logoutScene() --CustomBaseScene
    end)
end
--弹出游戏维护提示框
function HallScene:alertAlertViewWhenServerMaintain()
  local tipStr =HallUtils:getDescWithMsgNameAndRetNum(HallMsgManager.MsgName.SC_GameMaintain,14)
  CustomHelper.showAlertView(
    tipStr,
    false,
    true,
    function(tipLayer)
        tipLayer:removeSelf();   
    end,
    function(tipLayer)
        tipLayer:removeSelf();
    end
  );
end
function HallScene:callbackWhenReloginAndGetPlayerInfoFinished()
    self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
    local gamingInfoTab = self.myPlayerInfo:getGamingInfoTab()
    -- dump(gamingInfoTab, "gamingInfoTab", nesting)
    -- CustomHelper.printStack()
    if gamingInfoTab ~= nil then
        --todo
        self:alertGamingTipView()
    else
        self:checkIsNeedAlertAccountBindLayer()
    end
end
--弹出正在游戏中,是否进入提示
function HallScene:alertGamingTipView()
   self.reEnterGameTipLayer = CustomHelper.showAlertView(
    "您正处于游戏中，是否继续",
    false,
    true,
    function(tipLayer)
        self.reEnterGameTipLayer:removeSelf()
        self.reEnterGameTipLayer = nil;
    end,
    function(tipLayer)
        --进入游戏
        local curGamingInfoTab = self.myPlayerInfo:getGamingInfoTab()
        if curGamingInfoTab then
            --todo
            local firstGameType = curGamingInfoTab["first_game_type"]
            local roomID = curGamingInfoTab["second_game_type"]
            -- GameManager:getInstance():getHallManager():getHallMsgManager():sendEnterOneGameMsg(firstGameType,roomID);
            curGamingInfoTab["id"] = firstGameType
            GameManager:getInstance():getHallManager():enterOneGameWithGameInfoTab(curGamingInfoTab)
        end
        self.reEnterGameTipLayer:removeSelf()
        self.reEnterGameTipLayer = nil;
    end)
end
function HallScene:checkIsNeedAlertAccountBindLayer()
    if self.myPlayerInfo:getIsGuest() == true and self.isFirstEnter then
        --todo
        --苹果审核不弹出
        self.isFirstEnter = false;
        if not CustomHelper.isExaminState() then
            ViewManager.alertAccountBindTipLayer();
            
        else
            self:checkIsNeedAlertPrivacyLayer()
        end
    end
end
--是否需要弹出用户隐私条款
function HallScene:checkIsNeedAlertPrivacyLayer()
    if not GameManager:getInstance():getHallManager():getHallDataManager():getSavaShowPrivacy() then
        ViewManager.alertPrivacyLayer()
    end
end
function HallScene:registerNotification()
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_Gamefinish);
    self:addOneTCPMsgListener(HallMsgManager.MsgName.CS_ChangeGame);
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_EnterRoomAndSitDown)
    self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_GameMaintain)
    HallScene.super.registerNotification(self);
    --监听是否弹出重新进入游戏通知
    self:addCustomEventListener("show_gaming_tip",function()
        self:alertGamingTipView();
    end)
end

--收到服务器返回的失败的通知，如果登录失败，密码错误
function HallScene:receiveServerResponseErrorEvent(event)
    --print("HallScene:receiveServerResponseErrorEvent(event)")
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    local ret = userInfo["ret"] or userInfo["result"]; 
    if msgName == HallMsgManager.MsgName.LC_Login and ret == 15 then --賬號被封
        --默认调用场景跳转
        --todo
        self:callbackWhenReceiveFreezeAccount()
        return;
    -- elseif msgName == HallMsgManager.MsgName.SC_GameMaintain then --服务器维护
    --     --todo

    -- return;
    end
    HallScene.super.receiveServerResponseErrorEvent(self,event);
end
--收到服务器处理成功通知函数
function HallScene:receiveServerResponseSuccessEvent(event)
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    -- print("12222223123123123")
    if msgName == HallMsgManager.MsgName.SC_Gamefinish then --关闭提示框
        --todo
        -- print("12312312311111111111111111111111")
        if self.reEnterGameTipLayer then
            --todo
            -- print("123123123123123123")
            self.reEnterGameTipLayer:removeSelf();
            self.reEnterGameTipLayer = nil;
        end
		if self.gameingTipLayer then
            self.gameingTipLayer:removeSelf();
            self.gameingTipLayer = nil;
		end
        CustomHelper.showAlertView(
                "本局游戏已经结束",
                false,
                true,
                nil,
            function(tipLayer)
                tipLayer:removeSelf()
        end)
    end
    if HallScene.super then
        --todo
        HallScene.super.receiveServerResponseSuccessEvent(self,event);
    end
    
end
return HallScene;
