--
-- Author: yangfan
-- Date: 2017-3-28 
-- 游戏对象管理器
--

FishGameXMLConfigManager = class("FishGameXMLConfigManager")

--获取xml数据表
local function GetXmlTable(path,key)
    if not key then
        key = "";
    end
    local parser = myLua.XMLParser:create();
    local ta = parser:parseXML(path,key);
    return ta;
end


--  单件模式
FishGameXMLConfigManager.instance = nil
function FishGameXMLConfigManager:getInstance()
    if FishGameXMLConfigManager.instance == nil then
        FishGameXMLConfigManager.instance = FishGameXMLConfigManager:create()
    end
    return FishGameXMLConfigManager.instance
end

-- 初始化配置变量
function  FishGameXMLConfigManager:ctor()
    print("FishGameXMLConfigManager:ctor")
    self:init()
end

-- 初始化函数
function FishGameXMLConfigManager:init()

    self._bulletVector      = {}  -- vector
    self._fishMap           = {}  -- map
    self._boundBoxMap       = {}  -- map
    self._cannonPosVector   = {}  -- vector
    self._cannonSetVector   = {}  -- vector

   self._lockInfo           = {}

   self._mirror             = false
     
    self:loadSystemConfig(FishGameConfig.XML_CONFIG.SYSTEM)
    self:loadFishConfig(FishGameConfig.XML_CONFIG.FISH)
    self:loadBulletConfig(FishGameConfig.XML_CONFIG.BULLET_SET)
    self:loadCannonConfig(FishGameConfig.XML_CONFIG.CANNON_SET)
    self:loadBoundBoxConfig(FishGameConfig.XML_CONFIG.BOUNDING_BOX)
end

-- 加载系统配置
function  FishGameXMLConfigManager:loadSystemConfig(file)
    local xmlData = GetXmlTable(file)
    local SystemSet = xmlData.SystemSet

    self._showDebugInfo = SystemSet.ShowDebugInfo

    local sets = SystemSet.DefaultScreenSet
    local exchange  = SystemSet.ExchangeScore
    local fire      = SystemSet.Fire
    local ionSet    = SystemSet.IonSet
    local cannonSet = SystemSet.CannonSet
    local firstFire = SystemSet.FirstFire

    self._screenWidth       = sets.width
    self._screenHeight      = sets.height
    self._exchangeRatio     = exchange.Ratio
    self._exchangeOnce      = exchange.Once
    self._fireMinInterval   = fire.Interval
    self._fireMaxInterval   = fire.MaxInterval
    self._fireMaxBullet     = fire.MaxBullet
    self._ionMultiple       = ionSet.Multiple
    self._ionProbability    = ionSet.Probability
    self._ionTime           = ionSet.time
    self._cannonNormal      = cannonSet.Normal
    self._cannonIon         = cannonSet.Ion
    self._cannonDouble      = cannonSet.Double
end

-- 加载鱼配置
function FishGameXMLConfigManager:loadFishConfig(file)
    local xmlData = GetXmlTable(file);
    local FishSet = xmlData.FishSet
    local fish = FishSet.Fish

    self._fishMap = {}

    for _, v in ipairs(fish) do
        local ff = {}

        ff.nTypeID = tonumber(v.TypeID)
        ff.szName = v.Name

        ff.bBroadCast = v.BroadCast == "true"
        ff.fProbability = tonumber(v.Probability)
        ff.nSpeed = tonumber(v.Speed)

        ff.nVisualID = tonumber(v.VisualID)
        ff.nBoundBox = tonumber(v.BoundingBox)

        ff.bShowBingo = v.ShowBingo == "true"
        ff.szParticle = v.Particle
        ff.bShakeScree = v.ShowBingo == "true"
        ff.nLockLevel = tonumber(v.LockLevel)

        ff.EffectSet = {}

        local effct = v.Effect or {}
        if #effct == 0 and table.nums(effct) > 0 then
            local ecf = {}
            ecf.nTypeID = tonumber(effct.TypeID)
            ecf.nParam = {}

            for i = 1, 10 do
                local par = effct["Param" .. i]

                if not par then break end

                table.insert(ecf.nParam, tonumber(par))
            end

            table.insert(ff.EffectSet, ecf)
        else
            for __, vv in ipairs(effct) do
                local ecf = {}
                ecf.nTypeID = tonumber(vv.TypeID)
                ecf.nParam = {}

                for i = 1, 10 do
                    local par = vv["Param" .. i]

                    if not par then break end

                    table.insert(ecf.nParam, tonumber(par))
                end

                table.insert(ff.EffectSet, ecf)
            end
        end

        ff.BufferSet = {}

        local buf = v.Buffer or {}
        if #buf == 0 and table.nums(buf) > 0 then
            local but = {}
            but.nTypeID = tonumber(buf.TypeID)
            but.fParam = tonumber(buf.Param)
            but.fLife = tonumber(buf.Life)

            table.insert(ff.BufferSet, but)
        else
            for __, vv in ipairs(buf) do
                local but = {}
                but.nTypeID = tonumber(vv.TypeID)
                but.fParam = tonumber(vv.Param)
                but.fLife = tonumber(vv.Life)

                table.insert(ff.BufferSet, but)
            end
        end

        self._fishMap[ff.nTypeID] = ff;
    end
end

-- 加载子弹配置
function FishGameXMLConfigManager:loadBulletConfig(file)
    local xmlData = GetXmlTable(file)
    local BulletSet = xmlData.BulletSet

    for _, v in ipairs(BulletSet) do
        local bt = {}
        bt.nMulriple    = tonumber(v.Mulriple)
        bt.nSpeed       = tonumber(v.Speed)
        bt.nMaxCatch    = tonumber(v.MaxCatch)
        bt.nCatchRadio  = tonumber(v.CatchRadio)
        bt.nCannonType  = tonumber(v.CannonType)
        --[[bt.nBulletSize  = tonumber(v.BRidio)

        if self.m_MaxCannon < bt.nMulriple then
            self.m_MaxCannon = bt.nMulriple
        end
            
        --bt.ProbabilitySet = {}

        local cat = v.Catch or {}
        for __, vv in ipairs(cat) do
            bt.ProbabilitySettonumber[vv.FishID] = tonumber(vv.Probability)
        end]]--

        table.insert(self._bulletVector, bt)
    end
end

-- 加载炮配置
function FishGameXMLConfigManager:loadCannonConfig(file)
    local xmlData = GetXmlTable(file)
    local CCPOS = xmlData.CannonPos

    local Cannon = CCPOS.Cannon

    self._cannonPosVector = {}

    for _, v in ipairs(Cannon) do
        local id = tonumber(v.id)

        local cannonPos = {}

        cannonPos.x     = tonumber(v.PosX)
        cannonPos.y     = tonumber(v.PosY)
        cannonPos.dir   = tonumber(v.Direction)

        self._cannonPosVector[id] = cannonPos
    end

    local cef = CCPOS.CannonEffect
    self._cannonEffectPos       = {}
    self._cannonEffect          = cef.name
    self._cannonEffectPos.x     = tonumber(cef.PosX)
    self._cannonEffectPos.y     = tonumber(cef.PosY)

    local tnode = CCPOS.LOCK

   
    self._lockInfo.szLockIcon = tnode.name
    self._lockInfo.szLockLine = tnode.line
    self._lockInfo.szLockFlag = tnode.flag

    self._lockInfo.Pos = {}
    self._lockInfo.Pos.x = tnode.PosX
    self._lockInfo.Pos.y = tnode.PosY


    local jetton = CCPOS.Jetton
    self._jettonCount    = tonumber(jetton.Max)
    self._jettonPos      = {}
    self._jettonPos.x    = tonumber(tnode.PosX)
    self._jettonPos.y    = tonumber(tnode.PosY)

    self._cannonSetVector = {}
    local CannonSet = xmlData.CannonSet
    for _, v in ipairs(CannonSet) do
        local canset = {}

        canset.bRebound = v.Rebound == "true"
        canset.nID          = tonumber(v.id)
        canset.nNormalID    = tonumber(v.normal)
        canset.nIonID       = tonumber(v.ion)
        canset.nDoubleID    = tonumber(v.double)

        canset.Sets = {}

        local CannonType = v.CannonType or {}

        for __, vv in ipairs(CannonType) do
            local ccs = {}
            ccs.nTypeID = tonumber(vv.type)

            local Part = vv.Cannon or {}
            local cpt = {}
            cpt.szResourceName = Part.ResName
            cpt.Name        = Part.Name
            cpt.Move        = Part.Move or "move"
            cpt.nResType    = tonumber(Part.ResType)
            cpt.PosX        = tonumber(Part.PosX)
            cpt.PosY        = tonumber(Part.PosY)

            cpt.FireOfffest = tonumber(Part.FireOffest)
            cpt.nType       = tonumber(Part.type)
            cpt.RoateSpeed  = tonumber(Part.RoateSpeed)
            ccs.Cannon      = cpt

            local CannonEffect = vv.CannonEffect
            if CannonEffect then
                local cpte = {}
                cpte.szResourceName = CannonEffect.ResName
                cpte.Name           = CannonEffect.Name
                cpte.nResType       = tonumber(CannonEffect.ResType)
                cpte.PosX           = tonumber(CannonEffect.PosX)
                cpte.PosY           = tonumber(CannonEffect.PosY)

                cpte.FireOfffest    = tonumber(CannonEffect.FireOffest)
                cpte.nType          = tonumber(CannonEffect.type)
                cpte.RoateSpeed     = tonumber(CannonEffect.RoateSpeed)
                ccs.CannonEffect    = cpte
            end

            ccs.BulletSet = {}
            local Bullet = vv.Bullet or {}
            local cb = {}
            cb.szResourceName = Bullet.ResName
            cb.Name = Bullet.Name
            cb.nResType = tonumber(Bullet.ResType)
            cb.fScale = tonumber(Bullet.Scale)
            ccs.BulletSet = cb

            local Net = vv.Net
            local ns = {}
            ns.szResourceName = Net.ResName
            ns.Name = Net.Name
            ns.nResType = tonumber(Net.ResType)
            ns.fScale = tonumber(Net.Scale)
            ns.PosX = tonumber(Net.PosX)
            ns.PosY = tonumber(Net.PosY)
            ccs.NetSet = ns

            canset.Sets[ccs.nTypeID] = ccs
        end

        self._cannonSetVector[canset.nID] = canset
    end
end

-- 加载碰撞盒
function FishGameXMLConfigManager:loadBoundBoxConfig(file)
    local xmlData = GetXmlTable(file)
    local nbbx = xmlData.BoundingBox

    for _, v in ipairs(nbbx) do
        local boubx = {}
        boubx.nID = tonumber(v.id)
        boubx.BBList = {}

        local nbb = v.BB or {}

        if #nbb == 0 and table.nums(nbb) > 0 then
            local b = {}
            b.fRadio = tonumber(nbb.Radio)
            b.nOffestX = tonumber(nbb.OffestX)
            b.nOffestY = tonumber(nbb.OffestY)

            table.insert(boubx.BBList, b)
        else
            for __, vv in ipairs(nbb) do
                local b = {}
                b.fRadio = tonumber(vv.Radio)
                b.nOffestX = tonumber(vv.OffestX)
                b.nOffestY = tonumber(vv.OffestY)

                table.insert(boubx.BBList, b)
            end
        end

        self._boundBoxMap[boubx.nID] = boubx
    end
end

function FishGameXMLConfigManager:getCannonPosition(chairID)
    print("FishGameXMLConfigManager:getCannonPosition : ChairID: "..chairID)
    local v = self._cannonPosVector[chairID]
    return v.x * self._screenWidth, self._screenHeight * v.y
end

function FishGameXMLConfigManager:convertCoord(x, y)
    if self:mirrorShow() then
        x, y = self._screenWidth - x, self._screenHeight - y
    end

    return x, y
end

function FishGameXMLConfigManager:mirrorShow() 
    return self._mirror 
end

function FishGameXMLConfigManager:setMirrorShow(setv )
    self._mirror =setv
    --fishgame.FishObjectManager:GetInstance():SetMirrowShow(setv)
end

return  FishGameXMLConfigManager
