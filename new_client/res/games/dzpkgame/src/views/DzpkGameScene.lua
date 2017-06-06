requireForGameLuaFile("DzpkConfig")
requireForGameLuaFile("DzpkDefine")
requireForGameLuaFile("DZPKPoker")
requireForGameLuaFile("DzpkGameManager")
--local DzpkGameEnd = requireForGameLuaFile("DzpkGameEnd");
local SubGameBaseScene = requireForGameLuaFile("SubGameBaseScene")
local DzpkGameScene = class("DzpkGameScene",SubGameBaseScene);
local scheduler = cc.Director:getInstance():getScheduler()

local playWaitTime = 5


local jiazhuKuaiJie = {
	[1] = {btn = "Button_1",count = 5},
	[2] = {btn = "Button_2",count = 10},
	[3] = {btn = "Button_3",count = 25},
	[4] = {btn = "Button_4",count = 50},
}
--CustomHelper.getFullPath("game_res/mainui/chouma1.png")
local cardTypeImagePath = {
	[DzpkGameManager.CardType.CT_HIGH_CARD] = CustomHelper.getFullPath("game_res/mainui/dz_bq_gp.png"),
	[DzpkGameManager.CardType.CT_ONE_PAIR] = CustomHelper.getFullPath("game_res/mainui/dz_bq_yidui.png"),
	[DzpkGameManager.CardType.CT_TWO_PAIRS] = CustomHelper.getFullPath("game_res/mainui/dz_bq_dz.png"),
	[DzpkGameManager.CardType.CT_THREE_OF_A_KIND] = CustomHelper.getFullPath("game_res/mainui/dz_bq_santiao.png"),
	[DzpkGameManager.CardType.CT_STRAIGHT] = CustomHelper.getFullPath("game_res/mainui/dz_bq_sz.png"),
	[DzpkGameManager.CardType.CT_FLUSH] = CustomHelper.getFullPath("game_res/mainui/dz_bq_th.png"),
	[DzpkGameManager.CardType.CT_FULL_HOUSE] = CustomHelper.getFullPath("game_res/mainui/dz_bq_hl.png"),
	[DzpkGameManager.CardType.CT_FOUR_OF_KIND] = CustomHelper.getFullPath("game_res/mainui/dz_bq_st.png"),
	[DzpkGameManager.CardType.CT_STRAIT_FLUSH] = CustomHelper.getFullPath("game_res/mainui/dz_bq_ths.png"),
	[DzpkGameManager.CardType.CT_ROYAL_FLUSH] = CustomHelper.getFullPath("game_res/mainui/dz_bq_hjths.png"),
	
}

local cardTypeWords = {
	[DzpkGameManager.CardType.CT_HIGH_CARD] = "高牌",
	[DzpkGameManager.CardType.CT_ONE_PAIR] = "一对",
	[DzpkGameManager.CardType.CT_TWO_PAIRS] = "两对",
	[DzpkGameManager.CardType.CT_THREE_OF_A_KIND] = "三条",
	[DzpkGameManager.CardType.CT_STRAIGHT] = "顺子",
	[DzpkGameManager.CardType.CT_FLUSH] = "同花",
	[DzpkGameManager.CardType.CT_FULL_HOUSE] = "葫芦",
	[DzpkGameManager.CardType.CT_FOUR_OF_KIND] = "四条",
	[DzpkGameManager.CardType.CT_STRAIT_FLUSH] = "同花顺",
	[DzpkGameManager.CardType.CT_ROYAL_FLUSH] = "皇家同花顺",
	
}

local heguanBottomPos = {x = 640,y = 562}
local heguanMousePos = {x = 640,y = 664}
local publicCardPosTop 	  = {[1] = {x = 386,y = 410},[2] = {x = 510,y = 410},[3] = {x = 634,y = 410},[4] = {x = 758,y = 410},[5] = {x = 882,y = 410}}
local publicCardPosBottom = {[1] = {x = 386,y = 384},[2] = {x = 510,y = 384},[3] = {x = 634,y = 384},[4] = {x = 758,y = 384},[5] = {x = 882,y = 384}}
--玩家底牌坐标
local playerDiPaiShowInfo = {
	[1] = {[1] = {x = 638,y = 192,rotation = 0},[2] = {x = 730,y = 192,rotation = 0}},
	[2] = {[1] = {x = 151,y = 192,rotation = -5},[2] = {x = 186,y = 192,rotation = 5}},
	[3] = {[1] = {x = 85,y = 397,rotation = -5},[2] = {x = 120,y = 397,rotation = 5}},
	[4] = {[1] = {x = 165,y = 591,rotation = -5},[2] = {x = 195,y = 591,rotation = 5}},
	[5] = {[1] = {x = 1081,y = 591,rotation = -5},[2] = {x = 1116,y = 591,rotation = 5}},
	[6] = {[1] = {x = 1157,y = 388,rotation = -5},[2] = {x = 1192,y = 388,rotation = 5}},
	[7] = {[1] = {x = 1113,y = 184,rotation = -5},[2] = {x = 1148,y = 184,rotation = 5}},
}



--更新玩家信息
local userInfoPos = {
	[1] = {startpos = {x = 405,y = -216},endpos = {x = 405,y = 90}},
	[2] = {startpos = {x = -311,y = -216},endpos = {x = 68,y = 92}},
	[3] = {startpos = {x = -311,y = 296},endpos = {x = 2,y = 300}},
	[4] = {startpos = {x = 141,y = 760},endpos = {x = 82,y = 492}},
	[5] = {startpos = {x = 963,y = 760},endpos = {x = 998,y = 495}},
	[6] = {startpos = {x = 1408,y = 278},endpos = {x = 1075,y = 292}},
	[7] = {startpos = {x = 1408,y = -216},endpos = {x = 1030,y = 88}}

}


--menu按钮坐标
local menuPos = 
{
	["Button_back"] = {startpos = {x = 62,y = 465} ,endpos = {x = 63, y = 378}},
	["Button_huanzhuo"] = {startpos = {x = 62,y = 465} ,endpos = {x = 63, y = 291}},
	["Button_sound"] = {startpos = {x = 62,y = 465} ,endpos = {x = 63, y = 206}},
	["Button_music"] = {startpos = {x = 62,y = 465} ,endpos = {x = 63, y = 117}},
	["Button_help"] = {startpos = {x = 62,y = 465} ,endpos = {x = 63, y = 30}},
	
}


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
function DzpkGameScene:registerNotification()
	
	
	
	
	
	
    self:addOneTCPMsgListener(DzpkGameManager.MsgName.SC_TexasTableInfo);
    self:addOneTCPMsgListener(DzpkGameManager.MsgName.SC_TexasSendPublicCards);
    self:addOneTCPMsgListener(DzpkGameManager.MsgName.SC_TexasSendUserCards);
    self:addOneTCPMsgListener(DzpkGameManager.MsgName.SC_TexasUserAction)
    self:addOneTCPMsgListener(DzpkGameManager.MsgName.SC_TexasNewUser)
    self:addOneTCPMsgListener(DzpkGameManager.MsgName.SC_TexasUserLeave)
    self:addOneTCPMsgListener(DzpkGameManager.MsgName.SC_TexasTableEnd)
	self:addOneTCPMsgListener(DzpkGameManager.MsgName.SC_TexasForceLeave)
	self:addOneTCPMsgListener(DzpkGameManager.MsgName.SC_TexasGiveTips)
	
	self:addOneTCPMsgListener(DzpkGameManager.MsgName.SC_TexasShowCards)
	self:addOneTCPMsgListener(DzpkGameManager.MsgName.SC_TexasShowCardsPermission)
	self:addOneTCPMsgListener(DzpkGameManager.MsgName.SC_ChatTable)
	--self:addOneTCPMsgListener(HallMsgManager.MsgName.SC_StandUpAndExitRoom)
	
    DzpkGameScene.super.registerNotification(self);
	
	
	local dispatcher = cc.Director:getInstance():getEventDispatcher();
	--GFlowerGameScene.super.registerNotification(self)

    local marqueeShowListener =  cc.EventListenerCustom:create(HallMsgManager.kNotifyName_NeedShowMarqueeInfo,function(event) 
       self:showMarqueeTip()
    end);
	self.eventDispatcher:addEventListenerWithSceneGraphPriority(marqueeShowListener,self);
    -----
end

----接收消息
function DzpkGameScene:receiveServerResponseSuccessEvent(event)

	
	print( "receiveServerResponseSuccessEvent")
	dump(event)

    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"];
    if msgName == DzpkGameManager.MsgName.SC_TexasTableInfo then --成功收到demo命令
			
		for i=1, DZPK_MAX_USER do
			
			self:clearFanpaiByChair(i)
		end
		
		
		self:immediatelyPlayerInfo()
        self:immediatelyResetPublicCard()

    elseif msgName == DzpkGameManager.MsgName.SC_TexasSendPublicCards then ---
		self:allChouMaMoveToDiChi()
	
		self:sendPublicCard(userInfo["public_cards"])

    elseif msgName == DzpkGameManager.MsgName.SC_TexasSendUserCards then ---
		--发牌飞行动画 usr
		MusicAndSoundManager:getInstance():playerSoundWithFile("dzpksound/on_turn.mp3")
		
		self:updateLiangPaiNotice()
		
		self:sendPlayerDiPai(userInfo["pb_user"])
    elseif msgName == DzpkGameManager.MsgName.SC_TexasUserAction then ---有玩家操作 信息变化
		
		
		
		--有玩家进行操作
		self:playerOperate(userInfo)

    elseif msgName == DzpkGameManager.MsgName.SC_TexasNewUser then ---
		self:playerIn(userInfo["pb_user"])
    elseif msgName == DzpkGameManager.MsgName.SC_TexasUserLeave then ---
        self:playerOut(userInfo["pb_user"])

		self:clearFanpaiByChair(userInfo["pb_user"].chair)
		
    elseif msgName == DzpkGameManager.MsgName.SC_TexasTableEnd then ---
        self:doEnd()
   
	elseif msgName == DzpkGameManager.MsgName.SC_TexasGiveTips then ---打赏
		self:dashang(userInfo)
	--
	elseif msgName == DzpkGameManager.MsgName.SC_TexasShowCards then
		--翻牌
		self:fanpaiByChair(userInfo["chair"])
		--显示牌型
		self:showCardType(userInfo["chair"],0,3)
		
	elseif msgName == DzpkGameManager.MsgName.SC_TexasShowCardsPermission then
		self.LiangPai = false
	elseif msgName == DzpkGameManager.MsgName.SC_ChatTable then
		self:talk(userInfo)
		
	elseif msgName == DzpkGameManager.MsgName.SC_TexasForceLeave then ---强制离开
	--
		local function  verificationGold(  )
			local betNum = userInfo["num"]
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
	
	
    end


    DzpkGameScene.super.receiveServerResponseSuccessEvent(self,event)
end















---重新连接成功
function DzpkGameScene:callbackWhenReloginAndGetPlayerInfoFinished(event)
    -- body
    print("重新连接成功")
    DzpkGameScene.super.callbackWhenReloginAndGetPlayerInfoFinished(self,event);
   
    --- 尝试直接发送进入游戏消息
    local roomInfo = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab()
    local gameTypeID = roomInfo[HallGameConfig.GameIDKey]
    local roomID = roomInfo[HallGameConfig.SecondRoomIDKey]

    CustomHelper.addIndicationTip(HallUtils:getDescriptionWithKey("entering_gamescene_tip"));
    GameManager:getInstance():getHallManager():getHallMsgManager():sendEnterOneGameMsg(gameTypeID,roomID);
end

--请求失败通知，网络连接状态变化
function DzpkGameScene:callbackWhenConnectionStatusChange(event)
    DzpkGameScene.super.callbackWhenConnectionStatusChange(self,event);
    print("网络断开连接")
end

----收到服务器返回的失败的通知，如果登录失败，密码错误
function DzpkGameScene:receiveServerResponseErrorEvent(event)
    
    local userInfo = event.userInfo;
    local msgName = userInfo["msgName"]

    ---申请上庄失败 允许上庄按钮点击，并且显示界面
    -- if msgName == DzpkGameManager.MsgName.SC_OxForBankerFlag then
    --     if userInfo["result"] == 1 then
    --        MyToastLayer.new(self, "金币不足") 
    --     end
    --     self.bankerOn:setEnabled(true)
    --     self.bankerListOn:setVisible(true)
    -- end

end


----初始化要加载的资源
function DzpkGameScene.getNeedPreloadResArray()
    -- body
    local  res = {
        -- CustomHelper.getFullPath("game_res/zh_brnn_youxiguize.png"),
        -- CustomHelper.getFullPath("game_res/zh_brnn_beijing.png"),
        -- CustomHelper.getFullPath("game_res/zh_brnn_tongsha.png"),
        -- CustomHelper.getFullPath("game_res/zh_brnn_jiesuandi.png "),
        -- CustomHelper.getFullPath("game_res/zh_brnn_shangzhuangdi.png"),
        -- CustomHelper.getFullPath("anim/dkj_brnn_ui/dkj_brnn_ui.ExportJson")
		--ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("public/NN/fanpai_blue/fanpai_blue.ExportJson" )
		CustomHelper.getFullPath("anim/dzpk_px_eff/dzpk_px_eff.ExportJson"),
		CustomHelper.getFullPath("anim/dezhou_supervisor/dezhou_supervisor.ExportJson")
    }
    return res
end



function DzpkGameScene:onEnterTransitionFinish()
    ---发送开始消息
	self.dzpkGameManager:sendPlayerReconnection()
end

function DzpkGameScene:initVersion()
	local bgnode = self.csNode:getChildByName("Panel_bg")
	bgnode:getChildByName("Text_version"):setString("1.3")
end


function DzpkGameScene:ctor()

   
    ---初始化数据对象
    self.dzpkGameManager = DzpkGameManager:getInstance();

    DzpkGameScene.super.ctor(self);

    ---初始化界面
    local csNodePath = CustomHelper.getFullPath("dzpkGameLayerCCS.csb")
    self.csNode = cc.CSLoader:createNode(csNodePath)
    self:addChild(self.csNode)
	
	--[[
	self:runAction(cc.Sequence:create(
            cc.DelayTime:create(2),
			
			cc.CallFunc:create(
					function()
						---发送开始消息
						self.dzpkGameManager:sendPlayerReconnection()
					end
				)
			
			
            ))
	--
	--]]
	
	--初始化加注界面
	self:initJiazhuOperate()

	--重置玩家信息位置
	self:resetUserInfo()
	
	--初始化操作按钮
	self:initMyBtn()
	
	--初始化版本
	self:initVersion()
	
	--重置欲操作
	self:clearWillOperate()
	
	--清除之前的公共牌信息
	self:clearPublicCard()
	
	--初始化按钮
	self:initMenu()
	
	--初始化荷官
	self:initHeGuan()
	
	--初始化跑马灯
	self:initMarquee()

    ---背景音乐
    --MusicAndSoundManager:getInstance():playMusicWithFile("brnnSound/"..gameDzpk.Sound.brnnBg, true)
	
	self._scheduler = scheduler:scheduleScriptFunc(function(dt)
            self:update(dt)
            end, 0.02, false);
	--self:update(0)

    GameManager:getInstance():getHallManager():getPlayerInfo():setGamingInfoTab(nil)
	
	

	---背景音乐
    MusicAndSoundManager:getInstance():playMusicWithFile("dzpksound/back.mp3", true)
	
end

--初始化跑马灯
function DzpkGameScene:initMarquee()
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
function DzpkGameScene:showMarqueeTip()
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


--[[
--menu按钮坐标
local menuPos = 
{
	["Button_back"] = {startpos = {x = 62,y = 465} ,endpos = {x = 63, y = 378}},
	["Button_huanzhuo"] = {startpos = {x = 62,y = 465} ,endpos = {x = 63, y = 291}},
	["Button_sound"] = {startpos = {x = 62,y = 465} ,endpos = {x = 63, y = 206}},
	["Button_music"] = {startpos = {x = 62,y = 465} ,endpos = {x = 63, y = 117}},
	["Button_help"] = {startpos = {x = 62,y = 465} ,endpos = {x = 63, y = 30}},
	
}
--]]

--初始化荷官
function DzpkGameScene:initHeGuan()
	self.heguanArm = ccs.Armature:create("dezhou_supervisor")
	self.heguanArm:getAnimation():setMovementEventCallFunc(function(sender, _type, id)
		if _type == ccs.MovementEventType.start then
		elseif _type == ccs.MovementEventType.complete then
			--self.heguanArm:removeFromParent()
			--[[
			if id == "kiss" then
				self.heguanArm:getAnimation():play("stay")
			elseif id == "wait" then
				self.heguanArm:getAnimation():play("stay")
			elseif id == "showhand" then
				self.heguanArm:getAnimation():play("stay")
			elseif id == "stay" then
				self.heguanArm:getAnimation():play("stay")
			end
			--]]
			local time = self.dzpkGameManager:getDataManager():getThinkTime()
			if time > 0 and time <= playWaitTime then
				self.heguanArm:getAnimation():play("wait",-1,0)
			else
				self.heguanArm:getAnimation():play("stay",-1,0)
			end
			
			
		elseif _type == 2 then
		end
	end)
	self.heguanArm:getAnimation():play("stay",-1,0)
	local userlistCCS = self.csNode:getChildByName("Panel_middle")--
	userlistCCS:addChild(self.heguanArm)
	self.heguanArm:setPosition( cc.p(640,620))
	self.heguanArm:setScale(0.7)
end

myPlayTime = {}
function DzpkGameScene:playsound(sound,deltime)
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


function DzpkGameScene:onThinkTimeChanged(lastTime,curTime,ismy)
	
	if lastTime <= 0 then
		return
	end
	
	local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
	if tableinfo == nil or tableinfo.think_time <= 0 then
		return
	end
	if lastTime <= 0 or curTime <= 0 then
		return
	end
	
	local lastpercent = lastTime/tableinfo.think_time
	local curpercent = curTime/tableinfo.think_time
	if lastTime >= playWaitTime and curTime < playWaitTime then
		self.heguanArm:getAnimation():play("wait",-1,0)
	elseif lastTime > playWaitTime and curTime > playWaitTime then
		
		local movementid = self.heguanArm:getAnimation():getCurrentMovementID()
		if movementid == "wait" then
			self.heguanArm:getAnimation():play("stay",-1,0)
		end
		
	end
	
	--手指声音
	if curTime < playWaitTime and curTime > 0 then
		self:playsound("dzpksound/qiaozhuo.mp3")
	end
	
	if ismy == true then
		if lastpercent >= 1 then
			MusicAndSoundManager:getInstance():playerSoundWithFile("dzpksound/time.mp3")
		elseif lastpercent >=0.5 and curpercent < 0.5 then
			MusicAndSoundManager:getInstance():playerSoundWithFile("dzpksound/time_half.mp3")
		end
	end
	
	
	
	
end



--展开按钮 动画
function DzpkGameScene:zhankaiMenuAnim(speed)
	
	if speed == nil then
		speed = 1200
	end
	
	local menunode = self.csNode:getChildByName("Panel_menu")
	
	local zhedie = menunode:getChildByName("Button_zhankai")
	zhedie:loadTextures(CustomHelper.getFullPath("game_res/mainui/dz_button_shangla_normal.png"),
						CustomHelper.getFullPath("game_res/mainui/dz_button_shangla_pressed.png"),
						CustomHelper.getFullPath("game_res/mainui/dz_button_shangla_pressed.png"))
	
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
function DzpkGameScene:zhedieMenuAnim(speed)

	if speed == nil then
		speed = 1200
	end
	
	
	local menunode = self.csNode:getChildByName("Panel_menu")
	
	local zhedie = menunode:getChildByName("Button_zhankai")
	zhedie:loadTextures(CustomHelper.getFullPath("game_res/mainui/dz_button_xiala_normal.png"),
						CustomHelper.getFullPath("game_res/mainui/dz_button_xiala_pressed.png"),
						CustomHelper.getFullPath("game_res/mainui/dz_button_xiala_pressed.png"))
	
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
function DzpkGameScene:initMenu()
	local menunode = self.csNode:getChildByName("Panel_menu")
	
	local zhedie = menunode:getChildByName("Button_zhankai")
	zhedie.state = 0 --0:当前为折叠状态  1:当前为展开状态
	self:zhedieMenuAnim(100000)
	
	zhedie:addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			MusicAndSoundManager:getInstance():playerSoundWithFile("dzpksound/button.mp3")
			
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
			
			MusicAndSoundManager:getInstance():playerSoundWithFile("dzpksound/button.mp3")
			
			
			local users = self.dzpkGameManager:getDataManager():getUserInfoList()
			local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
			local myinfo = self.dzpkGameManager:getDataManager():getMyInfo()
			if tableinfo == nil or users == nil or myinfo == nil then
				return
			end
			if myinfo.action ~= nil and (myinfo.action == DzpkGameManager.TexasAction.ACT_WAITING or 
											myinfo.action == DzpkGameManager.TexasAction.ACT_FOLD) then
				
				self:exitGame()
			elseif tableinfo.state == DzpkGameManager.TexasStatus.STATUS_WAITING or 
					tableinfo.state == DzpkGameManager.TexasStatus.STATUS_SHOW_DOWN then
				self:exitGame()	
					
			else
				CustomHelper.showAlertView(
				   "此时离开本局已经下注的筹码不能收回,确定要离开吗？",
				   true,
				   true,
				   function(tipLayer)
					   tipLayer:removeFromParent()
				   end,
				   function(tipLayer)
					   
					MusicAndSoundManager:getInstance():playerSoundWithFile("dzpksound/tuichu.mp3")
					self:exitGame()
						tipLayer:removeFromParent()
			   end)
			end
			
			
		
		
		end
    end)
	
	--换桌
	menunode:getChildByName("Button_huanzhuo"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			MusicAndSoundManager:getInstance():playerSoundWithFile("dzpksound/button.mp3")
			
			
			local users = self.dzpkGameManager:getDataManager():getUserInfoList()
			local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
			local myinfo = self.dzpkGameManager:getDataManager():getMyInfo()
			if tableinfo == nil or users == nil or myinfo == nil then
				return
			end
			if myinfo.action ~= nil and myinfo.action == DzpkGameManager.TexasAction.ACT_WAITING then
				
				self.dzpkGameManager:sendChangeTable()
			else
				CustomHelper.showAlertView(
				   "此时换桌已经下注的筹码不能收回,确定要换桌吗？",
				   true,
				   true,
				   function(tipLayer)
					   tipLayer:removeFromParent()
				   end,
				   function(tipLayer)
					   self.dzpkGameManager:sendChangeTable()
						tipLayer:removeFromParent()
				   end)
			end
			
			
			
			
			
			--self.dzpkGameManager:sendPlayerLeave()
			
			--self.dzpkGameManager:sendPlayerReconnection()
		end
    end)
	
	--[[
--得到音乐开关状态
function MusicAndSoundManager:getMusicSwitch()
    return cc.UserDefault:getInstance():getBoolForKey("music_switch", true)
end
--设置音乐开关
function MusicAndSoundManager:setMusicSwitch(open)
    cc.UserDefault:getInstance():setBoolForKey("music_switch", open)
end
--得到音效开关
function MusicAndSoundManager:getSoundSwitch()
    return cc.UserDefault:getInstance():getBoolForKey("sound_switch", true)
end
--设置音效开关
function MusicAndSoundManager:setSoundSwitch(open)
    cc.UserDefault:getInstance():setBoolForKey("sound_switch", open)
end
	
	--]]
	

	--GameManager:getInstance():getMusicAndSoundManager():getMusicSwitch()
	
	local function updateSound()
		if GameManager:getInstance():getMusicAndSoundManager():getSoundSwitch() == true then
			menunode:getChildByName("Button_sound"):loadTextures(	CustomHelper.getFullPath("game_res/mainui/dz_button_yinxiao_kai_normal.png"),
																	CustomHelper.getFullPath("game_res/mainui/dz_button_yinxiao_kai_pressed.png"),
																	CustomHelper.getFullPath("game_res/mainui/dz_button_yinxiao_kai_pressed.png"))
		else
			menunode:getChildByName("Button_sound"):loadTextures(	CustomHelper.getFullPath("game_res/mainui/dz_button_yinxiao_guan_normal.png"),
																	CustomHelper.getFullPath("game_res/mainui/dz_button_yinxiao_guan_pressed.png"),
																	CustomHelper.getFullPath("game_res/mainui/dz_button_yinxiao_guan_pressed.png"))
		end
	end
	local function updateMusic()
		if GameManager:getInstance():getMusicAndSoundManager():getMusicSwitch() == true then
			menunode:getChildByName("Button_music"):loadTextures(	CustomHelper.getFullPath("game_res/mainui/dz_button_yinyue_kai_normal.png"),
																	CustomHelper.getFullPath("game_res/mainui/dz_button_yinyue_kai_pressed.png"),
																	CustomHelper.getFullPath("game_res/mainui/dz_button_yinyue_kai_pressed.png"))
		else
			menunode:getChildByName("Button_music"):loadTextures(	CustomHelper.getFullPath("game_res/mainui/dz_button_yinyue_guan_normal.png"),
																	CustomHelper.getFullPath("game_res/mainui/dz_button_yinyue_guan_pressed.png"),
																	CustomHelper.getFullPath("game_res/mainui/dz_button_yinyue_guan_pressed.png"))
		end
	end
	
	updateSound()
	updateMusic()
	--音效
	menunode:getChildByName("Button_sound"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			MusicAndSoundManager:getInstance():playerSoundWithFile("dzpksound/button.mp3")
			
			GameManager:getInstance():getMusicAndSoundManager():setSoundSwitch( not GameManager:getInstance():getMusicAndSoundManager():getSoundSwitch())
			updateSound()
		end
    end)
	
	--音乐
	menunode:getChildByName("Button_music"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			MusicAndSoundManager:getInstance():playerSoundWithFile("dzpksound/button.mp3")
			local musicOn = not GameManager:getInstance():getMusicAndSoundManager():getMusicSwitch()
			GameManager:getInstance():getMusicAndSoundManager():setMusicSwitch( musicOn)
			if musicOn == true then
				--GameManager:getInstance():getMusicAndSoundManager():pauseMusic()
				MusicAndSoundManager:getInstance():playMusicWithFile("dzpksound/back.mp3", true)
			else
				GameManager:getInstance():getMusicAndSoundManager():stopMusic()
			end
			updateMusic()
		end
    end)
	
	--帮助
	menunode:getChildByName("Button_help"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			MusicAndSoundManager:getInstance():playerSoundWithFile("dzpksound/popup.mp3")
			
			local _gameTipsLayer = requireForGameLuaFile("DzpkGameTips");
			self.gameTipsLayer = _gameTipsLayer:create()
			
			--self.gameTipsLayer:setguizeTexture(self.brnnGameManager.gameDetailInfoTab["second_game_type"])
			
			self:addChild(self.gameTipsLayer, 100)
			
		end
    end)
	
	--聊天
	menunode:getChildByName("Button_talk"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			--MusicAndSoundManager:getInstance():playerSoundWithFile("dzpksound/button.mp3")
			--
			local _gameTalk = requireForGameLuaFile("DzpkGameTalk");
			local function sendmessage(key,str)
				local a = 0
				self.dzpkGameManager:sendChatMsg(key.."|"..str)
			end
			
			self.gameTalk = _gameTalk:create(sendmessage)
			
			self:addChild(self.gameTalk, 100)
		end
    end)

	
end





--初始化加注界面
function DzpkGameScene:initJiazhuOperate()
	
	local csNodePath = CustomHelper.getFullPath("dzpk_jiazhu.csb")
	self.jiazhuNode = cc.CSLoader:createNode(csNodePath)
	self.csNode:addChild(self.jiazhuNode)
	self.jiazhuNode:setVisible(false)
	
	local panel = self.jiazhuNode:getChildByName("Panel_bg")

	for k,v in ipairs(jiazhuKuaiJie) do
		
		panel:getChildByName(v.btn):addTouchEventListener(function (sender, eventType)
			if eventType == ccui.TouchEventType.ended then
				local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
				local money = tableinfo.blind_bet*v.count
				self.dzpkGameManager:sendPlayerOperate(DzpkGameManager.TexasAction.ACT_RAISE,money)
				
				self.jiazhuNode:setVisible(false)
			end
		end)
	end
	
	
	
	--取消
	panel:getChildByName("Button_cancel"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			
			self.jiazhuNode:setVisible(false)
		end
    end)
	
	--加注
	panel:getChildByName("Button_jia"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local money = self.jiazhuNode.addnum
			self.dzpkGameManager:sendPlayerOperate(DzpkGameManager.TexasAction.ACT_RAISE,money)
			self.jiazhuNode:setVisible(false)
		end
    end)

end


--弹出加注界面
function DzpkGameScene:popJiazhuOperate()
	
	local users = self.dzpkGameManager:getDataManager():getUserInfoList()
	local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
	if tableinfo == nil or users == nil then
		return
	end
	
	self.jiazhuNode:setVisible(true)
	--大芒
	local damang = tableinfo.blind_bet
	
	
	
	
	
	
	--当前桌面最大注
	local maxBet = self.dzpkGameManager:getDataManager():getUserMaxBet_money()
	
	--当轮自己下注
	local myBet = self.dzpkGameManager:getDataManager():getMyBet_money()
	
	--范围
	local jiazhuMinBet = maxBet-myBet+damang
	local max = tableinfo.pot
	local myinfo = self.dzpkGameManager:getDataManager():getUserInfoByChair(tableinfo.own_chair)
	if max > myinfo.money then
		max = myinfo.money
	end
	
	local panel = self.jiazhuNode:getChildByName("Panel_bg")
	panel:getChildByName("Image_4"):setVisible(false)
	if jiazhuMinBet >= myinfo.money then
		jiazhuMinBet = myinfo.money
		panel:getChildByName("Image_4"):setVisible(true)
	end
	
	local jiazhuMaxBet = max
	if jiazhuMaxBet <= jiazhuMinBet then
		jiazhuMaxBet = jiazhuMinBet
	end
	
	 
	
	--快捷加注
	for k,v in ipairs(jiazhuKuaiJie) do
		--local t1 = self.jiazhuNode:getChildByName(v.btn):getChildByName("Text_1")
		--local str1 = CustomHelper.moneyShowStyleNone(damang*v.count)
		
		panel:getChildByName(v.btn):getChildByName("Text_1"):setString( CustomHelper.moneyShowStyleNone(damang*v.count))
		
		if damang*v.count >= jiazhuMinBet then
			if damang*v.count <= jiazhuMaxBet then
				--panel:getChildByName(v.btn):setTouchEnabled(true)
				panel:getChildByName(v.btn):setEnabled(true)
			else
				panel:getChildByName(v.btn):setEnabled(false)
				--panel:getChildByName(v.btn):setTouchEnabled(false)
			end
			
		else
			panel:getChildByName(v.btn):setEnabled(false)
			--panel:getChildByName(v.btn):setTouchEnabled(false)
		end
		
	end
	
	--加注具体数值
	self.jiazhuNode.addnum = jiazhuMinBet
	panel:getChildByName("Button_jia"):getChildByName("Text_1"):setString( CustomHelper.moneyShowStyleNone(jiazhuMinBet))
	panel:getChildByName("Slider_1"):setPercent(0)
	

	
	
	panel:getChildByName("Slider_1"):addEventListener( 
		function(sender,eventType)
			if eventType == ccui.SliderEventType.percentChanged then
				local curPercent = sender:getPercent()
				local bet = math.ceil((jiazhuMaxBet-jiazhuMinBet)/100*curPercent+jiazhuMinBet)
				
				panel:getChildByName("Button_jia"):getChildByName("Text_1"):setString(CustomHelper.moneyShowStyleNone( bet ))
				
				
				self.jiazhuNode.addnum = bet
				
				local myinfo = self.dzpkGameManager:getDataManager():getUserInfoByChair(tableinfo.own_chair)
				if bet >= myinfo.money then
					panel:getChildByName("Image_4"):setVisible(true)
				else
					panel:getChildByName("Image_4"):setVisible(false)
				end
				
			elseif eventType == ccui.SliderEventType.slideBallDown then
				
			elseif eventType == ccui.SliderEventType.slideBallUp then
				
				
			elseif eventType == ccui.SliderEventType.slideBallCancel then
				
			end
		end
		)
	

end



function DzpkGameScene:createChouMaSprite(num)
	
	--local chouma  = cc.Sprite:create(CustomHelper.getFullPath("game_res/mainui/chouma"..num..".png"))
	local chouma  = cc.Sprite:create(CustomHelper.getFullPath("game_res/mainui/chouma1.png"))
	local userlistCCS = self.csNode:getChildByName("Panel_middle")
	userlistCCS:addChild(chouma,100)
	return chouma
end

--[[
--动作类型
DzpkGameManager.TexasAction = 
{
	ACT_CALL 	= 1,--跟注
	ACT_RAISE 	= 2,--加注
	ACT_CHECK 	= 3,--让牌
	ACT_FOLD 	= 4,--弃牌
	ACT_ALL_IN 	= 5,--全下
	ACT_NORMAL 	= 6,--普通
	ACT_THINK 	= 7,
	ACT_WAITING	= 8--刚进入的玩家
}
--]]
local operateSound = {
	[1] = {
			[DzpkGameManager.TexasAction.ACT_CALL] = "dzpksound/say_boy/call_boy.mp3",
			[DzpkGameManager.TexasAction.ACT_RAISE] = "dzpksound/say_boy/raise_boy.mp3",
			[DzpkGameManager.TexasAction.ACT_CHECK] = "dzpksound/say_boy/chech_boy.mp3",
			[DzpkGameManager.TexasAction.ACT_FOLD] = "dzpksound/say_boy/fold_boy.mp3",
			[DzpkGameManager.TexasAction.ACT_ALL_IN] = "dzpksound/say_boy/allin_boy.mp3"
		  },
	[2] = {
			[DzpkGameManager.TexasAction.ACT_CALL] = "dzpksound/say_girl/call_girl.mp3",
			[DzpkGameManager.TexasAction.ACT_RAISE] = "dzpksound/say_girl/raise_girl.mp3",
			[DzpkGameManager.TexasAction.ACT_CHECK] = "dzpksound/say_girl/chech_girl.mp3",
			[DzpkGameManager.TexasAction.ACT_FOLD] = "dzpksound/say_girl/fold_girl.mp3",
			[DzpkGameManager.TexasAction.ACT_ALL_IN] = "dzpksound/say_girl/allin_girl.mp3"
		  }
}


local talkSound = {
	[1] = {
			[1] = "dzpksound/talk/m_1.mp3",
			[2] = "dzpksound/talk/m_2.mp3",
			[3] = "dzpksound/talk/m_3.mp3",
			[4] = "dzpksound/talk/m_4.mp3",
			[5] = "dzpksound/talk/m_5.mp3",
			[6] = "dzpksound/talk/m_6.mp3",
			[7] = "dzpksound/talk/m_7.mp3",
			[8] = "dzpksound/talk/m_8.mp3"
		  },
	[2] = {
			[1] = "dzpksound/talk/f_1.mp3",
			[2] = "dzpksound/talk/f_2.mp3",
			[3] = "dzpksound/talk/f_3.mp3",
			[4] = "dzpksound/talk/f_4.mp3",
			[5] = "dzpksound/talk/f_5.mp3",
			[6] = "dzpksound/talk/f_6.mp3",
			[7] = "dzpksound/talk/f_7.mp3",
			[8] = "dzpksound/talk/f_8.mp3"
		  }
}

function DzpkGameScene:playerOperateSound(action,chair)
	
	local playerinfo = self.dzpkGameManager:getDataManager():getUserInfoByChair(chair)
	local isman = PlayerInfo:getIsMaleByHeadIconNum( CustomHelper.tonumber(playerinfo.icon))
	local sex = 1
	if isman == false then
		sex = 2
	end
	
	local sound = operateSound[sex][action]
	if sound ~= nil then
		MusicAndSoundManager:getInstance():playerSoundWithFile(sound)
	end
end


--玩家操作

function DzpkGameScene:playerOperate(userInfo)
	local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
	--当轮到自己思考的时候 执行欲操作
	if userInfo["chair"] == tableinfo.own_chair then
		if userInfo["action"] == DzpkGameManager.TexasAction.ACT_THINK then
			self:doWillOperate()
			return
		end
	end
	
	self:playerOperateSound(userInfo["action"],userInfo["chair"])

	--如果是跟注，加注，全下的情况飞筹码
	if userInfo["action"] == DzpkGameManager.TexasAction.ACT_CALL 
	or userInfo["action"] == DzpkGameManager.TexasAction.ACT_RAISE 
	or userInfo["action"] == DzpkGameManager.TexasAction.ACT_ALL_IN then
		
		
		--MusicAndSoundManager:getInstance():playerSoundWithFile("dzpksound/tuichu.mp3")
		if userInfo["action"] == DzpkGameManager.TexasAction.ACT_ALL_IN then
			MusicAndSoundManager:getInstance():playerSoundWithFile("dzpksound/chip_fly.mp3")
			
		end
		
		
		
		local player = self.dzpkGameManager:getDataManager():getUserInfoByChair(userInfo["chair"])
		
		local playerNode = self:getUserInfoNodeFromChairid(userInfo["chair"])
		local startpos = playerNode:getChildByName("headicon"):convertToWorldSpace(cc.p(0,0))
		local endpos = playerNode:getChildByName("Panel_chouma"):getChildByName("Image_icon"):convertToWorldSpace(cc.p(0,0))

		local chouma  = self:createChouMaSprite(userInfo["bet_money"])
		chouma:setPosition(startpos)
		
		chouma:runAction(
				cc.Sequence:create(
				cc.MoveTo:create(0.2, endpos),
				cc.CallFunc:create(function(sender)
					playerNode:getChildByName("Panel_chouma"):setScale(1)
					chouma:removeFromParent()
				end)))
		--判断本玩家本轮是否已经下过筹码
		if player.bet_money <= userInfo["bet_money"] then
			playerNode:getChildByName("Panel_chouma"):setScale(0)
		end
	--如果是弃牌
	elseif userInfo["action"] == DzpkGameManager.TexasAction.ACT_FOLD then
		local player = self.dzpkGameManager:getDataManager():getUserInfoByChair(userInfo["chair"])
		
		local playerNode = self:getUserInfoNodeFromChairid(userInfo["chair"])
		local startpos = playerNode:getChildByName("Image_dipai"):convertToWorldSpace(cc.p(0,0))
		local endpos = {x = 640,y = 360}
		
		local middlenode = self.csNode:getChildByName("Panel_middle")
		local t1 = cc.Sprite:create(CustomHelper.getFullPath("game_res/mainui/dz_duipai.png"))
		middlenode:addChild(t1,100)
		t1:setPosition(startpos)
		
		t1:runAction(
			cc.Sequence:create(
			cc.MoveTo:create(0.2, endpos),
			cc.CallFunc:create(function(sender)
				
				
				--如果是自己
				--[[if v.chair == tableinfo.own_chair then
					self:fanpaiByChair(tableinfo.own_chair)
				end--]]
				
				
				t1:removeFromParent()
			end)))
		MusicAndSoundManager:getInstance():playerSoundWithFile("dzpksound/fold_pai.mp3")
		--local userlistCCS = self.csNode:getChildByName("Panel_middle")
		--userlistCCS:addChild(t1,100)
		
	end


end






--清除之前的公共牌信息
function DzpkGameScene:clearPublicCard()
	
	if self.publicCard == nil then
		self.publicCard = {}
	end

	for k,v in ipairs(self.publicCard) do
		
		v:removeFromParent()
	end
	
	self.publicCard = {}
end

--设置公共牌的终点位置
function DzpkGameScene:setPublicCardEndPos()
	
	local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
	
	if tableinfo == nil then
		return
	end
	
	if self.publicCard == nil then
		return
	end
	--根据边池个数调整公牌位置
	local endpos = publicCardPosTop
	if tableinfo.side_pot ~= nil and #tableinfo.side_pot > 3 then
		endpos = publicCardPosBottom
	end

	--设置位置
	for k,v in ipairs(self.publicCard) do
		v:stopAllActions()
		v:setScale(0.6)
		v:setOpacity(255)
		v:setPosition(endpos[k])
	end
	
end

--公共牌发牌动画
function DzpkGameScene:sendPublicCardAction(count,poker,delaytime)
	if delaytime == nil then
		delaytime = 0.001
	end
	poker:setScale(0)
	poker:setOpacity(0)
	poker:setPosition(heguanBottomPos)
	
	--根据边池个数调整公牌位置
	local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
	local endpos = publicCardPosTop
	if tableinfo.side_pot ~= nil and #tableinfo.side_pot > 3 then
		endpos = publicCardPosBottom
	end
	
	poker:runAction(cc.Sequence:create(
            cc.DelayTime:create(delaytime),
			cc.ScaleTo:create(0.5,0.6,0.6)
            ))
	poker:runAction(cc.Sequence:create(
            cc.DelayTime:create(delaytime),
			cc.FadeIn:create(0.5)
            ))
	poker:runAction(cc.Sequence:create(
            cc.DelayTime:create(delaytime),
			
			cc.CallFunc:create(function()
				MusicAndSoundManager:getInstance():playerSoundWithFile("dzpksound/fapai_a.mp3")
				
			end),
			--
			
			cc.MoveTo:create(0.5, endpos[count])
            ))
	
end

--发公共牌
function DzpkGameScene:sendPublicCard(cards)
	if self.publicCard == nil then
		self.publicCard = {}
	end
	local num = #self.publicCard
	if num >= 5 then
		print("牌发多了")
		return
	end
	
	self:setPublicCardEndPos()

	local middleCCS = self.csNode:getChildByName("Panel_middle")
	local isfapai = false
	for k,v in ipairs(cards) do
		local pokercard = DZPKPoker.new(true, v)
		pokercard:setScale(0.6)
		middleCCS:addChild(pokercard,100)
		self.publicCard[num+k] = pokercard
		
		self:sendPublicCardAction(num+k,pokercard,0.5+k*0.1)
		isfapai = true
	end
	
	if isfapai == true then
		self.heguanArm:getAnimation():play("showhand",-1,0)
	end
	
	
	
end


--新玩家进入
function DzpkGameScene:playerIn(user)
	
	local v = user
	
	local uNode = self:getUserInfoNodeFromChairid(v.chair)
	if uNode ~= nil then
		uNode:setPosition( uNode.startpos )
		
		uNode:runAction(
				cc.Sequence:create(
				cc.MoveTo:create(0.3, uNode.endpos),
				cc.CallFunc:create(function(sender)
					
				end)))
		
	end
	
end

--玩家离开
function DzpkGameScene:playerOut(user)
	
	local v = user
	
	local uNode = self:getUserInfoNodeFromChairid(v.chair)
	if uNode ~= nil then
		uNode:setPosition( uNode.endpos )
		
		uNode:runAction(
				cc.Sequence:create(
				cc.MoveTo:create(0.3, uNode.startpos),
				cc.CallFunc:create(function(sender)
					
				end)))
				
		self:choumaMoveToDiChi(v.chair)
		
	end
	
end
--[[
local anpos = {[1] = {x = 328, y = 375},[2] = {x = 404, y = 328},[3] = {x = 872, y = 328},[4] = {x = 953, y = 375}}
local aniFile = "dkj_brnn_ui"
local aniName = "ani_0"..an[i]

local node = ccs.Armature:create(aniFile)
node:getAnimation():setMovementEventCallFunc(function(sender, _type, id)
	if _type == ccs.MovementEventType.start then
	elseif _type == ccs.MovementEventType.complete then
		node:removeFromParent()
	elseif _type == 2 then
	end
end)
node:getAnimation():play(aniName)
self._table:addChild(node)
node:setPosition(anpos[i])
--]]


--赢家动画
function DzpkGameScene:createWinAnim(chair)
	local userInfo = self.dzpkGameManager:getDataManager():getUserInfoByChair(chair)
	if userInfo == nil then
		return
	end

	--头像上的动画
	local userNode = self:getUserInfoNodeFromChairid(chair)

	local consize = userNode:getChildByName("Image_headbg"):getContentSize()
	
	local pos1 = userNode:getChildByName("Image_headbg"):convertToWorldSpace(cc.p(consize.width/2,consize.height/2))
	
	print("------------x:"..pos1.x.."--------y:"..pos1.y)
	--pos1 = cc.pAdd(pos1,cc.p(-10,))
	
	local node = ccs.Armature:create("dzpk_px_eff")
	node:getAnimation():setMovementEventCallFunc(function(sender, _type, id)
		if _type == ccs.MovementEventType.start then
		elseif _type == ccs.MovementEventType.complete then
			node:removeFromParent()
		elseif _type == 2 then
		end
	end)
	node:getAnimation():play("ani_07")
	--node:setAnchorPoint( cc.p(0.5,0.5))
	local userlistCCS = self.csNode:getChildByName("Panel_middle")--
	userlistCCS:addChild(node,10000)
	node:setPosition(pos1)
	
	
end

--牌型动画
function DzpkGameScene:cardTypeAnim(cardType)
	
	if cardType == nil or cardType < DzpkGameManager.CardType.CT_STRAIGHT or cardType > DzpkGameManager.CardType.CT_ROYAL_FLUSH then
		return
	end
	
	
	local node = ccs.Armature:create("dzpk_px_eff")
	node:getAnimation():setMovementEventCallFunc(function(sender, _type, id)
		if _type == ccs.MovementEventType.start then
		elseif _type == ccs.MovementEventType.complete then
			node:removeFromParent()
		elseif _type == 2 then
		end
	end)
	local aninum = {
		[DzpkGameManager.CardType.CT_STRAIGHT] = "ani_06",
		[DzpkGameManager.CardType.CT_FLUSH] = "ani_05",
		[DzpkGameManager.CardType.CT_FULL_HOUSE] = "ani_04",
		[DzpkGameManager.CardType.CT_FOUR_OF_KIND] = "ani_03",
		[DzpkGameManager.CardType.CT_STRAIT_FLUSH] = "ani_02",
		[DzpkGameManager.CardType.CT_ROYAL_FLUSH] = "ani_01"
	}
	node:getAnimation():play(aninum[cardType])
	local userlistCCS = self.csNode:getChildByName("Panel_middle")--
	userlistCCS:addChild(node,1000)
	node:setPosition( cc.p(1280/2,720/2) )
	
	
end


--主池飞筹码
function DzpkGameScene:zhuchiChoumaFlyToPlayer(chair,delay)
	local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
	
	local uNode = self:getUserInfoNodeFromChairid(chair)
	if uNode ~= nil then
		local startpos = self:getDiChiIconPos()
		local endpos = uNode:getChildByName("headicon"):convertToWorldSpace(cc.p(0,0))
		
		for i=1, 3 do
			local chouma = self:createChouMaSprite(num)
			chouma:setPosition(startpos)
			chouma:runAction(
				cc.Sequence:create(
				cc.DelayTime:create(delay+0.1*i),
				cc.MoveTo:create(0.3, endpos),
				cc.CallFunc:create(function(sender)
					
					chouma:removeFromParent()
				end)))
		end
	end
end
--边池飞筹码
function DzpkGameScene:bianchiChoumaFlyToPlayer(bianchinum,chair,delay)
	local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
	
	local uNode = self:getUserInfoNodeFromChairid(chair)
	if uNode ~= nil then
		
		local userlistCCS = self.csNode:getChildByName("Panel_middle")--
		
		local startpos = userlistCCS:getChildByName("Panel_cmc"):getChildByName("Panel_youbianchi2"):getChildByName("Image_bianchi_"..(bianchinum-1)):convertToWorldSpace(cc.p(0,0))
		local endpos = uNode:getChildByName("headicon"):convertToWorldSpace(cc.p(0,0))
		
		for i=1, 3 do
			local chouma = self:createChouMaSprite(num)
			chouma:setPosition(startpos)
			chouma:runAction(
				cc.Sequence:create(
				cc.DelayTime:create(delay+0.1*i),
				cc.MoveTo:create(0.3, endpos),
				cc.CallFunc:create(function(sender)
					
					chouma:removeFromParent()
				end)))
		end
	end
end

--结算数字Panel_winmoney
function DzpkGameScene:showWinMoney(chair,delay,time)

	local playerinfo = self.dzpkGameManager:getDataManager():getUserInfoByChair(chair)
	if playerinfo == nil then
		return
	end
	
	
	local userlistCCS = self.csNode:getChildByName("Panel_middle")

	local uNode = self:getUserInfoNodeFromChairid(chair)
	if uNode ~= nil then
		local pos1 = uNode:convertToWorldSpace(cc.p(0,0))
		
		local showNode = userlistCCS:getChildByName("Panel_winmoney"):clone()
		userlistCCS:addChild(showNode,1000)
		showNode:setPosition(pos1)
		showNode:setVisible(false)
		
		showNode:getChildByName("Text_win"):setString("+"..CustomHelper.moneyShowStyleNone(playerinfo.win_money))
		showNode:getChildByName("Text_shui"):setString("税收:"..CustomHelper.moneyShowStyleNone(playerinfo.tax))
		
		showNode:runAction(
			cc.Sequence:create(
			cc.DelayTime:create(delay),
			cc.CallFunc:create(function(sender)
				
				showNode:setVisible(true)
			end),
			cc.DelayTime:create(time-delay),
			cc.CallFunc:create(function(sender)
				
				showNode:removeFromParent()
			end)
			))
		
	end
end

--显示牌型
function DzpkGameScene:showCardType(chair,delay,time)

	local userlistCCS = self.csNode:getChildByName("Panel_middle")--
	local playerinfo = self.dzpkGameManager:getDataManager():getUserInfoByChair(chair)
	if playerinfo.cards_type == nil then
		return
	end
	
	local uNode = self:getUserInfoNodeFromChairid(chair)
	if uNode ~= nil then
		
		local consize = uNode:getChildByName("Image_paixing"):getContentSize()
	
		local pos1 = uNode:getChildByName("Image_paixing"):convertToWorldSpace(cc.p(consize.width/2,consize.height/2))
		
		local paixing  = cc.Sprite:create( cardTypeImagePath[playerinfo.cards_type])
		local userlistCCS = self.csNode:getChildByName("Panel_middle")
		userlistCCS:addChild(paixing,10000)
		paixing:setPosition( pos1)
		paixing:setVisible(false)
		paixing:setAnchorPoint( cc.p(0.5,0.5))
		
		paixing:runAction(
			cc.Sequence:create(
			cc.DelayTime:create(delay),
			cc.CallFunc:create(function(sender)
				
				paixing:setVisible(true)
			end),
			cc.DelayTime:create(time-delay),
			cc.CallFunc:create(function(sender)
				
				paixing:removeFromParent()
			end)
			))
		
		
	end

end

--
function DzpkGameScene:talk(msgTab)
	
	local datas = string.split(msgTab.chat_content or "","|")
	local words = msgTab.chat_content
	local key = 1
	if datas and table.nums(datas) >=2 then
		words = datas[2]
		key = tonumber(datas[1])
	end
	
	
	local user = self.dzpkGameManager:getDataManager():getUserInfoByGuid(msgTab["chat_guid"])
	if user ~= nil then
		
		local isman = PlayerInfo:getIsMaleByHeadIconNum( CustomHelper.tonumber(user.icon))
		local sex = 1
		if isman == false then
			sex = 2
		end
		MusicAndSoundManager:getInstance():playerSoundWithFile(talkSound[sex][key])
		
		
		
		
		local userNode = self:getUserInfoNodeFromChairid(user.chair)
		if userNode == nil then
			return
		end
		
		local talkui = self.csNode:getChildByName("Panel_Talk"):clone()
		self.csNode:addChild(talkui)
		
		local pos1 = userNode:getChildByName("Panel_talk"):convertToWorldSpace(cc.p(0,0))
		talkui:setPosition(pos1)
		talkui:getChildByName("Text_6"):setString(words)
		
		talkui:runAction(cc.Sequence:create(
            cc.DelayTime:create(5),
			cc.FadeOut:create(0.2),
			cc.CallFunc:create(
					function()
						---发送开始消息
						talkui:removeFromParent()
					end
				)
			
			
            ))
	end
	
	
end


--打赏
function DzpkGameScene:dashang(user)
	
	if user == nil then
		return
	end
	local userNode = self:getUserInfoNodeFromChairid(user.chair)
	if userNode == nil then
		return
	end
	
	self.heguanArm:getAnimation():play("kiss")

	local startpos = heguanMousePos
	local consize = userNode:getChildByName("Image_headbg"):getContentSize()
	local endpos = userNode:getChildByName("Image_headbg"):convertToWorldSpace(cc.p(consize.width/2,consize.height/2))
	
	
	local middlenode = self.csNode:getChildByName("Panel_middle")

	local t1 = cc.Sprite:create(CustomHelper.getFullPath("game_res/mainui/dz_dashang.png"))
	middlenode:addChild(t1,100)
	t1:setPosition(startpos)
	t1:runAction(
		cc.Sequence:create(
		cc.MoveTo:create(0.8, endpos),
		cc.CallFunc:create(function(sender)
			
			t1:removeFromParent()
		end)))
			
	t1:runAction( cc.FadeOut:create(1))	
	
	
	
	
end


----结算
function DzpkGameScene:doEnd()
	
	--处理比牌
	local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
	
	local users = self.dzpkGameManager:getDataManager():getUserInfoList()
	local compareNum = 0

	local myinfo = self.dzpkGameManager:getDataManager():getUserInfoByChair(tableinfo.own_chair)
	if myinfo.win_money > 0 and myinfo.win_money < 50*tableinfo.blind_bet then
		MusicAndSoundManager:getInstance():playerSoundWithFile("dzpksound/ying.mp3")
	elseif myinfo.win_money > 50*tableinfo.blind_bet then
		MusicAndSoundManager:getInstance():playerSoundWithFile("dzpksound/ying_big.mp3")
	else
		MusicAndSoundManager:getInstance():playerSoundWithFile("dzpksound/lose.mp3")
	end
	--

	--牌最大的人
	local maxWinMoneyPlayer = {}
	local maxWinMoney = 0
	
	--除开牌最大的人之外的赢钱的人
	local winMoneyNotMax = {}
	
	--有牌的人
	local haveCardPlayer = {}
	
	for k, v in pairs(users) do
		
		--未弃牌人数
		if v.cards ~= nil and #v.cards == 2 then
			compareNum = compareNum + 1
			
			table.insert(haveCardPlayer,v)
		end
		
		if v.biggest_winner == 1 then
			table.insert(maxWinMoneyPlayer,v)
		else
			if v.win_money > 0 then
				table.insert(winMoneyNotMax,v)
			end
		end
		
		--[[
		--最大赢家
		if v.win_money > maxWinMoney then
			maxWinMoney = v.win_money
			maxWinMoneyPlayer = v
		end
		--]]
	end
	
	--比牌
	if compareNum >= 2 then
		--翻牌
		for i=1, DZPK_MAX_USER do
			if i ~= tableinfo.own_chair then
				self:fanpaiByChair(i)
			end
			
		end

		--显示牌型
		for k,v in pairs(haveCardPlayer) do
			self:showCardType(v.chair,0.3,4)
		end
		
		
		for k,v in pairs(maxWinMoneyPlayer) do
			--赢家动画
			self:createWinAnim(v.chair)
			
			--飞筹码
			self:zhuchiChoumaFlyToPlayer(v.chair,0.1)
			if v.side_pot_money ~= nil then
				for k1,v1 in ipairs(v.side_pot_money) do
					if v1 > 0 then
						self:bianchiChoumaFlyToPlayer(k1,v.chair,0.2)
					end
					
				end
			end
			
			--显示赢钱数
			self:showWinMoney(v.chair,0.7,3)
			
			
		end
		local yanshi = 1
		--其他赢家
		for k,v in pairs(winMoneyNotMax) do
			
			--飞筹码
			--self:zhuchiChoumaFlyToPlayer(v.chair,0.1)
			if v.side_pot_money ~= nil then
				for k1,v1 in ipairs(v.side_pot_money) do
					if v1 > 0 then
						self:bianchiChoumaFlyToPlayer(k1,v.chair,0.2+yanshi)
					end
					
				end
			end
			
			--显示赢钱数
			self:showWinMoney(v.chair,0.7+yanshi,3+yanshi)
			
			
		end
		
		
		--播放牌型动画
		self:cardTypeAnim(maxWinMoneyPlayer[1].cards_type)
		
	
	--不比牌
	else
		for k,v in pairs(maxWinMoneyPlayer) do
			--赢家动画
			self:createWinAnim(v.chair)
			
			--飞筹码
			self:zhuchiChoumaFlyToPlayer(v.chair,0.1)
			if v.side_pot_money ~= nil then
				for k1,v1 in ipairs(v.side_pot_money) do
					if v1 > 0 then
						self:bianchiChoumaFlyToPlayer(k1,v.chair,0.2)
					end
					
				end
			end
			
			--显示赢钱数
			self:showWinMoney(v.chair,0.7,3)
			
			
		end
		
		
	end
	
	
end
--[[
--结算
function DzpkGameScene:doEnd(msg)
	
	self:doCompareCard()
	
end
--]]


--获取底池图标坐标
function DzpkGameScene:getDiChiIconPos()

	local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
	
	local userlistCCS = self.csNode:getChildByName("Panel_middle")--
	local pos1 = userlistCCS:getChildByName("Panel_cmc"):getChildByName("Image_dichi"):convertToWorldSpace(cc.p(0,0))
	--[[
	if tableinfo.side_pot ~= nil and #tableinfo.side_pot <= 2 then
		pos1 = userlistCCS:getChildByName("Panel_cmc"):getChildByName("Panel_youbianchi1"):getChildByName("Image_chouma"):convertToWorldSpace(cc.p(0,0))
	elseif tableinfo.side_pot ~= nil and #tableinfo.side_pot <= 5 then
		pos1 = userlistCCS:getChildByName("Panel_cmc"):getChildByName("Panel_youbianchi2"):getChildByName("Image_chouma"):convertToWorldSpace(cc.p(0,0))
	end
	--]]
	
	return pos1
end

--荷官收取本轮下注的所有筹码
function DzpkGameScene:allChouMaMoveToDiChi()
	
	MusicAndSoundManager:getInstance():playerSoundWithFile("dzpksound/chip_he.mp3")
	
	for i=1, DZPK_MAX_USER do
		self:choumaMoveToDiChi(i)
	end
end


--一个座位的本轮下注的筹码飞向底池
function DzpkGameScene:choumaMoveToDiChi(chair)
	
	local uNode = self:getUserInfoNodeFromChairid(chair)
	if uNode ~= nil then
		local startpos = uNode:getChildByName("Panel_chouma"):getChildByName("Image_icon"):convertToWorldSpace(cc.p(0,0))
		local endpos = self:getDiChiIconPos()
		local num = tonumber(uNode:getChildByName("Panel_chouma"):getChildByName("Text_3"):getString())
		if num > 0 then
			local chouma = self:createChouMaSprite(num)
			chouma:setPosition(startpos)
			chouma:runAction(
				cc.Sequence:create(
				cc.MoveTo:create(0.2, endpos),
				cc.CallFunc:create(function(sender)
					
					chouma:removeFromParent()
				end)))
		end
	end
end



--立即显示玩家头像信息
function DzpkGameScene:immediatelyPlayerInfo()
	local users = self.dzpkGameManager:getDataManager():getUserInfoList()
	local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
	if tableinfo == nil or users == nil then
		return
	end
	
	local userlistCCS = self.csNode:getChildByName("Panel_middle")
	
	for i=1, DZPK_MAX_USER do
		local node1 = userlistCCS:getChildByName("Panel_userInfo_"..(i-1))
		node1:setPosition(node1.startpos)
	end
	
	
	print("-------immediatelyPlayerInfo--------")
	for k, v in pairs(users) do
		
		
		local uNode = self:getUserInfoNodeFromChairid(v.chair)
		if uNode ~= nil then
			uNode:stopAllActions()
			uNode:setPosition( uNode.endpos )
			print("---------setEndPos---------")
			dump(uNode.endpos)
		end
		
	end
end


--立即更新公共牌()
function DzpkGameScene:immediatelyResetPublicCard()
	
	--先清除之前的公共牌信息
	self:clearPublicCard()
	
	--
	local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
	
	local middleCCS = self.csNode:getChildByName("Panel_middle")
	
	if tableinfo == nil or tableinfo.public_cards == nil or middleCCS == nil then
		return
	end

	
	
	--创建牌
	for k,v in ipairs(tableinfo.public_cards) do
		local pokercard = DZPKPoker.new(true, v)
		pokercard:setScale(0.6)
		middleCCS:addChild(pokercard,100)
		self.publicCard[k] = pokercard
	end
	
	--设置位置
	self:setPublicCardEndPos()
	
	
end

--清空一个座位的底牌
function DzpkGameScene:clearFanpaiByChair(chair)
	
	if self.chairCard ~= nil then
		local t1 = self.chairCard[chair]
		if t1 ~= nil then
			if t1[1] ~= nil then
				t1[1]:removeFromParent()
			end
			if t1[2] ~= nil then
				t1[2]:removeFromParent()
			end
		end
		self.chairCard[chair] = nil
	else
		self.chairCard = {}
	end
		
	
	
end



--翻开一个座位的底牌
function DzpkGameScene:fanpaiByChair(chair)
	local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
	local middleCCS = self.csNode:getChildByName("Panel_middle")
	--
	self:clearFanpaiByChair(chair)
	
	local ccs1 = chair - tableinfo.own_chair
	if ccs1 < 0 then
		ccs1 = ccs1 + DZPK_MAX_USER
	end
	
	local userinfo = self.dzpkGameManager:getDataManager():getUserInfoByChair(chair)
	
	if userinfo == nil or userinfo.cards == nil then
		return
	end
	
	for k,v in ipairs(userinfo.cards) do
		local pokercard = DZPKPoker.new(false, v)
		pokercard:setScale(0.5)
		middleCCS:addChild(pokercard,100)
		pokercard:setPosition( cc.p(playerDiPaiShowInfo[ccs1+1][k].x, playerDiPaiShowInfo[ccs1+1][k].y))
		pokercard:setRotation( playerDiPaiShowInfo[ccs1+1][k].rotation )
		
		pokercard:openBackAction(true)
		
		if self.chairCard[chair] == nil then
			self.chairCard[chair] = {}
		end
		
		self.chairCard[chair][k] = pokercard
	end
	
	
	
	--[[--如果是自己
	if chair == tableinfo.own_chair then
		
	else
	
	end--]]
end


--发玩家底牌
function DzpkGameScene:sendPlayerDiPai(usr)
	
	local middlenode = self.csNode:getChildByName("Panel_middle")
	local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()

	for k,v in ipairs(usr) do
		local usrNode = self:getUserInfoNodeFromChairid(v.chair)
		if usrNode ~= nil then
			local startpos = heguanBottomPos
			local endpos = usrNode:getChildByName("Image_dipai"):convertToWorldSpace(cc.p(0,0))
			usrNode:getChildByName("Image_dipai"):setScale(0)
			local t1 = cc.Sprite:create(CustomHelper.getFullPath("game_res/mainui/dz_duipai.png"))
			middlenode:addChild(t1,100)
			t1:setPosition(startpos)
			--t1:setScale(0)
			--t1:runAction(cc.ScaleTo.create(0.5,1))
			t1:runAction(
				cc.Sequence:create(
				cc.MoveTo:create(0.3, endpos),
				cc.CallFunc:create(function(sender)
					
					MusicAndSoundManager:getInstance():playerSoundWithFile("dzpksound/fapai_b.mp3")
					
					usrNode:getChildByName("Image_dipai"):setScale(1)
					
					--如果是自己
					if v.chair == tableinfo.own_chair then
						self:fanpaiByChair(tableinfo.own_chair)
					end
					
					
					t1:removeFromParent()
				end)))
			
		end
		
		
	end
end



--更新桌面信息
function DzpkGameScene:updateTable(dt )

	local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
	
	--边池信息
	if tableinfo == nil then
		return
	end
	--Panel_youbianchi1
	local middlenode = self.csNode:getChildByName("Panel_middle")
	
	
	if tableinfo.state == DzpkGameManager.TexasStatus.STATUS_WAITING then
		middlenode:getChildByName("Panel_cmc"):getChildByName("Image_dichi"):setVisible(false)
		--middlenode:getChildByName("Panel_cmc"):getChildByName("Panel_wubianchi"):setVisible(false)
		middlenode:getChildByName("Panel_cmc"):getChildByName("Panel_youbianchi1"):setVisible(false)
		middlenode:getChildByName("Panel_cmc"):getChildByName("Panel_youbianchi2"):setVisible(false)
		return
	else
		middlenode:getChildByName("Panel_cmc"):getChildByName("Image_dichi"):setVisible(true)
		--middlenode:getChildByName("Panel_cmc"):getChildByName("Panel_wubianchi"):setVisible(true)
		middlenode:getChildByName("Panel_cmc"):getChildByName("Panel_youbianchi1"):setVisible(true)
		middlenode:getChildByName("Panel_cmc"):getChildByName("Panel_youbianchi2"):setVisible(true)
	end
	
		
	local dichiword = middlenode:getChildByName("Panel_cmc"):getChildByName("Image_dichi"):getChildByName("Text_num")
	dichiword:setString( CustomHelper.moneyShowStyleNone(tableinfo.pot))
	
	--local dichi = middlenode:getChildByName("Panel_cmc"):getChildByName("Panel_wubianchi")
	local bianchi1 = middlenode:getChildByName("Panel_cmc"):getChildByName("Panel_youbianchi1")
	local bianchi2 = middlenode:getChildByName("Panel_cmc"):getChildByName("Panel_youbianchi2")
	if tableinfo.side_pot == nil or #tableinfo.side_pot == 0 then
		--dichi:setVisible(true)
		bianchi1:setVisible(false)
		bianchi2:setVisible(false)
		--
		
	elseif #tableinfo.side_pot <= 3 then
		--dichi:setVisible(false)
		bianchi1:setVisible(true)
		bianchi2:setVisible(false)
	else
		--dichi:setVisible(false)
		bianchi1:setVisible(false)
		bianchi2:setVisible(true)
	end
	
	--dichi:getChildByName("Image_chouma"):getChildByName("Text_5"):setString( CustomHelper.moneyShowStyleNone(tableinfo.pot) )
	--bianchi1:getChildByName("Image_chouma"):getChildByName("Text_5"):setString( CustomHelper.moneyShowStyleNone(tableinfo.pot) )
	--bianchi2:getChildByName("Image_chouma"):getChildByName("Text_5"):setString( CustomHelper.moneyShowStyleNone(tableinfo.pot) )
	
	
	for i=1, 6 do
		local b1 = bianchi1:getChildByName("Image_bianchi_"..(i-1))
		if b1 ~= nil then
			b1:setVisible(false)
		end
		
		local b2 = bianchi2:getChildByName("Image_bianchi_"..(i-1))
		if b2 ~= nil then
			b2:setVisible(false)
		end
	end
	
	if tableinfo.side_pot ~= nil then
		for k,v in ipairs(tableinfo.side_pot) do
			
			if v > 0 then
				local b1 = bianchi1:getChildByName("Image_bianchi_"..(k-1))
				if b1 ~= nil then
					b1:setVisible(true)
					b1:getChildByName("Text_5"):setString( CustomHelper.moneyShowStyleNone(v) )
				end
				
				local b2 = bianchi2:getChildByName("Image_bianchi_"..(k-1))
				if b2 ~= nil then
					b2:setVisible(true)
					b2:getChildByName("Text_5"):setString( CustomHelper.moneyShowStyleNone(v) )
				end
				--[[
				
				if k >= 3 then
					bianchi2:getChildByName("Image_bianchi_"..k):setVisible(true)
					--bianchi1:getChildByName("Image_bianchi_"..k):getChildByName("Text_5"):setString( CustomHelper.moneyShowStyleNone(v) )
					bianchi2:getChildByName("Image_bianchi_"..k):getChildByName("Text_5"):setString( CustomHelper.moneyShowStyleNone(v) )
				else
					bianchi1:getChildByName("Image_bianchi_"..k):setVisible(true)
					bianchi2:getChildByName("Image_bianchi_"..k):setVisible(true)
					bianchi1:getChildByName("Image_bianchi_"..k):getChildByName("Text_5"):setString( CustomHelper.moneyShowStyleNone(v) )
					bianchi2:getChildByName("Image_bianchi_"..k):getChildByName("Text_5"):setString( CustomHelper.moneyShowStyleNone(v) )
				end
				--]]
			end
		end
	end
	
end




--初始化自己按钮
function DzpkGameScene:initMyBtn( )
	
	self.overLiangPai = false --结束时亮牌
	self.LiangPai = true --亮牌

	local bottom = self.csNode:getChildByName("Panel_bottom")
	
	local leftbig = bottom:getChildByName("Panel_leftbig")
	local leftsmall = bottom:getChildByName("Panel_leftsmall")
	local rightmyturn = bottom:getChildByName("Panel_rightmyturn")
	local rightelseturn = bottom:getChildByName("Panel_rightelseturn")
	
	local liangpai = bottom:getChildByName("Panel_liangpai")
	--结束时亮牌
	liangpai:getChildByName("Button_1"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self.overLiangPai = not self.overLiangPai
			
		end
    end)
	--亮牌
	liangpai:getChildByName("Button_2"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self.dzpkGameManager:sendShowCards()
			self.overLiangPai = false --结束时亮牌
			self.LiangPai = true
		end
    end)
	
	--[[--动作类型
DzpkGameManager.TexasAction = 
{
	ACT_CALL 	= 1,--跟注
	ACT_RAISE 	= 2,--加注
	ACT_CHECK 	= 3,--让牌
	ACT_FOLD 	= 4,--弃牌
	ACT_ALL_IN 	= 5,--全下
	ACT_NORMAL 	= 6,--普通
	ACT_THINK 	= 7,
	ACT_WAITING	= 8--刚进入的玩家
}--]]
	
	--3X
	leftsmall:getChildByName("Button_1"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
			local money = tableinfo.blind_bet*3
			self.dzpkGameManager:sendPlayerOperate(DzpkGameManager.TexasAction.ACT_RAISE,money)
		end
    end)
	--4X
	leftsmall:getChildByName("Button_2"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
			local money = tableinfo.blind_bet*4
			self.dzpkGameManager:sendPlayerOperate(DzpkGameManager.TexasAction.ACT_RAISE,money)
		end
    end)
	--1底池
	leftsmall:getChildByName("Button_3"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
			local money = tableinfo.pot
			self.dzpkGameManager:sendPlayerOperate(DzpkGameManager.TexasAction.ACT_RAISE,money)
		end
    end)
	
	
	
	--1/2X底池
	leftbig:getChildByName("Button_1"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
			local money = math.floor(tableinfo.pot/2)
			self.dzpkGameManager:sendPlayerOperate(DzpkGameManager.TexasAction.ACT_RAISE,money)
		end
    end)
	--2/3X底池
	leftbig:getChildByName("Button_2"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
			local money = math.floor(tableinfo.pot/3*2)
			self.dzpkGameManager:sendPlayerOperate(DzpkGameManager.TexasAction.ACT_RAISE,money)
		end
    end)
	--1底池
	leftbig:getChildByName("Button_3"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
			local money = tableinfo.pot
			self.dzpkGameManager:sendPlayerOperate(DzpkGameManager.TexasAction.ACT_RAISE,money)
		end
    end)
	
	
	--弃牌
	rightmyturn:getChildByName("Button_1"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			
			self.dzpkGameManager:sendPlayerOperate(DzpkGameManager.TexasAction.ACT_FOLD,0)
		end
    end)
	--加注
	rightmyturn:getChildByName("Button_2"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:popJiazhuOperate()
		end
    end)
	--跟注
	rightmyturn:getChildByName("Button_3_gen"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			--local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
			--local money = tableinfo.pot
			
			local maxNum = self.dzpkGameManager:getDataManager():getUserMaxBet_money()
			local myNum = self.dzpkGameManager:getDataManager():getMyBet_money()
			local myinfo = self.dzpkGameManager:getDataManager():getMyInfo()
			
			self.dzpkGameManager:sendPlayerOperate(DzpkGameManager.TexasAction.ACT_CALL,(maxNum-myNum))
		end
    end)
	--全下
	rightmyturn:getChildByName("Button_3_all"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self.dzpkGameManager:sendPlayerOperate(DzpkGameManager.TexasAction.ACT_ALL_IN,0)
		end
    end)
	--让牌
	rightmyturn:getChildByName("Button_3_rang"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self.dzpkGameManager:sendPlayerOperate(DzpkGameManager.TexasAction.ACT_CHECK,0)
		end
    end)
	
	--[[
	[1] = {state = false},	--让或弃
	[2] = {state = false},	--更任何注
	[3] = {state = false,num = 0}, --跟注
	[4] = {state = false}, --全下
	[5] = {state = false}  --自动让牌
--]]	
	
	
	--让或弃
	rightelseturn:getChildByName("Button_1"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:setWillOperate(1)
		end
    end)
	--跟任何注
	rightelseturn:getChildByName("Button_2"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:setWillOperate(2)
		end
    end)
	--跟注
	rightelseturn:getChildByName("Button_3"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:setWillOperate(3)
		end
    end)
	--全下
	rightelseturn:getChildByName("Button_4"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:setWillOperate(4)
		end
    end)
	--自动让牌
	rightelseturn:getChildByName("Button_5"):addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:setWillOperate(5)
		end
    end)
	
	
end

--重置玩家信息位置
function DzpkGameScene:resetUserInfo( )

	local userlistCCS = self.csNode:getChildByName("Panel_middle")
	for i=1, DZPK_MAX_USER do
		local u = userlistCCS:getChildByName("Panel_userInfo_"..(i-1))
		u.startpos = userInfoPos[i].startpos
		u.endpos = userInfoPos[i].endpos
		if u ~= nil and userInfoPos[i] ~= nil then
			u:setPosition(userInfoPos[i].startpos)
			

		--倒计时
		-- 倒计时闹钟 --
		local pro = u:getChildByName("Image_timeProgress")
		if pro == nil then
			local time_mask = u:getChildByName("Image_time")
			time_mask:setVisible(false)
			
			local iconName =  CustomHelper.getFullPath("game_res/mainui/dz_txk_wfg_1.png") 
			local spriteProgress = cc.Sprite:create(iconName)
			local progressTimer = cc.ProgressTimer:create(spriteProgress)
			progressTimer:setAnchorPoint(0.5, 0.5)
			progressTimer:setPosition(cc.p(time_mask:getPosition()))
			progressTimer:setReverseDirection(true)
			progressTimer:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
			progressTimer:setPercentage(100)
			u:addChild(progressTimer)
			progressTimer:setName("Image_timeProgress")
		end
		
		
			
		end
	end
end

function DzpkGameScene:getUserInfoNodeFromChairid(chair)

	local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
	if tableinfo == nil then
		return nil
	end
	local userlistCCS = self.csNode:getChildByName("Panel_middle")
	
	local ccs1 = chair - tableinfo.own_chair
	if ccs1 < 0 then
		ccs1 = ccs1 + DZPK_MAX_USER
	end
	
	local uNode = userlistCCS:getChildByName("Panel_userInfo_"..(ccs1))
	
	return uNode
end



local texasActionImage = {
	[DzpkGameManager.TexasAction.ACT_CALL] = CustomHelper.getFullPath("game_res/mainui/dz_bq_gz.png"),
	[DzpkGameManager.TexasAction.ACT_RAISE] = CustomHelper.getFullPath("game_res/mainui/dz_bq_jz.png"),
	[DzpkGameManager.TexasAction.ACT_CHECK] = CustomHelper.getFullPath("game_res/mainui/dz_bq_rp.png"),
	[DzpkGameManager.TexasAction.ACT_FOLD] = CustomHelper.getFullPath("game_res/mainui/dz_bq_qp.png"),
	[DzpkGameManager.TexasAction.ACT_ALL_IN] = CustomHelper.getFullPath("game_res/mainui/dz_bq_qx.png"),
	[DzpkGameManager.TexasAction.ACT_NORMAL] = nil,
	[DzpkGameManager.TexasAction.ACT_THINK] = CustomHelper.getFullPath("game_res/mainui/dz_bq_skz.png"),
	[DzpkGameManager.TexasAction.ACT_WAITING] = nil,
}


function DzpkGameScene:updateUserInfo(dt )

	local users = self.dzpkGameManager:getDataManager():getUserInfoList()
	local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
	local myinfo = self.dzpkGameManager:getDataManager():getMyInfo()
	if tableinfo == nil or users == nil or myinfo == nil then
		return
	end
	
	local userlistCCS = self.csNode:getChildByName("Panel_middle")
	
	for k, v in pairs(users) do
		
		
		local uNode = self:getUserInfoNodeFromChairid(v.chair)
		if uNode ~= nil then
			local lasttime = v.countdown
			v.countdown = v.countdown - dt
			local ismy = false
			if v.chair == myinfo.chair then
				ismy = true
			end
			
			self:onThinkTimeChanged(lasttime,v.countdown,ismy)
			
			--玩家名字
			local userNameNode = uNode:getChildByName("Text_name")
			userNameNode:setString(v.name)
			CustomHelper.transeWordToStaticLen(userNameNode,110)
			
			--玩家钱
			local userMoneyNode = uNode:getChildByName("Text_money")
			userMoneyNode:setString( CustomHelper.moneyShowStyleNone(v.money))
			
			--玩家头像
			local userIconNode = uNode:getChildByName("headicon")
			userIconNode:loadTexture(CustomHelper.getFullPath("hall_res/head_icon/"..(v.icon)..".png"))
			
			--玩家动作状态
			local userActionStateNode = uNode:getChildByName("Image_state")
			if texasActionImage[v.action] == nil then
				userActionStateNode:setVisible(false)
			else
				userActionStateNode:setVisible(true)
				userActionStateNode:loadTexture(texasActionImage[v.action])
			end
			
			if v.action == DzpkGameManager.TexasAction.ACT_WAITING then
				uNode:setOpacity(150)
			else
				uNode:setOpacity(255)
			end
			
			
			
			--是否是庄家
			local userZhuangjiaNode = uNode:getChildByName("Image_zhuangjia")
			if v.position == 3 then --庄家
				userZhuangjiaNode:setVisible(true)
			else
				userZhuangjiaNode:setVisible(false)
			end

			--是否有2张底牌
			local userDipaiNode = uNode:getChildByName("Image_dipai")
			if v.hole_cards == 1 and v.chair ~= tableinfo.own_chair then --有
				userDipaiNode:setVisible(true)
			else
				userDipaiNode:setVisible(false)
			end
			
			--筹码
			local userChoumaNode = uNode:getChildByName("Panel_chouma")
			userChoumaNode:getChildByName("Text_3"):setString( CustomHelper.moneyShowStyleNone(v.bet_money) )
			CustomHelper.transeWordToStaticScaleLen(userChoumaNode:getChildByName("Text_3"),70)
			if v.bet_money > 0 then
				userChoumaNode:setVisible(true)
			else
				userChoumaNode:setVisible(false)
			end
			
			--倒计时
			local imageTimeProgress = uNode:getChildByName("Image_timeProgress")
			if v.countdown <= 0 then
				imageTimeProgress:setVisible(false)
			else
				imageTimeProgress:setVisible(true)
			end
			local t1 = v.countdown/tableinfo.think_time
			local spriteProgress = nil
			if t1 > 0.5 then
				local iconName =  CustomHelper.getFullPath("game_res/mainui/dz_txk_wfg_1.png")
				spriteProgress = cc.Sprite:create(iconName)
			elseif t1 > 0.25 then
				local iconName =  CustomHelper.getFullPath("game_res/mainui/dz_txk_wfg_2.png")
				spriteProgress = cc.Sprite:create(iconName)
			else 
				local iconName =  CustomHelper.getFullPath("game_res/mainui/dz_txk_wfg_3.png")
				spriteProgress = cc.Sprite:create(iconName)
			end
			imageTimeProgress:setSprite(spriteProgress)
			imageTimeProgress:setPercentage(math.ceil(100*t1))
			
			
		end
		
		
		
		
	end
end

--清空欲操作
function DzpkGameScene:clearWillOperate()
	self.willOperate = {
		[1] = {state = false,dofun1 = function()
			--
			local maxBet = self.dzpkGameManager:getDataManager():getUserMaxBet_money()
			local myBet = self.dzpkGameManager:getDataManager():getMyBet_money()
			if maxBet-myBet > 0 then
				self.dzpkGameManager:sendPlayerOperate(DzpkGameManager.TexasAction.ACT_FOLD,0)
			else
				self.dzpkGameManager:sendPlayerOperate(DzpkGameManager.TexasAction.ACT_CHECK,0)
			end
		end},	--让或弃
		[2] = {state = false,dofun1 = function()
			--
			local maxBet = self.dzpkGameManager:getDataManager():getUserMaxBet_money()
			local myBet = self.dzpkGameManager:getDataManager():getMyBet_money()
			if maxBet-myBet > 0 then
				self.dzpkGameManager:sendPlayerOperate(DzpkGameManager.TexasAction.ACT_CALL,0)
			end
			
			
		end},	--更任何注
		[3] = {state = false,num = 0,dofun1 = function()
			--
			local maxBet = self.dzpkGameManager:getDataManager():getUserMaxBet_money()
			local myBet = self.dzpkGameManager:getDataManager():getMyBet_money()
			if maxBet-myBet > 0 then
				self.dzpkGameManager:sendPlayerOperate(DzpkGameManager.TexasAction.ACT_CALL,0)
			end
			
		end}, --跟注
		[4] = {state = false,dofun1 = function()
			--
			self.dzpkGameManager:sendPlayerOperate(DzpkGameManager.TexasAction.ACT_ALL_IN,0)
		end}, --全下
		[5] = {state = false,dofun1 = function()
			--
			self.dzpkGameManager:sendPlayerOperate(DzpkGameManager.TexasAction.ACT_CHECK,0)
		end}  --自动让牌
	}
end

--设置欲操作
function DzpkGameScene:setWillOperate(num)
	
	if self.willOperate[num] ~= nil then
		for k,v in ipairs(self.willOperate) do
			if num == k then
				v.state = not v.state
			else
				v.state = false
			end
		end
	end
	
end


--设置欲操作
function DzpkGameScene:doWillOperate()
	
	
	for k,v in ipairs(self.willOperate) do
		if v.state == true then
			v.dofun1()
			break
		end
	end
	
	self:clearWillOperate()
	
end

--更新亮牌提示信息
function DzpkGameScene:updateLiangPaiNotice()
	local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
	if tableinfo == nil then
		return
	end
	local myinfo = self.dzpkGameManager:getDataManager():getUserInfoByChair(tableinfo.own_chair)
	if myinfo == nil then
		return
	end
	local userlistCCS = self.csNode:getChildByName("Panel_bottom")
	local liangpai = userlistCCS:getChildByName("Panel_liangpai")
	local noticeWord = noticeWords[math.random(1,#noticeWords)]
	liangpai:getChildByName("Text_4"):setString(noticeWord)
end



--更新亮牌信息
function DzpkGameScene:updateLiangPai()
	
	local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
	if tableinfo == nil then
		return
	end
	local myinfo = self.dzpkGameManager:getDataManager():getUserInfoByChair(tableinfo.own_chair)
	if myinfo == nil then
		return
	end
	local userlistCCS = self.csNode:getChildByName("Panel_bottom")
	local liangpai = userlistCCS:getChildByName("Panel_liangpai")
	local willliangpai = liangpai:getChildByName("Button_1")
	local liangpaibtn = liangpai:getChildByName("Button_2")
	liangpaibtn:setVisible(false)
	liangpai:getChildByName("Text_4"):setVisible(true)
	if tableinfo.state == DzpkGameManager.TexasStatus.STATUS_SHOW_DOWN then
		
		liangpai:setVisible(true)
		liangpai:getChildByName("Text_4"):setVisible(false)
		willliangpai:setVisible(false)
		if self.LiangPai == false then
			liangpaibtn:setVisible(true)
		end
		
	elseif myinfo.action == DzpkGameManager.TexasAction.ACT_FOLD then --弃牌
		liangpai:setVisible(true)
		
		willliangpai:setVisible(true)
		
	end
	
	
	--self.overLiangPai
	
	if self.overLiangPai == true then
		willliangpai:getChildByName("Image_3"):setVisible(true)
	else
		willliangpai:getChildByName("Image_3"):setVisible(false)
	end
	
end


--更新玩家操作按钮状态
function DzpkGameScene:updatePlayerBtn(dt )
		
	local users = self.dzpkGameManager:getDataManager():getUserInfoList()
	local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
	if tableinfo == nil or users == nil then
		return
	end
	
	local userlistCCS = self.csNode:getChildByName("Panel_bottom")
	
	
	
	local myinfo = self.dzpkGameManager:getDataManager():getUserInfoByChair(tableinfo.own_chair)
	if myinfo == nil then
		return
	end
	
	
	
	
	local leftbig = userlistCCS:getChildByName("Panel_leftbig")
	local leftsmall = userlistCCS:getChildByName("Panel_leftsmall")
	local rightmyturn = userlistCCS:getChildByName("Panel_rightmyturn")
	local rightelseturn = userlistCCS:getChildByName("Panel_rightelseturn")
	
	local liangpai = userlistCCS:getChildByName("Panel_liangpai")
	
	
	--等待或结算
	if tableinfo.state == DzpkGameManager.TexasStatus.STATUS_WAITING  then
		userlistCCS:setVisible(false)
		
	elseif tableinfo.state == DzpkGameManager.TexasStatus.STATUS_SHOW_DOWN then
		leftsmall:setVisible(false)
		leftbig:setVisible(false)
		rightmyturn:setVisible(false)
		rightelseturn:setVisible(false)
		liangpai:setVisible(true)
		return
	else
		userlistCCS:setVisible(true)
	end
	
	
	--设置按钮是否可点击
	local maxbet = self.dzpkGameManager:getDataManager():getUserMaxBet_money()
	local mybet = self.dzpkGameManager:getDataManager():getMyBet_money()
	--3X
	if myinfo.money >= tableinfo.blind_bet*3 and mybet+tableinfo.blind_bet*3 >= maxbet then
		leftsmall:getChildByName("Button_1"):setEnabled(true)
	else
		leftsmall:getChildByName("Button_1"):setEnabled(false)
	end
	
	
	--4X
	if myinfo.money >= tableinfo.blind_bet*4 and mybet+tableinfo.blind_bet*4 >= maxbet then
		leftsmall:getChildByName("Button_2"):setEnabled(true)
	else
		leftsmall:getChildByName("Button_2"):setEnabled(false)
	end
	
	--1底池
	if myinfo.money >= tableinfo.pot then
		leftsmall:getChildByName("Button_3"):setEnabled(true)
	else
		leftsmall:getChildByName("Button_3"):setEnabled(false)
	end
	
	
	
	
	--1/2X底池
	if myinfo.money >= math.floor(tableinfo.pot/2) then
		leftbig:getChildByName("Button_1"):setEnabled(true)
	else
		leftbig:getChildByName("Button_1"):setEnabled(false)
	end
	
	--2/3X底池
	if myinfo.money >= math.floor(tableinfo.pot/3*2) then
		leftbig:getChildByName("Button_2"):setEnabled(true)
	else
		leftbig:getChildByName("Button_2"):setEnabled(false)
	end
	
	--1底池
	if myinfo.money >= tableinfo.pot then
		leftbig:getChildByName("Button_3"):setEnabled(true)
	else
		leftbig:getChildByName("Button_3"):setEnabled(false)
	end
	
	
	--自己不在思考的时候关闭加注界面
	if myinfo.action ~= DzpkGameManager.TexasAction.ACT_THINK then --自己思考中
		self.jiazhuNode:setVisible(false)
	end
	
	
	
	if myinfo.action == DzpkGameManager.TexasAction.ACT_THINK then --自己思考中
		liangpai:setVisible(false)
		rightmyturn:setVisible(true)
		rightelseturn:setVisible(false)
		--第一轮
		if tableinfo.state == DzpkGameManager.TexasStatus.STATUS_PRE_FLOP then
			leftsmall:setVisible(true)
			leftbig:setVisible(false)
		else
			--如果底池<=3x大盲注，出现按钮，【3x大盲】、【4x大盲】、【1x底池】
			--如果底池>3x大盲注，出现按钮，【1/2底池】、【2/3底池】、【1x底池】
			if tableinfo.pot <= tableinfo.blind_bet*3 then
				leftsmall:setVisible(true)
				leftbig:setVisible(false)
			else
				leftsmall:setVisible(false)
				leftbig:setVisible(true)
			end
		end
		
		--跟注
		rightmyturn:getChildByName("Button_3_gen"):setVisible(true)
		rightmyturn:getChildByName("Button_3_all"):setVisible(false)
		rightmyturn:getChildByName("Button_3_rang"):setVisible(false)
		
		local maxNum = self.dzpkGameManager:getDataManager():getUserMaxBet_money()
		local myNum = self.dzpkGameManager:getDataManager():getMyBet_money()
		local myinfo = self.dzpkGameManager:getDataManager():getMyInfo()
		local cha = maxNum - myNum
		if cha <= 0 then
			rightmyturn:getChildByName("Button_3_gen"):setVisible(false)
			rightmyturn:getChildByName("Button_3_all"):setVisible(false)
			rightmyturn:getChildByName("Button_3_rang"):setVisible(true)
		elseif cha >= myinfo.money then
			rightmyturn:getChildByName("Button_3_gen"):setVisible(false)
			rightmyturn:getChildByName("Button_3_all"):setVisible(true)
			rightmyturn:getChildByName("Button_3_rang"):setVisible(false)
		end
		rightmyturn:getChildByName("Button_3_gen"):getChildByName("Text_2"):setString(  CustomHelper.moneyShowStyleNone(cha))
		
		CustomHelper.transeWordToStaticScaleLen(rightmyturn:getChildByName("Button_3_gen"):getChildByName("Text_2"),126)
		
	elseif 	myinfo.action == DzpkGameManager.TexasAction.ACT_WAITING 	or
			myinfo.action == DzpkGameManager.TexasAction.ACT_ALL_IN 	then
		leftsmall:setVisible(false)
		leftbig:setVisible(false)
		rightmyturn:setVisible(false)
		rightelseturn:setVisible(false)
		liangpai:setVisible(false)
	elseif 	myinfo.action == DzpkGameManager.TexasAction.ACT_FOLD then
		leftsmall:setVisible(false)
		leftbig:setVisible(false)
		rightmyturn:setVisible(false)
		rightelseturn:setVisible(false)
		liangpai:setVisible(true)
	--没有在弃牌和等待和自己思考中状态(欲操作)
	else
		leftsmall:setVisible(false)
		leftbig:setVisible(false)
		rightmyturn:setVisible(false)
		rightelseturn:setVisible(true)
		liangpai:setVisible(false)
		
		local geng = rightelseturn:getChildByName("Button_3")
		local all = rightelseturn:getChildByName("Button_4")
		local rang = rightelseturn:getChildByName("Button_5")

		local maxBet = self.dzpkGameManager:getDataManager():getUserMaxBet_money()
		local myBet = self.dzpkGameManager:getDataManager():getMyBet_money()
		if maxBet == 0 and myBet == 0 then
			rang:setVisible(true)
			all:setVisible(false)
			geng:setVisible(false)
		elseif maxBet-myBet > 0 then
			rang:setVisible(false)
			if maxBet-myBet < myinfo.money then
				all:setVisible(false)
				geng:setVisible(true)
				geng:getChildByName("Text_4"):setString(  CustomHelper.moneyShowStyleNone(maxBet-myBet))
				CustomHelper.transeWordToStaticScaleLen(geng:getChildByName("Text_4"),126)
				if maxBet-myBet ~= self.willOperate[3].num then
					self:clearWillOperate()
					self.willOperate[3].num = maxBet-myBet
				end
				
			else
				all:setVisible(true)
				geng:setVisible(false)
			end
			
		end
		--
		
		for k,v in ipairs(self.willOperate) do
			if v.state == true then
				rightelseturn:getChildByName("Button_"..k):getChildByName("Image_3"):setVisible(true)
			else
				rightelseturn:getChildByName("Button_"..k):getChildByName("Image_3"):setVisible(false)
			end
		end
		
		
	end
	
	--
	
	
end

--获取自己的手牌和公共牌
function DzpkGameScene:getMyCardsAndPublicCards()
	local re = {}
	local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
	if tableinfo == nil then
		return re
	end
	local myinfo = self.dzpkGameManager:getDataManager():getUserInfoByChair(tableinfo.own_chair)
	if myinfo == nil or self.chairCard == nil or self.chairCard[tableinfo.own_chair] == nil then
		return re
	end
	
	for k,v in ipairs(self.chairCard[tableinfo.own_chair]) do
		table.insert(re,v)
	end
	if self.publicCard ~= nil then
		for k,v in ipairs(self.publicCard) do
			table.insert(re,v)
		end
	end
	
	return re
	
end

--预测牌型
function DzpkGameScene:checkMyCardType(dt)
	local tableinfo = self.dzpkGameManager:getDataManager():getTableInfo()
	if tableinfo == nil then
		return
	end
	local myinfo = self.dzpkGameManager:getDataManager():getUserInfoByChair(tableinfo.own_chair)
	if myinfo == nil then
		return
	end
	
	for k,v in ipairs(self:getMyCardsAndPublicCards()) do
		v:HideLight()
	end
	
	if myinfo.cards_type == nil or myinfo.cards_type == DzpkGameManager.CardType.CT_HIGH_CARD then
		local uNode = self:getUserInfoNodeFromChairid(tableinfo.own_chair)
		if uNode ~= nil then
			uNode:getChildByName("Text_paixing"):setString("")
			
		end
		return
	end
	
	if myinfo.cards_show ~= nil then
		for k,v in ipairs(myinfo.cards_show) do
			for k1,v1 in ipairs(self:getMyCardsAndPublicCards()) do
				if v == v1._num then
					v1:ShowLight()
				end
			end
		end
	end
	
	--
	
	local uNode = self:getUserInfoNodeFromChairid(tableinfo.own_chair)
	if uNode ~= nil then
		uNode:getChildByName("Text_paixing"):setString(cardTypeWords[myinfo.cards_type])
		
	end
end


--更新信息
function DzpkGameScene:update(dt )
	
		self:updateTable(dt)
		self:updateUserInfo(dt)
		self:updatePlayerBtn(dt)
		self:updateLiangPai()
		self:checkMyCardType(dt)
end


function DzpkGameScene:onExit()
    if self._scheduler then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scheduler)
        self._scheduler = nil
    end
end

----退出房间
function DzpkGameScene:exitGame(issend ,openSecondLayer)

	if issend == nil then
		issend = true
	end
	

    ---释放资源
    local needLoadResArray = DzpkGameScene.getNeedPreloadResArray();
    for i,v in ipairs(needLoadResArray) do
        if string.find(v,".ExportJson") then
        --todo
            ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(v);
        end
    end
	
	if issend == true then
		self.dzpkGameManager:sendPlayerLeave()
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



---取一个数整数
function DzpkGameScene:getIntPart(x)
    if x <= 0 then
       return math.ceil(x);
    end

    if math.ceil(x) == x then
       x = math.ceil(x);
    else
       x = math.ceil(x) - 1;
    end
    return x;
end




return DzpkGameScene