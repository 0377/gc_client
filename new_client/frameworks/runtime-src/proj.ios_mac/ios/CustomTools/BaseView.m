//
//  BaseView.m
//  PopStarA
//
//  Created by 郭天琪 on 14-10-15.
//
//

#import "BaseView.h"

@implementation BaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [TQTools addShadeColor];
        self.userInteractionEnabled = YES;
        clearView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(ScreenRect), CGRectGetHeight(ScreenRect))] autorelease];
        clearView.center = CGPointMake(CGRectGetWidth(ScreenRect)*3/2, CGRectGetHeight(ScreenRect)/2-30);
        [self addSubview:clearView];
        size = ScreenRect.size;
        point = frame.origin;
        scaleX = [TQTools screenScaleX];
        scalePY = scaleX*2;
        [TQTools springAnimationWithView:clearView isOn:YES];
    }
    return self;
}

- (void)close:(UIButton *)sender
{
    __button = sender;
    [TQTools springAnimationWithView:clearView isOn:NO];
    [NSTimer scheduledTimerWithTimeInterval:0.2
                                     target:self
                                   selector:@selector(removeSelf:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)removeSelf:(NSTimer*)timer
{
    [self removeFromSuperview];
}

- (UIImageView *)imageWithName:(NSString *)name Position:(CGPoint)position ContentSize:(CGSize)contentsize
{
    UIImage * image = [UIImage imageNamed:name];
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    imageView.frame = CGRectMake(0, 0, contentsize.width, contentsize.height*scaleX);
    imageView.center = position;
    return [imageView autorelease];
}

@end
