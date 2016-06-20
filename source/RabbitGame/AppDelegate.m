//
//  AppDelegate.m
//  RabbitGame
//
//  Created by pai hong on 12-6-20.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

//#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "BeginScene.h"
#import "RootViewController.h"
#import "DelegateAssitant.h"

#import "Business.h"
#import "Appirater.h"
#import "MyAppiraterDelegate.h"
#import "GameScene.h"
#import "GameDayPrize.h"
#import "EncryptionConfig.h"
#import "MyUserAnalyst.h"
#import "Configuration.h"
#import "MobClick.h"
#import "HLService.h"
#import "SimpleAudioEngine.h"

@implementation AppDelegate

@synthesize window;
@synthesize viewController = viewController;
//@synthesize webData;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}
- (void) applicationDidFinishLaunching:(UIApplication*)application
{
    
    
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
    
    

    
    viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];


	// Init the View Controller
	viewController.wantsFullScreenLayout = YES;
    
    [Globel shareGlobel].rootController = viewController;
	SEL selector = sel_registerName([@"setRootViewController:" UTF8String]);
	if ([window respondsToSelector:selector]) {
        window.rootViewController = viewController;	
    }
    
    [[HLInterface sharedInstance] startGet];
    [HLAdManager sharedInstance];
    [HLAnalyst start];
    
    // 加入商业逻辑
    Business *business = [Business sharedInstance];
    [business startWithAppId:AppId
                   iPhoneKey:AdvertiseId
                     iPadKey:nil
                  umenAppKey:umengAppKey
               useGameCenter:false
                 notifyQuote:@"亲们，赶紧来吧，兔兔等得花儿都谢了！~现在进入游戏免费拿金币哦~"];
    
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
	if( ! [director enableRetinaDisplay:YES] )
	{
		CCLOG(@"Retina Display Not Supported.");
	}
	else
	{
		CCLOG(@"Retina Display Supported.");
	}
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
//	if( ! [director enableRetinaDisplay:YES] )
//		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
//	[director setDisplayFPS:YES];
    [director setDisplayFPS:NO];
    [director setProjection:CCDirectorProjection3D];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    NSLog(@"Initiating remoteNoticationssAreActive");
    //if(!application.enabledRemoteNotificationTypes){
//        NSLog(@"Initiating remoteNoticationssAreActive1");
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    //}
    
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene:[BeginScene scene] ];
    //[[CCDirector sharedDirector] runWithScene: [HelloWorldLayer scene] ];
    
    delegateAssitant = [[DelegateAssitant alloc] init];
    
    [[Globel shareGlobel].allDataConfig setValue:[NSNumber numberWithBool:false] forKey:@"Ruan"];
    CCLOG(@"size = %@",NSStringFromCGSize([[CCDirector sharedDirector] winSize]));
//    
//    [Appirater rateApp:@"623734317"];
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgm.mp3" loop:YES];
    
    [self performSelector:@selector(showAd) withObject:nil afterDelay:6];
}
- (void)showAd{
    if ([HLAnalyst boolValue:@"init_show_ad"]) {
        [[HLAdManager sharedInstance] showUnsafeInterstitial];
    }
}

//- (void)sendDeviveTokenToURL:(NSString *)httpURL appid:(NSString *)APPID deviceToken:(NSData *)deviceToken
//{
//    NSString *deviceTokenString=[deviceToken description];
//    NSString *postStr =
//    [NSString stringWithFormat:@"APPID=%@&DevicePost=%@",APPID,deviceTokenString];
//    NSURL *url = [NSURL URLWithString:httpURL];
//    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
//    NSString *strLength = [NSString stringWithFormat:@"%d", [postStr length]];
//    [req addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [req addValue:strLength forHTTPHeaderField:@"Content-Length"];
//    [req setHTTPMethod:@"POST"];
//    [req setHTTPBody: [postStr dataUsingEncoding:NSUTF8StringEncoding]];
//    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
//    if (conn) {
//        webData = [[NSMutableData data] retain];
//    }
//}
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse
//                                                                     *)response
//{
//    // This method is called when the server has determined that it
//    // has enough information to create the NSURLResponse.
//    // It can be called multiple times, for example in the case of a
//    // redirect, so each time we reset the data.
//    // receivedData is an instance variable declared elsewhere.
//    [webData setLength:0];
//}
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    // Append the new data to receivedData.
//    // receivedData is an instance variable declared elsewhere.
//    [webData appendData:data];
//    NSLog(@"YES!%@",[[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding]);
//}
//- (void)connection:(NSURLConnection *)connection
//  didFailWithError:(NSError *)error
//{
//    // release the connection, and the data object
//    [conn release];
//    // receivedData is declared as a method instance elsewhere
//    [webData release];
//    // inform the user
//    NSLog(@"Connection failed! Error - %@ %@",
//          [error localizedDescription],
//          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
//}

//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    bool sent = [defaults boolForKey:@"SentToken"];
//    if (!sent) {
//        [self sendDeviveTokenToURL:@"http://211.99.196.19/apns/getToken.php" appid:@"16" deviceToken:deviceToken];
//        NSLog(@"APN device token: %@", deviceToken);
//        [defaults setBool:TRUE forKey:@"SentToken"];
//        [defaults synchronize];
//    }
//    
//}
//
//- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
//    NSLog(@"Error %@",err);
//    
//}


- (void)applicationWillResignActive:(UIApplication *)application {
    [[Business sharedInstance] willResignActive];
	[[CCDirector sharedDirector] pause];
    [[SimpleAudioEngine sharedEngine]pauseBackgroundMusic];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [[Business sharedInstance] didBecomeActive];
	[[CCDirector sharedDirector] resume];
    [[SimpleAudioEngine sharedEngine]resumeBackgroundMusic];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
    [[Business sharedInstance] didEnterBackground];
    //程序进入后台
    [delegateAssitant applicationEnterBack];
    
	[[CCDirector sharedDirector] stopAnimation];
    
    
    bool clickedRuan = false;
    NSObject *obj =  [[Globel shareGlobel].allDataConfig objectForKey:@"Ruan"];
    if (obj) {
        clickedRuan = [((NSNumber*)obj) boolValue];
        if (clickedRuan) {
            
            NSString *lastdatestr = [[Globel shareGlobel].allDataConfig objectForKey:@"RuanTime"];
            if (![lastdatestr isEqualToString:@""]) {
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                NSDate *lasetdate = [df dateFromString:lastdatestr];
                
                NSTimeInterval spacetime = [lasetdate timeIntervalSinceNow];
                
                [df release];
                
                if (-spacetime < 30) {
                    
                    GameScene *scene = [GameScene shareInstance];
                    if (scene) {
                        GameDayPrize *gamedayprize = [GameDayPrize node];
                        if ([gamedayprize isNewDayRecommend]) {
                            [gamedayprize updateNewDayRecommend];
                            
                            [MobClick event:@"Interstitial" label:@"RecommendOK"];
                            [[Globel shareGlobel].allDataConfig setValue:[NSNumber numberWithBool:false] forKey:@"Ruan"];
                            [scene add_cut_money:500];
                            [scene removeRuanButton];
                            [[EncryptionConfig shareInstance] saveConfig:[Globel shareGlobel].allDataConfig];
                            exit(1);
                            
                        }
                    }
                }
            }
        }
    }
    
    
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
    //程序进入前台
    [delegateAssitant applicationEnterFront];
    
	[[CCDirector sharedDirector] startAnimation];
    
    [[Globel shareGlobel].allDataConfig setValue:[NSNumber numberWithBool:false] forKey:@"Ruan"];
    
    int alpha = [MyUserAnalyst getIntFlag:@"IntersForeground" defaultValue:0];
    int idx = arc4random() % 100;
    if (idx < alpha && GeneralOnOff) {
        [MobClick event:@"Interstitial" label:@"Foreground"];
        [[Business sharedInstance] performSelector:@selector(showHalfBanner) withObject:nil afterDelay:1.0f];
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[Business sharedInstance] willTerminate];
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    [[Business sharedInstance] receiveNotification:notification];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    [[Business sharedInstance] handleOpenURL:url];
    return YES;
}

- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[window release];
	[super dealloc];
}

@end
