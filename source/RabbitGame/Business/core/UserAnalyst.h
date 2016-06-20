//
//  LocalScoreLoader.h
//  BookReader
//
//  Created by terababy on 10-8-26.
//  Copyright 2010 terababy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserAnalyst : NSObject {
}

+ (void)startWithAppkey:(NSString *)appkey;
+ (void)updateOnlineConfig;
+ (void)playLevel:(int)level;
+ (void)broadcast:(NSString*)channel;
+ (void)promotion:(NSString*)toApp;
+ (bool)isOpenFlag:(NSString*)key;
+ (int)getIntFlag:(NSString*)key defaultValue:(int)defaultV;
+ (NSString*)getOnlineParam:(NSString*)key;
@end
