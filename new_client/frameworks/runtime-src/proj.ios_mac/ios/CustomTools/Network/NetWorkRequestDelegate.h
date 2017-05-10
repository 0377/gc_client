//
//  NetWorkRequestDelegate.h
//  GoodSDKDP1
//
//  Created by Dale_Hui on 13-8-19.
//  Copyright (c) 2013年 Dale_Hui. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NetworkRequest;
@protocol NetWorkRequestDelegate <NSObject>

/**
 *  请求成功返回数据
 *
 *  @param request request对象
 *  @param callSN 命令代码编号(接口唯一标识)
 *  @param params  数据
 */
- (void)requestDidFinished:(NetworkRequest *)request params:(NSMutableData *)params CallSN:(NSString*)callSN;

/**
 *  请求失败返回错误信息
 *
 *  @param request request对象
 *  @param error   错误信息
 */
- (void)requestDidFailed:(NetworkRequest *)request error:(NSError *)error;

/**
 *  请求c超时
 */
- (void)requestDidTimeOut;


@end
