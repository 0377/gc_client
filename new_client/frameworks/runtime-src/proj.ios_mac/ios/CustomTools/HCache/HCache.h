//
//  HCache.h
//  DownLoadCacheDemo
//
//  Created by Xes.Sky.Macbook on 14-6-6.
//  Copyright (c) 2014年 Xes.Sky.Macbook. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^resultData)(NSDictionary* dataInfo);
@interface HCache : NSData

/**
*  缓存 （图片 切记用主线程渲染,否则会延迟渲染）
*
*  @param url        文件UR
*  @param resultData 回调
*
*/
-(void)getDataCache:(NSString*)url result:(resultData)resultData;

///清除缓存
+(BOOL)clearCache;

@end
