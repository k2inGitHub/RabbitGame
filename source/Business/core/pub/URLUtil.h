//
//  AppStore.h
//  SuperCoaster
//
//  Created by terababy on 10-11-22.
//  Copyright 2010 terababy. All rights reserved.
//


#import <Foundation/Foundation.h>
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#import <UIKit/UIKit.h>
#endif 

@interface URLUtil : NSObject{
	
}
+ (URLUtil *) sharedInstance;

//+(NSString*)getCountryCode;
//+(NSString*)getCountryCodeByCarrier;

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
+(void)launchURL:(NSString*)url;
+(void)launchAppstore:(NSString*)appid;
+(void)launchGoogleMap:(NSString*) searchQuery;
+(void)launchAppleMail:(NSString*)address;
+(void)launchPhone:(NSString*)phoneNo;
+(void)launchSMS:(NSString*)phoneNo;
+(void)launchAppleMailInApp:(UIView*)view recipient:(NSString*)recipient subject:(NSString*)subject body:(NSString*)body image:(UIImage*)image imageType:(NSString*)type;

#endif 
+(NSString*)getCurrentLanguage;
+(NSString*)getLocaleImageName:(NSString *)imageName;
+(void)sendTwitterMsg:(NSString*)message appID:(NSString*)appID;
+(void)sendFacebookMsg:(NSString*)message;
@end
