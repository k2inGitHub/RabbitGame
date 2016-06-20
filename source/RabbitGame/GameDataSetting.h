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

@class GameScene;
@class Grid;
@class Link;
@class GameLinksInfor;

@interface GameDataSetting : NSObject {
    GameScene *gameScene;
    
    int numx;
    int numy;
    
    NSMutableArray *tempFindLinks;
    
    GameLinksInfor *gamelinksinfor;
    
    Link *curLink;
}

-(void)updateGamelinksinforPosition;

-(void)analyseData:(GameScene *)delegate levelNum:(int)level;

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
-(void)clearCurrentLinkInfor;
-(void)showCurrentLinkInfor:(Link *)link;

-(void)releaseGridsTouchRegist;

@end
