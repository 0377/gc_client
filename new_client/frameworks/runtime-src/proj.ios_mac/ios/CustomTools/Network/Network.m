//
//  Network.m
//  TaoXiaoCai
//
//  Created by Peter_Qin on 6/7/14.
//  Copyright (c) 2014 Peter_Qin. All rights reserved.
//

#import "Network.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <netinet/in.h>

//数据个数不对报错信息
#define BODY_ERROR_COUNT(Count)  \
if (info.allKeys.count!=Count) { \
    NSLog(@"Error:%s",__func__); \
    return;                      \
}
@implementation Network
- (void)dealloc
{
    self.networkRequest.flag=NO;
    self.networkRequest=nil;
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.networkRequest=[[[NetworkRequest alloc]init]autorelease];
        self.networkRequest.delegate=self;
    }
    return self;
}

-(void)stopConection
{
    [self.networkRequest stopConnection];
}

#pragma mark NetWorkRequestDelegate
- (void)requestDidFinished:(NetworkRequest *)request params:(NSMutableData *)params CallSN:(NSString *)callSN
{
    if ([_delegate respondsToSelector:@selector(requestDidFinished:params:)]) {
        [_delegate requestDidFinished:request params:params];
    }
}
- (void)requestDidFailed:(NetworkRequest *)request error:(NSError *)error
{
    if ([_delegate respondsToSelector:@selector(requestDidFailed:error:)]) {
        [_delegate requestDidFailed:request error:error];
    }
}
- (void)requestDidTimeOut
{
    if ([_delegate respondsToSelector:@selector(requestDidTimeOut)]) {
        [_delegate requestDidTimeOut];
    }
}
@end
