local DdzRules = import(".DdzRules")
local DdzHelper = class("DdzHelper")

DdzHelper.POKER_VALUE = {
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4,
    [5] = 5,
    [6] = 6,
    [7] = 7,
    [8] = 8,
    [9] = 9,
    [10] = 10,
    ["J"] = 11,
    ["j"] = 11,
    ["Q"] = 12,
    ["q"] = 12,
    ["K"] = 13,
    ["k"] = 13,
    ["A"] = 1,
    ["a"] = 1,
    ["jj"] = 14,
    ["JJ"] = 15,
}





function DdzHelper.SearchOutCardForHelp_None(mycards, AnalyseResult)
    local value = {}



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


function DdzHelper.SearchOutCardForHelp(mycards, cards)
    -- 首先分析统计 --
    local AnalyseResult = DdzRules.AnalysebCardData(mycards)

    local value = {}

    local result = DdzRules.GetCardType(cards)

    if result.type == DdzRules.CT_MISSILE_CARD then
        -- 如果当前牌为对王，那就无解 --
        return {}
    elseif result.type == DdzRules.CT_ERROR then
        -- 查找头家出牌方式 --
        return DdzHelper.SearchOutCardForHelp_None(mycards, AnalyseResult)
    elseif result.type == DdzRules.CT_SINGLE
            or result.type == DdzRules.CT_DOUBLE
            or result.type == DdzRules.CT_THREE
    then
        for i = result.value + 1, 0xd do
            if AnalyseResult.cbValueCount[i]
                    and AnalyseResult.cbValueCount[i] > result.type - DdzRules.CT_SINGLE then
                local ele = {}
                for j = 1, result.type - DdzRules.CT_SINGLE + 1 do
                    table.insert(ele, i)
                end
                table.insert(value, ele)
            end
        end

        -- 单牌，判定大王和小王 --
        if result.type == DdzRules.CT_SINGLE then
            if result.value < 0xE and AnalyseResult.cbValueCount[0xE] > 0 then
                table.insert(value, { 0xE })
            end
            if AnalyseResult.cbValueCount[0xF] > 0 then
                table.insert(value, { 0xF })
            end
        end
    elseif result.type == DdzRules.CT_SINGLE_LINE
            or result.type == DdzRules.CT_DOUBLE_LINE
            or result.type == DdzRules.CT_THREE_LINE
    then
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
    elseif result.type == DdzRules.CT_THREE_TAKE_ONE
            or result.type == DdzRules.CT_THREE_TAKE_TWO
    then
        -- 如果是连子，就不包含2在内 --
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
    elseif result.type == DdzRules.CT_FOUR_TAKE_ONE
            or result.type == DdzRules.CT_FOUR_TAKE_TWO
    then
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

function DdzHelper.PrintCards(cards, tip)
    tip = tip or ""
    local colors = {
        --        "♠","♤","♣","♢"
        "黑桃", "红桃", "梅花", "方片"
    }
    local values = {
        "A", 2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "joker", "JOKER"
    }
    local text = tip .. ""
    for _, v in ipairs(cards or {}) do
        local color = math.floor(v / 16) + 1
        local value = DdzRules.GetCardValue(v)

        text = text .. (colors[color] or "") .. values[value] .. ","
    end
    print(text)
    return text
end

--- 对牌进行排序
--- @data 牌的数据
function DdzHelper.SortCard(data)
    table.sort(data, function(a, b)
        local c_a = DdzRules.GetCardColor(a)
        local c_b = DdzRules.GetCardColor(b)
        local v_a = DdzRules.GetCardRValue(a)
        local v_b = DdzRules.GetCardRValue(b)
        if v_a == v_b then
            return c_a > c_b
        else
            return v_a > v_b
        end
    end)
end

--- 对牌进行升序排序 
--- @data 牌的数据
function DdzHelper.SortAscenCard(data)
    table.sort(data, function(a, b)
        local c_a = DdzRules.GetCardColor(a)
        local c_b = DdzRules.GetCardColor(b)
        local v_a = DdzRules.GetCardRValue(a)
        local v_b = DdzRules.GetCardRValue(b)

        if v_a == v_b then
            return c_a > c_b
        else
            return v_a < v_b
        end
    end)
end


function DdzHelper.TestConvertCards(cards)
    local result = {}
    for _, v in ipairs(cards) do
        table.insert(result, DdzHelper.POKER_VALUE[v])
    end
    return result
end


return DdzHelper