//
//  HUIImageView.m
//  DownLoadCacheDemo
//
//  Created by Peter_Qin on 6/7/14.
//  Copyright (c) 2014 Xes.Sky.Macbook. All rights reserved.
//

#import "HUIImageView.h"
#import "HCache.h"
@implementation HUIImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.cache=[[HCache alloc]init];
        
        // Initialization code
    }
    return self;
}


- (instancetype)initWithDataURL:(NSString*)url BaseImageNamed:(NSString*)baseImageName
{
    self = [super init];
    if (self) {
        self.image=[UIImage imageNamed:baseImageName];
         self.cache=[[HCache alloc]init];
        [self getDataFromURL:url];
    }
    return self;
}

-(void)getDataFromURL:(NSString*)url
{
    if (!self.cache) {
        self.cache=[[HCache alloc]init];
    }
    [self.cache getDataCache:url result:^(NSDictionary *dataInfo) {
        UIImage* img=[UIImage imageWithContentsOfFile:[dataInfo objectForKey:@"filePath"]];
        [self performSelectorOnMainThread:@selector(setImage:) withObject:img waitUntilDone:YES];
    }];
    
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
