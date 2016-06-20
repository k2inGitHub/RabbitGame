//
//  Localnotification.m
//  iphone.localnotification
//
//  Created by GAO FENG on 11-7-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Localnotification.h"
#import "MyUserAnalyst.h"

@implementation Localnotification

@synthesize cancel;
@synthesize message;

#define CPH_OFFLINE 5
#define FREE_COIN_FULL 50
#define NOTIFICATION_TIME_EACHDAY 20
#define KEY_LAST_RUNTIME @"LastRuntime"

#define KEY_BUTTON_CANCEL_EN   @"OK!"
#define KEY_BUTTON_CANCEL_CN   @"确定"

#define KEY_BUTTON_GO_EN    @"Let's go！"
#define KEY_BUTTON_GO_CN    @"好吧！"

int freecoin;

- (void)cancelAllLocalNotification {
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (NSDate*) getLastRuntime {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *date = [defaults objectForKey:KEY_LAST_RUNTIME];
    return date;
}

- (void) setLastRuntime {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSDate date] forKey:KEY_LAST_RUNTIME];
}


- (void)createLocalNotifcation:(NSCalendarUnit)repeatUnit fireDate:(NSDate*)fireDate cancelString:(NSString*)cancelString okString:(NSString*)okString body:(NSString*)body {
    
    UILocalNotification *notification=[[UILocalNotification alloc] init]; 
    notification.timeZone=[NSTimeZone defaultTimeZone]; 
    notification.repeatInterval = repeatUnit;
    notification.applicationIconBadgeNumber = 1;
    notification.alertAction = okString;
    notification.alertLaunchImage=cancelString;
    
    notification.fireDate = fireDate;
    notification.alertBody = body;
    [notification setSoundName:UILocalNotificationDefaultSoundName];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


- (void)createLocalNotifcation:(NSCalendarUnit)repeatUnit fireDate:(NSDate*)fireDate {
    
    [self createLocalNotifcation: repeatUnit fireDate:fireDate cancelString:cancel okString:KEY_BUTTON_GO_CN body:message];
}

- (NSDate *) getFireDate:(NSDate*) date {
	NSCalendar *gregorian= [NSCalendar currentCalendar];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit;
	NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];
    NSDate *fireDate = nil;
    while(true) {
        comps.hour = NOTIFICATION_TIME_EACHDAY;
        comps.day += 1;
        fireDate = [gregorian dateFromComponents:comps];
        NSTimeInterval time=[fireDate timeIntervalSinceDate:date];
        if (time > 0) {
            break;
        }
    }
	return fireDate;
}

- (NSDate *) getWeekendFireDate:(NSDate*) date {
	NSCalendar *gregorian= [NSCalendar currentCalendar];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit| NSHourCalendarUnit;
	NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];
    NSDate *fireDate = nil;
    while(true) {
        int day2 = comps.day + 1;
        comps.hour = NOTIFICATION_TIME_EACHDAY;
        comps.day = day2;
        fireDate = [gregorian dateFromComponents:comps];
        NSTimeInterval time=[fireDate timeIntervalSinceDate:date];
        NSDateComponents *comps2 = [gregorian components:unitFlags fromDate:fireDate];
        if (time > 0 && comps2.weekday == 7) {
            break;
        }
    }
	return fireDate;
}

- (void)sendLocalNotification {
    
    [self cancelAllLocalNotification];
    
    NSDate *lastRuntime = [self getLastRuntime];
    
    NSTimeInterval time=[[NSDate date] timeIntervalSinceDate:lastRuntime];
    int day = time / 3600*24;
    
    NSDate *fireDate = [self getFireDate:[NSDate date]];
    if (day == 0 || day == 1) {
        //[self createLocalNotifcation:kCFCalendarUnitDay fireDate:fireDate];
    } else if (day == 2) {
        [self createLocalNotifcation:kCFCalendarUnitWeek fireDate:[fireDate dateByAddingTimeInterval:3600*24*2]];
        [self createLocalNotifcation:kCFCalendarUnitWeek fireDate:[fireDate dateByAddingTimeInterval:3600*24*4]];
        [self createLocalNotifcation:kCFCalendarUnitWeek fireDate:[fireDate dateByAddingTimeInterval:3600*24*6]];
    } else if (day >= 3) {
        [self createLocalNotifcation:kCFCalendarUnitWeek fireDate:[fireDate dateByAddingTimeInterval:3600*24*3]];
        [self createLocalNotifcation:kCFCalendarUnitWeek fireDate:[fireDate dateByAddingTimeInterval:3600*24*6]];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
    NSString *speDates = [MyUserAnalyst getOnlineParam:@"NotificationSpecialDay"];
	NSArray *array = [speDates componentsSeparatedByString:@"|"];
    int count = [array count];
    for (int i = 0; i < count - 1; i ++) {
        NSDate *date = [dateFormatter dateFromString:[array objectAtIndex:i]];
        [self createLocalNotifcation:kCFCalendarUnitWeek fireDate:date cancelString:@"没空啦" okString:KEY_BUTTON_GO_CN body:[array objectAtIndex:count - 1]];
    }
    
    
    NSDate *fireWDate = [self getWeekendFireDate:[NSDate date]];
    [self createLocalNotifcation:kCFCalendarUnitWeek fireDate:fireWDate];
}

- (void)generateNotification {
    [self sendLocalNotification];
    [self setLastRuntime];
}

- (void)dealloc {
    [super dealloc];
}

@end
