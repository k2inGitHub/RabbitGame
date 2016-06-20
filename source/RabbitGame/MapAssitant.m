//
//  MapAssitant.m
//  RabbitGame
//
//  Created by pai hong on 12-7-24.
//  Copyright (c) 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "MapAssitant.h"
#import "WorldMapScene.h"
#import "CCAnimationHelper.h"


@implementation MapAssitant

-(id)initWithMap:(WorldMapScene *)worldmap{
    self = [super init];
    if (self) {
        
        delegate = worldmap;
        
        //小动物
        [self createAnimal];
        
        //云朵
        [self createCloud];
        
        [self performSelector:@selector(rollClound) withObject:nil afterDelay:3];
        
    }
    
    return self;
}


#pragma mark ---创建小动物---

//放入场景
-(void)putAniToMap:(CCSprite *)anim{
    int len = [animalPosition count];
    
    int a = arc4random()%len;
    
    CGPoint point = [[animalPosition objectAtIndex:a] CGPointValue];
    
    anim.position = point;
    
    [delegate addChild:anim];
}

//开始运动
-(void)startjump:(CCSprite *)anim{
    NSArray *a1 = [NSArray arrayWithObjects:
                   @"animala1.png",
                   @"animala2.png",
                   @"animala3.png",
                   @"animala4.png",
                   @"animala5.png",
                   @"animala6.png",
                   nil];
    NSArray *a2 = [NSArray arrayWithObjects:
                   @"animalb1.png",
                   @"animalb2.png",
                   @"animalb3.png",
                   @"animalb4.png",
                   @"animalb5.png",
                   @"animalb6.png",
                   nil];
    //
    CCAnimation *animationa = [CCAnimation animationWithNames:a1 delay:0.2];
    CCAnimation *animationb = [CCAnimation animationWithNames:a2 delay:0.2];
    
    CCAnimate *animatea = [CCAnimate actionWithAnimation:animationa];
    CCAnimate *animateb = [CCAnimate actionWithAnimation:animationb];
    
    CCRepeatForever *repeat;
    
    if (anim.tag==1) {//a
        repeat = [CCRepeatForever actionWithAction:animatea];
    }else {
        repeat = [CCRepeatForever actionWithAction:animateb];
    }
    
    int len = [animalPosition count];
    int i = arc4random()%len;
    CGPoint point = [[animalPosition objectAtIndex:i] CGPointValue];
    
    float distance = ccpDistance(anim.position, point);
    
    float time = distance / 10; //分母越小，走的越慢
    
    if (anim.position.x <= point.x) {
        anim.scaleX = -0.7;
    }else {
        anim.scaleX = 0.7;
    }
    
    CCMoveTo *movto = [CCMoveTo actionWithDuration:time position:point];
    
    CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(animalMoveOver:)];
    
    CCSequence *seq = [CCSequence actions:movto,callback, nil];
    
    
    //CCSpawn *spawn = [CCSpawn actions:seq,repeat, nil];
    
    [anim runAction:repeat];
    [anim runAction:seq];
}


-(void)animalMoveOver:(CCSprite *)anim{
    [anim stopAllActions];
    [self startjump:anim];
}



//创建小动物
-(void)createAnimal{
    
    animalPosition = [[NSArray arrayWithObjects:
                      [NSValue valueWithCGPoint:ccp(24,424)],
                      [NSValue valueWithCGPoint:ccp(56,401)],
                      [NSValue valueWithCGPoint:ccp(171,415)],
                      [NSValue valueWithCGPoint:ccp(280,371)],
                      [NSValue valueWithCGPoint:ccp(100,346)],
                      [NSValue valueWithCGPoint:ccp(25,316)],
                      [NSValue valueWithCGPoint:ccp(116,297)],
                      [NSValue valueWithCGPoint:ccp(218,315)],
                      [NSValue valueWithCGPoint:ccp(21,255)],
                      [NSValue valueWithCGPoint:ccp(164,183)],
                      [NSValue valueWithCGPoint:ccp(93,136)],
                      [NSValue valueWithCGPoint:ccp(179,129)],
                      nil] retain];
    
    //小动物1
    CCSprite *aniA = [CCSprite spriteWithSpriteFrameName:@"animala1.png"];
    aniA.tag = 1;
    aniA.scaleX = 0.7;
    aniA.scaleY = 0.7;
    [self putAniToMap:aniA];
    
    //小动物2
    CCSprite *aniB = [CCSprite spriteWithSpriteFrameName:@"animalb1.png"];
    aniB.tag = 2;
    aniB.scaleX = 0.7;
    aniB.scaleY = 0.7;
    [self putAniToMap:aniB];
    
    [self startjump:aniA];
    [self startjump:aniB];
    
    
}


#pragma mark ---创建云朵逻辑---

-(void)moveover:(CCSprite *)sp{
    [sp removeFromParentAndCleanup:YES];
}


-(void)startMove:(CCSprite *)sp{
    CGPoint point = sp.position;
    point.x -= 400;
    
    CCCallFuncN *callfunc = [CCCallFuncN actionWithTarget:self selector:@selector(moveover:)];
    CCMoveTo *move = [CCMoveTo actionWithDuration:75 position:point];
    
    CCSequence *sequence = [CCSequence actions:move,callfunc, nil];
    
    [sp runAction:sequence];
}



-(void)createCloud{
    for (int i=0; i<6; i++) {

        int num = (arc4random() % 9) + 1;
        
        NSString *strname = [NSString stringWithFormat:@"云彩0%d.png",num];
        
        CCSprite *sp = [CCSprite spriteWithSpriteFrameName:strname];
        
        int px = arc4random() % 300;
        int py = arc4random() % 380 + 100;
        
        sp.position = CGPointMake(px,py);
        
        [delegate addChild:sp z:1];
        
        [self startMove:sp];
    }
}


-(void)rollClound{
    int num = (arc4random() % 9) + 1;
    NSString *strname = [NSString stringWithFormat:@"云彩0%d.png",num];
    CCSprite *sp = [CCSprite spriteWithSpriteFrameName:strname];
    
    int px = 360;
    int py = arc4random() % 380+40;
    
    sp.position = CGPointMake(px,py);
    
    [delegate addChild:sp z:1];
    
    [self startMove:sp];
    
    [self performSelector:@selector(rollClound) withObject:nil afterDelay:12];
}


-(void)dispnse{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [animalPosition release];
}




#pragma mark ---创建小动物逻辑---










@end
