local DdzRules = class("DdzRules")

-- 牌的大小值 --
DdzRules.VALUE_TABLE = {


    -- [0] = 1,  --3
    -- [1] = 2,  --4
    -- [2] = 3,   --5 
    -- [3] = 4,   --6 
    -- [4] = 5,   --7
    -- [5] = 6,   --8
    -- [6] = 7,   --9
    -- [7] = 8,   --10
    -- [8] = 9,   --J
    -- [9] = 10,  --Q
    -- [10] = 11, -- k
    -- [11] = 12, -- A
    -- [12] = 13, -- 2
    -- [13] = 14, -- 小王
    -- [14] = 15, -- 大王
    -- [15] = 16, -- JJ
    [0] = 1,
    [1] = 2,  --3
    [2] = 3,   --4 
    [3] = 4,   --5 
    [4] = 5,   --6
    [5] = 6,   --7
    [6] = 7,   --8
    [7] = 8,   --9
    [8] = 9,   --10
    [9] = 10,  --j
    [10] = 11, -- Q
    [11] = 12, -- K
    [12] = 13, -- A
    [13] = 14, -- 2
    [14] = 15, -- 小王
    [15] = 16, -- 小王
}
DdzRules.VALUE_TABLE_RE = {
    -- [0] = 0,   --3
    -- [1] = 1,   --4 
    -- [2] = 2,   --5
    -- [3] = 3,   --6
    -- [4] = 4,   --7
    -- [5] = 5,   --8
    -- [6] = 6,   --9
    -- [7] = 7,   --10
    -- [8] = 8,   -- J
    -- [9] = 9,   -- Q
    -- [10] = 10, -- K
    -- [11] = 11, --A
    -- [12] = 12, --2 
    -- [13] = 13, -- 小王
    -- [14] = 14, -- 大王
    [0] = 0,
    [1] = 1,  --3
    [2] = 2,   --4 
    [3] = 3,   --5 
    [4] = 4,   --6
    [5] = 5,   --7
    [6] = 6,   --8
    [7] = 7,   --9
    [8] = 8,   --10
    [9] = 9,  --j
    [10] = 10, -- Q
    [11] = 11, -- K
    [12] = 12, -- A
    [13] = 13, -- 2
    [14] = 14, -- 小王

}
---通过下班
DdzRules.VALUE_SOUND_RE = {
    [1] = 3,
    [2] = 4,
    [3] = 5,
    [4] = 6,
    [5] = 7,
    [6] = 8,
    [7] = 9,
    [8] = 10,
    [9] = 11, -- J
    [10] = 12, -- Q
    [11] = 13, -- K
    [12] = 1, -- A 
    [13] = 2,
    [14] = 14, -- jj
    [15] = 15, -- JJ
}

-- 逻辑类型 --
DdzRules.CT_ERROR = 0 -- 错误类型
DdzRules.CT_SINGLE = 1 -- 单牌类型
DdzRules.CT_DOUBLE = 2 -- 对牌类型
DdzRules.CT_THREE = 3 -- 三条类型
DdzRules.CT_SINGLE_LINE = 4 -- 单连类型
DdzRules.CT_DOUBLE_LINE = 5 -- 对连类型
DdzRules.CT_THREE_LINE = 6 -- 三连类型
DdzRules.CT_THREE_TAKE_ONE = 7 -- 三带一单
DdzRules.CT_THREE_TAKE_TWO = 8 -- 三带一对
DdzRules.CT_FOUR_TAKE_ONE = 9 -- 四带两单
DdzRules.CT_FOUR_TAKE_TWO = 10 -- 四带两对
DdzRules.CT_BOMB_CARD = 11 -- 炸弹类型
DdzRules.CT_MISSILE_CARD = 12 -- 火箭类型
DdzRules.CT_FEIJI_ONE = 13 -- 飞机带单
DdzRules.CT_FEIJI_TWO = 14 -- 飞机带对
DdzRules.CardTypeText = {
    [0] = "错误",
    "单牌",
    "对子",
    "三条",
    "单连",
    "对连",
    "三连",
    "三带一",
    "三带二",
    "四带两",
    "四带两对",
    "炸弹",
    "火箭",
}

-- 数值掩码 --
DdzRules.MASK_COLOR = 0xF0 -- 花色掩码
DdzRules.MASK_VALUE = 0x0F -- 数值掩码


--- 对牌进行升序排序 
--- @data 牌的数据
function DdzRules.SortAscenCard(data)
    table.sort(data, function(a, b)
        local c_a = DdzRules.GetCardColor(a)
        local c_b = DdzRules.GetCardColor(b)
        local v_a = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(a)]
        local v_b = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(b)]

        if v_a == v_b then
            return c_a < c_b
        else
            return v_a < v_b
        end
    end)
end

--- 对牌进行排序
--- @data 牌的数据
function DdzRules.SortCard(data)
    table.sort(data, function(a, b)
        local c_a = DdzRules.GetCardColor(a)
        local c_b = DdzRules.GetCardColor(b)
        local v_a = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(a)]
        local v_b = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(b)] --DdzRules.VALUE_TABLE[DdzRules.GetCardValue(b)]

        if v_a == v_b then
            return c_a > c_b
        else
            return v_a > v_b
        end
    end)
end

function DdzRules.GetCardRValue(card)

    return DdzRules.VALUE_TABLE[DdzRules.GetCardValue(card)]
end

function DdzRules.GetCardByRValue(valeu)
    return DdzRules.VALUE_TABLE_RE[valeu]
end
---转换出来的真实值
function DdzRules.GetCardSoundValue(valeu)
    return DdzRules.VALUE_SOUND_RE[valeu]
end

function DdzRules.GetCardValue(a_value)
    return  DdzRules.convertCardNumToPoint(a_value); ---bit._and(a_value, DdzRules.MASK_VALUE)
end

function DdzRules.GetCardColor(a_value)
    return math.floor(a_value%4)-- bit._and(a_value, DdzRules.MASK_COLOR)
end

function DdzRules.GetCardLogicValue(cbCardData)
    -- 扑克属性
    local cbCardColor = DdzRules.GetCardColor(cbCardData)
    local cbCardValue = DdzRules.convertCardNumToPoint(cbCardData);
    return DdzRules.VALUE_TABLE[cbCardValue]
end

function DdzRules.AnalysebCardData(cbCardData)
    local cbCardCount = #cbCardData
    local AnalyseResult = {
        cbBlockCount = { 0, 0, 0, 0 },
        cbValueCount = {},
        cbCardData = { {}, {}, {}, {}, },
    }
    --print("0xF:",0xF)
    for i = 1, 0xF do
        AnalyseResult.cbValueCount[i] = 0
    end

    -- 扑克分析
    for i = 1, cbCardCount do
        --变量定义
        local cbLogicValue = DdzRules.GetCardLogicValue(cbCardData[i])
        AnalyseResult.cbValueCount[cbLogicValue] = AnalyseResult.cbValueCount[cbLogicValue]+1
    end
    for k, v in pairs(AnalyseResult.cbValueCount) do
        if v > 0 then
            AnalyseResult.cbBlockCount[v] = AnalyseResult.cbBlockCount[v] + 1
        end
    end
    for i = 1, 0xF do
        local value = AnalyseResult.cbValueCount[i]
        if value and value > 0 then

            table.insert(AnalyseResult.cbCardData[value], i)
            
        end
    end

    return AnalyseResult
end

function DdzRules.CardType(type, value, count)
    return {
        type = type or DdzRules.CT_ERROR,
        value = value or 0,
        count = count or 1,
    }
end

function DdzRules.GetCardType(cbCardData)
    cbCardData = cbCardData or {}

    local cbCardCount = #cbCardData
    if cbCardCount == 0 then
        return DdzRules.CardType()
    elseif cbCardCount == 1 then
        -- 单牌 --
        return DdzRules.CardType(DdzRules.CT_SINGLE, DdzRules.GetCardLogicValue(cbCardData[1]))
    elseif cbCardCount == 2 then
        -- 对王 --
        if ((cbCardData[1] == 52) and (cbCardData[2] == 53)) or ((cbCardData[1] == 53) and (cbCardData[2] == 52)) then
            return DdzRules.CardType(DdzRules.CT_MISSILE_CARD, 0x0E)
        end
        -- 对子 --
        if (DdzRules.GetCardLogicValue(cbCardData[1]) == DdzRules.GetCardLogicValue(cbCardData[2])) then
            return DdzRules.CardType(DdzRules.CT_DOUBLE, DdzRules.GetCardLogicValue(cbCardData[1]))
        end
        return DdzRules.CardType()
    end

    -- 分析牌型 --
    local AnalyseResult = DdzRules.AnalysebCardData(cbCardData)
    ---dump(AnalyseResult, "AnalyseResult")
    -- 四牌判断 --
    if (AnalyseResult.cbBlockCount[4] > 0) then
        -- 炸弹 --
        if ((AnalyseResult.cbBlockCount[4] == 1) and (cbCardCount == 4)) then
            return DdzRules.CardType(DdzRules.CT_BOMB_CARD, DdzRules.GetCardLogicValue(cbCardData[1]))
        end
        -- 四带二 --
        if ((AnalyseResult.cbBlockCount[4] == 1) and (cbCardCount == 6)) then
            return DdzRules.CardType(DdzRules.CT_FOUR_TAKE_ONE, AnalyseResult.cbCardData[4][1], AnalyseResult.cbBlockCount[4])
        end
        -- 四带两对 --
        if ((AnalyseResult.cbBlockCount[4] == 1) and (cbCardCount == 8) and (AnalyseResult.cbBlockCount[2] == 2)) then
            return DdzRules.CardType(DdzRules.CT_FOUR_TAKE_TWO, AnalyseResult.cbCardData[4][1], AnalyseResult.cbBlockCount[4])
        end
        return DdzRules.CardType()
    end

    -- 三牌判断 --
    if (AnalyseResult.cbBlockCount[3] > 0) then
        -- 连牌判断 --
        if (AnalyseResult.cbBlockCount[3] > 1) then
            local cbFirstLogicValue = AnalyseResult.cbCardData[3][1]
            if (cbFirstLogicValue > 11) or cbFirstLogicValue + AnalyseResult.cbBlockCount[3] - 1 > 12 then
                return DdzRules.CardType()
            end
            -- 连牌判断 --
            for i = 2, AnalyseResult.cbBlockCount[3] do
                local cbCardData = AnalyseResult.cbCardData[3][i]
                if cbFirstLogicValue + i - 1 ~= cbCardData then return DdzRules.CardType() end
            end
        elseif (cbCardCount == 3) then
            return DdzRules.CardType(DdzRules.CT_THREE, AnalyseResult.cbCardData[3][1])
        end

        -- 牌形判断 --
        if (AnalyseResult.cbBlockCount[3] * 3 == cbCardCount) then
            -- 三连顺 --
            return DdzRules.CardType(DdzRules.CT_THREE_LINE, AnalyseResult.cbCardData[3][1], AnalyseResult.cbBlockCount[3])
        end
        if (AnalyseResult.cbBlockCount[3] * 4 == cbCardCount) then
            return DdzRules.CardType(DdzRules.CT_THREE_TAKE_ONE, AnalyseResult.cbCardData[3][1], AnalyseResult.cbBlockCount[3])
        end
        if ((AnalyseResult.cbBlockCount[3] * 5 == cbCardCount) and (AnalyseResult.cbBlockCount[2] == AnalyseResult.cbBlockCount[3])) then
            return DdzRules.CardType(DdzRules.CT_THREE_TAKE_TWO, AnalyseResult.cbCardData[3][1], AnalyseResult.cbBlockCount[3])
        end

        return DdzRules.CardType()
    end

    -- 两张类型 --
    if (AnalyseResult.cbBlockCount[2] >= 3) then
        local cbFirstLogicValue = AnalyseResult.cbCardData[2][1]
        if cbFirstLogicValue > 10
                or cbFirstLogicValue + AnalyseResult.cbBlockCount[2] - 1 > 12
        then
            return DdzRules.CardType()
        end

        -- 连牌判断 --
        for i = 2, AnalyseResult.cbBlockCount[2] do
            local cbCardData = AnalyseResult.cbCardData[2][i]
            if cbFirstLogicValue + i - 1 ~= cbCardData then return DdzRules.CardType() end
        end

        -- 二连判断 --
        if ((AnalyseResult.cbBlockCount[2] * 2) == cbCardCount) then
            return DdzRules.CardType(DdzRules.CT_DOUBLE_LINE, cbFirstLogicValue, AnalyseResult.cbBlockCount[2])
        end

        return DdzRules.CardType()
    end

    -- 单张判断 --
    if ((AnalyseResult.cbBlockCount[1] >= 5) and (AnalyseResult.cbBlockCount[1] == cbCardCount)) then
        --变量定义
        local cbFirstLogicValue = AnalyseResult.cbCardData[1][1]
        -- 错误过虑,最少五张，如果大于8，即比10大 --
        if cbFirstLogicValue > 8
                or cbFirstLogicValue + AnalyseResult.cbBlockCount[1] - 1 > 12
        then
            return DdzRules.CardType()
        end

        -- 连牌判断 --
        for i = 2, AnalyseResult.cbBlockCount[1] do
            local cbCardData = AnalyseResult.cbCardData[1][i]
            if cbFirstLogicValue + i - 1 ~= cbCardData then return DdzRules.CardType() end
        end
        return DdzRules.CardType(DdzRules.CT_SINGLE_LINE, cbFirstLogicValue, AnalyseResult.cbBlockCount[1])
    end

    return DdzRules.CardType()
end

function DdzRules.GetCardTypeText(...)
    local result = DdzRules.GetCardType(...)
    return {
        type = DdzRules.CardTypeText[result.type],
        value = result.value,
        count = result.count,
    }
end

function DdzRules.convertCardNumToPoint(cardNum)
    -- body
    
    if cardNum == 52 then
        return 13
    end
    if cardNum == 53 then
        return 14
    end
    local point = math.floor(cardNum / 4)
    local suit  = math.floor(cardNum % 4)
    if point == 0 then
        
    end
    ---print("cardNum:",cardNum,"point:",point)
    return point
end





function DdzRules.SearchOutCardForHelp_None(mycards, AnalyseResult)
    local value = {}

    -- 单牌,对子,三个 --
    for kkk = DdzRules.CT_SINGLE, DdzRules.CT_THREE do
        for i = 1, 0xd do
            if AnalyseResult.cbValueCount[i] and AnalyseResult.cbValueCount[i] > kkk - DdzRules.CT_SINGLE then
                local ele = {}
                for j = 1, kkk - DdzRules.CT_SINGLE + 1 do
                    table.insert(ele, i)
                end
                table.insert(value, ele)
                break
            end
        end
    end

    -- 单顺，双顺，三顺 --
    local lineConfig = {
        [DdzRules.CT_SINGLE_LINE] = 5,
        [DdzRules.CT_DOUBLE_LINE] = 3,
        [DdzRules.CT_THREE_LINE] = 2,
    }
    for kkk = DdzRules.CT_SINGLE_LINE, DdzRules.CT_THREE_LINE do
        local cardNum = kkk - DdzRules.CT_SINGLE_LINE
        local start = nil
        local count = 0
        for i = 1, 0xC do
            if start == nil then
                if AnalyseResult.cbValueCount[i] > cardNum then
                    start = i
                    count = count + 1
                end
            else
                if AnalyseResult.cbValueCount[i] > cardNum then
                    count = count + 1
                else
                    break
                end
            end
            if count >= lineConfig[kkk] then
                for i = 1, count - lineConfig[kkk] + 1 do
                    local temp = {}
                    for j = 1, lineConfig[kkk] do
                        for z = 1, cardNum + 1 do
                            table.insert(temp, start + j - 1)
                        end
                    end
                    table.insert(value, temp)
                    break
                end
                break
            end
        end
    end

    -- 三带一 --
    for kkk = DdzRules.CT_THREE_TAKE_ONE, DdzRules.CT_THREE_TAKE_TWO do
        local start = nil
        local count = 0
        for i = 1, 0xC do
            if start == nil then
                if AnalyseResult.cbValueCount[i] > 2 then
                    start = i
                    count = count + 1
                end
            else
                if AnalyseResult.cbValueCount[i] > 2 then
                    count = count + 1
                else
                    break
                end
            end

            if count >= 1 then
                for z = 1, 1 do
                    local tempCards = clone(AnalyseResult.cbValueCount)

                    local temp = {}
                    for j = 1, 1 do
                        local index = start - 1 + j
                        table.insert(temp, index)
                        table.insert(temp, index)
                        table.insert(temp, index)

                        tempCards[index] = 0
                    end

                    local _a = {}
                    for k, v in pairs(tempCards) do
                        if v > kkk - DdzRules.CT_THREE_TAKE_ONE then
                            table.insert(_a, k)
                        end
                    end
                    if #_a >= 1 then
                        for j = 1, 1 do
                            for kk = 1, kkk - DdzRules.CT_THREE_TAKE_ONE + 1 do
                                table.insert(temp, _a[j])
                            end
                        end
                        table.insert(value, temp)
                    end
                end
            end
        end
    end

    -- 嗨个炸弹 --
    for i = 1, 0xd do
        if AnalyseResult.cbValueCount[i] == 4 then
            table.insert(value, { i, i, i, i })
        end
    end

    -- 最后找对王搞死对面 --
    if AnalyseResult.cbValueCount[0xE] > 0 and AnalyseResult.cbValueCount[0xF] > 0 then
        table.insert(value, { 0xE, 0xF })
    end

    -- 最后进行一次转化 --
    local _result = {}
    for k, v in ipairs(value) do
        local _mycards = clone(mycards)
        local _ele = {}

        for kk, vv in ipairs(v) do
            for kkk, vvv in ipairs(_mycards) do
                if DdzRules.GetCardLogicValue(vvv) == vv then
                    table.insert(_ele, vvv)
                    table.remove(_mycards, kkk)
                    break
                end
            end
        end
        table.insert(_result, _ele)
    end
    return _result
end

--- 出牌提示
function DdzRules.SearchOutCardForHelp(mycards, cards)
    -- 首先分析统计 --
    local AnalyseResult = DdzRules.AnalysebCardData(mycards)

    --dump(AnalyseResult,"AnalyseResult")
    local value = {}

    local result = DdzRules.GetCardType(cards)

    --dump(result, "result---");


    if result.type == DdzRules.CT_MISSILE_CARD then
        -- 如果当前牌为对王，那就无解 --
        return {}
    elseif result.type == DdzRules.CT_ERROR then
        return DdzRules.SearchOutCardForHelp_None(mycards, AnalyseResult)
    ---单排 --- 对子 ---- 三条   
    elseif result.type == DdzRules.CT_SINGLE  or result.type == DdzRules.CT_DOUBLE or result.type == DdzRules.CT_THREE then
        for i = result.value + 1, 0xd do
            if AnalyseResult.cbValueCount[i] and AnalyseResult.cbValueCount[i] > result.type - DdzRules.CT_SINGLE then
                local ele = {}
                for j = 1, result.type - DdzRules.CT_SINGLE + 1 do
                    table.insert(ele, i)
                end
                table.insert(value, ele)
            end
        end

        if result.type == DdzRules.CT_SINGLE then
            if result.value < 0xE and AnalyseResult.cbValueCount[0xE] > 0 then
                table.insert(value, { 0xE })
            end
            if AnalyseResult.cbValueCount[0xF] > 0 then
                table.insert(value, { 0xF })
            end
        end
    ---单连类型 ----对连类型 ---三连类型
    elseif result.type == DdzRules.CT_SINGLE_LINE or result.type == DdzRules.CT_DOUBLE_LINE or result.type == DdzRules.CT_THREE_LINE then
        local cardNum = result.type - DdzRules.CT_SINGLE_LINE
        for i = result.value + 1, 0xC - result.count + 1 do
            if AnalyseResult.cbValueCount[i] > cardNum then
                local isOk = true
                for n = i + 1, i + result.count - 1 do

                    if n >= 0xD or AnalyseResult.cbValueCount[n] <= cardNum then
                        isOk = false
                        break
                    end
                end
                -- 满足顺子的条件 --
                if isOk then
                    local temp = {}
                    for j = 1, result.count do
                        local index = i + j - 1
                        for n=1,cardNum + 1 do
                            table.insert(temp, index)
                        end
                    end
                    table.insert(value, temp)
                end
            end
        end
    ----三带一单 ---三带一对
    elseif result.type == DdzRules.CT_THREE_TAKE_ONE or result.type == DdzRules.CT_THREE_TAKE_TWO then
        -- 如果是连子，就不包含2在内 --
        print("0xE:",0xE)
        print("0xD:",0xD)
        for i = result.value + 1, 0xE - result.count do
            -- 满足两张 --
            if AnalyseResult.cbValueCount[i] > 2 then
                local isOk = true
                for n = i + 1, i + result.count - 1 do

                    if n >= 0xD or AnalyseResult.cbValueCount[n] <= 2 then
                        isOk = false
                        break
                    end
                end
                -- 满足顺子的条件 --
                if isOk then
                    local tempCards = clone(AnalyseResult.cbValueCount)

                    local temp = {}
                    for j = 1, result.count do
                        local index = i + j - 1
                        table.insert(temp, index)
                        table.insert(temp, index)
                        table.insert(temp, index)

                        tempCards[index] = 0
                    end
                    local _a = {}
                    for k, v in pairs(tempCards) do
                        if v > result.type - DdzRules.CT_THREE_TAKE_ONE then
                            table.insert(_a, k)
                        end
                    end

                    if #_a >= result.count then
                        for j = 1, result.count do
                            for kk = 1, result.type - DdzRules.CT_THREE_TAKE_ONE + 1 do
                                table.insert(temp, _a[j])
                            end
                        end
                        table.insert(value, temp)
                    end
                end
            end
        end
    
    elseif result.type == DdzRules.CT_FOUR_TAKE_ONE or result.type == DdzRules.CT_FOUR_TAKE_TWO then
        -- 四带二 ，四带一对 --
        for i = result.value + 1, 0x0D do
            -- 满足四张 --
            if AnalyseResult.cbValueCount[i] > 3 then
                local tempCards = clone(AnalyseResult.cbValueCount)

                local temp = {}
                for j = 1, result.count do
                    local index = i + j - 1
                    table.insert(temp, index)
                    table.insert(temp, index)
                    table.insert(temp, index)
                    table.insert(temp, index)

                    tempCards[index] = 0
                end

                local _a = {}
                for k, v in pairs(tempCards) do
                    if v > result.type - DdzRules.CT_FOUR_TAKE_ONE then
                        table.insert(_a, k)
                    end
                end

                if #_a >= result.count * 2 then
                    for kk = 1, result.type - DdzRules.CT_FOUR_TAKE_ONE + 1 do
                        table.insert(temp, _a[1])
                    end
                    table.remove(_a, 1)

                    for kk = 1, result.type - DdzRules.CT_FOUR_TAKE_ONE + 1 do
                        table.insert(temp, _a[1])
                    end
                    table.remove(_a, 1)

                    table.insert(value, temp)
                end
            end
        end
    end

    -- 如果对面的炸弹，找到比他大的炸弹，否则随便整个炸弹 --
    local bombIndex = 1
    if result.type == DdzRules.CT_BOMB_CARD then
        bombIndex = result.value + 1
    end
    -- 找到比当前大的炸弹 --
    for i = bombIndex, 0xd do
        if AnalyseResult.cbValueCount[i] == 4 then
            table.insert(value, { i, i, i, i })
        end
    end

    -- 最后找对王搞死对面 --
    if AnalyseResult.cbValueCount[0xE] > 0 and AnalyseResult.cbValueCount[0xF] > 0 then
        table.insert(value, { 0xE, 0xF })
    end
    -- 最后进行一次转化 --
    local _result = {}
    for k, v in ipairs(value) do
        local _mycards = clone(mycards)
        local _ele = {}

        for kk, vv in ipairs(v) do
            for kkk, vvv in ipairs(_mycards) do
                if DdzRules.GetCardLogicValue(vvv) == vv then
                    table.insert(_ele, vvv)
                    table.remove(_mycards, kkk)
                    break
                end
            end
        end
        table.insert(_result, _ele)
    end

    return _result
end


----根据牌型排序
function DdzRules.showCardsTypeSort(cards)
    local tempCards = {};
    for k,v in pairs(cards) do
        table.insert(tempCards,v)
    end
    local testNewtble = {} ---一样的
    local testNewTable_1 = {} ----不一样的
    local testNewTable_2 = {}

    ---取出一样的一个
    for i=1,#tempCards do

        if (i+2) > #tempCards then
            break;
        end
        local v_a = gameDdz.DdzRules.VALUE_TABLE[gameDdz.DdzRules.convertCardNumToPoint(tempCards[i])]
        local v_b = gameDdz.DdzRules.VALUE_TABLE[gameDdz.DdzRules.convertCardNumToPoint(tempCards[i+1])]
        local v_c = gameDdz.DdzRules.VALUE_TABLE[gameDdz.DdzRules.convertCardNumToPoint(tempCards[i+2])]
        
        if v_a == v_b and v_a == v_c then
            table.insert(testNewtble,tempCards[i])
        end
    end
    --dump(testNewtble, "testNewtble")

    ---所有一样的
    for i = #tempCards,1,-1 do
        for _i,_v in ipairs(testNewtble) do
            local v_a = gameDdz.DdzRules.VALUE_TABLE[gameDdz.DdzRules.convertCardNumToPoint(tempCards[i])]
            local v_b = gameDdz.DdzRules.VALUE_TABLE[gameDdz.DdzRules.convertCardNumToPoint(_v)]
            if v_a == v_b then
                table.insert(testNewTable_2,tempCards[i])
                break;
            end
        end
    end
    --dump(testNewTable_2, "testNewTable_2")

    ---取出不一样的值
    for i,v in ipairs(tempCards) do
        local have = false
        for _i,_v in ipairs(testNewtble) do
            local v_a = gameDdz.DdzRules.VALUE_TABLE[gameDdz.DdzRules.convertCardNumToPoint(v)]
            local v_b = gameDdz.DdzRules.VALUE_TABLE[gameDdz.DdzRules.convertCardNumToPoint(_v)]
            if v_a ~= v_b then
                have = false
            else
                have = true
                break
            end
        end
        if have == false then
            table.insert(testNewTable_1,v)
        end
    end
    --dump(testNewTable_1, "testNewTable_1")
    

    ---把一样的和不一样的合并
    for i = #testNewTable_1,1,-1 do
        table.insert(testNewTable_2,testNewTable_1[i])
    end
    return testNewTable_2
end


--/********************************************************************************************************/
---查询牌组里面是否有指定牌号的值;
function DdzRules.isContainInCards(cardNum, desCards)
    -- body
    local  ret = false;
    for i,v in ipairs(desCards) do
        if cardNum == desCards[i]  then --DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(desCards[i])]
            ret = true
            break;
        end
    end
    return ret;
end

----数组取重
function DdzRules.unique(arr)
    local result = {}
    local hash = {}
    local elem = 1
    local x = #arr
    for i = 1,x do
        elem = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(arr[i])]
        if hash[elem] == nil or  hash[elem] == false  then
            table.insert(result, arr[i])
            hash[elem] = true
        end
    end

    return result
end


function DdzRules.getSubCards(my_cards,container, len, excludes) 
    local con = container;
    local len = len;
    local retCards = {};
    local hash = {};
    dump(excludes, "excludes:")
    if excludes ~= nil then
        local elem = 1
        for i,v in ipairs(excludes) do
            hash[v] = true
        end
        -- for i=1,#excludes do
        --     elem = excludes[i]
        --     if elem ~= nil then
        --          hash[elem] = true;
        --     end
        -- end
    end
    if len <= 1 then
        for i=1, #con.danpai do
             table.insert(retCards,con.danpai[i])
             return retCards
        end
    end
    if len <= 2 then
        for i=1, #con.duizi do
            local index = 0
            local a_c =  DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(con.duizi[i])]
            for j,v in ipairs(my_cards) do
                -- print("3带2-----7",index,"len:",len)
                -- if index == len then
                --     dump(retCards,"retCards---0")
                --     return retCards
                -- end
                local a_b = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(v)]
                if a_c==a_b then
                    table.insert(retCards,v)
                    index = index+1
                end
                if index == len then
                    return retCards
                end
            end
        end
    end
    if len <= 3 then
        for i=1, #con.santiao do
            if hash[con.santiao[i]] ~= true then
                local index = 0
                local a_c =  DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(con.santiao[i])]
                for j,v in ipairs(my_cards) do
                    if index == len then
                        return retCards
                    end
                    local a_b =  DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(v)]
                    if a_c==a_b then
                        table.insert(retCards,v)
                        index = index+1
                    end
                end
                return retCards
            end
        end
    end
    return nil
end




-- [[从container中取比[beg/len]大的一组牌, 单牌/对子/三条/四条;
--  *@ container = {danpai:[],duizi:[],santiao:[],sitiao:[]}
--  *@ beg: 起值(关键值), target_len:取出值长度;
--  *@ flag: 是否允许拆分四条, 默认或未设置为允许;
--  *@ ret = {flag:false, cards:[]}]]

 
function DdzRules.getBiggerCardsArr(my_cards,container, cardsBeg, target_len, flag) 

    local con = container;
    local len = target_len;
    local retCards = {};
    local beg = cardsBeg --DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(cardsBeg)]
    print("cardsBeg:",cardsBeg)
    if len <=1 then
        for i=1,#con.danpai do
            local temp = {}
            local a_c = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(con.danpai[i])]
            
            if a_c > beg then
                table.insert(temp,con.danpai[i]);
            end
            if #temp>0 then
                table.insert(retCards,temp)
            end
        end
    end

    if len <= 2 then
        for i=1,#con.duizi do
           local a_c = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(con.duizi[i])]
           if a_c > beg then
                local temp = {};
                    local index = 0
                    for j,v in ipairs(my_cards) do
                        local a_b = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(v)]
                        if a_c == a_b then
                            table.insert(temp,v)
                            index = index +1
                        end
                        if index == len then
                            break
                        end
                    end
                if #temp > 0 then
                   table.insert(retCards,temp)
                end
           end
        end
    end

    if len <= 3 then
        for i=1,#con.santiao do
           local a_c = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(con.santiao[i])]
           if a_c > beg then
                local temp = {};
                    local index = 0
                    for j,v in ipairs(my_cards) do
    
                        local a_b = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(v)]
                        if a_c == a_b then
                            table.insert(temp,v)
                            index = index+1
                        end
                        if index == len then
                            break
                        end
                    end
                if #temp > 0 then
                   table.insert(retCards,temp)
                end
           end
        end
    end

    if flag == nil or flag == true then
        if len <= 4 then
            for i=1,#con.sitiao do
                local a_c = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(con.sitiao[i])]
                if a_c>beg then
                    temp = {};
                    local index = 0                
                    for j,v in ipairs(my_cards) do
                        local a_b = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(v)]
                        if a_c == a_b then
                            table.insert(temp,v)
                            index = index+1
                        end
                        if index == len then
                            break
                        end
                    end
                    --dump(temp, "#temp----")
                    if #temp > 0 and  #temp == len then
                        table.insert(retCards,temp)
                        
                    end
                end
            end
        end
    end
    return retCards
end


function DdzRules.getBiggerShunZiArr(myCards,desCards,srcbeg,srclen,cardsType)
    
    DdzRules.SortAscenCard(desCards)
    dump(desCards, "desCards")
    local len_des = #desCards
    local len_src =  srclen
    local delta = len_des - (srclen - 1)
    local isFind = true;
    local ret_arr = {};
    local bigger_cards = {};
    print("srcbeg:",srcbeg,"srclen:",srclen)

    for i=1,delta do
        isFind = true
        bigger_cards = {}
        local a_c = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(desCards[i])]
        --local srcbeg = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(srcbeg)] 
        if a_c > srcbeg then
            for j=1,len_src do
                local target_val = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(desCards[i])] + j-1
                if target_val >= 13 then
                    isFind = false;
                    bigger_cards = {};
                    break;
                end
                local count = 1
                if cardsType == DdzRules.CT_THREE_LINE  then
                    count = 3
                elseif cardsType == DdzRules.CT_DOUBLE_LINE then
                    count = 2
                elseif cardsType == DdzRules.CT_FEIJI_ONE then
                    count = 3
                elseif cardsType == DdzRules.CT_FEIJI_TWO then
                    count = 3
                else
                    count = 1
                end 
                 print("target_val:",target_val)
                for _i,_v in ipairs(myCards) do
                    if count == 0 then
                        break
                    end
                    if target_val == DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(_v)] then
                        print("_v:",DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(_v)],"target_val:",target_val)
                        table.insert(bigger_cards,_v)
                        count = count-1
                    end
                end
                if count ~= 0 then
                    isFind = false
                    bigger_cards = {};
                    break;
                end

                -- if #bigger_cards == srclen then
                --     dump(bigger_cards, "bigger_cards")
                --     break
                -- end
                -- local flag = DdzRules.isContainInCards(target_val, desCards);
                -- print("target_val:",target_val)
                -- dump(flag,"flag")
                -- if flag == false then
                --     isFind = false;
                --     bigger_cards = {};
                --     break;
                -- else
                --     for k=1,count do
                --         table.insert(bigger_cards,flag)
                --     end
                -- end
            end
            print(isFind)
            if isFind == true then
                if bigger_cards then
                    --todo
                end
                table.insert(ret_arr, bigger_cards)
            else
                isFind = false 
            end
        end
    end

    return ret_arr
 end


function DdzRules.Extract(cards)
    -- dump(cards,"cards11111")
    -- DdzRules.SortAscenCard(cards)
    -- dump(cards,"cards2222")
    local count = 0;
    local container = {
        danpai = {},
        duizi = {},
        santiao = {},
        sitiao = {}
    }

    for i = #cards,1 ,-1 do
        for j = #cards,1,-1 do
            local a_c = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(cards[i])]
            local a_b = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(cards[j])]
           
            if a_c == a_b then
                count = count+1;
            end
        end
        if count == 1 then
            table.insert(container.danpai,cards[i])
        elseif count == 2 then
            table.insert(container.duizi,cards[i])
        elseif count == 3 then
            table.insert(container.santiao,cards[i])
        elseif count == 4 then
            table.insert(container.sitiao,cards[i])
        end
        count = 0
    end
    DdzRules.SortAscenCard(container.danpai)
    DdzRules.SortAscenCard(container.duizi)
    DdzRules.SortAscenCard(container.santiao)
    DdzRules.SortAscenCard(container.sitiao)
    container.danpai = DdzRules.unique(container.danpai)
    container.duizi = DdzRules.unique(container.duizi)
    container.santiao = DdzRules.unique(container.santiao)
    container.sitiao = DdzRules.unique(container.sitiao)
    return container;
end

function DdzRules.getFirstTips(my_cards)

    local finalArr = {};
     ---提取所有的单牌/对子/三条/四条;
    local container = DdzRules.Extract(my_cards);

     if (#my_cards == 2) then
        local  ret = DdzRules.isWangZha(my_cards);
        if (ret.flag == true) then
            table.insert(finalArr, myCards)
            return finalArr;
        end
    end

    ---仅剩四张优先炸弹;
    if (#my_cards == 4)  then
        local ret = DdzRules.isZhaDan(myCards);
        if (ret.flag == true) then
            table.insert(finalArr, myCards)
            return finalArr;
        end
    end



    local retCardsArr = DdzRules.getBiggerCardsArr(my_cards,container,-1, 1, false);
    
    if #retCardsArr > 0 then
        for i=1,#retCardsArr do
             table.insert(finalArr, retCardsArr[i])
        end
    end

    if #finalArr > 0 then
        return finalArr;
    end
end

---出牌提示
function DdzRules.NewSearchOutCardForHelp(my_cards,pre_cards)
    -- body\
    print("444444444444")


    if (pre_cards == nil or pre_cards == false or pre_cards == true) and my_cards ~= nil then
        local finalArr = DdzRules.getFirstTips(my_cards)
        return finalArr
    end

    if my_cards == nil then
        return {}
    end

    -- for i=1,#pre_cards do
    --     print("my_cards:",DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(pre_cards[i])])
    -- end
    -- ---获取牌型
    local pre_result  = DdzRules.GetCardType(pre_cards)
    dump(pre_result,"pre_result")

    local pre_cardsInfo = DdzRules.getNewCardType(pre_cards)
    dump(pre_cardsInfo, "newResult")

    local pre_result = pre_cardsInfo

    local preCards = DdzRules.convertCardsNumToPointArr(pre_cards);
    local preSize = #pre_cards;
    DdzRules.SortCard(preCards)


    local myCards = DdzRules.convertCardsNumToPointArr(my_Cards);
    local mySize = #my_cards;
    DdzRules.SortCard(myCards)


    ---提取所有的单牌/对子/三条/四条;
    local container = DdzRules.Extract(my_cards);
    --dump(container, "container")


    local  result = {}
    ------ 王炸    
    if pre_cardsInfo.cardType == DdzRules.CT_MISSILE_CARD then
        return {};

    ------ 单牌
    elseif pre_cardsInfo.cardType == DdzRules.CT_SINGLE then
        
        local retCardsArr = DdzRules.getBiggerCardsArr(my_cards,container, pre_cardsInfo.beg, 1, false);
        --dump(retCardsArr, "retCardsArr")
        local special_arr = DdzRules.getSitiao_Wangzha(my_cards,container);
        if #special_arr > 0 then
            for i=1,#special_arr do
                 table.insert(retCardsArr, special_arr[i])
            end
        end
        if #retCardsArr > 0 then
            return retCardsArr;
        end

    ------ 对子
    elseif  pre_cardsInfo.cardType == DdzRules.CT_DOUBLE then
        print("对子------")
        local retCardsArr = DdzRules.getBiggerCardsArr(my_cards,container, pre_cardsInfo.beg, 2, false);
        --dump(retCardsArr, "retCardsArr")
        local special_arr = DdzRules.getSitiao_Wangzha(my_cards,container);
        if #special_arr > 0 then
            for i=1,#special_arr do
                 table.insert(retCardsArr, special_arr[i])
            end
        end
        if #retCardsArr > 0 then
            return retCardsArr;
        end

    ------ 三条
    elseif pre_cardsInfo.cardType == DdzRules.CT_THREE then
        print("三条------1")
        local retCardsArr = DdzRules.getBiggerCardsArr(my_cards,container, pre_cardsInfo.beg, 3, false);
        local special_arr = DdzRules.getSitiao_Wangzha(my_cards,container);
        if #special_arr > 0 then
            for i=1,#special_arr do
                 table.insert(retCardsArr, special_arr[i])
            end
        end
        if #retCardsArr > 0 then
            return retCardsArr;
        end

    ------ 三带一
    elseif pre_cardsInfo.cardType == DdzRules.CT_THREE_TAKE_ONE then
        print("三带一------1")
        local retCardsArr = DdzRules.getBiggerCardsArr(my_cards,container, pre_cardsInfo.beg, 3, false);
        --dump(retCardsArr,"三带一")
        local exceptArr = {}
        for i=1,#retCardsArr do
            local sub_ret = DdzRules.getSubCards(my_cards,container, 1, retCardsArr[i])
            if sub_ret~=nil then
                table.insert(retCardsArr[i], sub_ret[1])
            else
                table.insert(exceptArr,retCardsArr[i])
            end
        end

        local special_arr = DdzRules.getSitiao_Wangzha(my_cards,container);
        if #special_arr > 0 then
            for i=1,#special_arr do
                 table.insert(retCardsArr, special_arr[i])
            end
        end
        if #retCardsArr > 0 then
            return retCardsArr;
        end
        
    ----- 三带二
    elseif pre_cardsInfo.cardType == DdzRules.CT_THREE_TAKE_TWO then
       
        print("三带二------1")
        local retCardsArr = DdzRules.getBiggerCardsArr(my_cards,container, pre_cardsInfo.beg, 3, false);
        --dump(retCardsArr, "retCardsArr")
        local exceptArr = {}
        for i=1,#retCardsArr do
            local sub_ret = DdzRules.getSubCards(my_cards,container, 2, retCardsArr[i])
            --dump(sub_ret,"sub_ret")
            if sub_ret~=nil then
                local len = 0
                for j=1,2 do
                    table.insert(retCardsArr[i],sub_ret[j])
                end
            else
                table.insert(exceptArr,retCardsArr[i])
            end
        end

        local tempCardsArr = {};
        for i=1,#retCardsArr do
            if #retCardsArr[i] ==5 then
                table.insert(tempCardsArr, retCardsArr[i])
            end
        end

        local special_arr = DdzRules.getSitiao_Wangzha(my_cards,container);
        if #special_arr > 0 then
            for i=1,#special_arr do
                 table.insert(tempCardsArr, special_arr[i])
            end
        end
        if #tempCardsArr > 0 then
            --dump(tempCardsArr, "retCardsArr")
            return tempCardsArr;
        end

    ------ 四带两单
    elseif pre_cardsInfo.cardType == DdzRules.CT_FOUR_TAKE_ONE then
        print("4带2单:----")
        local retCardsArr = DdzRules.getBiggerCardsArr(my_cards,container, pre_cardsInfo.beg,  4 , true);
        --dump(retCardsArr,"retCardsArr")
        print("4带2单:----1")
        if (#retCardsArr > 0) then
            dump(retCardsArr,"retCardsArr")
            local exceptArr = {}
            for i,v in ipairs(retCardsArr) do
                local len = 2
                local temp = {}
                for j,j_v in ipairs(container.danpai) do
                    if len == 0 then
                        break;
                    end
                    table.insert(temp, j_v)
                    len = len -1
                end
                for j,j_v in ipairs(container.duizi) do
                    if len == 0 then
                        break;
                    end
                    for k = 1,2 do
                        if len == 0 then
                            break;
                        end
                         table.insert(temp, j_v)
                         len = len -1
                    end
                end
                for j,j_v in ipairs(container.santiao) do
                    if len == 0 then
                        break;
                    end
                    for k = 1,3 do
                        if len == 0 then
                            break;
                        end
                         table.insert(temp, j_v)
                         len = len -1
                    end
                end
                for j,j_v in ipairs(container.sitiao) do
                    if len == 0 then
                        break;
                    end
                    for k = 1,4 do
                        if len == 0 then
                            break;
                        end
                         table.insert(temp, j_v)
                         len = len -1
                    end
                end
                if len == 0 then
                    for i,v in ipairs(retCardsArr) do
                        for j,j_v in ipairs(temp) do
                            table.insert(retCardsArr[i], j_v)
                        end
                    end
                else
                    table.insert(exceptArr, retCardsArr[i])
                end
            end
        end
        local special_arr = DdzRules.getSitiao_Wangzha(my_cards,container);
        if #special_arr > 0 then
            for i=1,#special_arr do
                table.insert(retCardsArr, special_arr[i])
            end
        end       
        if #retCardsArr>0 then
             return retCardsArr
        end
       

    ------ 四带两对
    elseif pre_cardsInfo.cardType == DdzRules.CT_FOUR_TAKE_TWO  then 
        print("四带两对------")
        local retCardsArr = DdzRules.getBiggerCardsArr(my_cards,container, pre_cardsInfo.beg, 4, true);
        print("四带两对------1")
        if #retCardsArr > 0 then
            --dump(retCardsArr,"retCardsArr")
            local exceptArr = {}
            for i,v in ipairs(retCardsArr) do
                local len = 2
                local temp = {}

                for j,j_v in ipairs(container.duizi) do
                    local a_c = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(container.duizi[j])]
                    for k,v in pairs(my_cards) do
                        local a_b = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(v)]
                        if a_c == a_b then
                            table.insert(temp, v)
                        end
                    end
                    if #temp == 2 then
                        len = 1
                    elseif #temp == 4 then
                        len = 0
                        break
                    end
                end

                for j,j_v in ipairs(container.santiao) do
                    if len == 0 then
                        break;
                    end
                    local num = 0; ---
                    local flag = DdzRules.isContainInCards(container.santiao[j], retCardsArr[i]);
                    if flag == false then
                        local a_c = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(container.santiao[j])]
                        for k,v in pairs(my_cards) do
                            local a_b = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(v)]
                            if a_b == a_c then
                                table.insert(temp,v)
                                num = num +1;
                            end
                            ---只能放2个进去
                            if num == 2 then
                                break
                            end
                        end
                       
                    end
                    if #temp == 2 then
                        len = 1
                    elseif #temp == 4 then
                        len = 0
                        break
                    end
                end
                for j,j_v in ipairs(container.sitiao) do
                    if (len == 0) then
                        break;
                    end
                    local num = 0
                    local flag = DdzRules.isContainInCards(container.sitiao[j], retCardsArr[i]);
                    if flag == false then
                        local a_c = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(container.sitiao[j])]
                        for k,v in pairs(my_cards) do
                            local a_b = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(v)]
                            if a_c == a_b then
                                table.insert(temp,v)
                                num = num +1;
                            end
                            if num == 2 then
                                break
                            end
                        end
                    end
                    if #temp == 2 then
                        len = 1
                    elseif #temp == 4 then
                        len = 0
                        break
                    end
                end
                ----进行组合
                if len == 0 then
                    -- for j=1,#retCardsArr do
                    --     table.insert(retCardsArr[j], temp[1])
                    --     table.insert(retCardsArr[j], temp[2])
                    --     table.insert(retCardsArr[j], temp[3])
                    --     table.insert(retCardsArr[j], temp[4])
                    -- end
                    for i,v in ipairs(retCardsArr) do
                        for j,j_v in ipairs(temp) do
                            table.insert(retCardsArr[i], j_v)
                        end
                    end
                else
                    table.insert(exceptArr,retCardsArr[i])    
                end
            end
        end
        local special_arr = DdzRules.getSitiao_Wangzha(my_cards,container);
        if #special_arr > 0 then
            for i=1,#special_arr do
                table.insert(retCardsArr, special_arr[i])
            end
        end
        if #retCardsArr>0 then
            return retCardsArr
        end
        
    ------ 单连
    elseif pre_cardsInfo.cardType == DdzRules.CT_SINGLE_LINE then
        local retCardsArr = DdzRules.getBiggerShunZiArr(my_cards,my_cards,pre_cardsInfo.beg, pre_cardsInfo.len,  DdzRules.CT_SINGLE_LINE );
        --dump(retCardsArr, "retCardsArr")
        local special_arr = DdzRules.getSitiao_Wangzha(my_cards,container);
        if #special_arr > 0 then
            for i=1,#special_arr do
                 table.insert(retCardsArr, special_arr[i])
            end
        end
        if (#retCardsArr > 0) then
            return retCardsArr;
        end

    ------ 连对类型
    elseif pre_cardsInfo.cardType == DdzRules.CT_DOUBLE_LINE then
        local des = {}
        for i,v in ipairs(container.duizi) do
            table.insert(des,container.duizi[i])
        end
        for i,v in ipairs(container.santiao) do
            table.insert(des,container.santiao[i])
        end
        for i,v in ipairs(container.sitiao) do
            table.insert(des,container.sitiao[i])
        end


        local retCardsArr = DdzRules.getBiggerShunZiArr(my_cards,des, pre_cardsInfo.beg, pre_cardsInfo.len, DdzRules.CT_DOUBLE_LINE );
        local special_arr = DdzRules.getSitiao_Wangzha(my_cards,container);
        if #special_arr > 0 then
            for i=1,#special_arr do
                 table.insert(retCardsArr, special_arr[i])
            end
        end
        if (#retCardsArr > 0) then
            return retCardsArr;
        end

    ------ 三连类型
    elseif pre_cardsInfo.cardType == DdzRules.CT_THREE_LINE then
        local des = {}
        --dump(container,"container")
        for i,v in ipairs(container.santiao) do
            table.insert(des,container.santiao[i])
        end
        for i,v in ipairs(container.sitiao) do
            table.insert(des,container.sitiao[i])
        end
        
        local retCardsArr = DdzRules.getBiggerShunZiArr(my_cards,des, pre_cardsInfo.beg, pre_cardsInfo.len, DdzRules.CT_THREE_LINE);
        local special_arr = DdzRules.getSitiao_Wangzha(my_cards,container);
        if #special_arr > 0 then
            for i=1,#special_arr do
                 table.insert(retCardsArr, special_arr[i])
            end
        end
        if (#retCardsArr > 0) then
            return retCardsArr;
        end

    ----飞机带单;
    elseif pre_cardsInfo.cardType == DdzRules.CT_FEIJI_ONE then  
        local des = {}
        for i,v in ipairs(container.santiao) do
            table.insert(des,container.santiao[i])
        end
        for i,v in ipairs(container.sitiao) do
            table.insert(des,container.sitiao[i])
        end
        local retCardsArr = DdzRules.getBiggerShunZiArr(my_cards,des, pre_cardsInfo.beg, pre_cardsInfo.len, DdzRules.CT_FEIJI_ONE);
        if #retCardsArr > 0 then
            local exceptArr = {};
            for i=1,#retCardsArr do
                local len = pre_cardsInfo.len
                local temp = {}
                ---单排
                for j=1,#container.danpai do
                    if len == 0 then
                        break;
                    end
                    table.insert(temp, container.danpai[j])
                    len = len - 1
                end
                ---对子
                for j=1,#container.duizi do
                    if len == 0 then
                        break;
                    end
                    local a_c = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(container.duizi[j])]
                    for k,v in pairs(my_cards) do
                        local a_b = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(v)]
                        if a_c == a_b then
                            table.insert(temp, v)
                            len = len - 1
                        end
                        if len == 0 then
                            break
                        end
                    end
                end

                ----三条
                for j=1,#container.santiao do
                    --拆三条;
                    if len == 0 then
                        break;
                    end
                    local flag = DdzRules.isContainInCards(container.santiao[j], retCardsArr[i]);
                    if flag == false then
                        local a_c = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(container.sitiao[j])]

                        for k,v in pairs(my_cards) do
                            local a_b = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(v)]
                            if a_b == a_c then
                                table.insert(temp,v)
                            end
                            len =  len - 1
                            if len == 0 then
                                break
                            end
                        end
                    end
                end

                ---四条
                for j=1,#container.sitiao do
                    if (len == 0) then
                        break;
                    end
                    local flag = DdzRules.isContainInCards(container.sitiao[j], retCardsArr[i]);
                    if flag == false then
                        local a_c = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(container.sitiao[j])]
                        for k,v in pairs(my_cards) do
                            local a_b = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(v)]
                            if a_c == a_b then
                                table.insert(temp,v)
                                len = len - 1
                            end
                            if len == 0 then
                                break
                            end
                        end
                    end
                end

                ----进行组合
                if len == 0 then
                    for j=1,#retCardsArr do
                        table.insert(retCardsArr[j], temp[1])
                        table.insert(retCardsArr[j], temp[2])
                    end
                else
                    table.insert(exceptArr,retCardsArr[i])    
                end
            end
        end

        local special_arr = DdzRules.getSitiao_Wangzha(my_cards,container);
        if #special_arr > 0 then
            for i=1,#special_arr do
                 table.insert(retCardsArr, special_arr[i])
            end
        end
        if (#retCardsArr > 0) then
            return retCardsArr;
        end

    ----飞机带对子;
    elseif pre_cardsInfo.cardType == DdzRules.CT_FEIJI_TWO then
        print("飞机带对子:----")
        local des = {}
        for i,v in ipairs(container.santiao) do
            table.insert(des,container.santiao[i])
        end
        for i,v in ipairs(container.sitiao) do
            table.insert(des,container.sitiao[i])
        end

        local retCardsArr = DdzRules.getBiggerShunZiArr(my_cards,des, pre_cardsInfo.beg, pre_cardsInfo.len, DdzRules.CT_FEIJI_TWO);
        --dump(retCardsArr, "retCardsArr")
        if #retCardsArr > 0 then
            local exceptArr = {};
            for i=1,#retCardsArr do

                local len = pre_cardsInfo.len
                local temp = {}
                if len == 0 then
                    break;
                end
                ---对子
                for j=1,#container.duizi do
                    local a_c = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(container.duizi[j])]
                    for k,v in pairs(my_cards) do
                        local a_b = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(v)]
                        if a_c == a_b then
                            print("len:",a_b)
                            table.insert(temp, v)
                        end
                    end
                    if #temp == 2 then
                        len = 1
                    elseif #temp == 4 then
                        len = 0
                        break
                    end
                end
                ----三条
                for j=1,#container.santiao do
                    --拆三条;
                    print("4带2 拆三条")
                    if len == 0 then
                        break;
                    end
                    local num = 0; ---
                    local flag = DdzRules.isContainInCards(container.santiao[j], retCardsArr[i]);
                    if flag == false then
                        local a_c = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(container.santiao[j])]
                        for k,v in pairs(my_cards) do
                            local a_b = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(v)]
                            if a_b == a_c then
                                table.insert(temp,v)
                                num = num +1;
                            end
                            ---只能放2个进去
                            if num == 2 then
                                break
                            end
                        end
                       
                    end
                    if #temp == 2 then
                        len = 1
                    elseif #temp == 4 then
                        len = 0
                        break
                    end
                end

                ---四条
                for j=1,#container.sitiao do
                    if (len == 0) then
                        break;
                    end
                    local num = 0
                    local flag = DdzRules.isContainInCards(container.sitiao[j], retCardsArr[i]);
                    if flag == false then
                        local a_c = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(container.sitiao[j])]
                        for k,v in pairs(my_cards) do
                            local a_b = DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(v)]
                            if a_c == a_b then
                                table.insert(temp,v)
                                num = num +1;
                            end
                            if num == 2 then
                                break
                            end
                        end
                    end
                    if #temp == 2 then
                        len = 1
                    elseif #temp == 4 then
                        len = 0
                        break
                    end
                end

                ----进行组合
                if len == 0 then
                    for j=1,#retCardsArr do
                        table.insert(retCardsArr[j], temp[1])
                        table.insert(retCardsArr[j], temp[2])
                        table.insert(retCardsArr[j], temp[3])
                        table.insert(retCardsArr[j], temp[4])
                    end
                else
                    table.insert(exceptArr,retCardsArr[i])    
                end
            end
        end

        local special_arr = DdzRules.getSitiao_Wangzha(my_cards,container);
        if #special_arr > 0 then
            for i=1,#special_arr do
                 table.insert(retCardsArr, special_arr[i])
            end
        end
        if (#retCardsArr > 0) then
            --dump(retCardsArr,"所有飞机带对子")
            return retCardsArr;
        end

    ----- 炸弹类型
    elseif pre_cardsInfo.cardType == DdzRules.CT_BOMB_CARD then
        print("炸弹类型:----")
        local retCardsArr = DdzRules.getBiggerCardsArr(my_cards,container, pre_cardsInfo.beg, 4, true);
        local special_arr = DdzRules.getWangzha(container);
        if #special_arr > 0 then
            for i=1,#special_arr do
                 table.insert(retCardsArr, special_arr[i])
            end
        end
        if (#retCardsArr > 0) then
            return retCardsArr;
        end
    end

    return {}
end


----将服务器数字转换成 牌的面值
function DdzRules.convertCardsNumToPointArr(cards)
    local ret = {}
    if cards == nil or #cards == 0  then
        return ret 
    end
    for i,v in ipairs(cards) do
        table.insert(ret,DdzRules.VALUE_TABLE[DdzRules.convertCardNumToPoint(v)])
    end
    return ret
end


---/////////////牌型判断//////////////

---获取单牌
function DdzRules.isDan(cards)
    local arr = DdzRules.convertCardsNumToPointArr(cards);
    if cards ~= nil and #cards == 1 then

        return {flag = true, beg = arr[1] ,len = -1}
    end
    return {flag = false, beg = -1 ,len = -1}
end

--对子
function DdzRules.isDuiZi(cards)
    local arr = DdzRules.convertCardsNumToPointArr(cards);
    if (#arr == 2) then
        if arr[1] == arr[2] then
            return { flag = true, beg = arr[1], len = -1 };
        end
    end
    return {flag = false, beg = -1 ,len = -1}
end

---3个不带
function DdzRules.isSanBuDai(cards)
    local arr = DdzRules.convertCardsNumToPointArr(cards);
    if (#arr == 3 and arr[1] == arr[2] and arr[1] == arr[3] ) then
        return { flag = true, beg = arr[1], len = -1 };
    end
    return {flag = false, beg = -1 ,len = -1}
end

---3带1
function DdzRules.isSanDaiYi(cards)
    local arr = DdzRules.convertCardsNumToPointArr(cards);
    if (#arr == 4) then
        DdzRules.SortAscenCard(arr)
        if arr[1] == arr[2] and arr[3] == arr[1] and arr[4] == arr[1]  then
             return {flag = false, beg = -1 ,len = -1}
        elseif (arr[1] == arr[1] and arr[2] == arr[3]) or (arr[2] == arr[4] and arr[2] == arr[3]) then
             return {flag = true, beg = arr[2] ,len = -1}
        end
    end
    return {flag = false, beg = -1 ,len = -1}
end
---三带二
function DdzRules.isSanDaiDui(cards)
    local arr = DdzRules.convertCardsNumToPointArr(cards);
    if (#arr == 5) then
        DdzRules.SortAscenCard(arr)
         if (arr[1] == arr[2] and arr[3] == arr[4] and arr[4] == arr[5] or arr[4] == arr[5] and arr[3] == arr[1] and arr[3] == arr[2]) then
            return {flag = true, beg = arr[3] ,len = -1}
        end
    end
    return {flag = false, beg = -1 ,len = -1}
end

---顺子
function DdzRules.isShunZi(cards)
    local arr = DdzRules.convertCardsNumToPointArr(cards);
    if #arr < 5 or #arr > 12 then
        return {flag = false, beg = -1 ,len = -1}
    end
    DdzRules.SortAscenCard(arr)
    for i = 1,#arr-1  do
        local pre = arr[i]
        local next1 = arr[i+1]
        if pre == 13 or pre == 14 or pre == 15 or next1 == 13 or next1 == 14 or next1 == 15 then
            return {flag = false, beg = -1 ,len = -1} 
        else
            if pre - next1 ~= -1 then
                return {flag = false, beg = -1 ,len = -1}
            end
        end
    end
    return {flag = true, beg = arr[1] ,len = #arr}
end

---连对
function DdzRules.isLianDui(cards)
    local arr = DdzRules.convertCardsNumToPointArr(cards);
    local num = #arr / 2;
    if #arr < 6 or #arr % 2 ~= 0 then
        return {flag = false, beg = -1 ,len = -1}
    else
        DdzRules.SortAscenCard(arr)
        for i = 1,#arr,2 do
             print("i:",arr[i],"i+1:",arr[i+1])
            if arr[i] ~= arr[i+1] or arr[i] >=13 or arr[i+1] >=14 then
                print("--------1")
                return {flag = false, beg = -1 ,len = -1}
            end

            if i + 2 < #arr then
                print("i:",arr[i],"i+2:",arr[i+2])
                if arr[i] - arr[i+2] ~= -1 then
                     print("--------2")
                    return {flag = false, beg = -1 ,len = -1} 
                end
            end
        end
    end
    return {flag = true, beg = arr[1] ,len = num}
end

---飞机不带/三顺;
function DdzRules.isFeiJiBuDai(cards)
    local arr = DdzRules.convertCardsNumToPointArr(cards);
    local num = #arr / 3;

   
    if (#arr < 6 or #arr % 3 ~= 0) then 
        return {flag = false, beg = -1 ,len = -1} 
    end
    dump(arr,"arr")
    DdzRules.SortAscenCard(arr)
    dump(arr,"arr")
    local main = {}
    for i=1,#arr,3 do
        if arr[i] == arr[i+1] and arr[i] == arr[i+2] and arr[i]<12 then
            table.insert(main,arr[i])
        else
            return {flag = false, beg = -1 ,len = -1} 
        end
    end

    for i=1,num-1 do
        if (main[i+1] - main[i]) ~= 1 then
           print("连续的三条才是飞机," ,main[i+1] .. " " .. main[i] ,"不连续");
           return {flag = false, beg = -1 ,len = -1} 
        end
    end
    dump(main,"main")
   
    return {flag = true, beg = main[1] ,len = num}
end


---//飞机带单;
function DdzRules.isFeiJiDaiDan(cards)
    print("飞机带单牌")
    local arr = DdzRules.convertCardsNumToPointArr(cards);
    local num = #arr / 4;
    if (#arr < 8) or (#arr % 4 ~= 0) then
        return {flag = false, beg = -1 ,len = -1}  
    end
    DdzRules.SortAscenCard(arr)
    local main = {}
    for i=3,#arr do
        print(arr[i],",",arr[i-1],",",arr[i],",",arr[i-2],",",i)
        if (arr[i] == arr[i - 1]) and (arr[i] == arr[i - 2]) and (arr[i] < 13) then
            ---四条只计算一次;
            local isFind = DdzRules.isContainInCards(arr[i], main);
            print("arr[i]----:",arr[i])
            if isFind == false then
                ----主值;
                print("arr[i]----2222:",arr[i])
                table.insert(main, arr[i])
            end
        end
    end
    if #main <= 1 then
        print("退出2")
        return {flag = false, beg = -1 ,len = -1}
    end

    ---把不是连续的筛选出来
    local main2 = {}
    for i=1,#main-1 do
        if (main[i] - main[i + 1]) ~= -1 then
            table.insert(main2,main[i])
            --return {flag = false, beg = -1 ,len = -1}
        end
    end


    if #main2 > 0 then
        ---选出连续的
        local main3 = {}
        for i,v in ipairs(main) do
            for _i,_v in ipairs(main2) do
                if v~=_v then
                    table.insert(main3, v)
                end
            end
        end
        if #main3 > 0 then
            main = main3
        end
        
        if #main <= 1 then
            print("退出1")
            return {flag = false, beg = -1 ,len = -1}
        end
    end
    
    dump(main, "main")
    DdzRules.SortCard(main)
    for i=1,#main do
        local isFind = true
        for j=1,num do
            local target = main[i] - j
            local isFind = DdzRules.isContainInCards(target, main);
            if isFind == false then
                break;
            end 
        end
        if isFind == true then
            local key  = main[i] - num +1
            return {flag = true, beg = key ,len = num} 
        end
    end
    return {flag = false, beg = -1 ,len = -1}  
end

---//飞机带对子;
function DdzRules.isFeiJiDaiDui(cards)
    print("飞机带对子1")
    local arr = DdzRules.convertCardsNumToPointArr(cards);
    local num = #arr / 5;
    if (#arr < 10) or (#arr % 5 ~= 0)  then
        print("飞机带对子2")
        return {flag = false, beg = -1 ,len = -1}  
    end
    DdzRules.SortAscenCard(arr)
    local main = {};
    local sub = {};
    for i=3,#arr do
        if arr[i] == arr[i-1] and arr[i] == arr[i-2] and arr[i]~=14 then
            local isFind = false
            local idx = -1;
            for j=1,#main do
                if main[j] == arr[i] then
                    isFind = true;
                    idx = j
                    break;
                end
            end
            if isFind == false then
                table.insert(main, arr[i])
            else
                table.remove(main,idx)
            end
        end
    end
    if #main <= 1 then
        print("退出2")
        return {flag = false, beg = -1 ,len = -1}
    end
    for i=1,#main-1 do
        if (main[i] - main[i + 1]) ~= -1 then
            print("退出1")
            return {flag = false, beg = -1 ,len = -1}
        end
    end
    dump(main,"main")
    for i=1,#arr do
        local isFind = DdzRules.isContainInCards(arr[i],main)
        if (isFind == false) then
            -- 提取辅值
            table.insert(sub, arr[i])
        end
    end
    DdzRules.SortAscenCard(sub)
    dump(sub,"sub")
    for i=1,#sub -1,2 do
        if (sub[i + 1] ~= sub[i]) then 
            print("飞机带对子3")
            return {flag = false, beg = -1 ,len = -1}  
        end
    end
    DdzRules.SortCard(main)
    dump(main,"main")
    for i=1,#main do
        local isFind = true
        for j=1,num do
            local target = main[i];

            isFind = DdzRules.isContainInCards(target,main)
            if isFind == false then
                break
            end
        end
        if isFind == true then
            local key  = main[i] - num +1
            print("飞机带对子5")
            return {flag = true, beg = key ,len = num} 
        end
    end
     print("飞机带对子6")
    return {flag = false, beg = -1 ,len = -1}  
end

---四带两个单牌;
function DdzRules.isSiDaiEr_Dan(cards)
    dump(cards, "四带两个单牌")
    local arr = DdzRules.convertCardsNumToPointArr(cards);
    dump(arr, "四带两个单牌")
    if #arr == 6 then
        DdzRules.SortAscenCard(arr)
        for i=1,3 do
            if arr[i] == arr[i+1] and arr[i] == arr[i+2] and arr[i] == arr[i+3] then
                return {flag = true, beg = arr[i] ,len = 1} 
            end
        end
    end
    return {flag = false, beg = -1 ,len = -1}  
end

---四带两个对子;
function DdzRules.isSiDaiEr_Dui(cards)
    print("四带两个对子")
    local arr = DdzRules.convertCardsNumToPointArr(cards);
    if (#arr == 8) then
        local main = {};
        local sub = {};
        DdzRules.SortAscenCard(arr)
        for i=1,5 do
            if arr[i] == arr[i+1] and arr[i] == arr[i+2] and arr[i] == arr[i+3] then
                table.insert(main, arr[i])
            end
        end

        if #main > 0 then
            if #main == 1 then
                for i=1,#arr do
                    ---提取赋值
                    local isFind =  DdzRules.isContainInCards(arr[i],main)
                    if isFind == false then
                        table.insert(sub, arr[i])
                    end
                end
                ---验证辅值;
                for i=1,#sub,2 do
                    if sub[i+1] ~= sub[i] then
                        return {flag = false, beg = -1 ,len = -1}  
                    end
                end
                print(" arr[1]:", arr[1]);
                dump(main,"sub")
                return {flag = true, beg = main[1] ,len = 1} 

            elseif #main == 2 then
                ---两四条
                local max = -1
                if main[1] >= main[2] then
                     max = main[1]
                else
                    max = main[2]
                end
                --var max = main[0] >= main[1] ? main[0] : main[1];
                return {flag = true, beg = max ,len = 1} 
            end
        end
    end
    return {flag = false, beg = -1 ,len = -1}  
end

---炸弹
function DdzRules.isZhaDan(cards)
    local arr = DdzRules.convertCardsNumToPointArr(cards);
    if (#arr == 4 and arr[1] == arr[2] and arr[1] == arr[3] and arr[1] == arr[4])  then
        return { flag = true, beg = arr[1] , len = 1 };
    end
    return {flag = false, beg = -1 ,len = -1}  
end
--- 王炸,一对王;
function DdzRules.isWangZha (cards)

    --local arr = DdzRules.convertCardsNumToPointArr(cards);
    if (cards~=nil and #cards == 2 ) then 
        local _isWangZha = false
        for i=1,#cards do
            if cards[i] >=52 then
                _isWangZha = true
            else
                _isWangZha = false;
                break;
            end
        end
        if _isWangZha == false then
            return {flag = false, beg = -1 ,len = -1} 
        end
        return { flag = true, beg = -1, len = -1};
    end
    return {flag = false, beg = -1 ,len = -1} 
end

----获取牌的类型
function DdzRules.getNewCardType(in_cards)
    
    local cards = DdzRules.convertCardsNumToPointArr(cards)
    local card_type = DdzRules.CT_ERROR
    local ret = {}
    if cards ~= nil then

        ---单牌
        ret = DdzRules.isDan(in_cards)
        if ret.flag ==  true then
             card_type = DdzRules.CT_SINGLE
             return { cardType = card_type, beg = ret.beg, len = ret.len };
        end

        ---对子
        ret = DdzRules.isDuiZi(in_cards)
        if ret.flag ==  true then
             card_type = DdzRules.CT_DOUBLE
             return { cardType = card_type, beg = ret.beg, len = ret.len };
        end

        ---三不带
        ret = DdzRules.isSanBuDai(in_cards)
        if ret.flag ==  true then
             card_type = DdzRules.CT_THREE
             return { cardType = card_type, beg = ret.beg, len = ret.len };
        end

        ---三带一
        ret = DdzRules.isSanDaiYi(in_cards)
        if ret.flag ==  true then
             card_type = DdzRules.CT_THREE_TAKE_ONE
             return { cardType = card_type, beg = ret.beg, len = ret.len };
        end

        ---三带二
        ret = DdzRules.isSanDaiDui(in_cards)
        if ret.flag ==  true then
             card_type = DdzRules.CT_THREE_TAKE_TWO
             return { cardType = card_type, beg = ret.beg, len = ret.len };
        end

        ---顺子
        ret = DdzRules.isShunZi(in_cards)
        if ret.flag ==  true then
             card_type = DdzRules.CT_SINGLE_LINE
             return { cardType = card_type, beg = ret.beg, len = ret.len };
        end

        ---连队
        ret = DdzRules.isLianDui(in_cards)
        if ret.flag ==  true then
             card_type = DdzRules.CT_DOUBLE_LINE
             return { cardType = card_type, beg = ret.beg, len = ret.len };
        end

        ---飞机不带
        ret = DdzRules.isFeiJiBuDai(in_cards)
        if ret.flag ==  true then
             card_type = DdzRules.CT_THREE_LINE
             return { cardType = card_type, beg = ret.beg, len = ret.len };
        end

        ---飞机带1
        ret = DdzRules.isFeiJiDaiDan(in_cards)
        print("isFeiJiDaiDui")
        if ret.flag ==  true then
             card_type = DdzRules.CT_FEIJI_ONE
             return { cardType = card_type, beg = ret.beg, len = ret.len };
        end

        ---飞机带2
        ret = DdzRules.isFeiJiDaiDui(in_cards)
        
        if ret.flag ==  true then
             card_type = DdzRules.CT_FEIJI_TWO
             return { cardType = card_type, beg = ret.beg, len = ret.len };
        end

        ---四带一
        ret = DdzRules.isSiDaiEr_Dan(in_cards)
        if ret.flag ==  true then
             card_type = DdzRules.CT_FOUR_TAKE_ONE
             return { cardType = card_type, beg = ret.beg, len = ret.len };
        end

        ---四带二
        ret = DdzRules.isSiDaiEr_Dui(in_cards)
        if ret.flag ==  true then
             card_type = DdzRules.CT_FOUR_TAKE_TWO
             return { cardType = card_type, beg = ret.beg, len = ret.len };
        end

        ---炸弹
        ret = DdzRules.isZhaDan(in_cards)
        if ret.flag ==  true then
             card_type = DdzRules.CT_BOMB_CARD
             return { cardType = card_type, beg = ret.beg, len = ret.len };
        end

        ---王炸
        ret = DdzRules.isWangZha(in_cards)
        if ret.flag ==  true then
             card_type = DdzRules.CT_MISSILE_CARD
             return { cardType = card_type, beg = ret.beg, len = ret.len };
        end
    end
    return { cardType = card_type, beg = -1, len = -1 };
end

function  DdzRules.getSitiao_Wangzha(my_cards,container)
    local special_arr = {};
    special_arr = DdzRules.getBiggerCardsArr(my_cards,container, -1, 4, true);
    
    local cards = {}
    local len = #container.danpai
    if len >= 2 then
        DdzRules.SortAscenCard(container.danpai) 
        table.insert(cards,container.danpai[#container.danpai])
        table.insert(cards,container.danpai[#container.danpai-1])
        local ret  = DdzRules.isWangZha(cards);
        if ret.flag == true then
            table.insert(special_arr,cards)
        elseif ret == false and len == 2  then
            return {}
        end
    end
    return special_arr
end


function  DdzRules.getWangzha(container) 
    local wangzha = {};
    local special_arr = {};
    local len = #container.danpai;
    if len >= 2 then
        DdzRules.SortAscenCard(container.danpai) 
        table.insert(wangzha,container.danpai[#container.danpai])
        table.insert(wangzha,container.danpai[#container.danpai-1])
        local ret = DdzRules.isWangZha(wangzha);
        if ret.flag == true then
            table.insert(special_arr,wangzha)
            return special_arr
        end
    end
    return {}
end
--/********************************************************************************************************/




return DdzRules
