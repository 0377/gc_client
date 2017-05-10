//
//  GoodActivity.m
//  ActivityDemo
//
//  Created by Dale_Hui on 13-8-21.
//  Copyright (c) 2013年 Dale_Hui. All rights reserved.
//

#import "HActivity.h"
#import <QuartzCore/QuartzCore.h>
#define kLOADING_STR @"加载中"
#define kTIMEOUT_STR @"加载超时"
#define kANIMATION_NAME @"HActivity"

@interface HActivity()

@property (nonatomic, retain) NSString * loadingStr;
@property (nonatomic, retain) NSString * timeoutStr;

@end

@implementation HActivity

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged:)
                                                     name:@"UIDeviceOrientationDidChangeNotification"
                                                   object:nil];

        self.loadingStr= kLOADING_STR;
        self.timeoutStr = kTIMEOUT_STR;
        
        _activity=[[UIActivityIndicatorView alloc]init];
        [_activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_activity setColor:[UIColor whiteColor]];

        _labelInfo=[[UILabel alloc]init];
        [_labelInfo setFont:[UIFont systemFontOfSize:13]];
        [_labelInfo setTextColor:[UIColor whiteColor]];
        [_labelInfo setBackgroundColor:[UIColor clearColor]];
        
        [_labelInfo setTextAlignment:NSTextAlignmentCenter];

        
        [self setBackgroundColor:[UIColor blackColor]];
        [self.layer setCornerRadius:10];
        [self setAlpha:0];
        
        [self addSubview:_labelInfo];
        [self addSubview:_activity];
        
        [self changLayer];
        
    }
    return self;
}
- (void)replaceStr:(NSString *)str timeOut:(NSString *)timeOut
{
    _loadingStr = str;
    _timeoutStr = timeOut;
}
- (void)orientationChanged:(NSNotification *)notification
{
    [self changLayer];
}
-(void)changLayer
{
    CGAffineTransform transform= CGAffineTransformMakeRotation(3*M_PI_2);
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        {
             transform =  CGAffineTransformMakeRotation(3*M_PI_2);
        }
            break;
        case UIInterfaceOrientationLandscapeRight:
        {
             transform =  CGAffineTransformMakeRotation(M_PI_2);
        }
            break;
        case UIInterfaceOrientationPortrait:
        {
             transform =  CGAffineTransformMakeRotation(M_PI_2*4);
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
        {
             transform =  CGAffineTransformMakeRotation(M_PI_2*2);
        }
        default:
            break;
    }
    self.transform = transform;
    
}

-(void)startAnimating
{
    _labelInfo.text=_loadingStr;
    [self showSuperViewCenter];
    [_activity startAnimating];
    [UIView beginAnimations:kANIMATION_NAME context:nil];
    [self setAlpha:0.85];
    [UIView setAnimationDuration:10];
    [UIView commitAnimations];

}

-(void)stopAnimating
{
    [self showSuperViewCenter];
    [UIView beginAnimations:kANIMATION_NAME context:nil];
    [self setAlpha:0];
    [UIView setAnimationDuration:10];
    [UIView commitAnimations];
}

-(void)timeOut
{
    _labelInfo.text=_timeoutStr;
    [self performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
}

-(void)showSuperViewCenter
{
    if (self.superview) {
        CGRect superRect=self.superview.bounds;
        [self setFrame:CGRectMake((superRect.origin.x+superRect.size.width)/2-50, (superRect.origin.y+superRect.size.height)/2-50, 90, 90)];
        [_activity setFrame:CGRectMake((self.bounds.size.width/2)-(50/2),self.bounds.size.height/2-(70/2), 50, 50)];
        CGRect labelInfoRect=_activity.frame;
        labelInfoRect.origin.x-=5;
        labelInfoRect.size.width+=15;
        labelInfoRect.origin.y+=labelInfoRect.size.height;
        labelInfoRect.size.height=20;
        [_labelInfo setFrame:labelInfoRect];

    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
