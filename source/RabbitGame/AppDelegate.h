//
//  AppDelegate.h
//  RabbitGame
//
//  Created by pai hong on 12-6-20.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@class DelegateAssitant;

@interface AppDelegate : NSObject <UIApplicationDelegate
//,NSURLConnectionDelegate
> {
	UIWindow			*window;
	RootViewController	*viewController;
    
    DelegateAssitant *delegateAssitant;
    
//    NSMutableData *webData;
//    NSURLConnection *conn;
}
//@property (nonatomic,assign) NSMutableData *webData;
//@property (nonatomic,assign) NSURLConnection *conn;



@property (nonatomic, retain) UIWindow *window;

@property (nonatomic, retain) RootViewController *viewController;

//-(void)sendDeviveTokenToURL:(NSString *) httpURL appid:(NSString *) APPID deviceToken:(NSData *) deviceToken;

@end
