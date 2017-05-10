#import "VWebView.h"
#import "PlatBridge.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "scripting/lua-bindings/manual/platform/ios/CCLuaObjcBridge.h"

@interface VWebView()
{
    BOOL isLoadingFinished;
    int _callback;
    NSString* _args;
    BOOL isCallBackFunc;
    UIWebView * _webView;
    UILabel* _label_title;
}

@end


@implementation VWebView

- (id)initWithFrame:(CGRect)frame callback:(int)nCallback args:(NSString*)strArgs
{
    BOOL isWeiXinPay = true;
    if([strArgs isEqual: @"alipay"])
    {
        isWeiXinPay = false;
        frame = CGRectMake(0, 0, 0, 0);
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        _webView = [[[UIWebView alloc] init] autorelease];
        _webView.layer.anchorPoint = CGPointMake(0.0, 0.0);
        _webView.delegate = self;
        _webView.center = CGPointMake(0, 0);
        _webView.backgroundColor = [UIColor whiteColor];
        [_webView.layer setMasksToBounds:YES];
        [self addSubview:_webView];
        
        _webView.frame = CGRectMake(frame.origin.x , frame.origin.y + 50, frame.size.width, frame.size.height - 50);
        
        isLoadingFinished = NO;
        isCallBackFunc = NO;
        _callback = nCallback;
        _args = [[NSString alloc] initWithString:strArgs];
        
        [_webView setScalesPageToFit:YES];
        if(isWeiXinPay)
        {
            UIImageView* bg = [TQTools
                           imageWithName:@"bg_title.9.png"
                           Anchor:CGPointMake(0.0, 0.0)
                           Position:CGPointMake(0, 0)
                           Enable:true];
            bg.frame = CGRectMake(0, 0, _webView.frame.size.width, 50);
    
            [self addSubview:bg];
    
            UIButton * btn_back = [TQTools
                                   buttonWithImage:@"btn_back.png"
                                   Target:self
                                   Select:@selector(_onBtn_back:)
                                   Anchor:CGPointMake(0.0, 0.0)
                                   Position:CGPointMake(10, 5)];
            [btn_back setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed.png"] forState:UIControlStateSelected];
            [self addSubview:btn_back];
    
            UIButton * btn_close = [TQTools
                                   buttonWithImage:@"btn_close_1.png"
                                   Target:self
                                   Select:@selector(closeMy:)
                                   Anchor:CGPointMake      (1.0, 0.0)
                                   Position:CGPointMake(_webView.frame.size.width - 10, 8)];
            [btn_close setBackgroundImage:[UIImage imageNamed:@"btn_close_1_pressed.png"] forState:UIControlStateSelected];
            [self addSubview:btn_close];
            
            [btn_close addTarget:self action:@selector(closeMy:) forControlEvents:UIControlEventTouchUpInside];
        }

        _label_title = [TQTools
                                labelWithText:@""
                                Font: [UIFont systemFontOfSize:32]
                                Anchor:CGPointMake      (0.5, 0.5)
                                Position:CGPointMake(_webView.frame.size.width / 2, 25)];
        [self addSubview:_label_title];

        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver: self
                   selector: @selector(closeMy:)
                       name: UIApplicationDidBecomeActiveNotification
                     object: nil];
    }
    return self;
}

- (id)initWithLocalFrame:(CGRect)frame Js:(NSString*)localUrl
{
    self = [super initWithFrame:frame];
    if (self) {
        _webView = [[[UIWebView alloc] init] autorelease];
        _webView.layer.anchorPoint = CGPointMake(0.0, 0.0);
        _webView.delegate = self;
        _webView.frame = CGRectMake(frame.origin.x , frame.origin.y + 50, frame.size.width, frame.size.height);
        _webView.center = CGPointMake(0, 0);
        _webView.backgroundColor = [UIColor whiteColor];
        [_webView.layer setMasksToBounds:YES];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
        NSURL * url = [NSURL fileURLWithPath:path];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
        NSLog(@" nfdsfsd");
        JSContext *context = [_webView valueForKeyPath: @"documentView.webView.mainFrame.javaScriptContext"];
        context[@"getUrl"] = ^(){
            return localUrl;
        };
        [self addSubview:_webView];
        
        isLoadingFinished = NO;
        UIImageView* bg = [TQTools
                           imageWithName:@"bg_title.9.png"
                           Anchor:CGPointMake(0.0, 0.0)
                           Position:CGPointMake(0, 0)
                           Enable:true];
        bg.frame = CGRectMake(0, 0, _webView.frame.size.width, 50);
        
        [self addSubview:bg];
        
        UIButton * btn_back = [TQTools
                               buttonWithImage:@"btn_back.png"
                               Target:self
                               Select:@selector(_onBtn_back:)
                               Anchor:CGPointMake(0.0, 0.0)
                               Position:CGPointMake(10, 5)];
        [btn_back setBackgroundImage:[UIImage imageNamed:@"btn_back_pressed.png"] forState:UIControlStateSelected];
        [self addSubview:btn_back];
        
        UIButton * btn_close = [TQTools
                                buttonWithImage:@"btn_close_1.png"
                                Target:self
                                Select:@selector(closeMy:)
                                Anchor:CGPointMake      (1.0, 0.0)
                                Position:CGPointMake(_webView.frame.size.width - 10, 8)];
        [btn_close setBackgroundImage:[UIImage imageNamed:@"btn_close_1_pressed.png"] forState:UIControlStateSelected];
        [self addSubview:btn_close];
        

        [btn_close addTarget:self action:@selector(closeMy:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _label_title = [TQTools
                        labelWithText:@""
                        Font: [UIFont systemFontOfSize:32]
                        Anchor:CGPointMake      (0.5, 0.5)
                        Position:CGPointMake(_webView.frame.size.width / 2, 25)];
        [self addSubview:_label_title];

        
    }
    return self;
}


- (void)_onBtn_back:(UIButton *)sender
{
    [self closeMy:sender];
}

- (void)closeMy:(UIButton *)sender
{
    [PlatBridge unshowLoading];

    if(_callback != 0 ){
        // 1. 将引用 ID 对应的 Lua function 放入 Lua stack
        cocos2d::LuaObjcBridge::pushLuaFunctionById(_callback);
        // 2. 将需要传递给 Lua function 的参数放入 Lua stack

        cocos2d::LuaObjcBridge::getStack()->pushString([_args cStringUsingEncoding:NSUTF8StringEncoding]);
        // 3. 执行 Lua function
        cocos2d::LuaObjcBridge::getStack()->executeFunction(1);
        // 4. 释放引用 ID
        cocos2d::LuaObjcBridge::releaseLuaFunctionById(_callback);
    }


    [super close:sender];
}

- (void)setTitle:(NSString*)title
{
    [_label_title setText:title];

    CGSize textSize = [title sizeWithFont:[UIFont systemFontOfSize:32]
                        constrainedToSize:CGSizeMake(CGRectGetWidth(ScreenRect), 400)
                            lineBreakMode:NSLineBreakByWordWrapping
                        ];
    
    [_label_title setFrame:CGRectMake(_webView.frame.size.width / 2 - textSize.width / 2, 25 - textSize.height / 2, textSize.width, textSize.height)];
}

- (void)setUrl:(NSString*)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [_webView loadRequest:request];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* scheme = [[request URL] scheme];
    NSLog(@"scheme = %@, url = %@",scheme, request.URL.absoluteString);
    //判断是不是https
//    if ([scheme isEqualToString:@"https"]) {
//        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
//        //if (!self.isAuthed) {
//            self.originRequest = request;
//            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//            [conn start];
//            [_webView stopLoading];
//            return NO;
//        }
//    } else
    if ([scheme isEqualToString:@"alipays"] || [scheme isEqualToString:@"alipayqr"] || [scheme isEqualToString:@"weixin"]) {
        NSLog(@"start with Browser:%@", request.URL.absoluteString);
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    NSURL *theUrl = [request URL];
    self.currentURL = theUrl;
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    //网页宽度自适应
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", _webView.frame.size.width];
    [_webView stringByEvaluatingJavaScriptFromString:meta];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError：%@", error);
    
    //出错时打开外部浏览器
    NSURL *url = [NSURL URLWithString:[error.userInfo objectForKey:@"NSErrorFailingURLStringKey"]];
    if (error.code == -999){
        return;
    }
    if ([error.domain isEqual:@"WebKitErrorDomain"]
        && (error.code == 101 || error.code == 102)
        && [[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
        return;
    }
}

#pragma mark ================= NSURLConnectionDataDelegate <NSURLConnectionDelegate>
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    NSLog(@"%@",request);
    return request;
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
//    self.isAuthed = YES;
    //webview 重新加载请求。
    [_webView loadRequest:_originRequest];
    [connection cancel];
}

@end
