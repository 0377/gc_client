--[[
	子游戏Mananger父类
]]
local SubGameBaseManager = class("SubGameBaseManager");
GameMaintainStatus = {
	On = 1,--游戏维护状态
	Off = 2 -- 游戏维护关闭状态
}
function SubGameBaseManager:ctor()
	self._gameMaintainStatus = GameMaintainStatus.Off;--游戏总开关
end
function SubGameBaseManager:onEnter()

end
function SubGameBaseManager:onExit()
	--清除
	GameManager:getInstance():getHallManager():setSubGameManager(nil)
end
--注册协议到协议解析中
function SubGameBaseManager:registerPBProtocolToHallMsgManager()

end
function SubGameBaseManager:initGameSearchPath(packageRootPath)

end

function SubGameBaseManager:sendMessage(...)
	GameManager:getInstance():getHallManager():getHallMsgManager():sendMsg(...);
end

---站起并离开房间
function SubGameBaseManager:sendStandUpAndExitRoomMsg()
	GameManager:getInstance():getHallManager():getHallMsgManager():sendStandUpAndExitRoom()
end
---准备
function SubGameBaseManager:sendGameReady()
	-- body
	GameManager:getInstance():getHallManager():getHallMsgManager():sendGameReady();
end

---发送进入房间并坐下
function SubGameBaseManager:sendEnterRoomAndSitDownMsg( )
	-- body
	GameManager:getInstance():getHallManager():getHallMsgManager():sendEnterRoomAndSitDown();
end
function SubGameBaseManager:getGameSwitchStatus()
	return self._gameMaintainStatus;
end
function SubGameBaseManager:on_SC_GameMaintain(msgTab)
	self._gameMaintainStatus = GameMaintainStatus.On;
end
function SubGameBaseManager:getDescriptionWithKey(key)
	if self.subGameTipsConfig then
		--todo
		return self.subGameTipsConfig[key]
	end
	return nil
end
return SubGameBaseManager