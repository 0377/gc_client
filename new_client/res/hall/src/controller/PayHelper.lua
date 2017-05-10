local sqlite3 = requireForGameLuaFile("lsqlite3")
local StoreConfig = requireForGameLuaFile("StoreConfig")
local ANDROID_CLASSNAME = "org.cocos2dx.lua.MobilePlate"
local json = require("cjson");
local targetPlatform = cc.Application:getInstance():getTargetPlatform()
local luaoc = nil
local luaj = nil
if targetPlatform == cc.PLATFORM_OS_IPHONE or targetPlatform == cc.PLATFORM_OS_IPAD then
    luaoc = requireForGameLuaFile("src.cocos.cocos2d.luaoc")
elseif targetPlatform == cc.PLATFORM_OS_ANDROID then
    luaj = requireForGameLuaFile("src.cocos.cocos2d.luaj")
end 



local PayHelper = {
	  queryingIOSPayData = nil,
      queryingWebPayOrder = nil,
}

-- goods_id
-- order_id
-- iospay_key

function PayHelper.getIOSPayOrderTable()
    local db = sqlite3.open(device.writablePath .. "data.db")
    db:exec [[
        CREATE TABLE IF NOT EXISTS IOSPayOrder (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            receipt_data TEXT NOT NULL,
            order_id TEXT NOT NULL,
            goods_id TEXT NOT NULL,
            player_id TEXT NOT NULL
            );
    ]]

    return db
end

function PayHelper.SaveOrder(data)
    local db = PayHelper.getIOSPayOrderTable()
    local sql = string.format("INSERT INTO IOSPayOrder VALUES (NULL,'%s','%s','%s','%s');",
        data.receipt_data, data.order_id, data.goods_id, data.player_id)
    db:exec(sql)

    db:close()
end

function PayHelper.GetOrders()
    local db = PayHelper.getIOSPayOrderTable()


    local data = {}
    for v in db:nrows("SELECT * FROM IOSPayOrder LIMIT 1;") do
        table.insert(data, v)
    end
    db:close()

    return data
end

function PayHelper.DelOrder(data)
    local db = PayHelper.getIOSPayOrderTable()
    local sql = string.format("DELETE FROM IOSPayOrder WHERE order_id='%s' AND goods_id='%s' AND player_id='%s';",
        data.order_id, data.goods_id, data.player_id)
    local ret, msg = db:exec(sql)
    return data
end
function PayHelper.httpRequest(callback,method,url,parameterTab,args)
    
	local xhr = cc.XMLHttpRequest:new()
    xhr:setRequestHeader("Content-Type","application/json; charset=utf-8");
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON -- json数据类型
	local function onReadyStateChanged()
		
    	local isSuccess = false;
        print("xhr.readyState:",xhr.readyState)
    	if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then 
            isSuccess = true;
        else
			
        end
        callback({
                    args = args,
                    name = isSuccess and "success" or "failed",
                    response = xhr.response,
                });
        xhr:unregisterScriptHandler()
    end
	xhr:registerScriptHandler(onReadyStateChanged)
	if method == nil then
		--todo
		method = "POST";
	end
    local parameterStr = "";
    local dataJsonStr = nil;
    if parameterTab ~= nil and table.nums(parameterTab) >0 then
        --todo
        local isFirstParameter = true;
        dataJsonStr = CustomHelper.getJsonStrWithJsonTab(parameterTab);
        for k,v in pairs(parameterTab) do
            if isFirstParameter then
                --todo
                parameterStr = parameterStr..k.."="..v
                isFirstParameter = false
            else
                parameterStr = parameterStr.."&"..k.."="..v
            end
        end
    end
    
	if method == "POST" then
    	--todo
        print("jsonStr:",dataJsonStr)
        -- dump(parameterTab)
	    xhr:open(method,url);
        -- print("POST url:",url)
        -- print("dataJsonStr:",dataJsonStr)
    	xhr:send(dataJsonStr)
	elseif method == "GET" then
    	--todo
		url = url.."?"..parameterStr;
        -- print("GET url:",url)
	    xhr:open(method,url);
	    xhr:send()
    end
end

function PayHelper.createTransferPayOrder(item, paytype)
    local pay_url = StoreConfig.transfer_alipay_create_order
    local recharge_type = 1
    local player_id = GameManager:getInstance():getHallManager():getPlayerInfo():getGuid()
    local t_sign =  CustomHelper.md5String('guid='..player_id..'&recharge_type='..recharge_type..'&money='..item.price..'&channel='..paytype.. "12345678")
    local param = {
            guid = player_id,
            recharge_type = recharge_type,
            money = item.price,
            channel = paytype,
            sign = t_sign,
        }
    local function callBack(event)
        CustomHelper.removeIndicationTip();
        if event.name == "success" then
            local data = json.decode(event.response)
            dump(data)
            if data and data.status == 1 then  
                local order_id = data.data.serial_order_no
                local qrcode = data.data.url
                PayHelper.queryingWebPayOrder = order_id
                local callback = function()
                    -- CustomHelper.performWithDel-ayGlobal(PayHelper.queryWebPay, 5)
                    CustomHelper.removeIndicationTip()
                end
                -- CustomHelper.addIndicationTip("正在启动支付宝客户端",cc.Director:getInstance():getRunningScene(),0);
                PayHelper.showUrl(qrcode, "", callback, paytype)
            elseif data then 
                CustomHelper.showAlertView(data.message,false,true,nil,nil)
            end
        else
            CustomHelper.showAlertView("生成订单网络超时，请稍后再试！",false,true,nil,nil)
        end
    end
    PayHelper.httpRequest(callBack,"POST",pay_url,param,{t_sign = t_sign})
end


function PayHelper.createOrder(item, paytype)

    local pay_url = nil
    local recharge_type = nil
    local goods_id = item.good_id
    if paytype == StoreConfig.PAY_TYPE.IOSPAY then
        pay_url = StoreConfig.ios_create_order
        recharge_type =  2
        goods_id = item.good_id
    else
        pay_url = StoreConfig.web_create_order
        recharge_type = 1
        goods_id = item.price
    end
	local t_time = os.time()
	local player_id = GameManager:getInstance():getHallManager():getPlayerInfo():getGuid()
    local t_sign = CustomHelper.md5String("goods_amt="..item.price.."&guid="..player_id.."&recharge_type="..recharge_type..t_time)
   

    local param = {
            guid = player_id,
            recharge_type = recharge_type,
            goods_id = goods_id,
            channel = paytype,
            sign = t_sign,
            time = t_time,
        }


    local function callBack(event)
        CustomHelper.removeIndicationTip();
        if event.name == "success" then
			local data = json.decode(event.response)
            if data and data.status == 1 then
                local order_id = data.data.serial_order_no
                local t_sign = event.args.t_sign
                if paytype == StoreConfig.PAY_TYPE.IOSPAY then
                    PayHelper.payPlat(item, order_id)
                else
                        local order_id = data.data.serial_order_no
                        local qrcode = data.data.qrcode
                        PayHelper.queryingWebPayOrder = order_id
                        local callback = function()
                            CustomHelper.performWithDelayGlobal(PayHelper.queryWebPay, 5)
                            CustomHelper.removeIndicationTip()
                        end
                    if paytype == StoreConfig.PAY_TYPE.ALIPAY then
                        CustomHelper.addIndicationTip("正在启动支付宝客户端",cc.Director:getInstance():getRunningScene(),0);
                        PayHelper.showUrl(qrcode, "", callback, paytype)
                    elseif paytype == StoreConfig.PAY_TYPE.WEIXINPAY then
                        PayHelper.showUrl(qrcode, "微信支付", callback, paytype)
                    end 
                   
                end

               -- PayHelper.umengCountBuy("coin", 1, item.coin * 10000)
               -- PayHelper.umengCountBuy("cash", 1, item.price)
            elseif data then 
                CustomHelper.showAlertView(data.message,false,true,nil,nil)
            end
        else
            CustomHelper.showAlertView("生成订单网络超时，请稍后再试！",false,true,nil,nil)
        end
    end
	PayHelper.httpRequest(callBack,"POST",pay_url,param,{t_sign = t_sign})
end

function PayHelper.payPlat(item, orderid)
    if device.platform == "ios" then
        local args = {
            goods_id = tostring(item.good_id),
            order_id = tostring(orderid),
            callback = PayHelper._onIOSPaySuccessed,
        }  
        luaoc.callStaticMethod("PlatBridge", "pay", args)
    elseif device.platform == "android" then
    end
end

--苹果返回支付成功票据
function PayHelper._onIOSPaySuccessed(data)
    local data = {
        receipt_data = data.iospay_key,
        order_id = data.order_id,
        goods_id = data.goods_id,
        player_id = GameManager:getInstance():getHallManager():getPlayerInfo():getGuid(),
    }
    PayHelper.SaveOrder(data)
    PayHelper.checkIOSPayOrders()
end

--查询ios支付订单
function PayHelper.checkIOSPayOrders()
    if PayHelper.queryingIOSPayData then return end

    local orders = PayHelper.GetOrders()
    if #orders > 0 then
        PayHelper.SaveOrder(PayHelper.DelOrder(orders[1]))
        PayHelper.queryIOSPay(orders[1])
    end
end

--查询ios支付订单状态
function PayHelper.queryIOSPay(data)
    -- goods_id
    -- order_id
    -- iospay_key
    PayHelper.queryingIOSPayData = data
	local function callback(event)
        if event.name == "success" then
            local data = json.decode(event.response)
            if data and data.status == 1 then
                PayHelper.DelOrder(PayHelper.queryingIOSPayData)
            else
                local data = json.decode(event.response)
                if data then
                    if data.code == "10001" then
                        PayHelper.DelOrder(PayHelper.queryingIOSPayData)
                    end
                    -- CustomHelper.showAlertView(data.message,false,true,nil,nil)
                end
            end
            PayHelper.queryingIOSPayData = nil
            PayHelper.checkIOSPayOrders()
            CustomHelper.performWithDelayGlobal(PayHelper.checkIOSPayOrders, 10)
            
        elseif event.name == "failed" then
            PayHelper.queryingIOSPayData = nil
            CustomHelper.performWithDelayGlobal(PayHelper.checkIOSPayOrders, 10)
        end	
	end
	
	local url = StoreConfig.ios_query_order
	local args = {
		receipt_data = data.receipt_data, --string.urlencode(data.receipt_data),
		serial_order_no = data.order_id,
		guid = data.player_id,
		}
	local methon = "POST"
	PayHelper.httpRequest(callback,methon,url ,args,nil)
end


--查询支付宝／微信支付状态
function PayHelper.queryWebPay()

    print("PayHelper.queryWebPay")

    if PayHelper.queryingWebPayOrder == nil then  return end
    local order_id = PayHelper.queryingWebPayOrder
    local function callback(event)
        if event.name == "success" then
            local response = event.responsssse -- 
            local output = json.decode(response) -- 
            if output then
                if output.status == 1 then
                    --此处应该请求刷新金币数量
                    CustomHelper.showAlertView("充值成功。",false,true,nil,nil)
                else
                    -- CustomHelper.showAlertView(output.message,false,true,nil,nil)
                end
            end
        else
             CustomHelper.showAlertView("查询订单支付状态网络超时，请稍后再试！",false,true,nil,nil)
        end
       
    end
	local pay_url = StoreConfig.web_query_order
    local param = {serial_order_no = order_id}
    PayHelper.queryingWebPayOrder = nil
	PayHelper.httpRequest(callback,"GET",pay_url, param,nil)
end

function PayHelper.callQQChat(qqNumber)
    if targetPlatform == cc.PLATFORM_OS_ANDROID then
        local args = { qqNumber }
        luaj.callStaticMethod(ANDROID_CLASSNAME, "callQQChat", args, "(Ljava/lang/String;)V")
    elseif targetPlatform == cc.PLATFORM_OS_IPHONE or targetPlatform == cc.PLATFORM_OS_IPAD then
        local appargs = {
            strUrl = "mqq://",
        }
        local ok, ret = luaoc.callStaticMethod("PlatBridge", "canOpenURL", appargs)
        if ok then
            --todo
            if ret == "true" then
                  local appargs = {
                    qqNum = qqNumber,
                }
                luaoc.callStaticMethod("PlatBridge", "callQQChat", appargs)
            else 
                CustomHelper.showAlertView("启动QQ失败,请检查是否安装有QQ客户端。",false,true,nil,nil)
            end
        end
    end
end

--复制字符串到剪切板
function PayHelper.copyStrToShearPlate(ui, str)
    str = tostring(str)
    if targetPlatform == cc.PLATFORM_OS_ANDROID then
        local args = { str };
        luaj.callStaticMethod(ANDROID_CLASSNAME, "copyStrToShearPlate", args, "(Ljava/lang/String;)V");
        return true, "复制成功"
    elseif targetPlatform == cc.PLATFORM_OS_IPHONE or targetPlatform == cc.PLATFORM_OS_IPAD then
        local appargs = {
            str = str,
        }
        luaoc.callStaticMethod("PlatBridge", "copyStrToShearPlate", appargs);
        return true, "复制成功"
    else
        MyToastLayer.new(cc.Director:getInstance():getRunningScene(), "模拟器不允许复制")
        return false, "模拟器不允许复制"
    end
end



function PayHelper.showUrl(url, title, callback, jsonstr)
    if string.find(url,"https://") == 1 or string.find(url,"http://") == 1 then
        if device.platform == "android" then
            local appargs = {
                url or "",
                title or "电玩城",
                callback or 0,
                jsonstr or "",
            }
    		print("showWebView:",url)
            luaj.callStaticMethod(ANDROID_CLASSNAME, "showWebView", appargs, "(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)V")
        elseif device.platform == "ios" then
            local appargs = {
                url = url or "",
                title = title or "电玩城",
                callback =callback or 0,
                args = jsonstr or "",
            }
            luaoc.callStaticMethod("PlatBridge", "showWebView", appargs)
        else
            cc.Application:getInstance():openURL(url)
        end
    else
        CustomHelper.removeIndicationTip()
        PayHelper.openBrowser(url)
    end

end

function PayHelper.openBrowser(url)
    if device.platform == "ios" then
        local appargs = {
            strUrl = url,
        }
        luaoc.callStaticMethod("PlatBridge", "openBrowser", appargs)
        CustomHelper.performWithDelayGlobal(PayHelper.queryWebPay, 5)
    elseif device.platform == "android" then
        local args = { url }
        luaj.callStaticMethod(ANDROID_CLASSNAME, "openBrowser", args, "(Ljava/lang/String;)V")
        CustomHelper.performWithDelayGlobal(PayHelper.queryWebPay, 5)
    elseif device.platform == "windows" then
        cc.Application:getInstance():openURL(url)
        CustomHelper.performWithDelayGlobal(PayHelper.queryWebPay, 5)
    end
end

--是否安装支付宝
function PayHelper.isInstallAliPay()
	if device.platform == "ios" then
        local appargs = {
            strUrl = "alipay://",
        }
        local ok, ret = luaoc.callStaticMethod("PlatBridge", "canOpenURL", appargs)
        if ok then
            --todo
            if ret == "true" then
                return true
            else 
                CustomHelper.showAlertView("未安装支付宝插件，请使用其他方式充值。",false,true,nil,nil)
                return false
            end
        end
    elseif device.platform == "android" then
        local args = { url }
        local ok, ret = luaj.callStaticMethod(ANDROID_CLASSNAME, "checkAliPayInstalled", nil, "()Ljava/lang/String;")
          if ok then
            --todo
            print("ret:",ret)
             if ret == "true" then
                return true
            else 
                CustomHelper.showAlertView("未安装支付宝插件，请使用其他方式充值。",false,true,nil,nil)
                return false
            end
        end
        return false
    elseif device.platform == "windows" then
        return false
    end
end

--[[
function PayHelper.umengCountPay(money, coin, source)
    if device.platform == "android" then
        local args = {
            money or 0,
            coin or 0,
            source or 0,
        }
        luaj.callStaticMethod("org.cocos2dx.lua.MobilePlate", "umengCountBuy", args, "(FFI)V")
    elseif device.platform == "ios" then
    end
end

function PayHelper.umengCountBuy(id, coin, price)
    if device.platform == "android" then
        local args = {
            id or "",
            coin or 0,
            price or 0,
        }
        luaj.callStaticMethod("org.cocos2dx.lua.MobilePlate", "umengCountBuy", args, "(Ljava/lang/String;IF)V")
    elseif device.platform == "ios" then
    end
end
]]


return PayHelper
