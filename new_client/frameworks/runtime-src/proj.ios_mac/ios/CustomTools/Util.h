//
//  Util.h
//  TaoXiaoCai
//
//  Created by Peter_Qin on 5/25/14.
//  Copyright (c) 2014 Peter_Qin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

/**
 *  16进制RGB值转UICOLOR
 *
 *  @param rgb 16进制值
 *
 *  @return COLOR
 */
+(UIColor*)getColorFromRGB:(int) rgb;

/**
 *  16进制RGB值字符串转换成UICOLOR
 *
 *  @param colorStr RGB16进制字符串
 *
 *  @return COLOR
 */
+(UIColor *)getColorFromRGBString:(NSString*)colorStr;

/**
 *  将串转换成MD5的形式
 *
 *  @param md5Str 需要转换的串
 *
 *  @return MD5字符串
 */
+(NSString *)getMD5:(NSString*)md5Str;

/**
 *  判断字符串是否为Email
 *
*  @param str 需要判断的字符串
 *
 *  @return 返回True Or False
 */
+(BOOL)isEmail:(NSString*)str;

/**
 *  判断字符串是否为电话号码
 *
 *  @param str 需要判断的字符串
 *
 *  @return True Or False
 */
+(BOOL)isPhone:(NSString*)str;

/**
 *  套小菜Pin_Code生成
 *
 *  @param callType 调用类型(查询=0,更新=1)
 *  @param callSN 命令代码编号(这个后台提供)
 *
 *  @return Pin_code（MD5）
 */
+(NSString*)makeTXCMD5CodeFromCallType:(NSString*)callType CallSN:(NSString*)callSN;

/**
 *  时间戳转字符串
 *
 *  @param timeStr 时间戳
 *
 *  @return 正常字符串
 */
+(NSString*)getDateFromS1970:(NSString*)timeStr;

/*
 *  返回ios版本号
 *  @return 版本号
 *
 */
+(double)getIOSVersion;
/**
 *  返回color
 *  @color
 *
 */
+(UIColor *)createColorR:(int)r G:(int)g B:(int)b;
@end
