//
//  NetworkRequest.m
//  TaoXiaoCai
//
//  Created by Peter_Qin on 6/6/14.
//  Copyright (c) 2014 Peter_Qin. All rights reserved.
//

#import "NetworkRequest.h"
#import "HActivity.h"
#import "JSONKIT.h"

#define TIMEOUT 7          //超时时长
static HActivity* _gactivity=nil;
static UIView * activityView=nil;
@implementation NetworkRequest

-(void)dealloc
{
    self.flag=NO;
    self.receiveData=Nil;
    self.delegate=nil;
    self.timeOur=nil;
    self.delegate=nil;
    [self stopConnection];
    [_gactivity stopAnimating];
//    [_gactivity release];
//    _gactivity=nil;
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.flag=YES;
        _callSN=@"0";
    }
    return self;
}

#pragma mark Get
- (void)getUrlString:(NSString *)urlString withDelegate:(id<NetWorkRequestDelegate>)sender
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:30.0];

    _connection = [[NSURLConnection connectionWithRequest:request delegate:self] retain];
    [self setDelegate:sender];
    [self activity];
    [request setTimeoutInterval:TIMEOUT];
    self.timeOur=[NSTimer scheduledTimerWithTimeInterval:TIMEOUT target:self selector:@selector(timeOutMethods) userInfo:nil repeats:NO];
}

#pragma mark POST
-(void)postUrlString:(NSString *)urlString
          bodyString:(NSString *)bodyString
        withDelegate:(id<NetWorkRequestDelegate>)sender
              callSN:(NSString*)callSN
       chrysanthemum:(BOOL)chrysanthemum
{
    _callSN=callSN;
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:TIMEOUT];
    [request setHTTPBody:data];
    
    _connection = [[NSURLConnection connectionWithRequest:request delegate:self] retain];
    [self setDelegate:sender];
    if (chrysanthemum) {
        [self activity];
    }
    
    self.timeOur=[NSTimer scheduledTimerWithTimeInterval:TIMEOUT target:self selector:@selector(timeOutMethods) userInfo:nil repeats:NO];

}

#pragma mark ---gactivity---
-(void)activity
{
    if (!_gactivity) {
        _gactivity=[[HActivity alloc]init];
        activityView = [[UIView alloc] initWithFrame:ScreenRect];
        [activityView addSubview:_gactivity];
        activityView.backgroundColor = [UIColor clearColor];
        [[[UIApplication sharedApplication]keyWindow] addSubview:activityView];
    }
    activityView.userInteractionEnabled = YES;
    [_gactivity startAnimating];
    
}

#pragma mark ---StopConnection(停止连接)---
-(void)stopConnection
{
    [_connection cancel];
    activityView.userInteractionEnabled = NO;
    [_gactivity stopAnimating];
    _connection = nil;
}

#pragma mark NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.receiveData = [NSMutableData dataWithCapacity:100];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receiveData appendData:data];
//    NSLog(@"data1 = %@",[_receiveData objectFromJSONData]);
}

#pragma mark NetWorkRequestDelegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSLog(@"data2 = %@",[_receiveData objectFromJSONData]);
    [_timeOur invalidate];
    
    if (_gactivity) {
        [_gactivity stopAnimating];
        activityView.userInteractionEnabled = NO;
    }
    if (_delegate==nil) {
        return;
    }
    if (_flag) {

        if ([_delegate respondsToSelector:@selector(requestDidFinished:params:CallSN:)]) {
            [_delegate requestDidFinished:self params:_receiveData CallSN:_callSN];
        }
    }
}

- (void)requestDidFailed:(NetworkRequest *)request error:(NSError *)error
{
    [_connection cancel];
    [_timeOur invalidate];
    [_gactivity stopAnimating];
    activityView.userInteractionEnabled = NO;
    if (_flag) {
        
        if ([_delegate respondsToSelector:@selector(requestDidFailed:error:)]) {
            [_delegate requestDidFailed:request error:error];
        }
    }
}


#pragma mark ---timeOutMethods(超时操作)---
-(void)timeOutMethods
{
    [_connection cancel];
    [_gactivity timeOut];
    activityView.userInteractionEnabled = NO;
    if (_flag) {
        if ([_delegate respondsToSelector:@selector(requestDidTimeOut)])
        {
            [_delegate requestDidTimeOut];
            
        }
    }
}



@end
