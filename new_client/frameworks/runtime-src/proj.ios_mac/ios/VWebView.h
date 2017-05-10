//
//  PopStarAAppController.h
//  PopStarA
//
//  Created by YongSang Lee on 13. 6. 2..
//  Copyright __MyCompanyName__ 2013년. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@interface VWebView : BaseView<UIWebViewDelegate>

@property(nonatomic, assign) NSURL *currentURL;
@property(nonatomic, assign) bool isAuthed;
@property(nonatomic, assign) NSURLRequest *originRequest;

- (void)setTitle:(NSString*)title;
- (void)setUrl:(NSString*)url;
- (id)initWithFrame:(CGRect)frame callback:(int)nCallback args:(NSString*)strArgs;
- (id)initWithLocalFrame:(CGRect)frame Js:(NSString*)localUrl;

@end
