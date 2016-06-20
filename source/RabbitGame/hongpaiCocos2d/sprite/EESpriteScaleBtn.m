//
//  EESpriteScaleBtn.m
//  RabbitGame
//
//  Created by pai hong on 12-6-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "EESpriteScaleBtn.h"


@implementation EESpriteScaleBtn

@synthesize isSendEventWhenActionOver;

@synthesize link;

-(void)touchDown{
    
    if (isMoving) {
        return;
    }
    
    if (!_alwaysScale) {
        CCAction *action = [self getActionByTag:123];
        if( action ){
            [self stopAction:action];
            [self setScale:originalScale_];
        }else{
            originalScale_ = self.scale;
        }
        
        CCAction *zoomAction = [CCScaleTo actionWithDuration:0.1f scale:originalScale_ * 1.15f];
        zoomAction.tag = 123;
        [self runAction:zoomAction];
    }
    
    [super touchDown];
}

-(void)touchUp{
    isMoving = YES;
    if (!_alwaysScale) {
        [self stopActionByTag:123];
        CCScaleTo *zoomAction = [CCScaleTo actionWithDuration:0.1f scale:originalScale_];
        zoomAction.tag = 123;
        
        
        CCCallFuncN *actOver = [CCCallFuncN actionWithTarget:self selector:@selector(actionOK)];
        
        CCSequence *seque = [CCSequence actions:zoomAction,actOver, nil];
        
        [self runAction:seque];
    }
    
    
    [super touchUp];
}

-(void)doTheCallBack{
    track();
    //是否2步结束才触发事件
    if (isSendEventWhenActionOver) {//松开鼠标后，等动画播放完再触发事件
        isClickValid = YES;//这个变量很重要， 是否为有效的点击
    }else {//松开鼠标后立刻触发
        [super doTheCallBack];
    }
}

//运动完成
-(void)actionOK{
    //trace(@"运动完成");
    isMoving = NO;
    //是否2步结束才触发事件
    if (isClickValid) {
        [super doTheCallBack];
        isClickValid = NO;
    }
}

-(void)setHight:(BOOL)b{
    
}
- (void)setAlwaysScale:(BOOL)alwaysScale{
    _alwaysScale = alwaysScale;
    if (_alwaysScale) {
        
        [self stopActionByTag:128];
        CCActionInterval *zoomAction = [CCScaleBy actionWithDuration:0.6 scale:1.1];
        CCActionInterval *reverse = [zoomAction reverse];
        CCRepeatForever *ac = [CCRepeatForever actionWithAction:[CCSequence actions:zoomAction, reverse, nil]];
        [self runAction:ac];
    } else {
        [self stopActionByTag:128];
    }
}

@end
