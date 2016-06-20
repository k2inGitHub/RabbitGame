//
//  EESpriteBtn.m
//  RabbitGame
//
//  Created by pai hong on 12-6-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "EESpriteBtn.h"


@implementation EESpriteBtn

@synthesize isTouched;

- (id)init
{
    self = [super init];
    if (self) {
        isTouched = YES;
    }
    return self;
}

#pragma mark ---事件回调处理

-(void)addEETarget:(id)sender selector:(SEL)sel{
    delegate = sender;
    callback = sel;
}

#pragma mark ----点击处理判断----

/** 计算精灵的尺寸位置 */  
-(CGRect) rect   
{   
    return CGRectMake( position_.x - contentSize_.width*anchorPoint_.x,   
                      position_.y - contentSize_.height*anchorPoint_.y,   
                      contentSize_.width, contentSize_.height);    
}   


/** 判断touch点的位置是否在精灵上 */  
- (BOOL)containsTouchLocation:(UITouch *)touch   
{   
    //CCLOG(@"精灵触摸事件...........");   
    CGPoint touchLocation = [touch locationInView: [touch view]];   
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];   
    CGPoint local = [self convertToNodeSpace:touchLocation];   
    CGRect r = [self rect];   
    r.origin = CGPointZero;   
    BOOL isinself = CGRectContainsPoint( r, local );   
    /*if( isTouched ){   
        [numberLabel setColor:ccc3(255, 0, 0)];   
        if (delegate) {   
            [delegate touchedMySprite:self];   
        }   
        CCLOG(@"**点中精灵%i", index_);   
    } else {   
        CCLOG(@"****没有点中精灵%i", index_);   
        
    }  */ 
    return isinself;   
}   

-(void)touchDown{
    
}

-(void)touchUp{
    
}

-(void)doTheCallBack{
    [delegate performSelector:callback withObject:self afterDelay:0];  
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event   
{     
    
    BOOL isintoucharea = [self containsTouchLocation:touch];   
    
    //over事件
    if (isintoucharea) {
        [self touchDown];
    }
    
    return isintoucharea;//    
}   


-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    track();
    if (delegate == nil) {
        trace(@"---EENotice------接受事件对象为空");
        [self touchUp];
        return;
    }
    
    [self touchUp];
    
    if (isTouched) {
        if ([self containsTouchLocation:touch]) {
            [self doTheCallBack];
        }
    }
    
}

#pragma mark ----生命周期----
-(void)onEnter{
    [[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];   
    //[[CCTouchDispatcher sharedDispatcher] addStandardDelegate:self priority:0];
    [super onEnter];
}

-(void)onExit{
    
    [[CCTouchDispatcher sharedDispatcher]removeDelegate:self]; 
    [super onExit];
}

@end
