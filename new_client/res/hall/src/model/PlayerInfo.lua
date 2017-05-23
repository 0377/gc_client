requireForGameLuaFile("MessageInfo")
requireForGameLuaFile("FeedbackInfo")

--[[
	用户存储玩家信息
]]
PlayerInfo = class("PlayerInfo");
PlayerInfo.AttrKey_IsGuest = "is_guest"
PlayerInfo.AttrKey_HeadIconNum			=			"header_icon"

function PlayerInfo:ctor()
    CustomHelper.addSetterAndGetterMethod(self,"playerInfoTab",{});
    --player login tab
	CustomHelper.addSetterAndGetterMethod(self,"account",nil);--玩家账号
	CustomHelper.addSetterAndGetterMethod(self,"password",nil);--玩家密码
	CustomHelper.addSetterAndGetterMethod(self,"gameID",nil);--当前游戏id
	CustomHelper.addSetterAndGetterMethod(self,"guid",nil);--唯一id
	CustomHelper.addSetterAndGetterMethod(self,"nickName",nil);--昵称
	CustomHelper.addSetterAndGetterMethod(self,"isGuest",false);
	CustomHelper.addSetterAndGetterMethod(self,"isMale",true);--性别
	--player base info
	CustomHelper.addSetterAndGetterMethod(self,"bank",0);--银行存款
	CustomHelper.addSetterAndGetterMethod(self,"loginAwardDay",0);--登录奖励，该领取那一天
	CustomHelper.addSetterAndGetterMethod(self,"loginAwardReceiveDay",0);--登录奖励，最近领取在那一天
	CustomHelper.addSetterAndGetterMethod(self,"onlineAwardTime",0);-- 在线奖励，今天已经在线时间
	CustomHelper.addSetterAndGetterMethod(self,"onlineAwardNum",0);--在线奖励，该领取哪个奖励
	CustomHelper.addSetterAndGetterMethod(self,"relief_payment_count",0);--救济金，今天领取次数
	CustomHelper.addSetterAndGetterMethod(self,"level",1);--玩家等级
	CustomHelper.addSetterAndGetterMethod(self,"money",0);--有多少钱
	-- CustomHelper.addSetterAndGetterMethod(self,"circleHeadIcon",nil);--圆形头像
	-- CustomHelper.addSetterAndGetterMethod(self,"headIcon",nil);
	CustomHelper.addSetterAndGetterMethod(self,"headIconNum",1);--头像序号
	CustomHelper.addSetterAndGetterMethod(self,"gamingInfoTab",nil);--正在游戏的信息
	CustomHelper.addSetterAndGetterMethod(self,"messageInfo",MessageInfo.new());-- 消息数据
	CustomHelper.addSetterAndGetterMethod(self,"feedbackInfo",FeedbackInfo.new());-- 反馈数据
	CustomHelper.addSetterAndGetterMethod(self,"alipayName",nil);--支付宝名字
	CustomHelper.addSetterAndGetterMethod(self,"alipayAccount",nil);--支付宝账号信息

	CustomHelper.addSetterAndGetterMethod(self,"ip_position",nil);--支付宝账号信息

	CustomHelper.addSetterAndGetterMethod(self,"enable_transfer",false);--能否转账
	CustomHelper.addSetterAndGetterMethod(self,"isFirst",2);--是否首次登陆

	CustomHelper.addSetterAndGetterMethod(self,"freezeAccount",0); ---是否封号
end
--从infoTab中赋值某个属性的值
function PlayerInfo:setOnePropertyWithKey(infoTab,key,propertyName)
	if infoTab[key] ~= nil then
		--todo
        self[propertyName] = infoTab[key];
	end 
end
--初始化登录属性
function PlayerInfo:updatePlayerPropertyWithInfoTab(infoTab)
	--更新
	--dump(infoTab, "========================33333")
	CustomHelper.updateJsonTab(self.playerInfoTab,infoTab);
	self:setOnePropertyWithKey(infoTab,"account","account");
	self:setOnePropertyWithKey(infoTab,"password","password");
	self:setOnePropertyWithKey(infoTab,"guid","guid");
	self:setOnePropertyWithKey(infoTab,"game_id","gameID");
	self:setOnePropertyWithKey(infoTab,"nickname","nickName");
	self:setOnePropertyWithKey(infoTab,"alipay_account","alipayAccount");
	self:setOnePropertyWithKey(infoTab,"alipay_name","alipayName");
	local isGuestOb = infoTab[PlayerInfo.AttrKey_IsGuest]
	if isGuestOb then
		--todo
		self:setIsGuest(CustomHelper.tobool(isGuestOb));
	end
	--检查是否更新player base info 数据
	self:setOnePropertyWithKey(infoTab,"bank","bank");
	self:setOnePropertyWithKey(infoTab,"login_award_day","loginAwardDay");
	self:setOnePropertyWithKey(infoTab,"login_award_receive_day","loginAwardReceiveDay");
	self:setOnePropertyWithKey(infoTab,"online_award_time","onlineAwardTime");
	self:setOnePropertyWithKey(infoTab,"online_award_num","onlineAwardNum");
	self:setOnePropertyWithKey(infoTab,"relief_payment_count","reliefPaymentCount");
	self:setOnePropertyWithKey(infoTab,"level","level");
	self:setOnePropertyWithKey(infoTab,"money","money");
	self:setOnePropertyWithKey(infoTab,"is_first","isFirst");
	-- local tt = infoTab["enable_transfer"]

	-- if tt == true then
	-- 	print("---------true----")
	-- elseif tt == false then
	-- 	print("---------false----")
	-- else
	-- 	print("--------fftt-----")
	-- end

	self:setOnePropertyWithKey(infoTab,"enable_transfer","enable_transfer");

	self:setOnePropertyWithKey(infoTab,"ip_area","ip_position");
	self:setOnePropertyWithKey(infoTab,PlayerInfo.AttrKey_HeadIconNum,"headIconNum");
	if self.headIconNum > 10 then
		--todo
		self.headIconNum = 10
	end
end
--根据头像得到性别
function PlayerInfo:getIsMaleByHeadIconNum(headIconNum)
	if headIconNum == nil then
		--todo
		headIconNum = self.headIconNum
	end
	local isWoman =  headIconNum < 6
	return not isWoman;
end
--得到圆形头像
function PlayerInfo:getCircleHeadIconPath()
	return CustomHelper.getFullPath("hall_res/head_icon/"..(self.headIconNum)..".png");--头像序号 1-30 
end
--得到方形头像
function PlayerInfo:getSquareHeadIconPath()
--	 print("self.headIconNum:",self.headIconNum)
	return CustomHelper.getFullPath("hall_res/head_icon/"..(self.headIconNum)..".png");
	-- return CustomHelper.getFullPath("hall_res/account/bb_grxx_txk_1.png");
end
--得到是否绑定了支付宝
function PlayerInfo:getIsBindAlipay()
	if self.alipayAccount == nil then
		--todo
		return false;
	else
		return true;
	end
end
function PlayerInfo:updateAlipayBindInfo(account,name)
	self:setAlipayAccount(account);
	self:setAlipayName(name);
end
return PlayerInfo;