//
//  GameAppDelegate.m
//  SuperCoaster
//
//  Created by terababy on 10-10-29.
//  Copyright terababy 2010. All rights reserved.
//

#import "Business.h"
#import "MyUserAnalyst.h"
#import "Appirater.h"
#import "MyGameKitHelperDelegate.h"
#import "MyGameKitHelper.h"
#import "MyAppiraterDelegate.h"
#import "AdvertiseMoGo.h"



@implementation Business


#pragma mark Advertise

-(void)startWithAppId:(NSString*)appId iPhoneKey:(NSString*)iPhoneKey iPadKey:(NSString*)iPadKey umenAppKey:(NSString*)umenAppKey useGameCenter:(bool)useGameCenter notifyQuote:(NSString*)notifyQuote
{
    // 1. 广告
	Advertise *advertise = [Advertise shareInstance];
    [advertise start:iPhoneKey iPadId:iPadKey];
    
    
    // 2. 本地通知
    localnotification = [[Localnotification alloc] init];
    [localnotification cancelAllLocalNotification];
    localnotification.cancel = @"没空啦";
    localnotification.message = notifyQuote;
    
    // 3. 用户分析
    [MyUserAnalyst startWithAppkey:umenAppKey];
    
    // 4. 半屏自主广告
    //[[HalfScreen sharedInstance] start];
    
    // 5. 排行榜
    if (useGameCenter) {
        MyGameKitHelper *gamekit = (MyGameKitHelper*)[MyGameKitHelper sharedHelper];
        gameKitDelegate = [[MyGameKitHelperDelegate alloc] init];
        gamekit.delegate = gameKitDelegate;
        [gamekit authenticateLocalPlayer];
    }
    
    // 6. 用户评价
    [MyUserAnalyst updateOnlineConfig];
    int scoreWall = [MyUserAnalyst getIntFlag:@"ScoreWall" defaultValue:0];
    //if (scoreWall == 5) {
    
    //scoreWall=3;
    if (scoreWall > 0) {
        Appirater *appirater = [Appirater sharedInstance];
        appirater.message = [NSString stringWithFormat:@"喜欢这个游戏吗, 给个5星好评吧! 激励我们推出更多免费升级! ^_^"];
        appirater.title = @"鼓励一下我们吧";
        appirater.cancel = @"No, Thanks";
        appirater.later = @"就不给";
        appirater.ok =  @"现在去评分 :)";
        appirater.appId = appId;
        
        appirater.appiraterDaysUntilPrompt = 1;
        appirater.appiraterUserUntilPrompt = 1;
        appirater.appiraterSigEventsUntilPrompt = -1;
        appirater.appiraterTimeBeforeReminding = 1;
        appirater.delegate = [[MyAppiraterDelegate alloc]init];
        
        [Appirater appLaunched:YES];
    }
}


- (id)getAdvertise {
    return [AdvertiseMoGo sharedInstance];
}

- (id)getUIRootViewController {
    return [AdvertiseMoGo sharedInstance];
}

- (void)hideAdvertiseSpecial
{
    //[[Advertise shareInstance] hideBanner];
}

- (void)hideAdvertise {
    [[Advertise shareInstance] hideBanner];
}

- (void)showAdvertiseAfterDelay:(float)delay {
    [self performSelector:@selector(showAdvertise) withObject:nil afterDelay:delay];
}

- (void)showAdvertise {
    [[Advertise shareInstance] showBanner];
}

- (void)showHalfBanner {
    [[Advertise shareInstance] showHalfBanner];
}
- (void)showVideo
{
    [[Advertise shareInstance] playVideo];
}

#pragma mark Application Event

-(void)didEnterBackground
{
    [localnotification generateNotification];
}

-(void)willResignActive {
}

-(void)didBecomeActive {
    [self hideAdvertiseSpecial];
}

-(void)willTerminate
{
    [localnotification generateNotification];
}

-(void)receiveNotification:(UILocalNotification *)notification
{
}

-(void)handleOpenURL:(NSURL *)url {
    
}

- (id)init {
	return self;
}


static Business *instance;

#pragma mark Singleton stuff
+(id) alloc
{
	@synchronized(self)	
	{
		NSAssert(instance == nil, @"Attempted to allocate a second instance of the singleton: instance");
		instance = [[super alloc] retain];
		return instance;
	}
	
	// to avoid compiler warning
	return nil;
}

+(Business*) sharedInstance
{
	@synchronized(self)
	{
		if (instance == nil)
		{
			[[Business alloc] init];
		}
		
		return instance;
	}
	
	// to avoid compiler warning
	return nil;
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	
    if (instance) {
        [instance release];
        instance = nil;
    }
    
	[super dealloc];
}

@end
