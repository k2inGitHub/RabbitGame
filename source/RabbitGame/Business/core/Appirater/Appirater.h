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
 * Appirater.h
 * appirater
 *
 * Created by Arash Payan on 9/5/09.
 * http://arashpayan.com
 * Copyright 2010 Arash Payan. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const kAppiraterFirstUseDate;
extern NSString *const kAppiraterUseCount;
extern NSString *const kAppiraterSignificantEventCount;
extern NSString *const kAppiraterCurrentVersion;
extern NSString *const kAppiraterRatedCurrentVersion;
extern NSString *const kAppiraterDeclinedToRate;

/*
 Place your Apple generated software id here.
 */
//#define APPIRATER_APP_ID				301377083

/*
 Your app's name.
 */
#define APPIRATER_APP_NAME				[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey]


/*
 'YES' will show the Appirater alert everytime. Useful for testing how your message
 looks and making sure the link to your app's review page works.
 */
#define APPIRATER_DEBUG				NO

@protocol AppiraterDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


@interface Appirater : NSObject <UIAlertViewDelegate> {
    
    NSString *appId;

	UIAlertView		*ratingAlert;
    
    //This is the message your users will see once they've passed the day+launches threshold.
    NSString *message;
    //This is the title of the message alert that users will see.
    NSString *title;
    //The text of the button that rejects reviewing the app.
    NSString *cancel;
    //Text for button to remind the user to review later.
    NSString *later;
    //Text of button that will send user to app review page.
    NSString *ok;
    
    int appiraterDaysUntilPrompt;
    int appiraterUserUntilPrompt;
    int appiraterSigEventsUntilPrompt;
    int appiraterTimeBeforeReminding;
    
    id<AppiraterDelegate>  delegate;
}
@property(nonatomic, retain) NSString *appId;
@property(nonatomic, retain) UIAlertView *ratingAlert;
@property(nonatomic, assign) id<AppiraterDelegate> delegate;

@property(nonatomic, retain) NSString *message;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *cancel;
@property(nonatomic, retain) NSString *later;
@property(nonatomic, retain) NSString *ok;

@property(nonatomic, assign) int appiraterDaysUntilPrompt;
@property(nonatomic, assign) int appiraterUserUntilPrompt;
@property(nonatomic, assign) int appiraterSigEventsUntilPrompt;
@property(nonatomic, assign) int appiraterTimeBeforeReminding;

+ (Appirater*)sharedInstance;
/*
 DEPRECATED: While still functional, it's better to use
 appLaunched:(BOOL)canPromptForRating instead.
 
 Calls [Appirater appLaunched:YES]. See appLaunched: for details of functionality.
 */
+ (void)appLaunched;

/*
 Tells Appirater that the app has launched, and on devices that do NOT
 support multitasking, the 'uses' count will be incremented. You should
 call this method at the end of your application delegate's
 application:didFinishLaunchingWithOptions: method.
 
 If the app has been used enough to be rated (and enough significant events),
 you can suppress the rating alert
 by passing NO for canPromptForRating. The rating alert will simply be postponed
 until it is called again with YES for canPromptForRating. The rating alert
 can also be triggered by appEnteredForeground: and userDidSignificantEvent:
 (as long as you pass YES for canPromptForRating in those methods).
 */
+ (void)appLaunched:(BOOL)canPromptForRating;

/*
 Tells Appirater that the app was brought to the foreground on multitasking
 devices. You should call this method from the application delegate's
 applicationWillEnterForeground: method.
 
 If the app has been used enough to be rated (and enough significant events),
 you can suppress the rating alert
 by passing NO for canPromptForRating. The rating alert will simply be postponed
 until it is called again with YES for canPromptForRating. The rating alert
 can also be triggered by appLaunched: and userDidSignificantEvent:
 (as long as you pass YES for canPromptForRating in those methods).
 */
+ (void)appEnteredForeground:(BOOL)canPromptForRating;

/*
 Tells Appirater that the user performed a significant event. A significant
 event is whatever you want it to be. If you're app is used to make VoIP
 calls, then you might want to call this method whenever the user places
 a call. If it's a game, you might want to call this whenever the user
 beats a level boss.
 
 If the user has performed enough significant events and used the app enough,
 you can suppress the rating alert by passing NO for canPromptForRating. The
 rating alert will simply be postponed until it is called again with YES for
 canPromptForRating. The rating alert can also be triggered by appLaunched:
 and appEnteredForeground: (as long as you pass YES for canPromptForRating
 in those methods).
 */
+ (void)userDidSignificantEvent:(BOOL)canPromptForRating;

/*
 Tells Appirater to open the App Store page where the user can specify a
 rating for the app. Also records the fact that this has happened, so the
 user won't be prompted again to rate the app.

 The only case where you should call this directly is if your app has an
 explicit "Rate this app" command somewhere.  In all other cases, don't worry
 about calling this -- instead, just call the other functions listed above,
 and let Appirater handle the bookkeeping of deciding when to ask the user
 whether to rate the app.
 */
+ (void)rateApp:(NSString*)appID;

@end
