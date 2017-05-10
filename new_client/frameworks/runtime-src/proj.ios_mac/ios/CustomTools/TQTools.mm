//
//  TQTools.m
//  PopStarA
//
//  Created by 郭天琪 on 14-9-25.
//
//

#import "TQTools.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <netinet/in.h>

NSString * USER_ID_KEY = @"USER_ID_KEY";

TQTools * tools = nil;

@interface TQTools()
{
    BOOL _isFirst;
}

@end

@implementation TQTools

+ (id)shareTools
{
    if (!tools) {
        tools = [[TQTools alloc] init];
    }
    return tools;
}

- (void)initAlertView:(NSString *)message CallBack:(void (^)())callback isFirst:(BOOL)isfirst
{
    _isFirst = isfirst;
    UIAlertView * alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    alert.title = @"提示";
    alert.message = message;

    if (_isFirst) {
        [alert addButtonWithTitle:@"确定"];
    }else{
        [alert addButtonWithTitle:@"确定"];
        [alert addButtonWithTitle:@"取消"];
    }
    self.alertViewCallback = callback;

    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 || _isFirst == YES) {
        if (self.alertViewCallback) {
            self.alertViewCallback();
        }
    }
    [alertView release];
}

+(BOOL)saveUserId:(NSString *)userID
{
//    NSString * enStr = [TQTools md5:userID];
//    NSLog(@"enStr = %@", enStr);
//    [[NSUserDefaults standardUserDefaults] setObject:enStr forKey:USER_ID_KEY];
//    BOOL isSave = [[NSUserDefaults standardUserDefaults] synchronize];
//#ifdef DEBUG
//    NSLog(@"保存成功");
//#endif
//    return isSave;
    return YES;
}

+(NSString *)readUserId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID_KEY];
}

+ (BOOL)saveGiftUserId:(NSString *)userID
{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * userPath = [NSString stringWithFormat:@"%@.plist",[TQTools readUserId]];
    NSString * fileName = [path stringByAppendingPathComponent:userPath];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSMutableDictionary * data;
    if (![fileManager fileExistsAtPath:fileName])
    {
        data = [NSMutableDictionary dictionary];
    }
    else
    {
        data = [NSMutableDictionary dictionaryWithContentsOfFile:fileName];
    }
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddHHmm"];
    NSString * locationDate = [dateFormatter stringFromDate:date];

    [data setObject:locationDate forKey:userID];

    [dateFormatter release];
    if ([data writeToFile:fileName atomically:YES]) {
        return YES;
    }

    return NO;

}

+ (BOOL)compareGiftUserId:(NSString *)userId
{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * userPath = [NSString stringWithFormat:@"%@.plist",[self readUserId]];
    NSString * fileName = [path stringByAppendingPathComponent:userPath];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fileName])
    {
        return YES;
    }
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddHHmm"];
    NSString * locationDate = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithContentsOfFile:fileName];
    for (id obj in [data allKeys]) {
        NSString * objStr = obj;
        if ([userId isEqualToString:objStr]) {
            NSString * oldDate = [data objectForKey:objStr];
            NSLog(@"old time = %lld, location time = %lld",oldDate.longLongValue, locationDate.longLongValue);
            long long time = locationDate.longLongValue - oldDate.longLongValue;
            if (time >= 2400) {
                return YES;
            }else{
                return NO;
            }
        }
    }
    return YES;
}

+ (BOOL)isSeeWithVideo
{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * userPath = @"pop.plist";
    NSString * fileName = [path stringByAppendingPathComponent:userPath];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSMutableDictionary * data;
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    NSString * locationDate = [dateFormatter stringFromDate:date];
    if (![fileManager fileExistsAtPath:fileName])
    {
        data = [NSMutableDictionary dictionary];
        [data setObject:locationDate forKey:VUNGLE_VIDEO_TIME];
        [data setObject:@"0" forKey:VUNGLE_VIDEO_NUMBER];
        return [data writeToFile:fileName atomically:YES];
    }
    else
    {
        data = [NSMutableDictionary dictionaryWithContentsOfFile:fileName];
        NSAssert([[data allKeys] count] >= 2, @"警告：视频观看次数 没有存储进去");
        long oldTime = [[data objectForKey:VUNGLE_VIDEO_TIME] integerValue];
        long nowTime = locationDate.integerValue;
        if (nowTime > oldTime)
        {
            [data setObject:@"0" forKey:VUNGLE_VIDEO_NUMBER];
            return [data writeToFile:fileName atomically:YES];
        }
        else
        {
            long number = [[data objectForKey:VUNGLE_VIDEO_NUMBER] integerValue];
            if (number < 5)
                return YES;
            else
                return NO;
        }
    }
}

+ (void)saveVungleWithTime
{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * userPath = @"pop.plist";
    NSString * fileName = [path stringByAppendingPathComponent:userPath];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSAssert([fileManager fileExistsAtPath:fileName], @"没有存储 vungle time number的plist文件");
    NSMutableDictionary * data;
    data = [NSMutableDictionary dictionaryWithContentsOfFile:fileName];
    NSInteger number = [[data objectForKey:VUNGLE_VIDEO_NUMBER] integerValue];
    if (!number) {
        NSDate * date = [NSDate date];
        NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"YYYYMMdd"];
        NSString * locationDate = [dateFormatter stringFromDate:date];
        [data setObject:locationDate forKey:VUNGLE_VIDEO_TIME];
    }
    NSString * objStr = [NSString stringWithFormat:@"%ld", (long)number+1];
    [data setObject:objStr forKey:VUNGLE_VIDEO_NUMBER];
    [data writeToFile:fileName atomically:YES];
}

+ (BOOL)isShowAlertView
{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * userPath = @"pop.plist";
    NSString * fileName = [path stringByAppendingPathComponent:userPath];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSAssert([fileManager fileExistsAtPath:fileName], @"没有存储 vungle time number的plist文件");
    NSMutableDictionary * data;
    data = [NSMutableDictionary dictionaryWithContentsOfFile:fileName];
    NSInteger number = [[data objectForKey:VUNGLE_VIDEO_NUMBER] integerValue];
    if (number > 5)
        return NO;
    return YES;
}
//+ (void)showAlerView:(NSString *)message
//{
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
//    [alert release];
//}

+ (NSString *)getDeviceScreen
{
//    NSLog(@"model = %@",[UIDevice currentDevice].model);
//    NSRange foundObj=[[UIDevice currentDevice].model rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch];
//    if (foundObj.length > 0) {
//        return @"3.5";
//    }else{
//        return @"ipad";
//    }
    CGSize size = [[UIScreen mainScreen] bounds].size;
    if (size.height == 480.f && size.width == 320.f) {
        return @"3.5";
    }else if (size.width == 320.f && size.height == 568.f){
        return @"4";
    }else if (size.width == 375.f && size.height == 667.f){
        return @"4";
    }else if (size.width == 540.f && size.height == 960.f){
        return @"4";
    }else{
        return @"ipad";
    }

}

+ (NSString *)md5_32:(NSString *)str
{
    const char *cStr = [str UTF8String];

    unsigned char result[16];

    CC_MD5( cStr, strlen(cStr), result );

    NSMutableString *Mstr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [Mstr appendFormat:@"%02x",result[i]];
    }
    return Mstr;
    
}

+ (NSArray *)getRankUsersJsonData:(id)json
{
    NSArray * arr = [json objectForKey:@"ranks"];
    return arr;
}

+ (UIColor *)addShadeColor
{
    return [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5];
}

+ (UIImageView *)imageWithName:(NSString *)name Anchor:(CGPoint)anchor Position:(CGPoint)position Enable:(BOOL)enable
{
    CGFloat scaleX = [TQTools screenScaleX];
    UIImage * image = [UIImage imageNamed:name];
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.image = image;
    imageView.layer.anchorPoint = anchor;
    imageView.userInteractionEnabled = enable;
    imageView.frame = CGRectMake(0, 0, image.size.width*scaleX, image.size.height*scaleX);
    imageView.center = position;
    return [imageView autorelease];
}

+ (UIImageView *)imageWithImage:(UIImage *)image Anchor:(CGPoint)anchor Position:(CGPoint)position Enable:(BOOL)enable
{
    CGFloat scaleX = [TQTools screenScaleX];
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.image = image;
    imageView.layer.anchorPoint = anchor;
    imageView.userInteractionEnabled = enable;
    imageView.frame = CGRectMake(0, 0, image.size.width*scaleX, image.size.height*scaleX);
    imageView.center = position;
    return [imageView autorelease];
}

+ (UIButton *)buttonWithImage:(NSString *)image Target:(id)target Select:(SEL)select Anchor:(CGPoint)anchor Position:(CGPoint)position
{
    CGFloat scaleX = [TQTools screenScaleX];
    UIImage * _image = [UIImage imageNamed:image];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, (_image.size.width*scaleX), _image.size.height*scaleX);
    button.layer.anchorPoint = anchor;
    [button setImage:_image forState:UIControlStateNormal];
    [button addTarget:target action:select forControlEvents:UIControlEventTouchUpInside];
    button.center = position;
    return button;
}

+ (UILabel *)labelWithText:(NSString *)text Font:(UIFont *)font Anchor:(CGPoint)anchor Position:(CGPoint)position
{
    CGSize labelSize = [text sizeWithFont:font
                 constrainedToSize:CGSizeMake(CGRectGetWidth(ScreenRect), 400)
                     lineBreakMode:NSLineBreakByWordWrapping
                 ];
    UILabel * label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelSize.width, labelSize.height)] autorelease];
    [label setText:text];
    label.userInteractionEnabled = NO;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:font];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    label.layer.anchorPoint = anchor;
    label.center = position;
    return label;
}

+ (CGFloat)screenScaleX
{
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    return screenSize.width/640.f;
}

+ (void)springAnimationWithView:(UIView *)view isOn:(BOOL)ison
{
    CGSize size = [[UIScreen mainScreen] bounds].size;

    CGFloat centerX, centerY;

    if (ison) {
        centerX = size.width/2;
        centerY = size.height/2-30;
    }else{
        centerX = -size.width*3/2;
        centerY = size.height/2-30;
    }

    if (1) {
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {

        [UIView animateWithDuration:0.2 animations:^{
            view.center = CGPointMake(centerX, centerY);
        }];
        
        return;
    }
}

@end
