-------------------------------------------------------------------------
-- Desc:    �����齫���ͼ���
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
	--����ϲ----Ȧ���,�ŷ��,������,С����,������
	DA_SI_XI 			= {QUAN_FENG_KE,MEN_FENG_KE,DA_SAN_FENG,XIAO_SAN_FENG,PENG_PENG_HU},
	--����Ԫ----˫����,����
	DA_SAN_YUAN			= {SHUANG_JIAN_KE,JIAN_KE},	
	--��������----��һɫ		
	JIU_LIAN_BAO_DENG	= {QING_YI_SE},	
	--18�޺�----���ܣ�˫���ܣ����ܣ�������
	LUO_HAN_18			= {SAN_GANG,SHUANG_MING_GANG,MING_GANG,DAN_DIAO_JIANG},	
	--��7��----��һɫ����������ǰ�壬������
	LIAN_QI_DUI			= {QING_YI_SE,DAN_DIAO_JIANG,MEN_QING,ZI_MO},	
	--������--ȫ���ۣ�����������ǰ�壬��������һɫ
	DA_QI_XIN			= {QUAN_DAI_YAO,DAN_DIAO_JIANG,MING_GANG,ZI_MO,ZI_YI_SE},	
	--���--�������������ˣ�������
	TIAN_HU				= {DAN_DIAO_JIANG,BU_QIU_REN,ZI_MO},
	--С��ϲ ���ƴ����磬С���磬Ȧ��̣��ŷ�̡�
	XIAO_SI_XI			= {DA_SAN_FENG,XIAO_SAN_FENG,QUAN_FENG_KE,MEN_FENG_KE},
	--С��Ԫ	����˫���̣�����
	XIAO_SAN_YUAN		= {SHUANG_JIAN_KE,JIAN_KE},
	--��һɫ ���������͡�
	ZI_YI_SE			= {PENG_PENG_HU},
	--�İ���	���������̣�˫���̣���ǰ�壬�����ͣ�����
	SI_AN_KE 			= {SAN_AN_KE,SHUANG_AN_KE,MING_GANG,PENG_PENG_HU,ZI_MO},
	--һɫ˫���� ����ƽ�ͣ���һɫ��һ���
	SHUANG_LONG_HUI		= {PING_HU,QING_YI_SE,YI_BAN_GAO},
	--һɫ��ͬ˳ ����һɫ���ڸߡ�һɫ��ͬ˳���Ĺ�һ��һ���
	YI_SE_SI_TONG_SHUN	= {YI_SE_SAN_JIE_GAO,YI_SE_SAN_TONG_SHUN,SI_GUI_YI,YI_BAN_GAO},
	--һɫ�Ľڸ� ����һɫ��ͬ˳��һɫ���ڸߣ������ͣ�һ���
	YI_SE_SI_JIE_GAO	= {YI_SE_SAN_TONG_SHUN,YI_SE_SAN_JIE_GAO,PENG_PENG_HU,YI_BAN_GAO},
	--��Ԫ�߶��� ������ǰ�壬��������������
	SAN_YUAN_QI_DUI		= {MEN_QING,DAN_DIAO_JIANG,ZI_MO},
	--��ϲ�߶��� ���� ��ǰ�壬��������������
	SI_XI_QI_DUI		= {MEN_QING,DAN_DIAO_JIANG,ZI_MO},
	--һɫ�Ĳ��� ���������ߣ����������ٸ�
	YI_SE_SI_BU_GAO		= {YI_SE_SAN_BU_GAO,LIAN_LIU,LAO_SHAO_FU},
	--����  ����˫���գ�����
	SAN_GANG			= {SHUANG_MING_GANG,MING_GANG},
	--���۾� ���������͡�ȫ���ۡ�
	HUN_YAO_JIU			= {PENG_PENG_HU,QUAN_DAI_YAO},
	--�߶� ���Ʋ����ˣ���ǰ�壬��������������
	NORMAL_QI_DUI		= {BU_QIU_REN,MEN_QING,DAN_DIAO_JIANG,ZI_MO},
	--һɫ���ڸ� ����һɫ��ͬ˳��һ��ߡ�
	YI_SE_SAN_JIE_GAO	= {YI_SE_SAN_TONG_SHUN,YI_BAN_GAO},
	--һɫ��ͬ˳ ����һɫ���ڸߣ�һ��ߡ�
	YI_SE_SAN_TONG_SHUN	= {YI_SE_SAN_JIE_GAO,YI_BAN_GAO},
	--���ֿ� 	������������
	SI_ZI_KE			= {PENG_PENG_HU},
	--������ 	����С����
	DA_SAN_FENG			= {XIAO_SAN_FENG},
	--���� �������������ٸ���
	QING_LONG			= {LIAN_LIU,LAO_SHAO_FU},
	--������ ����˫����
	SAN_AN_KE			= {SHUANG_AN_KE},
	--���ֻش� ��������
	MIAO_SHOU_HUI_CHUN	= {ZI_MO},
	--���Ͽ��� 	����������
	GANG_SHANG_HUA		= {ZI_MO},
	--���ܺ� ���ƺ�����
	QIANG_GANG_HU		= {HU_JUE_ZHANG},
	--ȫ���� ���Ƶ���
	QUAN_QIU_REN		= {DAN_DIAO_JIANG},
	--˫���� 	����˫���̣����ܡ�
	SHUANG_AN_GANG		= {SHUANG_AN_KE,AN_GANG},
	--˫���� 	����˫���̣�����
	SHUANG_JIAN_KE		= {SHUANG_AN_KE,AN_GANG},
} 
TmjFanCalculator.CARD_HU_TYPE_INFO = {
	WEI_HU					= {name = "WEI_HU",fan = 0},				--δ��
------------------------------����-------------------------------------------------
	TIAN_HU					= {name = "TIAN_HU",fan = 88},				--���
	DI_HU					= {name = "DI_HU",fan = 88},				--�غ�
	REN_HU					= {name = "REN_HU",fan = 64},				--�˺�
	TIAN_TING				= {name = "TIAN_TING",fan = 32},			--����
	QING_YI_SE				= {name = "QING_YI_SE",fan = 16},			--��һɫ
	QUAN_HUA				= {name = "QUAN_HUA",fan = 16},				--ȫ��
	ZI_YI_SE				= {name = "ZI_YI_SE",fan = 64},				--��һɫ
	MIAO_SHOU_HUI_CHUN		= {name = "MIAO_SHOU_HUI_CHUN",fan = 8},	--���ֻش�
	HAI_DI_LAO_YUE			= {name = "HAI_DI_LAO_YUE",fan = 8},		--��������
	GANG_SHANG_HUA			= {name = "GANG_SHANG_HUA",fan = 8},		--���Ͽ���
	QUAN_QIU_REN			= {name = "QUAN_QIU_REN",fan = 8},			--ȫ����
	SHUANG_AN_GANG			= {name = "SHUANG_AN_GANG",fan = 6},		--˫����
	SHUANG_JIAN_KE			= {name = "SHUANG_JIAN_KE",fan = 6},		--˫����
	HUN_YI_SE				= {name = "HUN_YI_SE",fan = 6},				--��һɫ
	BU_QIU_REN				= {name = "BU_QIU_REN",fan = 4},			--������
	SHUANG_MING_GANG		= {name = "SHUANG_MING_GANG",fan = 4},		--˫����
	HU_JUE_ZHANG			= {name = "HU_JUE_ZHANG",fan = 4},			--������
	JIAN_KE					= {name = "JIAN_KE",fan = 2},				--����
	MEN_QING				= {name = "MEN_QING",fan = 2},				--��ǰ��
	ZI_AN_GANG				= {name = "ZI_AN_GANG",fan = 2},			--�԰���
	DUAN_YAO				= {name = "DUAN_YAO",fan = 2},				--����
	SI_GUI_YI				= {name = "SI_GUI_YI",fan = 2},				--�Ĺ�һ
	PING_HU					= {name = "PING_HU",fan = 2},				--ƽ��
	SHUANG_AN_KE			= {name = "SHUANG_AN_KE",fan = 2},			--˫����
	SAN_AN_KE				= {name = "SAN_AN_KE",fan = 16},			--������
	SI_AN_KE				= {name = "SI_AN_KE",fan = 64},				--�İ���
	BAO_TING				= {name = "BAO_TING",fan = 2},				--����
	MEN_FENG_KE				= {name = "MEN_FENG_KE",fan = 2},			--�ŷ��
	QUAN_FENG_KE			= {name = "QUAN_FENG_KE",fan = 2},			--Ȧ���
	ZI_MO					= {name = "ZI_MO",fan = 1},					--����
	DAN_DIAO_JIANG			= {name = "DAN_DIAO_JIANG",fan = 1},		--������
	YI_BAN_GAO	 			= {name = "YI_BAN_GAO",fan = 1},			--һ���
	LAO_SHAO_FU	 			= {name = "LAO_SHAO_FU",fan = 1},			--���ٸ�
	LIAN_LIU	 			= {name = "LIAN_LIU",fan = 1},				--����
	YAO_JIU_KE	 			= {name = "YAO_JIU_KE",fan = 1},			--�۾ſ�
	MING_GANG	 			= {name = "MING_GANG",fan = 1},				--����
	DA_SAN_FENG				= {name = "DA_SAN_FENG",fan = 24},			--������
	XIAO_SAN_FENG			= {name = "XIAO_SAN_FENG",fan = 24},		--С����
	PENG_PENG_HU			= {name = "PENG_PENG_HU",fan = 6},			--������
	SAN_GANG				= {name = "SAN_GANG",fan = 32},				--����
	QUAN_DAI_YAO			= {name = "QUAN_DAI_YAO",fan = 4},			--ȫ����
	QIANG_GANG_HU			= {name = "QIANG_GANG_HU",fan = 8},			--���ܺ�
	HUA_PAI					= {name = "HUA_PAI",fan = 1},				--����
-----------------------------------------------------------------------------------
	DA_QI_XIN			= {name = "DA_QI_XIN",fan = 88},			--������
	LIAN_QI_DUI 		= {name = "LIAN_QI_DUI",fan = 88},			--���߶�
	SAN_YUAN_QI_DUI		= {name = "SAN_YUAN_QI_DUI",fan = 48},		--��Ԫ�߶���
	SI_XI_QI_DUI		= {name = "SI_XI_QI_DUI",fan = 48},			--��ϲ�߶���
	NORMAL_QI_DUI 		= {name = "NORMAL_QI_DUI",fan = 24},		--��ͨ�߶�
---------------------
	DA_YU_WU 			= {name = "DA_YU_WU",fan = 88},				--������
	XIAO_YU_WU 			= {name = "XIAO_YU_WU",fan = 88},			--С����
	DA_SI_XI			= {name = "DA_SI_XI",fan = 88},				--����ϲ
	XIAO_SI_XI			= {name = "XIAO_SI_XI",fan = 64},			--С��ϲ
	DA_SAN_YUAN			= {name = "DA_SAN_YUAN",fan = 88},			--����Ԫ
	XIAO_SAN_YUAN		= {name = "XIAO_SAN_YUAN",fan = 64},		--С��Ԫ
	JIU_LIAN_BAO_DENG	= {name = "JIU_LIAN_BAO_DENG",fan = 88},	--��������
	LUO_HAN_18			= {name = "LUO_HAN_18",fan = 88},			--18�޺�
	SHUANG_LONG_HUI		= {name = "SHUANG_LONG_HUI",fan = 64},		--һɫ˫����
	YI_SE_SI_TONG_SHUN	= {name = "YI_SE_SI_TONG_SHUN",fan = 48},	--һɫ��ͬ˳
	YI_SE_SI_JIE_GAO	= {name = "YI_SE_SI_JIE_GAO",fan = 48},		--һɫ�Ľڸ�
	YI_SE_SI_BU_GAO		= {name = "YI_SE_SI_BU_GAO",fan = 32},		--һɫ�Ĳ���
	HUN_YAO_JIU			= {name = "HUN_YAO_JIU",fan = 32},			--���۾�
	YI_SE_SAN_JIE_GAO	= {name = "YI_SE_SAN_JIE_GAO",fan = 24},	--һɫ���ڸ�
	YI_SE_SAN_TONG_SHUN	= {name = "YI_SE_SAN_TONG_SHUN",fan = 24},	--һɫ��ͬ˳
	SI_ZI_KE			= {name = "SI_ZI_KE",fan = 24},				--���ֿ�
	QING_LONG			= {name = "QING_LONG",fan = 16},			--����
	YI_SE_SAN_BU_GAO	= {name = "YI_SE_SAN_BU_GAO",fan = 16},		--һɫ������
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
--��ȡ����
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
	
	--һ�򵽾��� ��-��-��-��  -��-��-��-   ��-��-��-��-÷-��-��-��--
	--1-9		    10-13		14-16		20-27
	jiang = 0
	g_jiang_tile = 0
	g_split_list = {}
	local hu = (TmjFanCalculator.Hu(cache) == 1 and g_jiang_tile ~= 0)
	if hu then
		local qing_yi_se = true
		local zi_yi_se = true
		local shuang_jian_ke = false  --˫����  �������С���������ɵĿ���
		local hun_yi_se = false  --�����������֡���������
		local jian_ke = false --����
		local men_qing = false --��ǰ��
		local ping_hu = false --ƽ��
		local lao_shao_fu = false --���ٸ�
		local si_an_ke = false --4����
		local san_an_ke = false --3����
		local shuang_an_ke = false --2����
		local lian_liu = false	--����
		local yao_jiu_ke = 0 --�۾ſ�
		local ming_gang = 0 --����
		local da_san_feng = false	--������
		local xiao_san_feng = false	--С����
		local san_gang = false --����
		local quan_dai_yao = true --ȫ����

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

		local has_wan = false--��һɫ �����������֡���������
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
		-- ���� --
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
				si_an_ke = true --4����
			elseif four_or_three_count >= 3 then
				san_an_ke = true --3����
			elseif four_or_three_count >= 2 then
				shuang_an_ke = true --2����
			end
		end
		-- ���� --

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
			lian_liu = true	--����
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

		-- ������ --
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
			da_san_feng = true	--������
		end
		-- ������ --
		-- С���� --
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
			xiao_san_feng = true	--С����
		end
		-- С���� --
		-- ���� -- 
		if #four_tong_list == 3 then
			san_gang = true
		end
		-- ���� --
		-- ȫ���� -- 
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
		-- ȫ���� --

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

		----------��������---------
		if cache[10] == 2 and cache[11] == 2 and cache[12] == 2 and cache[13] == 2 and cache[14] == 2 
		and cache[15] == 2 and cache[16] == 2
		then
			table.insert(base_fan_table,HU_INFO.DA_QI_XIN)
			return base_fan_table-- ������ --
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
				return base_fan_table-- ��Ԫ�߶��� --
			end
			if cache[10] == 2 and cache[11] == 2 and cache[12] == 2 and cache[13] == 2 then
				table.insert(base_fan_table,HU_INFO.SI_XI_QI_DUI)
				return base_fan_table-- ��ϲ�߶��� --
			end
			table.insert(base_fan_table,HU_INFO.NORMAL_QI_DUI)
			return base_fan_table-- �߶� --
		end
		---------------------------

	---------------------------------------------------------------------------------------
		-- ��С���� --
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
		-- ��С���� --
		-- �������� --
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
				return base_fan_table-- �������� --
			end
		end
		-- �������� --
		-- 18�޺� --
		if #four_tong_list == 4 then
			table.insert(base_fan_table,HU_INFO.LUO_HAN_18)
			return base_fan_table-- 18�޺� --
		end
		-- 18�޺� --
		-- һɫ˫���� --
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
		-- һɫ˫���� --
		-- ��ϲ--
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
		-- ��ϲ--
		-- ��Ԫ --
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
		-- ��Ԫ --
		-- һɫ��ͬ˳ --
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
		-- һɫ��ͬ˳ --
		-- һɫ�Ľڸ� --
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
		-- һɫ�Ľڸ� --
		-- һɫ�Ĳ��� --
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
		-- һɫ�Ĳ��� --
		-- ���۾� --
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
		-- ���۾� --
		-- һɫ���ڸ� --
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
		-- һɫ���ڸ� --
		-- һɫ��ͬ˳ --
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
		-- һɫ��ͬ˳ --
		-- ���� --
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
		
		-- ���� --
		-- һɫ������ --
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
		-- һɫ������ --
		-- ������ --
		if (#three_tong_list + #four_tong_list) >= 4 and #shun_zi_list == 0 then
			table.insert(base_fan_table,HU_INFO.PENG_PENG_HU)
			return base_fan_table 
		end
		-- ������ --
		-- ���ֿ� --
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
		-- ���ֿ� --
		
		table.insert(base_fan_table,HU_INFO.PING_HU)
		return base_fan_table 
	else
		return {}
	end
end
--�������ϵ��ƣ����㷬�������ϵ��ƣ��������ƣ�����
--@param cards ��
--@key shou_pai ���ϵ��� [1,2,3]
--@key ming_pai ���� [ [111,22222,345]]
function TmjFanCalculator.getFan(cards)
	local huInfos = TmjFanCalculator.is_hu(cards)
	if huInfos and next(huInfos) then
		return TmjFanCalculator.get_fan_table_res(huInfos)
	end
	return nil
end

return TmjFanCalculator