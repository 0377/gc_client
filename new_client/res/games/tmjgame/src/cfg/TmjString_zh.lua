local languageString = { }
-- 根据模块划分
-- 使用方式 i18n:get('str_common', 'comm_appname')
-- 根据模块Key，字符串Key获得文字
-----------------------[[ 配置区Start ]]-----------------------------
-- 通用模块
languageString['str_cardtip'] =
{
    ['chi'] = '吃',
    ['peng'] = '碰',
    ['gang'] = '杠',
    ['hu'] = '胡',
    ['ting'] = '听',
    ['anGang'] = '暗杠',
    ['buGang'] = '补杠',
    ['getOne'] = '摸牌',
    ['playOne'] = '打牌',
    ['buHua'] = '补花',
}

languageString['str_mjplay'] =
{
    ['fan'] = '%d番',
    ['rate'] = '%d倍',
    ['restCount'] = '剩余%d张',
    ['exitAlert'] = '您正在游戏中，退出游戏后将由电脑托管您继续完成游戏，您可以重进游戏继续该局游戏。',
    ['lackgold'] = '金币不足，退出房间!!!',
  
}
-----------------------[[ 配置区End ]]-----------------------------
return languageString