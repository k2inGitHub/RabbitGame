
//
//  LevelDataSetting.h
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
#import "Link.h"

@class GameScene_Course;
@class Grid;
@class GameLinksInfor;

@interface GameDataSetting_Course : NSObject {
    GameScene_Course *gameScene;
    
    int numx;
    int numy;
    
    NSMutableArray *tempFindLinks;
    
    Link *curLink;
    
    GameLinksInfor *gamelinksinfor;
    
}
-(void)analyseData:(GameScene_Course *)delegate levelNum:(int)level;

-(void)traceGrid;
-(void)trace1_0;

-(void)refreshLawnTexture;

-(BOOL)isFindsLinks;

-(void)findLinksToLink:(Grid *)grid :(Link *)firstLink;
-(void)linkAllFindLinks:(Grid *)grid :(Link *)firstLink ;

-(void)stopAllLinkPrevMove;

-(Link *)getAllTogetherLink;
-(BOOL)isGetDoubleScore;

-(void)clearTempFindLinksArray;
-(void)removeAllOldLinksAfterLinking;
-(void)showFindLinkScoreEffect:(Link *)link position:(CGPoint)pos;
-(void)showGetScoreEffect:(Link *)link;
-(void)showGetScoreEffect:(Link *)link isdouble:(BOOL)twoDouble position:(CGPoint)pos;

-(void) showGetMoneyEffect:(Grid *)grid money:(int)num;

-(void)showBomEffect:(Grid *)grid;
-(Link *)getLowestLink;

-(NSMutableArray *)getAllParkLevel1Array;
-(NSMutableArray *)checkAllRabiit;

-(NSMutableArray *)getFindsLinks;
-(void)moveAllRabiit;
-(void)setRandomLinkInMapWhenBegin:(NSMutableArray *)grids;
-(BOOL)checkGameOver;
-(NSMutableArray *)recordLinks;
-(void)cancelAllPerform;

-(void)allLevel2RabbitToPark;

-(void)recoverLastTempGridsData:(NSMutableArray *)grids :(NSMutableArray *)historygrids;
-(void) showLostScoreEffect:(Grid *)grid score:(int)num;
-(BOOL)checkExistBaoXiang;
-(BOOL)checkRoomIsEmpty;
-(BOOL)checkRoomHasBom;

-(void)setLinkToGrids:(NSMutableArray *)grids X:(int)x Y:(int)y type:(Link_Type)t level:(int)l;


@end
