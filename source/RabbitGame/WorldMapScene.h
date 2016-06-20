//
//  WorldMapScene.h
//  RabbitGame
//
//  Created by pai hong on 12-6-21.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "LevelTipInfor.h"
@class EESpriteScaleBtn;
@class GameMoney;
@class MapAssitant;

//点击了功能按钮(设置 教程 帮助 成就  分享 更多 排名 )
typedef enum{
    BtnFuncType_setting = 1,
    BtnFuncType_help,
    BtnFuncType_honor,
    BtnFuncType_share,
    BtnFuncType_more,
    BtnFuncType_ranking,
    BtnFuncType_course,
    BtnFuncType_aboutUs
    
}BtnFuncType;

@interface WorldMapScene : CCLayer {
    LevelTipInfor *tipinfor;
    GameMoney *gamemoney;
    
    MapAssitant *mapAssitant;
}

-(void)gameStart:(int)levelNum;
-(void)clickFuncBtns:(EESpriteScaleBtn *)sprite;
+(CCScene *)scene;

-(void)addDayPrizeMoney:(int)num;














@end
