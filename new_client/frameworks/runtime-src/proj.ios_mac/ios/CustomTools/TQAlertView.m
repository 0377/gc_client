//
//  TQAlertView.m
//  PopStarA
//
//  Created by 郭天琪 on 14-10-22.
//
//

#import "TQAlertView.h"
#import "TQTools.h"
TQAlertView * __tqAlertView = nil;

@interface TQAlertView()
{
//    UIView * clearView;
//    UIView * tqClearView;
//    UIView * whiteView;
//    UIButton * okButton;
//    UIButton * cancelButton;
//    UILabel * messageLabel;
//    UILabel * titleLabel;

    CGFloat scaleX;
    CGFloat scalePY;
    float buttony;
}

@property (nonatomic, retain) UIView * tqClearView;
@property (nonatomic, retain) UIView * whiteView;
@property (nonatomic, retain) UIButton * okButton;
@property (nonatomic, retain) UIButton * cancelButton;
@property (nonatomic, retain) UILabel * messageLabel;
@property (nonatomic, retain) UILabel * titleLabel;

@end

@implementation TQAlertView

+ (TQAlertView *)shareAlertView
{
    if (!__tqAlertView) {
        CGRect rect = ScreenRect;
        rect.size.width = ScreenRect.size.width/2;
        rect.size.height = ScreenRect.size.height/2;
        
        __tqAlertView = [[TQAlertView alloc] initWithFrame:rect];
        [[[[UIApplication sharedApplication] windows] firstObject] addSubview:__tqAlertView];
    }
    return __tqAlertView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        scaleX = [TQTools screenScaleX];
        scalePY = scaleX*2;
        self.backgroundColor = [TQTools addShadeColor];

//        clearView = [[[UIView alloc] initWithFrame:ScreenRect] autorelease];
//        [self addSubview:clearView];
//        _tqClearView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, clearSize.width, clearSize.height)] autorelease];
        _tqClearView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 240*scalePY, 130*scalePY)] autorelease];
        _tqClearView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3];
        [_tqClearView.layer setMasksToBounds:YES];
        [_tqClearView.layer setCornerRadius:6*scalePY];
        [self addSubview:_tqClearView];

        _whiteView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tqClearView.bounds)-8*scalePY, CGRectGetHeight(_tqClearView.bounds)-8*scalePY)] autorelease];
        [_whiteView.layer setMasksToBounds:YES];
        [_whiteView.layer setCornerRadius:6*scalePY];
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.center = CGPointMake(CGRectGetWidth(_tqClearView.bounds)/2, CGRectGetHeight(_tqClearView.bounds)/2);
        [_tqClearView addSubview:_whiteView];

//        CGSize labelSize = [messageLabel sizeWithFont:[UIFont systemFontOfSize:20*scalePY]
//                            constrainedToSize:CGSizeMake(CGRectGetWidth(whiteView.bounds), 400)
//                                lineBreakMode:NSLineBreakByWordWrapping
//                            ];
        _messageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_whiteView.bounds)-12*scalePY, 60*scalePY)] autorelease];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.numberOfLines = 0;
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _messageLabel.font = [UIFont systemFontOfSize:13.0f*scalePY];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = [UIColor blackColor];
        _messageLabel.center = CGPointMake(CGRectGetWidth(_whiteView.bounds)/2, 55*scalePY);
        [_whiteView addSubview:_messageLabel];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_whiteView.bounds)-20*scalePY, 14*scalePY)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [_titleLabel setTextColor:[UIColor blackColor]];
        _titleLabel.text = @"提示";
        _titleLabel.font = [UIFont systemFontOfSize:15  *scalePY];
        _titleLabel.center = CGPointMake(CGRectGetWidth(_whiteView.bounds)/2, 20*scalePY);
        [_whiteView addSubview:_titleLabel];

        buttony = 50*scalePY;
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _okButton.frame = CGRectMake(0, 0, 80*scalePY, 25*scalePY);
        _okButton.backgroundColor = TQCOLOR(234, 74, 79);
        _okButton.titleLabel.font = [UIFont systemFontOfSize:13*scalePY];
        [_okButton setTitle:@"确定" forState:UIControlStateNormal];
        [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _okButton.center = CGPointMake(CGRectGetWidth(_whiteView.bounds)/2-buttony, CGRectGetHeight(_whiteView.bounds)-25*scalePY);
        [_whiteView addSubview:_okButton];
        [_okButton addTarget:self action:@selector(okButton:) forControlEvents:UIControlEventTouchUpInside];

        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = _okButton.frame;
        _cancelButton.backgroundColor = TQCOLOR(43, 186, 245);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = _okButton.titleLabel.font;
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelButton.center = CGPointMake(CGRectGetWidth(_whiteView.bounds)/2+buttony, _okButton.center.y);
        [_cancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
        [_whiteView addSubview:_cancelButton];

        
    }
    return self;
}

- (void)AlertViewMessage:(NSString *)message isFirst:(BOOL)isfirst OK:(void (^)())ok Cancel:(void (^)())cancel
{
    [_okButton setTitle:@"确定" forState:UIControlStateNormal];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    _tqClearView.center = CGPointMake(CGRectGetWidth(ScreenRect)*3/2, CGRectGetHeight(ScreenRect)/2-30);
    self.okCallBack = ok;
    if (isfirst) {
        _cancelButton.hidden = YES;
        _okButton.center = CGPointMake(CGRectGetWidth(_whiteView.bounds)/2, _okButton.center.y);
    }else{
        self.cancelCallBack = cancel;
        _cancelButton.hidden = NO;
        _okButton.center = CGPointMake(CGRectGetWidth(_whiteView.bounds)/2-buttony, _cancelButton.center.y);
    }
    _messageLabel.text = message;
    self.hidden = NO;
    isTouch = NO;
    [TQTools springAnimationWithView:_tqClearView isOn:YES];
}

- (void)AlertViewMessage:(NSString *)message Back:(NSString *)back OK:(void (^)())ok Cancel:(void (^)())cancel
{
    [_okButton setTitle:@"更新" forState:UIControlStateNormal];
    [_cancelButton setTitle:back forState:UIControlStateNormal];
    _tqClearView.center = CGPointMake(CGRectGetWidth(ScreenRect)*3/2, CGRectGetHeight(ScreenRect)/2-30);
    self.okCallBack = ok;
    self.cancelCallBack = cancel;
    _cancelButton.hidden = NO;
    _okButton.center = CGPointMake(CGRectGetWidth(_whiteView.bounds)/2-buttony, _cancelButton.center.y);
    _messageLabel.text = message;
    self.hidden = NO;
    isTouch = NO;
    [TQTools springAnimationWithView:_tqClearView isOn:YES];
}

- (void)okButton:(UIButton *)sender
{
    if (isTouch) {
        return;
    }
    isTouch = YES;
    [self animationView];
    if (self.okCallBack) {
        self.okCallBack();
    }
}

- (void)cancelButton:(UIButton *)sender
{
    if (isTouch) {
        return;
    }
    isTouch = YES;
    [self animationView];
    if (self.cancelCallBack) {
        self.cancelCallBack();
    }
}

- (void)animationView
{
    [TQTools springAnimationWithView:_tqClearView isOn:NO];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(hideAlertView) userInfo:nil repeats:NO];
}

- (void)hideAlertView
{
    self.hidden = YES;
}

@end
