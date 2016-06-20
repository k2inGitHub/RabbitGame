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
@class GameDataSetting;
@class Grid;
@class TouchCanvas;
@class Link;
@class MaskLayer;
@class BirdController;
@class PeopleController;
@class CloudController;
@class BlackMask;
@class EESpriteScaleBtn;
#import "AdUnlockListener.h"

@interface GameScene : CCLayer {
    
    EESpriteScaleBtn *spriteRuan;
    
    //v1.2
    NSMutableArray *tasks;
    
    //v1.1 terababy
    // 增加历史记录，记录小摊贩人数及阻止暴力执法次数
    /*
    内容逻辑判定：
    小摊贩人数：XXX人
    草棚=2人
    小房子=5人
    别墅=20人
    小城堡=100人
    三头城堡=500人
    五头城堡=2000人
    注：均为每个等于多少人，重复累计，不因被合体后而覆盖其数量
    
    阻止城管暴力执法：XXX次
    墓碑：1次
    小教堂：10次
    大教堂：50次
    注：均为每个等于多少人，重复累计，不因被合体后而覆盖其数量
    */
    
    int peopleNumber;
    int revolutedNumber;
    
    
    
    int levelNum;
    CCSpriteBatchNode *batchLawn;
    
    //关卡数据
    int numx;//横向的格子数量
    int numy;//竖向的格子数量
    float startx;//起始点 右下角的x坐标
    float starty;//起始点 右下角的y坐标
    NSMutableArray *grids;
    
    CCSprite *dialog;
    
    GameMoney *gamemoney;
    GameStep *gamestep;
    GameScore *gamescore;
    GameNextSeat *gamenextseat;
    
    GameDataSetting *gameassitant;
    
    TouchCanvas *touchCanvas;
    
    MaskLayer *masklayer;
    
    int conststep;//消耗的步数
    
    BOOL isGameOver;
    
    BOOL pauseDoGenerate;
    
    BOOL gameoverButRoomIsEmpty;
    
    NSMutableArray *lastStepGridsData;
    NSMutableDictionary *lastNextSeatData;
    int lastTempScore;
    
    //BirdController *birdController;
    PeopleController *peopleController;
    CloudController *cloudController;
    
    
    //教程
    BOOL isInDaohang;
    int stepnum;
    CCSprite *touchDaoHang;
    CCSprite *inforbg;
    CCSprite *infor;
    BlackMask *blackMark;
    NSMutableArray *putDownArray;
    
    bool hasNewTask;
    
    CGPoint randomStart;
    CGPoint randomEnd;
}
//v1.1
@property(nonatomic,assign) NSMutableArray *tasks;

//@property(nonatomic,assign)BirdController *birdController;
@property(nonatomic,assign)PeopleController *peopleController;

@property(nonatomic,readwrite) BOOL isGameOver;

@property(nonatomic,readwrite) int conststep;
@property(nonatomic,readwrite) int levelNum;

@property (nonatomic, retain) AdUnlockListener *adUnlockListener;

+(GameScene *)shareInstance;

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


-(void)showCurrentLinkInfor:(Link *)link;
-(int)getPeopleCount;

- (void)addGoStoreDialog;
-(void)addStorePage;
-(void)addToolPage;

-(void)addPeopleOrRevolute:(Link*)link;

//v1.2
- (void)addTaskFinishDialog:(NSString*)content coin:(int)coin;
- (void)addScoreWallDialog;

- (void)removeRuanButton;
@end
