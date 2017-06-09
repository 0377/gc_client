--[[
	用于控制testgame中相关数据
]]
GFlowerGameDataManager = class("GFlowerGameDataManager");
local GFlowerGameScene = requireForGameLuaFile("GFlowerGameScene");
local GFlowerPlayerInfo = requireForGameLuaFile("GFlowerPlayerInfo")
local scheduler = cc.Director:getInstance():getScheduler()

-- 数据初始化
function GFlowerGameDataManager:ctor()

    self._enterRoomAndSitDownInfo = nil     -- 房间玩家及其对应的桌号信息
    self.roomAndPlayerState       = nil     -- 自己进入前，已经房间状态 和 已经存在的玩家状态
    self.roomInfo                 = nil    -- 房间参数信息（进场最少需要多少钱、底注等信息）
    self.MinJettonMoney           = 0     -- 进入需要最小金币数量  和 底注
    self.MinJetton                = 0 

    self.roomNum = nil 

    CustomHelper.addSetterAndGetterMethod(self,"gfPlayers", {})

    self.playerOrder = {}
    self.validPlayerTag = {}                -- 有效玩家标志
    for i = 1, GFlowerConfig.CHAIR_COUNT do
       self.playerOrder[i]       = 0
       self.validPlayerTag[i]    = 0
    end

    self.outJiesuanPlayersCount       = 0    -- 退出的结算玩家数量
    self.outJieSuanPlayers             = {}  -- 已经退出的结算玩家
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        self.outJieSuanPlayers[i]     = {}
    end

    -- 是否是重新进入该房间
    -- 是新进入需要 获取房间信息，上局就在房间的人不能新获取房间信息
    self.is_newIn = true
    self.myServerChairId    = 0             -- 在服务器中的椅子位置
    self.deskAllMoney       = 0             -- 桌上总筹码数量
    self.countDown          = 0             -- 倒计时

    self.roundNum           = 0             -- 轮数(记录玩家的轮数，取最大轮数既是当前轮数)

    self.doing_id           = 0             -- 当前正在操作的玩家 clientid
    self.follow_num         = 1             -- 当前跟注 筹码编号
    self.follow_money       = 0             -- 当前单注大小 金币数量
    self.isSelfLookCard     = false         -- 自己是否已经看牌
    self.room_state         = GFlowerConfig.ROOM_STATE.FREE  -- 房间状态
    self.gendaodi           = false         -- 是否跟到底
    self.is_AllIn           = false         -- 对方是否是全下
    self.is_add             = false         -- 加注标志
    self.huanzhuo           = false
    self.all_Compare        = false         -- 是否是全场比牌
    self.StandUp            = false         -- 进入没准备 被t
	
	--  私人房间相关数据
	self.selScoreIdx        = 0             -- 当前选择的基础分数索引（私人房间）
	self.isPrivateRoom      = false         -- 私人房间
	self.isInPRReady        = false         -- 私人房间的准备状态
	self.isInPRJieSan       = false         -- 私人房间的解散状态
	self.isNeedPRoomPro     = true          -- 是否需要获取私人房间属性
	self.isFirstLookCard    = false         -- 第一轮是否看牌
	self.isFirstCompare     = false         -- 第一轮是否比牌
	self.isNoMoneyCompare   = false         -- 没钱是否可以比牌
	self.isMoreRound        = false         -- 轮数是否更多
	self.isLastGame         = false         -- 是否是最后一局
end

-- 初始化数据
function GFlowerGameDataManager:InitData()
	-- 私人房间
	if self.isPrivateRoom == true then		
		self:calPRJetton()
	else
		-- 房间参数信息（进场最少需要多少钱、底注等信息）
		self.roomInfo = GameManager:getInstance():getHallManager():getHallDataManager():getCurSelectedGameDetailInfoTab();
		-- 进入需要最小金币数量  和 底注
		self.MinJettonMoney = self.roomInfo[HallGameConfig.SecondRoomMinMoneyLimitKey]
		self.MinJetton = self.roomInfo[HallGameConfig.SecondRoomMinJettonLimitKey]

		-- 根据房间编号 初始化筹码比例
		self.roomNum = self.roomInfo["second_game_type"]
		GFlowerConfig.ADD_BTN_TIMES = GFlowerConfig.ADD_BTN_TIMES_LIST[self.roomNum]
	end
	
    self.is_newIn = true
    self:resetMainTableData()         -- 下面为本局结束需要清除的数据
end

-- 重置上局的数据
function GFlowerGameDataManager:resetMainTableData()
    self.deskAllMoney = 0                   -- 桌上总筹码数量
    self.roundNum = 1                       -- 轮数
    self.doing_id = 0                       -- 当前正在操作的玩家
    self.follow_num = 1                     -- 当前跟注 大小 默认为100
    self.follow_money = self.MinJetton      -- 当前跟注 金币数量
    self.isSelfLookCard = false             -- 自己是否已经看牌
    self.room_state = GFlowerConfig.ROOM_STATE.FREE     -- 房间状态 
    self.gendaodi = false                   -- 是否选择了跟到底
    self.is_AllIn = false                   -- 对方是否是全下
    self.is_add = false                     -- 加注标志
    self.huanzhuo = false
    self.all_Compare = false                -- 是否是全场比牌
    self.StandUp = false                    -- 进入没准备 被t
end

-- 进入房间时保存房间数据 点击进入 和 换桌时调用 
function GFlowerGameDataManager:_onMsg_EnterRoomAndSitDownInfo( infoTab )
    print("GFlowerGameDataManager:_onMsg_EnterRoomAndSitDownInfo ===========================")
    self._enterRoomAndSitDownInfo = infoTab

    self.myServerChairId = infoTab.chair_id
    -- 重置为首次进入
    self.is_newIn = true

    --dump(msgTab, "---进入房间-桌子信息- ---");
    local client_id = self:getLocalChairId(infoTab.chair_id)

    local gfPlayer = GFlowerPlayerInfo:create()
    gfPlayer:updatePlayerPropertyWithInfoTab(infoTab)
    gfPlayer:setClientChairId(client_id)
    local playerInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
    gfPlayer:setMoney(playerInfo:getMoney())
    gfPlayer:setChairId(self.myServerChairId)
    gfPlayer:setGuid(playerInfo:getGuid())
    gfPlayer:setNickName(sx_SubStringUTF8(playerInfo:getIp_position(), 12))
    if playerInfo:getHeadIconNum() == 0 then 
        gfPlayer:setHeadIconNum(1)            -- 默认头像为1
    else
        gfPlayer:setHeadIconNum(playerInfo:getHeadIconNum())
    end

    self.gfPlayers[gfPlayer:getChairId()] = gfPlayer

    print("GFlowerGameDataManager:_onMsg_EnterRoomAndSitDownInfo.1  新增玩家: ",gfPlayer:getChairId()," GUID: ",gfPlayer:getGuid(),"ClientID: ",client_id)
    dump(infoTab.pb_visual_info,"infoTab.pb_visual_info")
    -- 已经在房间内的玩家
    local players = infoTab.pb_visual_info
    if players ~= nil then
        for k, player in pairs(players) do

            local othergfPlayer = GFlowerPlayerInfo:create()
            othergfPlayer:updatePlayerPropertyWithInfoTab(player)
            local client_id = self:getLocalChairId(othergfPlayer:getChairId())
            othergfPlayer:setClientChairId(client_id)
            if othergfPlayer:getHeadIconNum() == 0 then 
                othergfPlayer:setHeadIconNum(1)            -- 默认头像为1
            end

            print("GFlowerGameDataManager:_onMsg_EnterRoomAndSitDownInfo.2  新增玩家: ",othergfPlayer:getChairId()," GUID: ",othergfPlayer:getGuid(),"ClientID: ",client_id)
            self.gfPlayers[othergfPlayer:getChairId()] = othergfPlayer
        end
    end

    self:recalPlayerClientId()
end

-- 重新计算一次每个玩家的客户端座位号,以防止在后续的计算中取不到玩家的座位ID
function GFlowerGameDataManager:recalPlayerClientId()
    for k,player in pairs(self.gfPlayers) do
        if player:getClientChairId() == nil then
            local client_id = self:getLocalChairId(player:getChairId())
            player:setClientChairId(client_id)
        end
    end
end

-- 计算私人房间的底注
function GFlowerGameDataManager:calPRJetton()
	-- 进入需要最小金币数量  和 底注
	local seldata = GFlowerConfig.PRIVATE_ROOM[self.selScoreIdx]
	dump(seldata, "seldata")
	
    self.MinJettonMoney = seldata.money_limit
    self.MinJetton 		= seldata.score[1]

    GFlowerConfig.ADD_BTN_TIMES = GFlowerConfig.ADD_BTN_TIMES_LIST[1]
end

-- 重连获取房间信息
function GFlowerGameDataManager:_onMsg_ReConnectInfo( infoTab )
    --dump(infoTab,"infoTab")
    -- 首先就初始化自己id
    self.myServerChairId = infoTab.chair_id

    local players = infoTab.pb_visual_info
    if players ~= nil then
        for k, player in pairs(players) do

            local othergfPlayer = GFlowerPlayerInfo:create()
            othergfPlayer:updatePlayerPropertyWithInfoTab(player)
            local client_id = self:getLocalChairId(othergfPlayer:getChairId())
            othergfPlayer:setClientChairId(client_id)
            if othergfPlayer:getHeadIconNum() == 0 then 
                othergfPlayer:setHeadIconNum(1)            -- 默认头像为1
            end

            self.gfPlayers[othergfPlayer:getChairId()] = othergfPlayer
        end
    end
end

-- 获取私人房间的房主ID
function GFlowerGameDataManager:getPRMaster()
	if self.gfPlayers ~= nil and table.nums(self.gfPlayers) > 0 then
        for k, v in pairs(self.gfPlayers) do
			if v:getChairId() == GFlowerConfig.PR_MASTER then
				return v:getClientChairId()
            end
        end
    end
	
	return 0
end

-- 是否是房主
function GFlowerGameDataManager:isPRMaster()
	if self.myServerChairId == GFlowerConfig.PR_MASTER then
		return  true
	end
	
	return false
end

-- 自己进入时得到已经存在的玩家的状态
function GFlowerGameDataManager:S2C_ZhaJinHuaWatch(msgTab)
    -- 获取房间其他玩家状态
    self.roomAndPlayerState = msgTab

    -- 重置为首次进入
    self.is_newIn = true

    -- 获取状态返回 置为 false
    self.StandUp = false

    -- 状态消息回来后再刷新界面（准备）
    self:dealZhaJinHuaWatch()
end

function GFlowerGameDataManager:S2C_ZhaJinHuaTabCFG(msgTab)
	dump(msgTab)
	self.isPrivateRoom = true
	self.isInPRReady   = true
	self.selScoreIdx   = msgTab.score_type
end

function GFlowerGameDataManager:S2C_ZhaJinHuaTabVote(msgTab)

end

function GFlowerGameDataManager:setInPRJiesanState(stat )
	self.isInJieSan = stat
end

function GFlowerGameDataManager:S2C_ShowTax(msgTab)
    dump(msgTab, "税收开关--------------------------------")
    local isshow_shuishou = msgTab.flag

    if isshow_shuishou == GFlowerConfig.TAX.OPEN then
        self.is_shuishou = true
    else
        self.is_shuishou = false
    end
end

-- 重新设置房间状态 和 玩家状态（玩家断线重连上来的时候调用）
function GFlowerGameDataManager:resetRoomAndPlayerState()
    
    -- 获取房间其他玩家状态
    local allRoomInfo = self.roomAndPlayerState

    --dump(allRoomInfo,"allRoomInfo")

    -- 房间状态
    self.room_state = allRoomInfo.room_status

    -- 当前玩家clientid
    if allRoomInfo.banker_chair_id ~= nil then
        self.doing_id = self:getLocalChairId(allRoomInfo.banker_chair_id)
    end

    -- 回合数
    if allRoomInfo.round ~= nil then
        self.roundNum = allRoomInfo.round - 1
    end

    -- 计算 当前跟注筹码编号  和 当前跟注金币数 allstate.score = 100
    if allRoomInfo.score ~= nil then
        self:setFollowType(allRoomInfo.score)
    end

    --桌上总筹码数量
    if allRoomInfo.totalmoney ~= nil then
        self.deskAllMoney = allRoomInfo.totalmoney 
    end
    --print("桌上总筹码数量--------------："..self.deskAllMoney)
    ---------------------------------------------------------------------------------

    -- 玩家下注的金币
    local playermoney = allRoomInfo.playermoney

    if playermoney ~= nil then
        --dump(playermoney,"playermoney")
        for server_id, money in pairs(playermoney) do
            local gfPlayer = self:getGfPlayers()[server_id]
            if gfPlayer ~= nil then
                gfPlayer:setDownMoney( money )
            end
        end
    end

    -- 看牌玩家列表
    local look_list = allRoomInfo.isseecard
    -- 玩家状态
    local server_state = allRoomInfo.status

    if server_state ~= nil then
        for server_id, state in pairs(server_state) do
            --if state ~= 0 then
            local client_chairid = self:getLocalChairId(server_id)
            local tempPlayer = self:getGFPlayerByClientId(client_chairid)
            if tempPlayer ~= nil then 
                if state == GFlowerConfig.PLAYER_STATUS.WAIT
                or state == GFlowerConfig.PLAYER_STATUS.COMPARE then
                    tempPlayer:setGameState(GFlowerConfig.PLAYER_STATUS.CONTROL)
                else
                    tempPlayer:setGameState(state)
                end
            end
        end
    end

    -- 如果玩家处于弃牌和淘汰的情况 不能用看牌去覆盖状态
    if look_list ~= nil then
        for server_id, state in pairs(look_list) do
            if state then
                local client_chairid = self:getLocalChairId(server_id)
                local tPlayer = self:getGFPlayerByClientId(client_chairid)
                if tPlayer ~= nil then
                    local state1 = tPlayer:getGameState()
                    -- 如果玩家当前状态为 准备下注 、准备操作、 比牌 这些状态，直接替换状态为看牌
                    if state1 == GFlowerConfig.PLAYER_STATUS.WAIT
                    or state1 == GFlowerConfig.PLAYER_STATUS.CONTROL
                    or state1 == GFlowerConfig.PLAYER_STATUS.COMPARE then
                        tPlayer:setGameState(GFlowerConfig.PLAYER_STATUS.LOOK)
                    end
                end
            end
        end
    end

    -- 获取当前本桌下注收吗
    self.coinList = allRoomInfo.allbet
end

-- 根据玩家serverid 刷新玩家金币
function GFlowerGameDataManager:UpdatePlayerMoney(server_id, money_num) -- self.follow_money
    local money = 0
    local down_money = 0
    local gfplayer = self:getGfPlayers()[server_id]
    if gfplayer ~= nil then
        money       = gfplayer:getMoney()
        down_money  = gfplayer:getDownMoney()
        -- 减去自身金币
        if money - money_num <= 0 then
            money = 0
        else
            money = money - money_num
        end

        -- 增加下注金币
        down_money = down_money + money_num

        --桌上总筹码数量 加上一次跟注
        self.deskAllMoney = self.deskAllMoney + money_num --self.follow_money

        gfplayer:setMoney(money)
        gfplayer:setDownMoney(down_money)
    end
end


function GFlowerGameDataManager:dealZhaJinHuaWatch()
    -- 如果是新进入该桌的玩家
    print("GFlowerGameDataManager:dealZhaJinHuaWatch    WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW")
    if self.is_newIn == true then
        
        --清除所有数据
        self:InitData()

        -- 下次进入 不会再去获取该桌玩家信息
        self.is_newIn = false
       
        self:resetRoomAndPlayerState()
    else
        self:resetMainTableData()
    end
end

-- 换桌返回
function GFlowerGameDataManager:S2C_ChangeTable( msgTab )
    --print("--------------------------------------------换桌返回")
    self.huanzhuo = true

    -- 根据得到的桌子数据刷新界面
    self:_onMsg_EnterRoomAndSitDownInfo(msgTab)
end

function GFlowerGameDataManager:getGFPlayerByClientId(clientId)
    if self.gfPlayers ~= nil and table.nums(self.gfPlayers) > 0 then
        for k, v in pairs(self.gfPlayers) do
            if clientId == v:getClientChairId() then
                return v
            end
        end
    end

    return nil
end

function GFlowerGameDataManager:getGFPlayerCount()
	return table.nums(self.gfPlayers)
end

function GFlowerGameDataManager:getGFPayerByGuid(guid)
    if self.gfPlayers ~= nil and table.nums(self.gfPlayers) > 0 then
        for k, player in pairs(self.gfPlayers) do
            if guid == player:getGuid() then
                return player
            end
        end
    end

    return nil
end

function GFlowerGameDataManager:clearGFPlayerByClientId(clientId)
    if self.gfPlayers ~= nil and table.nums(self.gfPlayers) > 0 then
        for k, v in pairs(self.gfPlayers) do
            if clientId == v:getClientChairId() then
                self.gfPlayers[k] = nil
                break
            end
        end
    end
end

-- 准备返回
function GFlowerGameDataManager:S2C_Ready( msgTab )
    -- 初始化完成执行
    local server_chairid = msgTab.ready_chair_id
    local client_chair_id = self:getLocalChairId(server_chairid)
    print(" GFlowerGameDataManager:S2C_Ready ......................CHAIRID: ",client_chair_id)
    if client_chair_id ~= nil then
        if self.room_state ~= GFlowerConfig.ROOM_STATE.PLAY then
            -- 更新玩家状态
            self.gfPlayers[server_chairid]:setGameState(GFlowerConfig.PLAYER_STATUS.READY)
            --dump(self.playerState, "---有玩家准备");
        end
    end
end

--自己离开房间
function GFlowerGameDataManager:S2C_StandUpAndExitRoom( msgTab )
    print("GFlowerGameDataManager:S2C_StandUpAndExitRoom  .............")
    self:InitData()
end

function GFlowerGameDataManager:setAllPlayerState(vv)
   if self.gfPlayers ~= nil and table.nums(self.gfPlayers) > 0 then
        for k,v in pairs(self.gfPlayers) do
            v:setGameState(vv)
        end
    end
end

--其他玩家进入 (中途进入)
function GFlowerGameDataManager:S2C_NotifySitDown( msgTab ) 

    local server_chairid = msgTab.pb_visual_info["chair_id"]
    local money = msgTab.pb_visual_info["money"]
    local nickname = msgTab.pb_visual_info["nickname"]
    local headericon = msgTab.pb_visual_info["header_icon"]
    local ip_area = msgTab.pb_visual_info["ip_area"]

    -- 先查看桌上是否有该玩家 如果有就是重连进来
    -- 不重新刷新玩家信息
    local is_intable = false
    for serverID, gfplayer in pairs(self.gfPlayers) do
        if server_chairid == gfplayer:getChairId() then
            if playerid ~= 0 then
                is_intable = true
            end
        end
    end

    if is_intable == false then

        local client_id = self:getLocalChairId(server_chairid) 

        local new_gfPlayer = GFlowerPlayerInfo:create()
        new_gfPlayer:updatePlayerPropertyWithInfoTab(msgTab.pb_visual_info)
        new_gfPlayer:setClientChairId(client_id)
        new_gfPlayer:setChairId(server_chairid)
        if new_gfPlayer:getHeadIconNum() == 0 then 
            new_gfPlayer:setHeadIconNum(1)            -- 默认头像为1
        end
    
        --dump(msgTab.pb_visual_info,"msgTab.pb_visual_info")
        self.gfPlayers[server_chairid] = new_gfPlayer
    else
        -- 首先从已退出玩家表中删除 ??????(有 BUG )
        local client_id = self:getLocalChairId(server_chairid) 

        local old_gfPlayer = self:getGfPlayers()[server_chairid]
        old_gfPlayer:updatePlayerPropertyWithInfoTab(msgTab.pb_visual_info)
        old_gfPlayer:setClientChairId(client_id)
        if old_gfPlayer:getHeadIconNum() == 0 then 
            old_gfPlayer:setHeadIconNum(1)            -- 默认头像为1
        end

        self.gfPlayers[server_chairid] = old_gfPlayer
    end
end

--其他玩家退出
function GFlowerGameDataManager:S2C_NotifyStandUp(msgTab)
    local server_id = msgTab.chair_id
    local client_chair = self:getLocalChairId(server_id)
    
    -- 如果退出玩家在玩玩家不是自己就暂时记录下来供结算使用
    if server_id ~= self.myServerChairId then
        local gfplayer  = self:getGFPlayerByClientId(client_chair)
        if  gfplayer ~= nil  then
            local  state = gfplayer:getGameState()
            if state == GFlowerConfig.PLAYER_STATUS.LOOK or 
               state == GFlowerConfig.PLAYER_STATUS.CONTROL or 
               state == GFlowerConfig.PLAYER_STATUS.DROP or 
               state == GFlowerConfig.PLAYER_STATUS.LOSE then
                   self.outJiesuanPlayersCount = self.outJiesuanPlayersCount + 1
                   self.outJieSuanPlayers[self.outJiesuanPlayersCount]["guid"]       = gfplayer:getGuid()
                   self.outJieSuanPlayers[self.outJiesuanPlayersCount]["name"]       = gfplayer:getNickName()
                   self.outJieSuanPlayers[self.outJiesuanPlayersCount]["downMoney"]  = gfplayer:getDownMoney()
                   self.outJieSuanPlayers[self.outJiesuanPlayersCount]["headicon"]   = gfplayer:getHeadIconNum()
                   self.outJieSuanPlayers[self.outJiesuanPlayersCount]["client_id"]  = client_chair
                   self.outJieSuanPlayers[self.outJiesuanPlayersCount]["state"]      = state
               end

            --dump(self.outJieSuanPlayers," S2C_NotifyStandUp ~~~~~~~~~~~~ outPlayer")
            self:clearGFPlayerByClientId(client_chair)
        end
    end
end

-- 清除结算面板的玩家信息
function GFlowerGameDataManager:clearOutJieSuanPlayer()
    self.outJiesuanPlayersCount       = 0   -- 退出的结算玩家数量
    self.outJieSuanPlayers             = {}  -- 已经退出的结算玩家
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        self.outJieSuanPlayers[i]     = {}
    end
end

-- 获取已经退出的玩家信息
function GFlowerGameDataManager:getOutJieSuanPlayerByGuid(guid)
    for idx = 1, GFlowerConfig.CHAIR_COUNT do 
       if self.outJieSuanPlayers[idx]["guid"]  == guid then
           return self.outJieSuanPlayers[idx]
       end
    end

    return nil
end

-- 把本地椅子号 转化为服务器椅子号 便于发送比牌消息
function GFlowerGameDataManager:getServerChairId( chair_client )
     local gfplayer = self:getGFPlayerByClientId(chair_client)
     return gfplayer:getChairId()
end

-- 计算发牌顺序
function GFlowerGameDataManager:setPlayerOrder( begin_chair )
    --dump(self.playersID, "----------计算发牌顺序：玩家列表");

    -- 清空排序
    self.playerOrder = {}
    for i = 1, GFlowerConfig.CHAIR_COUNT do
        self.playerOrder[i] = 0
    end

    local index = 1
    for i = begin_chair, GFlowerConfig.CHAIR_COUNT + begin_chair - 1 do
        -- 如果玩家是准备状态 则说明可以发牌给他
        local idx = i%GFlowerConfig.CHAIR_COUNT
        if idx == 0 then
            idx = GFlowerConfig.CHAIR_COUNT
        end
        local player = self:getGfPlayers()[idx]
        if player ~= nil then
            local client_id = player:getClientChairId()
            if client_id ~= 0 then
                self.playerOrder[index] = client_id
                index = index + 1
                --print("1发牌序号：",index,"--------玩家client_id：",client_id," idx: ",idx," begin_chair: ",begin_chair," 底注：",self.MinJetton)

                -- 刷新底注
				dump(self.MinJetton, "self.MinJetton")
                self:UpdatePlayerMoney(idx, self.MinJetton)
            end
        end
    end
    -- -- 发牌前 更新所有玩家状态为 等待操作
    for k, client_id in pairs(self.playerOrder) do
        local tPlayer = self:getGFPlayerByClientId(client_id)
        if tPlayer ~= nil then
            tPlayer:setGameState(GFlowerConfig.PLAYER_STATUS.CONTROL)
        end
    end
end

-----------------------------游戏操作--------------------------------
-- 发牌
function GFlowerGameDataManager:S2C_ZhaJinHuaStart(msgTab)
    local banker_chair_id = msgTab.banker_chair_id
    local begin_chair = self:getLocalChairId(banker_chair_id)

	if self.isPrivateRoom == false then
		--  记录本局有效玩家
		for k , server_id in pairs(msgTab.chair_id) do
			local client_id = self:getLocalChairId(server_id)
			self.validPlayerTag[client_id] = 1
		end
    
		--  清除无效玩家数据
		for idx = 1,  GFlowerConfig.CHAIR_COUNT do
			if self.validPlayerTag[idx] == 0 then
				self:clearGFPlayerByClientId(idx)
			end
		end
	else
		self.isInPRReady = false
	end

    -- 记录当前操作玩家
    self.doing_id = begin_chair

    -- 发牌之前计算发牌顺序
    self:setPlayerOrder(banker_chair_id)

    -- 设置游戏状态 为 进行状态
    self.room_state = GFlowerConfig.ROOM_STATE.PLAY
    self.roundNum = 1

    self:resetGFPlayerInfo()
end

function GFlowerGameDataManager:clearPlayerDownMoney()
    -- 重置玩家的数据
    for k, gfplayer in pairs(self.gfPlayers) do
        gfplayer:setDownMoney(0)
    end
end

-- 计算 当前跟注筹码编号  和 当前跟注金币数
function GFlowerGameDataManager:setFollowType(score)
	for type1, num in pairs(GFlowerConfig.ADD_BTN_TIMES) do

		if num * self.MinJetton   ==  score then
			-- 筹码下标
			self.follow_num = type1
			-- 剩以底注
			self.follow_money = GFlowerConfig.ADD_BTN_TIMES[self.follow_num] * self.MinJetton
			break
		end
	end
end

function GFlowerGameDataManager:resetValidPlayerTag()
    for idx = 1, GFlowerConfig.CHAIR_COUNT do
        self.validPlayerTag[idx]  =  0
    end
end

-- 判断是否加注
function GFlowerGameDataManager:isAddScore(score)
    self.is_add = false
    if GFlowerConfig.ADD_BTN_TIMES[self.follow_num] * self.MinJetton < score then
        self.is_add = true
    end
end

-- 全压时筹码飞出 列表制作
function GFlowerGameDataManager:AllCoinList(score)
    self.AllInNum = 1
    self.AllInList = {}

    local allnum = (score / CustomHelper.goldToMoneyRate() )
    while( allnum > 0 ) do
        if allnum >= self.MinJetton * GFlowerConfig.ADD_BTN_TIMES[5] then
            self.AllInList[self.AllInNum] = 5
            allnum = allnum - self.MinJetton * GFlowerConfig.ADD_BTN_TIMES[5]
        elseif allnum >= self.MinJetton * GFlowerConfig.ADD_BTN_TIMES[4] then
            self.AllInList[self.AllInNum] = 4
            allnum = allnum - self.MinJetton * GFlowerConfig.ADD_BTN_TIMES[4]
        elseif allnum >= self.MinJetton * GFlowerConfig.ADD_BTN_TIMES[3] then
            self.AllInList[self.AllInNum] = 3
            allnum = allnum - self.MinJetton * GFlowerConfig.ADD_BTN_TIMES[3]
        elseif allnum >= self.MinJetton * GFlowerConfig.ADD_BTN_TIMES[2] then
            self.AllInList[self.AllInNum] = 2
            allnum = allnum - self.MinJetton * GFlowerConfig.ADD_BTN_TIMES[2]
        elseif allnum >= self.MinJetton * GFlowerConfig.ADD_BTN_TIMES[1] then
            self.AllInList[self.AllInNum] = 1
            allnum = allnum - self.MinJetton * GFlowerConfig.ADD_BTN_TIMES[1]
        else
            self.AllInList[self.AllInNum] = 1
            break
        end
        self.AllInNum = self.AllInNum + 1
    end
end


--sx 加注 跟注 返回
function GFlowerGameDataManager:S2C_ZhaJinHuaAddScore( msgTab )
    local add_score_id = msgTab.add_score_chair_id
    local cur_id = msgTab.cur_chair_id
    local score = msgTab.score
    local money = msgTab.money
    
    if msgTab.money == nil then
        money = 0
        score = 0
    end

    if msgTab.money ~= nil then
        if msgTab.is_all == 2 then
            self.is_AllIn = true
        end
    end

    -- 跟到20轮的时候 这 add_score_id 鸡巴为空
    if add_score_id == nil then
        add_score_id = cur_id
    end

    local add_chair = self:getLocalChairId(add_score_id)
    local next_chair = self:getLocalChairId(cur_id)

    -- 或者等于玩家当前的所有持有金币 视为全下
    if self.is_AllIn then
        self:AllCoinList(score)
    end

    -- 判断是否加注
    self:isAddScore(score)

    -- 记录当前玩家
    self.doing_id = next_chair

    -- 当前跟注大小，下一个跟注默认为这个值
    self:setFollowType(score)

    -- 更新玩家金币 和 跟注累计值
    self:UpdatePlayerMoney(add_score_id, money)

    -- 更新轮数文本
    self:updatePlayerRoundNum(add_chair)

    -- 已经看过牌 就不更新为跟注状态了
    local player = self:getGFPlayerByClientId(add_chair)
    if player ~= nil then
        if player:getGameState() ~= GFlowerConfig.PLAYER_STATUS.LOOK  and self.room_state == GFlowerConfig.ROOM_STATE.PLAY then
            player:setGameState(GFlowerConfig.PLAYER_STATUS.CONTROL)
        end
    end
end

-- 弃牌 返回
function GFlowerGameDataManager:S2C_ZhaJinHuaGiveUp( msgTab )

    local giveup_id = msgTab.giveup_chair_id
    local cur_id = msgTab.cur_chair_id

    local giveup_chair = self:getLocalChairId(giveup_id)
    local next_chair = self:getLocalChairId(cur_id)

    -- 记录当前玩家
    self.doing_id = next_chair

    -- 更新轮数文本
    self:updatePlayerRoundNum(giveup_chair) 

    -- 更新玩家状态
    local player = self:getGfPlayers()[giveup_id]
    if player ~= nil then
        player:setGameState(GFlowerConfig.PLAYER_STATUS.DROP)
    end
end

function GFlowerGameDataManager:S2C_ZhaJinHuaPrivateCFG(msgTab)
	if self.isPrivateRoom == true then
		if msgTab.first_see == 1 then
			self.isFirstLookCard = true
		else
			self.isFirstLookCard = false
		end
		
		if msgTab.first_compare == 1 then
			self.isFirstCompare = true
		else
			self.isFirstCompare = false
		end
		
		if msgTab.no_money_compare == 1 then
			self.isNoMoneyCompare = true
		else
			self.isNoMoneyCompare = false
		end
		
		if msgTab.more_round == 1 then
		    self.isMoreRound = true
		else
			self.isMoreRound = false
		end
		
	end
end


-- 自己看牌
function GFlowerGameDataManager:S2C_ZhaJinHuaLookCard( msgTab )

    --dump(msgTab, "---------------------------------------------自己看牌")
    local chair_id = msgTab.lookcard_chair_id
    local client_chair_id = self:getLocalChairId(chair_id)

    -- 设置是否看牌标志
    self.isSelfLookCard = true

    -- 更新玩家状态
    local player = self:getGFPlayerByClientId(client_chair_id)
    if player ~= nil then
        player:setGameState(GFlowerConfig.PLAYER_STATUS.LOOK)
    end
end

-- 别人看牌
function GFlowerGameDataManager:S2C_ZhaJinHuaNotifyLookCard( msgTab )
    --dump(msgTab, "别家看牌")
    local chair_id = msgTab.lookcard_chair_id
    local client_chair_id = self:getLocalChairId(chair_id)

    -- 更新玩家状态
    local player = self:getGFPlayerByClientId(client_chair_id)
    if player ~= nil then
        player:setGameState(GFlowerConfig.PLAYER_STATUS.LOOK)
    end
end

-- 比牌前返回给输家两家的牌
function GFlowerGameDataManager:S2C_ZhaJinHuaLostCards( msgTab )
    self.lost_cards = msgTab.loster_cards
    self.win_cards = msgTab.win_cards

    dump(self.win_cards, "赢家牌")
    dump(self.lost_cards, "输家牌")
end

-- 比牌
function GFlowerGameDataManager:S2C_ZhaJinHuaCompareCard( msgTab )

    --dump(msgTab, "比牌返回")
    local cur_player = msgTab.cur_chair_id      --当前玩家
    local win_player = msgTab.win_chair_id      --赢牌用户
    local lost_player = msgTab.lost_chair_id    --输牌用户
    local isAll = msgTab.is_all    --是否是全场比牌

    -- 如果是全场比牌
    if isAll ~= nil then
        if isAll == 4  then
            if self.all_Compare == false then
                self.all_Compare = false
            end
        else
            self.all_Compare = true
        end
    else
        self.all_Compare = false
    end

    --print("比牌返回--------------------"..isAll)
    if self.all_Compare == false then
        local cur_id = self:getLocalChairId(cur_player)
        local win_id = self:getLocalChairId(win_player)
        local lost_id = self:getLocalChairId(lost_player)

        -- 当前玩家计数加1， 更新轮数
        self:updatePlayerRoundNum(self.doing_id)

        -- 更新总注 和 玩家金币
        local client_Cid = win_id
        local CompareId = win_player
        if self.doing_id == lost_id then
            CompareId = lost_player
            client_Cid = lost_id
        end

        -- 如果不是全压 来的比牌消息才加比牌需要的钱（太鸡巴烦了 非要喊客户端去算金额）
        if self.is_AllIn == false then
            -- 如果是看牌玩家和别人比牌 需要2倍
            local player = self:getGFPlayerByClientId(client_Cid)
            if player:getGameState() == GFlowerConfig.PLAYER_STATUS.LOOK then
                self:UpdatePlayerMoney(CompareId, self.follow_money * 2)
            else 
                self:UpdatePlayerMoney(CompareId, self.follow_money * 1)
            end
        end

        -- 更新玩家状态 这个状态表示被比死了(淘汰)
        local lPlayer = self:getGFPlayerByClientId(lost_id)
        lPlayer:setGameState(GFlowerConfig.PLAYER_STATUS.LOSE)
    end
end

-- 通知客户端倒计时的消息
function GFlowerGameDataManager:S2C_ZhaJinHuaReadyTime(msgTab)
    self.countDown = msgTab.time
end

-- 通知客户端倒计时的消息
function GFlowerGameDataManager:S2C_ZhaJinHuaClientReadyTime(msgTab)
    self.countDown = msgTab.time
end

-- 私人房间T人消息
function GFlowerGameDataManager:S2C_ZhaJinHuaTabTiren(msgTab)
	local serverchairid  = msgTab.chair_id
	local clientchairid  = self:getLocalChairId(serverchairid)
	
	self:clearGFPlayerByClientId(clientchairid)
end

function GFlowerGameDataManager:S2C_ZhaJinHuaTabVote(msgTab)
	local clientchairid  = self:getLocalChairId(msgTab.chair_id)
	
end

function GFlowerGameDataManager:S2C_ZhaJinHuaStatistics(msgTab)
	self.isLastGame  = true
end

-- 游戏结束
function GFlowerGameDataManager:S2C_ZhaJinHuaEnd(msgTab)
    --print("S2C_ZhaJinHuaEnd  。。。。。。。。。。。。。。。。")
    --dump(msgTab, "游戏结束-------------------------------------------------")

    -- 保存数据 
    self.win_chair_id = msgTab.win_chair_id
    self.player_end_list = msgTab.pb_conclude
    self.tax = msgTab.tax
    if self.tax == nil then
        self.tax = 0
    end

    -- 设置房间状态为空闲
    self.room_state = GFlowerConfig.ROOM_STATE.FREE

    -- 重设无效玩家标志
    self:resetValidPlayerTag()
end

-- 重置玩家数据
function GFlowerGameDataManager:resetGFPlayerInfo()
    for idx, player in pairs(self.gfPlayers) do
        player:setRoundNum(1)
    end
end

-- 更新玩家轮数
function GFlowerGameDataManager:updatePlayerRoundNum(client_id)
    local player    = self:getGFPlayerByClientId(client_id) 
    if player ~= nil then
        local curRound  = player:getRoundNum()
        local round     = curRound + 1
        player:setRoundNum(round)
    end
end

-- 获取准备玩家数量
function GFlowerGameDataManager:getReadyPlayerNum()
    local num = 0
    for k, player in pairs(self.gfPlayers) do
        if player:getGameState() == GFlowerConfig.PLAYER_STATUS.READY then
            num = num + 1
        end
    end

    return num
end

-- 计算剩下的生存玩家数量（没弃牌和没被淘汰的玩家数量）
function GFlowerGameDataManager:getPlayingNum()

    local playingNum = 0
    for k, player in pairs(self.gfPlayers) do
        if player:getGameState() == GFlowerConfig.PLAYER_STATUS.CONTROL
        or player:getGameState() == GFlowerConfig.PLAYER_STATUS.LOOK then
            playingNum = playingNum + 1
            --print("11111111+++++++++++++++++++++++++"..client_id.."++"..player_state)
        end
    end
    return playingNum
end

-- 剩下自己和另一个玩家时 找出另一个玩家的id比牌
function GFlowerGameDataManager:getCompareNum()
    
    for k, player in pairs(self.gfPlayers) do
        local state  = player:getGameState()
        local client_id = player:getClientChairId()
        if state == GFlowerConfig.PLAYER_STATUS.CONTROL
        or state == GFlowerConfig.PLAYER_STATUS.LOOK then
            if client_id ~= GFlowerConfig.CHAIR_SELF then
                --print("剩下自己和另一个玩家时，另一个玩家的id："..client_id)
                return client_id
            end
        end
    end
end


-- 把服务器椅子号 转化为本地椅子号
function GFlowerGameDataManager:getLocalChairId(chair)
    if self.myServerChairId == 0 or self.myServerChairId == nil  then
        return
    end

    local num = self.myServerChairId - chair
    --print("把服务器椅子号 转化为本地椅子号+++++++++++++++++++++++++ "..self.s_chair.." ++++ "..chair)

    if num == 0 then
        return 1
    ------------------------------
    elseif num == 1 then
        return 5
    elseif num == 2 then
        return 4
    elseif num == 3 then
        return 3
    elseif num == 4 then
        return 2
    ------------------------------
    elseif num == -1 then
        return 2
    elseif num == -2 then
        return 3
    elseif num == -3 then
        return 4
    elseif num == -4 then
        return 5
    end
end

-----------------------------------------------------字符串截取功能-----------------------------------------------------------------
--截取中英混合的UTF8字符串，endIndex可缺省
function SubStringUTF8(str, startIndex, endIndex)
    if startIndex < 0 then
        startIndex = SubStringGetTotalIndex(str) + startIndex + 1;
    end

    if endIndex ~= nil and endIndex < 0 then
        endIndex = SubStringGetTotalIndex(str) + endIndex + 1;
    end

    if endIndex == nil then 
        return string.sub(str, SubStringGetTrueIndex(str, startIndex));
    else
        return string.sub(str, SubStringGetTrueIndex(str, startIndex), SubStringGetTrueIndex(str, endIndex + 1) - 1);
    end
end

--获取中英混合UTF8字符串的真实字符数量
function SubStringGetTotalIndex(str)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat 
        lastCount = SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(lastCount == 0);
    return curIndex - 1;
end

function SubStringGetTrueIndex(str, index)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat 
        lastCount = SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(curIndex >= index);
    return i - lastCount;
end

--返回当前字符实际占用的字符数
function SubStringGetByteCount(str, index)
    local curByte = string.byte(str, index)
    local byteCount = 1;
    if curByte == nil then
        byteCount = 0
    elseif curByte > 0 and curByte <= 127 then
        byteCount = 1
    elseif curByte>=192 and curByte<=223 then
        byteCount = 2
    elseif curByte>=224 and curByte<=239 then
        byteCount = 3
    elseif curByte>=240 and curByte<=247 then
        byteCount = 4
    end
    return byteCount;
end

--截取前 n个(12个)字符串  字母等算一个字节  汉子类算两个字节
function sx_SubStringUTF8(str, Index)
    if Index <= 1 or str == nil then
        return ""
    end

    return string.sub(str, 1, SubStringGetAllIndex(str, Index));
end

-- 计算字符串占用字节数
function SubStringGetAllIndex(str, Index)
    local i = 1;
    local lastCount = 0;
    -- 字符宽度累积
    local w = 0
    repeat
        lastCount = SubStringGetByteCount(str, i)
        i = i + lastCount;
        -- 如果是汉子宽度 加2  其他字符串和大写字母宽度为 加1
        if lastCount >= 3 then
            w = w + 2
        else
            w = w +1
        end
        --print("字符宽度："..lastCount)
    until(w > Index);
    return i - 1 - lastCount;
end
