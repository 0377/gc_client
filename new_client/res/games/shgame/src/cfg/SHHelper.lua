-------------------------------------------------------------------------
-- Desc:    二人梭哈游工具集合
-- Author:  zengzx
-- Date:    2017.5.11
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local SHHelper = {}
function SHHelper.isLuaNodeValid(node)
	return(node and not tolua.isnull(node))
end
function SHHelper.removeAll(table)
	if table then
		while true do
			local k =next(table)
			if not k then break end
			table[k] = nil
		end
	end

end

--对牌数据进行排序
--牌顺序应该自动排布为 8-9-10-J-Q-K-A
--@param cards 牌集合table 单个节点包含val
function SHHelper.sortCardsInfo(cards)
	SHHelper.quickSort(cards,function (c1,c2)
		return c1.val < c2.val
	end)
end

--]]
function SHHelper.quickSort(array,compareFunc)
	SHHelper.quick(array, 1, #array, compareFunc)
end

--[[
快速排序
	array 需要排序的数字
	left  左边已经完成比较的数组下标
	right 右边已经完成比较的数组下标
	compareFunc 比较函数
--]]
function SHHelper.quick(array,left,right,compareFunc)
	if(left < right ) then
		local index = SHHelper.partion(array,left,right,compareFunc)
		SHHelper.quick(array,left,index-1,compareFunc)
		SHHelper.quick(array,index+1,right,compareFunc)
	end
end

--[[
快速排序的一趟排序
	array 需要排序的数字
	left  左边已经完成比较的数组下标
	right 右边已经完成比较的数组下标
	compareFunc 比较函数
--]]
function SHHelper.partion(array,left,right,compareFunc)
	local key = array[left] -- 哨兵  一趟排序的比较基准
	local index = left
	array[index],array[right] = array[right],array[index] -- 与最后一个元素交换
	local i = left
	while i< right do
		if not compareFunc( key,array[i]) then
			array[index],array[i] = array[i],array[index]-- 发现不符合规则 进行交换
			index = index + 1
		end
		i = i + 1
	end
	array[right],array[index] = array[index],array[right] -- 把哨兵放回
	return index
end

--手中牌的类型
SHHelper.CardType = {
	NULL = 0, --牌张数不对
	HIGH_CARD = 1, --高牌 散牌
	ONE_PAIR = 2, --一对
	TWO_PAIR = 3, --两对
	THREE = 4, --三条
	STRAIGHT = 5, --顺子
	FLUSH = 6, --同花
	THREE_PAIR = 7, --满堂红 fullhouse 三带一对
	FOUR = 8, --四条
	STRAIGHT_FLUSH = 9, --同花顺
}
--牌型动画配置
SHHelper.CardTypeAnim = {
	[SHHelper.CardType.HIGH_CARD] = "ani_03",
	[SHHelper.CardType.ONE_PAIR] = "ani_02",
	[SHHelper.CardType.TWO_PAIR] = "ani_09",
	[SHHelper.CardType.THREE] = "ani_05",
	[SHHelper.CardType.STRAIGHT] = "ani_06",
	[SHHelper.CardType.FLUSH] = "ani_07",
	[SHHelper.CardType.THREE_PAIR] = "ani_10",
	[SHHelper.CardType.FOUR] = "ani_04",
	[SHHelper.CardType.STRAIGHT_FLUSH] = "ani_08",
}
--判断是否为同花顺
function SHHelper.isStraightFlush(arr)
	if not arr then
		return false
	end
	local preCard = nil
	local flag = true
	for i,card in ipairs(arr) do
		if preCard then
			if preCard.col~=card.col then --花色不对
				flag = false
				break
			end
			if preCard.val ~=card.val - 1 then --前面的牌点数必须要是后边一张牌点数的小1
				flag = false
				break
			end
		end
		preCard = card
	end
	return flag
end
--判断是否有几张相同的牌点数
function SHHelper.isSameCount(inCount,arr)
	local count = 1
	local preCard = nil
	for i,card in ipairs(arr) do
		if preCard then
			if preCard.val == card.val then --如果上一张牌和当前牌点数一样
				count = count + 1
				if count==inCount then
					break
				end
			else
				count = 1
			end
			
		end
		preCard = card
	end
	return count == inCount
end
--是否为满堂红 三带一对
function SHHelper.isThreePair(arr)
	local countArr = {}
	for i,card in ipairs(arr) do
		if countArr[card.val] then
			countArr[card.val] = countArr[card.val] + 1
		else
			countArr[card.val] = 1
		end
	end
	if table.nums(countArr)==2 then
		local hasThree = false
		local hasPair = false
		for i,v in pairs(countArr) do
			if v==2 then
				hasPair = true
			elseif v==3 then
				hasThree = true
			end
		end
		return hasThree and hasPair
		
	end
	return false
end
--判断是否为同花
function SHHelper.isFlush(arr)
	local preCardCol = nil
	local flag = true
	for i,card in ipairs(arr) do
		if preCardCol then
			if preCardCol~=card.col then
				flag = false
				break
			end
		end
		preCardCol = card.col
	end
	return flag
end
--是否为顺子
function SHHelper.isStraight(arr)
	if not arr then
		return false
	end
	local preCardVal = nil
	local flag = true
	for i,card in ipairs(arr) do
		if preCardVal then
			if preCardVal ~=card.val - 1 then --前面的牌点数必须要是后边一张牌点数的小1
				flag = false
				break
			end
		end
		preCardVal = card.val
	end
	return flag
end
--是否为三张 带两个单牌
function SHHelper.isThree(arr)
	local countArr = {}
	for i,card in ipairs(arr) do
		if countArr[card.val] then
			countArr[card.val] = countArr[card.val] + 1
		else
			countArr[card.val] = 1
		end
	end
	
	local hasThree = false

	for i,v in pairs(countArr) do
		if v==3 then
			hasThree = true
			break
		end
	end
	return hasThree
	
end
--判断对子是否有给定的个数
function SHHelper.isPairCount(count,arr)
	local countArr = {}
	for i,card in ipairs(arr) do
		if countArr[card.val] then
			countArr[card.val] = countArr[card.val] + 1
		else
			countArr[card.val] = 1
		end
	end
	local pairCount = 0
	for i,v in pairs(countArr) do
		if v==2 then
			pairCount = pairCount +1 
		end
	end
	return pairCount == count
end

--获取牌的类型
-- 可能是 同花顺>四条>满堂红（fullhouse 3+2）>同花>顺子>三条>两对>一对>散牌
--@param arr 牌数据数组 每个单牌数据包括col 牌花色 val 牌数值
function SHHelper.getCardType(arr)
	if not arr then
		return SHHelper.CardType.NULL
	end
	SHHelper.sortCardsInfo(arr)
	--牌型判断前提是有5张牌 否则直接是空的
	if table.nums(arr)~=5 then
		return SHHelper.CardType.NULL
	end
	--先判断是否为同花顺
	local flag = SHHelper.isStraightFlush(arr)
	if flag then
		return SHHelper.CardType.STRAIGHT_FLUSH
	end
	--判断是否有四张
	flag = SHHelper.isSameCount(4,arr)
	if flag then
		return SHHelper.CardType.FOUR
	end
	--判断是否是满堂红
	flag = SHHelper.isThreePair(arr)
	if flag then
		return SHHelper.CardType.THREE_PAIR
	end
	--判断是否是同花
	flag = SHHelper.isFlush(arr)
	if flag then
		return SHHelper.CardType.FLUSH
	end
	--判断是否是顺子
	flag = SHHelper.isStraight(arr)
	if flag then
		return SHHelper.CardType.STRAIGHT
	end
	--判断是否是三张
	flag = SHHelper.isSameCount(3,arr)
	if flag then
		return SHHelper.CardType.THREE
	end
	--判断是否是两对
	flag = SHHelper.isPairCount(2,arr)
	if flag then
		return SHHelper.CardType.TWO_PAIR
	end
	--判断是否是一对
	flag = SHHelper.isPairCount(1,arr)
	if flag then
		return SHHelper.CardType.ONE_PAIR
	end
	--除此之外就是高牌了
	return SHHelper.CardType.HIGH_CARD
end


return SHHelper