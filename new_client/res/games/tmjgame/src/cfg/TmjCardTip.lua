local TmjCardTip = {}

TmjCardTip.CardOperation = 
{
	Chi = 1,
	Peng = 2,
	Gang = 3,
	Ting = 4,
	Hu = 5,
	Pass = 6,
	AnGang = 7,
	BuGang = 8,
	ZiMo =  9,
	GangHu = 10,
	HuaHu  = 11,
	CalculateFan = 11,
}


local jiang = 0
local function cloneTable(st)
    if st == nil then
        --todo
        return nil;
    end
    local tab = {}
    for k, v in pairs(st or {}) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = cloneTable(v)
        end
    end
    return tab
end

local function lastCount(array)
	local sum = 0;
	for i,v in pairs(array) do
		sum = sum + v;
	end;
	return sum;
end;
local function Hu(array)
	if(lastCount(array) == 0) then return 1;end;

	local index = 0;
	for i,v in pairs(array) do
		if(v ~= 0) then index = i;break;end;
	end;

	if(array[index] == 4) then
		array[index] = 0;
		if(Hu(array) == 1) then return 1;end;
		array[index] = 4;
	end;
	if(array[index] >= 3) then
		array[index] = array[index] - 3;
		if(Hu(array) == 1) then return 1;end;
		array[index] = array[index] + 3;
	end;
	if(jiang == 0 and array[index] >= 2) then
		jiang = 1;
		array[index] = array[index] - 2;
		if(Hu(array) == 1) then return 1;end;
		array[index] = array[index] + 2;
		jiang = 0;
	end;
	if(index > 9) then return 0;end;
	if(index <= 7 and array[index + 1]~=nil and array[index + 2]~=nil and array[index + 1] > 0 and array[index + 2] > 0) then
		array[index] = array[index] - 1;
		array[index + 1] = array[index + 1] - 1;
		array[index + 2] = array[index + 2] - 1;
		if(Hu(array) == 1) then return 1;end;
		array[index] = array[index] + 1;
		array[index + 1] = array[index + 1] + 1;
		array[index + 2] = array[index + 2] + 1;
	end;
	return 0;
end;

local function Ting(array)
	if(lastCount(array) < 4) then return 1;end;

	local index = 0;
	for i,v in pairs(array) do
		if(v > 0) then
			if(v == 4) then 
				array[i] = 0;
				if(Ting(array) == 1) then return 1;end;
				array[i] = 4;
			end;
			if(v >= 3) then
				array[i] = array[i] - 3;
				if(Ting(array) == 1) then return 1;end;
				array[i] = array[i] + 3;
			end;
			if(v >= 2 and jiang == 0) then
				jiang = 1;
				array[i] = array[i] - 2;
				if(Ting(array) == 1) then return 1;end;
				array[i] = array[i] + 2;
				jiang = 0;
			end;
			--if(i > 9) then return 0;end;
			if(i <= 7 and array[i+1] > 0 and array[i + 2] > 0) then
				array[i] = array[i] - 1;
				array[i+1] = array[i+1] - 1;
				array[i+2] = array[i+2] - 1;
				if(Ting(array) == 1) then return 1;end;
				array[i] = array[i] + 1;
				array[i+1] = array[i+1] + 1;
				array[i+2] = array[i+2] + 1;
			end;
		end;
	end;

	return 0;
end;

function TmjCardTip.isHu(array,value)
	local cache = {}
	for i,v in pairs(array) do
		cache[i] = v
	end
	if value then
		if cache[value] then
			cache[value] = cache[value] +1
		else
			cache[value] = 1
		end
	end
	--if(value) then cache[value] = cache[value] + 1 end
	jiang = 0
	local huTag = Hu(cache)
	return huTag == 1
end

function TmjCardTip.calculateFan(cards,hua,outTimes)
	local fan = hua
end

---[[检查能否吃，如果能，返回所有可以吃的组合，否则返回nil-]]--
function TmjCardTip.isChi(array,value)
	if(value > 9 or value < 1) then return nil end
	local s2,s1,s,b1,b2 = array[value - 2],array[value - 1],array[value],array[value + 1],array[value + 2]
	if(value == 8) then b2 = 0
	elseif(value == 9) then b1 = 0 b2 = 0
	elseif(value == 2) then s2 = 0
	elseif(value == 1) then s1 = 0 s2 = 0
	end;

	local result = {}
	if(s2 > 0 and s1 > 0) then result[#result + 1] = {value-2,value-1} end
	if(s1 > 0 and b1 > 0) then result[#result + 1] = {value-1,value+1} end
	if(b1 > 0 and b2 > 0) then result[#result + 1] = {value+1,value+2} end
	if(#result == 0) then return nil end
	return result
end

function TmjCardTip.isPeng(array,value)
	return (array[value]) > 1 and value or false
end

--这个杠是手中有3个一样的去杠别人出的牌 为明杠
function TmjCardTip.isGang(array,value)
	return (array[value]) > 2 and value or false;
end

--这是补杠，即下面已经碰了一组，再摸到一张相同的来杠
function TmjCardTip.isBuGang(extraPeng , value)
	for k , v in pairs(extraPeng) do
		--if(v[1]:getValue() == value) then
		if(v[1] == value) then
			return value
		end
	end
	return false
end

--这是暗杠 即手中本来就存在3张一样的，再摸到一张
function TmjCardTip.isAnGang(array , value)
	if((array[value]) == 3) then
		return value;
	else
		return false
	end
--[[
	for i = 1 , 16 do
		if((array[i]) == 3) then
			return i;
		end
	end--]]
	return false;
end

--[[
判断手牌是否可以报听，如果可以，返回可以打出去的牌的集合，否则返回nil
]]
function TmjCardTip.isTing(array)
	local result = {};
	local cache = {};
	for i,v in pairs(array) do
		cache[i] = v;
	end

	jiang = 0;

	--[[报听的条件：通过分解码和将后剩余3（或者2）张牌无法分解
	--]]
	if(Ting(cache) == 1) then
		local temp = {};
		local count = 0;

		for i,v in pairs(cache) do
			if(v > 0) then temp[#temp + 1] = i;end;
			count = count + v;
		end

		if(count == 2) then
			if(#temp == 1 and array[temp[1]] < 4) then result[#result + 1] = temp[1];
			elseif(#temp == 2) then
				if(array[temp[1]] < 4) then result[#result + 1] = temp[2];end;
				if(array[temp[2]] < 4) then result[#result + 1] = temp[1];end;
			end;

		elseif(count == 3) then

			local func = function(a,b)--判断a,b可否成码
				if(b - a == 2 and array[a + 1] < 4) then
					return true;
				elseif(b - a == 1) then
					if((a - 1 > 0 and array[a - 1] < 4) or 
						(b + 1 < 10 and array[b + 1] < 4)) then 
						return true;
					end;
				end;
			end;

			--3张一样的牌
			if(#temp == 1 and array[temp[1]] < 4) then result[#result + 1] = temp[1];
			--一对加一张
			elseif(#temp == 2) then
				local tindex = cache[temp[1]] == 2 and 1 or 2;
				if(array[temp[tindex]] < 4) then result[#result + 1] = temp[3 - tindex];end
				if(temp[2] < 10) then
					if(func(temp[1],temp[2])) then result[#result+1] = temp[tindex];end;
				end
			--3张单牌
			else
				if(temp[3] < 10) then
					if(func(temp[1],temp[2])) then result[#result + 1] = temp[3];end;
					if(func(temp[1],temp[3])) then result[#result + 1] = temp[2];end;
					if(func(temp[2],temp[3])) then result[#result + 1] = temp[1];end;
				elseif(temp[2] < 10) then
					if(func(temp[1],temp[2])) then result[#result + 1] = temp[3];end;
				end
			end
		end
	end

	if(result and #result == 0) then return nil;end;
	return result;
end
--[[
判断手牌是否可以报听，如果可以，返回可以打出去的牌的集合和胡牌集合，否则返回nil
]]
function TmjCardTip.isTingHu(array,value)
	--把value放到array中去
	print(value)
	array[value] = array[value] or 0
	array[value] = array[value] + 1
	--听的组合
	local tingResult = TmjCardTip.isTing(array)
	if not tingResult or not next(tingResult) then
		return nil --当前牌不能听
	end
	--能听牌了
	local huResult = {}
	for _,v in pairs(tingResult) do
		local tempArr = cloneTable(array)
		if tempArr[v]~=nil then
			tempArr[v] = tempArr[v] - 1 --这张牌打出去
			for i=1,16 do --1万到白板
				if TmjCardTip.isHu(tempArr,i) then
					huResult[v] = huResult[v] or {}
					table.insert(huResult[v],i)
				end
			end
			
		end
	end
	return huResult
end


TmjCardTip.s_cmds = 
{
	[TmjCardTip.CardOperation.Chi] 			= TmjCardTip.isChi,
	[TmjCardTip.CardOperation.Peng] 			= TmjCardTip.isPeng,
	[TmjCardTip.CardOperation.Gang] 			= TmjCardTip.isGang,
	[TmjCardTip.CardOperation.Ting] 			= TmjCardTip.isTingHu,
	[TmjCardTip.CardOperation.Hu] 			    = TmjCardTip.isHu,
	[TmjCardTip.CardOperation.AnGang]          = TmjCardTip.isAnGang,
	[TmjCardTip.CardOperation.BuGang]          = TmjCardTip.isBuGang,
	[TmjCardTip.CardOperation.CalculateFan]	= TmjCardTip.calculateFan,
}
--动作权重
TmjCardTip.operationWeight = 
{
	[TmjCardTip.CardOperation.Chi] 			= 1,
	[TmjCardTip.CardOperation.Peng] 			= 2,
	[TmjCardTip.CardOperation.Gang] 			= 3,
	[TmjCardTip.CardOperation.Ting] 			= 4,
	[TmjCardTip.CardOperation.Hu] 			    = 10,
	[TmjCardTip.CardOperation.AnGang]          = 3,
	[TmjCardTip.CardOperation.BuGang]          = 3,
		
}
return TmjCardTip