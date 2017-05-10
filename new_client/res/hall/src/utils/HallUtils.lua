HallUtils = class("HallUtils");
--
local targetPlatform = cc.Application:getInstance():getTargetPlatform()
function HallUtils:getDescWithMsgNameAndRetNum(msgName,result)
	return HallUtils:getDescriptionWithKey(msgName.."_"..result)
end
--得到描述key
function HallUtils:getDescriptionWithKey(key)
    local HallClientDesc = requireForGameLuaFile("HallTipsDesc");
    local desc = HallClientDesc[key];
    if desc == nil then
      --todo
      local subGameManager = GameManager:getInstance():getHallManager():getSubGameManager();
      if subGameManager then
        --todo
        desc = subGameManager:getDescriptionWithKey(key)
      end
    end
    if desc == nil then
      --todo
      print(key,"is not find in HallTipsDesc.lua or subGameManager tips.lua");
      desc = key;
    end
    return desc;
end
--获取第三方应用回调app url
function HallUtils:getThreedAppUrl()
   local targetPlatform = cc.Application:getInstance():getTargetPlatform()

	if targetPlatform == cc.PLATFORM_OS_IPHONE or targetPlatform == cc.PLATFORM_OS_IPAD then
		local appargs = {}
        luaoc.callStaticMethod("PlatBridge", "getThreedAppUrl", appargs);
	end
end
---判断是否在游戏中
function HallUtils:checkIsInGaming()
	self.myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo()
    local gamingInfoTab = self.myPlayerInfo:getGamingInfoTab()
    if gamingInfoTab ~= nil then
        --todo
       return true
   else
   	   return false
   end
end
return HallUtils;