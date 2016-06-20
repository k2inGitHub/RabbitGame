//
//  CloudController.m
//  RabbitGame
//
//  Created by pai hong on 12-8-3.
//  Copyright (c) 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "CloudController.h"


@implementation CloudController

@synthesize delegate;


- (id)initWithDelegate:(id)d;
{
    self = [super init];
    if (self) {
        delegate = d;
        [self createCloud];
        
        [self performSelector:@selector(rollClound) withObject:nil afterDelay:3];
    }
    return self;
}


#pragma mark ---创建云朵逻辑---

-(void)moveover:(CCSprite *)sp{
    [sp removeFromParentAndCleanup:YES];
}


-(void)startMove:(CCSprite *)sp{
    CGPoint point = sp.position;
    point.x -= 600;
    
    CCCallFuncN *callfunc = [CCCallFuncN actionWithTarget:self selector:@selector(moveover:)];
    CCMoveTo *move = [CCMoveTo actionWithDuration:100 position:point];
    
    CCSequence *sequence = [CCSequence actions:move,callfunc, nil];
    
    [sp runAction:sequence];
}



-(void)createCloud{
    for (int i=0; i<2; i++) {
        
        int num = (arc4random() % 9) + 1;
        
        NSString *strname = [NSString stringWithFormat:@"阴影0%d.png",num];
        
        CCSprite *sp = [CCSprite spriteWithSpriteFrameName:strname];
        
        int px = arc4random() % 300;
        int py = arc4random() % 380 + 100;
        
        sp.position = CGPointMake(px,py);
        
        [delegate addChild:sp z:99];
        
        [self startMove:sp];
    }
}


-(void)rollClound{
    int num = (arc4random() % 9) + 1;
    NSString *strname = [NSString stringWithFormat:@"阴影0%d.png",num];
    CCSprite *sp = [CCSprite spriteWithSpriteFrameName:strname];
    
    int px = 360;
    int py = arc4random() % 380+40;
    
    sp.position = CGPointMake(px,py);
    sp.anchorPoint = ccp(0,0.5);
    
    [delegate addChild:sp z:99];
    
    [self startMove:sp];
    
    [self performSelector:@selector(rollClound) withObject:nil afterDelay:22];
}

-(void)disponse{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    delegate = nil;
}


@end
