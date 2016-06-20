//
//  GameRoom.m
//  RabbitGame
//
//  Created by pai hong on 12-7-2.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "GameRoom.h"


@implementation GameRoom

@synthesize locked;
@synthesize roomId;

- (id)init
{
    self = [super init];
    if (self) {
        dishes = NULL;
    }
    return self;
}

- (void)unlock:(bool)unlock
{
    if (dishes) {
        [dishes removeFromParentAndCleanup:true];
        dishes = NULL;
    }
    if (unlock) {
        locked = false;
        dishes = [CCSprite spriteWithSpriteFrameName:@"仓库.png"];
        dishes.position = ccp(25,25);
        [self addChild:dishes];
    } else {
        locked = true;
        dishes = [CCSprite spriteWithFile:@"blanklock.png"];
        dishes.position = ccp(25,32);
        [self addChild:dishes];
    }
}

//是否为空
-(BOOL)isEmpty{
    if (storeLink==nil) {
        return YES;
    }else {
        return NO;
    }
}

//吧link塞入store
-(void)pushLinkToStore:(Link *)link{
    link.scale = 0.8;
    link.position = ccp(25,35);
    [self addChild:link];
    storeLink = link;
}

//从store中删除link
-(Link *)deleteLinkFromStore{
    if (storeLink!=nil) {
        [storeLink retain];
        [storeLink removeFromParentAndCleanup:YES];
        return storeLink;
    }else {
        return nil;
    }
}

-(Link *)getStoreLink{
    return storeLink;
}















@end
