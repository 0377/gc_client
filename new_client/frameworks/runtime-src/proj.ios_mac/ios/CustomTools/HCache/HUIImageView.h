//
//  HUIImageView.h
//  DownLoadCacheDemo
//
//  Created by Peter_Qin on 6/7/14.
//  Copyright (c) 2014 Xes.Sky.Macbook. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCache;
@interface HUIImageView : UIImageView

@property(nonatomic,strong)HCache* cache;

/**
 *  获取图片
 *
 *  @param url url
 */
-(void)getDataFromURL:(NSString*)url;

/**
 *  初始化
 *
 *  @param url           图片url
 *  @param baseImageName 默认图片
 *
 *  @return id
 */
- (instancetype)initWithDataURL:(NSString*)url BaseImageNamed:(NSString*)baseImageName;


@end
