//
//  BeginScene.m
//  RabbitGame
//
//  Created by pai hong on 12-6-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BeginScene.h"
#import "EESpriteScaleBtn.h"
#import "WorldMapScene.h"
#import "LoadingScene.h"
#import "EncryptionConfig.h"
#import "SoundManagerR.h"
#import "SimpleAudioEngine.h"
#import "MyUserAnalyst.h"
#import "MobClick.h"
#import "Business.h"
#import "Configuration.h"

#import "GameHelp.h"

//edited, 0831
#import "GameScene.h"

@implementation BeginScene

+(CCScene *)scene{
    CCScene *s = [CCScene node];
    
    BeginScene *m = [BeginScene node];
    [s addChild:m];
    
    return s;
}

-(void)updateInfo{
    
    [self unscheduleAllSelectors];
    
    //初始化数据   得到游戏配置信息
    NSMutableDictionary *gameconfig = [[EncryptionConfig shareInstance] getConfig];
    [Globel shareGlobel].allDataConfig = [gameconfig retain];
    trace(@"%@",[Globel shareGlobel].allDataConfig);
    
    //初始化   关卡数据
    NSString *leveldatepath = [[NSBundle mainBundle] pathForResource:@"levelfeature" ofType:@"plist"];
    [Globel shareGlobel].levelFeature = [[NSMutableDictionary alloc] initWithContentsOfFile:leveldatepath];
    
    
    trace(@"%@",[Globel shareGlobel].allDataConfig);
    trace(@"%@",[Globel shareGlobel].levelFeature);
    
}

- (void)updateUI {
    //开始按钮
    // 1.1 terababy
    // 增加逻辑：判断是否存档，如果存档，使用继续按钮，否则使用开始按钮
    //读取存档数据
    NSString *levelstr = [NSString stringWithFormat:@"level_%d",1];
    NSMutableArray *historygrids = [[[Globel shareGlobel].allDataConfig objectForKey:levelstr] objectForKey:@"archive"];
    EESpriteScaleBtn *startBtn = NULL;
    if (historygrids==nil || [historygrids count] == 0) {
        //说明是第一次玩
        startBtn = [EESpriteScaleBtn spriteWithFile:@"begin_startbtn.png"];
    }else {
        //说明存在存档数据
        startBtn = [EESpriteScaleBtn spriteWithFile:@"begin_continuebtn.png"];
    }
    [self addChild:startBtn];
    [startBtn addEETarget:self selector:@selector(startGame:)];
    startBtn.position = ccp(SSSW*0.5,SSSH*0.09);
    
    
    
    //分数背景
    CCSprite *hiScorebg = [CCSprite spriteWithFile:@"beginhightscorebg.png"];
    hiScorebg.position = ccp(SSSW*0.35,SSSH*0.20);
    [self addChild:hiScorebg];
    
    
    //分数
    NSString *highestscore = [NSString stringWithFormat:@"%d",[self getHightestScore]];
    CCLabelAtlas *score = [CCLabelAtlas labelWithString:highestscore charMapFile:@"over_number_big.png" itemWidth:20 itemHeight:30 startCharMap:'0'];
    score.position = ccp(SSSW*0.66,SSSH*0.20);
    score.anchorPoint = ccp(0.5,0.5);
    [self addChild:score];
}

-(void) onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    int history = [self getHightestScore];
    if (history > 0) {
        int alpha = [MyUserAnalyst getIntFlag:@"IntersMain" defaultValue:0];
        int idx = arc4random() % 100;
        if (idx < alpha && GeneralOnOff) {
            [MobClick event:@"Interstitial" label:@"Main"];
            [[Business sharedInstance] performSelector:@selector(showHalfBanner) withObject:nil afterDelay:1.0f];
        }
    }
}

- (id)init
{
    [[Business sharedInstance] hideAdvertise];
    
    self = [super init];
    if (self) {        
        [CCSpriteFrameCache purgeSharedSpriteFrameCache];
        
        
        //背景
        CCSprite *bg = [CCSprite spriteWithFile:@"begin_bg.png"];
        [self addChild:bg];
        bg.position = ccp(SSSW*0.5,SSSH*0.5);
        [GameHelp autoscale:bg];
        
        [self updateInfo];
        [self addDailyDialog];
        
        
        // 推荐弹窗
        [MyUserAnalyst updateOnlineConfig];
        int scoreWall = [MyUserAnalyst getIntFlag:@"ScoreWall" defaultValue:0];
        
        
        if (scoreWall>0) {
            int  enterGameCount = [(NSNumber*)[[NSUserDefaults standardUserDefaults]objectForKey:@"enterGameCount"]intValue ];
            int  isFirst = [(NSNumber*)[[NSUserDefaults standardUserDefaults]objectForKey:@"isFirst"]intValue ];
            enterGameCount++;
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:enterGameCount] forKey:@"enterGameCount"];
            NSString *valueText = [MobClick getConfigParams:@"content"];
            NSString *valueTextBefor=  [[NSUserDefaults standardUserDefaults]objectForKey:@"cotentOnline"];
            if (valueTextBefor==nil) {
                [[NSUserDefaults standardUserDefaults] setObject:valueText forKey:@"cotentOnline"];
            }
            if (enterGameCount==3&&isFirst==0) {
                
                isFirst++;
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:isFirst] forKey:@"isFirst"];
                
                NSDate *nowdate = [NSDate date];
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd"];
                
                NSString *newdatestr = [df stringFromDate:nowdate];
                
                [MobClick event:@"UIAlertViewApperCount" label:newdatestr];
                [[NSUserDefaults standardUserDefaults] setObject:valueText forKey:@"cotentOnline"];
                UIAlertView *mysalealert=[[UIAlertView alloc]initWithTitle:@"精品推荐！" message:valueText delegate:self cancelButtonTitle:@"下次吧" otherButtonTitles:@"走你",nil];
                
                [mysalealert show];
                [mysalealert release];
                
                
                
            }else{
                if (![valueText isEqualToString:valueTextBefor]&&isFirst!=0) {
                    
                    NSDate *nowdate = [NSDate date];
                    
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    [df setDateFormat:@"yyyy-MM-dd"];
                    
                    NSString *newdatestr = [df stringFromDate:nowdate];
                    [[NSUserDefaults standardUserDefaults] setObject:valueText forKey:@"cotentOnline"];
                    [MobClick event:@"UIAlertViewApperCount" label:newdatestr];
                    UIAlertView *mysalealert=[[UIAlertView alloc]initWithTitle:@"精品推荐！" message:valueText delegate:self cancelButtonTitle:@"下次吧" otherButtonTitles:@"走你",nil];
                    
                    [mysalealert show];
                    [mysalealert release];
                    
                }
                
                
            }
        }
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    switch (buttonIndex) {
        case 0:
        {
            break;
        }case 1:
        {
            NSDate *nowdate = [NSDate date];
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd"];
            
            NSString *newdatestr = [df stringFromDate:nowdate];
            NSString *valueText2 = [MobClick getConfigParams:adress];
            
            [MobClick event:@"ClickOk" label:newdatestr];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:valueText2]];
            break;
        }
            
        default:
            
            break;
            
            
            
    }
    
}



//得到最高分
-(int)getHightestScore{
    int all = 0;
    for (int i=1; i<=8; i++) {
        NSString *levelname = [NSString stringWithFormat:@"level_%d",i];
        NSDictionary *diction = [[Globel shareGlobel].allDataConfig objectForKey:levelname];
        int cur = [[diction objectForKey:@"currentscore"] intValue];
        int hi = [[diction objectForKey:@"highestscore"] intValue];
        all = all>=cur?all:cur;
        all = all>=hi?all:hi;
    }
    return all;
}

-(void)startGame:(id)sender{
    track();
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    [self schedule:@selector(go) interval:0.4];
}


//游戏开始
-(void)go{
    
    track();
    
    BOOL isfirst = [[[Globel shareGlobel].allDataConfig valueForKey:@"firstEnterApp"] boolValue];
    
    if (isfirst) {
        [[Globel shareGlobel].allDataConfig setValue:[NSNumber numberWithBool:NO] forKey:@"firstEnterApp"];
        [Globel shareGlobel].isInCourse = YES;
        [[EncryptionConfig shareInstance] saveConfig:[Globel shareGlobel].allDataConfig];
        [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
    }else {
        [Globel shareGlobel].curLevel = 1;
        [Globel shareGlobel].isInCourse = NO;
        [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
    }
}



//每日奖励

+(NSString*)getFullDateCurrent {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateNow = [NSDate date];
    NSString *strNow = [df stringFromDate:dateNow];
    return strNow;
}

+(NSDate*)convertDate:(NSString*)strDate {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [df dateFromString:strDate];
    return date;
}

+(int)intervalDate:(NSDate*)date1 date2:(NSDate*)date2 {
    int nInterval = [date1 timeIntervalSinceDate:date2];
    int nDate = nInterval / 3600 / 24;
    return nDate;
}

// 记住领取奖励的日期
-(void)rememberDaily:(int)daily{
    
    NSString *strCurrent = [BeginScene getFullDateCurrent];
    [[Globel shareGlobel].allDataConfig setValue:[NSString stringWithFormat:@"%d",daily] forKey:@"userdaily"];
    [[Globel shareGlobel].allDataConfig setValue:strCurrent forKey:@"userdailydate"];
    
    int coins[8] = {0, 25, 35, 45, 65, 85, 100, 150};
    
    int money = [[[Globel shareGlobel].allDataConfig objectForKey:@"usermoney"] intValue];
    money += coins[daily];
    [[Globel shareGlobel].allDataConfig setValue:[NSString stringWithFormat:@"%d",money] forKey:@"usermoney"];
    
    [[EncryptionConfig shareInstance] saveConfig:[Globel shareGlobel].allDataConfig];
}


-(void)lingDaily:(id)sender{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    [dialog removeFromParentAndCleanup:TRUE];
    dialog = nil;
    
    [self rememberDaily:nDaily];
    [self updateUI];
}

// 添加每日游戏奖励界面元素，按第1天、第2天...第七天
- (void)addDailyStatus:(int)no now:(int)now {
    
    // 图标
    NSString *fnIcon = NULL;
    if (no > now) {
        fnIcon = [NSString stringWithFormat:@"d_icon%dg.png", no];
    } else {
        fnIcon = [NSString stringWithFormat:@"d_icon%d.png", no];
    }
    CCSprite *spIcon = [CCSprite spriteWithFile:fnIcon];
    spIcon.position = ccp3(35, 320 - 45 * (no - 1));
    [dialog addChild:spIcon];
    
    // 领取状态
    CCSprite *spLing = NULL;
    if (no > now) {
        
        spLing = [CCSprite spriteWithFile:@"d_lingg.png"];
    } else if (no == now){
        
        EESpriteScaleBtn *bnLing = [EESpriteScaleBtn spriteWithFile:@"d_ling.png"];
        [bnLing addEETarget:self selector:@selector(lingDaily:)];
        spLing = bnLing;
    } else {
        
        spLing = [CCSprite spriteWithFile:@"d_linged.png"];
    }
    spLing.position = ccp3(250, 320 - 45 * (no - 1));
    [dialog addChild:spLing];
}

// 添加每日游戏奖励对话框
- (void)addDailyDialog {
    
    nDaily = 1;
    
    NSString *strLastdate = [[Globel shareGlobel].allDataConfig objectForKey:@"userdailydate"];
    NSDate *datCurrent = [NSDate date];
    
    int interval = 0;
    if (strLastdate) {
        NSDate *datLast = [BeginScene convertDate:strLastdate];
        interval = [BeginScene intervalDate:datCurrent date2:datLast];
        if (interval == 0) {
            
            [self updateUI];
            return;
            
        } else if (interval == 1){
            
            NSObject *obDaily = [[Globel shareGlobel].allDataConfig objectForKey:@"userdaily"];
            if (obDaily) {
                nDaily = [(NSString*)obDaily intValue] + 1;
                if (nDaily == 8) {
                    nDaily = 1;
                }
            }
            
        } else if (interval > 1){
            
            // 超过两天登陆，从第一天开始
            nDaily = 1;
            
        } else {
            
            nDaily = 0;
            [self rememberDaily:nDaily];
            [self updateUI];
            
            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"警告"
                                                                 message:@"您可能通过修改系统日期领取奖励，警告一次，下次将会清零!"
                                                                delegate:nil
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"确定", nil] autorelease];
            [alertView show];
            return;
        }
    }
    
    
    
    if (dialog == nil) {
        dialog = [EEMaskSprite spriteWithFile:@"d_bg.png"];
        dialog.position = ccp2(160,240);
        [self addChild:dialog z:1000];
        
        for (int i = 1; i <= 7; i ++) {
            [self addDailyStatus:i now:nDaily];
        }
        
        int money = [[[Globel shareGlobel].allDataConfig objectForKey:@"usermoney"] intValue];
        CCLabelAtlas *labMoney = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d", money] charMapFile:@"number-ui.png" itemWidth:9 itemHeight:15 startCharMap:'0'];
        labMoney.anchorPoint = ccp(0,0.5);
        labMoney.position = ccp3(230, 365);
        [dialog addChild:labMoney];
    }
}















@end
