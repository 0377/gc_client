-------------------------------------------------------------------------
-- Desc:    二人麻将游工具集合
-- Author:  zengzx
-- Date:    2017.4.10
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local TmjHelper = {}
function TmjHelper.isLuaNodeValid(node)
	return(node and not tolua.isnull(node))
end
function TmjHelper.removeAll(table)
	if table then
		while true do
			local k =next(table)
			if not k then break end
			table[k] = nil
		end
	end

end
--对牌进行排序
--牌顺序应该自动排布为1 - 9万 - 东 - 西 - 南 - 北 - 中 - 发 - 白 - 春 - 夏 - 秋 - 冬 - 梅 - 兰 - 竹 - 菊
--@param cards 牌集合table 单个节点包含val 牌值 [TmjConfig.Card.R_1,TmjConfig.Card.R_Chry]
function TmjHelper.sortCards(cards)
	TmjHelper.quickSort(cards,function (c1,c2)
		return c1.info.val < c2.info.val
	end)
end
--对牌数据进行排序
--牌顺序应该自动排布为1 - 9万 - 东 - 西 - 南 - 北 - 中 - 发 - 白 - 春 - 夏 - 秋 - 冬 - 梅 - 兰 - 竹 - 菊
--@param cards 牌集合table 单个节点包含val 牌值 [TmjConfig.Card.R_1,TmjConfig.Card.R_Chry]
function TmjHelper.sortCardsInfo(cards)
	TmjHelper.quickSort(cards,function (c1,c2)
		return c1.val < c2.val
	end)
end

--]]
function TmjHelper.quickSort(array,compareFunc)
	TmjHelper.quick(array, 1, #array, compareFunc)
end

--[[
快速排序
	array 需要排序的数字
	left  左边已经完成比较的数组下标
	right 右边已经完成比较的数组下标
	compareFunc 比较函数
--]]
function TmjHelper.quick(array,left,right,compareFunc)
	if(left < right ) then
		local index = TmjHelper.partion(array,left,right,compareFunc)
		TmjHelper.quick(array,left,index-1,compareFunc)
		TmjHelper.quick(array,index+1,right,compareFunc)
	end
end

--[[
快速排序的一趟排序
	array 需要排序的数字
	left  左边已经完成比较的数组下标
	right 右边已经完成比较的数组下标
	compareFunc 比较函数
--]]
function TmjHelper.partion(array,left,right,compareFunc)
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

return TmjHelper