//
//  Grid.h
//  RabbitGame
//
//  Created by pai hong on 12-6-24.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Link;

@interface Grid : CCSprite <CCTargetedTouchDelegate>{
    Link *link;
    
    int x;//(坐标0-5)
    int y;//(坐标0-5)
    
    //标记
    NSString *lawnTag;
    
    //link引用是否改变了
    BOOL isLinkExsit;
    
    //是否遍历过
    BOOL isFinded;
    
    CCSpriteBatchNode *batchNode;
    
   // CCLabelTTF *timesttf;
}
@property(nonatomic,readwrite) int x;
@property(nonatomic,readwrite) int y;

@property(nonatomic,assign) BOOL isFinded;

@property(nonatomic,assign) Link *link;

-(void)setLinkRelation:(Link *)linkrelation;

-(void)refreshLawn;

-(void)refreshLawnByTop:(Grid *)top :(Grid *)right :(Grid *)down :(Grid *)left :(Grid *)lefttop :(Grid *)righttop :(Grid *)rightdown :(Grid *)leftdown;

-(void)findOneTime;

-(void)clearLink;

-(void)insertWall;
@end
