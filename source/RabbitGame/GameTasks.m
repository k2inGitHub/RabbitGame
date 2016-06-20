

#import "GameTasks.h"
#import "EESpriteScaleBtn.h"
#import "WorldMapScene.h"
#import "SoundManagerR.h"
#import "GameKitHelper.h"
#import "Business.h"
#import "Task.h"
#import "Link.h"
#import "GameScene.h"
#import "MyUserAnalyst.h"
#import "MobClick.h"
#import "Configuration.h"
#import "TipAlert.h"
#import "VisibleRect.h"


@implementation GameTasks


//创建影片剪辑
-(void)creatSpriteByFramename:(NSString *)framename px:(float)x py:(float)y{
    track();
    CCSprite *sprite = [CCSprite spriteWithFile:framename];
    sprite.anchorPoint = ccp(0,1);
    sprite.position = ccp(x,y);
    [self addChild:sprite];
}

//创建功能按钮代理函数
-(EESpriteScaleBtn *)creatBtnByFramename:(NSString *)framename px:(float)x py:(float)y sel:(SEL)callback tag:(int)t{
    track();
    EESpriteScaleBtn *sprite = [EESpriteScaleBtn spriteWithFile:framename];
    sprite.tag = t;
//    sprite.anchorPoint = ccp(0,1);
    sprite.position = ccp(x,y);
    [sprite addEETarget:self selector:callback];
    [self addChild:sprite];
    return sprite;
}



- (void)initTasks
{
    float delta = 80;
    for (int i = 1; i <= 3; i++) {
        Task *task = [Task getInitTask:i];
        
        // 图标
        Link *link = [Link createByType:task->targetLinkType andLelve:task->targetLinkLevel];
        link.position = ccp(60, 360 - (i - 1) * delta);
        [self addChild:link];
        
        // 文字
        CCLabelTTF *quote = [CCLabelTTF labelWithString:task->content fontName:@"Helvetica" fontSize:18];
        quote.color = ccBLACK;
        quote.anchorPoint = ccp(0.5,0.5);
        quote.position = ccp(160, 370 - (i - 1) * delta);
        [self addChild:quote];
        
        // 钱
        CCSprite *moneyIco = [CCSprite spriteWithSpriteFrameName:@"ico_money.png"];
        moneyIco.position = ccp(135, 340 - (i - 1) * delta);
        [self addChild:moneyIco];
        
        CCLabelAtlas *coinLabel = [CCLabelAtlas labelWithString:@"0" charMapFile:@"number-ui.png" itemWidth:9 itemHeight:15 startCharMap:'0'];
        coinLabel.anchorPoint = ccp(1,0.5);
        coinLabel.scale = 0.8f;
        coinLabel.position = ccp(190, 340 - (i - 1) * delta);
        [coinLabel setString:[NSString stringWithFormat:@"%d", task->bonusCoin]];
        [self addChild:coinLabel];
        
        CCLabelTTF *plus = [CCLabelTTF labelWithString:@"+" fontName:@"Helvetica" fontSize:16];
        plus.color = ccWHITE;
        plus.anchorPoint = ccp(0,0.5);
        plus.position = ccp(155, 340 - (i - 1) * delta);
        [self addChild:plus];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        
        CCLayerColor *color = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 100) width:640 height:960];
        [self addChild:color];
        
        //背景
        CCSprite *sprite = [CCSprite spriteWithFile:@"tasks_dg_bg.png"];
        sprite.position = ccp(160,260);
        [self addChild:sprite];
        
        //音乐  音效  语音
        isbgmusice = [[[Globel shareGlobel].allDataConfig objectForKey:@"sound_bg"] boolValue];
        
        if (isbgmusice) {
            [self creatBtnByFramename:@"tasks_btn_music_on.png" px:53 py:128 sel:@selector(clickBgMusice) tag:11];
        } else {
            [self creatBtnByFramename:@"tasks_btn_music_off.png" px:53 py:128 sel:@selector(clickBgMusice) tag:11];
        }
                
        //排行榜
//        [self creatBtnByFramename:@"tasks_btn_leader.png" px:190 py:128 sel:@selector(clickGameKit) tag:15];
        
        //免费金币
        [MyUserAnalyst updateOnlineConfig];
        int scoreWall = [MyUserAnalyst getIntFlag:@"Video" defaultValue:0];
//        if (scoreWall > 0 && GeneralOnOff) {
        EESpriteScaleBtn *btn = [self creatBtnByFramename:@"btn_free_tubi.png" px:102 py:70 sel:@selector(getFreeCoin) tag:17];
        btn.alwaysScale = YES;
        btn.tag = 22;
        [self updateCoinBtn];
//        }
        
        //关闭
        [self creatBtnByFramename:@"btn_set_btn_close.png" px:240 py:70 sel:@selector(clickreturn:) tag:17];

        //任务列表
        [self initTasks];
        
    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
}

-(void)videoPlayed:(NSNotification *)notification
{
    [MobClick event:@"Video" label:@"Coin"];
    int VideoCoin = [MyUserAnalyst getIntFlag:@"VideoCoin" defaultValue:100];
    int money = [[[Globel shareGlobel].allDataConfig objectForKey:@"usermoney"] intValue];
    money += VideoCoin;
    [[Globel shareGlobel].allDataConfig setValue:[NSString stringWithFormat:@"%d",money] forKey:@"usermoney"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    TipAlert *alert = [TipAlert createWithTitle:[NSString stringWithFormat:@"恭喜你获得%d金币", VideoCoin]];
    [self addChild:alert z:100];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"last_free_coin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self updateCoinBtn];
}

- (void)updateCoinBtn{
    
    CCNode *node = [self getChildByTag:22];
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"last_free_coin"];
    float freeCoinTime = [HLAnalyst floatValue:@"free_coin_time" defaultValue:60];
    BOOL hide = (date && ([[NSDate date] timeIntervalSinceDate:date] < freeCoinTime)) || [HLAnalyst boolValue:@"free_coin_hide" defaultValue:false];
    if (node) {
        node.visible = !hide;
    }
}

//点击了免费金币
-(void)clickByFreeMoney{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayed:) name:HLInterstitialFinishNotification object:nil];
    [[Business sharedInstance] showVideo];
    //    [[GameScene shareInstance] addScoreWallDialog];
    
    
}

//免费金币
- (void)getFreeCoin{
    [self closeDialog:nil];
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

-(void)closeDialog:(id)sender{
    if (dialog) {
        [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
        [dialog removeFromParentAndCleanup:TRUE];
        dialog = nil;
    }
}

#pragma mark ---点击了返回---
-(void)clickreturn:(id)sender{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    [self removeFromParentAndCleanup:true];
}

//排名
-(void)clickGameKit{
    
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];

    [[GameKitHelper sharedHelper] showLeaderboard];



}


//音乐
-(void)clickBgMusice{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    

    isbgmusice = !isbgmusice;

    [[Globel shareGlobel].allDataConfig setValue:(isbgmusice?@"YES":@"NO")  forKey:@"sound_bg"];
    [[Globel shareGlobel].allDataConfig setValue:(isbgmusice?@"YES":@"NO")  forKey:@"sound_action"];
    
    trace(@"%@",[Globel shareGlobel].allDataConfig);
    
    EESpriteScaleBtn *sprite = (EESpriteScaleBtn *)[self getChildByTag:11];
    if (isbgmusice) {
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage: @"tasks_btn_music_on.png"];
        [sprite setTexture:texture];

    }else {
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage: @"tasks_btn_music_off.png"];
        [sprite setTexture:texture];

    }
}





























@end
