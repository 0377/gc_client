--[[
	大厅数据管理器
]]
requireForGameLuaFile("HallGameConfig")
HallDataManager = class("HallDataManager");
HallDataManager.defaultTCPAddr = nil;
HallDataManager.defaultTCPPort = nil;
HallDataManager.defaultTCPConnectionID = 1;

--保存的账号key
HallDataManager.SaveAccountKey = "SaveAccountKey"
HallDataManager.SavePwdKey	   = "SavePwdKey"
HallDataManager.SavaShowPrivacy = "SavaShowPrivacy" --是否显示过隐私条款
HallDataManager.SaveTodayKey = "SaveTodayKey" --当前日期的时间戳
HallDataManager.NOTICE_TYPE = 
{
	HALL_NOTICE = 2,-- 2大厅公告
	HORSE_RACE_LAMP = 3, -- 3跑马灯
	GLOBAL_NOTICE = 4,-- 4全服公告
	GAME_NOTICE = 5,-- 5游戏房间公告
	DAY_NOTICE = 6,-- 6每日公告
}

function HallDataManager:ctor()
	CustomHelper.addSetterAndGetterMethod(self,"tcpAddr",HallDataManager.defaultTCPAddr);--tcp连接地址
	CustomHelper.addSetterAndGetterMethod(self,"tcpPort",HallDataManager.defaultTCPPort);--tcp连接端口
	CustomHelper.addSetterAndGetterMethod(self,"connectionID",HallDataManager.defaultTCPConnectionID);--tcp连接状态
	self.connectionStatus = NetworkManager.TCPConnectionStatus.TCPConnectionStatus_Close;
	CustomHelper.addSetterAndGetterMethod(self,"publicKey",nil);--登录密码加密key
	CustomHelper.addSetterAndGetterMethod(self,"gameServerList",nil);--服务器开放的列表，每一种游戏对应多个一个服务器，game_id唯一
	CustomHelper.addSetterAndGetterMethod(self,"allOpenGamesDeatilTab",nil);--所有开放游戏的信息
	CustomHelper.addSetterAndGetterMethod(self,"curSelectedGameDetailInfoTab",nil);--当前选择游戏的详情
	-- CustomHelper.addSetterAndGetterMethod(self,"hallInfoTab",nil);--大厅信息
	CustomHelper.addSetterAndGetterMethod(self,"HallGameConfigTab",nil);--大厅配置
	CustomHelper.addSetterAndGetterMethod(self,"wordVerifyData",nil);
	self.marqueeArrayFromServer = nil;--从服务器收到的跑马灯消息
	CustomHelper.addSetterAndGetterMethod(self,"marqueeArray",{});
	CustomHelper.addSetterAndGetterMethod(self,"exchangeListData",nil);
	CustomHelper.addSetterAndGetterMethod(self,"serverIntervalTime",0);	-- 服务器时间减去客服端时间
	-- CustomHelper.addSetterAndGetterMethod(self,"allGameRoomList",nil);--服务器返回的所有房间列表信息，k为游戏类型，v为游戏房间列表
	-- CustomHelper.addSetterAndGetterMethod(self,"hallGameOrderList",nil);--大厅游戏排序
	CustomHelper.addSetterAndGetterMethod(self,"notices",{});	
	CustomHelper.addSetterAndGetterMethod(self,"gameSwitch");--游戏开关
	self.serverIndex = 1;
end
function HallDataManager:resetServerIndex()
	self.serverIndex = 1;
	self:refreshTCPIPAndPort();
end
function HallDataManager:getConnectionStatus()
	return self.connectionStatus;
end
-- 设置连接状态
function HallDataManager:setConnectionStatus(status)
	self.connectionStatus = status;
	if status == NetworkManager.TCPConnectionStatus.TCPConnectionStatus_Close then
		--todo
		self.publicKey = nil;
	end
end
--根据http请求返回的大厅数据 初始化数据
function HallDataManager:initDataWithServerConfig(hallInfoTab)
	print("HallDataManager:initDataWithServerConfig")
	self.ipAddrArray = hallInfoTab["addr"]
	self:refreshTCPIPAndPort()
	self:setHallGameConfigTab(hallInfoTab["config"]);
end
--刷新服务器地址
function HallDataManager:refreshTCPIPAndPort()
	local serverAddrInfoStr = self.ipAddrArray[self.serverIndex];
	if serverAddrInfoStr then
		--todo
		local serverAddrInfoTab = string.split(serverAddrInfoStr, "#")
		self:setTcpAddr(serverAddrInfoTab[1]);
		self:setTcpPort(serverAddrInfoTab[2]);
		self.serverIndex = self.serverIndex + 1;
		return true;
	else
		return false;
	end
end
--得到hall config tab中某个key的值
function HallDataManager:getOneHallGameConfigValueWithKey(key)
	return self.HallGameConfigTab[key];
end
--处理从服务器返回的 服务器列表信息,将其转化为1种游戏对应多个2级房间
function HallDataManager:dealWithServerList(infoTab)
	local allOpenGames = infoTab.pb_cfg;
	self:setGameServerList(allOpenGames);
	if allOpenGames ~= nil then
		--todo
		--根据开放游戏，处理需要显示的游戏列表
		local allGameConstTab = HallGameConfig.allGames;
		-- dump(infoTab, "infoTab", nesting)
		-- dump(allGameConstTab, "allGameConstTab", nesting)
		local allGameDetailTab = {};
		for gameType,v in pairs(allGameConstTab) do
			--二级房间
			local secondRoomList = v[HallGameConfig.SecondRoomKey];--排列序号为显示序号
			local oneGameDetailTab = {};--一种游戏详情
			local openSecondRoomTab = {};
			for i,oneSecondRoom in ipairs(secondRoomList) do
				local gameSubType = oneSecondRoom[HallGameConfig.SecondRoomIDKey];
				local tempIsOpen = false;
				local oneOpenGameConfig = nil;
				--从服务器中返回的数据中，刷选出来
				for j,oneOpenGameConfig in ipairs(allOpenGames) do
					local tempGameType = oneOpenGameConfig["first_game_type"];
					local tempSubType = oneOpenGameConfig["second_game_type"];
					-- print("gameType",gameType,",gameSubType",gameSubType,",tempGameType:",tempGameType,",tempSubType",tempSubType)
					if gameType == tempGameType and gameSubType == tempSubType then
						--todo
						tempIsOpen = true;
						local tempOneRoomDetailTab = CustomHelper.copyTab(oneSecondRoom);
						if tempOneRoomDetailTab then
							--todo
							CustomHelper.updateJsonTab(tempOneRoomDetailTab,oneOpenGameConfig);
							table.insert(openSecondRoomTab,tempOneRoomDetailTab);
						end
						break;
					end
				end
				-- if tempIsOpen then --该二级房 开放
				-- 	--todo
				-- 	local tempOneRoomDetailTab = CustomHelper.copyTab(oneSecondRoom);
				-- 	table.insert(openSecondRoomTab,tempOneRoomDetailTab);
				-- end
			end
			if table.nums(openSecondRoomTab) > 0 then --该游戏有开放
				--todo
				oneGameDetailTab = CustomHelper.copyTab(v);
				oneGameDetailTab[HallGameConfig.SecondRoomKey] = openSecondRoomTab;
				--dump(oneRommDetailTab, "oneRommDetailTab", nesting)
				allGameDetailTab[gameType] = oneGameDetailTab;
			end
		end
		self:setAllOpenGamesDeatilTab(allGameDetailTab);
	else
		self:setAllOpenGamesDeatilTab(nil);
	end
	 dump(self.allOpenGamesDeatilTab, "allGameDetailTab", 100)
end
--保存玩家登录账号
function HallDataManager:savePlayerAccountInfo(account,pwd)
	local userDefault = cc.UserDefault:getInstance();
	userDefault:setStringForKey(HallDataManager.SaveAccountKey,account);
	userDefault:setStringForKey(HallDataManager.SavePwdKey,pwd);
	userDefault:flush();
end

function HallDataManager:savaShowPrivacy(showPrivacy)
	-- body
	local userDefault = cc.UserDefault:getInstance();
	userDefault:setBoolForKey(HallDataManager.SavaShowPrivacy,showPrivacy);
end

function HallDataManager:getSavaShowPrivacy()
	return cc.UserDefault:getInstance():getBoolForKey(HallDataManager.SavaShowPrivacy);
end

function HallDataManager:getSavePlayerAccount()
	local account = cc.UserDefault:getInstance():getStringForKey(HallDataManager.SaveAccountKey);
	if account == "" then
		--todo
		account = nil;
	end
	return account;
end
function HallDataManager:getSavePlayerPwd()
	local pwd = cc.UserDefault:getInstance():getStringForKey(HallDataManager.SavePwdKey);
	if pwd == "" then
		--todo
		pwd = nil;
	end
	return pwd;
end
function HallDataManager:reset()
	self.wordVerifyData = nil;
	self.marqueeArray = nil;
	self.marqueeArrayFromServer = nil
	self.exchangeListData = nil;
	self.gameSwitch = nil;
end
function HallDataManager:getServerTime()
	return socket.gettime() + self:getServerIntervalTime()
end
--
function HallDataManager:getMarqueeArrayFromServer()
	return self.marqueeArrayFromServer;
end
function HallDataManager:setMarqueeArrayFromServer(marueeInfoArray)
	if self.marqueeArrayFromServer ~= nil then
		--todo
		for i,needCleanMarquee in ipairs(self.marqueeArrayFromServer) do
			CustomHelper.removeItem(self.marqueeArray,needCleanMarquee);
		end
	end
	self.marqueeArrayFromServer = marueeInfoArray;
	for i,v in ipairs(marueeInfoArray) do
		self:addOneMarqueeInfo(v)
	end
end

--添加公告
function HallDataManager:addNewNotice( msg )
	--dump(msg)
	self.notices = self.notices or {}
	table.insert(self.notices,msg)
	--dump(self.notices)
end
--增加一条跑马灯消息
function HallDataManager:addOneMarqueeInfo(marqueeInfo)
	marqueeInfo.showTimes = 0;--已经显示次数
	marqueeInfo.preShowTime = 0;--上一次显示的时间，默认为0
	if self.marqueeArray == nil then
		self.marqueeArray = {};
	end
	table.insert(self.marqueeArray,marqueeInfo); 
end
--得到下一条需要显示的
function HallDataManager:getNextNeedShowMarqueeInfo(index)
	local marqueeInfo = self:checkIsHasNeedShowMarqueeInfo();

	return marqueeInfo
end
--显示完成后
function HallDataManager:callbackWhenOneMarqueeShowFinished(marqueeInfo)
	if marqueeInfo then
		--todo
		marqueeInfo.showTimes = marqueeInfo.showTimes + 1
		marqueeInfo.preShowTime = self:getServerTime();
	end
end
--检测是否有需要显示的跑马灯
function HallDataManager:checkIsHasNeedShowMarqueeInfo(index)
	if self.marqueeArray == nil then
		--todo
		return nil;
	end
	if index == nil then
		index = 1;
	end
	local marqueeInfo = self.marqueeArray[index];
	if marqueeInfo == nil then
		return nil
	end
	--检测marquee是否在有效期内
		--[[
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
	local serverTime = self:getServerTime();
	--判断是否开启
	if marqueeInfo.start_time ~= nil  then
		--todo
		if marqueeInfo.start_time > serverTime  then -- 还没有到开启时间
			--todo
			index = index + 1;
			return self:checkIsHasNeedShowMarqueeInfo(index);
		end
	end
	--判断是否结束
	--todo
	if  marqueeInfo.end_time ~= nil then
		if serverTime > marqueeInfo.end_time then
			--todo
			CustomHelper.removeItem(self.marqueeArray,marqueeInfo);
			return self:checkIsHasNeedShowMarqueeInfo(index);
		end
	end
	--判断 轮播次数是否结束
	if marqueeInfo.number ~= nil and marqueeInfo.number > 0  then
		--todo
		if marqueeInfo.showTimes >= marqueeInfo.number  then
		  --todo
		  	--次数已经播完
		  	CustomHelper.removeItem(self.marqueeArray,marqueeInfo);
			return self:checkIsHasNeedShowMarqueeInfo(index);
		end
	end
	--判断时间间隔是否到达
	if marqueeInfo.interval_time ~= nil and marqueeInfo.interval_time > 0 then
		--todo
		if serverTime - marqueeInfo.preShowTime  < marqueeInfo.interval_time then --还没有到时间间隔
		   --todo
		   index = index + 1;
		   return self:checkIsHasNeedShowMarqueeInfo(index);
		end
	end
	-- dump(marqueeInfo, "marqueeInfo=", 100)
	return marqueeInfo
end

function HallDataManager:checkIsHasNeedShowNotice()
	
-- 	HallDataManager.NOTICE_TYPE = 
-- {
-- 	HALL_NOTICE = 2,-- 2大厅公告
-- 	HORSE_RACE_LAMP = 3, -- 3跑马灯
-- 	GLOBAL_NOTICE = 4,-- 4全服公告
-- 	GAME_NOTICE = 5,-- 5游戏房间公告
-- 	DAY_NOTICE = 6,-- 6每日公告

-- }
	local serverTime = self:getServerTime();
	if not self:getCurSelectedGameDetailInfoTab() then
		for _, v in ipairs(self.notices) do
			if serverTime > v.StartTime and serverTime < v.EndTime  then
				--大厅未读公告
				if v._Content.content_type and (tonumber(v._Content.content_type) == self.NOTICE_TYPE.GLOBAL_NOTICE or tonumber(v._Content.content_type) == self.NOTICE_TYPE.HALL_NOTICE) and not v.Readed then
					return v
				elseif v._Content.content_type and tonumber(v._Content.content_type) == self.NOTICE_TYPE.DAY_NOTICE then --每日公告
					 --print("每日公告")
					 local day = os.date("%y-%m-%d", serverTime)
					 local saveDay = self:getDayNoticeReadTime(v.Id)
					 --print("saveDay:",saveDay)
					 --print("day:",day)
					 if day ~= saveDay then
					 	return v
					 end
				end
			end
		end
	else
		--游戏未读公告
		for _, v in ipairs(self.notices) do
			if serverTime > v.StartTime and serverTime < v.EndTime and not v.Readed then
				if v._Content.content_type and tonumber(v._Content.content_type) == self.NOTICE_TYPE.GLOBAL_NOTICE 
				or (tonumber(v._Content.content_type) == self.NOTICE_TYPE.GAME_NOTICE and tonumber(v._Content.game_id or 0) == tonumber(self.curSelectedGameDetailInfoTab['game_id'] or 1)) then
					return v
				end
			end
		end
	end
	return nil
end

--秒刷新函数
function HallDataManager:refreshByOneSecond()
	

end
--保存每日公告读取时间
function HallDataManager:saveDayNoticeReadTime(noticeID)
	local userDefault = cc.UserDefault:getInstance();
	local serverTime = self:getServerTime();
	local day = os.date("%y-%m-%d", serverTime)
	userDefault:setStringForKey(noticeID,day);
	userDefault:flush();
end
--获取保存的每日公告上次读取时间
function HallDataManager:getDayNoticeReadTime(noticeID)
	local day = cc.UserDefault:getInstance():getStringForKey(noticeID);
	if day == "" then
		--todo
		day = nil;
	end
	return day;
end
return HallDataManager;