--[[
	dealwith hall msg
]]
HallMsgManager = class("HallMsgManager");
require("socket")
--初始化 大厅消息类型,k
HallMsgManager.MsgName 		=	 {
	C_RequestPublicKey				=				"C_RequestPublicKey",--请求密码加密key
	C_PublicKey 					= 				"C_PublicKey",--得到公钥
	CG_GameServerCfg				=				"CG_GameServerCfg",--请游戏配置信息
	CL_Login						= 				"CL_Login",--登录请求
	LC_Login						= 				"LC_Login",--登录返回
	CS_RequestSms					=				"CS_RequestSms",--发送验证码
	SC_RequestSms					=				"SC_RequestSms",--验证码发送成功
	CS_ResetAccount					=				"CS_ResetAccount",--绑定账号
	SC_ResetAccount 				=				"SC_ResetAccount",--绑定消息返回结果
	CL_RegAccount					=				"CL_RegAccount",--快速注册
	CS_RequestPlayerInfo			=				"CS_RequestPlayerInfo",--请求玩家数据信息
	SC_ReplyPlayerInfo 				=				"SC_ReplyPlayerInfo",--服务器请求数据回复
	SC_ReplyPlayerInfoComplete		=				"SC_ReplyPlayerInfoComplete",--玩家数据服务器回复完成
	GC_GameServerCfg				=				"GC_GameServerCfg",--返回游戏配置
	CS_ChangeGame					=				"CS_ChangeGame",--切换游戏服务器 调用成功 回调 SC_EnterRoomAndSitDown
	CS_SetNickname					=				"CS_SetNickname",--设置昵称
	SC_SetNickname					=				"SC_SetNickname",--设置昵称返回
	CS_ChangeHeaderIcon				=				"CS_ChangeHeaderIcon",--修改头像
	SC_ChangeHeaderIcon				=				"SC_ChangeHeaderIcon",
	CL_LoginBySms					=				"CL_LoginBySms",--用短信验证码登陆
	CS_BankDeposit					=				"CS_BankDeposit",--银行存钱
	SC_BankDeposit					=				"SC_BankDeposit",--银行存钱成功
	CS_BankDraw						=				"CS_BankDraw",--银行取钱消息
	SC_BankDraw						=				"SC_BankDraw",--银行取钱
	CS_BankTransfer					=				"CS_BankTransfer",--银行转账 (账号转账)
	CS_BankTransferByGuid			=				"CS_BankTransferByGuid", --guid 转账
	SC_BankTransfer                 =				"SC_BankTransfer",--转账结果
	CS_SetPassword					=				"CS_SetPassword",--修改密码
	CS_SetPasswordBySms				=				"CS_SetPasswordBySms",--短信改密
	SC_SetPassword					=				"SC_SetPassword",--返回修改密码结果
	-- SC_ChangeGame					=				"SC_ChangeGame",--切换游戏服务器结果
	-- CS_EnterRoomAndSitDown			=				"CS_EnterRoomAndSitDown",--进入房间并坐下
	SC_EnterRoomAndSitDown			=				"SC_EnterRoomAndSitDown",
	CS_StandUpAndExitRoom			=				"CS_StandUpAndExitRoom",--站起并离开房间
	SC_StandUpAndExitRoom			=				"SC_StandUpAndExitRoom",
	CS_Ready						=				"CS_Ready", --准备开始
	SC_Ready						=				"SC_Ready",
	SC_NotifyEnterRoom              =               "SC_NotifyEnterRoom", --通知其他人进入房间
	SC_NotifyExitRoom               =               "SC_NotifyExitRoom", ---通知其他人离开房间
	SC_NotifySitDown  				=				"SC_NotifySitDown", --通知同桌坐下
	SC_NotifyStandUp				=				"SC_NotifyStandUp", --// 通知同桌站起
	SC_Gamefinish					=				"SC_Gamefinish",--// 应答当前游戏结束数据
	CS_HEARTBEAT					=				"CS_HEARTBEAT",--心跳包
	SC_HEARTBEAT					=				"SC_HEARTBEAT" ,--	
	SC_NotifyMoney					=				"SC_NotifyMoney", --用户金币有刷新	
	SC_NotifyBank					=				"SC_NotifyBank",--银行账号刷新
	CS_LoginValidatebox				=				"CS_LoginValidatebox"	,--文字验证
	SC_LoginValidatebox				=				"SC_LoginValidatebox",-- 验证结果
 	CS_BandAlipay					=				"CS_BandAlipay",--绑定支付宝
 	SC_BandAlipay					=				"SC_BandAlipay",--绑定支付宝返回值		
	--- 消息功能
	CS_QueryPlayerMsgData			=				"CS_QueryPlayerMsgData",
	SC_QueryPlayerMsgData			=				"SC_QueryPlayerMsgData",
	CS_SetMsgReadFlag				=				"CS_SetMsgReadFlag",
	SC_NewMsgData					=				"SC_NewMsgData",
	--- 反馈功能
	SC_FeedBackUpDate				=				"SC_FeedBackUpDate",		-- 反馈更新
	SC_QueryPlayerMarquee    		=				"SC_QueryPlayerMarquee",--收到新的跑马灯
	SC_NewMarquee 					=				"SC_NewMarquee", ---收到一条新的跑马灯
	-- CL_GetInviterInfo               =				"CL_GetInviterInfo",--获取邀请人信息
	SC_BrocastClientUpdateInfo		=				"SC_BrocastClientUpdateInfo",--client_const.json
	SC_AlipayEdit					=				"SC_AlipayEdit", ---后天主动修改支付宝信息
	SC_FreezeAccount				= 				"SC_FreezeAccount", ----封号消息
	SC_GameMaintain					=				"SC_GameMaintain",---服務器維護開關，用户玩家一轮游戏结束后，弹出维护提示框
	SC_CashMaintain					=				"SC_CashMaintain",--提現維護開關
	CS_PrivateRoomInfo              =               "CS_PrivateRoomInfo",  -- 请求私人房间信息
	SC_PrivateRoomInfo              =               "SC_PrivateRoomInfo",  -- 返回私人房间信息
	CS_JoinPrivateRoom              =               "CS_JoinPrivateRoom",  -- 请求进入私人房间
	SC_JoinPrivateRoomFailed        =               "SC_JoinPrivateRoomFailed",  -- 请求进入私人房间失败
};
-- HallMsgManager.EnumName = {
-- 	REG_ACCOUNT_RESULT = "REG_ACCOUNT_RESULT",
-- 	LOGIN_RESULT = "LOGIN_RESULT"
-- }
--通知
-- HallMsgManager.kNotifyName_MsgRequestError 		= 	"kNotifyName_MsgRequestError"
HallMsgManager.kNotifyName_ConnectionClose			=	"HallMsgManager.kNotifyName_ConnectionClose"
HallMsgManager.kNotifyName_MsgResponseError   		=   "kNotifyName_MsgResponseError"
HallMsgManager.kNotifyName_ConnectionStatusChange   = 	"kNotifyName_ConnectionStatusChange"
HallMsgManager.kNotifyName_MsgResponseSuccess		=   "kNotifyName_MsgResponseSuccess"
HallMsgManager.kNotifyName_RefreshPlayerInfo		=	"kNotifyName_RefreshPlayerInfo" --刷新用户信息通知
HallMsgManager.kNotifyName_RefreshConstConifg 		= 	"kNotifyName_RefreshConstConifg" ---刷新常量配置通知
HallMsgManager.kNotifyName_NeedShowMarqueeInfo		=	"HallMsgManager.kNotifyName_NeedShowMarqueeInfo" --显示跑马灯信息
HallMsgManager.kNotifyName_NeedShowNotice			=	"HallMsgManager.kNotifyName_NeedShowNotice" --显示需要弹出的公告


HallMsgManager.kNeedSendMsgInfo_MsgName 			=	"msgName"
HallMsgManager.kNeedSendMsgInfo_MsgTab				=   "msgTab"
HallMsgManager.kNeedSendMsgInfo_NeedLogin			=	"needlogin"
HallMsgManager.kNeedSendMsgInfo_ResponseArray		=	"response_array"
--心跳包间隔
HallMsgManager.HeartBeatInterval = 5.0;
HallMsgManager.MsgTimeoutInerval = 15.0;
---每个ip地址的 自动重连次数
HallMsgManager.AutoReconnectMaxTimes = 0;
function HallMsgManager:ctor()
	--消息解析类 pb to tab
	self.msgPBParseManager = GameManager:getInstance():getMsgPBParseManager();
	self:reset();
	self:initPBData();
end
function HallMsgManager:reset()
	CustomHelper.unscheduleGlobal(self.heartBeatScheduleID); 
	CustomHelper.unscheduleGlobal(self.delayRefreshConstScheduleID);
	self.connectionID = nil;
	self.needTimeoutMsgMap = {};--用于记录需要检测超时的消息
	self:addDefaultNeedTimeoutMsg();

	self.sendingMsgMap = {};--定时器需要检测
	self.needAddToSendingMsg = {};
	self.responseMsgMap = {};--已经完成的消息，在定时器中 将sendingMsgMap中的对应key移除
	self.needResendMsgMap = {};--记录需要重发的消息
	self.playerInfo = nil;
	self.reconnectTimes = 0;
	self.isNeedAutoReconnect = true;
end
--增加默认需要监听超时的消息
function HallMsgManager:addDefaultNeedTimeoutMsg()
	self:registerNeedTimeoutMsgName(
		HallMsgManager.MsgName.CS_ChangeGame,
		{
			HallMsgManager.MsgName.SC_EnterRoomAndSitDown,
			HallMsgManager.MsgName.SC_GameMaintain
		}
	)
end
--初始化pb文件
function HallMsgManager:initPBData()
	local pbFileTab = {};
	table.insert(pbFileTab, "common_player_define.proto");
	table.insert(pbFileTab, "common_msg_define.proto");
	table.insert(pbFileTab, "common_enum_define.proto");
	for k,v in pairs(pbFileTab) do
		local pbFullPath = cc.FileUtils:getInstance():fullPathForFilename(v);
		--print("k:",pbFullPath);
		self:registerProtoFileToPb(pbFullPath);
		--print("register end")
	end
	--增加解析key
	for k,v in pairs(HallMsgManager.MsgName) do
		self:registerMsgNameToMsgPBMananager(v);
	end
end
--注册协议文件
function HallMsgManager:registerProtoFileToPb(filePath)
	self.msgPBParseManager:registerProtoFileToPb(filePath);
end
--注册消息命令
function HallMsgManager:registerMsgNameToMsgPBMananager(msgName)
	self.msgPBParseManager:addMsgNameKeyToKeyMap(msgName);
end
--检测是否需要连接到服务器
function HallMsgManager:checkIsNeedReConnectionToServer()
	local isNeed = true;
	local  tcpStatus = GameManager:getInstance():getHallManager():getHallDataManager():getConnectionStatus();
	if tcpStatus == NetworkManager.TCPConnectionStatus.TCPConnectionStatus_Connected then
		--todo
		isNeed = false;
	end
	-- print("checkIsNeedReConnectionToServer status:",tcpStatus,"isNeed:",isNeed);
	return isNeed;
end
--连接tcp
function HallMsgManager:connect(connectionID,tcpAddr,tcpPort)
	self.connectionID = connectionID;
	self.tcpAddr = tcpAddr;
	self.tcpPort = tcpPort;
	self.timeout = HallMsgManager.MsgTimeoutInerval
	--连接服务器
	GameManager:getInstance():getNetworkManager():connect(connectionID,tcpAddr,tcpPort,self.timeout);
end
---断开连接
function HallMsgManager:disconnect()
	if self.connectionID == nil then
		--todo
		return;
	end
	local  tcpStatus = GameManager:getInstance():getHallManager():getHallDataManager():getConnectionStatus();
	if tcpStatus == NetworkManager.TCPConnectionStatus.TCPConnectionStatus_Connected then
		--todo
		GameManager:getInstance():getNetworkManager():disconnect(self.connectionID);
	end
end
function HallMsgManager:startReconnect()
	self.hallManager = GameManager:getInstance():getHallManager();
	self.hallDataManager = self.hallManager:getHallDataManager();
    self.reconnectTimes = 0;
    self.hallDataManager:resetServerIndex()
	self:reconnect();
end
--重连
function HallMsgManager:reconnect()
	local  tcpStatus = GameManager:getInstance():getHallManager():getHallDataManager():getConnectionStatus();
	if tcpStatus ~= NetworkManager.TCPConnectionStatus.TCPConnectionStatus_Connecting then
		--todo
		GameManager:getInstance():getHallManager():connect();
	end
	-- CustomHelper.printStack();
end
--[[
msgName:需要监听的发送消息名
reponseMsgArray：服务器可能响应返回的消息名
]]
function HallMsgManager:registerNeedTimeoutMsgName(msgName,responseMsgArray,timeout)
	--print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
	if timeout == nil then
		--todo
		timeout = HallMsgManager.MsgTimeoutInerval
	end
	local info = {};
	info.responseMsgArray = responseMsgArray;
	info.timeout = timeout;
	self.needTimeoutMsgMap[msgName] = info;
	--dump(self.needTimeoutMsgMap, "self.needTimeoutMsgMap", nesting)
end
--发送消息接口   
--[[
isNeedLogin为是否需要登录才能发送,
isAutoResend为网络重连后，是否重发默认值为true
]]
function HallMsgManager:sendMsg(msgName,msgTab,isNeedLogin,isAutoResend)
	if isAutoResend == nil then
	--todo
		isAutoResend = true
	end
	if isNeedLogin == nil then
		--todo
		isNeedLogin = true;
	end
	local msgInfo = self.needTimeoutMsgMap[msgName];
	--dump(msgInfo, "msgInfo", nesting)
	--检测是否将msg放入到needResendMsgMap中
	if self:checkIsNeedReConnectionToServer() == true or msgInfo then 
		--todo
		--记录本次请求以及参数
		local needSendMsgInfo = {};
		if isAutoResend then
			--todo
			needSendMsgInfo[HallMsgManager.kNeedSendMsgInfo_MsgName] = msgName;
			needSendMsgInfo[HallMsgManager.kNeedSendMsgInfo_MsgTab] = CustomHelper.copyTab(msgTab);
			needSendMsgInfo[HallMsgManager.kNeedSendMsgInfo_NeedLogin] = isNeedLogin;
			if msgInfo then
				--todo
				needSendMsgInfo[HallMsgManager.kNeedSendMsgInfo_ResponseArray] = msgInfo.responseMsgArray
			end
			self.needResendMsgMap[msgName] = needSendMsgInfo
			--dump(self.needResendMsgMap, "self.needResendMsgMap", nesting)
		end
		if self:checkIsNeedReConnectionToServer() then--重连服务器
				--todo
			self:startReconnect();
			return
		end
	end
	if 	msgName == HallMsgManager.MsgName.CL_Login or
		msgName == HallMsgManager.MsgName.CS_ResetAccount    or
		msgName == HallMsgManager.MsgName.CS_SetPassword    or
		msgName == HallMsgManager.MsgName.CS_SetPasswordBySms
		then --登录需要 加密 密码
		--todo
		--替换其中的密码
		local passwordKey = "password";
		local pwd = msgTab[passwordKey];
		local publicKey = GameManager:getInstance():getHallManager():getHallDataManager():getPublicKey();
		local encryptPwd = myLua.LuaBridgeUtils:crypto_encrypt_password(publicKey,pwd);
		msgTab[passwordKey] = encryptPwd;
		if msgName == HallMsgManager.MsgName.CS_SetPassword then --旧密码加密
		--todo
			local oldPwdKey = "old_password"
			msgTab[oldPwdKey] = myLua.LuaBridgeUtils:crypto_encrypt_password(publicKey,msgTab[oldPwdKey]);
			-- elseif conditions then
			--todo
		end
	end
	--
	if msgName ~= HallMsgManager.MsgName.CS_HEARTBEAT then
		--todo
--		print("msgName:",msgName)
		--CustomHelper.printStack();
		dump(msgTab, "msgTab", nesting)
	end
	--检测是否需要处理超时
	--[[
	local info = {};
	info.reponse = reponseMsgArray;
	info.timeout = timeout;
	]]
	--dump(self.needTimeoutMsgMap,"self.needTimeoutMsgMap", nesting)
	--dump(msgInfo, "msgInfo", nesting)
	
	if msgInfo  then 
		--todo
		--在超时检测定时器中加入该消息
		local msgTimeoutInfo = {
			response = msgInfo.responseMsgArray,
			timeout_interval = os.time() + msgInfo.timeout
		}
		self.sendingMsgMap[msgName] = msgTimeoutInfo;
	end
	local pbBuffer = self.msgPBParseManager:encodeToBuffer(msgName,msgTab);
	
	local len = #pbBuffer
	local t1 = pbBuffer[1]
	local t2 = pbBuffer[2]
	local t3 = pbBuffer[3]
	local t4 = pbBuffer[4]
	
	local msgID = self.msgPBParseManager:getTCPMsgEnumID(msgName); 
	GameManager:getInstance():getNetworkManager():sendTCPMsg(self.connectionID,msgID,pbBuffer);
end
function HallMsgManager:callbackWhenReceiveOneFullMsg(msgID,dataStr)
	--function name
	local msgName = self.msgPBParseManager:getMsgNameWitMsgID(msgID);
	if msgName == nil then
		--todo
		print("client is not register msgID:",msgID)
		return;
	--elseif msgName ~= HallMsgManager.MsgName.C_PublicKey then
		--todo
		--return;
	end
	local msgTab = self:parseAllPBDataStrToTab(msgName,dataStr);
	msgTab["msgID"] = msgID;
    msgTab["msgName"] = msgName;
	if msgName ~= HallMsgManager.MsgName.SC_HEARTBEAT then
		--todo
	    dump(msgTab, "callbackWhenReceiveOneFullMsg tab:", 100)
	end
	--self.needResendMsgMap移除对应数据
	for needResendMsgName,v in pairs(self.needResendMsgMap) do
		local tempResponseArray = v[HallMsgManager.kNeedSendMsgInfo_ResponseArray];
		if tempResponseArray then
			--todo
			for i,tempResonse in ipairs(tempResponseArray) do
				if tempResonse == msgName then
					--todo
					--print("remove one msgName from needResendMsgMap:",msgName)
					self.needResendMsgMap[needResendMsgName] = nil;
				end
			end
		end
	end
	--dump(self.sendingMsgMap, "self.sendingMsgMap", nesting)
	for k1,v1 in pairs(self.sendingMsgMap) do
		local responseArray = v1.response
		for i,tempResponse in ipairs(responseArray) do
			if tempResponse == msgName then
				--todo
				self.sendingMsgMap[k1] = nil;
				break;
			end
		end
	end

	local resultKey = msgTab.ret or msgTab.result;
	local eventDispatcher = cc.Director:getInstance():getEventDispatcher();
	local event = nil;
	if resultKey == nil or resultKey == 0 then --成功
		--处理成功 处理函数为
		local dealFuncName = "on_"..msgName;
		if dealFuncName and self[dealFuncName] then --交给各自对应的处理函数处理 
			--todo
			self[dealFuncName](self,msgTab);
		end
		--判断是否在子游戏中监听
		local subGameManager = GameManager:getInstance():getHallManager():getSubGameManager();
		if dealFuncName and subGameManager and subGameManager[dealFuncName] then
			--todo
			subGameManager[dealFuncName](subGameManager,msgTab);
		end
		---发送成功通知
		event = cc.EventCustom:new(HallMsgManager.kNotifyName_MsgResponseSuccess);
	else
		--发出失败通知
		local errorFuncName = "on_error_"..msgName;
		if errorFuncName and self[errorFuncName] then --交给各自对应的处理函数处理 
			--todo
			self[errorFuncName](self,msgTab);
		end
				--判断是否在子游戏中监听
		local subGameManager = GameManager:getInstance():getHallManager():getSubGameManager();
		if errorFuncName and subGameManager and subGameManager[errorFuncName] then
			--todo
			subGameManager[errorFuncName](subGameManager,msgTab);
		end
	    event = cc.EventCustom:new(HallMsgManager.kNotifyName_MsgResponseError)
	end
    event.userInfo = msgTab--string.format("%d",count2)
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event);
end
--检测是否有超时的消息
function HallMsgManager:checkIsHasTimeoutMsg()
	--检测是否有超时
	--[[
     "CL_RegAccount" = {
         "response" = {
             1 = "LC_Login"
         }
         "timeout_interval" = 1489819427
    }
	]]
	for k,v in pairs(self.sendingMsgMap) do
		--
		local osTime = os.time();
		local timeoutInterval = v.timeout_interval
		if timeoutInterval < osTime then -- 超时
			--todo
			print(k,":is timeout")
			self.sendingMsgMap[k] = nil
			self:disconnect();
		end
	end
end
--处理连接状态变化通知
function HallMsgManager:callbackWhenReceiveTCPConnectionStatusModiy(status)
	self.hallDataManager:setConnectionStatus(status);
	-- print("new connection status:",status);
	if status == NetworkManager.TCPConnectionStatus.TCPConnectionStatus_Close then --连接状态变为关闭时
		--todo
		--关闭心跳包检测
		self.hallDataManager:setPublicKey(nil);
		CustomHelper.unscheduleGlobal(self.heartBeatScheduleID);
		dump(self.needResendMsgMap, "self.needResendMsgMap", 100)
		-- --发出网络连接失败通知
		-- if self.needResendMsgMap and #self.needResendMsgMap > 0 then
		-- 	--todo
		-- 	local alreadyDispatchEvent = {};
		-- 	for i,needSendMsgInfo in ipairs(self.needResendMsgMap) do
		-- 		local msgName = needSendMsgInfo[HallMsgManager.kNeedSendMsgInfo_MsgName]
		-- 		if alreadyDispatchEvent[msgName] == nil then
		-- 			--todo
		-- 			local disConnectEvent = cc.EventCustom:new(HallMsgManager.kNotifyName_ConnectionClose)
		-- 			disConnectEvent.userInfo = {
		-- 				msgName = msgName;
		-- 			}
		-- 			cc.Director:getInstance():getEventDispatcher():dispatchEvent(disConnectEvent);
		-- 			alreadyDispatchEvent[msgName] = msgName;
		-- 		end
		-- 	end
		-- end	
		--增加后台自动重连
		if self.isNeedAutoReconnect then
			--todo
			if  self.reconnectTimes < HallMsgManager.AutoReconnectMaxTimes then
				--todo
				self.reconnectTimes = self.reconnectTimes + 1;
				self:reconnect();
				return
			elseif self.hallDataManager:refreshTCPIPAndPort() == true then --刷新服务器
				--todo
				--连接下一个地址
				self.reconnectTimes = 0;
				GameManager:getInstance():getHallManager():connect();
				return;
			else
				local disConnectEvent = cc.EventCustom:new(HallMsgManager.kNotifyName_ConnectionClose)
				cc.Director:getInstance():getEventDispatcher():dispatchEvent(disConnectEvent);
			end
		else
             --所有配置服务器地址都连接失败了，则发出网络断开通知
			local disConnectEvent = cc.EventCustom:new(HallMsgManager.kNotifyName_ConnectionClose)
			cc.Director:getInstance():getEventDispatcher():dispatchEvent(disConnectEvent);
		end
	elseif status == NetworkManager.TCPConnectionStatus.TCPConnectionStatus_Connected then --每次重连后，会更新public_key,故重连登录需放在 publickey回调函数里实现
		--todo
		--开启心跳包
		--因为有些消息没有返回消息，故心跳包只能一直发送		
		self.reconnectTimes = 0;
		self:reopenDelaySendHeartBeatMsg();
		--发送获取登录密码publicKey
		self:sendRequestPublicKey();
		--拉取服务器信息
		self:sendRequestGameServerCfg();
	end
	local event = nil;
	--发出失败通知
	event = cc.EventCustom:new(HallMsgManager.kNotifyName_ConnectionStatusChange)
    event.userInfo = {
    	["status"] = status
    }--string.format("%d",count2)
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event); 
end
--解析pb数据,根据规则解析所有
function HallMsgManager:parseAllPBDataStrToTab(msgName,dataStr)
	local tempTab = self.msgPBParseManager:decodeMsgToTabWithMsgName(msgName,dataStr);
	if tempTab ~= nil then
		--todo
		for k,v in pairs(tempTab) do
			if string.find(k,"pb_") ~= nil then --需要进一步解析
				--判断v是否需要进一步解析
				local vTab = nil;
				if type(v[1]) ~= "table"  then --直接解析
					--todo
					vTab = self:parseAllPBDataStrToTab(v[1],v[2]);
					
				else --是数组
					vTab = {}; 
					for j,v2 in ipairs(v) do
						local v2Tab = self:parseAllPBDataStrToTab(v2[1],v2[2]);
						vTab[j] = v2Tab;
					end
				end
				tempTab[k] = vTab;
			end
		end
	end
	return tempTab;
end
function HallMsgManager:clenNeedResendMsg()
	self.needResendMsgMap = {};
end
--不烦
function HallMsgManager:checkIsNeedResendMsgToServer(isNeedLogin)
    local index = 1;
    local isHasResendMsg = false;
    dump(self.needResendMsgMap, "self.needResendMsgMap111", nesting)
    local needRemoveTab = {};
    for k,msgInfo in pairs(self.needResendMsgMap) do
    	local tempIsNeedLogin = msgInfo[HallMsgManager.kNeedSendMsgInfo_NeedLogin]
        if isNeedLogin == tempIsNeedLogin then
            isHasResendMsg = true;
            local msgName = msgInfo[HallMsgManager.kNeedSendMsgInfo_MsgName];
            local msgTab = CustomHelper.copyTab(msgInfo[HallMsgManager.kNeedSendMsgInfo_MsgTab]);
            needRemoveTab[k] = k;
            self:sendMsg(msgName,msgTab,isNeedLogin);
        end
    end
    for k,v in pairs(needRemoveTab) do
    	self.needResendMsgMap[k] = nil;
    end
    print("isNeedLogin:",isNeedLogin,",isHasResendMsg:",isHasResendMsg,",self.playerInfo:",self.playerInfo)
    if isNeedLogin == false and isHasResendMsg == false and self.playerInfo then --如果在游戏中，断线重连后，需要自动登录
    	--todo
		local account = self.playerInfo:getAccount();
		local pwd = self.playerInfo:getPassword();
		self:sendLoginMsg(account,pwd);
		isHasResendMsg = true;
    end
    return isHasResendMsg;
end
--获取游戏开放配置
function HallMsgManager:sendRequestGameServerCfg()
	local infoTab = {
	};
	local msgName = HallMsgManager.MsgName.CG_GameServerCfg;
	self:sendMsg(msgName,infoTab,false);
end
function HallMsgManager:on_GC_GameServerCfg(msgTab)
	--按照协议分层级解析,返回的数据为开放的房间
	-- dump(msgTab, "serverConfigPBTab", 1000);
	self.hallDataManager:dealWithServerList(msgTab);
end
--发送快速开始按钮
function HallMsgManager:sendQuickStartMsg()
--检测是否本地有账号
	-- local hallManager = GameManager:getInstance():getHallManager();
	-- self.hallDataManager = hallManager:getHallDataManager();
	-- local account = self.hallDataManager:getSavePlayerAccount();
	-- local pwd = self.hallDataManager:getSavePlayerPwd();
	-- if account ~= nil and pwd ~= nil then --账号已经存在，直接调用登录
	-- 	--todo
	-- 	self:sendLoginMsg(account,pwd);
	-- else --调用快速注册接口
			--todo	
		self:sendUserRegisterMsg(nil,nil);
	-- end
end
function HallMsgManager:sendTelVerifyCode(telNum,intention)
	local infoTab = {}
	infoTab["tel"] = telNum;
	if intention == nil then
		infoTab["intention"] = 1;
	else
		infoTab["intention"] = intention;
	end
	self:sendMsg(HallMsgManager.MsgName.CS_RequestSms,infoTab,false)
end
--发送注册消息
function HallMsgManager:sendUserRegisterMsg(account,pwd)
	local infoTab = {};
	--快速注册的时候，account 和 pwd为nil，均有服务器生成
	if account ~= nil  then
		--todo
		infoTab["account"] = account;
	end
	if pwd ~= nil  then
		--todo
		infoTab["password"] = pwd;
	end
	--[[
	// 注册账号
	message CL_RegAccount {
		enum MsgID { ID = 1001; }
		optional string account = 1;					// 账号，没有账号密码即是游客登陆
		optional string password = 2;					// 密码 需要加密
		optional string phone = 3;						// 手机型号
		optional string phone_type = 4;					// 手机类型
		optional string version = 5;					// 版本号
		optional string channel_id = 6;					// 渠道号
		optional string package_name = 7;				// 安装包名字
		optional string imei = 8;						// 设备唯一码
		optional string ip = 9;							// 客户端ip
	}
	]]
	--添加服务器需要记录的其他字段
	self:addNeedRecordDeviceInfo(infoTab)
	self:sendMsg(HallMsgManager.MsgName.CL_RegAccount,infoTab,false);
end
function  HallMsgManager:addNeedRecordDeviceInfo(infoTab)
	local versionManger = GameManager:getInstance():getVersionManager()
	local DeviceUtils = requireForGameLuaFile("DeviceUtils")
	infoTab["phone"] = DeviceUtils.getDevicePlatform()
	infoTab["phone_type"] = DeviceUtils.getDeviceModel()
	infoTab["version"] = versionManger:getVersionStr()
	infoTab["channel_id"] = versionManger:getChannelName();
	infoTab["package_name"] = DeviceUtils.getBundleName();
	infoTab["imei"] = DeviceUtils.getIMEIStr()
	return infoTab;
end
--短信验证登录
function HallMsgManager:sendLoginBySms(phoneNumTextStr,verifyCodeTextStr)
	local info = {};
	info["account"] = phoneNumTextStr
	info["sms_no"] = verifyCodeTextStr
	self:addNeedRecordDeviceInfo(info)
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(HallMsgManager.MsgName.CL_LoginBySms,info,false)
end
--[[
// 登录请求
message CL_Login {
	enum MsgID { ID = 1003; }
	optional string account = 1;					// 账号
	optional string password = 2;					// 密码 需要加密
	optional string phone = 3;						// 手机型号
	optional string phone_type = 4;					// 手机类型
	optional string imei = 5;						// 设备唯一码
	optional string ip = 6;							// 客户端ip
}
]]
--得到加密key
function HallMsgManager:sendRequestPublicKey()
	local infoTab = {
	};
	local msgName = HallMsgManager.MsgName.C_RequestPublicKey;
	self:sendMsg(msgName,infoTab,false);
end
--收到publicKey处理
function HallMsgManager:on_C_PublicKey(msgTab)
	--设置publicKey
	print("11111111111111111111111111")
	self.hallDataManager:setPublicKey(msgTab.public_key);
end
--发送登录消息
function HallMsgManager:sendLoginMsg(account,pwd)
	self.tempPwd = pwd
	if string.len(pwd) ~= 32 then -- md5的长度是32 
		--todo
		self.tempPwd = CustomHelper.md5String(self.tempPwd);
	end
	local infoTab = {
		account = account,
		password = self.tempPwd
	};
	self:addNeedRecordDeviceInfo(infoTab)
	local msgName = HallMsgManager.MsgName.CL_Login;
	self:sendMsg(msgName,infoTab,false);
end
--接收到登录消息 （登录 或者 快速注册都会调用该方法）
function HallMsgManager:on_LC_Login(msgTab)
	--保存账号
	if self.playerInfo == nil then --判断playerInfo是否存在，不存在则创建。该对象在退出游戏时注销
		--todo
		self.playerInfo = PlayerInfo:create();
		self.hallManager:setPlayerInfo(self.playerInfo);
	end
	--todo
	self.playerInfo:updatePlayerPropertyWithInfoTab(msgTab);
	local account = self.playerInfo:getAccount();
	local pwd = self.tempPwd;
	-- print("pwd:",pwd,"self.playerInfo:getIsGuest():",self.playerInfo:getIsGuest())
	if self.playerInfo:getPassword() ~= nil then
		--todo
		pwd = self.playerInfo:getPassword()
	elseif self.playerInfo:getIsGuest() then
		--todo
		pwd = CustomHelper.md5String(account);
	end
	-- print("login pwd:",pwd);
	self.playerInfo:setPassword(pwd);
	self.hallDataManager:savePlayerAccountInfo(account,pwd);
	--检测是否弹出文字验证框
	local pb_validatebox = msgTab.pb_validatebox;
	if pb_validatebox ~= nil then 
		--todo
		 self.hallDataManager:setWordVerifyData(pb_validatebox);
	end

	--补发消息
	-- self:checkIsNeedResendMsgToServer(true);
end
--绑定账号
function HallMsgManager:sendAccountBindMsg(account,password,nickname,smsNo)
	-- 	optional string account = 1;					// 账号
	-- optional string password = 2;					// 密码
	-- optional string nickname = 3;					// 昵称
	-- optional string sms_no = 4;	
	self.tempPwd = CustomHelper.md5String(password);
	local infoTab = {};
	infoTab.account = account
	infoTab.password = self.tempPwd;
	infoTab.nickname = nickname;
	infoTab.sms_no = smsNo;
	self:sendMsg(HallMsgManager.MsgName.CS_ResetAccount,infoTab)
end
function HallMsgManager:on_SC_ResetAccount(msgTab)
	self.playerInfo:setPassword(self.tempPwd)
	self.playerInfo:updatePlayerPropertyWithInfoTab(msgTab);
	self.playerInfo:setIsGuest(false);
	--保存最新账号
	local account = self.playerInfo:getAccount();
	self.hallDataManager:savePlayerAccountInfo(account,self.playerInfo:getPassword());
	--发出用户信息刷新通知
	self:postRefreshPlayerInfoNotify();
end
--修改密码
function HallMsgManager:sendResetPwdByOldPwd(oldPwd,newPwd)
	local infoTab = {}
    infoTab["old_password"] = CustomHelper.md5String(oldPwd)
    infoTab["password"] = CustomHelper.md5String(newPwd)
    self.tempPwd = newPwd;
    self:sendMsg(HallMsgManager.MsgName.CS_SetPassword,infoTab)
end
--短信改密
function HallMsgManager:sendResetPwdBySms(newPwd,verifyCode)
	local infoTab = {}
    infoTab["sms_no"] = verifyCode
    infoTab["password"] = CustomHelper.md5String(newPwd);
    self.tempPwd = newPwd;
    self:sendMsg(HallMsgManager.MsgName.CS_SetPasswordBySms,infoTab)
end
--收到密码修改成功
function HallMsgManager:on_SC_SetPassword(msgTab)
	self.playerInfo:setPassword(self.tempPwd)
	self.hallDataManager:savePlayerAccountInfo(self.playerInfo:getAccount(),self.playerInfo:getPassword());
end
--发出用户新消息刷新通知
function HallMsgManager:postRefreshPlayerInfoNotify()
	local event = cc.EventCustom:new(HallMsgManager.kNotifyName_RefreshPlayerInfo);
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event);
end

---常量改变 主界面刷新通知
function HallMsgManager:postRefreshConstConfigNotify()
    local event = cc.EventCustom:new(HallMsgManager.kNotifyName_RefreshConstConifg);
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event);
end

--发送获取玩家信息 ，会收到多个玩家信息数据，直到收到
function HallMsgManager:sendGetPlayerInfoMsg()
	local infoTab = {};
	self:sendMsg(HallMsgManager.MsgName.CS_RequestPlayerInfo,infoTab);
end
--更新玩家信息
function HallMsgManager:on_SC_ReplyPlayerInfo(msgTab)
	--解析个人基础信息
	local baseInfoTab = msgTab["pb_base_info"];
	-- if #msgTab.base_info > 0 then
	if baseInfoTab then
		self.playerInfo:updatePlayerPropertyWithInfoTab(baseInfoTab);
	end
end
function HallMsgManager:on_SC_SetNickname(msgTab)
	self.playerInfo:updatePlayerPropertyWithInfoTab(msgTab);
	self:postRefreshPlayerInfoNotify();
end
function HallMsgManager:on_SC_ChangeHeaderIcon(msgTab)
	self.playerInfo:updatePlayerPropertyWithInfoTab(msgTab);
	self:postRefreshPlayerInfoNotify();
end
--银行 存入
function HallMsgManager:on_SC_BankDeposit(msgTab)
	local depositMoney = msgTab.money;
	if depositMoney then
		--todo
		self.playerInfo:setMoney(self.playerInfo:getMoney() - depositMoney);
		self.playerInfo:setBank(self.playerInfo:getBank() + depositMoney);
		self:postRefreshPlayerInfoNotify();
	end
end
--银行 取出
function HallMsgManager:on_SC_BankDraw(msgTab)
	local  withdrawMoney = msgTab.money
	if withdrawMoney then
		--todo
		self.playerInfo:setMoney(self.playerInfo:getMoney() + withdrawMoney);
		self.playerInfo:setBank(self.playerInfo:getBank() - withdrawMoney);
		self:postRefreshPlayerInfoNotify();
	end

end
--[[
message SC_BankTransfer {
	enum MsgID { ID = 2018; }
	optional int32 result = 1;						// 结果 BANK_OPT_RESULT
	optional int64 money = 2;						// 转账多少钱
	optional int64 bank = 3;						// 当前银行的钱
}
]]
function HallMsgManager:on_SC_BankTransfer(msgTab)
	local tranferNum = msgTab.money;
	if tranferNum then
		--todo
		self.playerInfo:setBank(self.playerInfo:getBank() + tranferNum);
		self:postRefreshPlayerInfoNotify();
	end	
end 
--获取玩家信息完成，回调函数
function HallMsgManager:on_SC_ReplyPlayerInfoComplete(msgTab)
	print("HallMsgManager:on_SC_ReplyPlayerInfoComplete()···获取玩家信息完成，回调函数");
	if msgTab.pb_gmMessage  then 
		--todo
		self.playerInfo:setGamingInfoTab(msgTab.pb_gmMessage);
	end
	-- TODO 拉取历史消息
	self.playerInfo:getMessageInfo():getData()
	self:postRefreshPlayerInfoNotify();
	-- TODO 拉取反馈是否有新的消息
	-- self:send_SC_getFeedBackNew()
end

function HallMsgManager:on_SC_Gamefinish(msgTab)
	if msgTab then
		--todo
		self.playerInfo:setGamingInfoTab(nil)
		self.playerInfo:updatePlayerPropertyWithInfoTab(msgTab);
		self:postRefreshPlayerInfoNotify();
	end
end

--切换进入某个子游戏
function HallMsgManager:sendEnterOneGameMsg(gameType,roomID)
	local infoTab = {};
	infoTab["first_game_type"] = gameType;
	infoTab["second_game_type"] = roomID;
	print("sendEnterOneGameMsg")
	self:sendMsg(HallMsgManager.MsgName.CS_ChangeGame,infoTab,true);
end
--增加切换游戏返回消息
function HallMsgManager:on_SC_EnterRoomAndSitDown(msgTab)
	-- print("get enter one game result :")
	-- dump(msgTab, "msgTab", nesting);	
	---服务器切换成功，准备进入具体某个游戏
	print("on_SC_EnterRoomAndSitDown")
	GameManager:getInstance():getHallManager():enterOneGameWithGameInfoTab(msgTab);
end
--处理错误异常
function HallMsgManager:on_error_SC_StandUpAndExitRoom(msgTab)
	print("HallMsgManager:on_error_SC_StandUpAndExitRoom")
	if msgTab.result == 3 then --玩家已经出了房间
		--todo
		self.playerInfo:setGamingInfoTab(nil)
	end
end
--进入房间并坐下
function HallMsgManager:sendEnterRoomAndSitDown()
	local infoTab = {};
	self:sendMsg(HallMsgManager.MsgName.CS_EnterRoomAndSitDown,infoTab);
end
--站起并离开房间
function HallMsgManager:sendStandUpAndExitRoom()
	local infoTab = {};
	self:sendMsg(HallMsgManager.MsgName.CS_StandUpAndExitRoom,infoTab);
end
--准备开始
function HallMsgManager:sendGameReady()
	local infoTab = {};
	self:sendMsg(HallMsgManager.MsgName.CS_Ready,infoTab);
end

-- function HallMsgManager:on_SC_Playstatus(msgTab)
-- 	-- body
-- 	print("进入游戏")
-- 	self:sendReconnectionPlay();
-- end
--用户金币有刷新
--[[
message SC_NotifyMoney {
	enum MsgID { ID = 2019; }
	optional int32 opt_type = 1;					// LOG_MONEY_OPT_TYPE
	optional int32 money = 2;						// 当前的钱
	optional int32 change_money = 3;				// 改变的钱
}
]]
function HallMsgManager:on_SC_NotifyMoney(msgTab)
	local money = msgTab.money or 0
	if self.playerInfo and money then
		--todo
		self.playerInfo:setMoney(money);
		self:postRefreshPlayerInfoNotify();
	end
end
function HallMsgManager:on_SC_NotifyBank(msgTab)
	local bank = msgTab.bank or 0
	if self.playerInfo and bank then
		--todo
		self.playerInfo:setBank(bank);
		self:postRefreshPlayerInfoNotify();
	end
end
--发送游戏断线重连
function HallMsgManager:sendReconnectionPlay()
	-- body
	local msg = {}
	self:sendMsg(HallMsgManager.MsgName.CS_ReconnectionPlay,msg);
end

function HallMsgManager:callbackWhenDoExitGame()
	self.isNeedAutoReconnect = false;--退出游戏后，不自动重连
	self:disconnect()
end

--开启延时发送心跳包
function HallMsgManager:reopenDelaySendHeartBeatMsg()
	CustomHelper.unscheduleGlobal(self.heartBeatScheduleID);
	-- if self.heartBeatScheduleID == nil then
		self.heartBeatScheduleID = CustomHelper.performWithDelayGlobal(function()
		--发送心跳包消息
			--print("HallMsgManager:send_HEARTBEAT()")
			self:sendHeartBeatMsg();
		end,HallMsgManager.HeartBeatInterval)
	-- end
end
--发送心跳包请求
function HallMsgManager:sendHeartBeatMsg()
	local msg = {};
	self:registerNeedTimeoutMsgName(HallMsgManager.MsgName.CS_HEARTBEAT,{HallMsgManager.MsgName.SC_HEARTBEAT},HallMsgManager.MsgTimeoutInerval);
	self:sendMsg(HallMsgManager.MsgName.CS_HEARTBEAT,msg);
	--
end
function HallMsgManager:on_SC_HEARTBEAT(data)
	local timeNow = socket.gettime()
	self.hallDataManager:setServerIntervalTime(data.severTime - timeNow)	--print("HallMsgManager:on_SC_HEARTBEAT()")
	self:reopenDelaySendHeartBeatMsg();
end
--[[
message CS_BandAlipay{
	enum MsgID { ID = 11075; }
	optional string alipay_account = 1;					// 支付宝账号
	optional string alipay_name = 2;					// 支付宝名字
}
]]
--发送绑定支付宝账号相关
function HallMsgManager:sendBindAlipayAccount(name,account)
	local infoTab = {
		alipay_account = account;
		alipay_name = name;
	}
	self:sendMsg(HallMsgManager.MsgName.CS_BandAlipay,infoTab);
end
--[[
message SC_BandAlipay{
	enum MsgID { ID = 11075; }
	optional int32 result = 1;           //1失败 0成功
	optional string alipay_account = 1;					// 支付宝账号
	optional string alipay_name = 2;					// 支付宝名字
}

]]
--收到绑定支付宝成功
function HallMsgManager:on_SC_BandAlipay(msgTab)
	local showAlipayName = msgTab.alipay_name;
	local showAlipayAccount = msgTab.alipay_account
	self.playerInfo:updateAlipayBindInfo(showAlipayAccount,showAlipayName);
	--发出更新用户信息通知
	self:postRefreshPlayerInfoNotify();
end
function HallMsgManager:sendQueryPlayerMsgData()
	local infoTab = {}
	dump(22222)
	self:sendMsg(HallMsgManager.MsgName.CS_QueryPlayerMsgData, infoTab, false)
end

function HallMsgManager:on_SC_QueryPlayerMsgData(data)
	print("on_SC_QueryPlayerMsgData:")
	local messageInfo = self.playerInfo:getMessageInfo()
	messageInfo:addData(data.pb_msg_data, true)
	--dump(data)
	-- 发送更新消息数据
	local event = cc.EventCustom:new("kNotifyName_RefreshMessageData");
	local event1 = cc.EventCustom:new("kNotifyName_RefreshMessageReaded");
	cc.Director:getInstance():getEventDispatcher():dispatchEvent(event);
	cc.Director:getInstance():getEventDispatcher():dispatchEvent(event1);
end

function HallMsgManager:sendSetMsgReadFlag(data)
	local infoTab = {
		id = data.Id,
		msg_type = data.Type,
	}
	dump(infoTab)
	self:sendMsg(HallMsgManager.MsgName.CS_SetMsgReadFlag, infoTab, false)
	local event1 = cc.EventCustom:new("kNotifyName_RefreshMessageReaded");
	cc.Director:getInstance():getEventDispatcher():dispatchEvent(event1);
end

function HallMsgManager:on_SC_NewMsgData(data)
	dump(data.pb_msg_data)
	local messageInfo = self.playerInfo:getMessageInfo()
	messageInfo:addData(data.pb_msg_data, false)
	-- 发送更新消息数据
	local event = cc.EventCustom:new("kNotifyName_RefreshMessageData");
	local event1 = cc.EventCustom:new("kNotifyName_RefreshMessageReaded");
	cc.Director:getInstance():getEventDispatcher():dispatchEvent(event);
	cc.Director:getInstance():getEventDispatcher():dispatchEvent(event1);

	-- local event2 = cc.EventCustom:new("kNotifyName_ReceiveNewMsg")
	-- cc.Director:getInstance():getEventDispatcher():dispatchEvent(event2)
end
--- 处理反馈信息更新消息
function HallMsgManager:on_SC_FeedBackUpDate(msgTab)
	-- 拉取反馈信息状态
	local FeedbackHelper = requireForGameLuaFile("FeedbackHelper")
	FeedbackHelper.queryFeedbackStatus()

	local event2 = cc.EventCustom:new("kNotifyName_ReceiveNewMsg")
	cc.Director:getInstance():getEventDispatcher():dispatchEvent(event2)
end
--[[
// 返回查询玩家跑马灯
message SC_QueryPlayerMarquee {
	enum MsgID { ID = 2212; }
	repeated Marquee pb_msg_data = 1;				// 消息数据
}
// 追加跑马灯消息
message SC_NewMarquee {	
	enum MsgID { ID = 2213; }
	repeated Marquee pb_msg_data = 1; 				// 玩家的guid
}
// 跑马灯
message Marquee{
	optional int32  id = 1;							// 编号
	optional int32  start_time = 2;					// 开始时间
	optional int32  end_time = 3;					// 结束时间
	optional string content = 4;					// 消息内容
	optional int32 number = 5;						// 轮播次数
	optional int32 interval_time = 6;				// 轮播时间间隔（秒）	
}
]]
--收到跑马灯查询消息
function HallMsgManager:on_SC_QueryPlayerMarquee(msgTab)
	self.hallDataManager:setMarqueeArrayFromServer(msgTab.pb_msg_data or {});
end
--收到一条新的跑马灯消息
function HallMsgManager:on_SC_NewMarquee(msgTab)
	local oneMarquee = msgTab.pb_msg_data
	if oneMarquee then
		self.hallDataManager:addOneMarqueeInfo(oneMarquee);
	end	--
end
--收到client_const常量需要刷新的消息
function HallMsgManager:on_SC_BrocastClientUpdateInfo(msgTab)
	dump(msgTab, "常量修改消息'----");
	--刷新本地常量
	local update_info = msgTab.update_info;
	--{"template":"'.$group.'"}
	local infoTab = CustomHelper.getJsonTabWithJsonStr(update_info);
	dump(infoTab["template"], "infoTab", nesting)
	dump(CustomHelper.getOneHallGameConfigValueWithKey("template"),"oldTemplate");
	-- infoTab 为空时也拉取
	if infoTab == nil  or infoTab["template"] == CustomHelper.getOneHallGameConfigValueWithKey("template") then
		--todo
		--为了减轻PHP压力，延时发送
		local delay = math.random() * 10;
		print("on_SC_BrocastClientUpdateInfo",delay)
		if self.delayRefreshConstScheduleID ~= nil then
			--todo
			return;
		end
		self.delayRefreshConstScheduleID = CustomHelper.performWithDelayGlobal(
			function()
				local versionManger = GameManager:getInstance():getVersionManager();
				versionManger:refreshClientConstConfig(function(xhr,isSuccess)
					--更新常量
					self.hallDataManager:initDataWithServerConfig(versionManger:getHallInfoConfigTab())
					self.delayRefreshConstScheduleID = nil;
					print("1----------------1")
					self:postRefreshConstConfigNotify();

					if cc.Director:getInstance():getRunningScene().getUpdatePrompt and cc.Director:getInstance():getRunningScene():getUpdatePrompt() then
						-- 提示有热更新，需要去更新
						local needUpdateInfoTabForHall = GameManager:getInstance():getVersionManager():getNeedUpdateBeforeEnterHall()
						-- -- dump(needUpdateInfoTabForHall, "needUpdateInfoTabForHall", nesting)
						if needUpdateInfoTabForHall ~= nil and table.nums(needUpdateInfoTabForHall) > 0 then -- 需要更新
							CustomHelper.showAlertView("游戏有更新，前往更新？",false,true,nil, function(tipLayer)
				                cc.Director:getInstance():getRunningScene():logoutScene()
				            end)
						end
					end
				end);
			end,
			delay
		)
	end
end
function HallMsgManager:refreshByOneSecond()
	if self.hallDataManager and self.hallDataManager:checkIsHasNeedShowMarqueeInfo()  then
		--todo
		--有符合条件的跑马灯
		CustomHelper.postOneNotify(HallMsgManager.kNotifyName_NeedShowMarqueeInfo);
	end
	if self.hallDataManager then
		local notice = self.hallDataManager:checkIsHasNeedShowNotice()
	 	--判断是否有需要弹出的公告
	 	if notice then
	 		CustomHelper.postOneNotify(HallMsgManager.kNotifyName_NeedShowNotice,notice);
	 	end 
	 end
	--检测是否有超时函数
	self:checkIsHasTimeoutMsg();
end


----后台修改支付宝信息
function HallMsgManager:on_SC_AlipayEdit(msg)
	local alipayName = msg["alipay_name"] or nil
	local alipayAccount = msg["alipay_account"] or nil
	self.playerInfo:updateAlipayBindInfo(alipayAccount,alipayName)
	self:postRefreshPlayerInfoNotify();
end

----冻结账号
function HallMsgManager:on_SC_FreezeAccount(msg)
	-- body
	self.playerInfo:setFreezeAccount(msg["status"]);
	---要弹出封号提示
	if self.playerInfo:getFreezeAccount() == 1 then --封号
		--todo
	else--解封

	end
end

-- 请求进入私人房间
function HallMsgManager:sendEnterPrivateRoomMsg(roomId)
	local tab = {
		["owner_guid"] = roomId
	}
	self:sendMsg(HallMsgManager.MsgName.CS_JoinPrivateRoom, tab)
end

-- 请求私人房间信息
function HallMsgManager:sendPrivateRoomInfoMsg()
	self:sendMsg(HallMsgManager.MsgName.CS_PrivateRoomInfo, {})
end

-- 请求创建私人房间
function HallMsgManager:sendCreatePrivateRoomMsg(gameType, roomId, guid, playerNum)
	local tab = {
		["first_game_type"] = gameType,
		["second_game_type"] = 99,
		["private_room_opt"] = 1,
		["owner_guid"] = guid,
		["private_room_chair_count"] = playerNum,
		["private_room_score_type"] = roomId
	}
	dump(tab)
	self.tempGameType = gameType
	self:sendMsg(HallMsgManager.MsgName.CS_ChangeGame, tab)
end


