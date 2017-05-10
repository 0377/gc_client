//
//  Util.m
//  TaoXiaoCai
//
//  Created by Peter_Qin on 5/25/14.
//  Copyright (c) 2014 Peter_Qin. All rights reserved.
//

#import "Util.h"
#import <CommonCrypto/CommonDigest.h>


@implementation Util

+(UIColor*)getColorFromRGB:(int) rgb{
    return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0];
}

+(UIColor *)getColorFromRGBString:(NSString*)colorStr
{
    unsigned int r,g,b;
    NSRange range = NSMakeRange(0, 2);
    NSString *string = [colorStr substringWithRange:range];
    [[NSScanner scannerWithString:string] scanHexInt:&r];
    
    range = NSMakeRange(2, 2);
    string = [colorStr substringWithRange:range];
    [[NSScanner scannerWithString:string] scanHexInt:&g];
    
    range = NSMakeRange(4, 2);
    string = [colorStr substringWithRange:range];
    [[NSScanner scannerWithString:string] scanHexInt:&b];
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

+(NSString *)getMD5:(NSString*)md5Str
{
    if (!md5Str) {
        return  NULL;
    }
	const char*cStr =[md5Str UTF8String];
	unsigned char result[16];
	CC_MD5(cStr, strlen(cStr), result);
	return[NSString stringWithFormat:
           @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
           result[0], result[1], result[2], result[3],
           result[4], result[5], result[6], result[7],
           result[8], result[9], result[10], result[11],
           result[12], result[13], result[14], result[15]
           ];
}

+(BOOL)isEmail:(NSString*)str
{
    NSString *Regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [emailTest evaluateWithObject:str];
}

+(BOOL)isPhone:(NSString*)str
{
    NSString* Regex=@"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate* phoneTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",Regex];
    return [phoneTest evaluateWithObject:str];
}

#pragma mark TaoXiaoCai用
+(NSString*)makeTXCMD5CodeFromCallType:(NSString*)callType CallSN:(NSString*)callSN
{
    static NSString* code=@"TXC1864";
    NSString* md5Code=[NSString stringWithFormat:@"%@%@%@",callType,code,callSN];
    return [Util getMD5:md5Code];
}

+(NSString*)getDateFromS1970:(NSString*)timeStr
{

    NSDate* date=[NSDate dateWithTimeIntervalSince1970:timeStr.doubleValue/1000];
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY.MM.dd HH:mm"];
    return [formatter stringFromDate:date];
}

+(double)getIOSVersion
{
     return [[UIDevice currentDevice].systemVersion doubleValue];
}

+(UIColor *)createColorR:(int)r G:(int)g B:(int)b
{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

@end
