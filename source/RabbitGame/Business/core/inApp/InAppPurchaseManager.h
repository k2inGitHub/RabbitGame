
//  InAppPurchaseManager.h
//  aimngive
//
//  Created by d. nye on 3/5/10.
//  Copyright 2010 PlayNGive LLC. MIT License.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


#import "MBProgressHUD.h"


#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"

// add a couple notifications sent out when the transaction completes
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

#define kProductPurchasedNotification       @"ProductPurchased"
#define kProductPurchaseFailedNotification  @"ProductPurchaseFailed"

#define SHOES 6


@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
	BOOL storeDoneLoading;
    
    NSString *shoesKey,*threeH,*sevenH,*twelveH,*eighteenH,*twentyFiveH,*thirtyFiveH,*tenThousand;
}

@property(nonatomic, retain)NSString *shoesKey,*threeH,*sevenH,*twelveH,*eighteenH,*twentyFiveH,*thirtyFiveH,*tenThousand;

+(InAppPurchaseManager *)sharedInAppManager;
+(void )setComIndex : (int )index;

// public methods
- (void)loadStore;
- (BOOL)canMakePurchases;
- (BOOL)storeLoaded;
-(void)purchaseModel:(int)tag;
- (void)purchaseShoes;
-(void)restoreShoes;

@end