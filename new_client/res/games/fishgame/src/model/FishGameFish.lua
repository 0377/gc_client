--
-- Author: yangfan
-- Date: 2017-3-28 
-- 捕鱼游戏 鱼
--

local FishGameFish = class("FishGameFish")

function FishGameFish:ctor()
    self._x         = 0;
    self._y         = 0;
    self._lastX     = 0;
    self._lastY     = 0;
    self._tmpIdx    = 0;
    self._idx       = 0;

end

return FishGameFish

