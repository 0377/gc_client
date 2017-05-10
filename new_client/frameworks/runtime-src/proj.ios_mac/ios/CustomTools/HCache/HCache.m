
#import "HCache.h"
#include "Util.h"
#define kDOCUMENT_CACHE_NAME @"Caches"

@interface HCache()

@property(nonatomic,strong)NSFileManager* fileManager;
@property(nonatomic,strong)NSString* caches;
@property(nonatomic,strong)resultData result;

@end

@implementation HCache

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fileManager=[NSFileManager defaultManager];
        self.caches=[[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:kDOCUMENT_CACHE_NAME] copy];
        
    }
    return self;
}

-(void)getDataCache:(NSString*)url result:(resultData)resultData
{
    self.result=resultData;
    
    NSString* file=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:kDOCUMENT_CACHE_NAME];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    
    NSString* md5URL=[Util getMD5:url];
    ///若文件不存在，则下载至缓存
    if (![fileManager fileExistsAtPath:[file stringByAppendingPathComponent:md5URL]]) {
        NSOperationQueue* operationQueue=[[NSOperationQueue alloc]init];
        
        /**
         *  文件不存在则创建
         */
        [[NSFileManager defaultManager]createDirectoryAtPath:file withIntermediateDirectories:YES attributes:nil error:nil];
        
        NSInvocationOperation * op=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(downloadFinish:) object:url];
        [operationQueue addOperation:op];        
    }
    else
    {
        NSDictionary* dic=[NSDictionary dictionaryWithObject:[file stringByAppendingPathComponent:md5URL] forKey:@"filePath"];
         _result(dic);
    }

}

-(void)downloadFinish:(id)object
{
    NSURL * dataUrl=[NSURL URLWithString:object];
    NSData* data=[NSData dataWithContentsOfURL:dataUrl];
    NSString* file=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:kDOCUMENT_CACHE_NAME];
    [data writeToFile:[file stringByAppendingPathComponent:[Util getMD5:object]] atomically:YES];
    NSDictionary* dic=[NSDictionary dictionaryWithObject:[file stringByAppendingPathComponent:[Util getMD5:object]] forKey:@"filePath"];
    if (_result!=nil) {
        _result(dic);
    }
    else
    {
        NSLog(@"ERROR%s",__func__);
    }


}

///清除缓存
+(BOOL)clearCache
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSString* caches=[[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:kDOCUMENT_CACHE_NAME] copy];
    return [fileManager removeItemAtPath:caches error:nil];
}

@end
