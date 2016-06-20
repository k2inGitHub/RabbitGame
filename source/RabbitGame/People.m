//
//  People.m
//  RabbitGame
//
//  Created by pai hong on 12-7-25.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "People.h"
#import "CCAnimationHelper.h"


@implementation People

@synthesize pgrid,cpoint,link,isUnValid,isGoingToTalk,talkPosition,isReachTalkingPlace;

-(id)initWithSpriteFrameName:(NSString *)spriteFrameName isgril:(BOOL)gril{
    track();
    [self initWithSpriteFrameName:spriteFrameName];
    if (self) {
        isgril = gril;
    }
    return self;
}

+(id)create{
    track();
    int i = arc4random() % 10;
    BOOL isg;
    NSString *name;
    if (i<=4) {//女孩子
        isg = YES;
        name = @"g_worlk01.png";
    }else {//男孩子
        isg = NO;
        name = @"b_worlk01.png";
    }
    
    return  [[[self alloc] initWithSpriteFrameName:name isgril:isg] autorelease];
}


-(void)act_kantian{
    track();
    //停止原来的
    [self stopAllActions];
    
    CCAnimation *animation;
    if (isgril) {
        animation = [CCAnimation animationWithFrame:@"g_ttkt" frameCount:4 delay:0.4];
    }else {
        animation = [CCAnimation animationWithFrame:@"b_ttkt" frameCount:4 delay:0.4];
    }
    CCAnimate *animat = [CCAnimate actionWithAnimation:animation];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:animat];    
    [self runAction:repeat];
}

-(void)act_worlk{
    track();
    CCAnimation *animation;
    if (isgril) {
        NSArray *array = [NSArray arrayWithObjects:@"g_worlk01.png",@"g_worlk02.png",@"g_worlk03.png",@"g_worlk02.png",@"g_worlk01.png",nil];
        //animation = [CCAnimation animationWithFrame:@"g_worlk" frameCount:8 delay:0.07];
        animation = [CCAnimation animationWithNames:array delay:0.05];
    }else {
        NSArray *array = [NSArray arrayWithObjects:@"b_worlk01.png",@"b_worlk02.png",@"b_worlk03.png",@"b_worlk02.png",@"b_worlk01.png",nil];
        //animation = [CCAnimation animationWithFrame:@"g_worlk" frameCount:8 delay:0.07];
        animation = [CCAnimation animationWithNames:array delay:0.05];
        //animation = [CCAnimation animationWithFrame:@"b_worlk" frameCount:8 delay:0.07];
    }
    CCAnimate *animat = [CCAnimate actionWithAnimation:animation];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:animat];    
    [self runAction:repeat];
}

-(void)act_run{
    track();
    CCAnimation *animation;
    CCAnimation *animation1;
    
    if (isgril) {
        animation = [CCAnimation animationWithFrame:@"g_tp" frameCount:3 delay:0.2];
        NSArray * array=[NSArray arrayWithObjects:@"b_dt01.png",@"b_dt02.png",@"b_dt03.png",@"b_dt04.png",@"b_dt05.png", nil];
        animation1 = [CCAnimation animationWithNames:array delay:0.05];
        CCAnimate *animat = [CCAnimate actionWithAnimation:animation1];
        CCRepeatForever *repeat = [CCRepeatForever actionWithAction:animat];    
        [self runAction:repeat];
    }else {
        animation = [CCAnimation animationWithFrame:@"b_tp" frameCount:4 delay:0.4];
        NSArray * array=[NSArray arrayWithObjects:@"g_dt01.png",@"g_dt02.png",@"g_dt03.png",@"g_dt04.png",@"g_dt05.png", nil];
        animation1 = [CCAnimation animationWithNames:array delay:0.05];
        CCAnimate *animat = [CCAnimate actionWithAnimation:animation1];
        CCRepeatForever *repeat = [CCRepeatForever actionWithAction:animat];    
        [self runAction:repeat];
        
    }
    CCAnimate *animat = [CCAnimate actionWithAnimation:animation];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:animat];    
    [self runAction:repeat];
}

-(void)act_talk{
    track();
    CCAnimation *animation;
    if (isgril) {
        animation = [CCAnimation animationWithFrame:@"g_lt" frameCount:4 delay:0.2];
    }else {
        animation = [CCAnimation animationWithFrame:@"b_lt" frameCount:4 delay:0.2];
    }
    CCAnimate *animat = [CCAnimate actionWithAnimation:animation];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:animat];    
    [self runAction:repeat];
}

/*
 //重写 设置位置
 -(void)setPosition:(CGPoint)position{
 CGPoint point = ccp(position.x,position.y+10);//23是 中心点偏离轨道的位置
 cpoint = point;
 [super setPosition:point];
 }
 */

/*
 -(CGPoint)position{
 CGPoint point = self.position;
 
 CGPoint newp = ccp(point.x,point.y-12);//23是 中心点偏离轨道的位置
 
 return newp;
 }
 */

-(void)resetBoolsState{
    isGoingToTalk = NO;
    isReachTalkingPlace = NO;
}


-(void)resetDisplay{
    track();
    CCSpriteFrame *sf;
    if (isgril) {
        sf = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"g_worlk01.png"];
    }else {
        sf = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"b_worlk01.png"];
    }
    [self setDisplayFrame:sf];
}

-(void)dealloc{
    track();
    [self stopAllActions];
    self.pgrid = nil;
    if (self.link!=nil) {
        [self.link release];
    }
    
    [super dealloc];
}



@end
