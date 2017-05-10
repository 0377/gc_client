#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


@interface Pay : UIViewController<SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (nonatomic, copy) NSString *payProductId;
@property (nonatomic, copy) NSDictionary *dict;
@property Boolean isPayList;

- (instancetype)init;
- (void)payRequest:(NSDictionary *)dict;
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response;
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error;
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void)requestDidFinish:(SKRequest *)request;
- (void)dealloc;
- (void)verifyPruchase;
- (void)payFailed:(NSObject*)errorMsg;@end
