--
-- Author: Your Name
-- Date: 2016-12-29 15:07:41
-- 数据管理器
--

FishGameDataManager = class("FishGameDataManager")
local FishGameScene = import("..views.FishGameScene")

--
-- start 引入数据对象  
--

-- end

local schedule  = cc.Director:getInstance():getScheduler()

-- 类的初始化方法，自动调用
function FishGameDataManager:ctor()
	-- body



end

return FishGameDataManager