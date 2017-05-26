local DeviceUtils = {};
local device = require("cocos.framework.device");
local targetPlatform = cc.Application:getInstance():getTargetPlatform()
--得到手机平台
function DeviceUtils.getDevicePlatform()
	return device.platform;
end
function DeviceUtils.callStaticMethod(methodName, sig)
    --print("methodName:",methodName)
     if targetPlatform == cc.PLATFORM_OS_ANDROID then
        local luaj = require("cocos.cocos2d.luaj")
        local Android_ClassName = "org.cocos2dx.lua.MobilePlate"
        local ok, ret = luaj.callStaticMethod(Android_ClassName,methodName, nil, sig or "()Ljava/lang/String;")
        return ret
    elseif targetPlatform == cc.PLATFORM_OS_IPHONE or targetPlatform == cc.PLATFORM_OS_IPAD then
        local IOS_ClassName =  "PlatBridge"
        local luaoc = require("cocos.cocos2d.luaoc")
        local ok, ret = luaoc.callStaticMethod(IOS_ClassName,methodName)
        return ret;
    end
    return nil;
end
--获取设备model
function DeviceUtils.getDeviceModel()
    local model = DeviceUtils.callStaticMethod("getMobileType")
    if model == nil then
       model =  "Win32 Mobile Test"
    end
    return model
end
--获取设备唯一id
function DeviceUtils.getIMEIStr()
	local value = DeviceUtils.callStaticMethod("getDeviceId");
    if value == nil then
        value =  "IMEI Test"
        
        if targetPlatform == cc.PLATFORM_OS_WINDOWS then
            value = myLua.LuaBridgeUtils:getMacString()..math.random(os.time())
        end
        
    end

    return value
end
function DeviceUtils.getBundleName()
    local value = DeviceUtils.callStaticMethod("getBundleName");
    if value == nil then
        value =  "Bundle Test"
    end
    return value
end

-- 获取电量
function DeviceUtils.getBatteryLevel()
    local value = DeviceUtils.callStaticMethod("getBatteryLevel", "()I")
    if value == nil then
        value =  0
    end
    return value
end

-- 获取电池状态
function DeviceUtils.getBatteryStatus()
    local value = DeviceUtils.callStaticMethod("getBatteryStatus", "()I")
    if value == nil then
        value =  0
    end
    return (value == 2)
end

-- 获取网络类型
function DeviceUtils.getConnectivityType()
    local value = DeviceUtils.callStaticMethod("getConnectivityType", "()I")
    if value == nil then
        value =  0
    end
    return value
end

-- 获取网络信号
function DeviceUtils.getMobileSignalLevel()
    local value = DeviceUtils.callStaticMethod("getMobileSignalLevel", "()I")
    if value == nil then
        value =  0
    end
    return value
end

-- 获取wifi信号
function DeviceUtils.getWifiSignalLevel()
    local value = DeviceUtils.callStaticMethod("getWifiSignalLevel", "()I")
    if value == nil then
        value =  0
    end
    return value
end

return DeviceUtils;
