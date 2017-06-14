EOS_INIT = 0
EOS_LIVE = 1
EOS_HIT = 2
EOS_DEAD = 3
EOS_DESTORED = 4


E_Red = 1
E_Blue = 2
E_Light = 3


SpecialFishType = {
    ESFT_NORMAL = 0,
    ESFT_KING = 1,
    ESFT_KINGANDQUAN = 2,
    ESFT_SANYUAN = 3,
    ESFT_SIXI = 4,
    ESFT_MAX = 5,
}

EffectType =  {
    ETF_NONE = -1,
    ETP_ADDMONEY = 0, -- 增加金币
    ETP_KILL = 1, --杀死其它鱼
    ETP_ADDBUFFER = 2, --增加BUFFER
    ETP_PRODUCE = 3, --生成其它鱼
    ETP_BLACKWATER = 4, --乌贼喷墨汁效果
    ETP_AWARD = 5, --抽奖
};