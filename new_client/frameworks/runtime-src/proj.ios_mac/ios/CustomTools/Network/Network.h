//
//  Network.h
//  TaoXiaoCai
//
//  Created by Peter_Qin on 6/7/14.
//  Copyright (c) 2014 Peter_Qin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"



@protocol NetWorkDelegate <NSObject>

/**
 *  请求成功
 *
 *  @param request  NetWorkRequest对象
 *  @param params  服务器返回的数据
 */
- (void)requestDidFinished:(NetworkRequest *)request params:(NSMutableData *)params;

/**
 *  请求失败
 *
 *  @param request NetWorkRequest对象
 *  @param error   服务器返回错误的数据
 */
- (void)requestDidFailed:(NetworkRequest *)request error:(NSError *)error;

/**
 *  请求超时
 */
- (void)requestDidTimeOut;

/**
 *  发送错误信息
 *
 *  @param request 错误信息
 */
-(void)sendTheWrongInformation:(NSString*)request;

@end


@interface Network : NSObject<NetWorkRequestDelegate>

@property(retain,nonatomic)NetworkRequest* networkRequest;
@property(assign,nonatomic)id<NetWorkDelegate>delegate;

-(void)postCdkey:(NSString *)str;
-(void)stopConection;



@end



