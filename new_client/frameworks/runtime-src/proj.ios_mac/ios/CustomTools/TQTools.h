//
//  TQTools.h
//  PopStarA
//
//  Created by 郭天琪 on 14-9-25.
//
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "TQAlertView.h"
#import "AppController.h"

#define NOTICE_POSITION @"NOTICE_POSITION"

#define SNG_PASSWORD_TQ @"SNG_PASSWORD_TQ"
#define SNG_HISCORE @"*_odadaedac"
#define SNG_STARS_COUNT @"%_czeefadw"
#define SNG_FIRSTPLAY @"DSADFEWE=W"
#define SNG_HAMMERCOUNT @"ASDsacae323-="
#define SNG_SHUFFLECOUNT @"23dadwqracASy"
#define SNG_RegisterRewardsView @"6780"

#define SNG_LOGIN_SCCUESS @"SNG_LOGIN_SCCUESS"
#define SNG_LOGOUT_SCCUESS @"SNG_LOGOUT_SCCUESS"

#define SNG_USER_GAME_INFO @"6781"
#define SNG_HERO_DATE @"6782"

#define VUNGLE_VIDEO_TIME @"vungle_video_time"
#define VUNGLE_VIDEO_NUMBER @"vungle_video_number"

static NSString * gift_Message_Fail = @"您刚刚赠送过该好友礼物,请等一会再试吧...";
static NSString * gift_Message_Success = @"您给予%@的礼物已经发出";

static NSString * loading_Rank_Faild = @"加载失败";
static NSString * loading_Rank_none = @"没有更多了";
static NSString * receive_Gift_Fail = @"收取失败了，再试一次吧";

@interface TQTools : NSObject<UIAlertViewDelegate>

+ (id)shareTools;

- (void)initAlertView:(NSString *)message CallBack:(void(^)())callback isFirst:(BOOL)isfirst;
@property (nonatomic, copy) void (^alertViewCallback)();

+ (BOOL)saveUserId:(NSString *)userID;
+ (NSString *)readUserId;
+ (BOOL)saveGiftUserId:(NSString *)userID;
+ (BOOL)compareGiftUserId:(NSString *)userId;
//+ (void)showAlerView:(NSString *)message;
+ (NSString *)getDeviceScreen;
+ (NSArray *)getRankUsersJsonData:(id)json;
+ (UIColor *)addShadeColor;
+ (CGFloat)screenScaleX;
+ (void)springAnimationWithView:(UIView *)view isOn:(BOOL)ison;

+ (UIImageView *)imageWithName:(NSString *)name Anchor:(CGPoint)anchor Position:(CGPoint)position Enable:(BOOL)enable;
+ (UIImageView *)imageWithImage:(UIImage *)image Anchor:(CGPoint)anchor Position:(CGPoint)position Enable:(BOOL)enable;
+ (UIButton *)buttonWithImage:(NSString *)image Target:(id)target Select:(SEL)select Anchor:(CGPoint)anchor Position:(CGPoint)position;
+ (UILabel *)labelWithText:(NSString *)text Font:(UIFont *)font Anchor:(CGPoint)anchor Position:(CGPoint)position;

+ (NSString *)md5_32:(NSString *)str;

+ (BOOL)isSeeWithVideo;
+ (void)saveVungleWithTime;
+ (BOOL)isShowAlertView;

@end
