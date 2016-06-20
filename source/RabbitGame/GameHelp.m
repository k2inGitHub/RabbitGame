//
//  GameCourse.m
//  RabbitGame
//
//  Created by pai hong on 12-6-23.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "GameHelp.h"
#import "EESpriteScaleBtn.h"


@implementation GameHelp


+ (void)autoscale:(CCSprite*)sprite
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    float a1 = size.width/sprite.contentSize.width;
    float a2 = size.height/sprite.contentSize.height;
    if (a1 < a2) {
        a1 = a2;
    }
    sprite.anchorPoint = ccp(0.5,0.5);
    sprite.position = ccp(size.width/2.0f, size.height/2.0f);
    sprite.scale = a1;
}

- (id)init
{
    self = [super init];
    if (self) {
        curIndex = 1;
        
        //图片容器
        sp_content = [CCSprite spriteWithFile:@"op1.png"];
        [self addChild:sp_content];
        sp_content.position = ccp(SSSW*0.5,SSSH*0.5);
        
        [self scheduleUpdate];
    }
    return self;
}

-(void)update:(ccTime)delta{
    [self unscheduleAllSelectors];
    
    //self.position = ccp(SSSW*0.5,SSSH*0.5);
    
    //返回按钮
    btn_return = [EESpriteScaleBtn spriteWithSpriteFrameName:@"btn_return4.png"];
    btn_return.position = ccp(46,24);
    btn_return.isSendEventWhenActionOver = YES;
    [btn_return addEETarget:self selector:@selector(clickreturn:)];
    [self addChild:btn_return];
    
    //下一页
    btn_nextpage = [EESpriteScaleBtn spriteWithSpriteFrameName:@"btn_nextstep.png"];
    btn_nextpage.position = ccp(194,24);
    //btn_nextpage.isSendEventWhenActionOver = YES;
    [btn_nextpage addEETarget:self selector:@selector(clicknext:)];
    [self addChild:btn_nextpage];
    
}


#pragma mark ---点击了返回---
-(void)clickreturn:(id)sender{
    [self removeFromParentAndCleanup:YES];
}

#pragma mark ---点击了下一页---
-(void)clicknext:(id)sender{
    if (curIndex>=8) {
        return;
    }
    if (curIndex==7) {
        //所有界面结束后，添加返回按钮
        [btn_return removeFromParentAndCleanup:YES];
        [btn_nextpage removeFromParentAndCleanup:YES];
        
        EESpriteScaleBtn *btn_returnlast = [EESpriteScaleBtn spriteWithSpriteFrameName:@"btn_return2.png"];
        btn_returnlast.position = ccp(SSSW*0.5,24);
        btn_returnlast.isSendEventWhenActionOver = YES;
        [btn_returnlast addEETarget:self selector:@selector(clickreturn:)];
        [self addChild:btn_returnlast];
        
        curIndex++;
        return;
    }
    curIndex ++;
    NSString *imagename = [NSString stringWithFormat:@"op%d",curIndex];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imagename ofType:@"png"];
    CCTexture2D *texture = [[CCTexture2D alloc] initWithImage:[UIImage imageWithContentsOfFile:imagePath]];
    
    [sp_content setTexture:texture];
}












@end
