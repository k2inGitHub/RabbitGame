//
//  TouchCanvas.m
//  RabbitGame
//
//  Created by pai hong on 12-6-25.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "TouchCanvas.h"
#import "Link.h"


@implementation TouchCanvas


//拷贝
-(id)initwithLink:(Link *)link{
    self = [super init];
    if (self) {
        //背景框子 50 * 50
        CCSprite *bg = [CCSprite spriteWithSpriteFrameName:@"放置高亮.png"];
        [self addChild:bg];
        
        //图标
        Link *touclink = [Link createByType:link.type andLelve:link.level];
        touclink.scale = 0.7;
        [self addChild:touclink];
    }
    return self;
}

//根据传过来的Link，拷贝一个
+(id)createByLink:(Link *)link{
    return  [[[self alloc] initwithLink:link] autorelease];
}















@end
