//
//  Link.h
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

@class Grid;

typedef enum{
    Link_Type_House = 1, //草     胡萝卜 果树  村屋  农舍 公寓 四方金字塔 水晶塔  神殿
    Link_Type_Rabbit,    //兔子 飞兔
    Link_Type_Park,    //笼子 收容所 宝箱  大宝箱
    Link_Type_Stone,     //小石头 大石头 
    Link_Type_Tool,       //彩虹球 炸弹
    Link_Type_Wall       //游戏禁止区域，如果说湖
}Link_Type;

@interface Link : CCSprite {
    Link_Type type;
    int level;
    
    int score;
    BOOL issuper;//是否是高一级的物种
    
    int x;//(坐标0-5)
    int y;//(坐标0-5)
    
    CGPoint rememberPosition;
    
    CGPoint targetPosition;
    
    CGPoint lastHeiTuPosition;
    
    int order;
    
    Grid *pgrid;
    
    BOOL isActioning;
    
    BOOL isCreatedPeople;//是否已经创建了小人
}

@property(nonatomic,readwrite) Link_Type type;
@property(nonatomic,readwrite) int level;
@property(nonatomic,readwrite) int score;
@property(nonatomic,readwrite) int order;

@property(nonatomic,readwrite) BOOL issuper;
@property(nonatomic,assign) Grid *pgrid;


@property(nonatomic,readwrite) int x;
@property(nonatomic,readwrite) int y;

@property(nonatomic,readwrite) BOOL isCreatedPeople;

-(id)initWithSpriteFrameBytype:(Link_Type )t level:(int)l issuper:(BOOL)isSuper;

+(id)createByType:(Link_Type)t andLelve:(int)l;
+(id)createByType:(Link_Type)t andLelve:(int)l issuper:(BOOL)isSuper;

-(void)preMovePointTo:(CGPoint)p;
-(void)startMovePointTo:(CGPoint)p;
-(void)stopPreMove;

-(Link *)copyOne;

-(void)setLinkPgrid:(Grid *)g;

-(void)regeistRabbitActinos;

-(void)regeistCreatePeopleHandle;


@end
