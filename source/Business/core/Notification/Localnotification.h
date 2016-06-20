//
//  Localnotification.h
//  iphone.localnotification
//
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"





@interface Localnotification : NSObject {
    
    NSString *cancel;
    NSString *message;
    
}
@property(nonatomic, retain)NSString *cancel;
@property(nonatomic, retain)NSString *message;

- (void)cancelAllLocalNotification;
- (void)setLastRuntime;
- (NSDate*)getLastRuntime;

- (void)createLocalNotifcation:(NSCalendarUnit)repeatUnit fireDate:(NSDate*)fireDate;
- (NSDate*)getFireDate:(NSDate*) date;
- (void)sendLocalNotification;

- (void)generateNotification;
@end
