//
//  EEMaskSprite.m
//  RabbitGame
//
//  Created by pai hong on 12-6-24.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "EEMaskSprite.h"


@implementation EEMaskSprite

- (id)init
{
    self = [super init];
    if (self) {
        //[self setIsTouchEnabled:YES];
        
        //注册事件
        //[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:kCCMenuTouchPriority swallowsTouches:YES];
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    }
    return self;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    trace(@"停止冒泡");
    //停止冒泡
    return YES;
}

-(void)onExit{
    //回收事件
    trace(@"回收事件");
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}
@end
