--
-- Author: yangfan
-- Date: 2017-3-28 
-- 游戏对象管理器
--

local FishGameObjectManager = class("FishGameObjectManager")

--  单件模式
FishGameObjectManager.instance = nil
function FishGameObjectManager:getInstance()
    if FishGameObjectManager.instance == nil then
        FishGameObjectManager.instance = FishGameObjectManager:create()
    end
    return FishGameObjectManager.instance
end

-- 初始化局部变量
function  FishGameObjectManager:ctor()
    self._fishes    = {}
    self._bullets   = {}
end

-- 添加鱼 
function  FishGameObjectManager:addFish(idx, fish)

end

-- 添加子弹
function  FishGameObjectManager:addBullet(idx, bullet)

end

-- 删除鱼
function FishGameObjectManager:delFish(idx)

end

-- 删除子弹
function FishGameObjectManager:delBullet(idx)

end

return  FishGameObjectManager

