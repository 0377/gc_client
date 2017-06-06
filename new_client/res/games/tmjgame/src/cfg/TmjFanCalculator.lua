-------------------------------------------------------------------------
-- Desc:    二人麻将番型计算
-- Author:  zengzx
-- Date:    2017.6.6
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local TmjFanCalculator = {}
TmjFanCalculator.GANG_TYPE = {
	AN_GANG = 1,
	MING_GANG = 2,
	BA_GANG = 3
}
TmjFanCalculator.FAN_UNIQUE_MAP	 = {
	--大四喜----圈风刻,门风刻,大三风,小三风,碰碰胡
	DA_SI_XI 			= {QUAN_FENG_KE,MEN_FENG_KE,DA_SAN_FENG,XIAO_SAN_FENG,PENG_PENG_HU},
	--大三元----双箭刻,箭刻
	DA_SAN_YUAN			= {SHUANG_JIAN_KE,JIAN_KE},	
	--九莲宝灯----清一色		
	JIU_LIAN_BAO_DENG	= {QING_YI_SE},	
	--18罗汉----三杠，双明杠，明杠，单钓将
	LUO_HAN_18			= {SAN_GANG,SHUANG_MING_GANG,MING_GANG,DAN_DIAO_JIANG},	
	--连7对----清一色、单钓，门前清，自摸。
	LIAN_QI_DUI			= {QING_YI_SE,DAN_DIAO_JIANG,MEN_QING,ZI_MO},	
	--大七星--全带幺，单钓将，门前清，自摸，字一色
	DA_QI_XIN			= {QUAN_DAI_YAO,DAN_DIAO_JIANG,MING_GANG,ZI_MO,ZI_YI_SE},	
	--天胡--单钓将，不求人，自摸。
	TIAN_HU				= {DAN_DIAO_JIANG,BU_QIU_REN,ZI_MO},
	--小四喜 不计大三风，小三风，圈风刻，门风刻。
	XIAO_SI_XI			= {DA_SAN_FENG,XIAO_SAN_FENG,QUAN_FENG_KE,MEN_FENG_KE},
	--小三元	不计双箭刻，箭刻
	XIAO_SAN_YUAN		= {SHUANG_JIAN_KE,JIAN_KE},
	--字一色 不计碰碰和。
	ZI_YI_SE			= {PENG_PENG_HU},
	--四暗刻	不计三暗刻，双暗刻，门前清，碰碰和，自摸
	SI_AN_KE 			= {SAN_AN_KE,SHUANG_AN_KE,MING_GANG,PENG_PENG_HU,ZI_MO},
	--一色双龙会 不计平和，清一色，一般高
	SHUANG_LONG_HUI		= {PING_HU,QING_YI_SE,YI_BAN_GAO},
	--一色四同顺 不计一色三节高、一色三同顺，四归一，一般高
	YI_SE_SI_TONG_SHUN	= {YI_SE_SAN_JIE_GAO,YI_SE_SAN_TONG_SHUN,SI_GUI_YI,YI_BAN_GAO},
	--一色四节高 不计一色三同顺，一色三节高，碰碰和，一般高
	YI_SE_SI_JIE_GAO	= {YI_SE_SAN_TONG_SHUN,YI_SE_SAN_JIE_GAO,PENG_PENG_HU,YI_BAN_GAO},
	--三元七对子 不计门前清，单钓将，自摸。
	SAN_YUAN_QI_DUI		= {MEN_QING,DAN_DIAO_JIANG,ZI_MO},
	--四喜七对子 不计 门前清，单调将，自摸。
	SI_XI_QI_DUI		= {MEN_QING,DAN_DIAO_JIANG,ZI_MO},
	--一色四步高 不计三步高，连六，老少副
	YI_SE_SI_BU_GAO		= {YI_SE_SAN_BU_GAO,LIAN_LIU,LAO_SHAO_FU},
	--三杠  不计双明刚，明杠
	SAN_GANG			= {SHUANG_MING_GANG,MING_GANG},
	--混幺九 不计碰碰和。全带幺。
	HUN_YAO_JIU			= {PENG_PENG_HU,QUAN_DAI_YAO},
	--七对 不计不求人，门前清，单钓将，自摸。
	NORMAL_QI_DUI		= {BU_QIU_REN,MEN_QING,DAN_DIAO_JIANG,ZI_MO},
	--一色三节高 不计一色三同顺，一般高。
	YI_SE_SAN_JIE_GAO	= {YI_SE_SAN_TONG_SHUN,YI_BAN_GAO},
	--一色三同顺 不计一色三节高，一般高。
	YI_SE_SAN_TONG_SHUN	= {YI_SE_SAN_JIE_GAO,YI_BAN_GAO},
	--四字刻 	不计碰碰胡。
	SI_ZI_KE			= {PENG_PENG_HU},
	--大三风 	不计小三风
	DA_SAN_FENG			= {XIAO_SAN_FENG},
	--清龙 不计连六，老少副。
	QING_LONG			= {LIAN_LIU,LAO_SHAO_FU},
	--三暗刻 不计双暗刻
	SAN_AN_KE			= {SHUANG_AN_KE},
	--妙手回春 不计自摸
	MIAO_SHOU_HUI_CHUN	= {ZI_MO},
	--杠上开花 	不计自摸。
	GANG_SHANG_HUA		= {ZI_MO},
	--抢杠胡 不计胡绝张
	QIANG_GANG_HU		= {HU_JUE_ZHANG},
	--全求人 不计单钓
	QUAN_QIU_REN		= {DAN_DIAO_JIANG},
	--双暗杠 	不计双暗刻，暗杠。
	SHUANG_AN_GANG		= {SHUANG_AN_KE,AN_GANG},
	--双箭刻 	不计双暗刻，暗杠
	SHUANG_JIAN_KE		= {SHUANG_AN_KE,AN_GANG},
} 
TmjFanCalculator.CARD_HU_TYPE_INFO = {
	WEI_HU					= {name = "WEI_HU",fan = 0},				--未胡
------------------------------叠加-------------------------------------------------
	TIAN_HU					= {name = "TIAN_HU",fan = 88},				--天胡
	DI_HU					= {name = "DI_HU",fan = 88},				--地胡
	REN_HU					= {name = "REN_HU",fan = 64},				--人胡
	TIAN_TING				= {name = "TIAN_TING",fan = 32},			--天听
	QING_YI_SE				= {name = "QING_YI_SE",fan = 16},			--清一色
	QUAN_HUA				= {name = "QUAN_HUA",fan = 16},				--全花
	ZI_YI_SE				= {name = "ZI_YI_SE",fan = 64},				--字一色
	MIAO_SHOU_HUI_CHUN		= {name = "MIAO_SHOU_HUI_CHUN",fan = 8},	--妙手回春
	HAI_DI_LAO_YUE			= {name = "HAI_DI_LAO_YUE",fan = 8},		--海底捞月
	GANG_SHANG_HUA			= {name = "GANG_SHANG_HUA",fan = 8},		--杠上开花
	QUAN_QIU_REN			= {name = "QUAN_QIU_REN",fan = 8},			--全求人
	SHUANG_AN_GANG			= {name = "SHUANG_AN_GANG",fan = 6},		--双暗杠
	SHUANG_JIAN_KE			= {name = "SHUANG_JIAN_KE",fan = 6},		--双箭刻
	HUN_YI_SE				= {name = "HUN_YI_SE",fan = 6},				--混一色
	BU_QIU_REN				= {name = "BU_QIU_REN",fan = 4},			--不求人
	SHUANG_MING_GANG		= {name = "SHUANG_MING_GANG",fan = 4},		--双明杠
	HU_JUE_ZHANG			= {name = "HU_JUE_ZHANG",fan = 4},			--胡绝张
	JIAN_KE					= {name = "JIAN_KE",fan = 2},				--箭刻
	MEN_QING				= {name = "MEN_QING",fan = 2},				--门前清
	ZI_AN_GANG				= {name = "ZI_AN_GANG",fan = 2},			--自暗杠
	DUAN_YAO				= {name = "DUAN_YAO",fan = 2},				--断幺
	SI_GUI_YI				= {name = "SI_GUI_YI",fan = 2},				--四归一
	PING_HU					= {name = "PING_HU",fan = 2},				--平胡
	SHUANG_AN_KE			= {name = "SHUANG_AN_KE",fan = 2},			--双暗刻
	SAN_AN_KE				= {name = "SAN_AN_KE",fan = 16},			--三暗刻
	SI_AN_KE				= {name = "SI_AN_KE",fan = 64},				--四暗刻
	BAO_TING				= {name = "BAO_TING",fan = 2},				--报听
	MEN_FENG_KE				= {name = "MEN_FENG_KE",fan = 2},			--门风刻
	QUAN_FENG_KE			= {name = "QUAN_FENG_KE",fan = 2},			--圈风刻
	ZI_MO					= {name = "ZI_MO",fan = 1},					--自摸
	DAN_DIAO_JIANG			= {name = "DAN_DIAO_JIANG",fan = 1},		--单钓将
	YI_BAN_GAO	 			= {name = "YI_BAN_GAO",fan = 1},			--一般高
	LAO_SHAO_FU	 			= {name = "LAO_SHAO_FU",fan = 1},			--老少副
	LIAN_LIU	 			= {name = "LIAN_LIU",fan = 1},				--连六
	YAO_JIU_KE	 			= {name = "YAO_JIU_KE",fan = 1},			--幺九刻
	MING_GANG	 			= {name = "MING_GANG",fan = 1},				--明杠
	DA_SAN_FENG				= {name = "DA_SAN_FENG",fan = 24},			--大三风
	XIAO_SAN_FENG			= {name = "XIAO_SAN_FENG",fan = 24},		--小三风
	PENG_PENG_HU			= {name = "PENG_PENG_HU",fan = 6},			--碰碰胡
	SAN_GANG				= {name = "SAN_GANG",fan = 32},				--三杠
	QUAN_DAI_YAO			= {name = "QUAN_DAI_YAO",fan = 4},			--全带幺
	QIANG_GANG_HU			= {name = "QIANG_GANG_HU",fan = 8},			--抢杠胡
	HUA_PAI					= {name = "HUA_PAI",fan = 1},				--花牌
-----------------------------------------------------------------------------------
	DA_QI_XIN			= {name = "DA_QI_XIN",fan = 88},			--大七星
	LIAN_QI_DUI 		= {name = "LIAN_QI_DUI",fan = 88},			--连七对
	SAN_YUAN_QI_DUI		= {name = "SAN_YUAN_QI_DUI",fan = 48},		--三元七对子
	SI_XI_QI_DUI		= {name = "SI_XI_QI_DUI",fan = 48},			--四喜七对子
	NORMAL_QI_DUI 		= {name = "NORMAL_QI_DUI",fan = 24},		--普通七对
---------------------
	DA_YU_WU 			= {name = "DA_YU_WU",fan = 88},				--大于五
	XIAO_YU_WU 			= {name = "XIAO_YU_WU",fan = 88},			--小于五
	DA_SI_XI			= {name = "DA_SI_XI",fan = 88},				--大四喜
	XIAO_SI_XI			= {name = "XIAO_SI_XI",fan = 64},			--小四喜
	DA_SAN_YUAN			= {name = "DA_SAN_YUAN",fan = 88},			--大三元
	XIAO_SAN_YUAN		= {name = "XIAO_SAN_YUAN",fan = 64},		--小三元
	JIU_LIAN_BAO_DENG	= {name = "JIU_LIAN_BAO_DENG",fan = 88},	--九莲宝灯
	LUO_HAN_18			= {name = "LUO_HAN_18",fan = 88},			--18罗汉
	SHUANG_LONG_HUI		= {name = "SHUANG_LONG_HUI",fan = 64},		--一色双龙会
	YI_SE_SI_TONG_SHUN	= {name = "YI_SE_SI_TONG_SHUN",fan = 48},	--一色四同顺
	YI_SE_SI_JIE_GAO	= {name = "YI_SE_SI_JIE_GAO",fan = 48},		--一色四节高
	YI_SE_SI_BU_GAO		= {name = "YI_SE_SI_BU_GAO",fan = 32},		--一色四步高
	HUN_YAO_JIU			= {name = "HUN_YAO_JIU",fan = 32},			--混幺九
	YI_SE_SAN_JIE_GAO	= {name = "YI_SE_SAN_JIE_GAO",fan = 24},	--一色三节高
	YI_SE_SAN_TONG_SHUN	= {name = "YI_SE_SAN_TONG_SHUN",fan = 24},	--一色三同顺
	SI_ZI_KE			= {name = "SI_ZI_KE",fan = 24},				--四字刻
	QING_LONG			= {name = "QING_LONG",fan = 16},			--清龙
	YI_SE_SAN_BU_GAO	= {name = "YI_SE_SAN_BU_GAO",fan = 16},		--一色三步高
}
local HU_INFO = TmjFanCalculator.CARD_HU_TYPE_INFO
local FAN_UNIQUE_MAP = TmjFanCalculator.FAN_UNIQUE_MAP
function TmjFanCalculator.lastCount(array)
	local sum = 0;
	for i,v in ipairs(array) do
		sum = sum + v;
	end;
	return sum;
end;

local jiang = 0;
local g_jiang_tile = 0
local g_split_list = {}
function TmjFanCalculator.Hu(array)
	if(TmjFanCalculator.lastCount(array) == 0) then return 1;end;

	local index = 0;
	for i,v in ipairs(array) do
		if(v ~= 0) then index = i;break;end;
	end;

	if(array[index] == 4) then
		array[index] = 0;
		g_split_list[#g_split_list + 1] = {index,index,index,index}
		if(TmjFanCalculator.Hu(array) == 1) then return 1;end;
		array[index] = 4;
		g_split_list[#g_split_list] = nil
	end;
	if(array[index] >= 3) then
		array[index] = array[index] - 3;
		g_split_list[#g_split_list + 1] = {index,index,index}
		if(TmjFanCalculator.Hu(array) == 1) then return 1;end;
		array[index] = array[index] + 3;
		g_split_list[#g_split_list] = nil
	end;
	if(jiang == 0 and array[index] >= 2) then
		jiang = 1;
		g_jiang_tile = index;
		array[index] = array[index] - 2;
		g_split_list[#g_split_list + 1] = {index,index}
		if(TmjFanCalculator.Hu(array) == 1) then return 1;end;
		array[index] = array[index] + 2;
		g_split_list[#g_split_list] = nil
		jiang = 0;
		g_jiang_tile = 0;
	end;
	if(index > 9) then return 0;end;
	if(index <= 7 and array[index + 1] > 0 and array[index + 2] > 0) then
		array[index] = array[index] - 1;
		array[index + 1] = array[index + 1] - 1;
		array[index + 2] = array[index + 2] - 1;
		g_split_list[#g_split_list + 1] = {index,index + 1,index + 2}
		if(TmjFanCalculator.Hu(array) == 1) then return 1;end;
		array[index] = array[index] + 1;
		array[index + 1] = array[index + 1] + 1;
		array[index + 2] = array[index + 2] + 1;
		g_split_list[#g_split_list] = nil
	end;
	return 0;
end;
function TmjFanCalculator.arrayClone(arraySrc)
	local arrayDes = {}
	for k,v in pairs(arraySrc) do
		arrayDes[k] = v
	end
	return arrayDes
end
--获取番数
function TmjFanCalculator.get_fan_table_res(base_fan_table)
	local res = {describe = "",fan = 0}
	local del_list = {}
	for k,v in ipairs(base_fan_table) do
		local tmp_map = FAN_UNIQUE_MAP[v.name]
		if tmp_map then
			for k1,v1 in ipairs(tmp_map) do
				for k2,v2 in ipairs(base_fan_table) do
					if v1 == v2.name then
						table.insert(del_list,k2)
					end
				end
			end
		end
	end

	for k,v in ipairs(del_list) do
		base_fan_table[v] = nil				
	end
	for k,v in ipairs(base_fan_table) do
		res.describe = res.describe .. v.name .. ","
		res.fan = res.fan + v.fan	
	end

	return res
end
function TmjFanCalculator.is_hu(pai,inPai)
	local cache = {0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,}
	for k,v in ipairs(pai.shou_pai) do
		cache[v] = cache[v] + 1
	end
	if inPai then cache[inPai] = cache[inPai] + 1 end
	
	--一万到九万， 东-南-西-北  -中-发-白-   春-夏-秋-冬-梅-兰-竹-菊--
	--1-9		    10-13		14-16		20-27
	jiang = 0
	g_jiang_tile = 0
	g_split_list = {}
	local hu = (TmjFanCalculator.Hu(cache) == 1 and g_jiang_tile ~= 0)
	if hu then
		local qing_yi_se = true
		local zi_yi_se = true
		local shuang_jian_ke = false  --双箭刻  两个由中、发、白组成的刻子
		local hun_yi_se = false  --牌型中有万、字、风三种牌
		local jian_ke = false --箭刻
		local men_qing = false --门前清
		local ping_hu = false --平胡
		local lao_shao_fu = false --老少副
		local si_an_ke = false --4暗刻
		local san_an_ke = false --3暗刻
		local shuang_an_ke = false --2暗刻
		local lian_liu = false	--连六
		local yao_jiu_ke = 0 --幺九刻
		local ming_gang = 0 --明杠
		local da_san_feng = false	--大三风
		local xiao_san_feng = false	--小三风
		local san_gang = false --三杠
		local quan_dai_yao = true --全带幺

		for k,v in ipairs(pai.ming_pai) do
			g_split_list[#g_split_list + 1] = TmjFanCalculator.arrayClone(v)
		end
		local four_tong_list = {}
		local three_tong_list = {}
		local shun_zi_list = {}
		for k,v in ipairs(g_split_list) do
			if #v > 3 then
				four_tong_list[#four_tong_list + 1] = v
			elseif v[1] == v[2] and v[1] == v[3] then
				three_tong_list[#three_tong_list + 1] = v
			elseif #v > 2 then
				shun_zi_list[#shun_zi_list + 1] = v
			end
			for k1,v1 in ipairs(v) do
				if v1 > 9 then qing_yi_se = false end
				if v1 < 10 or v1 > 16 then zi_yi_se = false end
			end
		end
		if g_jiang_tile > 9 then qing_yi_se = false end
		if g_jiang_tile < 10 or g_jiang_tile > 16 then zi_yi_se = false end
		local jian_ke_count = 0
		for k,v in ipairs(three_tong_list) do
			if v[1] >= 14 and v[1] <= 16 then
				jian_ke_count = jian_ke_count + 1
			end
		end
		if jian_ke_count == 2 then shuang_jian_ke = true end
		if jian_ke_count > 0 then jian_ke = true end

		local has_wan = false--混一色 牌型中有万、字、风三种牌
		local has_zi = false
		local has_feng = false
		for k,v in ipairs(pai.ming_pai) do
			if v[1] <= 9 then
				has_wan = true
			elseif v[1] <= 13 then
				has_zi = true
			elseif v[1] <= 16 then
				has_zi = true
			end
		end
		for k,v in ipairs(pai.shou_pai) do
			if v <= 9 then
				has_wan = true
			elseif v <= 13 then
				has_zi = true
			elseif v <= 16 then
				has_zi = true
			end
		end
		if has_wan and has_zi and has_feng then
			hun_yi_se = true
		end

		if #pai.ming_pai == 0 then
			men_qing = true
		end
		if #shun_zi_list == 4 and #four_tong_list == 0 and #three_tong_list == 0 and g_jiang_tile <= 9 then
			ping_hu = true
		end

		local shao_fu = 0
		local lao_fu = 0
		for k,v in ipairs(shun_zi_list) do
			if v[1] == 1 and v[2] == 2 and v[3] == 3 then
				shao_fu = shao_fu + 1
			end
			if v[1] == 7 and v[2] == 8 and v[3] == 9 then
				lao_fu = lao_fu + 1
			end
		end
		if shao_fu >= 1 and lao_fu >= 1 then
			lao_shao_fu = true
		end
		-- 暗刻 --
		local cache_an_ke = {0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,}
		local four_or_three_count = 0
		for k,v in ipairs(pai.shou_pai) do
			cache_an_ke[v] = cache_an_ke[v] + 1
		end
		for k,v in ipairs(cache_an_ke) do
			if v >= 3 then
				four_or_three_count = four_or_three_count + 1
			end
			if four_or_three_count >= 4 then
				si_an_ke = true --4暗刻
			elseif four_or_three_count >= 3 then
				san_an_ke = true --3暗刻
			elseif four_or_three_count >= 2 then
				shuang_an_ke = true --2暗刻
			end
		end
		-- 暗刻 --

		local cache_all_tile = {0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,}
		for k,v in ipairs(pai.shou_pai) do
			cache_all_tile[v] = 1
		end
		for k,v in ipairs(pai.ming_pai) do
			for k1,v1 in ipairs(v) do
				if k<5 then
					cache_all_tile[v1] = 1
				end
			end
		end
		cache_all_tile[g_jiang_tile] = 1
		if (cache_all_tile[1] + cache_all_tile[2] + cache_all_tile[3] + cache_all_tile[4] + cache_all_tile[5] + cache_all_tile[6] == 6) or
		(cache_all_tile[2] + cache_all_tile[3] + cache_all_tile[4] + cache_all_tile[5] + cache_all_tile[6] + cache_all_tile[7] == 6) or
		(cache_all_tile[3] + cache_all_tile[4] + cache_all_tile[5] + cache_all_tile[6] + cache_all_tile[7] + cache_all_tile[8] == 6) or
		(cache_all_tile[4] + cache_all_tile[5] + cache_all_tile[6] + cache_all_tile[7] + cache_all_tile[8] + cache_all_tile[9] == 6) then
			lian_liu = true	--连六
		end

		for k,v in pairs(three_tong_list) do
			if v[1] == 1 and v[1] == 9 and (v[1] <= 16 and v[1] >= 14) then
				yao_jiu_ke = yao_jiu_ke + 1
			end
		end
		for k,v in pairs(four_tong_list) do
			if v[1] == 1 and v[1] == 9 and (v[1] <= 16 and v[1] >= 14) then
				yao_jiu_ke = yao_jiu_ke + 1
			end
			if v[5] == TmjFanCalculator.GANG_TYPE.MING_GANG and v[5] == TmjFanCalculator.GANG_TYPE.BA_GANG then
				ming_gang = ming_gang + 1
			end
		end

		-- 大三风 --
		local da_feng_ke_count = 0
		for k,v in ipairs(three_tong_list) do
			if v[1] >= 10 and v[1] <= 13 then
				da_feng_ke_count = da_feng_ke_count + 1
			end
		end
		for k,v in ipairs(four_tong_list) do
			if v[1] >= 10 and v[1] <= 13 then
				da_feng_ke_count = da_feng_ke_count + 1
			end
		end
		if da_feng_ke_count >= 3 then
			da_san_feng = true	--大三风
		end
		-- 大三风 --
		-- 小三风 --
		local xiao_feng_ke_count = 0
		for k,v in ipairs(three_tong_list) do
			if v[1] >= 10 and v[1] <= 13 then
				xiao_feng_ke_count = xiao_feng_ke_count + 1
			end
		end
		for k,v in ipairs(four_tong_list) do
			if v[1] >= 10 and v[1] <= 13 then
				xiao_feng_ke_count = xiao_feng_ke_count + 1
			end
		end
		if g_jiang_tile >= 10 and g_jiang_tile <= 13 then
			xiao_feng_ke_count = xiao_feng_ke_count + 1
		end
		if xiao_feng_ke_count >= 3 and not da_san_feng then
			xiao_san_feng = true	--小三风
		end
		-- 小三风 --
		-- 三杠 -- 
		if #four_tong_list == 3 then
			san_gang = true
		end
		-- 三杠 --
		-- 全带幺 -- 
		if g_jiang_tile ~= 1 and g_jiang_tile ~= 9 then
			quan_dai_yao = false
		end
		for k,v in ipairs(three_tong_list) do
			if v[1] ~= 1 and v[1] ~= 9 then
				quan_dai_yao = false
			end
		end
		for k,v in ipairs(four_tong_list) do
			if v[1] ~= 1 and v[1] ~= 9 then
				quan_dai_yao = false
			end
		end
		for k,v in ipairs(shun_zi_list) do
			if (v[1] ~= 1 and v[1] ~= 9) and (v[2] ~= 1 and v[2] ~= 9) and (v[3] ~= 1 and v[3] ~= 9) then
				quan_dai_yao = false
			end
		end
		-- 全带幺 --

		local base_fan_table = {}
		if qing_yi_se then table.insert( base_fan_table,HU_INFO.QING_YI_SE) end
		if zi_yi_se then table.insert( base_fan_table,HU_INFO.ZI_YI_SE) end
		if shuang_jian_ke then table.insert( base_fan_table,HU_INFO.SHUANG_JIAN_KE) end
		if hun_yi_se then table.insert( base_fan_table,HU_INFO.HUN_YI_SE) end
		if jian_ke then table.insert( base_fan_table,HU_INFO.JIAN_KE) end
		if men_qing then table.insert( base_fan_table,HU_INFO.MEN_QING) end
		if ping_hu then table.insert( base_fan_table,HU_INFO.PING_HU) end
		if lao_shao_fu then table.insert( base_fan_table,HU_INFO.LAO_SHAO_FU) end
		if si_an_ke then table.insert( base_fan_table,HU_INFO.SI_AN_KE) end
		if san_an_ke then table.insert( base_fan_table,HU_INFO.SAN_AN_KE) end
		if shuang_an_ke then table.insert( base_fan_table,HU_INFO.SHUANG_AN_KE) end
		if lian_liu then table.insert( base_fan_table,HU_INFO.LIAN_LIU) end
		if da_san_feng then table.insert( base_fan_table,HU_INFO.DA_SAN_FENG) end
		if xiao_san_feng then table.insert( base_fan_table,HU_INFO.xiao_san_feng) end
		if san_gang then table.insert( base_fan_table,HU_INFO.SAN_GANG) end
		if quan_dai_yao then table.insert( base_fan_table,HU_INFO.QUAN_DAI_YAO) end
		if ping_hu then table.insert( base_fan_table,HU_INFO.PING_HU) end
		for i=1,yao_jiu_ke do
			table.insert( base_fan_table,HU_INFO.YAO_JIU_KE)
		end
		for i=1,ming_gang do
			table.insert( base_fan_table,HU_INFO.MING_GANG)
		end

		----------特殊牌型---------
		if cache[10] == 2 and cache[11] == 2 and cache[12] == 2 and cache[13] == 2 and cache[14] == 2 
		and cache[15] == 2 and cache[16] == 2
		then
			table.insert(base_fan_table,HU_INFO.DA_QI_XIN)
			return base_fan_table-- 大七星 --
		end

		local normarl_7_dui = true
		local dui_count = 0
		for k,v in ipairs(cache) do
			if v ~= 0 and k < 4
			and cache[k+0] == 2 and cache[k+1] == 2 and cache[k+2] == 2 and cache[k+3] == 2
			and cache[k+4] == 2 and cache[k+5] == 2 and cache[k+6] == 2
			then
				table.insert(base_fan_table,HU_INFO.LIAN_QI_DUI)
				return base_fan_table 
			end

			if v % 2 == 0 then
				dui_count = dui_count + v/2 
			end
			if v ~= 0 and v ~= 2 then
				normarl_7_dui = false
			end
		end
		
		if normarl_7_dui and dui_count == 7 then
			if cache[14] == 2 and cache[15] == 2 and cache[16] == 2 then
				table.insert(base_fan_table,HU_INFO.SAN_YUAN_QI_DUI)
				return base_fan_table-- 三元七对子 --
			end
			if cache[10] == 2 and cache[11] == 2 and cache[12] == 2 and cache[13] == 2 then
				table.insert(base_fan_table,HU_INFO.SI_XI_QI_DUI)
				return base_fan_table-- 四喜七对子 --
			end
			table.insert(base_fan_table,HU_INFO.NORMAL_QI_DUI)
			return base_fan_table-- 七对 --
		end
		---------------------------

	---------------------------------------------------------------------------------------
		-- 大小于五 --
		local da_yu_wu = true;
		local xiao_yu_wu = true;
		for k,v in pairs(cache_all_tile) do
			if v > 0 and k > 4 then
				xiao_yu_wu = false
			end
			if v > 0 and (k < 6 or k > 9) then
				da_yu_wu = false
			end
		end
		if da_yu_wu then
			table.insert(base_fan_table,HU_INFO.DA_YU_WU)
			return base_fan_table
		end
		if xiao_yu_wu then
			table.insert(base_fan_table,HU_INFO.XIAO_YU_WU)
			return base_fan_table
		end
		-- 大小于五 --
		-- 九莲宝灯 --
		if qing_yi_se then
			local cache_bao_deng = {0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,}
			for k,v in ipairs(g_split_list) do
				for k1,v1 in ipairs(v) do
					cache_bao_deng[v1] = cache_bao_deng[v1] + 1
				end
			end
			if (cache_bao_deng[1] == 3 or cache_bao_deng[1] == 4) and cache_bao_deng[2] == 1 and cache_bao_deng[3] == 1
			and cache_bao_deng[4] == 1 and cache_bao_deng[5] == 1 and cache_bao_deng[6] == 1 and cache_bao_deng[7] == 1
			and cache_bao_deng[8] == 1 and (cache_bao_deng[9] == 3 or cache_bao_deng[9] == 4) then
				table.insert(base_fan_table,HU_INFO.JIU_LIAN_BAO_DENG)
				return base_fan_table-- 九莲宝灯 --
			end
		end
		-- 九莲宝灯 --
		-- 18罗汉 --
		if #four_tong_list == 4 then
			table.insert(base_fan_table,HU_INFO.LUO_HAN_18)
			return base_fan_table-- 18罗汉 --
		end
		-- 18罗汉 --
		-- 一色双龙会 --
		if qing_yi_se and g_jiang_tile == 5 then
			local shao_fu = 0
			local lao_fu = 0
			for k,v in ipairs(shun_zi_list) do
				if v[1] == 1 and v[2] == 2 and v[3] == 3 then
					shao_fu = shao_fu + 1
				end
				if v[1] == 7 and v[2] == 8 and v[3] == 9 then
					lao_fu = lao_fu + 1
				end
			end
			if shao_fu == 2 and lao_fu == 2 then
				table.insert(base_fan_table,HU_INFO.SHUANG_LONG_HUI)
				return base_fan_table
			end
		end
		-- 一色双龙会 --
		-- 四喜--
		local si_xi_four_count = 0
		for k,v in ipairs(four_tong_list) do
			if v[1] >= 10 and v[1] <= 13 then
				si_xi_four_count = si_xi_four_count + 1
			end
		end
		local si_xi_three_count = 0
		for k,v in ipairs(three_tong_list) do
			if v[1] >= 10 and v[1] <= 13 then
				si_xi_three_count = si_xi_three_count + 1
			end
		end
		if (si_xi_three_count + si_xi_four_count) == 4 then
			table.insert(base_fan_table,HU_INFO.DA_SI_XI)
			return base_fan_table
		end
		if si_xi_three_count == 3 and (g_jiang_tile >= 10 and g_jiang_tile <= 13) then
			table.insert(base_fan_table,HU_INFO.XIAO_SI_XI)
			return base_fan_table
		end
		-- 四喜--
		-- 三元 --
		local san_yuan_three_count = 0
		for k,v in ipairs(three_tong_list) do
			if v[1] >= 14 and v[1] <= 16 then
				san_yuan_three_count = san_yuan_three_count + 1
			end
		end
		if san_yuan_three_count == 3 then
			table.insert(base_fan_table,HU_INFO.DA_SAN_YUAN)
			return base_fan_table
		end
		if san_yuan_three_count == 2 and (g_jiang_tile >= 14 and g_jiang_tile <= 16) then
			table.insert(base_fan_table,HU_INFO.XIAO_SAN_YUAN)
			return base_fan_table
		end
		-- 三元 --
		-- 一色四同顺 --
		if qing_yi_se and #shun_zi_list == 4 then
			local shun_zi_v1 = 0
			local yi_se_si_tong = true
			for k,v in ipairs(shun_zi_list) do
				if shun_zi_v1 == 0 then
					shun_zi_v1 = v[1]
				end
				if shun_zi_v1 ~= v[1] then
					yi_se_si_tong = false break
				end
			end
			if yi_se_si_tong then
				table.insert(base_fan_table,HU_INFO.YI_SE_SI_TONG_SHUN)
				return base_fan_table
			end
		end
		-- 一色四同顺 --
		-- 一色四节高 --
		if qing_yi_se and #three_tong_list == 4 then
			local tong_list = {}
			for k,v in ipairs(three_tong_list) do
				table.insert( tong_list, v[1])
			end
			table.sort(tong_list)
			if (tong_list[1]+1 == tong_list[2]) and (tong_list[1]+2 == tong_list[3]) and (tong_list[1]+3 == tong_list[4]) then
				table.insert(base_fan_table,HU_INFO.YI_SE_SI_JIE_GAO)
				return base_fan_table
			end
		end
		-- 一色四节高 --
		-- 一色四步高 --
		if qing_yi_se and #shun_zi_list == 4 then
			local shun_list = {}
			for k,v in ipairs(shun_zi_list) do
				table.insert( shun_list, v[1])
			end
			table.sort(shun_list)
			if (shun_list[1]+1 == shun_list[2]) and (shun_list[1]+2 == shun_list[3]) and (shun_list[1]+3 == shun_list[4]) then
				table.insert(base_fan_table,HU_INFO.YI_SE_SI_BU_GAO)
				return base_fan_table
			end
		end
		-- 一色四步高 --
		-- 混幺九 --
		if #shun_zi_list == 0 then
			local yao_count = 0
			local jiu_count = 0
			local has_other_wan = false
			if g_jiang_tile == 1 then
				yao_count = yao_count + 1 
			elseif g_jiang_tile == 9 then 
				jiu_count = jiu_count + 1
			elseif g_jiang_tile < 9 and g_jiang_tile > 1 then 
				has_other_wan = true
			end
			for k,v in ipairs(three_tong_list) do
				if v[1] == 1 then
					yao_count = yao_count + 1 
				elseif v[1] == 9 then 
					jiu_count = jiu_count + 1
				elseif v[1] < 9 and v[1] > 1 then 
					has_other_wan = true
				end
			end
			if yao_count == 1 and jiu_count == 1 and not has_other_wan then
				table.insert(base_fan_table,HU_INFO.HUN_YAO_JIU)
				return base_fan_table 
			end
		end
		-- 混幺九 --
		-- 一色三节高 --
		if qing_yi_se and #three_tong_list >= 3 then
			local tong_list = {}
			for k,v in ipairs(three_tong_list) do
				table.insert( tong_list, v[1])
			end
			table.sort(tong_list)
			if ((tong_list[1]+1 == tong_list[2]) and (tong_list[1]+2 == tong_list[3])) or 
			(#three_tong_list > 3 and (tong_list[2]+1 == tong_list[3]) and (tong_list[2]+2 == tong_list[4])) then
				table.insert(base_fan_table,HU_INFO.YI_SE_SAN_JIE_GAO)
				return base_fan_table
			end
		end
		-- 一色三节高 --
		-- 一色三同顺 --
		if qing_yi_se and #shun_zi_list >= 3 then
			local shun_zi_v1_list = {}
			local yi_se_si_tong = true
			for k,v in ipairs(shun_zi_list) do
				shun_zi_v1_list[v[1]] = shun_zi_v1_list[v[1]] or 0
				shun_zi_v1_list[v[1]] = shun_zi_v1_list[v[1]] + 1
			end
			for k,v in ipairs(shun_zi_v1_list) do
				if v == 3 then
					table.insert(base_fan_table,HU_INFO.YI_SE_SAN_TONG_SHUN)
					return base_fan_table
				end
			end
		end
		-- 一色三同顺 --
		-- 清龙 --
		if qing_yi_se then
			local cache_qing_long = {0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,}
			for k,v in ipairs(g_split_list) do
				for k1,v1 in ipairs(v) do
					cache_qing_long[v1] = cache_qing_long[v1] + 1
				end
			end
			if cache_qing_long[1] > 0 and cache_qing_long[2] > 0 and cache_qing_long[3] > 0 and cache_qing_long[4] > 0 and 
			cache_qing_long[5] > 0 and cache_qing_long[6] > 0 and cache_qing_long[7] > 0 and cache_qing_long[8] > 0 and cache_qing_long[9] > 0 then
				table.insert(base_fan_table,HU_INFO.QING_LONG)
				return base_fan_table 
			end
		end
		
		-- 清龙 --
		-- 一色三步高 --
		if qing_yi_se and #shun_zi_list >= 3 then
			local cache_san_bu_gao = {0,0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,}
			for k,v in ipairs(shun_zi_list) do
				cache_san_bu_gao[v[1]] = cache_san_bu_gao[v[1]] + 1
			end

			for k,v in ipairs(cache_san_bu_gao) do
				if (v > 0 and cache_san_bu_gao[k+1] > 0 and cache_san_bu_gao[k+2] > 0 ) or 
				(v > 0 and cache_san_bu_gao[k+2] > 0 and cache_san_bu_gao[k+4] > 0) then
					table.insert(base_fan_table,HU_INFO.YI_SE_SAN_BU_GAO)
					return base_fan_table 
				end
			end
		end
		-- 一色三步高 --
		-- 碰碰胡 --
		if (#three_tong_list + #four_tong_list) >= 4 and #shun_zi_list == 0 then
			table.insert(base_fan_table,HU_INFO.PENG_PENG_HU)
			return base_fan_table 
		end
		-- 碰碰胡 --
		-- 四字刻 --
		local zi_ke_count = 0
		for k,v in ipairs(three_tong_list) do
			if v[1] >= 10 and v[1] <= 16 then
				zi_ke_count = zi_ke_count + 1
			end
		end
		for k,v in ipairs(four_tong_list) do
			if v[1] >= 10 and v[1] <= 16 then
				zi_ke_count = zi_ke_count + 1
			end
		end
		if zi_ke_count >= 4 then
			table.insert(base_fan_table,HU_INFO.SI_ZI_KE)
			return base_fan_table 
		end
		-- 四字刻 --
		
		table.insert(base_fan_table,HU_INFO.PING_HU)
		return base_fan_table 
	else
		return {}
	end
end
--根据手上的牌，计算番数，手上的牌，包括手牌，明牌
--@param cards 牌
--@key shou_pai 手上的牌 [1,2,3]
--@key ming_pai 明牌 [ [111,22222,345]]
function TmjFanCalculator.getFan(cards)
	local huInfos = TmjFanCalculator.is_hu(cards)
	if huInfos and next(huInfos) then
		return TmjFanCalculator.get_fan_table_res(huInfos)
	end
	return nil
end

return TmjFanCalculator