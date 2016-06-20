//
//  GameStep.h
//  RabbitGame
//
//  Created by pai hong on 12-6-22.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameStep : CCSprite {
    CCLabelAtlas *stepLabel;
    int historySecond;
    
    int step;
    
    float maxLen;
    
    int secNum;
    CCSprite *process;
    
    BOOL isToRight;
}
@property(nonatomic,assign)    BOOL isToRight;


-(void)rememberLevelTime;

+(GameStep *)shareInstance;

-(void)refreshStepCount;
-(void)add_cut_step:(int)num;
-(int)getLeftStep;
-(void)setStep:(int)s;

-(void)addRemenberTimeStep;
-(void)refresh;

@end
