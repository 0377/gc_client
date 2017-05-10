//
//  Created by macos on 2017/2/5.
//
//

#import "PlatBridge.h"
#import <sys/utsname.h>
#import "Pay.h"
#import "scripting/lua-bindings/manual/platform/ios/CCLuaObjcBridge.h"
#import "scripting/lua-bindings/manual/CCLuaBridge.h"
#import "scripting/lua-bindings/manual/CCLuaValue.h"
#import "VWebView.h"
#import "UUID.h"
#import "Reachability.h"
USING_NS_CC;

int payQueryOrderTimes = 0;
int threedCallFunction = -1;

@implementation PlatBridge
+ (NSString*)checkTextType:(NSDictionary*)dict
{
    NSString * str = [dict objectForKey:@"str"];
    NSString * str1 = [dict objectForKey:@"str1"];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str1];
    /*判断是否为中文的正则表达式*/
    if([predicate evaluateWithObject:str])
    {
        //是中文
        return @"true";
    }
    else
    {
        //不是中文
        return @"false";
    }
}

+ (NSString*)getDeviceId
{
//    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
//    return identifierForVendor;
    NSString* uuid = [iosUUID getIOSUUID:@"chainkey_newbaobao"];
    return uuid ;
}
+ (NSString*)getBundleName
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleName"];
    return appName;
}
+ (NSString*)getGuestId
{
    return @"000";
}

+ (NSString*)getMobileType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    return deviceString;
}
+ (NSString*)getMacAddr
{
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    return identifierForVendor;
    
}

//+ (NSString*)getScreenRes
//{
//    NSString *str1 = [NSString stringWithFormat:@"%fX%f", ScreenRect.size.width, ScreenRect.size.height];
//    return str1;
//}

+ (NSString*)getOSVersion
{
    return [self getMobileType];
}

+ (NSString*)getChannelName
{
    return @"APP_STORE";
}
//支付
+ (void)pay:(NSDictionary *)dict
{
    NSString* goods_id = [dict objectForKey:@"goods_id"];
    NSString* order_id = [dict objectForKey:@"order_id"];
    id callback = [dict objectForKey:@"callback"];
    
    if(goods_id == nil || order_id == nil || callback == nil){
        [PlatBridge payFailed:@"支付参数为空"];
        return;
    }
    
    NSLog(@"道具购买请求 goods_id:%@  order_id:%@", goods_id, order_id);
    
    [PlatBridge showLoading];
    [[[Pay alloc] init] payRequest:dict];
}

    
+ (void)paySuccessTimer:(id) timer{
    NSDictionary* dict = [timer userInfo];
    
    
    NSString* goods_id = [dict objectForKey:@"goods_id"];
    NSString* order_id = [dict objectForKey:@"order_id"];
    NSString* iospay_key = [dict objectForKey:@"iospay_key"];
    int callback = [[dict objectForKey:@"callback"] intValue];
    
    NSLog(@"准备回调LUA goods_id:%@  order_id:%@", goods_id, order_id);
    
    [PlatBridge unshowLoading];
    
    // 1. 将引用 ID 对应的 Lua function 放入 Lua stack
    LuaObjcBridge::pushLuaFunctionById(callback);

    // 2. 将需要传递给 Lua function 的参数放入 Lua stack
    LuaValueDict item;
    item["goods_id"] = LuaValue::stringValue(goods_id.UTF8String);
    item["order_id"] = LuaValue::stringValue(order_id.UTF8String);
    item["iospay_key"] = LuaValue::stringValue(iospay_key.UTF8String);
    
    LuaObjcBridge::getStack()->pushLuaValueDict(item);
    // 3. 执行 Lua function
    LuaObjcBridge::getStack()->executeFunction(1);
    // 4. 释放引用 ID
    LuaObjcBridge::releaseLuaFunctionById(callback);
}
    

    
+ (void)paySuccess:(NSDictionary *)goodsDict
{
    NSURL *encodeData = [goodsDict objectForKey:@"appleData"];
    NSData *receiptData = [NSData dataWithContentsOfURL:encodeData];
    
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    [goodsDict setValue:encodeStr forKey:@"iospay_key"];
    
    payQueryOrderTimes = 0;
    [PlatBridge showLoading];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(paySuccessTimer:) userInfo:goodsDict repeats:NO];
}
    
+ (void)payFailed:(NSObject*)errorMsg
{
    [PlatBridge unshowLoading];
    if (errorMsg!= nil)
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        [alter release];
    }
}
    
+ (void) showLoading
{
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    UIActivityIndicatorView *indicator = nil;
    indicator = (UIActivityIndicatorView *)[window viewWithTag:103];
    
    if (indicator == nil) {
        
        //初始化:
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, ScreenRect.size.height)];
        
        indicator.tag = 103;
        
        //设置显示样式,见UIActivityIndicatorViewStyle的定义
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        
        
        //设置背景色
        indicator.backgroundColor = [UIColor blackColor];
        
        //设置背景透明
        indicator.alpha = 0.5;
        
        //设置背景为圆角矩形
        indicator.layer.cornerRadius = 6;
        indicator.layer.masksToBounds = YES;
        //设置显示位置
        [indicator setCenter:CGPointMake(ScreenRect.size.width / 2.0, ScreenRect.size.height / 2.0)];
        
        //开始显示Loading动画
        [indicator startAnimating];
        
        [window addSubview:indicator];
        
        [indicator release];
    }
    
    //开始显示Loading动画
    [indicator startAnimating];
}

+ (void)unshowLoading
{
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    UIActivityIndicatorView *indicator = nil;
    indicator = (UIActivityIndicatorView *)[window viewWithTag:103];
    if (indicator != nil) {
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    }
}

+ (void)copyStrToShearPlate:(NSDictionary*)dict
{
    NSString * str = [dict objectForKey:@"str"];
    if (str)
    {
        NSLog(@"copy%@", str);
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = str;
    }
}

+ (void)callQQChat:(NSDictionary*)dict
{
    NSString * qqNum = [dict objectForKey:@"qqNum"];
    if (qqNum)
    {
        NSString *qq=[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qqNum];
        NSURL *url = [NSURL URLWithString:qq];
       if ( [[UIApplication sharedApplication] canOpenURL:url])
       {
            [[UIApplication sharedApplication] openURL:url];
       }else
       {
           UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"启动QQ失败,请检查是否安装有QQ客户端。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
           [alter show];
           [alter release];
       }
    }
}

+ (void)showWebView:(NSDictionary *)dict
{
    NSString *url = [dict objectForKey:@"url"];
    NSString *title = [dict objectForKey:@"title"];
    int callback = [[dict objectForKey:@"callback"] intValue];
    NSString* strArgs = [dict objectForKey:@"args"];
    
    
    AppController *appController = (AppController *)[UIApplication sharedApplication].delegate;
    UIViewController *viewController = (UIViewController *)appController.viewController;
    
    VWebView *vWebView = [[VWebView alloc] initWithFrame:viewController.view.bounds callback:callback args:strArgs];
    [vWebView setUrl:url];

    [vWebView setTitle:title];  
    [viewController.view addSubview:vWebView];
}

+ (NSString*)openBrowser:(NSDictionary *)dict
{
    NSString *url = [dict objectForKey:@"strUrl"];
    BOOL openURL =[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    if(openURL)
    {
        return @"true";
    }else
    {
        return @"false";
    }
}

+ (NSString*)getThreedAppUrl:(NSDictionary*)dict
{
    NSArray* urlTypes = [NSBundle mainBundle].infoDictionary[@"CFBundleURLTypes"];
    NSDictionary* dir = [urlTypes objectAtIndex:0];
    NSArray* urlschemes = [dir objectForKey:@"CFBundleURLSchemes"];
    return [urlschemes objectAtIndex:0];
}


+ (void)threedAppCallBack:(NSURL*)url
{
    auto engine = LuaEngine::getInstance();
    lua_State* luaState = engine->getLuaStack()->getLuaState();
//    取得函数
    lua_getglobal(luaState, "GameManager");
    lua_getfield(luaState, -1, "getInstance");
    lua_pushvalue(luaState, -2);
    if (lua_pcall(luaState,1,1,0) == 0)//调用getInstance
    {
        lua_getfield(luaState, -1, "threedCallFunction");
        lua_pushvalue(luaState, -2);

        const char* urlStr = [[url scheme] UTF8String];
        const char* para = [[url host] UTF8String];

        lua_pushlstring(luaState, urlStr, strlen(urlStr));
        if (para != nil)
        {
            lua_pushlstring(luaState, para,  strlen(para));
        }else
        {
            lua_pushnil(luaState);
        }

        if (lua_pcall(luaState,3,0,0) == 0)
        {

        }
        else
        {
            const char* errstr = lua_tostring(luaState, -1);
            CCLOG("%s:%d(%s)", __FILE__, __LINE__, errstr);
            lua_pop(luaState, 1);
        }

    }
    else
    {
        const char* errstr = lua_tostring(luaState, -1);
        CCLOG("%s:%d(%s)", __FILE__, __LINE__, errstr);
        lua_pop(luaState, 1);
    }
}


+ (NSString*)canOpenURL:(NSDictionary *)dict
{
    NSString *url = [dict objectForKey:@"strUrl"];
    BOOL openURL = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
    if(openURL)
    {
        return @"true";
    }else
    {
        return @"false";
    }

}

+ (int)getBatteryLevel
{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    return [UIDevice currentDevice].batteryLevel * 100;
}

+ (int)getBatteryStatus
{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    return [UIDevice currentDevice].batteryState;
}

+ (int)getConnectivityType
{
    Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    return internetStatus;
}

+ (int)getMobileSignalLevel
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSString *dataNetworkItemView = nil;
//    NSString *wifiNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarSignalStrengthItemView") class]]) {
            dataNetworkItemView = subview;
        }
//        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
//            wifiNetworkItemView = subview;
//        }
    }
    
    int carrierSignalStrength = [[dataNetworkItemView valueForKey:@"signalStrengthRaw"] intValue];
//    int wifiSignalStrength = [[wifiNetworkItemView valueForKey:@"wifiStrengthRaw"] intValue];
    return carrierSignalStrength;
}

+ (int)getWifiSignalLevel
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    UIView *dataNetworkItemView = nil;
    
    for (UIView * subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    int signalStrength = [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] intValue];
    
   // NSLog(@"wifiStrengthBars %d", signalStrength);
    return signalStrength;
}

@end
