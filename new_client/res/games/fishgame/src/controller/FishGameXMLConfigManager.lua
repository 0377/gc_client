--
-- Author: yangfan
-- Date: 2017-3-28 
-- 游戏对象管理器
--

NPT_LINE = 0
NPT_BEZIER = 1
NPT_CIRCLE = 2

PMT_LINE = 0
PMT_BEZIER = 1
PMT_CIRCLE= 2
PMT_STAY = 3

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
--    self:loadBoundBoxConfig(FishGameConfig.XML_CONFIG.BOUNDING_BOX)
--    self:loadTroop(FishGameConfig.XML_CONFIG.TROOP_SET)
--    self:loadPath(FishGameConfig.XML_CONFIG.PATH)
--    self:loadFish(FishGameConfig.XML_CONFIG.FISH)
--    self:loadFishVisual(FishGameConfig.XML_CONFIG.VISUAL)
end

function FishGameXMLConfigManager:loadFishVisual(file)
    local xmlData = GetXmlTable(file)
    local FishPath = xmlData.VisualSet

    local visulaData = {}
    for _,v in ipairs(FishPath.Visual) do
        local data = {
            id = tonumber(v.Id),
            typeId = tonumber(v.TypeID),
            zorder = tonumber(v.ZOrder),
            live = {},
            die = {},
        }

        if #v.Live ~= 0 then
            for __,vv in ipairs(v.Live) do
                table.insert(data.live,{
                    image = vv.Image,
                    name = vv.Name,
                    aniType = tonumber(vv.AniType),
                    scale = tonumber(vv.Scale),
                    offset = {tonumber(vv.OffestX),tonumber(vv.OffestY)},
                    direction = tonumber(vv.Direction),
                    hideShadow = (vv.HideShadow == "true"),
                })
            end
        else
            table.insert(data.live,{
                image = v.Live.Image,
                name = v.Live.Name,
                aniType = tonumber(v.Live.AniType),
                scale = tonumber(v.Live.Scale),
                offset = {tonumber(v.Live.OffestX),tonumber(v.Live.OffestY)},
                direction = tonumber(v.Live.Direction),
                hideShadow = (v.Live.HideShadow == "true"),
            })
        end

        if #v.Die ~= 0 then
            for __,vv in ipairs(v.Die) do
                table.insert(data.die,{
                    image = vv.Image,
                    name = vv.Name,
                    aniType = tonumber(vv.AniType),
                    scale = tonumber(vv.Scale),
                    offset = {tonumber(vv.OffestX),tonumber(vv.OffestY)},
                    direction = tonumber(vv.Direction),
                    hideShadow = (vv.HideShadow == "true"),
                })
            end
        else
            table.insert(data.die,{
                image = v.Die.Image,
                name = v.Die.Name,
                aniType = tonumber(v.Die.AniType),
                scale = tonumber(v.Die.Scale),
                offset = {tonumber(v.Die.OffestX),tonumber(v.Live.OffestY)},
                direction = tonumber(v.Die.Direction),
                hideShadow = (v.Die.HideShadow == "true"),

            })
        end


        visulaData[data.id] = data
    end

    io.writefile("jaye_test.text", sz_T2S(visulaData), "w+")

end

function FishGameXMLConfigManager:loadFish(file)
    local xmlData = GetXmlTable(file)
    local FishPath = xmlData.FishSet

    local aaData = {}
    for _,v in ipairs(FishPath.Fish) do
        dump(v)
        local fish = {
            boundingBox = tonumber(v.BoundingBox),
            broadCast = tonumber(v.BroadCast),
            lockLvl = tonumber(v.LockLevel),
            name = v.Name,
            particle = v.Particle,
            probability = tonumber(v.Probability),
            shakeScreen = v.ShakeScreen == "true",
            showBingo = v.ShowBingo == "true",
            speed = tonumber(v.Speed),
            typeId = tonumber(v.TypeID),
            visualId = tonumber(v.VisualID),
            effect = {},
            buff = {},

        }
        -- effect
        if #v.Effect ~= 0 then
            for __,vv in ipairs(v.Effect) do
                local effect = {
                    typeId = tonumber(vv.TypeID),
                    data = {}
                }
                for i=1,10 do
                    if vv["Param" .. i] then
                        table.insert(effect.data,tonumber(vv["Param" .. i]))
                    end
                end
                table.insert(fish.effect,effect)
            end
        else
            local effect = {
                typeId = tonumber(v.Effect.TypeID),
                data = {}
            }
            for i=1,10 do
                if v.Effect["Param" .. i] then
                    table.insert(effect.data,tonumber(v.Effect["Param" .. i]))
                end
            end

            table.insert(fish.effect,effect)
        end

        -- buff
        if v.Buffer then
            if #v.Buffer ~= 0 then
                for __,vv in ipairs(v.Buffer) do
                    local effect = {
                        typeId = tonumber(vv.TypeID),
                        param = tonumber(vv.Param),
                        life = tonumber(vv.Life),
                    }
                    table.insert(fish.buff,effect)
                end
            else
                local effect = {
                    typeId = tonumber(v.Buffer.TypeID),
                    param = tonumber(v.Buffer.Param),
                    life = tonumber(v.Buffer.Life),
                }


                table.insert(fish.buff,effect)
            end
        end

        aaData[fish.typeId] = fish
    end

    io.writefile("jaye_test.text", sz_T2S(aaData), "w+")

end

    function sz_T2S(_t)
        local szRet = "{"
        function doT2S(_i, _v)
            if "number" == type(_i) then
                szRet = szRet .. "[" .. _i .. "] = "
    --            szRet = szRet .. "" .. _i .. " = "
                if "number" == type(_v) then
                    szRet = szRet .. _v .. ","
                elseif "string" == type(_v) then
                    szRet = szRet .. '"' .. _v .. '"' .. ","
                elseif "table" == type(_v) then
                    szRet = szRet .. sz_T2S(_v) .. ","
                elseif "boolean" == type(_v) then
                    szRet = szRet .. (_v and "true" or "false") .. ","
                else
                    szRet = szRet .. "nil,"
                end
            elseif "string" == type(_i) then
    --            szRet = szRet .. '["' .. _i .. '"] = '
                szRet = szRet .. '' .. _i .. ' = '
                if "number" == type(_v) then
                    szRet = szRet .. _v .. ","
                elseif "string" == type(_v) then
                    szRet = szRet .. '"' .. _v .. '"' .. ","
                elseif "table" == type(_v) then
                    szRet = szRet .. sz_T2S(_v) .. ","
                elseif "boolean" == type(_v) then
                    szRet = szRet .. (_v and "true" or "false") .. ","
                else
                    szRet = szRet .. "nil,"
                end
            end
        end
        table.foreach(_t, doT2S)
        szRet = szRet .. "}"
        return szRet
    end



function FishGameXMLConfigManager:loadTroop(file)
    local xmlData = GetXmlTable(file)
    local FishPath = xmlData.Path
--dump(FishPath)


    local config = {}

    for _,v in ipairs(FishPath) do
        local data = {
            id = tonumber(v.id),
            type = tonumber(v.Type),
            next = tonumber(v.Next),
            delay = tonumber(v.Delay),
            count = 4,
            position = {}
        }

        for __,vv in ipairs(v.Position) do
            local dd = {}
            dd[1] = tonumber(vv.x)
            dd[2] = tonumber(vv.y)

            table.insert(data.position,dd)
        end

        if data.type == NPT_LINE then
            data.count = 2
        elseif data.type == NPT_BEZIER then
            if data.position[4][1] == 0 and data.position[4][2] == 0 then
                data.count = 3
            end
        end

        config[data.id] = data

    end

    local pathMap = {}

    for k,v in pairs(config) do
        local next = k

        local hhh = {}
        repeat
            local data = config[next]

            local ttt ={
                type = data.type,
                count = data.count,
                delay = data.delay,
                position = data.position,

            }

            table.insert(hhh,ConvertPathPoint(ttt))

            next = data.next
        until next == 0

        pathMap[k] = createPathData(hhh)
    end


    io.writefile("jaye_test_1.text", sz_T2S(config), "w+")
    io.writefile("jaye_test.text", sz_T2S(pathMap), "w+")
end

function FishGameXMLConfigManager:loadPath(file)
    local xmlData = GetXmlTable(file)
    local FishPath = xmlData.FishPath

--    dump(FishPath)

    local config = {}

    for _,v in ipairs(FishPath.Path) do
        local data = {
            type = tonumber(v.Type),
            next = tonumber(v.Next),
            delay = tonumber(v.Delay),
            count = 4,
            position = {}
        }

        if data.type == NPT_LINE then
            data.count = 2
        elseif data.type == NPT_BEZIER then
            data.count = 3
        end


        for __,vv in ipairs(v.Position) do
            local dd = {}
            dd[1] = tonumber(vv.x)
            dd[2] = tonumber(vv.y)

            table.insert(data.position,dd)
        end

        table.insert(config,data)
    end

    local realData = {}
    local id = 0
    for _,v in ipairs(config) do
        for x=0,1 do
            for y=0,1 do
                for xy=0,1 do
                    for _not=0,1 do



--                        realData[id] = ConvertPathPoint(v,x == 1,y == 1,xy == 1,_not == 1)
                        realData[id] = createPathData({ConvertPathPoint(v,x == 1,y == 1,xy == 1,_not == 1)})
                        id = id + 1
                    end
                end
            end

        end
    end


    io.writefile("jaye_test.text", sz_T2S(realData), "w+")
end

function createPathData(path)
    local duration = 0
    local data = {
    }

    for _,v in ipairs(path) do
        if v.type == PMT_LINE
            or v.type == PMT_BEZIER
            or v.type == PMT_STAY
        then
            for _,vv in ipairs(v.position) do
                vv[1] = math.round(vv[1] * display.width)
                vv[2] = math.round(vv[2] * display.height)
            end
        else
            for k,vv in ipairs(v.position) do
                if k == 1 then
                    vv[1] = math.round(vv[1] * display.width)
                    vv[2] = math.round(vv[2] * display.height)
                end
            end
        end

    end

    for _,v in ipairs(path) do
        if v.type == NPT_LINE then
            local distance = game.fishgame2d.MathAide:CalcDistance(v.position[1][1],v.position[1][2],v.position[2][1],v.position[2][2])
            distance = math.round(distance)
            local ele = {
                type = PMT_LINE,
                position = v.position,
                count = v.count,
                duration = distance,
                start_time = duration,
                end_time = 0,
            }
            duration = duration + distance
            ele.end_time = duration

            table.insert(data,ele)

            if v.delay > 0 then
                local tempDir = game.fishgame2d.MathAide:CalcAngle(v.position[1][1],v.position[1][2],v.position[2][1],v.position[2][2]);
                tempDir = tempDir + math.pi / 2;

                local ele = {
                    type = PMT_STAY,
                    position = {{v.position[2][1],v.position[2][2]},{0,0},{0,0},{0,0}},
                    count = 1,
                    direction = tempDir,
                    duration = v.delay,
                    start_time = duration,
                    end_time = 0,
                }
                duration = duration + v.delay
                ele.end_time = duration

                table.insert(data,ele)
            end

        elseif v.type == NPT_BEZIER then
            local ele = {
                type = PMT_BEZIER,
                position = v.position,
                count = v.count,
                duration = 2000,
                start_time = duration,
                end_time = 0,
            }
            duration = duration + 2000
            ele.end_time = duration

            table.insert(data,ele)

            if v.delay > 0 then
                local tempDir = game.fishgame2d.MathAide:CalcAngle(v.xPos[0], v.yPos[0], v.xPos[1], v.yPos[1]);
                tempDir = tempDir + math.pi  / 2;

                local ele = {
                    type = PMT_STAY,
                    position = {{v.position[2][1],v.position[2][2]},{0,0},{0,0},{0,0}},
                    count = 1,
                    direction = tempDir,
                    duration = v.delay,
                    start_time = duration,
                    end_time = 0,
                }
                duration = duration + v.delay
                ele.end_time = duration

                table.insert(data,ele)
            end
        elseif v.type == NPT_CIRCLE then
            local nCount = v.position[2][1] * math.abs(v.position[3][2]);
            nCount = math.round(nCount)

            local ele = {
                type = PMT_CIRCLE,
                position = v.position,
                count = v.count,
                duration = nCount,
                start_time = duration,
                end_time = 0,
            }
            duration = duration + nCount
            ele.end_time = duration

            table.insert(data,ele)

            if v.delay > 0 then
                local tempDir = game.fishgame2d.MathAide:CalcAngle(v.xPos[0], v.yPos[0], v.xPos[1], v.yPos[1]);
                tempDir = tempDir + math.pi  / 2;

                local ele = {
                    type = PMT_STAY,
                    position = {{v.position[2][1],v.position[2][2]},{0,0},{0,0},{0,0}},
                    count = 1,
                    direction = tempDir,
                    duration = v.delay,
                    start_time = duration,
                    end_time = 0,
                }
                duration = duration + v.delay
                ele.end_time = duration

                table.insert(data,ele)
            end
        end
    end

    return {
        duration = duration,
        data = data,
    }
end

function ConvertPathPoint(data,xMirror,yMirror,xyMirror,Not)
    local v = clone(data)



    if xMirror then
        if v.type == NPT_CIRCLE then
            v.position[1][1] = 1.0 - v.position[1][1]
            v.position[3][1] = math.pi - v.position[3][1];
            v.position[3][2] = -v.position[3][2];
        else
            for i=1, v.count do
                v.position[i][1] = 1.0 - v.position[i][1]
            end
        end
    end

    if yMirror then
        if v.type == NPT_CIRCLE then
            v.position[1][2] = 1.0 - v.position[1][2]
            v.position[3][1] = 2 * math.pi - v.position[3][1];
            v.position[3][2] = -v.position[3][2];
        else
            for i=1, v.count do
                v.position[i][2] = 1.0 - v.position[i][2]
            end
        end
    end

    if yMirror then
        if v.type == NPT_CIRCLE then
            local t = v.position[1][1]
            v.position[1][1] = 1.0 - v.position[1][2]
            v.position[1][2] = 1.0 - t
            v.position[3][1] = v.position[3][1] + math.pi / 2
        else
            for i=1, v.count do
                local t = v.position[i][1]
                v.position[i][1] = v.position[i][2]
                v.position[i][2] = t
            end
        end
    end

    if yMirror then
        if v.type == NPT_CIRCLE then

            v.position[3][1] = v.position[3][1] + v.position[3][2]
            v.position[3][2] = -v.position[3][2]
        else
            for i=1, v.count do
                local t = v.position[i][1]
                v.position[i][1] = v.position[v.count - i + 1][1]
                v.position[v.count - i + 1][1] = t


                local t = v.position[i][2]
                v.position[i][2] = v.position[v.count - i + 1][2]
                v.position[v.count - i + 1][2] = t
            end
        end
    end

    return v
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

    io.writefile("jaye_test.text", sz_T2S(self._boundBoxMap), "w+")

end

function FishGameXMLConfigManager:getCannonPosition(chairID)
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
