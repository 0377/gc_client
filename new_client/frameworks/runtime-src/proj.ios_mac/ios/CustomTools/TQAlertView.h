//
//  TQAlertView.h
//  PopStarA
//
//  Created by 郭天琪 on 14-10-22.
//
//

#import <UIKit/UIKit.h>

@interface TQAlertView : UIView
{
    BOOL isFirst;
    BOOL isTouch;
}

@property (nonatomic, copy) void (^okCallBack)();
@property (nonatomic, copy) void (^cancelCallBack)();


+ (TQAlertView *)shareAlertView;
- (void)AlertViewMessage:(NSString *)message isFirst:(BOOL)isfirst OK:(void(^)())ok Cancel:(void(^)())cancel;
- (void)AlertViewMessage:(NSString *)message Back:(NSString *)back OK:(void(^)())ok Cancel:(void(^)())cancel;

@end
