/*
 This file is part of Appirater.
 
 Copyright (c) 2010, Arash Payan
 All rights reserved.
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */
/*
 * Appirater.m
 * appirater
 *
 * Created by Arash Payan on 9/5/09.
 * http://arashpayan.com
 * Copyright 2010 Arash Payan. All rights reserved.
 */

#import "Appirater.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>

NSString *const kAppiraterFirstUseDate				= @"kAppiraterFirstUseDate";
NSString *const kAppiraterUseCount					= @"kAppiraterUseCount";
NSString *const kAppiraterSignificantEventCount		= @"kAppiraterSignificantEventCount";
NSString *const kAppiraterCurrentVersion			= @"kAppiraterCurrentVersion";
NSString *const kAppiraterRatedCurrentVersion		= @"kAppiraterRatedCurrentVersion";
NSString *const kAppiraterDeclinedToRate			= @"kAppiraterDeclinedToRate";
NSString *const kAppiraterReminderRequestDate		= @"kAppiraterReminderRequestDate";

//NSString *templateReviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APP_ID";
NSString *templateReviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APP_ID";

NSString *templateReviewURL1 = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APP_ID";

NSString *templateReviewURL7 = @"itms-apps://itunes.apple.com/app/idAPP_ID";


@interface Appirater (hidden)
- (BOOL)connectedToNetwork;
- (void)showRatingAlert;
- (BOOL)ratingConditionsHaveBeenMet;
- (void)incrementUseCount;
@end

@implementation Appirater (hidden)

- (BOOL)connectedToNetwork {
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        NSLog(@"Error. Could not recover network reachability flags");
        return NO;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
	
	NSURL *testURL = [NSURL URLWithString:@"http://www.apple.com/"];
	NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
	NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:testRequest delegate:self];
	
    return ((isReachable && !needsConnection) || nonWiFi) ? (testConnection ? YES : NO) : NO;
}

- (void)showRatingAlert {
	UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:title
														 message:message
														delegate:self
											   cancelButtonTitle:later
											   otherButtonTitles:ok, nil] autorelease];
//											   cancelButtonTitle:APPIRATER_CANCEL_BUTTON
//											   otherButtonTitles:APPIRATER_RATE_BUTTON, APPIRATER_RATE_LATER, nil] autorelease];
	self.ratingAlert = alertView;
	[alertView show];
}

- (BOOL)ratingConditionsHaveBeenMet {
	if (APPIRATER_DEBUG)
		return YES;
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSDate *dateOfFirstLaunch = [NSDate dateWithTimeIntervalSince1970:[userDefaults doubleForKey:kAppiraterFirstUseDate]];
	NSTimeInterval timeSinceFirstLaunch = [[NSDate date] timeIntervalSinceDate:dateOfFirstLaunch];
	NSTimeInterval timeUntilRate = 60 * 60 * 24 * appiraterDaysUntilPrompt;
	if (timeSinceFirstLaunch < timeUntilRate)
		return NO;
	
	// check if the app has been used enough
	int useCount = [userDefaults integerForKey:kAppiraterUseCount];
	if (useCount <= appiraterUserUntilPrompt)
		return NO;
	
	// check if the user has done enough significant events
	int sigEventCount = [userDefaults integerForKey:kAppiraterSignificantEventCount];
	if (sigEventCount <= appiraterSigEventsUntilPrompt)
		return NO;
	
	// has the user previously declined to rate this version of the app?
	if ([userDefaults boolForKey:kAppiraterDeclinedToRate])
		return NO;
	
	// has the user already rated the app?
	if ([userDefaults boolForKey:kAppiraterRatedCurrentVersion])
		return NO;
	
	// if the user wanted to be reminded later, has enough time passed?
	NSDate *reminderRequestDate = [NSDate dateWithTimeIntervalSince1970:[userDefaults doubleForKey:kAppiraterReminderRequestDate]];
	NSTimeInterval timeSinceReminderRequest = [[NSDate date] timeIntervalSinceDate:reminderRequestDate];
	NSTimeInterval timeUntilReminder = 60 * 60 * 24 * appiraterTimeBeforeReminding;
	if (timeSinceReminderRequest < timeUntilReminder)
		return NO;
	
	return YES;
}

- (void)incrementUseCount {
	// get the app's version
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
	
	// get the version number that we've been tracking
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *trackingVersion = [userDefaults stringForKey:kAppiraterCurrentVersion];
	if (trackingVersion == nil)
	{
		trackingVersion = version;
		[userDefaults setObject:version forKey:kAppiraterCurrentVersion];
	}
	
	if (APPIRATER_DEBUG)
		NSLog(@"APPIRATER Tracking version: %@", trackingVersion);
	
	if ([trackingVersion isEqualToString:version])
	{
		// check if the first use date has been set. if not, set it.
		NSTimeInterval timeInterval = [userDefaults doubleForKey:kAppiraterFirstUseDate];
		if (timeInterval == 0)
		{
			timeInterval = [[NSDate date] timeIntervalSince1970];
			[userDefaults setDouble:timeInterval forKey:kAppiraterFirstUseDate];
		}
		
		// increment the use count
		int useCount = [userDefaults integerForKey:kAppiraterUseCount];
		useCount++;
		[userDefaults setInteger:useCount forKey:kAppiraterUseCount];
		if (APPIRATER_DEBUG)
			NSLog(@"APPIRATER Use count: %d", useCount);
	}
	else
	{
		// it's a new version of the app, so restart tracking
		[userDefaults setObject:version forKey:kAppiraterCurrentVersion];
		[userDefaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:kAppiraterFirstUseDate];
		[userDefaults setInteger:1 forKey:kAppiraterUseCount];
		[userDefaults setInteger:0 forKey:kAppiraterSignificantEventCount];
		[userDefaults setBool:NO forKey:kAppiraterRatedCurrentVersion];
		[userDefaults setBool:NO forKey:kAppiraterDeclinedToRate];
		[userDefaults setDouble:0 forKey:kAppiraterReminderRequestDate];
	}
	
	[userDefaults synchronize];
}

- (void)incrementSignificantEventCount {
	// get the app's version
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
	
	// get the version number that we've been tracking
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *trackingVersion = [userDefaults stringForKey:kAppiraterCurrentVersion];
	if (trackingVersion == nil)
	{
		trackingVersion = version;
		[userDefaults setObject:version forKey:kAppiraterCurrentVersion];
	}
	
	if (APPIRATER_DEBUG)
		NSLog(@"APPIRATER Tracking version: %@", trackingVersion);
	
	if ([trackingVersion isEqualToString:version])
	{
		// check if the first use date has been set. if not, set it.
		NSTimeInterval timeInterval = [userDefaults doubleForKey:kAppiraterFirstUseDate];
		if (timeInterval == 0)
		{
			timeInterval = [[NSDate date] timeIntervalSince1970];
			[userDefaults setDouble:timeInterval forKey:kAppiraterFirstUseDate];
		}
		
		// increment the significant event count
		int sigEventCount = [userDefaults integerForKey:kAppiraterSignificantEventCount];
		sigEventCount++;
		[userDefaults setInteger:sigEventCount forKey:kAppiraterSignificantEventCount];
		if (APPIRATER_DEBUG)
			NSLog(@"APPIRATER Significant event count: %d", sigEventCount);
	}
	else
	{
		// it's a new version of the app, so restart tracking
		[userDefaults setObject:version forKey:kAppiraterCurrentVersion];
		[userDefaults setDouble:0 forKey:kAppiraterFirstUseDate];
		[userDefaults setInteger:0 forKey:kAppiraterUseCount];
		[userDefaults setInteger:1 forKey:kAppiraterSignificantEventCount];
		[userDefaults setBool:NO forKey:kAppiraterRatedCurrentVersion];
		[userDefaults setBool:NO forKey:kAppiraterDeclinedToRate];
		[userDefaults setDouble:0 forKey:kAppiraterReminderRequestDate];
	}
	
	[userDefaults synchronize];
}

@end


@interface Appirater ()
- (void)hideRatingAlert;
@end

@implementation Appirater

@synthesize appId;
@synthesize delegate;
@synthesize ratingAlert;
@synthesize message;
@synthesize title;
@synthesize cancel;
@synthesize later;
@synthesize ok;

@synthesize appiraterDaysUntilPrompt;
@synthesize appiraterUserUntilPrompt;
@synthesize appiraterSigEventsUntilPrompt;
@synthesize appiraterTimeBeforeReminding;



+ (Appirater*)sharedInstance {
	static Appirater *appirater = nil;
	if (appirater == nil)
	{
		@synchronized(self) {
			if (appirater == nil) {
				appirater = [[Appirater alloc] init];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:@"UIApplicationWillResignActiveNotification" object:nil];
            }
        }
	}
	
	return appirater;
}

- (void)setMessage:(NSString *)message2 {
    if (message) {
        [message release];
    }
    message = [message2 retain];
}

- (void)setTitle:(NSString *)title2 {
    if (title) {
        [title release];
    }
    title = [title2 retain];
}

- (void)setOk:(NSString *)ok2 {
    if (ok) {
        [ok release];
    }
    ok = [ok2 retain];
}

- (void)setCancel:(NSString *)cancel2 {
    if (cancel) {
        [cancel release];
    }
    cancel = [cancel2 retain];
}

- (void)setLater:(NSString *)later2 {
    if (later) {
        [later release];
    }
    later = [later2 retain];
}

- (id)init {
	if (self == [super init]) {
        
        self.message = [NSString stringWithFormat:@"喜欢这个游戏吗, 给个5星好评吧! 激励我们推出更多免费升级! ^_^"];
        self.title = @"鼓励一下我们吧";
        self.cancel = @"No, Thanks";
        self.later = @"就不给";
        self.ok =  @"现在去评分 :)";
        
        appiraterDaysUntilPrompt = 1;
        appiraterUserUntilPrompt = 10;
        appiraterSigEventsUntilPrompt = -1;
        appiraterTimeBeforeReminding = 1;
        delegate = nil;
	}
	return self;
}

- (void)incrementAndRate:(NSNumber*)_canPromptForRating {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[self incrementUseCount];
	
	if ([_canPromptForRating boolValue] == YES &&
		[self ratingConditionsHaveBeenMet] &&
		[self connectedToNetwork])
	{
		[self performSelectorOnMainThread:@selector(showRatingAlert) withObject:nil waitUntilDone:NO];
	}
	
	[pool release];
}

- (void)incrementSignificantEventAndRate:(NSNumber*)_canPromptForRating {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[self incrementSignificantEventCount];
	
	if ([_canPromptForRating boolValue] == YES &&
		[self ratingConditionsHaveBeenMet] &&
		[self connectedToNetwork])
	{
		[self performSelectorOnMainThread:@selector(showRatingAlert) withObject:nil waitUntilDone:NO];
	}
	
	[pool release];
}

+ (void)appLaunched {
	[Appirater appLaunched:YES];
}

+ (void)appLaunched:(BOOL)canPromptForRating {
	NSNumber *_canPromptForRating = [[NSNumber alloc] initWithBool:canPromptForRating];
	[NSThread detachNewThreadSelector:@selector(incrementAndRate:)
							 toTarget:[Appirater sharedInstance]
						   withObject:_canPromptForRating];
	[_canPromptForRating release];
}

- (void)hideRatingAlert {
	if (self.ratingAlert.visible) {
		if (APPIRATER_DEBUG)
			NSLog(@"APPIRATER Hiding Alert");
		[self.ratingAlert dismissWithClickedButtonIndex:-1 animated:NO];
	}	
}

+ (void)appWillResignActive {
	if (APPIRATER_DEBUG)
		NSLog(@"APPIRATER appWillResignActive");
	[[Appirater sharedInstance] hideRatingAlert];
}

+ (void)appEnteredForeground:(BOOL)canPromptForRating {
	NSNumber *_canPromptForRating = [[NSNumber alloc] initWithBool:canPromptForRating];
	[NSThread detachNewThreadSelector:@selector(incrementAndRate:)
							 toTarget:[Appirater sharedInstance]
						   withObject:_canPromptForRating];
	[_canPromptForRating release];
}

+ (void)userDidSignificantEvent:(BOOL)canPromptForRating {
	NSNumber *_canPromptForRating = [[NSNumber alloc] initWithBool:canPromptForRating];
	[NSThread detachNewThreadSelector:@selector(incrementSignificantEventAndRate:)
							 toTarget:[Appirater sharedInstance]
						   withObject:_canPromptForRating];
	[_canPromptForRating release];
}

+ (void)rateApp:(NSString*)appID {
#if TARGET_IPHONE_SIMULATOR
	NSLog(@"APPIRATER NOTE: iTunes App Store is not supported on the iOS simulator. Unable to open App Store page.");
#else
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *reviewURL = [templateReviewURL1 stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@", appID]];
    if ( [[UIDevice currentDevice].systemVersion floatValue] >= 7.0){
        reviewURL = [templateReviewURL7 stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@", appID]];
    }
	[userDefaults setBool:YES forKey:kAppiraterRatedCurrentVersion];
	[userDefaults synchronize];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
#endif
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
//    if (delegate) {
//        [delegate alertView:alertView clickedButtonAtIndex:buttonIndex];
//    } else {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        switch (buttonIndex) {
            case 2:
            {
                // they don't want to rate it
                [userDefaults setBool:YES forKey:kAppiraterDeclinedToRate];
                [userDefaults synchronize];
                break;
            }
            case 1:
            {
                // they want to rate it
                [Appirater rateApp:appId];
                break;
            }
            case 0:
                // remind them later
                [userDefaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:kAppiraterReminderRequestDate];
                [userDefaults synchronize];
                break;
            default:
                break;
//        }
    }
}

@end
