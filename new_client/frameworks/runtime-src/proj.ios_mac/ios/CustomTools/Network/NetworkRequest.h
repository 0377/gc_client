//
//  NetworkRequest.h
//  TaoXiaoCai
//
//  Created by Peter_Qin on 6/6/14.
//  Copyright (c) 2014 Peter_Qin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkRequestDelegate.h"

@interface NetworkRequest : NSObject<NSURLConnectionDataDelegate>
{
}
@property(assign,atomic)bool flag;
@property(retain,nonatomic)NSTimer* timeOur;
@property(retain,nonatomic)NSURLConnection* connection;
@property(retain,nonatomic)NSMutableData* receiveData;
@property(assign,nonatomic)id<NetWorkRequestDelegate> delegate;
@property(assign,nonatomic)NSString* callSN;


/**
 *  Get方式请求数据
 *
 *  @param urlString  请求地址
 *  @param sender    Delegate指针
 */
- (void)getUrlString:(NSString *)urlString withDelegate:(id<NetWorkRequestDelegate>)sender;

/**
 *  Post方式请求数据
 *
 *  @param urlString     请求地址
 *  @param bodyString    请求的Body
 *  @param sender        Delegate指针
 *  @param callSN        命令代码编号（接口唯一标识）
 *  @param chrysanthemum 是否打开菊花显示
 */
-(void)postUrlString:(NSString *)urlString
           bodyString:(NSString *)bodyString
         withDelegate:(id<NetWorkRequestDelegate>)sender
                  callSN:(NSString*)callSN
        chrysanthemum:(BOOL)chrysanthemum;

/**
 *  中断请求
 */
-(void)stopConnection;


@end
