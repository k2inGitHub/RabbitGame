//
//  WorldMapScene.m
//  RabbitGame
//
//  Created by pai hong on 12-6-21.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "WorldMapScene.h"
#import "EESpriteScaleBtn.h"
#import "GameStep.h"
#import "GameMoney.h"
#import "IconLevel.h"
#import "LevelTipInfor.h"
#import "GameHelp.h"
#import "GameSetting.h"
#import "GameAboutUs.h"
#import "GameDayPrize.h"

#import "LoadingScene.h"
#import "GameScene.h"
#import "SoundManagerR.h"
#import "MapAssitant.h"

@implementation WorldMapScene

+(CCScene *)scene{
    CCScene *s = [CCScene node];
    
    WorldMapScene *m = [WorldMapScene node];
    [s addChild:m];
    
    return s;
}
//创建功能按钮代理函数
-(EESpriteScaleBtn *)creatFunctBtnByFramename:(NSString *)framename px:(float)x py:(float)y ftype:(BtnFuncType)type{
    track();
    EESpriteScaleBtn *btn = [EESpriteScaleBtn spriteWithSpriteFrameName:framename];
    btn.tag = (int)type;
    [btn addEETarget:self selector:@selector(clickFuncBtns:)];
    btn.position = ccp(x,SSSH-y);
    [self addChild:btn];
    return btn;
}
//关卡图片代理函数
-(IconLevel *)createICOLevelByLevelNum:(int)levelnum px:(float)x py:(float)y{
    IconLevel *icolevel = [IconLevel createSpriteIconByLevelName:levelnum];
    icolevel.isSendEventWhenActionOver = YES;
    [icolevel addEETarget:self selector:@selector(clickLevelico:)];
    icolevel.position = ccp(x,SSSH-y);
    [self addChild:icolevel];
    return icolevel;
}

- (id)init
{
    self = [super init];
    if (self) {
        track();
        //赋值给Globel全局变量
        [Globel shareGlobel].worldMapScene = self;
        
        //标记兔子的
        [Globel shareGlobel].rabbitTag = 100;//每次回到这里的时候就刷新
        
        //管理贴图
        [CCSpriteFrameCache purgeSharedSpriteFrameCache];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"worldMap.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"setting.plist"];
        
        //背景
        CCSprite *bg = [CCSprite spriteWithSpriteFrameName:@"world_mapbg.png"];
        [self addChild:bg];
        bg.position = ccp(SSSW*0.5,SSSH*0.5);
        
        //步骤
        GameStep *gamestep = [GameStep spriteWithSpriteFrameName:@"topbg_step.png"];
        gamestep.isToRight = YES;
        gamestep.position = ccp(70,SSSH-30);
        [self addChild:gamestep];
        //金钱
        gamemoney = [GameMoney spriteWithSpriteFrameName:@"topbg_money.png"];
        gamemoney.position = ccp(204,SSSH-30);
        [self addChild:gamemoney];
        
        
        
        //云彩 小动物
        mapAssitant = [[MapAssitant alloc] initWithMap:self];
        
        
        
        //设置 教程 帮助 成就  分享 更多 排名 
        [self creatFunctBtnByFramename:@"world_setting.png" px:262 py:171 ftype:BtnFuncType_setting];//设置
        [self creatFunctBtnByFramename:@"world_teaching.png" px:126 py:295 ftype:BtnFuncType_course];//教程
        //[self creatFunctBtnByFramename:@"world_help.png" px:152 py:252 ftype:BtnFuncType_help];//帮助
        [self creatFunctBtnByFramename:@"world_honor.png" px:112 py:75 ftype:BtnFuncType_honor];//成就
        [self creatFunctBtnByFramename:@"world_share.png" px:293 py:24 ftype:BtnFuncType_share];//分享
        [self creatFunctBtnByFramename:@"world_more.png" px:52 py:409 ftype:BtnFuncType_more];//更多
        [self creatFunctBtnByFramename:@"world_ranking.png" px:152 py:107 ftype:BtnFuncType_ranking];//排名
        
        //八个关卡图片
        [self createICOLevelByLevelNum:1 px:35 py:275];
        [self createICOLevelByLevelNum:2 px:84 py:218];
        [self createICOLevelByLevelNum:3 px:175 py:186];
        [self createICOLevelByLevelNum:4 px:33 py:122];
        [self createICOLevelByLevelNum:5 px:220 py:115];
        [self createICOLevelByLevelNum:6 px:230 py:294];
        [self createICOLevelByLevelNum:7 px:133 py:384];
        [self createICOLevelByLevelNum:8 px:280 py:398];
                
        //每日日常奖励
        [self schedule:@selector(doDayPrize) interval:0.5];
        
        
    }
    return self;
}

-(void)onExit{
    [self unscheduleAllSelectors];
    
    [mapAssitant dispnse];
    [mapAssitant release];
    
    //赋值给Globel全局变量
    [Globel shareGlobel].worldMapScene = nil;
    [super onExit];
}

#pragma mark ---点击了功能按钮(设置 教程 帮助 成就  分享 更多 排名 )---
//点击了功能按钮(设置 教程 帮助 成就  分享 更多 排名 )
-(void)clickFuncBtns:(EESpriteScaleBtn *)sprite{
    track();
    
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    if (sprite.tag == BtnFuncType_help ) {
        GameHelp *gameHelp = [GameHelp node];
        [self addChild:gameHelp z:3];
    }else if(sprite.tag == BtnFuncType_setting){
        GameSetting *gamesetting = [GameSetting node];
        [self addChild:gamesetting z:3];
    }else if(sprite.tag == 67){
        GameAboutUs *gameabout = [GameAboutUs node];
        [self addChild:gameabout z:3];
    }else if(sprite.tag == BtnFuncType_course){
        //进入了教程
        CCScene *game = [LoadingScene sceneWithTargetScene:TargetScenes_course];
        [[CCDirector sharedDirector] replaceScene:game];

    }
    trace(@"%d",sprite.tag);
}


#pragma mark ---点击了关卡图标---
-(void)clickLevelico:(IconLevel *)sprite{
    track();
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    if (tipinfor!=nil && tipinfor.parent !=nil ) {
        return;
    }
    int levelnum = sprite.levelNum;
    tipinfor = [LevelTipInfor createLevelTipInforByLevelNum:levelnum];
    [self addChild:tipinfor  z:3];
}

//游戏开始
-(void)gameStart:(int)levelNum{
    
    [Globel shareGlobel].curLevel = levelNum;
    
    //1、检测改关卡是不是还没有玩过  2、检测是否有其他的游戏还没有进行完成
    CCScene *game = [LoadingScene sceneWithTargetScene:TargetScenes_gamescen];
    [[CCDirector sharedDirector] replaceScene:game];
    
}



#pragma mark ---日常奖励----

-(void)doDayPrize{
    track();
    
    [self unschedule:@selector(doDayPrize)];
    
    GameDayPrize *gamedayprize = [GameDayPrize node];
    if ([gamedayprize isNewDay]) {
        [gamedayprize insertNeed];
        [self addChild:gamedayprize  z:3];
    }else {
        [self addChild:gamedayprize  z:3];
        [gamedayprize removeFromParentAndCleanup:YES];
    }
    //[self addChild:gamedayprize];
}

-(void)addDayPrizeMoney:(int)num{
    [gamemoney add_cut_money:num];
}




















@end
