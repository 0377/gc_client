CustomHelper = class("CustomHelper");
local json = require("cjson");
function CustomHelper.seekNodeByName(parent, name)
	return ccui.Helper:seekWidgetByName(parent,name);
end
function CustomHelper.checkIsChineseText(str)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    return CustomHelper.checkTextType(str,"^[\\u4e00-\\u9fa5·]+$")
end


function CustomHelper.checkTextType(str,str1)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if targetPlatform == cc.PLATFORM_OS_ANDROID then
        local luaj = require("cocos.cocos2d.luaj")
        local Android_ClassName = "org.cocos2dx.lua.MobilePlate"
        local args = {str,str1};
        dump(args, "args", 100)
        local ok, ret = luaj.callStaticMethod(Android_ClassName, "checkTextType",args,"(Ljava/lang/String;Ljava/lang/String;)Z");
        -- print("android CustomHelper.checkIsChineseText ok:",ok,"ret:",ret)
        if ok then
            --todo
            return ret
        end
        return false;
    elseif targetPlatform == cc.PLATFORM_OS_IPHONE or targetPlatform == cc.PLATFORM_OS_IPAD then
        local IOS_ClassName =  "PlatBridge"
        local luaoc = require("cocos.cocos2d.luaoc")
        local args = {
            str = str,
            str1 = str1
        }
        local ok, ret = luaoc.callStaticMethod(IOS_ClassName,"checkTextType",args)
        print("ok:",ok,"ret:",ret)
        if ok then
            --todo
            if ret == "true" then
                return true
            elseif ret == "false" then
                return false
            end

            return ret
        end
        return false;
    else
        return true;
    end
end





--转化数值
function CustomHelper.tonumber(numStr)
    local   num = tonumber(numStr);
    if num == nil then
        --todo
        num = 0;
    end
    return num;
end
function CustomHelper.tobool(v)
    if v == nil then
        --todo
        return false;
    end
    if type(v) == "boolean" then
        return v;
    else
        local number = CustomHelper.tonumber(v)
        if number == 0 then
            --todo
            return false;
        end
        return true;
    end
end
function CustomHelper.seekNodeByName(node, key)
    if node == nil then
        return nil;
    end
    -- print("------------key:"..key);
    if node:getName() == key then
        return node;
    end    
    local childrenTab = node:getChildren();
    for _, v in ipairs(childrenTab) do
        local res = CustomHelper.seekNodeByName(v,key);
        if res then
            --todo
            return res;
        end
    end
    return nil;
end
function CustomHelper.addSetterAndGetterMethod(obj,property,default)
    if obj == nil or property == nil then
        --todo
        return;
    end
    local member = property
    obj[member] = default
    local ucMember = string.ucfirst(member)
    obj['get' .. ucMember] = function(this) return this[member] end
    obj['set' .. ucMember] = function(this, value) this[member] = value end
end
--打印调用栈
function CustomHelper.printStack()
    print(debug.traceback() )
end
--更新json table 数据
function CustomHelper.updateJsonTab(targetTab,sourceTab)
    if sourceTab == nil then
        return;
    end
    -- dump(sourceTab, "sourceTab");
    if table.nums(sourceTab) <= 0 then
        --todo
        return;
    end 
    --遍历sourceTab
    for key, sourceValue in pairs(sourceTab) do    
        local targetValue = targetTab[key];  
        local sourceValueType = type(sourceValue);
        local targetValueType = type(targetValue);
        if sourceValueType ~= targetValueType then
            targetTab[key] = nil;
            targetTab[key] = sourceValue;
        elseif sourceValueType == "table" then
            if table.nums(sourceValue) == 0 then
                --todo
                targetTab[key] = nil;
            else
                -- dump(sourceValue, "sourceValue");
                if sourceValueType[1] == nil then --是数组，直接覆盖
                    --todo
                    dump(sourceValue, "key:"..key, nesting)
                    targetTab[key] = sourceValue
                else
                    CustomHelper.updateJsonTab(targetValue, sourceValue);
                end   
            end
        else
            targetTab[key] = sourceValue;
        end
    end    
    
end
function CustomHelper.copyTab(st)
    if st == nil then
        --todo
        return nil;
    end
    local tab = {}
    for k, v in pairs(st or {}) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = CustomHelper.copyTab(v)
        end
    end
    return tab
end
function CustomHelper.getWinSize()
    local size = cc.Director:getInstance():getWinSize();
    return size;
end
function CustomHelper.getJsonTabWithJsonStr(jsonStr)
    local jsonTab = json.decode(jsonStr);
    if jsonTab == json.null then
         --todo
         jsonTab = nil;
    end
    return jsonTab
end
function CustomHelper.getJsonStrWithJsonTab(jsonTab)
    return json.encode(jsonTab);
end
function CustomHelper.createJsonTabWithFilePath(path)
    local jsonStr = cc.FileUtils:getInstance():getStringFromFile(path)
    return json.decode(jsonStr)
end
function CustomHelper.addIndicationTip(tipStr,parent,delay)
    CustomHelper.removeIndicationTip()
    local IndictationLayer = requireForGameLuaFile("IndictationLayer");
    if parent == nil then
        --todo
        parent = cc.Director:getInstance():getRunningScene();
    end
    IndictationLayer:getInstance():addIndicationTip(tipStr,parent,delay);
end
function CustomHelper.removeIndicationTip()
    local IndictationLayer = requireForGameLuaFile("IndictationLayer");
    IndictationLayer:getInstance():removeIndicationTip();
end
--弹出框提示
function CustomHelper.showAlertView(content,showCancelBtn,showConfirmBtn,cancelCallbackFunc,confirmCallbackFunc)
    local TipLayer = requireForGameLuaFile("TipLayer"); 
    local tipLayer = TipLayer:create();
    tipLayer:showAlertView(content,showCancelBtn,showConfirmBtn,cancelCallbackFunc,confirmCallbackFunc)
    local tipLayerName = CustomHelper.md5String(content)
    tipLayer:setName(tipLayerName);
    local parent = cc.Director:getInstance():getRunningScene();
    if parent:getChildByName(tipLayerName)  then
        --todo
        return tipLayer;
    end
    parent:addChild(tipLayer,1000);
    return tipLayer;
end


--去充值弹出框提示
function CustomHelper.showLackMoneyAlertView(compareMoney,needMoneyTip,cancalCallbackFunc,bankCallbackFunc,storyCallbackFunc,closeCallbackFunc)
    local myPlayerInfo = GameManager:getInstance():getHallManager():getPlayerInfo();
    
    local  money = myPlayerInfo:getMoney()
    local  bank = myPlayerInfo:getBank()
    if money >= compareMoney then return false end
    local TipLayer = requireForGameLuaFile("TipLayer"); 
    local tipLayer = TipLayer:create();
    if money + bank >= compareMoney then --银行有钱足够，可以去提款
         tipLayer:showLackMoneyAlertView(needMoneyTip,"bank","story",bankCallbackFunc,storyCallbackFunc,closeCallbackFunc)
    else --银行有钱不过，去充值
         tipLayer:showLackMoneyAlertView(needMoneyTip,nil,"story",cancalCallbackFunc,storyCallbackFunc,closeCallbackFunc)
    end

    local tipLayerName = CustomHelper.md5String(content)
    tipLayer:setName(tipLayerName);
    local parent = cc.Director:getInstance():getRunningScene();
    if parent:getChildByName(tipLayerName)  then
        --todo
        return tipLayer;
    end
    parent:addChild(tipLayer,1000);
    return true;

    
end

--md5文件
function CustomHelper.md5File(filePath)
    -- body
    return myLua.LuaBridgeUtils:md5File(filePath);
end
function CustomHelper.md5String(string)
    return myLua.LuaBridgeUtils:md5String(string);
end
function CustomHelper.removeItem(tab,value)
    local i = 1
    while tab[i] do
        if tab[i] == value then
            table.remove(tab,i)
        else
            i = i+1
        end
    end 
end
function CustomHelper.writeStringToFile(str,filePath)
    local fileUtils = cc.FileUtils:getInstance();
    if fileUtils:isFileExist(filePath) then
        --todo
        fileUtils:removeFile(filePath);
    end
    local fileDir = CustomHelper.getFilePathDirectory(filePath);
    if fileUtils:isDirectoryExist(fileDir) ~= true then
        --todo
        fileUtils:createDirectory(fileDir);
    end
    fileUtils:writeStringToFile(str,filePath)
end
--获得路径文件夹
function CustomHelper.getFilePathDirectory(path)
   return myLua.LuaBridgeUtils:getFilePathDirectory(path);
end
function CustomHelper.getFullPath(fileName)
    return cc.FileUtils:getInstance():fullPathForFilename(fileName)
end
--解压文件
function CustomHelper.decompress(zip)
    return myLua.LuaBridgeUtils:decompress(zip);
end
--重新启动游戏
function CustomHelper.restartGame()
    reloadGameLuaFiles()
    cc.FileUtils:getInstance():purgeCachedEntries();
    require("app.MyApp"):create();
end
--用于记录需要清除的缓存的lua文件
function CustomHelper.customRequireLuaFile(file)
    if CustomHelper.needUnloadFiles == nil then
        --todo
        CustomHelper.needUnloadFiles = {}
    end
    CustomHelper.needUnloadFiles[file] = file
    requireForGameLuaFile("app.MyApp"):create();
end
--清除内存数据
function CustomHelper.cleanMemeryCache()
    GameManager:getInstance():getMusicAndSoundManager():stopAllSound();
    GameManager:getInstance():getMusicAndSoundManager():stopMusic()
    local textureCache = cc.Director:getInstance():getTextureCache();
    textureCache:unbindAllImageAsync();
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames();
    cc.AnimationCache:destroyInstance();
    textureCache:removeUnusedTextures();
    local cacheInfo =  textureCache:getCachedTextureInfo();
    --print("using resource:\n%s",cacheInfo);
end
function CustomHelper.changeNodeToGray(node)
    --print("node to gray")
    return myLua.LuaBridgeUtils:changeNodeToGray(node)
end
function CustomHelper.changeNodeToNormal(node)
    return myLua.LuaBridgeUtils:changeNodeToNormal(node)
end
--得到
function CustomHelper.getOneHallGameConfigValueWithKey(key)
    local hallManager = GameManager:getInstance():getHallManager();
    local valueStr = nil;
    if hallManager then
        --todo
        valueStr = hallManager:getHallDataManager():getOneHallGameConfigValueWithKey(key);
    end
    return valueStr
end
function CustomHelper.goldToMoneyRate()
    local ratio = 100;
    local valueStr = CustomHelper.getOneHallGameConfigValueWithKey("gold_to_money_ratio");
    if valueStr then
        --todo
        ratio = tonumber(valueStr);
    end
    return ratio
end
function CustomHelper.moneyShowStyleNone(_money)
    _money = tonumber(_money) or 0
    return string.format("%.02f", _money / CustomHelper.goldToMoneyRate())
end
function CustomHelper.addWholeScrennAnim(node, callback)
    dump(123123)
    local oldAnPos = node:getAnchorPoint();
    local oldPos = cc.p(node:getPositionX(), node:getPositionY());
    node:move(oldPos.x, oldPos.y + display.height)

    local seq = cc.Sequence:create(
        cc.MoveTo:create(0.2, oldPos),
        cc.MoveBy:create(0.05, cc.p(0, 20)),
        cc.MoveBy:create(0.04, cc.p(0, -20)),
        cc.CallFunc:create(function()
            if callback then
                --todo
                callback();
            end
        end));
    node:runAction(seq);
    node._removeSelf = node.removeSelf
    node.removeSelf = function(sender)
        sender:stopAllActions()
        sender:runAction(cc.Sequence:create(
            cc.MoveBy:create(0.1, cc.p(0, display.height)),
            cc.CallFunc:create(function(sender)
                sender:setVisible(false)
                sender:_removeSelf()
            end)))
    end
end

--增加弹出动画
--增加界面弹出特效
function CustomHelper.addAlertAppearAnim(node,callback)
    local oldAnPos = node:getAnchorPoint();
    local oldPos = cc.p(node:getPositionX(),node:getPositionY());
    local isIgnoreAnchorPointForPosition = node:isIgnoreAnchorPointForPosition();
    node:setAnchorPoint(cc.p(0.5,0.5));
    if isIgnoreAnchorPointForPosition == false then
        --todo
        local size = node:getContentSize();
        local newAnpos = node:getAnchorPoint();
        local newPos = cc.p(oldPos.x + size.width * (newAnpos.x - oldAnPos.x), oldPos.y + size.height * (newAnpos.y - oldAnPos.y));
            -- dump(newPos, "newPos()", nesting)
        node:setPosition(newPos);
    end
    node:setScale(0.5);
    local seq = cc.Sequence:create(
            -- cc.EaseExponentialIn:create(cc.ScaleTo:create(0.10,1.1)),
            cc.ScaleTo:create(0.05,0.7),
            cc.ScaleTo:create(0.05,1.1),
            cc.ScaleTo:create(0.04,1.06),
            cc.ScaleTo:create(0.03,1),
            cc.CallFunc:create(function()
                node:setAnchorPoint(oldAnPos);
                node:setPosition(oldPos);
                if callback then
                    --todo
                    callback();
                end
            end)
        );
    node:runAction(seq);
end
--增加弹出界面关闭动画
function CustomHelper.addCloseAnimForAlertView(node,callback)
    --[[
    0秒     100%          0.07秒    106%          0.13秒  85%            0.2秒     50%                 紧接着消失

    ]]
    local oldAnPos = node:getAnchorPoint();
    local oldPos = cc.p(node:getPositionX(),node:getPositionY());
    local isIgnoreAnchorPointForPosition = node:isIgnoreAnchorPointForPosition();
    node:setAnchorPoint(cc.p(0.5,0.5));
    if isIgnoreAnchorPointForPosition == false then
        --todo
        local size = node:getContentSize();
        local newAnpos = node:getAnchorPoint();
        node:setPosition(cc.p(oldPos.x + size.width * (newAnpos.x - oldAnPos.x), oldPos.y + size.height * (newAnpos.y - oldAnPos.y)));
    end
    node:setVisible(true);
    node:setScale(1.0);
    local seq = cc.Sequence:create(
            -- cc.EaseExponentialIn:create(cc.ScaleTo:create(0.10,1.1)),
            cc.ScaleTo:create(0.05,1.06),
            cc.ScaleTo:create(0.04,0.85),
            cc.ScaleTo:create(0.05,0.5),
            cc.CallFunc:create(function()
                -- node:ignoreAnchorPointForPosition(isIgnoreAnchorPointForPosition);
                node:setAnchorPoint(oldAnPos);
                node:setPosition(oldPos);
                if callback then
                    --todo
                    callback();
                end
            end)
        );
    node:runAction(seq);
end
--增加按下变暗动画
function CustomHelper.addPressedDarkAnimForBtn(btn)
    btn:addTouchEventListener(function(sender,eventType)
        local tag = 100213;
        local btn = tolua.cast(sender, "ccui.Button");
        local scale9Sprite = btn:getRendererClicked();
        --print(".................eventType:"..eventType);
        if eventType == ccui.TouchEventType.began then
             scale9Sprite:setColor(cc.c3b(88, 88, 88));
             local children = btn:getChildren();
             for i,child in ipairs(children) do
                 child:setColor(cc.c3b(88, 88, 88));
             end
        elseif eventType == ccui.TouchEventType.moved then
             if not btn:isHighlighted() then
                scale9Sprite:setColor(cc.c3b(255, 255, 255));
                local children = btn:getChildren();
                 for i,child in ipairs(children) do
                     child:setColor(cc.c3b(255, 255, 255));
                 end
             end

        elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
             if not btn:isHighlighted() then
                scale9Sprite:setColor(cc.c3b(255, 255, 255));
                local children = btn:getChildren();
                for i,child in ipairs(children) do
                     child:setColor(cc.c3b(255, 255, 255));
                end
             end
        end

    end);

end

function CustomHelper.stringWidthSingle(inputstr)
    local lenInByte = #inputstr
    local width = 0
    local i = 1
    while (i<=lenInByte)
    do
        local curByte = string.byte(inputstr, i)
        local byteCount = 1;
        if curByte>0 and curByte<=127 then
        byteCount = 1
        elseif curByte>=192 and curByte<223 then
        byteCount = 2
        elseif curByte>=224 and curByte<239 then
        byteCount = 3
        elseif curByte>=240 and curByte<=247 then
        byteCount = 4
        end

        local char = string.sub(inputstr, i, i+byteCount-1)
        i = i + byteCount
        if byteCount >= 2 then
            width = width + 2
        else
            width = width + 1
        end
        
    end
    return width
end





--昵称合法性判定
function CustomHelper.isNameLegal(nameStr )
    -- body
    local errorStr = nil
    if nameStr == ""  then
        errorStr = "昵称不能为空！"
        return errorStr
    end

    print("----------1111")
    local isChineseText = CustomHelper.checkTextType(nameStr,"^[\\w\\u4e00-\\u9fa5]+$")
    if isChineseText == false then
        errorStr = "昵称不能为字母数字下划线和汉字以外的字符";
        print("----------2222")
        return errorStr
    end


    local len = CustomHelper.stringWidthSingle(nameStr)
    print("----------len"..len)
    if len > 14 then
        errorStr = "昵称不能超过7个汉字或14个字符！"
    end

    if len < 4 then
        errorStr = "昵称不得少于2个汉字或4个字符！"
    end 

    
    
    return errorStr
end



--手机号合法性判定
function CustomHelper.isPhoneNumberLegal(phoneNumStr )
    -- body
    local errorStr = nil
    if phoneNumStr == ""  then
        errorStr = "手机号码不能为空！"
        return errorStr
    end

    --号码正确格式 "全数字" or “+ 全数字”
    local isLegal = 1
    if string.sub(phoneNumStr , 1 , 1 ) == "+" then
        -- print("string.sub(phoneNumStr , 1 , 2 ) = "..string.sub(phoneNumStr , 1 , 1 ))
        isLegal = 1
        for i=2,string.len(phoneNumStr) do
            -- print("string.sub(phoneNumStr , i , i ) = "..string.sub(phoneNumStr , i , i ))
            if string.sub(phoneNumStr , i , i) < "0" or string.sub(phoneNumStr , i , i) > "9" then
                isLegal = 0;
                break
            end
        end
        if 0 == isLegal then
            errorStr = "手机号码含有非法字符" --首位为+号手机号码含有非法字符
            return errorStr
        --else
            -- print("首位为+号手机号码未含有非法字符")
            --return true
        end
        
    else
        isLegal = 1
        for i=1,string.len(phoneNumStr) do
            -- print("string.sub(phoneNumStr , i , i ) = "..string.sub(phoneNumStr , i , i ))
            if string.sub(phoneNumStr , i , i) < "0" or string.sub(phoneNumStr , i , i) > "9" then
                isLegal = 0
                break
            end
        end
        if 0 == isLegal then
            errorStr = "手机号码含有非法字符"
            return errorStr
        end
    end
        --因为手机号各个国家长度不一致，设置长度为5~14
    if string.len(phoneNumStr) > 18 or string.len(phoneNumStr) < 7 then
        errorStr = "您输入的手机号码长度不对，最少为7位，最多为18位！"
        return errorStr
    end
    
    return errorStr
end


--验证码合法性判定
function CustomHelper.isCheckNumberLegal(checkNumStr )
    -- body
    local errorStr = nil
    if checkNumStr == ""  then
        errorStr = "验证码不能为空！"
        return errorStr
    end

    --号码正确格式 "全数字" or “+ 全数字”
    local isLegal = 1
    if true then
        isLegal = 1
        for i=1,string.len(checkNumStr) do
            -- print("string.sub(phoneNumStr , i , i ) = "..string.sub(phoneNumStr , i , i ))
            if string.sub(checkNumStr , i , i) < "0" or string.sub(checkNumStr , i , i) > "9" then
                isLegal = 0
                break
            end
        end
        if 0 == isLegal then
            errorStr = "验证码含有非法字符"
            return errorStr
        end
    end
        --长度6
    if string.len(checkNumStr) ~= 6 then
        print("----len"..string.len(checkNumStr))
        errorStr = "请输入正确的6位数字短信验证码！"
        return errorStr
    end
    
    return errorStr
end




--密码合法性判定
function CustomHelper.isPasswordNumberLegal(pwdTextStr )
    -- body
    local errorStr = nil
    
    
    local pwdLength = string.len(pwdTextStr);
	print("pwdLength:",pwdLength,"")
	local minLen = 6
	local maxLen = 18
	if errorStr == nil and pwdTextStr == "" then
		--todo
		errorStr = "请输入密码"
	end

    local iswords = CustomHelper.checkTextType(pwdTextStr,"^[A-Za-z0-9_]+$")
    --if iswords == false or iswords == "false" then

    if errorStr == nil and iswords == false then
        errorStr = "密码只能有字母,数字,下划线组成";
    end

	if errorStr == nil and pwdLength < minLen or pwdLength > maxLen then
		--todo
		errorStr = string.format("您输入的密码长度不对，密码最少为%d位,最多为%d位!", minLen,maxLen)
	end

    return errorStr
end











--检测是否是邮箱格式
function CustomHelper.checkIsEmailFormat(str)
    if string.len(str or "") < 6 then return false end  
    local b,e = string.find(str or "", '@')  
    local bstr = ""  
    local estr = ""  
    if b then  
     bstr = string.sub(str, 1, b-1)  
     estr = string.sub(str, e+1, -1)  
    else  
     return false  
    end  
  
    -- check the string before '@'  
    local p1,p2 = string.find(bstr, "[%w_]+")  
    if (p1 ~= 1) or (p2 ~= string.len(bstr)) then return false end  
  
  
    -- check the string after '@'  
    if string.find(estr, "^[%.]+") then return false end  
    if string.find(estr, "%.[%.]+") then return false end  
    if string.find(estr, "@") then return false end  
    if string.find(estr, "[%.]+$") then return false end  
  
  
    _,count = string.gsub(estr, "%.", "")  
    if (count < 1 ) or (count > 3) then  
     return false  
    end  
  
  
    return true 
end
function CustomHelper.unscheduleGlobal(handle)
    if handle then
        --todo
        local scheduler = cc.Director:getInstance():getScheduler()
        scheduler:unscheduleScriptEntry(handle);
    end
end
--isRepeat 是否循环
function CustomHelper.performWithDelayGlobal(callback,delay,isRepeat)
    -- body
    if isRepeat == nil then
        --todo
        isRepeat = false;
    end
    local handle
    local scheduler = cc.Director:getInstance():getScheduler()
    handle = scheduler:scheduleScriptFunc(function()
        if isRepeat == false then
            --todo
            CustomHelper.unscheduleGlobal(handle)
        end
        callback()
    end,delay, false)
    return handle
end
function CustomHelper.postOneNotify(notifyStr,userInfo)
    local event = cc.EventCustom:new(notifyStr);
    if userInfo ~= nil then
        --todo
        event.userInfo = userInfo;
    end
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event);
end
function CustomHelper.getCharacterCountInUTF8String(utf8Str)
    return myLua.LuaBridgeUtils:getCharacterCountInUTF8String(utf8Str);
end
function CustomHelper.decodeURI(s)
    return string.urldecode(s)
    -- s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    -- return s
end
function CustomHelper.encodeURI(s)
    return string.urlencode(s);
    -- s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    -- return string.gsub(s, " ", "+")
end

--是否苹果审核状态
function CustomHelper.isExaminState()
    -- local rechargeType =  CustomHelper.getOneHallGameConfigValueWithKey("recharge_types")
    -- dump(rechargeType)
    -- return  device.platform == "ios" and rechargeType.iospay

    local rechargeType =  CustomHelper.getOneHallGameConfigValueWithKey("recharge_types")
    if device.platform == "ios" then
        return rechargeType.iospay
    elseif device.platform == "android" then
        return rechargeType.androidpay
    else
        return false
    end 
end
--判断节点是否是适合指针
function CustomHelper.isLuaNodeValid(node)
	return(node and not tolua.isnull(node))
end