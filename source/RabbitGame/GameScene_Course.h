
//
//  GameScene.h
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

@class GameMoney;
@class GameScore;
@class GameStep;
@class GameNextSeat;
@class GameDataSetting_Course;
@class Grid;
@class TouchCanvas;
@class Link;
@class MaskLayer;

#import "BlackMask.h"

#import "EESpriteBtn.h"

@class BirdController;
@class PeopleController;
@class CloudController;

@interface GameScene_Course : CCLayer {
    int levelNum;
    CCSpriteBatchNode *batchLawn;
    
    //关卡数据
    int numx;//横向的格子数量
    int numy;//竖向的格子数量
    float startx;//起始点 右下角的x坐标
    float starty;//起始点 右下角的y坐标
    NSMutableArray *grids;
    
    
    
    GameMoney *gamemoney;
    GameStep *gamestep;
    GameScore *gamescore;
    GameNextSeat *gamenextseat;
    
    GameDataSetting_Course *gameassitant;
    
    TouchCanvas *touchCanvas;
    
    MaskLayer *masklayer;
    
    int conststep;//消耗的步数
    
    BOOL isGameOver;
    
    BOOL pauseDoGenerate;
    
    BOOL isInDaohang;
    int stepnum;
    CCSprite *touchDaoHang;
    CCSprite *inforbg;
    CCSprite *infor;
    
    BlackMask *blackMark;
    NSMutableArray *putDownArray;
    
    NSMutableArray *lastStepGridsData;
    NSMutableDictionary *lastNextSeatData;
    int lastTempScore;
    
    
    BirdController *birdController;
    PeopleController *peopleController;
    CloudController *cloudController;
}
@property(nonatomic,assign)BirdController *birdController;
@property(nonatomic,assign)PeopleController *peopleController;


@property(nonatomic,readwrite) BOOL isGameOver;

@property(nonatomic,readwrite) int conststep;
@property(nonatomic,readwrite) int levelNum;

+(GameScene_Course *)shareInstance;

+(CCScene *)scene;
-(BOOL)costOneStep;
-(int)getGameScore;

-(void)setBaseData:(NSMutableArray *)array : (int)nx :(int)ny :(float)sx :(float)sy ;
-(NSMutableArray *)getGrids;
-(void)touchOneGrid:(Grid *)grid;
-(void)add_cut_score:(int )score;
-(void)purgeTouchCanvas;

-(void)placeBomOk:(Link *)firstLink :(Grid *)grid;
-(void)placeColorBallOk:(Link *)firstLink :(Grid *)grid;

-(void)refreshRabbitState;
-(void)insertNewLinkToGameNextSeat:(Link *)link;

-(void)refreshMoneyAndStep;
-(void)add_cut_money:(int)money;

-(void)putNewLinkInScene:(Link *)link :(Grid *)grid;
-(void)LinkRabbitPark;

-(void)clickGameOverCameraShare;//截屏分享
-(void)clickGameOverRestatGame;
-(void)clickGameOverReturn;

-(void)rememberNecessaryWhenBack;

-(id)getLevelConfigDate:(NSString *)key;
-(void)setLevelConfigDate:(id)data key:(NSString *)k;

-(void)recoverLastTempData;
-(BOOL)isValidChexiaoInStore;

-(void)addGameOverBtns;


#pragma mark ---小人----
-(int)getPeopleCount;




@end
