//
//  BookLoader.m
//  BookReader
//
//  Created by terababy on 10-8-26.
//  Copyright 2010 terababy. All rights reserved.
//

#import "MyUserAnalyst.h"
#import "MobClick.h"
#import "CCLocalDataLoader.h"

#define EVENT_UNLOCK_LEVEL @"LevelUser"
#define EVENT_REPLAY_LEVEL @"LevelReplay"

@implementation MyUserAnalyst



+ (void)playLevel:(int)mode theme:(int)theme level:(int)level {
    
    NSString *levelStr = [NSString stringWithFormat:@"关卡%d_%d_%d", mode, theme, level];
    [MobClick event:EVENT_REPLAY_LEVEL label:levelStr];
    
    NSString *sendKey = [NSString stringWithFormat:@"SentLevelUser%d_%d_%d", mode, theme, level];
    BOOL sent = [[CCLocalDataLoader sharedLoader] boolForKey:sendKey];
    if (!sent) {
        NSString *levelStr = [NSString stringWithFormat:@"关卡%d_%d_%d", mode, theme, level];
        [MobClick event:EVENT_UNLOCK_LEVEL label:levelStr];
        [[CCLocalDataLoader sharedLoader] setBoolValue:TRUE forKey:sendKey];
    }
}

- (id)init {
	if (self == [super init]) {
        
	}
	return self;
}


@end
