requireForGameLuaFile("JdnnConfig")
requireForGameLuaFile("JdnnDefine")
requireForGameLuaFile("JDNNPoker")
requireForGameLuaFile("JdnnGameManager")
local DeviceUtils = requireForGameLuaFile("DeviceUtils")
--local JdnnGameEnd = requireForGameLuaFile("JdnnGameEnd");
local SubGameBaseScene = requireForGameLuaFile("SubGameBaseScene")
local JdnnGameScene = class("JdnnGameScene",SubGameBaseScene);
local scheduler = cc.Director:getInstance():getScheduler()

local playWaitTime = 5


-- JdnnGameManager.CardType = 
-- {
	
-- 	BANKER_CARD_TYPE_NONE           = 100;  --//无牛
-- 	BANKER_CARD_TYPE_ONE            = 101;  --//牛1
-- 	BANKER_CARD_TYPE_TWO            = 102;  --//牛2
-- 	BANKER_CARD_TYPE_THREE 			= 103;  --//牛3
-- 	BANKER_CARD_TYPE_FOUR 			= 104;  --//牛4
-- 	BANKER_CARD_TYPE_FIVE 			= 105;  --//牛5
-- 	BANKER_CARD_TYPE_SIX 			= 106;  --//牛6
-- 	BANKER_CARD_TYPE_SEVEN 			= 107;  --//牛7
-- 	BANKER_CARD_TYPE_EIGHT 			= 108;  --//牛8
-- 	BANKER_CARD_TYPE_NIGHT 			= 109;  --//牛9
-- 	BANKER_CARD_TYPE_TEN			= 110;  --//牛10	牛牛
-- 	BANKER_CARD_TYPE_FOUR_KING		= 201;  --//4花牛 银牛
-- 	BANKER_CARD_TYPE_FIVE_KING		= 202;  --//5花牛 金牛
-- 	BANKER_CARD_TYPE_FOUR_SAMES		= 203;  --//4炸
-- 	BANKER_CARD_TYPE_FIVE_SAMLL		= 204;  --//5小牛
-- 	BANKER_CARD_TYPE_ERROR			= 1;
-- }


--CustomHelper.getFullPath("game_res/mainui/chouma1.png")
local cardTypeImagePath = {
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_NONE] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_mn.png"),
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_ONE] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_n1.png"),
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_TWO] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_n2.png"),
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_THREE] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_n3.png"),
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_FOUR] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_n4.png"),
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_FIVE] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_n5.png"),
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_SIX] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_n6.png"),
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_SEVEN] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_n7.png"),
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_EIGHT] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_n8.png"),
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_NINE] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_n9.png"),
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_TEN] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_nn.png"),
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_FOUR_KING] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_yn.png"),
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_FIVE_KING] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_jn.png"),
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_FOUR_SAMES] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_zdn.png"),
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_FIVE_SAMLL] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_wxn.png"),
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_ERROR] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_mn.png"),
	
}

local cardTypeSoundPath = {
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_NONE] = "jdnnsound/paixing/no.mp3",
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_ONE] = "jdnnsound/paixing/niu_1.mp3",
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_TWO] = "jdnnsound/paixing/niu_2.mp3",
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_THREE] = "jdnnsound/paixing/niu_3.mp3",
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_FOUR] = "jdnnsound/paixing/niu_4.mp3",
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_FIVE] = "jdnnsound/paixing/niu_5.mp3",
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_SIX] = "jdnnsound/paixing/niu_6.mp3",
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_SEVEN] = "jdnnsound/paixing/niu_7.mp3",
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_EIGHT] = "jdnnsound/paixing/niu_8.mp3",
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_NINE] = "jdnnsound/paixing/niu_9.mp3",
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_TEN] = "jdnnsound/paixing/niu_10.mp3",
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_FOUR_KING] = "jdnnsound/paixing/yinniu.mp3",
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_FIVE_KING] = "jdnnsound/paixing/jinniu.mp3",
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_FOUR_SAMES] = "jdnnsound/paixing/sizha.mp3",
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_FIVE_SAMLL] = "jdnnsound/paixing/fiveniu.mp3",
	[JdnnGameManager.CardType.BANKER_CARD_TYPE_ERROR] = "jdnnsound/paixing/no.mp3",
	
}




local qiangPath = {
	[-1] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_bq.png"),
	[1] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_q1.png"),
	[2] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_q2.png"),
	[3] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_q3.png"),
	[4] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_q4.png")
}


--menu按钮坐标
local menuPos = 
{

	["Button_back"] = {startpos = {x = 59,y = 461} ,endpos = {x = 59, y = 348}},
	["Button_sound"] = {startpos = {x = 59,y = 461} ,endpos = {x = 59, y = 238}},
	["Button_music"] = {startpos = {x = 59,y = 461} ,endpos = {x = 59, y = 128}},
	["Button_help"] = {startpos = {x = 59,y = 461} ,endpos = {x = 59, y = 21}},
	
	
}

local cardStartPos = { x = 640,y = 610}



local card5EndPos = {
	[0] = {[1] = {x = 591,y = 100},[2] = {x = 651,y = 100},[3] = {x = 711,y = 100},[4] = {x = 771,y = 100},[5] = {x = 831,y = 100}},
	[1] = {[1] = {x = 212,y = 378},[2] = {x = 249,y = 378},[3] = {x = 284,y = 378},[4] = {x = 321,y = 378},[5] = {x = 355,y = 378}},
	[2] = {[1] = {x = 286,y = 593},[2] = {x = 323,y = 593},[3] = {x = 358,y = 593},[4] = {x = 395,y = 593},[5] = {x = 429,y = 593}},
	[3] = {[1] = {x = 842,y = 593},[2] = {x = 878,y = 593},[3] = {x = 914,y = 593},[4] = {x = 951,y = 593},[5] = {x = 985,y = 593}},
	[4] = {[1] = {x = 929,y = 378},[2] = {x = 965,y = 378},[3] = {x = 1001,y = 378},[4] = {x = 1037,y = 378},[5] = {x = 1072,y = 378}},
	
}

local card3_2EndPos = {}



for k,v in pairs(card5EndPos) do
	card3_2EndPos[k] = {}
	local y = v[1].y
	card3_2EndPos[k][1] = {x = v[2].x,y = y+14}
	card3_2EndPos[k][2] = {x = v[3].x,y = y+14}
	card3_2EndPos[k][3] = {x = v[4].x,y = y+14}
	card3_2EndPos[k][4] = {x = v[2].x+(v[3].x-v[2].x)/2,y = y-24}
	card3_2EndPos[k][5] = {x = v[3].x+(v[4].x-v[3].x)/2,y = y-24}
		
end


local aa = 0



local noticeWords = {
	[1] = "这次少输一点也是为了下把赢得更多",
	[2] = "就算你是赌神也不能保证下一张牌就是你想要的",
	[3] = "胆大心细，不要被对方的演技吓倒",
	[4] = "如果知道自己的牌是最大的，那么只要考虑怎么让人跟下去就好了",
	[5] = "如果有多个人赢家，他们牌型牌点一样，将平分奖池",
	[6] = "筹码不足时全下，还可以参与比牌，有机会赢一部分",
	[7] = "如果连续在自己的回合不操作，可能被提出房间",
	[8] = "拿到好牌不加注是放弃赢钱的机会",
	[9] = "在牌局未结束的时候强制离场，等于放弃了已经丢入场中的筹码",
	[10] = "同花顺>四条>葫芦>同花>顺子>三条>两对>一对>高牌"
}




----注册消息
function JdnnGameScene:registerNotification()
	
	
	
	
	
	
    self:addOneTCPMsgListener(JdnnGameManager.MsgName.SC_BankerTableMatching);
    self:addOneTCPMsgListener(JdnnGameManager.MsgName.SC_BankerSendCards);
    self:addOneTCPMsgListener(JdnnGameManager.MsgName.SC_BankerBeginToContend);
    self:addOneTCPMsgListener(JdnnGameManager.MsgName.SC_BankerPlayerContend)
    self:addOneTCPMsgListener(JdnnGameManager.MsgName.SC_BankerChoosingBanker)

    self:addOneTCPMsgListener(JdnnGameManager.MsgName.SC_BankerPlayerBeginToBet)
    self:addOneTCPMsgListener(JdnnGameManager.MsgName.SC_BankerPlayerBet)
	self:addOneTCPMsgListener(JdnnGameManager.MsgName.SC_BankerShowOwnCards)
	self:addOneTCPMsgListener(JdnnGameManager.MsgName.SC_BankerShowCards)
	self:addOneTCPMsgListener(JdnnGameManager.MsgName.SC_BankerGameEnd)

	self:addOneTCPMsgListener(JdnnGameManager.MsgName.SC_BankerForceToLeave)
	self:addOneTCPMsgListener(JdnnGameManager.MsgName.SC_BankerReconnectInfo)

	--self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_StandUpAndExitRoom)
	
    JdnnGameScene.super.registerNotification(self);
	
	
	local dispatcher = cc.Director:getInstance():getEventDispatcher();
	--GFlowerGameScene.super.registerNotification(self)

    local marqueeShowListener =  cc.EventListenerCustom:create(HallMsgManager.kNotifyName_NeedShowMarqueeInfo,function(event) 
       self:showMarqueeTip()
    end);
	self.eventDispatcher:addEventListenerWithSceneGraphPriority(marqueeShowListener,self);
    -----
end

----接收消息
function JdnnGameScene:receiveServerResponseSuccessEvent(event)

	
	print( "receiveServerResponseSuccessEvent")
	dump(event)

    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == JdnnGameManager.MsgName.SC_BankerTableMatching then --匹配
			--
		--清空筹码
		self:clearChouMa()

    elseif msgName == JdnnGameManager.MsgName.SC_BankerSendCards then ---发牌
		--清空筹码
		self:clearChouMa()
	
		self:faPai()

    elseif msgName == JdnnGameManager.MsgName.SC_BankerBeginToContend then ---开始抢庄
		
    elseif msgName == JdnnGameManager.MsgName.SC_BankerPlayerContend then ---其它玩家的抢庄倍数
		
		

    elseif msgName == JdnnGameManager.MsgName.SC_BankerChoosingBanker then ---定庄
		--self:dingZhuang(userInfo)
		self:dingZhuangStart(userInfo)
    elseif msgName == JdnnGameManager.MsgName.SC_BankerPlayerBeginToBet then ---闲家开始下注
       
		
    elseif msgName == JdnnGameManager.MsgName.SC_BankerPlayerBet then ---闲家下注
        --
		self:xiaZhu(userInfo)
   
	elseif msgName == JdnnGameManager.MsgName.SC_BankerShowOwnCards then ---玩家看到自己的牌
		self:tanPai(userInfo)
	--
	elseif msgName == JdnnGameManager.MsgName.SC_BankerShowCards then--展示牌桌各玩家牌	消息个数=玩家人数
		self:showCard(userInfo)
		
	elseif msgName == JdnnGameManager.MsgName.SC_BankerGameEnd then--结算
		self:doEnd(userInfo)
		
	elseif msgName == JdnnGameManager.MsgName.SC_BankerForceToLeave then ---强制离开
	--
		local function  verificationGold(  )
			local betNum = userInfo["num"]
			if betNum == nil then
				betNum = 200
			end
			local cancalCallbackFunc = function (  )
				self:exitGame(false)
			end

			local bankCallbackFunc = function (  )
				local secondLayer = {}
				secondLayer.tag = ViewManager.SECOND_LAYER_TAG.BANK             
				local BankCenterLayer = requireForGameLuaFile("BankCenterLayer")
				secondLayer.parme = BankCenterLayer.ViewType.WithDraw
				local data = {}
				table.insert(data,secondLayer)
				self:exitGame(false,data)
			end

			local storyCallbackFunc = function (  )
				local secondLayer = {}
				secondLayer.tag = ViewManager.SECOND_LAYER_TAG.STORY
				local data = {}
				table.insert(data,secondLayer)
				self:exitGame(false,data)
			end


			if CustomHelper.showLackMoneyAlertView(betNum,CustomHelper.decodeURI(userInfo["reason"]),cancalCallbackFunc,bankCallbackFunc,storyCallbackFunc,nil) then
				return false
			else
				return true 
			end
		end
		verificationGold()
	
	elseif msgName == JdnnGameManager.MsgName.SC_BankerReconnectInfo then--断线重入 房间汇总信息/等待信息
		self:reConnectFaPai()
		self:reConnectXiaZhu()
		self:reConnectDingZhuang()
		self:reConnectDoEnd()
    end


    JdnnGameScene.super.receiveServerResponseSuccessEvent(self,event)
end















---重新连接成功
function JdnnGameScene:callbackWhenReloginAndGetPlayerInfoFinished(event)
    -- body
    print("重新连接成功")
    JdnnGameScene.super.callbackWhenReloginAndGetPlayerInfoFinished(self,event);
	
	 local gameingInfoTable = GameManager:getInstance():getHallManager():getPlayerInfo():getGamingInfoTab()
	
	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	--if tableinfo ~= nil and (tableinfo.state == JdnnGameManager.TexasStatus.STATUS_SHOW_DOWN)then
	if gameingInfoTable == nil then
		CustomHelper.showAlertView(
                "本局已经结束,退回到大厅!!!",
                false,
                true,
                function(tipLayer)
					
                    self:exitGame()
					tipLayer:removeFromParent()
                end,
                function(tipLayer)
                    self:exitGame()
					tipLayer:removeFromParent()
                end
        )
	
		
	else
		--- 尝试直接发送进入游戏消息
		local tableinfo = self.jdnnGameManager:getDataManager():getRoomInfo()
		local gameTypeID = tableinfo.first_game_type
		local roomID = tableinfo.second_game_type

		CustomHelper.addIndicationTip(HallUtils:getDescriptionWithKey("entering_gamescene_tip"));
		GameManager:getInstance():getHallManager():getHallMsgManager():sendEnterOneGameMsg(gameTypeID,roomID);
	end
	
	
	
   
    
end

--请求失败通知，网络连接状态变化
function JdnnGameScene:callbackWhenConnectionStatusChange(event)
    JdnnGameScene.super.callbackWhenConnectionStatusChange(self,event);
    print("网络断开连接")
end

----收到服务器返回的失败的通知，如果登录失败，密码错误
function JdnnGameScene:receiveServerResponseErrorEvent(event)
    
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"]

    ---申请上庄失败 允许上庄按钮点击，并且显示界面
    -- if msgName == JdnnGameManager.MsgName.SC_OxForBankerFlag then
    --     if userInfo["result"] == 1 then
    --        MyToastLayer.new(self, "金币不足") 
    --     end
    --     self.bankerOn:setEnabled(true)
    --     self.bankerListOn:setVisible(true)
    -- end

end


----初始化要加载的资源
function JdnnGameScene.getNeedPreloadResArray()
    -- body
    local  res = {
		--CustomHelper.getFullPath("anim/jdnn_px_eff/jdnn_px_eff.ExportJson"),
		--CustomHelper.getFullPath("anim/dezhou_supervisor/dezhou_supervisor.ExportJson")
		CustomHelper.getFullPath("anim/eff_qznn_px/eff_qznn_px.ExportJson"),
    }
    return res
end



function JdnnGameScene:onEnterTransitionFinish()
    ---发送开始消息
	self.jdnnGameManager:sendPlayerReconnection()
end


function JdnnGameScene:initVersion()
	local bgnode = self.csNode:getChildByName("Panel_bg")
	bgnode:getChildByName("Text_version"):setString("1.3")
end

function JdnnGameScene:ctor()

   
    ---初始化数据对象
    self.jdnnGameManager = JdnnGameManager:getInstance();

    JdnnGameScene.super.ctor(self);

    ---初始化界面
    local csNodePath = CustomHelper.getFullPath("jdnnGameLayerCCS.csb")
    self.csNode = cc.CSLoader:createNode(csNodePath)
    self:addChild(self.csNode)
	
	
	
	--初始化操作按钮
	self:initMyBtn()
	
	--初始化版本
	self:initVersion()
	
	--初始化按钮
	self:initMenu()
	
	--清空筹码
	self:clearChouMa()
	--
	
	--初始化跑马灯
	self:initMarquee()

    ---背景音乐
    --MusicAndSoundManager:getInstance():playMusicWithFile("brnnSound/"..gameJdnn.Sound.brnnBg, true)
	
	self._scheduler = scheduler:scheduleScriptFunc(function(dt)
            self:update(dt)
            end, 0.02, false);
	self:update(0)

    GameManager:getInstance():getHallManager():getPlayerInfo():setGamingInfoTab(nil)
	
	

	---背景音乐
    MusicAndSoundManager:getInstance():playMusicWithFile("jdnnsound/background.mp3", true)
	
end

--初始化跑马灯
function JdnnGameScene:initMarquee()
	if self.marqueePanel ~= nil then
		self.marqueePanel:removeFromParent()
		self.marqueePanel = nil
	end
	local csNodePath = CustomHelper.getFullPath("marqueeTip.csb")
    self.marqueePanel = cc.CSLoader:createNode(csNodePath)
    self:addChild(self.marqueePanel)
	
	self.marqueeText = self.marqueePanel:getChildByName("Panel_bg"):getChildByName("marqueeTip"):getChildByName("clipper"):getChildByName("Text_1")
	
	self.marqueePanel:setOpacity(0);
	self:showMarqueeTip();
end

--
function JdnnGameScene:showMarqueeTip()
	local marqueeInfo = GameManager:getInstance():getHallManager():getHallDataManager():getNextNeedShowMarqueeInfo();
	if self.isShowingMarquee == true or marqueeInfo == nil then
		--todo
		return;
	end
	local marqueeTipStr = marqueeInfo.content;
	marqueeTipStr = CustomHelper.decodeURI(marqueeTipStr)
	self.isShowingMarquee = true
	if marqueeTipStr == nil then
		--todo
		return;
	end

	-- dump(self.marqueeText, "self.marqueeText", nesting)
	if marqueeTipStr then
		--todo
		self.marqueePanel:runAction(
			cc.Sequence:create(
				cc.FadeIn:create(0.5),
				cc.CallFunc:create(
					function()
						self.marqueeText:setString(marqueeTipStr);
						local clipperWidth = self.marqueeText:getParent():getContentSize().width
						local marqueeTextWidth = self.marqueeText:getContentSize().width
						local needMoveWidth = marqueeTextWidth + clipperWidth;
						self.marqueeText:setPosition(cc.p(clipperWidth,self.marqueeText:getPositionY()));
						self.marqueeText:stopAllActions();
						local speed = 80.0;
						local time = needMoveWidth/speed;
						local seq = cc.Sequence:create(
							cc.MoveTo:create(time,cc.p(-marqueeTextWidth,self.marqueeText:getPositionY())),
							cc.CallFunc:create(function()
								GameManager:getInstance():getHallManager():getHallDataManager():callbackWhenOneMarqueeShowFinished(marqueeInfo)
								local marqueeInfo = GameManager:getInstance():getHallManager():getHallDataManager():getNextNeedShowMarqueeInfo();
								dump(marqueeInfo, "marqueeInfo", nesting)
								if marqueeInfo == nil then
									--todo
									self.marqueePanel:runAction(cc.FadeOut:create(0.5))
								end
								self.isShowingMarquee = false
							end)
							);
						self.marqueeText:runAction(seq)	
					end
				)
			)
		)	

	end
end





myPlayTime = {}
function JdnnGameScene:playsound(sound,deltime)
	if deltime == nil then
		deltime = 0.2
	end
	
	local time = socket.gettime()
	if myPlayTime[sound] == nil then
		MusicAndSoundManager:getInstance():playerSoundWithFile(sound)
		myPlayTime[sound] = {}
		myPlayTime[sound].time = time
		myPlayTime[sound].count = 1
	else
		if time-myPlayTime[sound].time >= deltime then
			MusicAndSoundManager:getInstance():playerSoundWithFile(sound)
			myPlayTime[sound].time = time
		else
			
		end
		
	end
	
	
end





--展开按钮 动画
function JdnnGameScene:zhankaiMenuAnim(speed)
	
	if speed == nil then
		speed = 1200
	end
	
	local menunode = self.csNode:getChildByName("Panel_menu")
	
	local zhedie = menunode:getChildByName("Button_zhankai")
	zhedie:loadTextures(CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_cd1.png"),
						CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_cd1_pressed.png"),
						CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_cd1_pressed.png"))
	
	for k,v in pairs(menuPos) do
		local node1 = menunode:getChildByName(k)
		if node1 ~= nil then
			node1:setScale(1)
			--node1:setPosition(v.startpos)
			node1:stopAllActions()
			local time1 = cc.pGetDistance(v.startpos,v.endpos)/speed
			
			node1:runAction( cc.MoveTo:create(time1,v.endpos ))
		end
	end
end


--折叠按钮 动画
function JdnnGameScene:zhedieMenuAnim(speed)

	if speed == nil then
		speed = 1200
	end
	
	
	local menunode = self.csNode:getChildByName("Panel_menu")
	
	local zhedie = menunode:getChildByName("Button_zhankai")
	zhedie:loadTextures(CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_cd2.png"),
						CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_cd2_pressed.png"),
						CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_cd2_pressed.png"))
	
	for k,v in pairs(menuPos) do
		local node1 = menunode:getChildByName(k)
		if node1 ~= nil then
			
			--node1:setPosition(v.endpos)
			node1:stopAllActions()
			local time1 = cc.pGetDistance(v.startpos,v.endpos)/speed
			local seq = cc.Sequence:create( cc.MoveTo:create(time1,v.startpos ),cc.CallFunc:create(function(sender)
					node1:setScale(0)
					
				end))
			node1:runAction( seq)
		end
	end
end




--初始menu
function JdnnGameScene:initMenu()
	local menunode = self.csNode:getChildByName("Panel_menu")
	
	local zhedie = menunode:getChildByName("Button_zhankai")
	zhedie.state = 0 --0:当前为折叠状态  1:当前为展开状态
	self:zhedieMenuAnim(100000)
	
	zhedie:addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			MusicAndSoundManager:getInstance():playerSoundWithFile("jdnnsound/button.mp3")
			
			zhedie.state = (zhedie.state+1)%2
			
			--如果展开
			if zhedie.state == 1 then
				self:zhankaiMenuAnim()
			else
				self:zhedieMenuAnim()
			end
			
		end
    end)
	
	--退出
	menunode:getChildByName("Button_back"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			MusicAndSoundManager:getInstance():playerSoundWithFile("jdnnsound/button.mp3")
			
			if self.jdnnGameManager:getDataManager().isMatch == true then
				--[[
				CustomHelper.showAlertView(
				   "你确定要退出游戏吗？",
				   true,
				   true,
				   function(tipLayer)
					   tipLayer:removeFromParent()
				   end,
				   function(tipLayer)
					   
					--MusicAndSoundManager:getInstance():playerSoundWithFile("jdnnsound/tuichu.mp3")
					self:exitGame()
					tipLayer:removeFromParent()
			   end)
				--CustomHelper.addIndicationTip("",cc.Director:getInstance():getRunningScene(),0);
				--]]
				self:exitGame()
			else
				local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
				if tableinfo ~= nil and (tableinfo.state == JdnnGameManager.TexasStatus.STATUS_SHOW_DOWN )then
					self:exitGame()
				else
					MyToastLayer.new(self, "请在本局游戏结束时再退出游戏")
				end
				
				
			end
			
			
			
			
		
		
		end
    end)
	

	--取消匹配
	self.csNode:getChildByName("Panel_bg"):getChildByName("Panel_waiting"):getChildByName("Button_1"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			--MusicAndSoundManager:getInstance():playerSoundWithFile("jdnnsound/button.mp3")
			
			self:exitGame()
		end
    end)
	
	
	

	--GameManager:getInstance():getMusicAndSoundManager():getMusicSwitch()
	
	local function updateSound()
		if GameManager:getInstance():getMusicAndSoundManager():getSoundSwitch() == true then
			menunode:getChildByName("Button_sound"):loadTextures(	CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_yxk.png"),
																	CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_yxk_pressed.png"),
																	CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_yxk_pressed.png"))
		else
			menunode:getChildByName("Button_sound"):loadTextures(	CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_yxg.png"),
																	CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_yxg_pressed.png"),
																	CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_yxg_pressed.png"))
		end
	end
	local function updateMusic()
		if GameManager:getInstance():getMusicAndSoundManager():getMusicSwitch() == true then
			menunode:getChildByName("Button_music"):loadTextures(	CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_yyk.png"),
																	CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_yyk_pressed.png"),
																	CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_yyk_pressed.png"))
		else
			menunode:getChildByName("Button_music"):loadTextures(	CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_yyg.png"),
																	CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_yyg_pressed.png"),
																	CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_yyg_pressed.png"))
		end
	end
	
	updateSound()
	updateMusic()
	--音效
	menunode:getChildByName("Button_sound"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			--MusicAndSoundManager:getInstance():playerSoundWithFile("jdnnsound/button.mp3")
			
			GameManager:getInstance():getMusicAndSoundManager():setSoundSwitch( not GameManager:getInstance():getMusicAndSoundManager():getSoundSwitch())
			updateSound()
		end
    end)
	
	--音乐
	menunode:getChildByName("Button_music"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			--MusicAndSoundManager:getInstance():playerSoundWithFile("jdnnsound/button.mp3")
			local musicOn = not GameManager:getInstance():getMusicAndSoundManager():getMusicSwitch()
			GameManager:getInstance():getMusicAndSoundManager():setMusicSwitch( musicOn)
			if musicOn == true then
				
				MusicAndSoundManager:getInstance():playMusicWithFile("jdnnsound/background.mp3", true)
			else
				GameManager:getInstance():getMusicAndSoundManager():stopMusic()
			end
			updateMusic()
		end
    end)
	
	--帮助
	menunode:getChildByName("Button_help"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			--MusicAndSoundManager:getInstance():playerSoundWithFile("jdnnsound/popup.mp3")
			
			local _gameTipsLayer = requireForGameLuaFile("JdnnGameTips");
			self.gameTipsLayer = _gameTipsLayer:create()
			
			--self.gameTipsLayer:setguizeTexture(self.brnnGameManager.gameDetailInfoTab["second_game_type"])
			
			self:addChild(self.gameTipsLayer, 100)
			
		end
    end)
	
	--聊天
	menunode:getChildByName("Button_talk"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			--MusicAndSoundManager:getInstance():playerSoundWithFile("jdnnsound/button.mp3")
			--
			--[[
			local _gameTalk = requireForGameLuaFile("JdnnGameTalk");
			local function sendmessage(key,str)
				local a = 0
			end
			
			self.gameTalk = _gameTalk:create(sendmessage)
			
			self:addChild(self.gameTalk, 100)
			--]]
		end
    end)
	
	
	local middlenode = self.csNode:getChildByName("Panel_middle")
	--倒计时
	local Panel_timer = middlenode:getChildByName("Panel_timer")
	
	--倒计时
	local pro = Panel_timer:getChildByName("Image_timeProgress")
	if pro == nil then
		local time_mask = Panel_timer:getChildByName("Image_pro")
		time_mask:setVisible(false)
		Panel_timer:reorderChild(Panel_timer:getChildByName("Image_4"),1)
		Panel_timer:reorderChild(Panel_timer:getChildByName("Image_pro"),1)
		Panel_timer:reorderChild(Panel_timer:getChildByName("Image_4_1"),10)
		Panel_timer:reorderChild(Panel_timer:getChildByName("time_num"),10)
		
		local iconName =  CustomHelper.getFullPath("game_res/zhujiemian/sh_djs_2.png") 
		local spriteProgress = cc.Sprite:create(iconName)
		local progressTimer = cc.ProgressTimer:create(spriteProgress)
		progressTimer:setAnchorPoint(0.5, 0.5)
		progressTimer:setPosition(cc.p(time_mask:getPosition()))
		progressTimer:setReverseDirection(true)
		progressTimer:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
		progressTimer:setPercentage(100)
		Panel_timer:addChild(progressTimer,5)
		progressTimer:setName("Image_timeProgress")
	end

	
end


function JdnnGameScene:playAnim(animName,position)
	
	local node = ccs.Armature:create("eff_qznn_px")
	node:getAnimation():setMovementEventCallFunc(function(sender, _type, id)
		if _type == ccs.MovementEventType.start then
		elseif _type == ccs.MovementEventType.complete then
			node:removeFromParent()
		elseif _type == 2 then
		end
	end)
	node:getAnimation():play(animName)
	--node:setAnchorPoint( cc.p(0.5,0.5))
	local userlistCCS = self.csNode:getChildByName("Panel_middle")--
	userlistCCS:addChild(node,10000)
	node:setPosition(position)

end




function JdnnGameScene:createChouMaSprite(num)
	
	--local chouma  = cc.Sprite:create(CustomHelper.getFullPath("game_res/mainui/chouma"..num..".png"))
	local chouma  = cc.Sprite:create(CustomHelper.getFullPath("game_res/mainui/chouma1.png"))
	local userlistCCS = self.csNode:getChildByName("Panel_middle")
	userlistCCS:addChild(chouma,100)
	return chouma
end


--重连发牌
function JdnnGameScene:reConnectFaPai()
	
	local cardlayer = self.csNode:getChildByName("Panel_middle"):getChildByName("Panel_card")
	cardlayer:removeAllChildren(true)
	
	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	local userlist = self.jdnnGameManager:getDataManager():getUserInfoList()
	--
	if tableinfo == nil or userlist == nil then
		return
	end
	
	for k,v in ipairs(userlist) do
		
		local playernode = self:getUserInfoNodeFromChairid(v.chair)
		playernode.allCard = {}
		local showPos = self:getShowPos(v.chair)
		if v.cards ~= nil then
			for k1,v1 in ipairs(v.cards) do
				
				local pokercard = JDNNPoker.new(false, v1)
				
				
				
				table.insert(playernode.allCard,pokercard)
				
				cardlayer:addChild(pokercard)
				pokercard:openBackAction()
				
				if v.flag ~= nil and v.flag == 1 then
					pokercard:setPosition( card3_2EndPos[showPos][k1])
				else
					pokercard:setPosition( card5EndPos[showPos][k1])
				end
				 
			end
		end
	end
	--
	
end


----发牌
function JdnnGameScene:faPai()
	
	self:playsound("jdnnsound/kaiju.mp3")
	self:playAnim("ani_04",cc.p(640,360))
	
	local cardlayer = self.csNode:getChildByName("Panel_middle"):getChildByName("Panel_card")
	cardlayer:removeAllChildren(true)
	
	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	local userlist = self.jdnnGameManager:getDataManager():getUserInfoList()
	--
	if tableinfo == nil or userlist == nil then
		return
	end
	
	for k,v in ipairs(userlist) do
		
		local playernode = self:getUserInfoNodeFromChairid(v.chair)
		playernode.allCard = {}
		local showPos = self:getShowPos(v.chair)
		if v.cards ~= nil then
			for k1,v1 in ipairs(v.cards) do
				
				local pokercard = JDNNPoker.new(false, v1)
				pokercard:setPosition(cardStartPos)
				
				table.insert(playernode.allCard,pokercard)
				--card5EndPos
				
				pokercard:setScale(0.3)
				cardlayer:addChild(pokercard)
				
				local movetime = 0.4
				if v.chair == tableinfo.chair then -- 自己
					local actionscale = cc.ScaleTo:create(movetime,0.75,0.75)
					pokercard:runAction(cc.Sequence:create(cc.DelayTime:create(0.2+0.1*k+0.2*k1),actionscale))
					
				else
					local actionscale = cc.ScaleTo:create(movetime,0.45,0.45)
					pokercard:runAction(cc.Sequence:create(cc.DelayTime:create(0.2+0.1*k+0.2*k1),actionscale))
				end
				local actionmove = cc.MoveTo:create(movetime,card5EndPos[showPos][k1])
				
				--翻牌
				pokercard:runAction(cc.Sequence:create(
								cc.DelayTime:create(0.2+0.1*k+0.2*k1),
								cc.CallFunc:create(function()
									MusicAndSoundManager:getInstance():playerSoundWithFile("jdnnsound/fapai.mp3")
								end),
								actionmove,
								cc.CallFunc:create(function()
									
									pokercard:openBackAction()
								end)
								))
				
				
				--action 0.75  0.45 openBackAction
				 
			end
		end
		
		
	end
	
	--
	
	
end


----摊牌
function JdnnGameScene:tanPai(msg)
	
	self:playsound("jdnnsound/tanpai.mp3")
	
	local users = self.jdnnGameManager:getDataManager():getUserInfoList()
	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	local myinfo = self.jdnnGameManager:getDataManager():getMyInfo()
	if tableinfo == nil or users == nil or myinfo == nil then
		return
	end
	local mynode = self:getUserInfoNodeFromChairid( myinfo.chair)
	for k,v in ipairs(myinfo.cards) do
		if mynode.allCard[k] ~= nil then
			mynode.allCard[k]:setNum( v)
			mynode.allCard[k]:openBackAction()
		else
		
		end
		
		mynode.allCard[k]:setCanTouch(true)
	end
	
end

----展示牌型(亮牌)
function JdnnGameScene:showCard(msg)
	
	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	local myinfo = self.jdnnGameManager:getDataManager():getMyInfo()
	if tableinfo == nil or myinfo == nil then
		return
	end
	local node = self:getUserInfoNodeFromChairid( msg.chair)
	for k,v in ipairs(msg.cards) do
		if node.allCard[k] ~= nil then
			node.allCard[k]:setNum( v)
			
			if tableinfo.chair ~= msg.chair then
				node.allCard[k]:openBackAction()
			end
			
			
			
			local showPos = self:getShowPos(msg.chair)
			if msg.flag == 1 then
				node.allCard[k]:setPosition( card3_2EndPos[showPos][k])
			else
				node.allCard[k]:setPosition( card5EndPos[showPos][k])
			end
			
			node.allCard[k]:stopAllAction()
			
			
			
		else
		
		end
		
		if tableinfo.chair == msg.chair then	--
			node.allCard[k]:setCanTouch(false)
		end
	end
	
	--播牌型动画
	local Image_paixing = node:getChildByName("Image_paixing")
	local consize = Image_paixing:getContentSize()
	local pos1 = Image_paixing:convertToWorldSpace(cc.p(consize.width/2,consize.height/2))
	
	if msg.cards_type == JdnnGameManager.CardType.BANKER_CARD_TYPE_NONE then
		
	elseif 	msg.cards_type >= JdnnGameManager.CardType.BANKER_CARD_TYPE_ONE and
			msg.cards_type <= JdnnGameManager.CardType.BANKER_CARD_TYPE_NINE then
		self:playAnim("ani_07",pos1)
	elseif msg.cards_type == JdnnGameManager.CardType.BANKER_CARD_TYPE_TEN then
		self:playAnim("ani_08",pos1)
	else
		self:playAnim("ani_09",pos1)
	end
	
	self:playsound(cardTypeSoundPath[msg.cards_type])
	--MusicAndSoundManager:getInstance():playerSoundWithFile()
	
	
	
end

function JdnnGameScene:reConnectDingZhuang()
	local users = self.jdnnGameManager:getDataManager():getUserInfoList()
	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	local myinfo = self.jdnnGameManager:getDataManager():getMyInfo()
	if tableinfo == nil or users == nil or myinfo == nil then
		return
	end
	if tableinfo.state == JdnnGameManager.TexasStatus.STATUS_DICISION_BANKER then
		local userlistCCS = self.csNode:getChildByName("Panel_middle")
		local Panel_dingzhuang = userlistCCS:getChildByName("Panel_dingzhuang")
		Panel_dingzhuang:setVisible(false)
	end
	
end

function JdnnGameScene:playEndDingZhuang(msg)
	if self.dingzhuang_scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.dingzhuang_scheduler)
        self.dingzhuang_scheduler = nil
    end
	
	local zhuangjia = self.jdnnGameManager:getDataManager():getUserInfoByChair(msg.banker_chair)
	zhuangjia.ratio = msg.banker_ratio
	
	local users = self.jdnnGameManager:getDataManager():getUserInfoList()
	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	local myinfo = self.jdnnGameManager:getDataManager():getMyInfo()
	if tableinfo == nil or users == nil or myinfo == nil then
		return
	end

	local userlistCCS = self.csNode:getChildByName("Panel_middle")
	
	
	
	--local dingzhuangsprite  = cc.Sprite:create(CustomHelper.getFullPath("game_res/zhujiemian/jdnn_icon_zhuang_1.png"))
	--self.csNode:addChild(dingzhuangsprite,1)
	
	--dingzhuangsprite:setPosition( cc.p(632,449))
	
	local zhuangjianode = self:getUserInfoNodeFromChairid( tableinfo.banker_chair)
	local contentsize = zhuangjianode:getChildByName("headicon"):getContentSize()
	local endpos = zhuangjianode:getChildByName("headicon"):convertToWorldSpace(cc.p(contentsize.width/2,contentsize.height/2))
	
	self.dingzhuangAnim:runAction(
				cc.Sequence:create(
				--cc.DelayTime:create(2),
				cc.CallFunc:create(function(sender)
					local Panel_dingzhuang = userlistCCS:getChildByName("Panel_dingzhuang")
					--Panel_dingzhuang:setScale(0)
					Panel_dingzhuang:setVisible(false)
				end),
				cc.MoveTo:create(0.4, endpos),
				cc.CallFunc:create(function(sender)
					
					self:getUserInfoNodeFromChairid(tableinfo.banker_chair):getChildByName("Image_select"):setVisible(false)
					
					zhuangjianode:getChildByName("Image_zhuangjia"):setScale(1)
					
					self.dingzhuangAnim:getAnimation():play("ani_03")
					--dingzhuangsprite:removeFromParent()
				end)))
	
end


--
function JdnnGameScene:dingZhuangStart(msg)
	
	self.dingzhuangAnim = ccs.Armature:create("eff_qznn_px")
	self.dingzhuangAnim:getAnimation():setMovementEventCallFunc(function(sender, _type, id)
		if _type == ccs.MovementEventType.start then
		elseif _type == ccs.MovementEventType.complete then
			if id == "ani_01" then
				self.dingzhuangAnim:getAnimation():play("ani_02")
				self:dingZhuang(msg)
			elseif id == "ani_02" then
				
			elseif id == "ani_03" then
				self.dingzhuangAnim:removeFromParent()
				self.dingzhuangAnim = nil
			end
			
		elseif _type == 2 then
		end
	end)
	self.dingzhuangAnim:getAnimation():play("ani_01")
	--dingzhuangAnim:setAnchorPoint( cc.p(0.5,0.5))
	local userlistCCS = self.csNode:getChildByName("Panel_middle")--
	userlistCCS:addChild(self.dingzhuangAnim,10000)
	self.dingzhuangAnim:setPosition(cc.p(632,449))
	
	
	--
	local users = self.jdnnGameManager:getDataManager():getUserInfoList()
	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	local myinfo = self.jdnnGameManager:getDataManager():getMyInfo()
	if tableinfo == nil or users == nil or myinfo == nil then
		return
	end
	local zhuangjianode = self:getUserInfoNodeFromChairid( tableinfo.banker_chair)
	zhuangjianode:getChildByName("Image_zhuangjia"):setScale(0)
	
end

----定庄
function JdnnGameScene:dingZhuang(msg)
	
	--self._tableinfo.ManyChoosingPlayerChairs = msg.chiars
	--local player = self:getUserInfoByChair(msg.banker_chiar)	
	local users = self.jdnnGameManager:getDataManager():getUserInfoList()
	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	local myinfo = self.jdnnGameManager:getDataManager():getMyInfo()
	if tableinfo == nil or users == nil or myinfo == nil then
		return
	end
	
	if self.jdnnGameManager:getDataManager():getMaxRatio() == -1 then
		MyToastLayer.new(self, "无人抢庄，随机庄家，1倍押注")
	end
	
	
	
	local userlistCCS = self.csNode:getChildByName("Panel_middle")
	local Panel_dingzhuang = userlistCCS:getChildByName("Panel_dingzhuang")
	--Panel_dingzhuang:setScale(1)
	Panel_dingzhuang:setVisible(true)
	
	
	
	
	for i=1, JDNN_MAX_USER do
		Panel_dingzhuang:getChildByName("Image_jiantou"..(i-1)):setVisible(false)
		self:getUserInfoNodeFromChairid(i):getChildByName("Image_select"):setVisible(false)
	end
	
	--人数多于1
	if #tableinfo.ManyChoosingPlayerChairs <= 1 then
		self:playEndDingZhuang(msg)
		return
	end
	
	local manyNode = {}
	for k,v in ipairs(tableinfo.ManyChoosingPlayerChairs) do
		local showpos = self:getShowPos(v)
		manyNode[k] = Panel_dingzhuang:getChildByName("Image_jiantou"..(showpos))
		manyNode[k]:setVisible(true)
		manyNode[k].chair = v
	end
	
	if self.dingzhuang_scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.dingzhuang_scheduler)
        self.dingzhuang_scheduler = nil
    end
	self.dingzhuangPosNum = 0

	local speed = 0.12 --1次跳动用时
	local zhuangquanCount = 6	--总圈数
	local zhuangquanTime = speed*(#tableinfo.ManyChoosingPlayerChairs)*zhuangquanCount	--总用时
	local curTime = 0
	
	local lastposnum = 1
	
	self.dingzhuang_scheduler = scheduler:scheduleScriptFunc(
			function(dt)
				
				--1圈 用时 t1秒
				local t1 = zhuangquanTime/zhuangquanCount
				
				curTime = curTime + dt
				
				if curTime >= zhuangquanTime then
					
					self:playEndDingZhuang(msg)
					return
				end
				
				
				local tt = curTime
				while tt > t1 do
					tt = tt - t1
				end
				
				
				local posnum = 1
				
				for i=1, (#manyNode) do
					if tt/t1 > 1/(#manyNode)*i then
						posnum = i+1
					end
				end

				--箭头音效
				if lastposnum ~= posnum then
					MusicAndSoundManager:getInstance():playerSoundWithFile("jdnnsound/jiantou.mp3")
				end
				
				print("---------posnum:"..posnum)
				lastposnum = posnum
				
				--self.dingzhuangPosNum = self.dingzhuangPosNum + dt
				--local posnum = math.ceil(self.dingzhuangPosNum)%(#manyNode)+1
					
				--
				
				for k,v in ipairs(manyNode) do
					
					local chair = manyNode[k].chair
					
					if k == posnum then
						manyNode[k]:loadTexture(CustomHelper.getFullPath("game_res/zhujiemian/qznn_jiantou_1.png"))
						
						self:getUserInfoNodeFromChairid(chair):getChildByName("Image_select"):setVisible(true)
						
						
					else
						manyNode[k]:loadTexture(CustomHelper.getFullPath("game_res/zhujiemian/qznn_jiantou_2.png"))
						
						self:getUserInfoNodeFromChairid(chair):getChildByName("Image_select"):setVisible(false)
					end
				end
				
				
            end, 0.02, false);
	
end

--清空桌面上的筹码
function JdnnGameScene:clearChouMa()
	if self.allChouMa == nil then
		self.allChouMa = {}
		return
	end
	
	for k,v in ipairs(self.allChouMa) do
		v:removeFromParent()
	end
	
	self.allChouMa = {}
	
end


function JdnnGameScene:createChouMa(num)
	local chouma  = ccui.ImageView:create(CustomHelper.getFullPath("game_res/zhujiemian/zh_brnn_chouma"..(num)..".png"))
	local userlistCCS = self.csNode:getChildByName("Panel_middle"):getChildByName("Panel_card")
	userlistCCS:addChild(chouma,100)
	table.insert(self.allChouMa,chouma)
	return chouma
end


----重连下注
function JdnnGameScene:reConnectXiaZhu()
	--飞筹码到桌子上
	
	local users = self.jdnnGameManager:getDataManager():getUserInfoList()
	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	local myinfo = self.jdnnGameManager:getDataManager():getMyInfo()
	local zhuangjia = self.jdnnGameManager:getDataManager():getZhuangJiaInfo()
	if tableinfo == nil or users == nil or myinfo == nil then
		return
	end
	
	for k,v in ipairs(users) do
		if v.bet_money ~= nil and v.bet_money > 0 then
			local usernode = self:getUserInfoNodeFromChairid(v.chair)
	
			
			
			local num = v.bet_money/tableinfo.bottom_bet/zhuangjia.ratio
			
			
			local chouma = self:createChouMa(num)
			
			
			
			local endpos = { x = math.random(420,870),y = math.random(345,495)}
			chouma:setPosition( endpos)
			
		end
	end
	
	
	
	
	
end


----下注
function JdnnGameScene:xiaZhu(msg)
	--飞筹码到桌子上
	
	local users = self.jdnnGameManager:getDataManager():getUserInfoList()
	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	local myinfo = self.jdnnGameManager:getDataManager():getMyInfo()
	local zhuangjia = self.jdnnGameManager:getDataManager():getZhuangJiaInfo()
	if tableinfo == nil or users == nil or myinfo == nil then
		return
	end
	local usernode = self:getUserInfoNodeFromChairid(msg.chair)
	
	local consize = usernode:getChildByName("Text_money"):getContentSize()
	local startpos = usernode:getChildByName("Text_money"):convertToWorldSpace(cc.p(consize.width/2,consize.height/2))
	
	local num = msg.bet_money/tableinfo.bottom_bet/zhuangjia.ratio
	
	local chouma = self:createChouMa(num)
	
	chouma:setPosition( startpos)
	
	local endpos = { x = math.random(420,870),y = math.random(345,495)}
	
	chouma:runAction(
				cc.Sequence:create(
				cc.MoveTo:create(0.4, endpos),
				cc.CallFunc:create(function(sender)
					
					MusicAndSoundManager:getInstance():playerSoundWithFile("jdnnsound/xiazhu.mp3")
				end)))
	
	
end

----桌面筹码飞向赢家并显示加钱
function JdnnGameScene:choumaFlyToWinneer(winner)
	if winner == nil then
		return
	end
	
	local winnerNode = self:getUserInfoNodeFromChairid(winner.chair)
	
	local consize = winnerNode:getChildByName("Text_money"):getContentSize()
	local endpos = winnerNode:getChildByName("Text_money"):convertToWorldSpace(cc.p(consize.width/2,consize.height/2))
	
	local speed = 800
	for k,v in pairs(self.allChouMa) do
		local t = v:clone()
		local userlistCCS = self.csNode:getChildByName("Panel_middle")
		userlistCCS:addChild(t,100)
		
		local startpos = {};
		startpos.x,startpos.y = t:getPosition()
		local len = cc.pGetDistance(endpos,startpos)
		local time = len/speed
		
		t:runAction(
				cc.Sequence:create(
				cc.MoveTo:create(time, endpos),
				cc.CallFunc:create(function(sender)
					
					
					
					
					t:removeFromParent()
				end)))
	end
	
	
end

--

--显示结算界面
function JdnnGameScene:showEnd(msg)
	
	local users = self.jdnnGameManager:getDataManager():getUserInfoList()
	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	local myinfo = self.jdnnGameManager:getDataManager():getMyInfo()
	local zhuangjia = self.jdnnGameManager:getDataManager():getZhuangJiaInfo()
	if tableinfo == nil or users == nil or myinfo == nil then
		return
	end
	
	local csNodePath = CustomHelper.getFullPath("gameover.csb")
    self.csNodeOver = cc.CSLoader:createNode(csNodePath)
    self:addChild(self.csNodeOver)
	
	for i = 1,4 do
		self.csNodeOver:getChildByName("Panel_bg"):getChildByName("Panel_playerInfo"..i):getChildByName("Panel_kong"):setVisible(true)
		self.csNodeOver:getChildByName("Panel_bg"):getChildByName("Panel_playerInfo"..i):getChildByName("Panel_player"):setVisible(false)
	end
	
	local num = 1
	for k,v in ipairs(users) do
		--local ccs1 = self:getShowPos(v.chair)
		local userNode = nil
		if v.chair == tableinfo.chair then -- 自己
			userNode = self.csNodeOver:getChildByName("Panel_bg"):getChildByName("Panel_myInfo"):getChildByName("Panel_player")
		else
			local playerNode = self.csNodeOver:getChildByName("Panel_bg"):getChildByName("Panel_playerInfo"..num)
			playerNode:getChildByName("Panel_kong"):setVisible(false)
			playerNode:getChildByName("Panel_player"):setVisible(true)
			
			userNode = playerNode:getChildByName("Panel_player")
			
			num = num + 1
		end
		
		--头像
		userNode:getChildByName("Image_headicon"):loadTexture( CustomHelper.getFullPath("hall_res/head_icon/"..(v.icon)..".png"))
		--牌型
		userNode:getChildByName("Image_paixing"):loadTexture(cardTypeImagePath[v.cards_type])
		--庄家
		if v.position == 1 then
			userNode:getChildByName("Image_zhuangjia"):setVisible(true)
		else
			userNode:getChildByName("Image_zhuangjia"):setVisible(false)
		end
		
		--赢
		if v.increment_money > 0 then
			userNode:getChildByName("Panel_win"):setVisible(true)
			userNode:getChildByName("Panel_lose"):setVisible(false)
			userNode:getChildByName("Panel_win"):getChildByName("goldchangednum"):setString( CustomHelper.moneyShowStyleNone(v.increment_money) )
		else--输
			userNode:getChildByName("Panel_win"):setVisible(false)
			userNode:getChildByName("Panel_lose"):setVisible(true)
			userNode:getChildByName("Panel_lose"):getChildByName("goldchangednum"):setString( CustomHelper.moneyShowStyleNone(0-v.increment_money) )
		end
		
		--税
		if v.tax ~= nil and v.tax > 0 then
			userNode:getChildByName("Panel_shuishou"):setVisible(true)
			userNode:getChildByName("Panel_shuishou"):getChildByName("Text_num"):setString( CustomHelper.moneyShowStyleNone(v.tax) )
		else
			userNode:getChildByName("Panel_shuishou"):setVisible(false)
		end
		
	end
	
	
	--返回大厅
	self.csNodeOver:getChildByName("Panel_bg"):getChildByName("Button_back"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			
			self:exitGame()
			
		end
    end)
	
	--下一局
	self.csNodeOver:getChildByName("Panel_bg"):getChildByName("Button_next"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			self.jdnnGameManager:sendPlayerOperate()
			
			self.csNodeOver:removeFromParent()
			self.csNodeOver = nil
		end
    end)
	
	
end


----重连结算
function JdnnGameScene:reConnectDoEnd()
	
	local users = self.jdnnGameManager:getDataManager():getUserInfoList()
	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	local myinfo = self.jdnnGameManager:getDataManager():getMyInfo()
	local zhuangjia = self.jdnnGameManager:getDataManager():getZhuangJiaInfo()
	if tableinfo == nil or users == nil or myinfo == nil then
		return
	end
	
	if tableinfo.state == JdnnGameManager.TexasStatus.STATUS_SHOW_DOWN then
		self:doEnd()
	end
	
end

----结算
function JdnnGameScene:doEnd(msg)
	
	local users = self.jdnnGameManager:getDataManager():getUserInfoList()
	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	local myinfo = self.jdnnGameManager:getDataManager():getMyInfo()
	local zhuangjia = self.jdnnGameManager:getDataManager():getZhuangJiaInfo()
	if tableinfo == nil or users == nil or myinfo == nil then
		return
	end
	
	--赢家
	local winHasZhuangjia = false
	
	local winPlayer = {}
	for k,v in ipairs(users) do
		if v.increment_money > 0 then
			table.insert(winPlayer,v)
			
			if v.chair == zhuangjia.chair then
				winHasZhuangjia = true
			end
		end
		
	end
	
	if #winPlayer == 1 and winHasZhuangjia == true then
		self:playAnim("ani_05",cc.p(640,360))
		self:playsound("jdnnsound/allwin.mp3")
	end
	if #winPlayer == #users-1 and winHasZhuangjia == false then
		self:playAnim("ani_06",cc.p(640,360))
		self:playsound("jdnnsound/alllose.mp3")
	end

	
	
	
	
	--创建等同赢数倍的相同筹码
	for k,v in pairs(winPlayer) do
		self:choumaFlyToWinneer(v)
	end
	
	--清除桌面上的筹码
	self:clearChouMa()
	
	--显示具体输赢数字
	for k,v in ipairs(users) do
		local usernode = self:getUserInfoNodeFromChairid(v.chair)
		
		local consize = usernode:getChildByName("Image_headbg1"):getContentSize()
		
		local positon = usernode:getChildByName("Image_headbg1"):convertToWorldSpace(cc.p(consize.width/2,consize.height/2))
		
		local userlistCCS = self.csNode:getChildByName("Panel_middle")
		local board = {}
		if v.increment_money > 0 then
			board = self.csNode:getChildByName("Image_winnum"):clone()
			board:getChildByName("num"):setString( CustomHelper.moneyShowStyleNone(v.increment_money) )
		else
			board = self.csNode:getChildByName("Image_losenum"):clone()
			board:getChildByName("num"):setString( CustomHelper.moneyShowStyleNone(0-v.increment_money) )
		end
		userlistCCS:addChild(board,100)
		board:setPosition(positon)
		board:setScale(0)
		
		board:runAction(
				cc.Sequence:create(
				cc.DelayTime:create(1),
				cc.CallFunc:create(function(sender)
					board:setScale(1)
				end),
				cc.DelayTime:create(3),
				cc.CallFunc:create(function(sender)
					
					board:removeFromParent()
				end)))
		
	end
	
	
	--结算界面
	self.csNode:runAction(
				cc.Sequence:create(
				cc.DelayTime:create(3),
				cc.CallFunc:create(function(sender)
					self:showEnd(msg)
				end)
				))
	
end





--更新桌面信息
function JdnnGameScene:updateTable(dt )

	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	
	--
	if tableinfo == nil then
		return
	end
	
	local datamanager = self.jdnnGameManager:getDataManager()
	if datamanager == nil then
		return 
	
	end
	
	if  datamanager.isMatch == true then
		self.csNode:getChildByName("Panel_bg"):getChildByName("Panel_waiting"):setVisible(true)
		self.csNode:getChildByName("Panel_middle"):setVisible(false)
		return
		
	else
		self.csNode:getChildByName("Panel_bg"):getChildByName("Panel_waiting"):setVisible(false)
		self.csNode:getChildByName("Panel_middle"):setVisible(true)
	end
	
	
	if tableinfo.countdown ~= nil then
		tableinfo.countdown = tableinfo.countdown -dt
		if tableinfo.countdown < 0 then
			tableinfo.countdown = 0
		end
	
	end
	
	--
	local middlenode = self.csNode:getChildByName("Panel_middle")
	
	--底池
	local Panel_dizhu = middlenode:getChildByName("Panel_dizhu")
	Panel_dizhu:getChildByName("Text_num"):setString( CustomHelper.moneyShowStyleNone(tableinfo.bottom_bet))
	
	--dump(self.jdnnGameManager.gameDetailInfoTab)
	--self.brnnGameManager.gameDetailInfoTab["second_game_type"]gameDetailInfoTab
	Panel_dizhu:getChildByName("Text_1"):setString( self.jdnnGameManager.gameDetailInfoTab["room_name"])
	
	--倒计时
	local Panel_timer = middlenode:getChildByName("Panel_timer")
	
	if 	tableinfo.state == JdnnGameManager.TexasStatus.STATUS_CONTEND_BANKER or
		tableinfo.state == JdnnGameManager.TexasStatus.STATUS_BET or
		tableinfo.state == JdnnGameManager.TexasStatus.STATUS_SHOW_CARD then
		Panel_timer:setVisible(true)
		
		--倒计时
		Panel_timer:getChildByName("time_num"):setString( math.ceil(tableinfo.countdown))
		local imageTimeProgress = Panel_timer:getChildByName("Image_timeProgress")
		local t1 = tableinfo.countdown/tableinfo.total_time
		imageTimeProgress:setPercentage(math.ceil(100*t1))
	else
		Panel_timer:setVisible(false)
	end
	
	
	
end




--初始化自己按钮
function JdnnGameScene:initMyBtn( )
	

	local middle = self.csNode:getChildByName("Panel_middle")
	
	local Panel_qiangzhuang = middle:getChildByName("Panel_qiangzhuang")
	
	--不抢
	Panel_qiangzhuang:getChildByName("Button_1"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			self.jdnnGameManager:sendBankerContend(-1)
			
		end
    end)
	--1
	Panel_qiangzhuang:getChildByName("Button_2"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			self.jdnnGameManager:sendBankerContend(1)
			
		end
    end)
	--2
	Panel_qiangzhuang:getChildByName("Button_3"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			self.jdnnGameManager:sendBankerContend(2)
			
		end
    end)
	--3
	Panel_qiangzhuang:getChildByName("Button_4"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			self.jdnnGameManager:sendBankerContend(3)
			
		end
    end)
	--4
	Panel_qiangzhuang:getChildByName("Button_5"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			self.jdnnGameManager:sendBankerContend(4)
			
		end
    end)
	
	
	local Panel_xiazhu = middle:getChildByName("Panel_xiazhu")
	--1
	Panel_xiazhu:getChildByName("Button_1"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
			local zhuangjia = self.jdnnGameManager:getDataManager():getZhuangJiaInfo()
			if tableinfo == nil or zhuangjia == nil then
				return nil
			end
			
			
			self.jdnnGameManager:sendBankerPlayerBet(tableinfo.bottom_bet*zhuangjia.ratio*1)
			
		end
    end)
	--2
	Panel_xiazhu:getChildByName("Button_2"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
			local zhuangjia = self.jdnnGameManager:getDataManager():getZhuangJiaInfo()
			if tableinfo == nil or zhuangjia == nil then
				return nil
			end
			
			
			self.jdnnGameManager:sendBankerPlayerBet(tableinfo.bottom_bet*zhuangjia.ratio*2)
			
		end
    end)
	--3
	Panel_xiazhu:getChildByName("Button_3"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
			local zhuangjia = self.jdnnGameManager:getDataManager():getZhuangJiaInfo()
			if tableinfo == nil or zhuangjia == nil then
				return nil
			end
			
			
			self.jdnnGameManager:sendBankerPlayerBet(tableinfo.bottom_bet*zhuangjia.ratio*3)
			
		end
    end)
	--4
	Panel_xiazhu:getChildByName("Button_4"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
			local zhuangjia = self.jdnnGameManager:getDataManager():getZhuangJiaInfo()
			if tableinfo == nil or zhuangjia == nil then
				return nil
			end
			
			
			self.jdnnGameManager:sendBankerPlayerBet(tableinfo.bottom_bet*zhuangjia.ratio*4)
			
		end
    end)
	--5
	Panel_xiazhu:getChildByName("Button_5"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
			local zhuangjia = self.jdnnGameManager:getDataManager():getZhuangJiaInfo()
			if tableinfo == nil or zhuangjia == nil then
				return nil
			end
			
			
			self.jdnnGameManager:sendBankerPlayerBet(tableinfo.bottom_bet*zhuangjia.ratio*5)
			
		end
    end)
	
	
	
	local Panel_caipai = middle:getChildByName("Panel_caipai")
	--提示
	Panel_caipai:getChildByName("Button_1"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
			local myinfo = self.jdnnGameManager:getDataManager():getMyInfo()
			if tableinfo == nil or myinfo == nil then
				return nil
			end
			
			
			if myinfo.pre_cards_type == JdnnGameManager.CardType.BANKER_CARD_TYPE_NONE then
				MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "没牛")
			elseif 	myinfo.pre_cards_type >= JdnnGameManager.CardType.BANKER_CARD_TYPE_ONE and
					myinfo.pre_cards_type <= JdnnGameManager.CardType.BANKER_CARD_TYPE_TEN then
				self:upMy3Card10()
			elseif myinfo.pre_cards_type >= JdnnGameManager.CardType.BANKER_CARD_TYPE_FOUR_KING and
					myinfo.pre_cards_type <= JdnnGameManager.CardType.BANKER_CARD_TYPE_FIVE_KING then
				self:upPre3Card()
			elseif myinfo.pre_cards_type == JdnnGameManager.CardType.BANKER_CARD_TYPE_FOUR_SAMES then
				self:upMy4CardSame()
			elseif myinfo.pre_cards_type == JdnnGameManager.CardType.BANKER_CARD_TYPE_FIVE_SAMLL then			
				self:upPre5Card()
			end
			
		end
    end)
	--猜牌
	Panel_caipai:getChildByName("Button_2"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
			local myinfo = self.jdnnGameManager:getDataManager():getMyInfo()
			if tableinfo == nil or myinfo == nil then
				return nil
			end
			
			if myinfo.pre_cards_type >= JdnnGameManager.CardType.BANKER_CARD_TYPE_FOUR_KING  then
				self.jdnnGameManager:sendBankerPlayerGuessCards()
			else
				--有牛
				if 	myinfo.pre_cards_type >= JdnnGameManager.CardType.BANKER_CARD_TYPE_ONE and 
					myinfo.pre_cards_type <= JdnnGameManager.CardType.BANKER_CARD_TYPE_TEN then
					if self:isMy3UpCard10() then
						self.jdnnGameManager:sendBankerPlayerGuessCards()
					else
					--无牛
						MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "有牛哦，再尝试一下！")
					end
				else
					self.jdnnGameManager:sendBankerPlayerGuessCards()
				end
				
				
			end
			
			
			
		end
    end)
end


function JdnnGameScene:getShowPos(chair)
	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	if tableinfo == nil then
		return nil
	end
	local userlistCCS = self.csNode:getChildByName("Panel_middle")
	
	local ccs1 = chair - tableinfo.chair
	if ccs1 < 0 then
		ccs1 = ccs1 + JDNN_MAX_USER
	end
	
	return ccs1
end


function JdnnGameScene:getUserInfoNodeFromChairid(chair)

	local ccs1 = self:getShowPos(chair)
	local userlistCCS = self.csNode:getChildByName("Panel_middle")
	local uNode = userlistCCS:getChildByName("Panel_userInfo_"..(ccs1))
	
	return uNode
end



function JdnnGameScene:updateUserInfo(dt )

	local users = self.jdnnGameManager:getDataManager():getUserInfoList()
	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	local myinfo = self.jdnnGameManager:getDataManager():getMyInfo()
	if tableinfo == nil or users == nil or myinfo == nil then
		return
	end
	
	local userlistCCS = self.csNode:getChildByName("Panel_middle")
	
	for i=1, JDNN_MAX_USER do
		local uNode = self:getUserInfoNodeFromChairid(i)
		uNode:setVisible(false)
	end
	
	
	for k, v in pairs(users) do
		
		
		local uNode = self:getUserInfoNodeFromChairid(v.chair)
		if uNode ~= nil then
			uNode:setVisible(true)
			local ismy = false
			if v.chair == myinfo.chair then
				ismy = true
			end
			
			
			--玩家名字
			local userNameNode = uNode:getChildByName("Text_name")
			userNameNode:setString(v.name)
			CustomHelper.transeWordToStaticLen(userNameNode,110)
			
			--玩家钱
			local userMoneyNode = uNode:getChildByName("Text_money")
			userMoneyNode:setString( CustomHelper.moneyShowStyleAB(v.money))
			userMoneyNode:setScale(math.min(1,110 / userMoneyNode:getContentSize().width))

			
			--玩家头像
			local userIconNode = uNode:getChildByName("headicon")
			userIconNode:loadTexture(CustomHelper.getFullPath("hall_res/head_icon/"..(v.icon)..".png"))
			
			
			
			--是否是庄家
			local userZhuangjiaNode = uNode:getChildByName("Image_zhuangjia")
			if v.position == 1 then --庄家
				userZhuangjiaNode:setVisible(true)
			else
				userZhuangjiaNode:setVisible(false)
			end

			
			
			--筹码
			local userChoumaNode = uNode:getChildByName("Panel_chouma")
			
			if v.bet_money ~= nil and v.bet_money > 0 then
				userChoumaNode:setVisible(true)
				userChoumaNode:getChildByName("Text_3"):setString( CustomHelper.moneyShowStyleNone(v.bet_money) )
			else
				userChoumaNode:setVisible(false)
			end
			
			--抢庄
			local Image_qiang = uNode:getChildByName("Image_qiang")
			if v.ratio ~= nil then
				Image_qiang:setVisible(true)
				Image_qiang:loadTexture( qiangPath[v.ratio])
			else
				Image_qiang:setVisible(false)
			end
			
			--牌型
			local Image_paixing = uNode:getChildByName("Image_paixing")
			--if tableinfo.state == JdnnGameManager.TexasStatus.STATUS_SHOW_DOWN and v.cards_type ~= nil then
			if  v.cards_type ~= nil then
				Image_paixing:setVisible(true)
				Image_paixing:loadTexture( cardTypeImagePath[v.cards_type])
			else
				Image_paixing:setVisible(false)
			end
			
			
		end
		
		
		
		
	end
end
--[[
--游戏状态
JdnnGameManager.TexasStatus =
{
	STATUS_SEND_CARDS		= 1;	--//发牌阶段
	STATUS_CONTEND_BANKER	= 2;	--//抢庄阶段
	STATUS_DICISION_BANKER	= 3;	--//定庄阶段
	STATUS_BET				= 4;	--//下注阶段
	STATUS_SHOW_CARD		= 5;	--//摊牌阶段
	STATUS_SHOW_DOWN		= 6;	--//结算
}

--]]

--找出3张牌点之和为整10的数
function JdnnGameScene:get3CardTen(cards)
	
	if #cards ~= 5 then
		return nil
	end
	
	for i = 1,3 do
		for j = i+1,4 do
			for k = j+1,5 do
				if (cards[i]:getCardPoint() + cards[j]:getCardPoint() + cards[k]:getCardPoint())%10 == 0 then
					local re = {cards[i],cards[j],cards[k]}
					return re
				end
			end
		end
	end
	
	return nil

end

--找出4张相同的牌
function JdnnGameScene:get4CardSame(cards)
	
	if #cards ~= 5 then
		return nil
	end
	local pai = {}
	for k,v in ipairs(cards) do
		if pai[v:getTrueCardPoint()] == nil then
			pai[v:getTrueCardPoint()].count = 1
			pai[v:getTrueCardPoint()].cards = {v}
		else
			pai[v:getTrueCardPoint()].count = pai[v:getTrueCardPoint()].count + 1
			table.insert(pai[v:getTrueCardPoint()].cards,v )
		end
	end
	for k,v in pairs(pai) do
		if v.count == 4 then
			return v.cards
		end
	end
	
	return nil

end



--选择出前3张牌
function JdnnGameScene:upPre3Card()
	
	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	local myinfo = self.jdnnGameManager:getDataManager():getMyInfo()
	local zhuangjia = self.jdnnGameManager:getDataManager():getZhuangJiaInfo()
	if tableinfo == nil or myinfo == nil or zhuangjia == nil then
		return
	end
	
	local mynode = self:getUserInfoNodeFromChairid(tableinfo.chair)
	
	for k,v in ipairs(mynode.allCard) do
		if k <= 3 then
			v:select()
		else
			v:unSelect()
		end
		
	end
	
end
--选择出前5张牌
function JdnnGameScene:upPre5Card()
	
	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	local myinfo = self.jdnnGameManager:getDataManager():getMyInfo()
	local zhuangjia = self.jdnnGameManager:getDataManager():getZhuangJiaInfo()
	if tableinfo == nil or myinfo == nil or zhuangjia == nil then
		return
	end
	
	local mynode = self:getUserInfoNodeFromChairid(tableinfo.chair)
	
	for k,v in ipairs(mynode.allCard) do
		
		v:select()
		
	end
	
end

--选择出4张相同的牌
function JdnnGameScene:upMy4CardSame()
	
	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	local myinfo = self.jdnnGameManager:getDataManager():getMyInfo()
	local zhuangjia = self.jdnnGameManager:getDataManager():getZhuangJiaInfo()
	if tableinfo == nil or myinfo == nil or zhuangjia == nil then
		return
	end
	
	local mynode = self:getUserInfoNodeFromChairid(tableinfo.chair)
	--[[
	local cardpoint = {}
	for k,v in ipairs(mynode.allCard) do
		table.insert(cardpoint,v:getCardPoint())
	end
	--]]
	local cardSame = self:get4CardSame(mynode.allCard)
	
	if cardSame ~= nil then
		for k,v in ipairs(mynode.allCard) do
			v:unSelect()
		end
		for k,v in ipairs(cardSame) do
			v:select()
		end
	end
	
end




--选择出3张整10的牌
function JdnnGameScene:upMy3Card10()
	
	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	local myinfo = self.jdnnGameManager:getDataManager():getMyInfo()
	local zhuangjia = self.jdnnGameManager:getDataManager():getZhuangJiaInfo()
	if tableinfo == nil or myinfo == nil or zhuangjia == nil then
		return
	end
	
	local mynode = self:getUserInfoNodeFromChairid(tableinfo.chair)
	--[[
	local cardpoint = {}
	for k,v in ipairs(mynode.allCard) do
		table.insert(cardpoint,v:getCardPoint())
	end
	--]]
	local cardTen = self:get3CardTen(mynode.allCard)
	
	if cardTen ~= nil then
		for k,v in ipairs(mynode.allCard) do
			v:unSelect()
		end
		for k,v in ipairs(cardTen) do
			v:select()
		end
	end
	
end

function JdnnGameScene:isMy3UpCard10()
	local cards = self:getMyUpCard()
	
	if #cards ~= 3 then
		return false
	end
	
	local allnum = 0
	for k,v in ipairs(cards) do
		allnum = allnum + v:getCardPoint()
	end
	
	if allnum % 10 == 0  then
		return true
	end
	
	return false
end

function JdnnGameScene:getMyUpCard()
	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	local myinfo = self.jdnnGameManager:getDataManager():getMyInfo()
	local zhuangjia = self.jdnnGameManager:getDataManager():getZhuangJiaInfo()
	if tableinfo == nil or myinfo == nil or zhuangjia == nil then
		return {}
	end
	local allupCard = {}
	local mynode = self:getUserInfoNodeFromChairid(tableinfo.chair)
	for k,v in ipairs(mynode.allCard) do
		if v:isSelect() then
			table.insert(allupCard,v)
		end
	end
	
	return allupCard
end


function JdnnGameScene:updatePlayerBtn(dt )

	local users = self.jdnnGameManager:getDataManager():getUserInfoList()
	local tableinfo = self.jdnnGameManager:getDataManager():getTableInfo()
	local myinfo = self.jdnnGameManager:getDataManager():getMyInfo()
	local zhuangjia = self.jdnnGameManager:getDataManager():getZhuangJiaInfo()
	if tableinfo == nil or users == nil or myinfo == nil then
		return
	end
	
	local userlistCCS = self.csNode:getChildByName("Panel_middle")
	
	local Panel_dingzhuang = userlistCCS:getChildByName("Panel_dingzhuang")
	local Panel_qiangzhuang = userlistCCS:getChildByName("Panel_qiangzhuang")
	local Panel_xiazhu = userlistCCS:getChildByName("Panel_xiazhu")
	local Panel_caipai = userlistCCS:getChildByName("Panel_caipai")
	
	
	if tableinfo.state == JdnnGameManager.TexasStatus.STATUS_SEND_CARDS then
		Panel_dingzhuang:setVisible(false)
		Panel_qiangzhuang:setVisible(false)
		Panel_xiazhu:setVisible(false)
		Panel_caipai:setVisible(false)
		
	elseif tableinfo.state == JdnnGameManager.TexasStatus.STATUS_CONTEND_BANKER then
		Panel_dingzhuang:setVisible(false)
		Panel_qiangzhuang:setVisible(true)
		Panel_xiazhu:setVisible(false)
		Panel_caipai:setVisible(false)
		
		--抢庄 
		if myinfo.ratio ~= nil then
			Panel_qiangzhuang:setVisible(false)
		end
		
	elseif tableinfo.state == JdnnGameManager.TexasStatus.STATUS_DICISION_BANKER then
		--Panel_dingzhuang:setVisible(true)
		Panel_qiangzhuang:setVisible(false)
		Panel_xiazhu:setVisible(false)
		Panel_caipai:setVisible(false)
	elseif tableinfo.state == JdnnGameManager.TexasStatus.STATUS_BET then
		Panel_dingzhuang:setVisible(false)
		Panel_qiangzhuang:setVisible(false)
		Panel_xiazhu:setVisible(true)
		Panel_caipai:setVisible(false)
		--闲家下注
		if myinfo.position == 1 then --庄家
			Panel_xiazhu:getChildByName("Image_2"):setVisible(true)
			Panel_xiazhu:getChildByName("Button_1"):setVisible(false)
			Panel_xiazhu:getChildByName("Button_2"):setVisible(false)
			Panel_xiazhu:getChildByName("Button_3"):setVisible(false)
			Panel_xiazhu:getChildByName("Button_4"):setVisible(false)
			Panel_xiazhu:getChildByName("Button_5"):setVisible(false)
		else
			Panel_xiazhu:getChildByName("Image_2"):setVisible(false)
			
			if myinfo.bet_money ~= nil and myinfo.bet_money > 0 then
				Panel_xiazhu:getChildByName("Button_1"):setVisible(false)
				Panel_xiazhu:getChildByName("Button_2"):setVisible(false)
				Panel_xiazhu:getChildByName("Button_3"):setVisible(false)
				Panel_xiazhu:getChildByName("Button_4"):setVisible(false)
				Panel_xiazhu:getChildByName("Button_5"):setVisible(false)
			else
				Panel_xiazhu:getChildByName("Button_1"):setVisible(true)
				Panel_xiazhu:getChildByName("Button_2"):setVisible(true)
				Panel_xiazhu:getChildByName("Button_3"):setVisible(true)
				Panel_xiazhu:getChildByName("Button_4"):setVisible(true)
				Panel_xiazhu:getChildByName("Button_5"):setVisible(true)
				
				for i = 1,5 do
					Panel_xiazhu:getChildByName("Button_"..i):getChildByName("num"):setString( 
					CustomHelper.moneyShowStyleNone( tableinfo.bottom_bet*zhuangjia.ratio*i) )
				end
				
				
			end
			
			
		end
		
		
	elseif tableinfo.state == JdnnGameManager.TexasStatus.STATUS_SHOW_CARD then
		Panel_dingzhuang:setVisible(false)
		Panel_qiangzhuang:setVisible(false)
		Panel_xiazhu:setVisible(false)
		Panel_caipai:setVisible(true)
		
		if myinfo.cards_type ~= nil then
			Panel_caipai:setVisible(false)
		else
			--预测牌型
		
			local preCardTypeImagePathNormal = {
				[JdnnGameManager.CardType.BANKER_CARD_TYPE_FOUR_KING] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_yn.png"),
				[JdnnGameManager.CardType.BANKER_CARD_TYPE_FIVE_KING] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_jn.png"),
				[JdnnGameManager.CardType.BANKER_CARD_TYPE_FOUR_SAMES] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_zdn.png"),
				[JdnnGameManager.CardType.BANKER_CARD_TYPE_FIVE_SAMLL] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_icon_wxn.png"),
				
			}
			local preCardTypeImagePathPressed = {
				[JdnnGameManager.CardType.BANKER_CARD_TYPE_FOUR_KING] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_yn_pressed.png"),
				[JdnnGameManager.CardType.BANKER_CARD_TYPE_FIVE_KING] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_jn_pressed.png"),
				[JdnnGameManager.CardType.BANKER_CARD_TYPE_FOUR_SAMES] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_zdn_pressed.png"),
				[JdnnGameManager.CardType.BANKER_CARD_TYPE_FIVE_SAMLL] = CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_wxn_pressed.png"),
				
			}
			
			local prebtn = Panel_caipai:getChildByName("Button_2")
			--[JdnnGameManager.CardType.BANKER_CARD_TYPE_NONE] = CustomHelper.getFullPath("game_res/zhujiemian/jdnn_button_meiniu.png")
			if myinfo.pre_cards_type >= JdnnGameManager.CardType.BANKER_CARD_TYPE_FOUR_KING  then
				prebtn:loadTextures(preCardTypeImagePathNormal[myinfo.pre_cards_type],
						preCardTypeImagePathPressed[myinfo.pre_cards_type],
						preCardTypeImagePathPressed[myinfo.pre_cards_type])
			else
				--有牛
				if self:isMy3UpCard10() then
					prebtn:loadTextures(CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_youniu.png"),
						CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_youniu_pressed.png"),
						CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_youniu_pressed.png"))
				else
					--无牛
					prebtn:loadTextures(CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_meiniu.png"),
						CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_meiniu_pressed.png"),
						CustomHelper.getFullPath("game_res/zhujiemian/qznn_button_meiniu_pressed.png"))
				end
			end
		end
		
	elseif tableinfo.state == JdnnGameManager.TexasStatus.STATUS_SHOW_DOWN then
		Panel_dingzhuang:setVisible(false)
		Panel_qiangzhuang:setVisible(false)
		Panel_xiazhu:setVisible(false)
		Panel_caipai:setVisible(false)
	else
		Panel_dingzhuang:setVisible(false)
		Panel_qiangzhuang:setVisible(false)
		Panel_xiazhu:setVisible(false)
		Panel_caipai:setVisible(false)
	end
	
	
	
	
	
	
	
end

--更新设备信息
function JdnnGameScene:updateDeviceInfo(dt)
	if self.deviceCsb == nil then
		local csNodePath = CustomHelper.getFullPath("phoneInfo.csb")
		self.deviceCsb = cc.CSLoader:createNode(csNodePath)
		self:addChild(self.deviceCsb)
	end
	
	--wifi
	----信号类型
    local  onnectivityType = DeviceUtils.getConnectivityType()

    if onnectivityType == 0  then --none
        self.deviceCsb:getChildByName("Panel_bg"):getChildByName("Image_wifi"):loadTexture( 
								CustomHelper.getFullPath("game_res/zhujiemian/qznn_wifi_1.png"))

    elseif onnectivityType == 2 then ---mobil
       
        local mobileSignalLevel = DeviceUtils.getMobileSignalLevel();
        
        if mobileSignalLevel == 0 then
            
        
        elseif mobileSignalLevel >=3 then
           

        elseif mobileSignalLevel <=2   then
            
        end

    elseif onnectivityType == 1 then ---wifi

        
        local wifiSignalLevel = DeviceUtils.getWifiSignalLevel();
        if wifiSignalLevel == 0 then
            self.deviceCsb:getChildByName("Panel_bg"):getChildByName("Image_wifi"):loadTexture( 
								CustomHelper.getFullPath("game_res/zhujiemian/qznn_wifi_1.png"))
        ---3格信号以上
        elseif wifiSignalLevel >=3 then
            self.deviceCsb:getChildByName("Panel_bg"):getChildByName("Image_wifi"):loadTexture( 
								CustomHelper.getFullPath("game_res/zhujiemian/qznn_wifi_2.png"))
        ---2格信号
        elseif wifiSignalLevel == 2   then
           self.deviceCsb:getChildByName("Panel_bg"):getChildByName("Image_wifi"):loadTexture( 
								CustomHelper.getFullPath("game_res/zhujiemian/qznn_wifi_3.png"))
        ---1格信号
        elseif wifiSignalLevel == 1 then
            self.deviceCsb:getChildByName("Panel_bg"):getChildByName("Image_wifi"):loadTexture( 
								CustomHelper.getFullPath("game_res/zhujiemian/qznn_wifi_4.png"))
        end
    end
	
	
	--电量
	local dianchi = self.deviceCsb:getChildByName("Panel_bg"):getChildByName("Image_dianchi")
	
    

    ---是否充电
    local batteryStatus =  DeviceUtils.getBatteryStatus()
	local batteryLevel = DeviceUtils.getBatteryLevel()
	--batteryLevel = 50
    if batteryStatus == true then
		dianchi:getChildByName("Image_dianliangred"):setVisible(false)
		dianchi:getChildByName("Image_dianlianggreen"):setVisible(false)
		dianchi:getChildByName("Image_dianliangchongdian"):setVisible(true)
	elseif batteryLevel <= 25 then
		if batteryLevel <= 0 then
			batteryLevel = 0
		end
		dianchi:getChildByName("Image_dianliangred"):setVisible(true)
		dianchi:getChildByName("Image_dianlianggreen"):setVisible(false)
		dianchi:getChildByName("Image_dianliangchongdian"):setVisible(false)
		dianchi:getChildByName("Image_dianliangred"):setScaleX(batteryLevel/100);
	else
		if batteryLevel >= 100 then
			batteryLevel = 100
		end
		dianchi:getChildByName("Image_dianliangred"):setVisible(false)
		dianchi:getChildByName("Image_dianlianggreen"):setVisible(true)
		dianchi:getChildByName("Image_dianliangchongdian"):setVisible(false)
		dianchi:getChildByName("Image_dianlianggreen"):setScaleX(batteryLevel/100);
		
    end
	
	--时间
	--local time = self.deviceCsb:getChildByName("Panel_bg"):getChildByName("Text_time")
	local date=os.date("%H:%M");
	self.deviceCsb:getChildByName("Panel_bg"):getChildByName("Text_time"):setString(date)
end


--更新信息
function JdnnGameScene:update(dt )
	
		self:updateTable(dt)
		self:updateUserInfo(dt)
		self:updatePlayerBtn(dt)
		--self:updateLiangPai()
		self:updateDeviceInfo(dt)
end


function JdnnGameScene:onExit()
    if self._scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scheduler)
        self._scheduler = nil
    end
	if self.dingzhuang_scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.dingzhuang_scheduler)
        self.dingzhuang_scheduler = nil
    end
	JdnnGameManager:clearLoadedOneGameFiles()
end

----退出房间
function JdnnGameScene:exitGame(issend ,openSecondLayer)

	if issend == nil then
		issend = true
	end
	

    ---释放资源
    local needLoadResArray = JdnnGameScene.getNeedPreloadResArray();
    for i,v in ipairs(needLoadResArray) do
        if string.find(v,".ExportJson") then
        --todo
            ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(v);
        end
    end
	
	if issend == true then
		self.jdnnGameManager:sendPlayerLeave()
	end
    
    --self.brnnGameManager:sendStandUpAndExitRoomMsg()

    --GameManager:getInstance():getMusicAndSoundManager():playerSoundWithFile(HallSoundConfig.Sounds.HallTouch)

    if self._scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scheduler)
        self._scheduler = nil
    end


    --self.brnnGameManager:clearLoadedOneGameFiles()

    local subGameManager = GameManager:getInstance():getHallManager():getSubGameManager();
    subGameManager:onExit();
	
	if openSecondLayer == nil then
		SceneController.goHallScene()
	else
		SceneController.goHallScene(openSecondLayer);
	end
    
	
	
end




return JdnnGameScene