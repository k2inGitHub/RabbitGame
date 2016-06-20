//
//  GameAppDelegate.h
//  SuperCoaster
//
//  Created by terababy on 10-10-29.
//  Copyright terababy 2010. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Localnotification.h"
//#import "Advertise.h"
#import "GameKitHelperDelegate.h"
#import <MapKit/MapKit.h>
#import "HLService.h"

@class MyGameKitHelperDelegate;

@interface Business : NSObject {
    
    Localnotification *localnotification;
    MyGameKitHelperDelegate *gameKitDelegate;
    
}

+(Business*) sharedInstance;
-(void)startWithAppId:(NSString*)appId iPhoneKey:(NSString*)iPhoneKey iPadKey:(NSString*)iPadKey umenAppKey:(NSString*)umenAppKey useGameCenter:(bool)useGameCenter notifyQuote:(NSString*)notifyQuote;

// 广告
- (void)hideAdvertise;
- (void)showAdvertise;
- (void)showAdvertiseAfterDelay:(float)delay;
//- (id)getAdvertise;
//- (id)getUIRootViewController;
- (void)showHalfBanner;
- (void)showVideo;


// 应用事件处理
-(void)willResignActive;
-(void)didBecomeActive;
-(void)didEnterBackground;
-(void)willTerminate;
-(void)receiveNotification:(UILocalNotification *)notification;
-(void)handleOpenURL:(NSURL *)url;
@end
