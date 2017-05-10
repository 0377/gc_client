ViewManager = class("ViewManager")
local PersonalCenterLayer = requireForGameLuaFile("PersonalCenterLayer")
local BankCenterLayer = requireForGameLuaFile("BankCenterLayer")
local RechargeLayer = requireForGameLuaFile("RechargeLayer")


--二级界面tag
ViewManager.SECOND_LAYER_TAG = 
{
	BANK = 1,
	STORY = 2,
}


function ViewManager.setForceAlertOneView(isForce)
	local parent = cc.Director:getInstance():getRunningScene()
	parent.isShowingChild = not isForce;
end
function ViewManager.alertLackMoneyTipView(needMoneyTip)
	CustomHelper.showAlertView(
    needMoneyTip,
    true,
    true,
    nil,
    function(layer)
		layer:removeSelf();
		ViewManager.setForceAlertOneView(true);
		ViewManager.enterStoreLayer()
    end
    )
end
function ViewManager.addChildTo(child,parent)
	if parent == nil then
		--todo
		parent = cc.Director:getInstance():getRunningScene()
	end
	--判断是否弹出了相同界面
	local className = child.__cname
	local preChild = parent:getChildByName(className)
	if preChild ~= nil then
		return;
	end
	--判断是否弹出界面
	if parent.isShowingChild and parent.isShowingChild == true then
		--todo
		return;
	end
	child:onNodeEvent(
		"exit",
		function()
			parent.isShowingChild = false;
		end)
	child:setName(className)
	parent.isShowingChild = true;
	parent:addChild(child)
end
--弹出账号绑定界面
function ViewManager.alertAccountBindTipLayer()
	local className = "AccountBindTipLayer"
	local AccountBindTipLayer = requireForGameLuaFile(className);
	local myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
	local layer = AccountBindTipLayer:create(
		function()
			ViewManager.setForceAlertOneView(true);
        	if myPlayerInfo:getIsGuest() == false then
        		--todo
        		ViewManager.alertAlipayBindLayer()
        	else
	        	ViewManager.alertAccountBindLayer()	
        	end
			
		end
	);
	ViewManager.addChildTo(layer);
end
function ViewManager.enterOneLayerWithClassName(className,args)
	local ClassNameLayer = requireForGameLuaFile(className)
	local layer = ClassNameLayer:create(args);
	ViewManager.addChildTo(layer,parent);
	return layer;
end
function ViewManager.enterSecondarySelctedLayer(gameId)
	local layer = ViewManager.enterOneLayerWithClassName("SecondarySelectLayer")
	layer:showView(gameId);
end
--弹出账号绑定界面
function ViewManager.alertAccountBindLayer()
	local personCenterLayer =  ViewManager.enterOneLayerWithClassName("PersonalCenterLayer")
	personCenterLayer:showViewWithType(PersonalCenterLayer.ViewType.BindAccountView);
end
--进入玩家账号界面
function ViewManager.enterPlayerAccountInfoLayer()
	--判断是否弹出游客绑定提示框
	local myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
	if myPlayerInfo:getIsGuest() == true then
		--todo
		ViewManager.alertAccountBindTipLayer()
		return;
	end
	local personCenterLayer =  ViewManager.enterOneLayerWithClassName("PersonalCenterLayer")
	personCenterLayer:showViewWithType(PersonalCenterLayer.ViewType.BindAccountView);
end
--进入支付宝绑定界面
function ViewManager.alertAlipayBindLayer()
	local personCenterLayer =  ViewManager.enterOneLayerWithClassName("PersonalCenterLayer")
	personCenterLayer:showViewWithType(PersonalCenterLayer.ViewType.BindAlipayView);
end
--进入支付宝绑定再次确认界面
function ViewManager.alertAlipayBindAgainEnsureLayer(nameStr,accountStr)
	local args = {
		["alipayName"] = nameStr,
		["alipayAccount"] = accountStr
	}
	ViewManager.enterOneLayerWithClassName("AlipayBindEnsureLayer",args);
end
function ViewManager.enterPersonalInfoLayer()
	local personCenterLayer =  ViewManager.enterOneLayerWithClassName("PersonalCenterLayer")
	personCenterLayer:showViewWithType(PersonalCenterLayer.ViewType.PersonInfoView);
end
function ViewManager.enterChangePwdLayer()
	ViewManager.enterOneLayerWithClassName("PasswordModifyLayer")
end

--进入银行存入界面
function ViewManager.enterBankDepositLayer()
	--只有不再游戏的时候才能进入兑换界面
	if not ViewManager.checkIsInGaming() then
		local bankCenterLayer =  ViewManager.enterOneLayerWithClassName("BankCenterLayer")
		bankCenterLayer:showViewWithType(BankCenterLayer.ViewType.Deposit); 
	end

end

--进入银行取款界面
function ViewManager.enterBankWithDrawLayer()
	if not ViewManager.checkIsInGaming() then
		local bankCenterLayer =  ViewManager.enterOneLayerWithClassName("BankCenterLayer")
		bankCenterLayer:showViewWithType(BankCenterLayer.ViewType.WithDraw); 
	end

end

function ViewManager.enterBankCenterLayer()
	
end
--进入充值界面
function ViewManager.enterStoreLayer()
	if CustomHelper.isExaminState() then
		if not ViewManager.checkIsInGaming() then
			ViewManager.enterOneLayerWithClassName("ShopLayer"); 
		end
	else
		local function showRechargeType()
			local rechargeType =  CustomHelper.getOneHallGameConfigValueWithKey("recharge_types")
			if rechargeType then
				if rechargeType.zfb or rechargeType.weixin then
					return true 
				end
			end
			return false 
		end
		local function showAgentsInfo()
			local agentsInfo =  CustomHelper.getOneHallGameConfigValueWithKey("agents_info")
			return  agentsInfo  and #agentsInfo > 0
		end

		local function showAgentsZhaoShang()
			local agentsZhaoShang =  CustomHelper.getOneHallGameConfigValueWithKey("agents_zhaoshang")
			return  agentsZhaoShang and ((agentsZhaoShang.qq and #agentsZhaoShang.qq ) or (agentsZhaoShang.weixin and #agentsZhaoShang.weixin))
		end


		if showRechargeType() or showAgentsInfo() or showAgentsZhaoShang() then
			if not ViewManager.checkIsInGaming() then
				local storeCenterLayer =  ViewManager.enterOneLayerWithClassName("RechargeLayer")
				storeCenterLayer:showViewWithType(storeCenterLayer.showRechargeType[1]); 
			end
		else
			CustomHelper.showAlertView("充值系统维护中。",false,true,nil,nil)
		end 
	end
end
--进入客服界面
function ViewManager.enterCustomServiceLayer()
	ViewManager.enterOneLayerWithClassName("CustomServiceLayer")
end
--进入兑换界面
function ViewManager.enterExchangeLayer()
	--只有不再游戏的时候才能进入兑换界面
	if not ViewManager.checkIsInGaming() then
		ViewManager.enterOneLayerWithClassName("ExchangeLayer")
	end
end

--隐私条款界面
function ViewManager.alertPrivacyLayer()
	ViewManager.enterOneLayerWithClassName("PrivacyPolicyLayer")
end
--判断是否在游戏中否则就弹出UI
--@return false 不在游戏中 true 在游戏中
function ViewManager.checkIsInGaming()

	if HallUtils:checkIsInGaming() then
		print("正在游戏中哦")
		--ViewManager.reEnterGameTipLayer = CustomHelper.showAlertView("您正处于游戏中，请先完成游戏",false,true,nil,nil)
		local event = cc.EventCustom:new("kNotifyName_showGamingAlert")
		cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
		return true
	end
	return false
end

function ViewManager.showNotice(data )
	if cc.Director:getInstance():getRunningScene():getChildByName("NoticeShowLayer") then return end 
	local NoticeShowLayer = requireForGameLuaFile("NoticeShowLayer")
	local noticeShowLayer = NoticeShowLayer:create(data)
	noticeShowLayer:setName("NoticeShowLayer")
	cc.Director:getInstance():getRunningScene():addChild(noticeShowLayer,999)
end