//  InAppPurchaseManager.m
//  aimngive
//
//  Created by d. nye on 3/5/10.
//  Copyright 2010 PlayNGive LLC. MIT License.
//
#import "InAppPurchaseManager.h"
#import "GameConfig.h"
#import "Configuration.h"


@implementation InAppPurchaseManager
@synthesize shoesKey,threeH,sevenH,twelveH,eighteenH,twentyFiveH,thirtyFiveH,tenThousand;

static InAppPurchaseManager *_sharedInAppManager = nil;


-(id) init
{
    threeH=ThreeHundred;
    sevenH=SevenHundred;
    twelveH=TwelveHundred;
    eighteenH=EighteenHundred;
    twentyFiveH=TwentyFiveHundred;
    thirtyFiveH=ThirtyFiveHundred;
    tenThousand=TenThousand;

	storeDoneLoading = NO;
    
	return self;
}
+ (InAppPurchaseManager *)sharedInAppManager
{
	@synchronized([InAppPurchaseManager class])
	{
		if (!_sharedInAppManager)
			[[self alloc] init];
		
		return _sharedInAppManager;
	}
	// to avoid compiler warning
	return nil;
}

+(id)alloc
{
	@synchronized([InAppPurchaseManager class])
	{
		NSAssert(_sharedInAppManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedInAppManager = [super alloc];
		return _sharedInAppManager;
	}
//    [HLUtil setPaidState:false];
	// to avoid compiler warning
	return nil;
}


+(void )setComIndex : (int )index
{
//    comIndex = index;
}



- (void) dealloc
{
	[super dealloc];
}

- (BOOL) storeLoaded
{
	return storeDoneLoading;
}

- (void)requestProUpgradeProductData
{
    NSSet *productIdentifiers = [NSSet setWithObject:threeH];
    productsRequest = [[[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers] autorelease];
    productsRequest.delegate = self;
    [productsRequest start];
    
    // we will release the request object in the delegate callback
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;

    proUpgradeProduct = [products count] == 1 ? [[products objectAtIndex:0] retain] : nil;
    if (proUpgradeProduct)
    {
        NSLog(@"Product title: %@" , proUpgradeProduct.localizedTitle);
        NSLog(@"Product description: %@" , proUpgradeProduct.localizedDescription);
        NSLog(@"Product price: %@" , proUpgradeProduct.price);
        NSLog(@"Product id: %@" , proUpgradeProduct.productIdentifier);
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
    //[productsRequest release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

#pragma -
#pragma Public methods

//
// call this method once on startup
//
- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestProUpgradeProductData];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}
-(void)purchaseModel:(int)tag
{

    if (tag==300) {
        SKPayment *payment = [SKPayment paymentWithProductIdentifier:threeH];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }else if(tag==700){
        SKPayment *payment = [SKPayment paymentWithProductIdentifier:sevenH];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    }else if(tag==1200){
        SKPayment *payment = [SKPayment paymentWithProductIdentifier:twelveH];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }else if(tag==1800){
        SKPayment *payment = [SKPayment paymentWithProductIdentifier:eighteenH];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }else if(tag==2500){
        SKPayment *payment = [SKPayment paymentWithProductIdentifier:twentyFiveH];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }else if(tag==3500){
        SKPayment *payment = [SKPayment paymentWithProductIdentifier:thirtyFiveH];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }else if(tag==10000){
        SKPayment *payment = [SKPayment paymentWithProductIdentifier:tenThousand];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

-(void)purchaseShoes
{
    storeDoneLoading = YES;
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:shoesKey];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


-(void)restoreShoes
{
    storeDoneLoading = YES;
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma -
#pragma Purchase helpers

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    
    [MBProgressHUD hideHUDForView:
     [UIApplication sharedApplication].keyWindow animated:YES];
    
}

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
//    if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseProUpgradeProductId])
//    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
//    if ([productId isEqualToString:kInAppPurchaseProUpgradeProductId])
//    {
        // enable the pro features
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isProUpgradePurchased" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:productId];
        
//    }
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
        [MBProgressHUD hideHUDForView: [UIApplication sharedApplication].keyWindow animated:YES];//TODO:
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:transaction];
    }
    else
    {
        [MBProgressHUD hideHUDForView: [UIApplication sharedApplication].keyWindow animated:YES];
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
    
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                storeDoneLoading = NO;
                [MBProgressHUD hideHUDForView:
                 [UIApplication sharedApplication].keyWindow animated:YES];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                [MBProgressHUD hideHUDForView:
                 [UIApplication sharedApplication].keyWindow animated:YES];
                storeDoneLoading = NO;
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                storeDoneLoading = NO;
                [MBProgressHUD hideHUDForView:
                 [UIApplication sharedApplication].keyWindow animated:YES];
                break;
            default:
                break;
        }
    }
}

@end