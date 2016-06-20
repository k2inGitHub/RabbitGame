//
//  Buy.m
//  RabbitGame
//
//  Created by pai hong on 12-7-4.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "Buy.h"
#import "EESpriteScaleBtn.h"
#import "Store.h"
#import "SoundManagerR.h"
#import "GameScene.h"

#import "InAppPurchaseManager.h"
#import "Reachability.h"

#import "Business.h"
#import "MyUserAnalyst.h"
#import "Configuration.h"
#import "MobClick.h"
#import "TipAlert.h"
#import "VisibleRect.h"

#define kProductsLoadedNotification         @"ProductsLoaded"
#define kProductPurchasedNotification       @"ProductPurchased"
#define kProductPurchaseFailedNotification  @"ProductPurchaseFailed"

@implementation Buy

@synthesize delegate;
@synthesize hud = _hud;



- (void)initInAppRage
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];	
    NetworkStatus netStatus = [reach currentReachabilityStatus];    
    if (netStatus == NotReachable) {        
        NSLog(@"No internet connection!");  
        [MBProgressHUD hideHUDForView:
         [UIApplication sharedApplication].keyWindow animated:YES];
        self.hud = nil;
    }
    else {
        [[InAppPurchaseManager sharedInAppManager] loadStore];
    }
}


- (void)productPurchased:(NSNotification *)notification {
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSString *productIdentifier = (NSString *) notification.object;
    NSLog(@"cancel:%@",productIdentifier);
    
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    self.hud = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //    // 贴已买标签
    if ([productIdentifier hasPrefix:ThreeHundred]) {
        
        [self add_cut_money:300];
    }else if ([productIdentifier hasPrefix:SevenHundred]) {
        [self add_cut_money:700];
        
    }else if ([productIdentifier hasPrefix:TwelveHundred]) {
        
        [self add_cut_money:1200];
    }else if ([productIdentifier hasPrefix:EighteenHundred]) {
        
        [self add_cut_money:1800];
    }
    else if ([productIdentifier hasPrefix:TwentyFiveHundred]) {
        [self add_cut_money:2500];
        
        
    }else if ([productIdentifier hasPrefix:ThirtyFiveHundred]) {
        [self add_cut_money:3500];
        
    }else if ([productIdentifier hasPrefix:TenThousand]) {
        
        [self add_cut_money:10000];
    }
    
    
    
}

- (void)productPurchaseFailed:(NSNotification *)notification {
    
    [MBProgressHUD hideHUDForView: [UIApplication sharedApplication].keyWindow animated:YES];
    self.hud = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;    
    if (transaction.error.code != SKErrorPaymentCancelled) {    
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error!" 
                                                         message:transaction.error.localizedDescription 
                                                        delegate:nil 
                                               cancelButtonTitle:nil 
                                               otherButtonTitles:@"OK", nil] autorelease];
        [alert show];
    }
    
}

- (void)productsLoaded:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark MBProgressHUD

- (void)showHUD
{
    self.hud = [MBProgressHUD showHUDAddedToWindow:
                [UIApplication sharedApplication].keyWindow animated:YES];
    _hud.labelText = @"waiting...";
    //    [self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];//TODO: 如果有问题打开注释
}

- (void)dismissHUD:(id)arg
{
    [MBProgressHUD hideHUDForView:
     [UIApplication sharedApplication].keyWindow animated:YES];
    self.hud = nil;
}

- (void)timeout:(id)arg
{
    _hud.labelText = @"Timeout!";
    _hud.detailsLabelText = @"Please try again later.";
	_hud.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:2.0];
    
}





//创建影片剪辑
-(void)creatSpriteByFramename:(NSString *)framename px:(float)x py:(float)y{
    track();
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:framename];
    sprite.anchorPoint = ccp(0,1);
    sprite.position = ccp(x,y);
    [self addChild:sprite];
}

//创建功能按钮代理函数
-(void)creatBtnByFramename:(NSString *)framename px:(float)x py:(float)y sel:(SEL)callback tag:(int)t{
    track();
    EESpriteScaleBtn *sprite = [EESpriteScaleBtn spriteWithSpriteFrameName:framename];
    sprite.tag = t;
    //    sprite.anchorPoint = ccp(0,1);
    sprite.position = ccp(x,y);
    [sprite addEETarget:self selector:callback];
    [self addChild:sprite];
}

-(CCLabelAtlas *)createLabel:(float)x :(float)y{
    CCLabelAtlas *label = [CCLabelAtlas labelWithString:@"0" charMapFile:@"text1.png" itemWidth:16 itemHeight:25 startCharMap:'0'];
    label.anchorPoint = ccp(0.5,0.5);
    label.position = ccp(x,y);
    [self addChild:label];
    return  label;
}


-(int)getmoney{
    int money = [[[Globel shareGlobel].allDataConfig objectForKey:@"usermoney"] intValue];
    
    return money;
}

- (id)init
{
    self = [super init];
    if (self) {
        CCLayerColor *color = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 100) width:640 height:960];
        [self addChild:color];
        
        
        //标题：金币商城
        [self creatSpriteByFramename:@"jb.png" px:164 py:466];
        //标题：道具商城
        [self creatBtnByFramename:@"wz0.png" px:85 py:440 sel:@selector(clickByMoney) tag:13];
        
        //背景
        CCSprite *sprite = [CCSprite spriteWithFile:@"funcbg.png"];
        sprite.anchorPoint = ccp(0,1);
        sprite.position = ccp(15,415);
        [self addChild:sprite];
        
        //金钱背景框
        //[self creatSpriteByFramename:@"兔币1.png" px:59 py:94];
        
        //金钱数
        label_money = [CCLabelAtlas labelWithString:@"" charMapFile:@"number-ui.png" itemWidth:9 itemHeight:15 startCharMap:'0'];
        label_money.anchorPoint = ccp(0.5,0.5);
        label_money.position = ccp(96,270);
        [self addChild:label_money z:2];
        label_money.visible = false;
        label_money.string = [NSString stringWithFormat:@"%d",[self getmoney]];
        
        
        // 打开积分墙
        [MyUserAnalyst updateOnlineConfig];
        int scoreWall = [MyUserAnalyst getIntFlag:@"Video" defaultValue:0];
        //if (scoreWall == 5) {
        if (true) {
            EESpriteScaleBtn *sprite = [EESpriteScaleBtn spriteWithFile:@"btn_free_tubi.png"];
            sprite.alwaysScale = YES;
            sprite.tag = 22;
            //    sprite.anchorPoint = ccp(0,1);
            sprite.position = ccp(115,77);
            [sprite addEETarget:self selector:@selector(getFreeCoin:)];
            [self addChild:sprite];
            [self updateCoinBtn];
        }
        
        //返回
        [self creatBtnByFramename:@"js_back.png" px:246 py:77 sel:@selector(clickreturn) tag:14];
        
//        物资
//        撤销
//        [self creatSpriteByFramename:@"jb_10000.png" px:24 py:141];
//        [self creatBtnByFramename:@"buy.png" px:260 py:124 sel:@selector(click10000) tag:15];
//        
//        //大树
//        [self creatSpriteByFramename:@"jb_3500.png" px:31 py:185];
//        [self creatBtnByFramename:@"buy.png" px:260 py:169 sel:@selector(click3500) tag:16];
//        
//        
//        //萝卜
//        [self creatSpriteByFramename:@"jb_2500.png" px:36 py:231];
//        [self creatBtnByFramename:@"buy.png" px:260 py:214 sel:@selector(click2500) tag:17];
//
//        
//        //萝卜苗
//        [self creatSpriteByFramename:@"jb_1800.png" px:40 py:276];
//        [self creatBtnByFramename:@"buy.png" px:260 py:262 sel:@selector(click1800) tag:18];
//
//        
//        //炸弹
//        [self creatSpriteByFramename:@"jb_1200.png" px:33 py:317];
//        [self creatBtnByFramename:@"buy.png" px:260 py:304 sel:@selector(click1200) tag:19];
//
//        
//        //彩虹球
//        [self creatSpriteByFramename:@"jb_700.png" px:31 py:359];
//        [self creatBtnByFramename:@"buy.png" px:260 py:346 sel:@selector(click700) tag:20];

        
        //步骤
        [self creatSpriteByFramename:@"jb_300.png" px:47 py:412];
        [self creatBtnByFramename:@"buy.png" px:260 py:394 sel:@selector(click300) tag:21];

        
        
        
        int levelNum = [Globel shareGlobel].curLevel;
        if (levelNum==3) {
            
        }
        
        
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
    return self;
}


//加钱
-(void)add_cut_money:(int)num{
    int money = [self getmoney];
    money += num;
    [[Globel shareGlobel].allDataConfig setValue:[NSString stringWithFormat:@"%d",money] forKey:@"usermoney"];
    //刷新金钱显示
    label_money.string = [NSString stringWithFormat:@"%d",money];
    //刷新商店里面的金钱显示
    [(GameScene *)delegate refreshMoneyAndStep];
}


#pragma mark ---下面是点击了购买的按钮----
-(void)click300{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    
    [self initInAppRage];
    [[InAppPurchaseManager sharedInAppManager] purchaseModel:300];
    [self showHUD];
    
}
-(void)click700{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    
    [self initInAppRage];
    [[InAppPurchaseManager sharedInAppManager] purchaseModel:700];
    [self showHUD];
    
}

-(void)click1200{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    
    [self initInAppRage];
    [[InAppPurchaseManager sharedInAppManager] purchaseModel:1200];
    [self showHUD];
    
}

-(void)click1800{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    
    [self initInAppRage];
    [[InAppPurchaseManager sharedInAppManager] purchaseModel:1800 ];
    [self showHUD];
    
}

-(void)click2500{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    
    [self initInAppRage];
    [[InAppPurchaseManager sharedInAppManager] purchaseModel:2500 ];
    [self showHUD];
    
}

-(void)click3500{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    
    [self initInAppRage];
    [[InAppPurchaseManager sharedInAppManager] purchaseModel:3500 ];
    [self showHUD];
    
}

-(void)click10000{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    
    [self initInAppRage];
    [[InAppPurchaseManager sharedInAppManager] purchaseModel:10000 ];
    [self showHUD];
    
}

-(void)clickByMoney{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    //刷新GameScene的步骤和分数
    [[GameScene shareInstance] refreshMoneyAndStep];
    //移出
    [self removeFromParentAndCleanup:YES];
    [[GameScene shareInstance] addToolPage];
}

-(void)videoPlayed:(NSNotification *)notification
{
    [MobClick event:@"Video" label:@"Coin"];
    int VideoCoin = [MyUserAnalyst getIntFlag:@"VideoCoin" defaultValue:100];
    [self add_cut_money:VideoCoin];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    TipAlert *alert = [TipAlert createWithTitle:[NSString stringWithFormat:@"恭喜你获得%d金币", VideoCoin]];
    [self addChild:alert z:100];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"last_free_coin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self updateCoinBtn];
}

//点击了免费金币
-(void)clickByFreeMoney{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayed:) name:HLInterstitialFinishNotification object:nil];
    [[Business sharedInstance] showVideo];
    //    [[GameScene shareInstance] addScoreWallDialog];
    
    
    
    
}

-(void)closeDialog:(id)sender{
    if (dialog) {
        [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
        [dialog removeFromParentAndCleanup:TRUE];
        dialog = nil;
    }
}

- (void)getFreeCoin:(id)sender{
    [self closeDialog:sender];
    if([HLAnalyst boolValue:@"show_ad_tip"]) {
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

- (void)updateCoinBtn{
    
    CCNode *node = [self getChildByTag:22];
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"last_free_coin"];
    float freeCoinTime = [HLAnalyst floatValue:@"free_coin_time" defaultValue:60];
    BOOL hide = date && ([[NSDate date] timeIntervalSinceDate:date] < freeCoinTime);
    if (node) {
        node.visible = !hide;
    }
}

#pragma mark ---     返回      ----
//返回
-(void)clickreturn{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    [self removeFromParentAndCleanup:YES];
}
@end
