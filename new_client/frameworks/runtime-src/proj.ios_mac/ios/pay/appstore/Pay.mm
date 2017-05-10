#import "Pay.h"
#import "TQAlertView.h"
#import "AppController.h"
#include "PlatBridge.h"

@implementation Pay

@synthesize payProductId = _payProductId;
@synthesize dict = _dict;

- (instancetype)init
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    return self;
}

-(void)payRequest:(NSDictionary *)dict
{
    self.dict = dict;
    
    //检测设备是否支持store pay支付
    if (![SKPaymentQueue canMakePayments]) {
        [[TQAlertView shareAlertView] AlertViewMessage:@"您的设备不允许程序内支付，请先开启支付功能!" isFirst:YES OK:^{
            
        } Cancel:^{
            
        }];
        
        //取消支付请求
        return;
    }
    
    self.isPayList = false;
    
    self.payProductId = [dict objectForKey:@"goods_id"];
    
    NSSet *nsset = [NSSet setWithObject:self.payProductId];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
}

//收到产品信息返回
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *product = response.products;
    NSLog(@"无效的产品product ID = %@",response.invalidProductIdentifiers);
    if ([product count] == 0) {
        [self payFailed:@"没有找到商品信息，购买失败"];
        return;
    }
    
    SKProduct *p = nil;

    for (SKProduct *pro in product) {
        if ([pro.productIdentifier isEqualToString:self.payProductId]) {
            p = pro;
            break;
        }
    }
    
    if (p == nil) {
        [self payFailed:@"没有对应的商品信息，购买失败"];
        return;
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    [self payFailed:error.localizedDescription];
}

//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:  //交易完成
                NSLog(@"交易完成");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                if (self.isPayList==true)
                {
                    [self verifyPruchase];
                    self.isPayList = false;
                }
                break;
            case SKPaymentTransactionStatePurchasing: //添加商品进列表
                NSLog(@"添加商品进列表");
                break;
            case SKPaymentTransactionStateRestored:  //已经购买过商品
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                if (self.isPayList==true)
                    [self payFailed:@"已经购买过商品"];
                break;
            case SKPaymentTransactionStateFailed:  //购买失败
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                if (self.isPayList==true)
                    [self payFailed:[tran.error localizedDescription]];
                break;
            default:
                break;
        }
    }
}


- (void)requestDidFinish:(SKRequest *)request
{
    self.isPayList = true;
    NSLog(@"------------反馈信息结束-----------------");
}

- (void) dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [super dealloc];
}

- (void)verifyPruchase
{
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:self.dict];
    [mutDict setValue:[[NSBundle mainBundle] appStoreReceiptURL] forKey:@"appleData"];

    [PlatBridge paySuccess:(NSDictionary*)mutDict];
}

- (void)payFailed:(NSObject*)errorMsg
{
    self.isPayList = false;
    if([errorMsg isKindOfClass:[NSString  class]]==YES)
    {
        NSString* str = (NSString*)errorMsg;
        [PlatBridge payFailed:str];

    }else{
        [PlatBridge payFailed:nil];
    }
    
    NSLog(@"支付失败:%@", errorMsg);
   }

@end
