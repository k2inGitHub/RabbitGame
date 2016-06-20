//
//  People.h
//  RabbitGame
//
//  Created by pai hong on 12-7-25.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Grid;
@class Link;

@interface People : CCSprite {
    Grid *pgrid;
    Link *link;
    
    CGPoint cpoint;
    
    BOOL isgril;
    
    BOOL isUnValid;//小人在失去家园的时候，就设置成yes，不会产生talking动作。
    
    BOOL isGoingToTalk;
    
    BOOL isReachTalkingPlace;
    
    CGPoint talkPosition;
}
@property(nonatomic,assign)CGPoint cpoint;

@property(nonatomic,assign)BOOL isUnValid;
@property(nonatomic,assign)BOOL isGoingToTalk;
@property(nonatomic,assign)BOOL isReachTalkingPlace;

@property(nonatomic,assign)CGPoint talkPosition;

@property(nonatomic,assign)Grid *pgrid;
@property(nonatomic,retain)Link *link;

+(id)create;

-(void)act_kantian;

-(void)act_worlk;

-(void)act_run;

-(void)act_talk;

-(void)resetDisplay;

-(void)resetBoolsState;

@end
