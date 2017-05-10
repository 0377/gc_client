//
//  BaseView.h
//  PopStarA
//
//  Created by 郭天琪 on 14-10-15.
//
//

#import <UIKit/UIKit.h>
#import "TQTools.h"

@interface BaseView : UIView
{
    UIView * clearView;
    CGSize size;
    CGPoint point;
    UIImageView * background;

    CGFloat scaleX;
    CGFloat scalePY;
    UIButton * __button;
}

- (void)removeSelf:(NSTimer*)timer;
- (void)close:(UIButton *)sender;
- (UIImageView *)imageWithName:(NSString *)name Position:(CGPoint)position ContentSize:(CGSize)contentsize;

@end

