

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

#import "GameScene_Course.h"
#import "EESpriteScaleBtn.h"
#import "LoadingScene.h"
#import "GameStep.h"
#import "GameMoney.h"
#import "GameHelp.h"
#import "GameNextSeat.h"
#import "GameScore.h"
#import "Grid.h"
#import "CCAnimationHelper.h"

#import "GameDataSetting_Course.h"
#import "TouchCanvas.h"
#import "Link.h"
#import "GameRoom.h"
#import "Store.h"
#import "GameOver.h"
#import "Share.h"
#import "MaskLayer.h"
#import "OpenLevel.h"
#import "UIImageHelper.h"
#import "SoundManagerR.h"
#import "BirdController.h"
#import "PeopleController.h"
#import "People.h"

#import "CloudController.h"


#import "AWScreenshot.h"

static GameScene_Course *instance;

@implementation GameScene_Course

@synthesize peopleController,birdController;

+(CCScene *)scene{
    CCScene *s = [CCScene node];
    
    GameScene_Course *m = [GameScene_Course node];
    [s addChild:m];
    
    return s;
}

+(GameScene_Course *)shareInstance{
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        track();
        //赋值给静态变量
        instance = self;
        //关卡号
        levelNum = 1;
        [Globel shareGlobel].curLevel = 1;
        
        //游戏是否结束
        //isGameOver = [[self getLevelConfigDate:@"isgameover"] boolValue];
        isGameOver = NO;
        
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
        
        
        //        //草坪精灵批处理
        //        batchLawn = [CCSpriteBatchNode batchNodeWithFile:@"lawngreen.png"];
        //        [self addChild:batchLawn];
        
        //背景草坪
        CCSprite *bg;
        
        NSString *str ;
        if (levelNum==1 || levelNum==2 || levelNum==3 || levelNum==4) {
            str = [NSString stringWithFormat:@"level1-bg.png",levelNum];
        }else {
            str = [NSString stringWithFormat:@"level%d-bg.png",levelNum];
        }
        bg = [CCSprite spriteWithFile:str];
        bg.position = ccp(SSSW*0.5,SSSH*0.5);
        [self addChild:bg];

        
        
        
        //商店按钮
        EESpriteScaleBtn *btn_gostore = [EESpriteScaleBtn spriteWithSpriteFrameName:@"商店.png"];
        btn_gostore.position = ccp(242,416);
        btn_gostore.tag = 44;
        btn_gostore.opacity = 200;
        [btn_gostore addEETarget:self selector:@selector(clickNone)];
        [self addChild:btn_gostore];
        
        //菜单按钮
        EESpriteScaleBtn *btn_gamemenu = [EESpriteScaleBtn spriteWithSpriteFrameName:@"菜单.png"];
        btn_gamemenu.position = ccp(297,416);
        btn_gamemenu.tag = 45;
        [btn_gamemenu addEETarget:self selector:@selector(clickGameMenuBtn:)];
        [self addChild:btn_gamemenu];
        
        //分
        gamescore = [GameScore spriteWithSpriteFrameName:@"得分.png"];
        gamescore.position = ccp(68,449);
        [self addChild:gamescore];
        
        //步
        gamestep = [GameStep spriteWithSpriteFrameName:@"步数.png"];
        gamestep.position = ccp(68,417);
        [self addChild:gamestep];
        
        //钱
        gamemoney = [GameMoney spriteWithSpriteFrameName:@"兔币.png"];
        gamemoney.position = ccp(256,449);
        [self addChild:gamemoney];
        
        //next seat 预备席
        gamenextseat = [GameNextSeat node];
        gamenextseat.position = ccp(162,433);
        [self addChild:gamenextseat];
        
        //关卡图标
        /*
        NSString *qiaico = [NSString stringWithFormat:@"level_prohibit%d.png",levelNum];
        CCSprite *sp = [CCSprite spriteWithSpriteFrameName:qiaico];
        sp.position = ccp(22,409);
        [self addChild:sp];
         */
        
        //数据操作助手   不同关卡，不同的配置
        gameassitant = [[GameDataSetting_Course alloc] init];
        [gameassitant analyseData:self levelNum:levelNum];
        //刷新草坪
        [gameassitant refreshLawnTexture];
        [gamenextseat generateNext];
        
        /**/
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
        [self testCreate:Link_Type_House :1 :ccp(10,19)];
        [self testCreate:Link_Type_House :2 :ccp(40,19)];
        [self testCreate:Link_Type_House :3 :ccp(70,19)];
        [self testCreate:Link_Type_House :4 :ccp(100,19)];
        [self testCreate:Link_Type_House :5 :ccp(130,19)];
        [self testCreate:Link_Type_House :6 :ccp(160,19)];
        [self testCreate:Link_Type_House :7 :ccp(190,19)];
        [self testCreate:Link_Type_House :8 :ccp(220,19)];
        [self testCreate:Link_Type_House :9 :ccp(250,19)];
        
        [self testCreate:Link_Type_Stone :1 :ccp(10,47)];
        [self testCreate:Link_Type_Stone :2 :ccp(40,47)];
        
        [self testCreate:Link_Type_Park :1 :ccp(70,47)];
        [self testCreate:Link_Type_Park :2 :ccp(100,47)];
        [self testCreate:Link_Type_Park :3 :ccp(130,47)];
        [self testCreate:Link_Type_Park :4 :ccp(160,47)];
        [self testCreate:Link_Type_Park :5 :ccp(190,47)];
        
        [self testCreate:Link_Type_Rabbit :1 :ccp(220,47)];
        [self testCreate:Link_Type_Rabbit :2 :ccp(250,47)];
        [self testCreate:Link_Type_Tool :1 :ccp(280,47)];
        [self testCreate:Link_Type_Tool :2 :ccp(310,47)];
        
        /*
         1、普通
         2、兔子1.5倍
         3、特殊商店
         4、无仓
         5、没有兔子
         6、月光村，受限
         7、双仓库
         8、冒险岛(无飞天猫)
         */
        
        [gamenextseat insertNewLinkIn:[Link createByType:Link_Type_House andLelve:1]];
        [gamenextseat insertNewLinkIn:[Link createByType:Link_Type_Tool andLelve:2]];
        [gamenextseat insertNewLinkIn:[Link createByType:Link_Type_House andLelve:1]];
        [gamenextseat insertNewLinkIn:[Link createByType:Link_Type_Rabbit andLelve:1]];
        [gamenextseat insertNewLinkIn:[Link createByType:Link_Type_House andLelve:3]];
        [gamenextseat insertNewLinkIn:[Link createByType:Link_Type_House andLelve:2]];
        [gamenextseat insertNewLinkIn:[Link createByType:Link_Type_House andLelve:1]];
        
        //显示小鸟动画
        birdController = [[BirdController alloc] initWithDelegate:self];
        
        //显示小人动画
        peopleController = [[PeopleController alloc] initWithXNum:numx YNum:numy dele:self];              
        
        //显示云彩阴影动画
        cloudController = [[CloudController alloc] initWithDelegate:self];
        
        
        //[self scheduleUpdate];
        int random = 7+ arc4random()%3;
        [self schedule:@selector(playsound) interval:random];  
    }       
    
    
      return self;
    
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

#pragma  mark ---教程----
-(void)changehighlightPosition{
    if (isInDaohang) {
        stepnum++;
        if (stepnum>15) {
            isInDaohang = NO;
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
    [self performSelector:@selector(removeInfor) withObject:nil afterDelay:2];
}

-(void)removeInfor{
    
    [inforbg removeFromParentAndCleanup:YES];
}
#pragma mark ---设置 、得到、 基础数据---
-(void)setBaseData:(NSMutableArray *)array : (int)nx :(int)ny :(float)sx :(float)sy {
    track();
    grids = [array retain];
    
    numx = nx;
    numy = ny;
    startx = sx;
    starty = sy;
    
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
    [putDownArray addObject:[NSValue valueWithCGPoint:[self getPositionByGridsX:0 Y:5] ]];
    [putDownArray addObject:[NSValue valueWithCGPoint:[self getPositionByGridsX:0 Y:5] ]];
    [putDownArray addObject:[NSValue valueWithCGPoint:[self getPositionByGridsX:1 Y:2] ]];
    [putDownArray addObject:[NSValue valueWithCGPoint:[self getPositionByGridsX:1 Y:2] ]];
    [putDownArray addObject:[NSValue valueWithCGPoint:CGPointMake(1000, 1000)] ];
    
    isInDaohang = YES;
    stepnum = 1;
    
    //仓库
    GameRoom *room1 = [GameRoom spriteWithFile:@"blankpng.png"];
    [room1 addEETarget:self selector:@selector(clickGameRoom:)];
    [self addChild:room1];
    room1.position = ccp(35,340);  
    
    //加入蒙版
    blackMark = [BlackMask node];
    blackMark.position = ccp(320*0.5,480*0.5);
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
    infor.position = ccp(313*0.5,136*0.5);
    [inforbg addChild:infor];
    [self changedInfor];
    
    [Globel shareGlobel].isInCourse = YES;
}

-(NSMutableArray *)getGrids{
    return grids;
}
#pragma mark ----步骤操作----
-(BOOL)costOneStep{
    //步骤用完了
    if ([gamestep getLeftStep]<=0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"步骤已经全部用完了，请您稍等片刻。或者去商店购买步骤" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        return NO;
    }
    [gamestep add_cut_step:-1];
    
    conststep ++;
    
    return YES;
}

#pragma mark ----仓库 操作----
-(void)clickGameRoom:(GameRoom *)room{
    [[SoundManagerR shareInstance] playSound:@"放入仓库.wav" type:Sound_Type_Action];
    if (isInDaohang) {
        if (stepnum == 11 || stepnum == 12) {
            [self changehighlightPosition];
        }else {
            return;
        }
        
    }
    
    trace(@"点击了仓库");
    if (isGameOver) {
        return;
    }
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
        [roomlink release];
        
        [room pushLinkToStore:link];
        [link release];
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
    //[putDownArray addObject:[NSValue valueWithCGPoint:CGPointMake(1000, 1000)] ];
    //afsd
    
    [self changehighlightPosition];
    
    track();
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
                    [[SoundManagerR shareInstance] playSound:@"打开箱子.wav" type:Sound_Type_Action];
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
        }else {//第二次点击了其他的位置
            [[SoundManagerR shareInstance] playSound:@"touchprepare.wav" type:Sound_Type_Action];
            touchCanvas.position = grid.position;//摆放的位置与grid的位置相同
            
            if (firstLink.type != Link_Type_Rabbit) { //不是兔子的话，则查找可连接
                //检查地图上可组合的单位 firstLink不是炸弹，不是猫咪，不是飞猫
                [gameassitant findLinksToLink:grid :firstLink];
            }
            [gameassitant showFindLinksInfor];
        }
        
        //检测游戏是否结束
        if ([gameassitant checkGameOver]) {
            //处理飞天兔，全部变成石头
            [gameassitant allRabbitToPark];
            //合并石头
            [self performSelector:@selector(LinkRabbitPark) withObject:nil afterDelay:0.4];
            
            //2秒后再执行一次，防止合并的时候会触发游戏结束
            [self performSelector:@selector(gameover) withObject:nil afterDelay:2];
        }
    }   
    //trace(@"%@ %f %f",grid,grid.position.x,grid.position.y);
}



-(void)showCurrentLinkInfor:(Link *)link{
    [gameassitant showCurrentLinkInfor:link];
}


#pragma mark ---放置完成,关键方法_1---

-(void)putNewLinkInScene:(Link *)link :(Grid *)grid{
    link.position = grid.position;      
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
        grid.link = superLink;
        superLink.position = grid.position;
        superLink.pgrid = grid;
        [self addChild:superLink];
        
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

-(void)clickStore:(id)sender{
    Store *store = [Store node];
    [self addChild:store];
}

-(void)clickGameMenuBtn:(id)sender{
    track();
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    //保存数据
    //TODO
    
    /*
    if (!isGameOver) {//游戏没有结束
        [self rememberNecessaryWhenBack];
    }
    */
    
    //返回后，不处于教程状态
    [Globel shareGlobel].isInCourse = NO;
    
    
    [gameassitant cancelAllPerform];
    
    
    
    [birdController disponse];
    [birdController release];
    [peopleController disponse];//立即做回收之前的准备，看来这个disponse方法还是需要的，release了后不一定会马上就执行dealloc方法，如果放在onExit里面的话，也有延迟。所以要在这个clickGameMenuBtn函数里面写回收准备的方法。
    [peopleController release];
    
    [cloudController disponse];
    [cloudController release];
    
    
    
    
    CCScene *loads = [LoadingScene sceneWithTargetScene:TargetScene_worldmap];
    [[CCDirector sharedDirector] replaceScene:loads];
}






#pragma mark ---游戏进入后台---
//进入后台需要记住的东西 
-(void)rememberNecessaryWhenBack{
    //记住当前分数
    int curScore = [gamescore getScore];
    
    NSString *strCurScore = [NSString stringWithFormat:@"%d",curScore];
    
    [self setLevelConfigDate:strCurScore key:@"currentscore"];
    
    //记住场景数据
    NSMutableArray *recordgrid = [gameassitant recordLinks];
    [self setLevelConfigDate:recordgrid key:@"archive"];
    
    //记录gamenextseat队列
    NSMutableArray *nextseats = [self rescordNextSeats];
    [self setLevelConfigDate:nextseats key:@"nextseat"];
    
    //记录游戏的是否结束状态
    [self setLevelConfigDate:[NSNumber numberWithBool:isGameOver] key:@"isgameover"];
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
}//创建功能按钮代理函数
-(void)creatBtnByFramename:(NSString *)framename px:(float)x py:(float)y sel:(SEL)callback order:(int)o{
    track();
    EESpriteScaleBtn *sprite = [EESpriteScaleBtn spriteWithSpriteFrameName:framename];
    //    sprite.anchorPoint = ccp(0,1);
    sprite.position = ccp(x,y);
    [sprite addEETarget:self selector:callback];
    [self addChild:sprite z:o];
}
     


-(void)moveSomeNodeUp{
    //分
    gamescore.position = ccp(68,449);
    
    //步
    gamestep.position = ccp(68,417);
    
    //钱
    gamemoney.position = ccp(256,449);
    
    //next seat 预备席
    gamenextseat.position = ccp(162,433);
    
}
     

-(void)addGameOverBtns{
    [self moveSomeNodeUp];
    //结束了 ,加入按钮
    [[self getChildByTag:44] removeFromParentAndCleanup:YES];
    [[self getChildByTag:45] removeFromParentAndCleanup:YES];
    
    //截图分享
    [self creatBtnByFramename:@"js_share.png" px:83 py:385 sel:@selector(clickGameOverCameraShare) order:100];
    
    // 是否可以重新开始
    //if ([Globel shareGlobel].tempBool) {
        //重新开始
        [self creatBtnByFramename:@"js_restart0.png" px:238 py:385 sel:@selector(clickNone) order:100];
    //}else {
    //    [self creatBtnByFramename:@"js_restart.png" px:238 py:370 sel:@selector(clickGameOverRestatGame)];
    //}
    
    //返回
    [self creatBtnByFramename:@"js_back.png" px:256 py:418 sel:@selector(clickGameOverReturn) order:100];
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
    
    /*
    //设置游戏结束状态
    isGameOver = YES;
    
    [self rememberNecessaryWhenBack];
    
    //记录得分
    //    [self setLevelConfigDate:[NSString stringWithFormat:@"%d",[gamescore getScore]] key:@"currentscore"];
    
    //处理本关的最高分
    int score = [gamescore getScore];
    
    int highest = [[self getLevelConfigDate:@"highestscore"] intValue];
    
    if (score>highest) {//新的最高分，则保存
        NSString *h = [NSString stringWithFormat:@"%d",score];
        [self setLevelConfigDate:h key:@"highestscore"];
    }
    */
    
    //结束了 ,加入按钮
    [self addGameOverBtns];
    //删除商店 目录按钮
    [[self getChildByTag:44] removeFromParentAndCleanup:YES];
    [[self getChildByTag:45] removeFromParentAndCleanup:YES];
    
    /*
    //结束了 ,计算得分
    GameOver *gameover = [GameOver node];
    [self addChild:gameover];
    
    
    
    //是否打开第4关
    if (score<=20000) {
        [[OpenLevel shareInstance] openLevel5];//打开第4关
    }*/
}

//3个点击事件
//截屏分享
-(void)clickGameOverCameraShare{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    //白光
    UIView *slipview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [slipview setBackgroundColor:[UIColor whiteColor]];
    [[Globel shareGlobel].rootController.view addSubview:slipview];
    [slipview release];
    
    //加入一个不能点击的层
    masklayer = [MaskLayer node];
    [self addChild:masklayer z:100];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.8];
    slipview.alpha = 0;
    [UIView commitAnimations];
    
    [self performSelector:@selector(showShareWin:) withObject:slipview afterDelay:0.9];
    
}

-(void)showShareWin:(UIView *)v{
    [v removeFromSuperview];
    [masklayer removeFromParentAndCleanup:YES];
    
    //获取到了image
    UIImage * outputImage = [AWScreenshot takeAsImage];
    //保存进相册
    UIImageWriteToSavedPhotosAlbum(outputImage, nil, nil, nil);  
    //显示分享
    Share *share = [[Share alloc] initWithNibName:@"Share" bundle:nil];
    [[Globel shareGlobel].rootController presentModalViewController:share animated:YES];
    [share release];
}

//重新开始
-(void)clickNone{
    track();
}
//重新开始
-(void)clickGameOverRestatGame{
    track();
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    [gameassitant cancelAllPerform];
    
    //[self setLevelConfigDate:[NSNumber numberWithBool:NO] key:@"isgameover"];
    //[self setLevelConfigDate:[NSMutableArray array] key:@"archive"];
    
    CCScene *loads = [LoadingScene sceneWithTargetScene:TargetScenes_course];
    [[CCDirector sharedDirector] replaceScene:loads];
}
//返回
-(void)clickGameOverReturn{
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

#pragma mark----生命周期-----
-(void)onExit{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    track();
    instance = nil;
    
    [putDownArray release];
    
    if (lastStepGridsData!=nil) {
        [self releaseLastTempData];
    }
    
    //二维数组回收
    [grids release];
    //回收助手
    [gameassitant release];
        
    [super onExit];
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
