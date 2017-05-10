local StoreConfig = {}


StoreConfig.Config_Items = {
    { ["id"] = 1    ,["good_id"] = "coin_9" ,["goods_desc"] = "6元礼包",    ["price"] = 6,      ["goods_gold"] = 9 },
    { ["id"] = 2    ,["good_id"] = "coin_19" ,["goods_desc"] = "12元礼包",   ["price"] = 12,     ["goods_gold"] = 19 },
    { ["id"] = 3    ,["good_id"] = "coin_49" ,["goods_desc"] = "30元礼包",   ["price"] = 30,     ["goods_gold"] = 49 },
    { ["id"] = 4    ,["good_id"] = "coin_83" ,["goods_desc"] = "50元礼包",   ["price"] = 50,     ["goods_gold"] = 83 },
    { ["id"] = 5    ,["good_id"] = "coin_218" ,["goods_desc"] = "218元礼包",  ["price"] = 128,    ["goods_gold"] = 218 },
    { ["id"] = 6    ,["good_id"] = "coin_575" ,["goods_desc"] = "328元礼包",  ["price"] = 328,    ["goods_gold"] = 575 },
    { ["id"] = 7    ,["good_id"] = "coin_1100" ,["goods_desc"] = "618元礼包",  ["price"] = 618,    ["goods_gold"] = 1100 },
}


local function  initPayURL( )
    local payUrl =CustomHelper.getOneHallGameConfigValueWithKey("pay_url")
    if payUrl then 
        StoreConfig.ios_create_order = payUrl.ios_create_order
        StoreConfig.ios_query_order =  payUrl.ios_query_order
        StoreConfig.web_create_order =  payUrl.web_create_order
        StoreConfig.web_query_order = payUrl.web_query_order
        StoreConfig.transfer_alipay_create_order =  payUrl.transfer_alipay_create_order
    else
        assert("没有配置支付URL") 
    end
end
initPayURL()

-- StoreConfig.URL_GAME_CONFIG_BAK = "http://119.23.142.36:8080";
-- StoreConfig.CREATE_ORDER = "/api/apple/store"; --ios生成订单
-- StoreConfig.QUERY_ORDER = "/api/apple/apple_pay";--ios查询订单
-- StoreConfig.CREATE_WEBORDER = "/api/pay/store"; --web生成订单
-- StoreConfig.WEB_QUERY_ORDER = "/api/pay/show";--web查询订单

--alipay=支付宝，wxpay=微信,iospay=苹果支付
StoreConfig.PAY_TYPE = 
{
    IOSPAY = "iospay",
    ALIPAY = "alipay",
    WEIXINPAY = "wxpay",
    TRANSFERPAY = "transfer_alipay",

}

function StoreConfig.getItemsConfig()
    return StoreConfig.Config_Items
end

function StoreConfig.getItemsConfigById(id)
    for _,v in pairs(StoreConfig.Config_Items) do
        if v.id == id then
            return v
        end
    end

    return nil
end

return StoreConfig