//
//  GoodActivity.h
//  ActivityDemo
//
//  Created by Dale_Hui on 13-8-21.
//  Copyright (c) 2013年 Dale_Hui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HActivity : UIView

@property(strong,nonatomic)UILabel* labelInfo;///具体文字信息 Label
@property(strong,nonatomic)UIActivityIndicatorView* activity;///菊花

- (void)replaceStr:(NSString *)str timeOut:(NSString *)timeOut;
/**
 *  开始加载动画
 */
-(void)startAnimating;

/**
 *  停止加载动画
 */
-(void)stopAnimating;


/**
 *  连接超时
 */
-(void)timeOut;

/**
 *  让视图显示在父类视图上
 */
-(void)showSuperViewCenter;

@end
