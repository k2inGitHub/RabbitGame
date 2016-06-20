//
//  GameScene.m
//  RabbitGame
//
//  Created by pai hong on 12-6-21.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "GameConfig.h"
#import "Configuration.h"

#import "GameScene.h"
#import "EESpriteScaleBtn.h"
#import "LoadingScene.h"
#import "GameStep.h"
#import "GameMoney.h"
#import "GameHelp.h"
#import "GameNextSeat.h"
#import "GameScore.h"
#import "Grid.h"
#import "CCAnimationHelper.h"

#import "GameDataSetting.h"
#import "TouchCanvas.h"
#import "Link.h"
#import "GameRoom.h"
#import "Store.h"
#import "GameOver.h"
#import "Share.h"
#import "MaskLayer.h"
#import "OpenLevel.h"
#import "SoundManagerR.h"

#import "AWScreenshot.h"
#import "SoundManagerR.h"

#import "BirdController.h"
#import "PeopleController.h"
#import "EncryptionConfig.h"
#import "People.h"
#import "CloudController.h"
#import "BlackMask.h"
#import "Buy.h"

#import "GameSetting.h"
#import "GameTasks.h"
#import "GameTasks2.h"

#import "GameKitHelper.h"


#import "Task.h"
#import "Business.h"
#import "MyUserAnalyst.h"
#import "GameDayPrize.h"
#import "MobClick.h"
#import "VisibleRect.h"
#import "TipAlert.h"
#import "CCLeafTo.h"
#import "KTMathUtil.h"

const float kFreeItemRefreshTime = 300;

@interface GameScene(privete)

-(void)placeLinkOk:(Link *)firstLink :(Grid *)grid;

@end


@implementation GameScene

@synthesize levelNum,conststep,isGameOver;
@synthesize peopleController;
//birdController;

//v1.1
@synthesize tasks;

static GameScene *instance;

+(CCScene *)scene{
    CCScene *s = [CCScene node];
    
    GameScene *m = [GameScene node];
    [s addChild:m];
        
    return s;
}

+(GameScene *)shareInstance{
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.adUnlockListener = [[AdUnlockListener alloc] init];
        
        track();
        //赋值给静态变量
        instance = self;
        
        //如果是在教程中
        if ([Globel shareGlobel].isInCourse) {
            [Globel shareGlobel].curLevel = 1;
//            [[Business sharedInstance] hideAdvertise];
        }
        [[Business sharedInstance] showAdvertise];
        
        //关卡号
        levelNum = [Globel shareGlobel].curLevel;
        
        
        //游戏是否结束
        isGameOver = [[self getLevelConfigDate:@"isgameover"] boolValue];
        //如果是在教程中
        if ([Globel shareGlobel].isInCourse) {
            isGameOver = NO;
        }
        
        /*
        //根据存档来判断游戏是否是在结束状态
        NSArray *acrchive = [self getLevelConfigDate:@"archive"];
        if (acrchive==nil || [acrchive count]==0) {
            isGameOver = NO;
        }else {
            isGameOver = YES;
        }
         */
        
        //贴图处理
        [CCSpriteFrameCache purgeSharedSpriteFrameCache];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gametexture.plist"];
        
        if (levelNum==1 || levelNum==2 || levelNum==3 || levelNum==4) {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"lawngreen_caodi.plist"];
        }else if(levelNum==5 || levelNum==6 ){
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"lawngreen_xuedi.plist"];
        }else if( levelNum==7 || levelNum==8){
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"lawngreen_tudi.plist"];
        }

        
        //背景草坪
        CCSprite *bg;
        
        NSString *str ;
        if (levelNum==1 || levelNum==2 || levelNum==3 || levelNum==4) {
            str = [NSString stringWithFormat:@"level1-bg.png",levelNum];
        }else {
            str = [NSString stringWithFormat:@"level%d-bg.png",levelNum];
        }
        CGSize size = [[CCDirector sharedDirector] winSize];
        if (size.height>480) {
            CCSprite *bar = [CCSprite spriteWithFile:@"set_bar.png"];
            
            bar.position = ccpAdd([VisibleRect top], ccp(0, -21));            [self addChild:bar z:2];
            
            str = @"level1-bg-i5.png";
        }
        bg = [CCSprite spriteWithFile:str];
        bg.position = ccp(SSSW*0.5,size.height/2.0f);
        [self addChild:bg];
        
        
        //商店按钮
        EESpriteScaleBtn *btn_gostore = [EESpriteScaleBtn spriteWithFile:@"btn_tools.png"];
        btn_gostore.position = ccp(246,458);
        btn_gostore.tag = 44;
        [btn_gostore addEETarget:self selector:@selector(clickGoTool:)];
        [self addChild:btn_gostore];
        
        EESpriteScaleBtn *btnSet = [EESpriteScaleBtn spriteWithFile:@"btn_set.png"];
        btnSet.position = ccp(296,458);
        [btnSet addEETarget:self selector:@selector(clickSetup:)];
        [self addChild:btnSet];
        
        //分
        gamescore = [GameScore spriteWithSpriteFrameName:@"得分.png"];
        gamescore.position = ccp(60,420);
        gamescore.scaleY = 0.89f;
        [self addChild:gamescore];
        
        //步
        gamestep = [GameStep spriteWithSpriteFrameName:@"步数.png"];
        gamestep.position = ccp(260,420);
        gamestep.scaleY = 0.89f;
        [self addChild:gamestep];
        
        //kt
//        [gamestep setStep:1];
        
        //钱
        gamemoney = [GameMoney spriteWithFile:@"gamemoney2.png"];
        gamemoney.position = ccp(60,457);
        gamemoney.scale = 1.00f;
        [gamemoney addEETarget:self selector:@selector(clickGoStore:)];
        [self addChild:gamemoney];
        
        //next seat 预备席
        gamenextseat = [GameNextSeat node];
        gamenextseat.position = ccp(162,438);
        gamenextseat.scale = 0.89f;
        [self addChild:gamenextseat];
        
        //关卡图标
//        NSString *qiaico = [NSString stringWithFormat:@"level_prohibit%d.png",levelNum];
//        CCSprite *sp = [CCSprite spriteWithSpriteFrameName:qiaico];
//        sp.position = ccp(15,14);
//        //[self addChild:sp];
//        
//        //如果是在教程中，则不添加进去
//        if (![Globel shareGlobel].isInCourse) {
//            [gamestep addChild:sp z:1];
//        }
        
        //数据操作助手   不同关卡，不同的配置
        gameassitant = [[GameDataSetting alloc] init];
        [gameassitant analyseData:self levelNum:levelNum];
        //刷新草坪
        [gameassitant refreshLawnTexture];
        
        NSMutableArray *historygrids = [self getLevelConfigDate:@"archive"];
        if (historygrids==nil || [historygrids count] == 0) {//说明是第一次玩
            peopleNumber = 0;
            revolutedNumber = 0;
        } else {
            peopleNumber = [[self getLevelConfigDate:@"PeopleNumber"] intValue];
            revolutedNumber = [[self getLevelConfigDate:@"RevolutedNumber"] intValue];
        }
        
        if (true) {
            
            
            CCSprite *bar = [CCSprite spriteWithFile:@"set_bar.png"];
            bar.position = ccp(160,21.5);
            [self addChild:bar];
            
        } else {
            //测试信息按钮
            
            EESpriteScaleBtn *trace1 = [EESpriteScaleBtn spriteWithFile:@"test1.png"];
            trace1.position = ccp(60,30);
            //[trace1 addEETarget:self selector:@selector(clicktest1:)];
            [trace1 addEETarget:self selector:@selector(gameover)];
            [self addChild:trace1];
            
            EESpriteScaleBtn *trace2 = [EESpriteScaleBtn spriteWithFile:@"test1.png"];
            trace2.position = ccp(100,30);
            //[trace2 addEETarget:self selector:@selector(clicktest2:)];
            [trace2 addEETarget:self selector:@selector(gameover)];
            [self addChild:trace2];
            
            EESpriteScaleBtn *trace3 = [EESpriteScaleBtn spriteWithFile:@"test1.png"];
            trace3.position = ccp(140,30);
            //[trace3 addEETarget:self selector:@selector(generateNewLink:)];
            [trace3 addEETarget:self selector:@selector(generateNewLink:)];
            [self addChild:trace3];
            
            
            
            //花草按钮  测试按钮呀，
            [self testCreate:Link_Type_House :1 :ccp(10,0)];
            [self testCreate:Link_Type_House :2 :ccp(40,0)];
            [self testCreate:Link_Type_House :3 :ccp(70,0)];
            [self testCreate:Link_Type_House :4 :ccp(100,0)];
            [self testCreate:Link_Type_House :5 :ccp(130,0)];
            [self testCreate:Link_Type_House :6 :ccp(160,0)];
            [self testCreate:Link_Type_House :7 :ccp(190,0)];
            [self testCreate:Link_Type_House :8 :ccp(220,0)];
            [self testCreate:Link_Type_House :9 :ccp(250,0)];
            
            [self testCreate:Link_Type_Stone :1 :ccp(10,27)];
            [self testCreate:Link_Type_Stone :2 :ccp(40,27)];
            
            [self testCreate:Link_Type_Park :1 :ccp(70,27)];
            [self testCreate:Link_Type_Park :2 :ccp(100,27)];
            [self testCreate:Link_Type_Park :3 :ccp(130,27)];
            [self testCreate:Link_Type_Park :4 :ccp(160,27)];
            [self testCreate:Link_Type_Park :5 :ccp(190,27)];
            
            [self testCreate:Link_Type_Rabbit :1 :ccp(220,27)];
            [self testCreate:Link_Type_Rabbit :2 :ccp(250,27)];
            [self testCreate:Link_Type_Tool :1 :ccp(280,27)];
            [self testCreate:Link_Type_Tool :2 :ccp(310,27)];
            

        }

        
        
        //仓库 处理
        if (levelNum == 1 ) {
            
            
            GameRoom *room1 = [GameRoom spriteWithFile:@"blankpng.png"];
            [room1 unlock:true];
            room1.roomId = 1;
            [room1 addEETarget:self selector:@selector(clickGameRoom:)];
            [self addChild:room1];
            room1.position = ccp(35 + 50*3,365);
            
            bool unlockRoom2 = [[self getLevelConfigDate:@"UnlockRoom2"] boolValue];
            GameRoom *room2 = [GameRoom spriteWithFile:@"blankpng.png"];
            [room2 unlock:unlockRoom2];
            room2.roomId = 2;
            room2.position = ccp(35 + 50*4,365);
            [room2 addEETarget:self selector:@selector(clickGameRoom:)];
            [self addChild:room2];
            
            bool unlockRoom3 = [[self getLevelConfigDate:@"UnlockRoom3"] boolValue];
            GameRoom *room3 = [GameRoom spriteWithFile:@"blankpng.png"];
            [room3 unlock:unlockRoom3];
            room3.roomId = 3;
            room3.position = ccp(35 + 50*5,365);
            [room3 addEETarget:self selector:@selector(clickGameRoom:)];
            [self addChild:room3];
        }
        
        
        
        if (levelNum == 7) {// 第7关，还有个仓
            GameRoom *room1 = [GameRoom spriteWithFile:@"blankpng.png"];
            room1.position = ccp(85,90);
            [room1 addEETarget:self selector:@selector(clickGameRoom:)];
            [self addChild:room1];
        }
        
        //游戏是结束状态
        if (isGameOver) {
            [self addGameOverBtns];
        }
        
        
        //如果是在教程中，则不添加进去
        if ([Globel shareGlobel].isInCourse) {
            [gamenextseat insertNewLinkIn:[Link createByType:Link_Type_House andLelve:1]];
            [gamenextseat insertNewLinkIn:[Link createByType:Link_Type_Tool andLelve:2]];
            [gamenextseat insertNewLinkIn:[Link createByType:Link_Type_House andLelve:1]];
            [gamenextseat insertNewLinkIn:[Link createByType:Link_Type_Rabbit andLelve:1]];
            [gamenextseat insertNewLinkIn:[Link createByType:Link_Type_House andLelve:3]];
            [gamenextseat insertNewLinkIn:[Link createByType:Link_Type_House andLelve:2]];
            [gamenextseat insertNewLinkIn:[Link createByType:Link_Type_House andLelve:1]]; 
            [gamenextseat insertNewLinkIn:[Link createByType:Link_Type_House andLelve:1]];
        } else {
            [self initTasks];
        }
        
        
        //显示小鸟动画
        //birdController = [[BirdController alloc] initWithDelegate:self];
        
        //显示小人动画
        peopleController = [[PeopleController alloc] initWithXNum:numx YNum:numy dele:self];              
        
        //为了显示  生成说明序列,放在了这里
        [gamenextseat generateNext];
        
        //显示云彩阴影动画
        cloudController = [[CloudController alloc] initWithDelegate:self];
        
        //背景音乐
        int random = 7+ arc4random()%3;
        [self schedule:@selector(playsound) interval:random];
        
        
//		[[NSNotificationCenter defaultCenter] addObserver:self	selector:@selector(applicationDidBecomeActive) name:@"UIApplicationDidBecomeActiveNotification" object:nil];
        
        //v1.2
        [MyUserAnalyst updateOnlineConfig];
        int RuanSwitch = [MyUserAnalyst getIntFlag:@"RuanSwitch" defaultValue:0];
        
        if (RuanSwitch >0 && GeneralOnOff) {
            EESpriteScaleBtn *sprite = [EESpriteScaleBtn spriteWithFile:@"ruan1.png"];
            sprite.position = ccp(60,370);
            [sprite addEETarget:self selector:@selector(clickRuan:)];
            [self addChild:sprite z:50];
        }
        
        GameDayPrize *gamedayprize = [GameDayPrize node];
//        if ([gamedayprize isNewDayRecommend]) {
//            int InterstRecom = [MyUserAnalyst getIntFlag:@"InterstRecom" defaultValue:0];
//            
//            if (InterstRecom >0 && GeneralOnOff) {
//                spriteRuan = [EESpriteScaleBtn spriteWithFile:@"ruan1.png"];
//                spriteRuan.position = ccp(60,370);
//                [spriteRuan addEETarget:self selector:@selector(clickInterstitial:)];
//                [self addChild:spriteRuan z:50];
//            } else {
//                spriteRuan = nil;
//            }
//        } else {
//            spriteRuan = nil;
//            int scoreWall = [MyUserAnalyst getIntFlag:@"Video" defaultValue:0];
////            if (scoreWall > 0 && GeneralOnOff) {
//                EESpriteScaleBtn *sprite = [EESpriteScaleBtn spriteWithFile:@"btn_free_tubi.png"];
//                sprite.position = ccp(60,370);
//                [sprite addEETarget:self selector:@selector(clickByFreeMoney)];
//                [self addChild:sprite z:50];
////            }
//        }
        
        
        [self tryCreateItem];
    }
    return self;
}


-(void)videoPlayed:(NSNotification *)notification
{
    [MobClick event:@"Video" label:@"Coin"];
    int VideoCoin = [MyUserAnalyst getIntFlag:@"VideoCoin" defaultValue:100];
    [self add_cut_money:VideoCoin];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    TipAlert *alert = [TipAlert createWithTitle:[NSString stringWithFormat:@"恭喜你获得%d金币", VideoCoin]];
    [self addChild:alert z:100];
    [self refreshMoneyAndStep];
}

-(void)clickByFreeMoney{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayed:) name:HLInterstitialFinishNotification object:nil];
    [[Business sharedInstance] showVideo];
    //    [[GameScene shareInstance] addScoreWallDialog];
}

- (void)removeRuanButton
{
    if (spriteRuan) {
        [spriteRuan removeFromParentAndCleanup:true];
        
        
        int scoreWall = [MyUserAnalyst getIntFlag:@"Video" defaultValue:0];
        if (scoreWall > 0 && GeneralOnOff) {
            EESpriteScaleBtn *sprite = [EESpriteScaleBtn spriteWithFile:@"btn_free_tubi.png"];
            sprite.position = ccp(60,370);
            sprite.alwaysScale = YES;
            [sprite addEETarget:self selector:@selector(clickByFreeMoney)];
            [self addChild:sprite z:50];
        }
    }
}

- (void)clickInterstitial:(EESpriteScaleBtn*)node
{
    
    [[Globel shareGlobel].allDataConfig setValue:[NSNumber numberWithBool:true] forKey:@"Ruan"];
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *lasetdate = [NSDate date];
    
    NSString *str = [df stringFromDate:lasetdate];
    
    [[Globel shareGlobel].allDataConfig setValue:str forKey:@"RuanTime"];
    
    
    [MobClick event:@"Interstitial" label:@"Recommend"];
    [[Business sharedInstance] showHalfBanner];
}

//v1.2
- (void)initTasks {
    for (int i = 1; i <= 3; i++) {
        Task *task = [Task getInitTask:i];
        if (tasks == NULL) {
            tasks = [[NSMutableArray alloc] initWithCapacity:10];
        }
        [tasks addObject:task];
    }
}

- (void)clickRuan:(EESpriteScaleBtn*)node
{
    bool clickedRuan = false;
    NSObject *obj =  [[Globel shareGlobel].allDataConfig objectForKey:@"Ruan"];
    if (obj == NULL) {
        [[Globel shareGlobel].allDataConfig setValue:[NSNumber numberWithBool:false] forKey:@"Ruan"];
    } else {
        clickedRuan = [((NSNumber*)obj) boolValue];
    }
    if (!clickedRuan) {
        [self add_cut_money:500];
    }
    
    [[Globel shareGlobel].allDataConfig setValue:[NSNumber numberWithBool:true] forKey:@"Ruan"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://c.apple.shiwan.com/index/1732?from=zhangshunkj"]];
}

- (void)onEnter {
    [super onEnter];
    NSMutableArray *historygrids = [self getLevelConfigDate:@"archive"];
    if (historygrids==nil || [historygrids count] == 0) {//说明是第一次玩
        //v1.2
        if (![Globel shareGlobel].isInCourse) {
            GameTasks2 *gamesetting = [GameTasks2 node];
            [self addChild:gamesetting z:100];
        }
    } else {
        [self addWelcomeDialog];
    }
}

- (void)addGoStoreDialog {
    if (dialog == nil) {
        //清除TouchCanvas
        [self purgeTouchCanvas];
        //停止运动(物体的试运动)
        [gameassitant stopAllLinkPrevMove];
        dialog = [EEMaskSprite spriteWithFile:@"dg_coinover.png"];
        dialog.position = ccp(160,240);
        
        EESpriteScaleBtn *btn_close = [EESpriteScaleBtn spriteWithSpriteFrameName:@"dg_close.png"];
        btn_close.position = ccp(278,96);
        [btn_close addEETarget:self selector:@selector(closeDialog:)];
        [dialog addChild:btn_close];
        
        
        EESpriteScaleBtn *btn_go = [EESpriteScaleBtn spriteWithFile:@"金币商城.png"];
        
        btn_go.position = ccpAdd([VisibleRect bottom], ccp(70, 22));
        [btn_go addEETarget:self selector:@selector(clickGoStore:)];
        [dialog addChild:btn_go];
        
        EESpriteScaleBtn *btn_free = [EESpriteScaleBtn spriteWithFile:@"免费获得.png"];
        btn_free.position = ccpAdd([VisibleRect bottom], ccp(-70, 22));
        [btn_free addEETarget:self selector:@selector(getFreeCoin:)];
        [dialog addChild:btn_free];
        
        
        [self addChild:dialog z:1000];
    }
}

#pragma mark ---免费金币----
//免费金币
- (void)getFreeCoin:(id)sender{
    [self closeDialog:sender];
    if([HLAnalyst boolValue:@"show_ad_tip"]){
        dialog = [EEMaskSprite spriteWithFile:@"观看广告即可获得金币.png"];
        dialog.position = ccp(160,240);
        
        EESpriteScaleBtn *btn_close = [EESpriteScaleBtn spriteWithSpriteFrameName:@"dg_close.png"];
        btn_close.position = ccp(278,96);
        [btn_close addEETarget:self selector:@selector(closeDialog:)];
        [dialog addChild:btn_close];
        
        
        EESpriteScaleBtn *btn_go = [EESpriteScaleBtn spriteWithFile:@"免费获得.png"];
        
        btn_go.position = ccpAdd([VisibleRect bottom], ccp(0, 22));
        [btn_go addEETarget:self selector:@selector(clickFreeGet:)];
        [dialog addChild:btn_go];
        
        [self addChild:dialog z:1000];
    } else {
        [self clickFreeGet:nil];
    }
}

- (void)clickFreeGet:(id)sender{
    [self closeDialog:sender];
    [self clickByFreeMoney];
}

- (void)addScoreWallDialog {
    if (dialog == nil) {
        //清除TouchCanvas
        [self purgeTouchCanvas];
        //停止运动(物体的试运动)
        [gameassitant stopAllLinkPrevMove];
        
        
        dialog = [EEMaskSprite spriteWithFile:@"dialog_fc_bg.png"];
        dialog.position = ccp(160,240);
        
        for (int i = 1; i <= 4; i++) {
            NSString *string = [NSString stringWithFormat:@"free%d.png", i];
            EESpriteScaleBtn *btn_go = [EESpriteScaleBtn spriteWithFile:string];
            btn_go.position = ccp(40 + 69 * (i-1),122);
            btn_go.tag = i;
            [btn_go addEETarget:self selector:@selector(clickScoreWall:)];
            [dialog addChild:btn_go];
        }
        
        EESpriteScaleBtn *btn_close = [EESpriteScaleBtn spriteWithSpriteFrameName:@"dg_close.png"];
        btn_close.position = ccp(278,175);
        [btn_close addEETarget:self selector:@selector(closeDialog:)];
        [dialog addChild:btn_close];
        
        
        [self addChild:dialog z:1000];
    }
}

-(void)clickScoreWall:(EESpriteScaleBtn*)node
{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    
    [[Business sharedInstance] showVideo];
}

- (void)addTaskFinishDialog:(NSString*)content coin:(int)coin {
    if (dialog == nil) {
//        //清除TouchCanvas
//        [self purgeTouchCanvas];
//        //停止运动(物体的试运动)
//        [gameassitant stopAllLinkPrevMove];
        
        
        [[SoundManagerR shareInstance] playSound:@"level6-.wav" type:Sound_Type_Action];
        
        dialog = [EEMaskSprite spriteWithFile:@"dg_task_finish.png"];
        dialog.position = ccp(160,240);
        
        EESpriteScaleBtn *btn_close = [EESpriteScaleBtn spriteWithSpriteFrameName:@"dg_close.png"];
        btn_close.position = ccp(278,96);
        [btn_close addEETarget:self selector:@selector(closeTaskFinishDialog:)];
        [dialog addChild:btn_close];
        
        // 文字
        CCLabelTTF *label1 = [CCLabelTTF labelWithString:@"" fontName:@"Helvetica-Bold" fontSize:12];
        label1.color = ccWHITE;
        label1.anchorPoint = ccp(0,0.5);
        label1.position = ccp(113, 56);
        label1.string = @"恭喜您顺利的完成该任务";
        [dialog addChild:label1];
        
        // 文字
        CCLabelTTF *labelContent = [CCLabelTTF labelWithString:@"" fontName:@"Helvetica-Bold" fontSize:12];
        labelContent.color = ccWHITE;
        labelContent.anchorPoint = ccp(0,0.5);
        labelContent.position = ccp(113, 36);
        labelContent.string = [NSString stringWithFormat:@"任务内容：%@", content];
        [dialog addChild:labelContent];
        
        // 文字
        CCLabelTTF *labelCoin = [CCLabelTTF labelWithString:@"" fontName:@"Helvetica-Bold" fontSize:12];
        labelCoin.color = ccWHITE;
        labelCoin.anchorPoint = ccp(0,0.5);
        labelCoin.position = ccp(113, 20);
        labelCoin.string = [NSString stringWithFormat:@"获得奖励金币：%d枚", coin];
        [dialog addChild:labelCoin];
        
        [self add_cut_money:coin];
        
        
        [self addChild:dialog z:1000];
        
        [[Business sharedInstance] performSelector:@selector(showHalfBanner) withObject:nil afterDelay:1.0f];
    }
}

-(void)closeTaskFinishDialog:(id)sender{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    [dialog removeFromParentAndCleanup:TRUE];
    dialog = nil;
    
    GameTasks2 *gamesetting = [GameTasks2 node];
    [self addChild:gamesetting z:100];
    
}

- (void)addWelcomeDialog {
    if (dialog == nil) {
        //清除TouchCanvas
        [self purgeTouchCanvas];
        //停止运动(物体的试运动)
        [gameassitant stopAllLinkPrevMove];
        dialog = [EEMaskSprite spriteWithFile:@"dg_welcome.png"];
        dialog.position = ccp(160,240);
        
        EESpriteScaleBtn *btn_close = [EESpriteScaleBtn spriteWithSpriteFrameName:@"dg_close.png"];
        btn_close.position = ccp(278,96);
        [btn_close addEETarget:self selector:@selector(closeDialog:)];
        [dialog addChild:btn_close];
        
        
        //        EESpriteScaleBtn *btn_go = [EESpriteScaleBtn spriteWithSpriteFrameName:@"btn_continue.png"];
        //        btn_go.position = ccp(177,22);
        //        [btn_go addEETarget:self selector:@selector(clickContinue:)];
        //        [dialog addChild:btn_go];
        
        [self addChild:dialog z:1000];
    } else {
        //v1.2
        GameTasks2 *gamesetting = [GameTasks2 node];
        [self addChild:gamesetting z:100];
    }
}

- (void) applicationDidBecomeActive {
    [self addWelcomeDialog];
}


-(void)playsound{
    [self unscheduleAllSelectors];
    
    //背景音乐
    BOOL bgIsOpen = [[[Globel shareGlobel].allDataConfig objectForKey:@"sound_bg"] boolValue];
    if (bgIsOpen) {//如果开放的话
        [self schedule:@selector(playBgSound) interval:9];
    }
    
    int random = 7+ arc4random()%3;
    [self schedule:@selector(playsound) interval:random];
}

-(void)playBgSound{
    int random = arc4random() %10;
    if (random<=8) {
        int r = arc4random()%7+1;
        NSString *name = [NSString stringWithFormat:@"BG%d.wav",r];
        [[SoundManagerR shareInstance] playSound:name type:Sound_Type_Music];
    }
}
            
-(void)testCreate:(Link_Type )type :(int)level :(CGPoint)position{
            
    EESpriteScaleBtn *trace1 = [EESpriteScaleBtn spriteWithFile:@"test1.png"];
    trace1.position = position;
    [trace1 addEETarget:self selector:@selector(clicktestcreate:)];
    
    //[trace1 addEETarget:self selector:@selector(gameover)];
    [self addChild:trace1];
            
    Link *link = [Link createByType:type andLelve:level];
    link.scale = 0.5;
    link.position = ccp(12,12);
            
    [trace1 addChild:link];
    trace1.link = link;
        
}

-(CGPoint)getPositionByGridsX:(int)x Y:(int)y{
    Grid *grid = [[grids objectAtIndex:y] objectAtIndex:x];
    return grid.position;
}

#pragma mark ---设置 、得到、 基础数据---
-(void)setBaseData:(NSMutableArray *)array : (int)nx :(int)ny :(float)sx :(float)sy {
    track();
    grids = [array retain];
    
    numx = nx;
    numy = ny;
    startx = sx;
    starty = sy;
    
    //如果是在教程中，则执行以下操作
    if ([Globel shareGlobel].isInCourse) {
        
        putDownArray = [[NSMutableArray alloc] init];
        
        [putDownArray addObject:[NSValue valueWithCGPoint:[self getPositionByGridsX:5 Y:3] ]];
        [putDownArray addObject:[NSValue valueWithCGPoint:[self getPositionByGridsX:5 Y:3] ]];
        [putDownArray addObject:[NSValue valueWithCGPoint:[self getPositionByGridsX:4 Y:2] ]];
        [putDownArray addObject:[NSValue valueWithCGPoint:[self getPositionByGridsX:4 Y:2] ]];
        [putDownArray addObject:[NSValue valueWithCGPoint:[self getPositionByGridsX:5 Y:2] ]];
        [putDownArray addObject:[NSValue valueWithCGPoint:[self getPositionByGridsX:5 Y:2] ]];
        [putDownArray addObject:[NSValue valueWithCGPoint:[self getPositionByGridsX:1 Y:4] ]];
        [putDownArray addObject:[NSValue valueWithCGPoint:[self getPositionByGridsX:1 Y:4] ]];
        [putDownArray addObject:[NSValue valueWithCGPoint:[self getPositionByGridsX:1 Y:4] ]];
        [putDownArray addObject:[NSValue valueWithCGPoint:[self getPositionByGridsX:1 Y:4] ]];
        
        //v1.2 由于改变的仓库的位置
        CGPoint point = [self getPositionByGridsX:3 Y:5];
        point = ccpAdd(point, ccp(0, 50));
        [putDownArray addObject:[NSValue valueWithCGPoint:point ]];
        [putDownArray addObject:[NSValue valueWithCGPoint:point ]];
        
        [putDownArray addObject:[NSValue valueWithCGPoint:[self getPositionByGridsX:1 Y:2] ]];
        [putDownArray addObject:[NSValue valueWithCGPoint:[self getPositionByGridsX:1 Y:2] ]];
        [putDownArray addObject:[NSValue valueWithCGPoint:CGPointMake(1000, 1000)] ];
        
        isInDaohang = YES;
        stepnum = 1;
        
        //goto
        //加入蒙版
        blackMark = [BlackMask node];
        blackMark.position = [VisibleRect center];
        [self addChild:blackMark z:80];
        
        //touchDaoHang = [EESpriteBtn spriteWithFile:@"couseK.png"];
        touchDaoHang = [CCSprite spriteWithFile:@"couseK.png"];
        touchDaoHang.position = [[putDownArray objectAtIndex:0] CGPointValue];
        [self addChild:touchDaoHang z:81];
        
        [blackMark refreshState:touchDaoHang.position];
        
        
        inforbg = [CCSprite spriteWithFile:@"course_canvas.png"];
        inforbg.position = ccp(320*0.5,140*0.5);
        [self addChild:inforbg z:100];
        inforbg.tag = 456;
        
        infor = [CCSprite node];
        infor.position = ccp(313*0.5 - 10,136*0.5 - 20);
        [inforbg addChild:infor];
        [self changedInfor];
    }
}

-(NSMutableArray *)getGrids{
    return grids;
}

#pragma mark ----步骤操作----
-(BOOL)costOneStep{
    //步骤用完了
    if ([gamestep getLeftStep]<=0) {
    //if ([gamestep getLeftStep]<=3847) {
        
        if (dialog == nil) {
            
            //清除TouchCanvas
            [self purgeTouchCanvas];
            //停止运动(物体的试运动)
            [gameassitant stopAllLinkPrevMove];
            dialog = [EEMaskSprite spriteWithFile:@"点数不够了.png"];
            dialog.position = ccp(160,240);
            
            EESpriteScaleBtn *btn_close = [EESpriteScaleBtn spriteWithSpriteFrameName:@"dg_close.png"];
            btn_close.position = ccp(278,96);
            [btn_close addEETarget:self selector:@selector(closeDialog:)];
            [dialog addChild:btn_close];
            
            
            EESpriteScaleBtn *btn_go = [EESpriteScaleBtn spriteWithFile:@"免费获得.png"];
            btn_go.position = ccp(177,22);
            [btn_go addEETarget:self selector:@selector(getFreeStep)];
            [dialog addChild:btn_go];
            
            [self addChild:dialog z:1000];
        }
        
        return NO;
    }
    [gamestep add_cut_step:-1];
    
    conststep ++;
    
    return YES;
}



#pragma mark ----仓库 操作----
//v1.2
- (void)addGameRoomLockedDialog:(int)roomId {
    if (dialog == nil) {
        //清除TouchCanvas
        [self purgeTouchCanvas];
        //停止运动(物体的试运动)
        [gameassitant stopAllLinkPrevMove];
        
        dialog = [EEMaskSprite spriteWithFile:@"dg_room_lock.png"];
        dialog.position = ccp(160,240);
        
        EESpriteScaleBtn *btn_close = [EESpriteScaleBtn spriteWithSpriteFrameName:@"dg_close.png"];
        btn_close.position = ccp(278,96);
        [btn_close addEETarget:self selector:@selector(closeDialog:)];
        [dialog addChild:btn_close];
        
        // 文字
        CCLabelTTF *quote = [CCLabelTTF labelWithString:@"" fontName:@"Helvetica-Bold" fontSize:12];
        quote.color = ccWHITE;
        quote.anchorPoint = ccp(0.5,0.5);
        quote.position = ccp(185, 53);
        [dialog addChild:quote];
        if (roomId == 2) {
            quote.string = @"启用该暂存盘需要花费1000金币";
        } else if (roomId == 3) {
            quote.string = @"启用该暂存盘需要花费2000金币";
        }
        
        EESpriteScaleBtn *btn_go = [EESpriteScaleBtn spriteWithFile:@"btn_openroom.png"];
        btn_go.position = ccp(177,22);
        btn_go.tag = roomId;
        [btn_go addEETarget:self selector:@selector(clickOpenRoom:)];
        [dialog addChild:btn_go];
        
        [self addChild:dialog z:1000];
    }
}

-(void)clickOpenRoom:(CCNode*)node
{
    int usermoney = [[[Globel shareGlobel].allDataConfig objectForKey:@"usermoney"] intValue];
    int money = 1000;
    if (node.tag == 3) {
        money = 2000;
    }
    if (usermoney<money) {
        [dialog removeFromParentAndCleanup:true];
        dialog = NULL;
        [self addGoStoreDialog];
        return;
    }
    
    CCArray *allchilds = self.children;
    int len = [allchilds count];//遍历所有节点，找到，GameRoom
    for (int i=0; i<len; i++) {
        id ob = [allchilds objectAtIndex:i];
        if ([ob isKindOfClass:([GameRoom class])]) {
            GameRoom *room = (GameRoom*)ob;
            if (room.roomId == node.tag) {
                [room unlock:true];
                NSString *key = [NSString stringWithFormat:@"UnlockRoom%d", node.tag];
                [self setLevelConfigDate:[NSNumber numberWithBool:true] key:key];
            }
        }
    }
    [dialog removeFromParentAndCleanup:true];
    dialog = NULL;
    
    [self add_cut_money:-money];
}

-(void)clickGameRoom:(GameRoom *)room{
    trace(@"点击了仓库");
    
    if (room.locked) {
        [self addGameRoomLockedDialog:room.roomId];
        return;
    }
    
    
    if (isInDaohang) {
        if (stepnum == 11 || stepnum == 12) {
            [self changehighlightPosition];
        }else {
            return;
        }
        
    }
    
    
    if (isGameOver) {
        return;
    }
    
    [[SoundManagerR shareInstance] playSound:@"放入仓库.wav" type:Sound_Type_Action];

    //清除TouchCanvas
    [self purgeTouchCanvas];
    
    [gameassitant stopAllLinkPrevMove];
    
    if (room.isEmpty) {
        Link *link = [gamenextseat getLink];//得到link的引用
        [gamenextseat generateNext];  //生成下一个，移出当前显示link ，即上面的link
        
        [room pushLinkToStore:link];
        [link release];
    }else {
        Link *link = [gamenextseat getLink];//得到link的引用
        Link *roomlink = [room deleteLinkFromStore];//在room里面移出link，
        [gamenextseat replaceLink:roomlink];
        
        link.scale = 0.8;//如果这里不设定的话，要不然快速双击2次 room的话，则link的大小可能没有0.8倍
        
        [roomlink release];
        
        [room pushLinkToStore:link];
        [link release];
    }
    
    //结束时候特殊情况下产生的
    if (gameoverButRoomIsEmpty) {
        gameoverButRoomIsEmpty = NO;
        [self checkGameIsOver];
    }
}

#pragma mark ---队列操作 gamenextseat ---
-(void)insertNewLinkToGameNextSeat:(Link *)link{
    [gamenextseat insertNewLinkIn:link];
}

//记录队列
-(NSMutableArray *)rescordNextSeats{
    CCArray *seatArray = gamenextseat.seatArray;
    int len = [seatArray count];
    
    NSMutableArray *record = [NSMutableArray array];
    for (int a=0; a<len; a++) {
        Link *link = [seatArray objectAtIndex:a];
        
        NSMutableDictionary *recodlink = [NSMutableDictionary dictionary];
        [recodlink setValue:[NSNumber  numberWithInt:link.type] forKey:@"type"];
        [recodlink setValue:[NSNumber  numberWithInt:link.level] forKey:@"level"];
        [recodlink setValue:[NSNumber numberWithBool:link.issuper] forKey:@"issuper"];
        
        [record addObject:recodlink];
    }
    //以为在GameNextSeat初始化的时候，会默认删除数组的第一个，所以这里需要做一个小的处理，在第一个位置加入一个不关紧要的Link
    NSMutableDictionary *unessary = [NSMutableDictionary dictionary];
    [unessary setValue:[NSNumber  numberWithInt:Link_Type_House] forKey:@"type"];
    [unessary setValue:[NSNumber  numberWithInt:1] forKey:@"level"];
    [unessary setValue:[NSNumber  numberWithBool:NO] forKey:@"issuper"];
    [record insertObject:unessary atIndex:0];
    
    return record;
}

#pragma mark ----touchcanvas的操作----
//清除TouchCanvas
-(void)purgeTouchCanvas{
    if (touchCanvas!=nil) {
        [touchCanvas removeFromParentAndCleanup:YES];
        touchCanvas = nil;
    }
}

#pragma mark ---一些效果---
-(void)showWaring:(Grid *)grid{
    
}

#pragma mark ----Grid 操作----
-(void)touchOneGrid:(Grid *)grid{
    track();
    
    if ([Globel shareGlobel].isInCourse) {
        if (stepnum<15) {
            if (stepnum == 6) {
                [[SoundManagerR shareInstance] playSound:@"白兔子出现.wav" type:Sound_Type_Action];
            }
            CGPoint point = [[putDownArray objectAtIndex:stepnum-1] CGPointValue];
            if (grid.position.x == point.x && grid.position.y == point.y) {
            }else {
                return;
            }
        }
        [self changehighlightPosition];
    }
    
    
    //停止运动(物体的试运动)
    [gameassitant stopAllLinkPrevMove];
    
    //ALL
    BOOL isBom = NO;//炸弹
    BOOL isColorBall = NO;//彩虹球
    
    //得到队列中的第一个
    Link *firstLink = [gamenextseat getLink];
    if (firstLink==nil) {//这种情况一般是游戏结束了，然后gamenextseat就不生成了
        return;
    }
    
    //如果是炸弹的话
    if (firstLink.type == Link_Type_Tool && firstLink.level == 2) {
        //fd
        isBom = YES;
        if (grid.link==nil || grid.link.type == Link_Type_Wall) {
            [self showWaring:grid];
            //清除TouchCanvas
            [self purgeTouchCanvas];
            return;
        }
    }else {
        
        if (firstLink.type == Link_Type_Tool && firstLink.level ==1) {
            isColorBall = YES;
        }
        
        //判断改grid上面是否已经有了物体
        if (grid.link!=nil) {
            trace(@"不能放置");
            
            [[SoundManagerR shareInstance] playSound:@"放置错误.wav" type:Sound_Type_Action];
            //显示警示图片
            [self showWaring:grid];
            //清除TouchCanvas
            [self purgeTouchCanvas];
            
            //显示合成信息
            [self showCurrentLinkInfor:grid.link];
            
            //如果是  宝箱的话，则可以打开
            if (grid.link.type == Link_Type_Park ) {
                if (grid.link.level==4 || grid.link.level==5) {
                    [[SoundManagerR shareInstance] playSound:@"cash.mp3" type:Sound_Type_Action];
                    
                    int num;
                    if (grid.link.level==4) {
                        num = 50; //加50金币
                    }else {
                        num = 150;//加150金币
                    }
                    //加分
                    [gamemoney add_cut_money:num];
                    //加分 显示分数动画
                    [gameassitant showGetMoneyEffect:grid money:num];
                    //删除箱子
                    grid.link.pgrid = nil;
                    [grid.link removeFromParentAndCleanup:YES];
                    grid.link = nil;
                    //刷新草坪
                    [gameassitant refreshLawnTexture]; 
                }
            }
            return;
        }
    }
    
    
    //第一次点击屏幕的话，创建canvas，并加入场景
    if (touchCanvas==nil) {
        [[SoundManagerR shareInstance] playSound:@"touchprepare.wav" type:Sound_Type_Action];
        //处理tempFindLinks    
        [gameassitant clearTempFindLinksArray];
        
        touchCanvas = [TouchCanvas createByLink:firstLink];
        touchCanvas.position = grid.position;//摆放的位置与grid的位置相同
        [self addChild:touchCanvas z:100];
        if (firstLink.type != Link_Type_Rabbit) { //不是兔子的话，则查找可连接
            //检查地图上可组合的单位 firstLink不是炸弹，不是猫咪，不是飞猫   与下面的一样，最好放到一个函数里面去
            [gameassitant findLinksToLink:grid :firstLink];
            
            [gameassitant showFindLinksInfor];
        }
        
        return;
    }
    //说明是第二次点击
    if (touchCanvas != nil) {
        //步骤操作 消耗了一个步骤
        if (![self costOneStep]) {
            return;
        }
        
        trace(@"!!!!!!!!!!!!!!!!!放置物体：%d,%d", firstLink.type, firstLink.level);
        if (firstLink.type == Link_Type_House) {
            if (firstLink.level == 4) {
                peopleNumber += 2;
            } else if (firstLink.level == 5) {
                peopleNumber += 5;
            } else if (firstLink.level == 6) {
                peopleNumber += 20;
            } else if (firstLink.level == 7) {
                peopleNumber += 100;
            } else if (firstLink.level == 8) {
                peopleNumber += 500;
            } else if (firstLink.level == 9) {
                peopleNumber += 2000;
            }
        } else if (firstLink.type == Link_Type_Park) {
            if (firstLink.level == 1) {
                revolutedNumber += 2;
            } else if (firstLink.level == 2) {
                revolutedNumber += 10;
            } else if (firstLink.level == 3) {
                revolutedNumber += 50;
            }
        }
        int firstLinkType = firstLink.type;
        int firstLinkLevel = firstLink.level;
        
        
        //记住这个步骤，为了商店里面的撤退的道具
        [self rememberLastTempData];
        
        if (touchCanvas.position.x == grid.position.x && touchCanvas.position.y == grid.position.y) {
            if (isBom) {//炸弹
                [[SoundManagerR shareInstance] playSound:@"放下炸弹.wav" type:Sound_Type_Action];
                //炸弹操作
                [self placeBomOk:firstLink :grid];
            }else if(isColorBall){//彩虹球
                [[SoundManagerR shareInstance] playSound:@"touchdown.wav" type:Sound_Type_Action];
                //确定了放置的位置，并把firstLink传入
                [self placeColorBallOk:firstLink :grid];
            }else {
                [[SoundManagerR shareInstance] playSound:@"touchdown.wav" type:Sound_Type_Action];
                //确定了放置的位置，并把firstLink传入        兔子
                [self placeLinkOk:firstLink :grid];
            }
            
            //兔子的操作  移动，变石头，
            [self refreshRabbitState];
            
            
            
            
            // v1.2
            Task *finished = NULL;
            Task *next = NULL;
            for (Task *task in tasks) {
                if (task->operationType == Operate_Type_Place) {
                    if (task->targetLinkType == firstLinkType &&
                        task->targetLinkLevel == firstLinkLevel) {
                        next = [task stepUp];
                        finished = task;
                    }
                }
            }
            if (next) {
                [[GameScene shareInstance].tasks removeObject:finished];
                [[GameScene shareInstance].tasks addObject:next];
            }
            
            Task *finished2 = NULL;
            Task *next2 = NULL;
            for (Task *task in tasks) {
                if (task->operationType == Operate_Type_Use) {
                    if (task->targetLinkType == firstLinkType &&
                        task->targetLinkLevel == firstLinkLevel) {
                        next2 = [task stepUp];
                        finished2 = task;
                    }
                }
            }
            if (next2) {
                [[GameScene shareInstance].tasks removeObject:finished2];
                [[GameScene shareInstance].tasks addObject:next2];
            }
            
            
        }else {//第二次点击了其他的位置
            [[SoundManagerR shareInstance] playSound:@"touchprepare.wav" type:Sound_Type_Action];
            touchCanvas.position = grid.position;//摆放的位置与grid的位置相同
            
            if (firstLink.type != Link_Type_Rabbit) { //不是兔子的话，则查找可连接
                //检查地图上可组合的单位 firstLink不是炸弹，不是猫咪，不是飞猫
                [gameassitant findLinksToLink:grid :firstLink];
            }
            [gameassitant showFindLinksInfor];
        }
        
        
        [self checkGameIsOver];
        
        //v1.1 terababy
        // 增加机率存档，防止崩溃后无法存档的情况
        if (!isGameOver) {//游戏没有结束
            [self rememberNecessaryWhenBack];
        }
        [[EncryptionConfig shareInstance] saveConfig:[Globel shareGlobel].allDataConfig];
        
        
        
        int InterstitialCounter = [MyUserAnalyst getIntFlag:@"InterstitialCounter" defaultValue:0];
        
        if (InterstitialCounter >0) {
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            int useCount = [userDefaults integerForKey:@"InterstCounter"];
            useCount ++;
            if (useCount >= InterstitialCounter && GeneralOnOff) {
                [[Business sharedInstance] performSelector:@selector(showHalfBanner) withObject:nil afterDelay:1.0f];
                useCount = 0;
            }
            [userDefaults setInteger:useCount forKey:@"InterstCounter"];
        }
        
        
    }   
    //trace(@"%@ %f %f",grid,grid.position.x,grid.position.y);
}

-(void)addPeopleOrRevolute:(Link*)link
{
    if (link.type == Link_Type_House) {
        if (link.level == 4) {
            peopleNumber += 2;
        } else if (link.level == 5) {
            peopleNumber += 5;
        } else if (link.level == 6) {
            peopleNumber += 20;
        } else if (link.level == 7) {
            peopleNumber += 100;
        } else if (link.level == 8) {
            peopleNumber += 500;
        } else if (link.level == 9) {
            peopleNumber += 2000;
        }
    } else if (link.type == Link_Type_Park) {
        if (link.level == 1) {
            revolutedNumber += 2;
        } else if (link.level == 2) {
            revolutedNumber += 10;
        } else if (link.level == 3) {
            revolutedNumber += 50;
        }
    }
}

#pragma mark ----右上角，显示合成信息----

-(void)showCurrentLinkInfor:(Link *)link{
    [gameassitant showCurrentLinkInfor:link];
}

#pragma mark ---放置完成,关键方法_1---

-(void)putNewLinkInScene:(Link *)link :(Grid *)grid{
    
    if (link.type == Link_Type_Rabbit) {
        link.position = ccp(grid.position.x, grid.position.y + RabbitOffsetY);
    } else {
        link.position = grid.position;  
    }    
    link.scale = 1.0f;
    link.pgrid = grid;
    if (link.type == Link_Type_Rabbit) {//是兔子的话，则上一层
        [self addChild:link z:(7 - grid.y + 70)];
    }else if(link.type == Link_Type_Park && link.level==1){
        [self addChild:link];
    }else if(link.type == Link_Type_House && (link.level==7 || link.level ==8 || link.level == 9)){
        [self addChild:link z:(7-grid.y + link.level)];
    }else {
        [self addChild:link z:(7-grid.y)];
    }
    [link release];//link 在gamenextseat 的removeCurrent中retain了一次，所以这要release一下
}

int showScoreDelay;
-(void)placeLinkOk:(Link *)firstLink :(Grid *)grid{
    track();
    Link *link = firstLink;
    //清除TouchCanvas
    [self purgeTouchCanvas];
    
    
    //队列里面载入新的Link
    if (!pauseDoGenerate) {
        [gamenextseat generateNext];
    }
    
    //新的物体放入场景
    [self putNewLinkInScene:link :grid];
    //是否有必要创建小人
    [link regeistCreatePeopleHandle];
    //启动兔子动画
    [link regeistRabbitActinos];
    
    //把次Link的引用指向grid属性  并且赋值x y信息
    [grid setLinkRelation:link];
     
    if ([gameassitant isFindsLinks]) {
        
        //得到合并后的高级物种 并加入场景
        Link *superLink = [gameassitant getAllTogetherLink];
        trace(@"!!!!!!!!!!!!!!!!!产生物体：%d,%d", superLink.type, superLink.level);
        if (superLink.type == Link_Type_House) {
            if (superLink.level == 4) {
                peopleNumber += 2;
            } else if (superLink.level == 5) {
                peopleNumber += 5;
            } else if (superLink.level == 6) {
                peopleNumber += 20;
            } else if (superLink.level == 7) {
                peopleNumber += 100;
            } else if (superLink.level == 8) {
                peopleNumber += 500;
            } else if (superLink.level == 9) {
                peopleNumber += 2000;
            }
        } else if (superLink.type == Link_Type_Park) {
            if (superLink.level == 1) {
                revolutedNumber += 2;
            } else if (superLink.level == 2) {
                revolutedNumber += 10;
            } else if (superLink.level == 3) {
                revolutedNumber += 50;
            }
        }
        // v1.2
        Task *finished = NULL;
        Task *next = NULL;
        for (Task *task in tasks) {
            if (task->operationType == Operate_Type_Join) {
                if (task->targetLinkType == superLink.type &&
                    task->targetLinkLevel == superLink.level) {
                    next = [task stepUp];
                    finished = task;
                }
            }
        }
        if (next) {
            [[GameScene shareInstance].tasks removeObject:finished];
            [[GameScene shareInstance].tasks addObject:next];
        }
        
        
        grid.link = superLink;
        superLink.position = grid.position;
        superLink.pgrid = grid;
        
        [self addChild:superLink z:(7-grid.y)];
        
        //加分 显示分数
        [gameassitant showGetScoreEffect:link];
        [gameassitant showFindLinkScoreEffect:link position:link.pgrid.position];
        
        //删除放置的Link
        link.pgrid = nil;
        [link removeFromParentAndCleanup:YES];
        
        //删除原来的 从方格种删除。
        [gameassitant removeAllOldLinksAfterLinking];
        
        //开始合并  firstlink不是炸弹 不是猫咪 不是飞猫 
        [gameassitant linkAllFindLinks:grid :firstLink];   
    }else {//没有可合并的
        //加分 显示分数
        [gameassitant showGetScoreEffect:link];
    }
    //刷新草坪
    [gameassitant refreshLawnTexture]; 
}
//彩虹球
-(void)placeColorBallOk:(Link *)firstLink :(Grid *)grid{
    Link *lowerLink = [[gameassitant getLowestLink] retain]; 
    if (lowerLink ==nil) {
        [lowerLink release];
        lowerLink = [[Link createByType:Link_Type_Stone andLelve:1] retain];
    }
    
    
    //放置
    [self placeLinkOk:lowerLink :grid];
}

//放置了炸弹
-(void)placeBomOk:(Link *)firstLink :(Grid *)grid{
    //清除TouchCanvas
    [self purgeTouchCanvas];
    //队列里面载入新的Link
    [gamenextseat generateNext];
    
    Link *linkinGird = grid.link;
    if (linkinGird.type == Link_Type_Rabbit) {
        //创建宝箱，并渐变加入场景
        Link *park1 = [[Link createByType:Link_Type_Park andLelve:1] retain];//这里需要retain下，因为在putNewLinkInScene中release了下
        grid.link = park1;
        park1.pgrid = grid;
        [self putNewLinkInScene:park1 :grid];
        
        CCFadeIn *fadein = [CCFadeIn actionWithDuration:0.6];
        [park1 runAction:fadein];
        //清除Link 
        linkinGird.pgrid = nil;
        [linkinGird removeFromParentAndCleanup:YES];
        
        //检测兔笼是否可以有合并的
        [self LinkRabbitPark];
        
    }else if (linkinGird.type == Link_Type_Stone && linkinGird.level == 2) {//二级的石头 被炸出现宝箱
        //创建宝箱，并渐变加入场景
        Link *money = [[Link createByType:Link_Type_Park andLelve:4] retain];//这里需要retain下，因为在putNewLinkInScene中release了下
        grid.link = money;
        money.pgrid = grid;
        [self putNewLinkInScene:money :grid];
        
        CCFadeIn *fadein = [CCFadeIn actionWithDuration:0.6];
        [money runAction:fadein];
        //清除Link 
        linkinGird.pgrid = nil;
        [linkinGird removeFromParentAndCleanup:YES];
        
    }else{
        
        //减去分数
        int cutScore = linkinGird.score;
        if (linkinGird.issuper) {
            cutScore = cutScore *2;
        }
        [gamescore add_cut_score:cutScore*-1];
        
        
        //清除Link 
        linkinGird.pgrid = nil;
        [linkinGird removeFromParentAndCleanup:YES];
        grid.link = nil;
        
        //显示减去分数的动画
        [gameassitant showLostScoreEffect:grid score:-cutScore];
    }    
    
    //显示动画
    [gameassitant showBomEffect:grid];
    
    //刷新草坪
    [gameassitant refreshLawnTexture]; 
}


#pragma mark ----兔子刷新---
-(void)refreshRabbitState{
    track();
    //得到被困死的兔子
    NSMutableArray *diesArray = [gameassitant checkAllRabiit];
    
    //如果搞定了10只以上就打开第二关
    if ([diesArray count]>=10) {
        [[OpenLevel shareInstance] openLevel2];
    }
    
    
    //如果有的话，则转话成石头
    if ([diesArray count] > 0) {
        for (int i = 0; i<[diesArray count]; i++) {
            Link *dieRabbit = [diesArray objectAtIndex:i];
            Grid *grid = dieRabbit.pgrid;
            //创建宝箱，并渐变加入场景
            Link *park1 = [[Link createByType:Link_Type_Park andLelve:1] retain];//这里需要retain下，因为在putNewLinkInScene中release了下
            
            if (park1.type == Link_Type_Park) {
                if (park1.level == 1) {
                    revolutedNumber += 2;
                } else if (park1.level == 2) {
                    revolutedNumber += 10;
                } else if (park1.level == 3) {
                    revolutedNumber += 50;
                }
            }
            
            // v1.2
            Task *finished = NULL;
            Task *next = NULL;
            for (Task *task in tasks) {
                if (task->operationType == Operate_Type_Join) {
                    if (task->targetLinkType == park1.type &&
                        task->targetLinkLevel == park1.level) {
                        next = [task stepUp];
                        finished = task;
                    }
                }
            }
            if (next) {
                [[GameScene shareInstance].tasks removeObject:finished];
                [[GameScene shareInstance].tasks addObject:next];
            }
            
            
            
            dieRabbit.pgrid = nil;
            [dieRabbit removeFromParentAndCleanup:YES];
            
            
            grid.link = park1;
            park1.pgrid = grid;
            [self putNewLinkInScene:park1 :grid];
            
            CCFadeIn *fadein = [CCFadeIn actionWithDuration:0.2];
            [park1 runAction:fadein];
        }
        
        //合并石头
        [self performSelector:@selector(LinkRabbitPark) withObject:nil afterDelay:0.4];
    }
    
    //刷新草坪
    [gameassitant refreshLawnTexture]; 
    //兔子移动
    [gameassitant moveAllRabiit];
}
-(void)LinkRabbitPark{
    
    NSMutableArray *parkLevel1Array = [gameassitant getAllParkLevel1Array];
    
    int len = [parkLevel1Array count];
    if (len <= 2) {
        return;
    }
    
    //用了for循环，可能有多处会同时合体！！
    for (int i = (len-1) ; i>=0 ; i--) {
        Link *link = [parkLevel1Array objectAtIndex:i];
        if (link==nil || link.pgrid == nil) {
            continue;
        }
        
        Link *findlink = [[link copyOne] retain];
        
        Grid *grid = link.pgrid;
        
        //开始合并  firstlink不是炸弹 不是猫咪 不是飞猫 
        [gameassitant findLinksToLink:grid :findlink];
        
        NSMutableArray *togetherLink = [gameassitant getFindsLinks];
        if ([togetherLink count]!=0) {//说明可以合并的
            link.pgrid = nil;
            [link removeFromParentAndCleanup:YES];
        }
        
        //在grid中是否已经存在了兔笼，如果存在了，就删除
        if (grid.link != nil) {
            [grid clearLink];
        }
        
        //临时的解决办法，合并兔笼的时候，gameseatnext会执行generatenext多次
        pauseDoGenerate = YES;
        [self placeLinkOk:findlink :grid];
        pauseDoGenerate = NO;

    }

    
    //刷新草坪
    //[gameassitant refreshLawnTexture]; 
}













#pragma mark ---加分 ，减分---
-(void)setGameScore:(NSString *)gamescore{

}

-(void)add_cut_score:(int )score{
    [gamescore add_cut_score:score];
    
}

-(int)getGameScore{
    return  [gamescore getScore];
}

#pragma mark ---加金钱---
-(void)add_cut_money:(int)money{
    [gamemoney add_cut_money:money];
}

-(void)refreshMoneyAndStep{
    [gamemoney refresh];
    [gamestep refresh];
}


#pragma mark ---进入商店-   返回地图界面--
-(BOOL)isValidChexiaoInStore{
    if (lastStepGridsData==nil) {
        return NO;
    }
    return YES;
}

-(void)closeDialog:(id)sender{
    if(dialog != nil) {
        [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
        [dialog removeFromParentAndCleanup:TRUE];
        dialog = nil;
    }
}

-(void)addStorePage {
    Buy *buy = [Buy node];
    buy.delegate = self;
    [self addChild:buy z:100];
}

-(void)clickGoStore:(id)sender{
    [self closeDialog:sender];
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    [self addStorePage];
}

-(void)addToolPage {
    Store *store = [Store node];
    [self addChild:store z:100];
}

-(void)clickSetup:(id)sender {
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    GameTasks *gamesetting = [GameTasks node];
    [self addChild:gamesetting z:100];

    
//    GameSetting *gamesetting = [GameSetting node];
//    [self addChild:gamesetting z:100];
    
}

-(void)clickGoTool:(id)sender{
    //清除TouchCanvas
    [self purgeTouchCanvas];
    //停止运动(物体的试运动)
    [gameassitant stopAllLinkPrevMove];
    
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    [self addToolPage];
}

-(void)clickContinue:(id)sender {
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    [self closeDialog:sender];
}

-(void)clickGoToolForStepOver:(id)sender{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    [self closeDialog:sender];
    [self clickGoTool:sender];
}

-(void)clickGameMenuBtn:(id)sender{
    track();
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    //保存数据
    //TODO
    if (!isGameOver) {//游戏没有结束
        [self rememberNecessaryWhenBack];
    }
    
    
    //保存用户所有数据
    [[EncryptionConfig shareInstance] saveConfig:[Globel shareGlobel].allDataConfig];
    
    [gameassitant cancelAllPerform];
    
    //回收预制的
    [self disponse];
    
    CCScene *loads = [LoadingScene sceneWithTargetScene:TargetScene_worldmap];
    [[CCDirector sharedDirector] replaceScene:loads];
}






#pragma mark ---游戏进入后台---
//进入后台需要记住的东西 
-(void)rememberNecessaryWhenBack{
    
    if ([Globel shareGlobel].isInCourse) {
        return;
    }
    
    //记住当前分数
    int curScore = [gamescore getScore];
    
    NSString *strCurScore = [NSString stringWithFormat:@"%d",curScore];
    
    [self setLevelConfigDate:strCurScore key:@"currentscore"];
    
    [self setLevelConfigDate:[NSString stringWithFormat:@"%d", peopleNumber] key:@"PeopleNumber"];
    [self setLevelConfigDate:[NSString stringWithFormat:@"%d", revolutedNumber] key:@"RevolutedNumber"];
    
    //记住场景数据
    NSMutableArray *recordgrid = [gameassitant recordLinks];
    [self setLevelConfigDate:recordgrid key:@"archive"];
    
    //记录gamenextseat队列
    NSMutableArray *nextseats = [self rescordNextSeats];
    [self setLevelConfigDate:nextseats key:@"nextseat"];
    
    //记录游戏的是否结束状态
    [self setLevelConfigDate:[NSNumber numberWithBool:isGameOver] key:@"isgameover"];
    if (isGameOver) {
        [self setLevelConfigDate:[NSNumber numberWithBool:NO] key:@"isgameover"];
        [self setLevelConfigDate:[NSMutableArray array] key:@"archive"];
    }
    
    for (Task *task in tasks) {
        [task remember];
    }
    
    //记住仓库
    NSMutableArray *gamerooms = [NSMutableArray array];
    CCArray *allchilds = self.children;
    int len = [allchilds count];//遍历所有节点，找到，GameRoom
    for (int i=0; i<len; i++) {
        id ob = [allchilds objectAtIndex:i];
        if ([ob isKindOfClass:([GameRoom class])]) {
            Link *link = [(GameRoom *)ob getStoreLink];
            if (link==nil) {
                continue;
            }
            NSMutableDictionary *diction = [NSMutableDictionary dictionary];
            [diction setValue:([NSString stringWithFormat:@"%d",link.type]) forKey:@"type"];
            [diction setValue:([NSString stringWithFormat:@"%d",link.level]) forKey:@"level"];
            [gamerooms addObject:diction];
        }
    }
    [self setLevelConfigDate:gamerooms key:@"gamerooms"];
    [[GameStep shareInstance] rememberLevelTime];
    
}

//释放临时信息
-(void)releaseLastTempData{
    if (lastNextSeatData != nil) {
        [lastNextSeatData release];
        lastNextSeatData = nil;
    }
    if (lastStepGridsData != nil) {
        [lastStepGridsData release];
        lastStepGridsData = nil;
    }
}

//记住上一个步骤的状态
-(void)rememberLastTempData{
    //释放临时信息
    [self releaseLastTempData];
    
    //记住分数
    lastTempScore = [gamescore getScore];
    
    //记住场景数据
    lastStepGridsData = [[gameassitant recordLinks] retain];   
    
    //记录gamenextseat队列
    CCArray *seatArray = gamenextseat.seatArray;
    Link *link = [seatArray objectAtIndex:0];
    
    lastNextSeatData = [[NSMutableDictionary dictionary] retain];
    [lastNextSeatData setValue:[NSString stringWithFormat:@"%d",link.type] forKey:@"type"];
    [lastNextSeatData setValue:[NSString stringWithFormat:@"%d",link.level] forKey:@"level"];
}

//恢复上一个步骤
-(void)recoverLastTempData{
    
    // v1.2
    Task *finished = NULL;
    Task *next = NULL;
    for (Task *task in tasks) {
        if (task->operationType == Operate_Type_Use) {
            if (task->targetLinkType == 5 &&
                task->targetLinkLevel == 3) {
                next = [task stepUp];
                finished = task;
            }
        }
    }
    if (next) {
        [[GameScene shareInstance].tasks removeObject:finished];
        [[GameScene shareInstance].tasks addObject:next];
    }
    
    //恢复分数
    [gamescore set_score:lastTempScore];
    //恢复场景数据
    [gameassitant recoverLastTempGridsData:grids :lastStepGridsData];
    
    //恢复gamenextseat队列
    Link_Type type = [[lastNextSeatData objectForKey:@"type"] intValue];
    int level = [[lastNextSeatData objectForKey:@"level"] intValue];

    Link *new = [Link createByType:type andLelve:level];
    [gamenextseat insertNewLinkIn:new];

    //释放
    [self releaseLastTempData];
    
    [gameassitant refreshLawnTexture];
    
}


#pragma mark ---游戏结束---

-(void)checkGameIsOver{
    //检测游戏是否结束
    if ([gameassitant checkGameOver]) {
        //处理飞天兔，全部变成石头
        //[gameassitant allLevel2RabbitToPark];
        [gameassitant allRabbitToPark];
        //合并石头
        [self performSelector:@selector(LinkRabbitPark) withObject:nil afterDelay:0.4];
        
        //2秒后再执行一次，防止合并的时候会触发游戏结束
        [self performSelector:@selector(gameover) withObject:nil afterDelay:2];
        
        //刷新草坪
        [gameassitant refreshLawnTexture];
        
    }
}


//得到配置信息里面的数据  快捷方法
-(id)getLevelConfigDate:(NSString *)key{
    NSString *levelstr = [NSString stringWithFormat:@"level_%d",levelNum];
    id result = [[[Globel shareGlobel].allDataConfig objectForKey:levelstr] objectForKey:key];
    return result;
}
//设置配置信息里面的数据  快捷方法
-(void)setLevelConfigDate:(id)data key:(NSString *)k{
    NSString *levelstr = [NSString stringWithFormat:@"level_%d",levelNum];
    [[[Globel shareGlobel].allDataConfig objectForKey:levelstr] setValue:data forKey:k];
}

//创建功能按钮代理函数
-(void)creatBtnByFramename:(NSString *)framename px:(float)x py:(float)y sel:(SEL)callback{
    track();
    EESpriteScaleBtn *sprite = [EESpriteScaleBtn spriteWithSpriteFrameName:framename];
    //    sprite.anchorPoint = ccp(0,1);
    sprite.position = ccp(x,y);
    [sprite addEETarget:self selector:callback];
    [self addChild:sprite];
}
//创建功能按钮代理函数
-(void)creatBtnByFramename:(NSString *)framename px:(float)x py:(float)y sel:(SEL)callback order:(int)o{
    track();
    EESpriteScaleBtn *sprite = [EESpriteScaleBtn spriteWithSpriteFrameName:framename];
    //    sprite.anchorPoint = ccp(0,1);
    sprite.position = ccp(x,y);
    //sprite.scale = 0.8;
    [sprite addEETarget:self selector:callback];
    [self addChild:sprite z:o];
}

-(void)moveSomeNodeUp{
//    //分
//    gamescore.position = ccp(68,449);
//    
//    //步
//    gamestep.position = ccp(68,417);
//    
//    //钱
//    gamemoney.position = ccp(256,449);
//    
//    //next seat 预备席
//    gamenextseat.position = ccp(162,433);
    
}
-(void)addGameOverBtns{
    [self moveSomeNodeUp];
    //结束了 ,加入按钮
//    [[self getChildByTag:44] removeFromParentAndCleanup:YES];
//    [[self getChildByTag:45] removeFromParentAndCleanup:YES];
    
    //截图分享
//    [self creatBtnByFramename:@"js_share.png" px:83 py:385 sel:@selector(clickGameOverCameraShare) order:100];
        
    // 是否可以重新开始
    if ([Globel shareGlobel].tempBool || [Globel shareGlobel].isInCourse) {
        //重新开始
        [self creatBtnByFramename:@"js_restart.png" px:160 py:375 sel:@selector(clickGameOverRestatGame) order:100];
    }else {
        [self creatBtnByFramename:@"js_restart.png" px:160 py:375 sel:@selector(clickGameOverRestatGame) order:100];
    }
    [gameassitant clearCurrentLinkInfor];         
}        

-(void)gameover{
    //再检测游戏是否结束
    BOOL b = [gameassitant checkGameOver];
    if (!b) {
        return;
    }
    //检测1、场景上面有宝箱
    BOOL bb1 = [gameassitant checkExistBaoXiang];
    if (bb1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"别忘记了，您还有宝箱没打开哦" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];

        return;
    }
    //检测2、仓库里面有位置
    BOOL bb2 = [gameassitant checkRoomIsEmpty];
    if (bb2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"别忘记了，您还有仓库没用哦" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        gameoverButRoomIsEmpty = YES;
        return;
    }
    //检测3、仓库里面有炸弹
    BOOL bb3 = [gameassitant checkRoomHasBom];
    if (bb3) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"别忘记了，您仓库里面还有炸弹哦" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];

        return;
    }
    //检测4、队列里面是否是炸弹
    Link * linka = [gamenextseat getLink];
    if (linka.type == Link_Type_Tool && linka.level ==2) {
        return;
    }
    
    //游戏完毕后在执行一次 refreshRabbitState
    [self refreshRabbitState];
    
    //设置游戏结束状态
    isGameOver = YES;
    
    
    //如果是在教程里
    if ([Globel shareGlobel].isInCourse) {
        //结束了 ,加入按钮
        [self addGameOverBtns];
        //删除商店 目录按钮
//        [[self getChildByTag:44] removeFromParentAndCleanup:YES];
//        [[self getChildByTag:45] removeFromParentAndCleanup:YES];
        return;
    }
    
    
    
    [self rememberNecessaryWhenBack];
    [[EncryptionConfig shareInstance] saveConfig:[Globel shareGlobel].allDataConfig];
    
    //记录得分
//    [self setLevelConfigDate:[NSString stringWithFormat:@"%d",[gamescore getScore]] key:@"currentscore"];
    
    //处理本关的最高分
    int score = [gamescore getScore];
    
    int highest = [[self getLevelConfigDate:@"highestscore"] intValue];
    
    if (score>highest) {//新的最高分，则保存
        NSString *h = [NSString stringWithFormat:@"%d",score];
        [self setLevelConfigDate:h key:@"highestscore"];
        
        [[GameKitHelper sharedHelper] submitScore:score category:LeaderBoardId];
    }
    
    //是否打开第4关
    if (score<=20000) {
        [[OpenLevel shareInstance] openLevel5];//打开第4关
    }
    
    {
        //清除TouchCanvas
        //[self purgeTouchCanvas];
        //停止运动(物体的试运动)
        //[gameassitant stopAllLinkPrevMove];
        
        dialog = [EEMaskSprite spriteWithFile:@"dg_over_share_bg.png"];
        dialog.position = ccp(160,240);
        
//        EESpriteScaleBtn *btn_share = [EESpriteScaleBtn spriteWithFile:@"btn_over_share.png"];
//        btn_share.position = ccp(178,20);
//        [btn_share addEETarget:self selector:@selector(clickGameOverCameraShare)];
//        [dialog addChild:btn_share];
        
        EESpriteScaleBtn *btn_close = [EESpriteScaleBtn spriteWithSpriteFrameName:@"dg_close.png"];
        btn_close.position = ccp(278,96);
        [btn_close addEETarget:self selector:@selector(closeShareDialog:)];
        [dialog addChild:btn_close];
        
        CCLabelAtlas *peopleLabel = [CCLabelAtlas labelWithString:@"0" charMapFile:@"over_share_number.png" itemWidth:5 itemHeight:9 startCharMap:'0'];
        [dialog addChild:peopleLabel];
        [peopleLabel setString:[NSString stringWithFormat:@"%d", peopleNumber]];
        peopleLabel.position = ccp(200,58);
        
        CCLabelAtlas *revoluteLabel = [CCLabelAtlas labelWithString:@"0" charMapFile:@"over_share_number.png" itemWidth:5 itemHeight:9 startCharMap:'0'];
        [dialog addChild:revoluteLabel];
        [revoluteLabel setString:[NSString stringWithFormat:@"%d", revolutedNumber]];
        revoluteLabel.position = ccp(207,41);
        
        
        [self addChild:dialog z:1000];
    }
    
    
}

-(void)closeShareDialog:(id)sender{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    [dialog removeFromParentAndCleanup:TRUE];
    dialog = nil;
    
//    [[Business sharedInstance] hideAdvertise];
    
    [self realGameOver];
}

-(void)realGameOver
{
    
    [MobClick event:@"Interstitial" label:@"Gameover"];
    [[Business sharedInstance] performSelector:@selector(showHalfBanner) withObject:nil afterDelay:1.0f];
    
    //结束了 ,加入按钮
    [self addGameOverBtns];
    //删除商店 目录按钮
    //[[self getChildByTag:44] removeFromParentAndCleanup:YES];
    //[[self getChildByTag:45] removeFromParentAndCleanup:YES];
    
    //结束了 ,计算得分
    GameOver *gameover = [GameOver node];
//    gameover.position = CGPointMake(0, 50);
    [self addChild:gameover z:100];
    
}

-(void)clickGameOverCameraShare2{
    [self unschedule:@selector(clickGameOverCameraShare2)];
    
    //获取到了image
    UIImage * outputImage = [AWScreenshot takeAsImage];
    //保存进相册
    //UIImageWriteToSavedPhotosAlbum(outputImage, nil, nil, nil);
    //显示分享
    
    int score = [gamescore getScore];
    
//    NSString *body = [MyUserAnalyst getOnlineParam:ShareQuote];
//    NSMutableString * body2 = [NSMutableString stringWithFormat:body, score];
//    [UMSNS share:body2 image:outputImage key:umengAppKey];

    
    [self realGameOver];
}

//截屏分享
-(void)clickGameOverCameraShare{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    [dialog removeFromParentAndCleanup:true];
    dialog = NULL;
    
//    [[Business sharedInstance] hideAdvertise];
    
    [self schedule:@selector(clickGameOverCameraShare2) interval:0.1f];
}

//重新开始
-(void)clickNone{
    track();
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
}
//重新开始
-(void)clickGameOverRestatGame{
    track();
    
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    [gameassitant cancelAllPerform];
    [gameassitant releaseGridsTouchRegist];
    
    [self setLevelConfigDate:[NSNumber numberWithBool:NO] key:@"isgameover"];
    [self setLevelConfigDate:[NSMutableArray array] key:@"archive"];
    [[EncryptionConfig shareInstance] saveConfig:[Globel shareGlobel].allDataConfig];
    
    [self disponse];
    
    instance = nil;
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameScene scene]]];
    
//    CCScene *loads = [LoadingScene sceneWithTargetScene:TargetScenes_gamescen];
//    [[CCDirector sharedDirector] replaceScene:loads];
}
//返回
-(void)clickGameOverReturn{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    [self clickGameMenuBtn:nil];
}

#pragma mark ---小人----
-(int)getPeopleCount{
    CCArray *allchildren = self.children;
    int a=0;
    for (id child in allchildren) {
        if ([child isKindOfClass:[People class]]) {
            a++;
        }
    }
    return a;
}

#pragma mark -----教程-----

-(void)changehighlightPosition{
    if (isInDaohang) {
        stepnum++;
        if (stepnum>15) {
            isInDaohang = NO;
            
            [Globel shareGlobel].isInCourse = NO;
            
            [[Business sharedInstance] showAdvertise];
            
            return;
        }
        if (stepnum==15) {
            [self courseOver];
        }
        touchDaoHang.position = [[putDownArray objectAtIndex:stepnum-1] CGPointValue];
        
        [blackMark refreshState:touchDaoHang.position];
        
        [self changedInfor];
    }
}

-(void)changedInfor{
    NSString *filename = [NSString stringWithFormat:@"course%d",stepnum];
    NSString *path =[[NSBundle mainBundle] pathForResource:filename ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfResolutionIndependentFile:path];
    CCTexture2D *texture = [[CCTexture2D alloc] initWithImage:image];
    
    CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(0, 0, image.size.width, image.size.height)];
    [infor setDisplayFrame:frame];
    
    [texture release];
}


-(void)courseOver{
    //[blackMark removeFromParentAndCleanup:YES];
    blackMark.position = ccp(1000,1000);
    //[self schedule:@selector(removeInfor) interval:2];
    //v1.2
    
    [self performSelector:@selector(removeInfor) withObject:nil afterDelay:2];
}

-(void)removeInfor{
    [self initTasks];
    GameTasks2 *gamesetting = [GameTasks2 node];
    [self addChild:gamesetting z:100];
    [inforbg removeFromParentAndCleanup:YES];
}

#pragma mark----生命周期-----

-(void)disponse{
    
    //[birdController disponse];
    //[birdController release];
    
    [peopleController disponse];//立即做回收之前的准备，看来这个disponse方法还是需要的，release了后不一定会马上就执行dealloc方法，如果放在onExit里面的话，也有延迟。所以要在这个clickGameMenuBtn函数里面写回收准备的方法。
    [peopleController release];
    
    [cloudController disponse];
    [cloudController release];
    
}

-(void)onExit{
    track();
    
    //无论是不是在教程里面，反正退出的时候，
    [Globel shareGlobel].isInCourse = NO;
    
    [self unscheduleAllSelectors];
    
    if (lastStepGridsData!=nil) {
        [self releaseLastTempData];
    }
    
    //二维数组回收
    [grids release];
    //回收助手
    [gameassitant release];
    
    //停止静态变量的引用，应提前
    //instance = nil;
    
    
    [super onExit];
}

#pragma mark ---激励道具---

- (void)tryCreateItem{

    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"last_item_date"];
    if ((date != nil && [[NSDate date] timeIntervalSinceDate:date] < [HLAnalyst intValue:@"free_item_time" defaultValue:kFreeItemRefreshTime]) || [HLAnalyst boolValue:@"free_item_hide" defaultValue:false]){
        return;
    }
    CCNode *btn = [self getChildByTag:186];
    if (btn != nil) {
        return;
    }
    
    
    
    EESpriteScaleBtn *sprite = [EESpriteScaleBtn spriteWithFile:@"悬浮礼包.png"];
    sprite.position = ccpAdd([VisibleRect center], ccp(0,60)) ;
    sprite.tag = 186;
    [sprite addEETarget:self selector:@selector(getFreeItem)];
    [self addChild:sprite z:99];

    
    [self randomMove];
    
}

- (void)randomMove{
    CCSprite *sprite = (CCSprite *)[self getChildByTag:186];
    [self setRandomLine];
    float t = ccpLength(ccpSub(randomEnd, randomStart)) / 80;
    
    CCFiniteTimeAction *ac1 = [CCPlace actionWithPosition:randomStart];
    CCFiniteTimeAction *ac2 = [CCMoveTo actionWithDuration:t position:randomEnd];
    CCCallFunc *ac3 = [CCCallFunc actionWithTarget:self selector:@selector(randomMove)];
    CCSequence *seq = [CCSequence actions:ac1, ac2, ac3, nil];
    [sprite runAction:seq];
}

- (CGPoint)multipleVisibleVector:(CGPoint)p{
    CGPoint v = ccpSub(p, [VisibleRect center]);
    return ccpAdd(ccpMult(v, 1.1), [VisibleRect center]);
}

- (void)setRandomLine{
    CGPoint points[4] = {[self multipleVisibleVector:[VisibleRect leftTop]], [self multipleVisibleVector:[VisibleRect rightTop]], [self multipleVisibleVector:[VisibleRect rightBottom]], [self multipleVisibleVector:[VisibleRect leftBottom]]};
    
    int num1 = [KTMathUtil randomIntRange:0 and:4];
    int num2 = num1 + 2;
    num1 = fmodf(num1, 4);
    num2 = fmodf(num2, 4);
    
    int num11 = fmodf(num1+1, 4);
    int num22 = fmodf(num2+1, 4);
    
    randomStart = [self randomPoint:points[num1] and:points[num11]];//= points[num1]
    randomEnd = [self randomPoint:points[num2] and:points[num22]];

}

- (CGPoint)randomPoint:(CGPoint)a and:(CGPoint)b{
    CGPoint v = ccpSub(b, a);
    float l = arc4random() % (int)ccpLength(v);
    return ccpAdd(ccpMult(ccpNormalize(v), l), a);
}

- (void)getFreeItem{
    [self closeDialog:nil];
    if([HLAnalyst boolValue:@"show_ad_tip"]){
        dialog = [EEMaskSprite spriteWithFile:@"观看广告即可获得道具.png"];
        dialog.position = ccp(160,240);
        
        EESpriteScaleBtn *btn_close = [EESpriteScaleBtn spriteWithSpriteFrameName:@"dg_close.png"];
        btn_close.position = ccp(278,96);
        [btn_close addEETarget:self selector:@selector(closeDialog:)];
        [dialog addChild:btn_close];

        EESpriteScaleBtn *btn_go = [EESpriteScaleBtn spriteWithFile:@"免费获得.png"];
        
        btn_go.position = ccpAdd([VisibleRect bottom], ccp(0, 22));
        [btn_go addEETarget:self selector:@selector(clickByFreeItem)];
        [dialog addChild:btn_go];
        
        [self addChild:dialog z:1000];
    } else {
        [self clickByFreeItem];
    }
}

- (void)clickByFreeItem{

    [self closeDialog:nil];
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemVideoPlayed:) name:HLInterstitialFinishNotification object:nil];
    [[Business sharedInstance] showVideo];
}

- (void)itemVideoPlayed:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    int num = arc4random()%3;
    NSString *name;
    switch (num) {
        case 0:
        {
            //color ball
            Link *link = [Link createByType:Link_Type_Tool andLelve:1];
            [[GameScene shareInstance] insertNewLinkToGameNextSeat:link];
            name = @"万能胶囊";
        }
            break;
        case 1:{
            
            Link *link = [Link createByType:Link_Type_Tool andLelve:2];
            [[GameScene shareInstance] insertNewLinkToGameNextSeat:link];
            name = @"爆破弹";
            
        }break;
        case 2:{
            Link *link = [Link createByType:Link_Type_House andLelve:3];
            [[GameScene shareInstance] insertNewLinkToGameNextSeat:link];
            name = @"大树";
        }break;
        default:
            break;
    }
    
    TipAlert *alert = [TipAlert createWithTitle:[NSString stringWithFormat:@"恭喜你获得%@一个", name]];
    [self addChild:alert z:100];
    [self removeChildByTag:186 cleanup:YES];
    NSDate *date = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"last_item_date"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSelector:@selector(tryCreateItem) withObject:nil afterDelay:[HLAnalyst intValue:@"free_item_time" defaultValue:kFreeItemRefreshTime]+1];
    
}



- (void)getFreeStep{
    [self closeDialog:nil];
    if([HLAnalyst boolValue:@"show_ad_tip"]){
        dialog = [EEMaskSprite spriteWithFile:@"观看广告即可获得点数.png"];
        dialog.position = ccp(160,240);
        
        EESpriteScaleBtn *btn_close = [EESpriteScaleBtn spriteWithSpriteFrameName:@"dg_close.png"];
        btn_close.position = ccp(278,96);
        [btn_close addEETarget:self selector:@selector(closeDialog:)];
        [dialog addChild:btn_close];
        
        EESpriteScaleBtn *btn_go = [EESpriteScaleBtn spriteWithFile:@"免费获得.png"];
        
        btn_go.position = ccpAdd([VisibleRect bottom], ccp(0, 22));
        [btn_go addEETarget:self selector:@selector(clickByFreeStep)];
        [dialog addChild:btn_go];
        
        [self addChild:dialog z:1000];
    } else {
        [self clickByFreeStep];
    }
}

- (void)clickByFreeStep{
    
    [self closeDialog:nil];
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stepVideoPlayed:) name:HLInterstitialFinishNotification object:nil];
    [[Business sharedInstance] showVideo];
}

- (void)stepVideoPlayed:(NSNotification *)notification{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    int step = [[[Globel shareGlobel].allDataConfig objectForKey:@"step"] intValue];
    step += 200;
    [[Globel shareGlobel].allDataConfig setValue:[NSString stringWithFormat:@"%d",step] forKey:@"step"];
    
    TipAlert *alert = [TipAlert createWithTitle:[NSString stringWithFormat:@"恭喜你获得%d点数", 200]];
    [self addChild:alert z:100];
    [self refreshMoneyAndStep];
}

#pragma mark ---测试按钮---
-(void)clicktest1:(id)sender{
    [gameassitant traceGrid];
}

-(void)clicktest2:(id)sender{
    
    [gameassitant trace1_0];
}

-(void)generateNewLink:(id)sender{
    [gamenextseat generateNext];
}
-(void)clicktestcreate:(EESpriteScaleBtn *)sp{
    Link *link =  (Link *)sp.link;
    [gamenextseat generateNext:link.type :link.level :NO];
    
}
@end
