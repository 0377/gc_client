//
//  PlatBridge.h
//  new_client
//
//  Created by macos on 2017/2/5.
//
//

#import <Foundation/Foundation.h>

@interface PlatBridge : NSObject
+ (NSString*)checkTextType:(NSDictionary*)dict;
+ (NSString*)getDeviceId;
+ (NSString*)getBundleName;
+ (NSString*)getGuestId;
+ (NSString*)getMobileType;
+ (NSString*)getMacAddr;
//+ (NSString*)getScreenRes;
+ (NSString*)getOSVersion;
+ (NSString*)getChannelName;
    
+ (void)pay:(NSDictionary *)dict;
+ (void)paySuccessTimer:(id)timer;
+ (void)paySuccess:(NSDictionary *)goodsDict;
+ (void)payFailed:(NSObject*)errorMsg;
    
+ (void)showLoading;
+ (void)unshowLoading;

//复制文本到剪贴板
+ (void)copyStrToShearPlate:(NSDictionary*)dict;
//唤起QQ
+ (void)callQQChat:(NSDictionary*)dict;

+ (void)showWebView:(NSDictionary *)dict;
+ (NSString*)openBrowser:(NSDictionary *)dict;
+ (NSString*)canOpenURL:(NSDictionary*)dict;

//获取第三方应用回调app url
+ (NSString*)getThreedAppUrl:(NSDictionary*)dict;

//第三方app回调
+ (void)threedAppCallBack:(NSURL*)url;
/**
 *	获得电池剩余电量
 *
 *	@return	剩余电量百分比,0-100
 */
+ (int)getBatteryLevel;

/**
 *	获得电池状态
 *    UIDeviceBatteryStateUnknown,
 *    UIDeviceBatteryStateUnplugged,   // on battery, discharging
 *    UIDeviceBatteryStateCharging,    // plugged in, less than 100%
 *    UIDeviceBatteryStateFull,        // plugged in, at 100%
 *	@return	电池状态枚举
 */
+ (int)getBatteryStatus;

/**
 * 获取上网类型
 */
+ (int)getConnectivityType;

/**
 * 获取网络信号
 */
+ (int)getMobileSignalLevel;

/**
 * 获取wifi信号
 */
+ (int)getWifiSignalLevel;

@end
