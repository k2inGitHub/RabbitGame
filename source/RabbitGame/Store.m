//
//  Store.m
//  RabbitGame
//
//  Created by pai hong on 12-7-3.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "Store.h"
#import "EESpriteScaleBtn.h"
#import "Buy.h"
#import "GameScene.h"
#import "Link.h"
#import "OpenLevel.h"
#import "SoundManagerR.h"

#import "Business.h"
#import "MyUserAnalyst.h"
#import "MobClick.h"
#import "Configuration.h"
#import "UIAlertView+Blocks.h"
#import "TipAlert.h"
#import "VisibleRect.h"

@implementation Store

-(void)onEnter {
    [super onEnter];
    
    //AdMoGoViewController *mogo = (AdMoGoViewController*)[Globel shareGlobel].rootController;
    //[mogo hideBanner];
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
    CCLabelAtlas *label = [CCLabelAtlas labelWithString:@"234" charMapFile:@"text2.png" itemWidth:7 itemHeight:12 startCharMap:'0'];
    label.anchorPoint = ccp(0.5,0.5);
    label.position = ccp(x,y);
    [self addChild:label];
    return  label;
}


- (id)init
{
    self = [super init];
    if (self) {
        
        CCLayerColor *color = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 100) width:640 height:960];
        [self addChild:color];
        
        
        //标题：金币商城
        [self creatBtnByFramename:@"jb0.png" px:234 py:439 sel:@selector(clickByMoney) tag:13];
        //标题：道具商城
        [self creatSpriteByFramename:@"wz.png" px:15 py:467];
        
        //背景
        CCSprite *sprite = [CCSprite spriteWithFile:@"funcbg.png"];
        sprite.anchorPoint = ccp(0,1);
        sprite.position = ccp(15,415);
        [self addChild:sprite];
        
        //金钱背景框
        //[self creatSpriteByFramename:@"兔币1.png" px:59 py:94];
        
        //金钱
        label_money = [CCLabelAtlas labelWithString:@"" charMapFile:@"number-ui.png" itemWidth:9 itemHeight:15 startCharMap:'0'];
        label_money.anchorPoint = ccp(0.5,0.5);
        label_money.position = ccp(96,70);
        [self addChild:label_money];
        label_money.visible = false;
        label_money.string = [NSString stringWithFormat:@"%d",[self getmoney]];
        //label_money.string = [NSString stringWithFormat:@"%d",10000000];
        

        
        // 打开积分墙
        [MyUserAnalyst updateOnlineConfig];
        int scoreWall = [MyUserAnalyst getIntFlag:@"Video" defaultValue:0];
       if (true) {
            EESpriteScaleBtn *sprite = [EESpriteScaleBtn spriteWithFile:@"btn_free_tubi.png"];
            sprite.tag = 22;
            //    sprite.anchorPoint = ccp(0,1);
            sprite.position = ccp(115,77);
            sprite.alwaysScale = YES;
            [sprite addEETarget:self selector:@selector(getFreeCoin:)];
            [self addChild:sprite];
            [self updateCoinBtn];
       }
        
        //返回
        [self creatBtnByFramename:@"js_back.png" px:246 py:77 sel:@selector(clickreturn2) tag:14];
        
        //物资--------------------------------
        //撤销
        [self creatSpriteByFramename:@"wz_cx.png" px:39 py:186];
        if ([[GameScene shareInstance] isValidChexiaoInStore]) {
            [self creatBtnByFramename:@"buy.png" px:260 py:169 sel:@selector(clickPrevStep) tag:15];
        }else {
            [self creatBtnByFramename:@"buy0.png" px:260 py:169 sel:@selector(clickNone) tag:15];
        }

        //大树
        [self creatSpriteByFramename:@"cq_ds.png" px:41 py:230];
        if ([self getLeftStore:@"dashu"]>0) {
            [self creatBtnByFramename:@"buy.png" px:260 py:214 sel:@selector(clickDashu) tag:16];
        }else {
            [self creatBtnByFramename:@"buy0.png" px:260 py:214 sel:@selector(clickNone) tag:16];
        }
        label_dashu = [self createLabel:140 :156];
        label_dashu.string = [self getStoreNum:@"dashu"];
               
        //萝卜、灌木
        [self creatSpriteByFramename:@"wz_lb.png" px:35 py:274];
        if ([self getLeftStore:@"luobo"]>0) {
            [self creatBtnByFramename:@"buy.png" px:260 py:260 sel:@selector(clickluobo) tag:17];
        }else {
            [self creatBtnByFramename:@"buy0.png" px:260 py:260 sel:@selector(clickNone) tag:17];
        }
        label_luobo = [self createLabel:140 :202];
        label_luobo.string = [self getStoreNum:@"luobo"];
        
        //int levelNum = [Globel shareGlobel].curLevel;
        //if (levelNum==3) {
        /*
            //房屋
            [self creatSpriteByFramename:@"wz_cw.png" px:46 py:266];
            if ([self getLeftStore:@"caowu"]>0) {
                [self creatBtnByFramename:@"buy.png" px:260 py:241 sel:@selector(clickCaowu) tag:18];
            }else {
                [self creatBtnByFramename:@"buy0.png" px:260 py:241 sel:@selector(clickNone) tag:18];
            }
            label_fangwu = [self createLabel:140 :229];
            label_fangwu.string = [self getStoreNum:@"caowu"];
         */
        //}else {
            //萝卜苗、小草
            [self creatSpriteByFramename:@"lbmiao.png" px:37 py:317];
            if ([self getLeftStore:@"xiaocao"]>0) {
                [self creatBtnByFramename:@"buy.png" px:260 py:304 sel:@selector(clickLuobomiao) tag:18];
            }else {
                [self creatBtnByFramename:@"buy0.png" px:260 py:304 sel:@selector(clickNone) tag:18];
            }
            label_luobomiao = [self createLabel:140 :248];
            label_luobomiao.string = [self getStoreNum:@"xiaocao"];
       // }
        
        
        //炸弹
        [self creatSpriteByFramename:@"wz_zd.png" px:39 py:361];
        if ([self getLeftStore:@"bom"]>0) {
            [self creatBtnByFramename:@"buy.png" px:260 py:346 sel:@selector(clickBom) tag:19];
        }else {
            [self creatBtnByFramename:@"buy0.png" px:260 py:346 sel:@selector(clickNone) tag:19];
        }
        label_bom = [self createLabel:140 :293];
        label_bom.string = [self getStoreNum:@"bom"];
        
        //彩虹球
        [self creatSpriteByFramename:@"cq_chqiu.png" px:37 py:412];
        if ([self getLeftStore:@"colorball"]>0) {
            [self creatBtnByFramename:@"buy.png" px:260 py:394 sel:@selector(clickColorBall) tag:20];
        }else {
            [self creatBtnByFramename:@"buy0.png" px:260 py:394 sel:@selector(clickNone) tag:20];
        }
        label_colorball = [self createLabel:140 :337];
        label_colorball.string = [self getStoreNum:@"colorball"];
        
        //步骤
//        [self creatSpriteByFramename:@"wz_bshu.png" px:35 py:412];
//        [self creatBtnByFramename:@"buy.png" px:260 py:394 sel:@selector(clickBuystep) tag:21];
        
        
        
        
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


#pragma mark ---库存控制---
//得到库存的数量int
-(int)getLeftStore:(NSString *)type{
    NSString *levelstr = [NSString stringWithFormat:@"level_%d",[Globel shareGlobel].curLevel];
    return  [[[[[Globel shareGlobel].allDataConfig objectForKey:levelstr] objectForKey:@"store"] objectForKey:type] intValue];
}
//得到库存的数量string    
-(NSString *)getStoreNum:(NSString *)type{
    int leftnum = [self getLeftStore:type];
    return [NSString stringWithFormat:@"%d",leftnum];
}
//检测库存量
-(BOOL)checkLeftStore:(NSString *)type{
    int leftnum = [self getLeftStore:type];
    if (leftnum<=0) {
        return NO;
    }else {
        return YES;
    }
}
//消耗了一个库存
-(void)removeOneStore:(NSString *)type{
    int leftnum = [self getLeftStore:type];
    leftnum--;
    
    NSString *levelstr = [NSString stringWithFormat:@"level_%d",[Globel shareGlobel].curLevel];
    [[[[Globel shareGlobel].allDataConfig objectForKey:levelstr] objectForKey:@"store"] setValue:[NSString stringWithFormat:@"%d",leftnum] forKey:type];
}


#pragma mark ---金币控制---
-(void)refeshMoney{
    label_money.string = [NSString stringWithFormat:@"%d",[self getmoney]];
}
//点击了购买金币
-(void)clickByMoney{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    //刷新GameScene的步骤和分数
    [[GameScene shareInstance] refreshMoneyAndStep];
    //移出
    [self removeFromParentAndCleanup:YES];
    [[GameScene shareInstance] addStorePage];
}
//点击返回
-(void)clickreturn2{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    //刷新GameScene的步骤和分数
    [[GameScene shareInstance] refreshMoneyAndStep];
    //移出
    [self removeFromParentAndCleanup:YES];
}
-(void)clickreturn{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //刷新GameScene的步骤和分数
    [[GameScene shareInstance] refreshMoneyAndStep];
    //移出
    [self removeFromParentAndCleanup:YES];
}

//购买什么

-(void)clickNone{
}

-(void)clickPrevStep{
    
    if (![self checkMoney:50])return;
    
    [self add_puls_money:-50];
    
    [[GameScene shareInstance] recoverLastTempData];
    
    [[SoundManagerR shareInstance] playSound:@"购买成功.wav" type:Sound_Type_Action];
    
    [self clickreturn];
}

-(int)getmoney{
    int money = [[[Globel shareGlobel].allDataConfig objectForKey:@"usermoney"] intValue];
    
    return money;
}

-(void)add_puls_money:(int)num{
    int money = [self getmoney];
    
    money += num;
    
    [[Globel shareGlobel].allDataConfig setValue:[NSString stringWithFormat:@"%d",money] forKey:@"usermoney"];
    
    label_money.string = [NSString stringWithFormat:@"%d",money];

}

-(BOOL)checkMoney:(int)money{
    int usermoney = [self getmoney];
    if (usermoney<money) {
        
        [[GameScene shareInstance] addGoStoreDialog];
        
        return NO;
    }
    return YES;
}


//是否开启第3关
-(void)checkOpenLevel3{
    //是否打开第3关
    if ([self getLeftStore:@"dashu"] <= 0 && [self getLeftStore:@"luobo"] <= 0 && [self getLeftStore:@"xiaocao"] <= 0) {
        [[OpenLevel shareInstance] openLevel3];//打开第3关
    }
}


//购买步数
-(void)clickBuystep{
    if (![self checkMoney:100])return;
    
    int step = [[[Globel shareGlobel].allDataConfig objectForKey:@"step"] intValue];
    step += 200;
    [[Globel shareGlobel].allDataConfig setValue:[NSString stringWithFormat:@"%d",step] forKey:@"step"];
    
    [self add_puls_money:-100];
    
    [self clickreturn];
    [[SoundManagerR shareInstance] playSound:@"购买成功.wav" type:Sound_Type_Action];
}
//购买大树
-(void)clickDashu{
    if (![self checkMoney:50])return;
    if (![self checkLeftStore:@"dashu"])return;
    
    [self add_puls_money:-50];
    [self removeOneStore:@"dashu"];
    
    //是否开启第3关
    [self checkOpenLevel3];
    
    Link *link = [Link createByType:Link_Type_House andLelve:3];
    [[GameScene shareInstance] insertNewLinkToGameNextSeat:link];
    
    [self clickreturn];
    
    
    [[SoundManagerR shareInstance] playSound:@"购买成功.wav" type:Sound_Type_Action];
}
//购买灌木
-(void)clickluobo{
    if (![self checkMoney:20])return;
    if (![self checkLeftStore:@"luobo"])return;
    
    [self add_puls_money:-20];
    [self removeOneStore:@"luobo"];
    
    //是否开启第3关
    [self checkOpenLevel3];
    
    Link *link = [Link createByType:Link_Type_House andLelve:2];
    [[GameScene shareInstance] insertNewLinkToGameNextSeat:link];
    
    [self clickreturn];
    
    
    [[SoundManagerR shareInstance] playSound:@"购买成功.wav" type:Sound_Type_Action];
}
//购买草屋
-(void)clickCaowu{
    if (![self checkMoney:50])return;
    if (![self checkLeftStore:@"caowu"])return;
    
    [self add_puls_money:-50];
    [self removeOneStore:@"caowu"];
    
    Link *link = [Link createByType:Link_Type_House andLelve:4];
    [[GameScene shareInstance] insertNewLinkToGameNextSeat:link];
    
    [self clickreturn];
    
    [[SoundManagerR shareInstance] playSound:@"购买成功.wav" type:Sound_Type_Action];
}
//购买萝卜苗
-(void)clickLuobomiao{
    if (![self checkMoney:10])return;
    if (![self checkLeftStore:@"xiaocao"])return;
    
    [self add_puls_money:-10];
    [self removeOneStore:@"xiaocao"];
    
    //是否开启第3关
    [self checkOpenLevel3];
    
    Link *link = [Link createByType:Link_Type_House andLelve:1];
    [[GameScene shareInstance] insertNewLinkToGameNextSeat:link];
    
    [self clickreturn];
    
    [[SoundManagerR shareInstance] playSound:@"购买成功.wav" type:Sound_Type_Action];
}
//购买炸弹
-(void)clickBom{
    if (![self checkMoney:100])return;
    if (![self checkLeftStore:@"bom"])return;
    
    [self add_puls_money:-100];
    [self removeOneStore:@"bom"];
    
    
    Link *link = [Link createByType:Link_Type_Tool andLelve:2];
    [[GameScene shareInstance] insertNewLinkToGameNextSeat:link];
    
    [self clickreturn];
    
    [[SoundManagerR shareInstance] playSound:@"购买成功.wav" type:Sound_Type_Action];
}
//购买彩虹球
-(void)clickColorBall{
    if (![self checkMoney:150])return;
    if (![self checkLeftStore:@"colorball"])return;
    
    [self add_puls_money:-150];
    [self removeOneStore:@"colorball"];
    
    
    Link *link = [Link createByType:Link_Type_Tool andLelve:1];
    [[GameScene shareInstance] insertNewLinkToGameNextSeat:link];
    
    [self clickreturn];
    
    [[SoundManagerR shareInstance] playSound:@"购买成功.wav" type:Sound_Type_Action];
}


-(void)videoPlayed:(NSNotification *)notification
{
    [MobClick event:@"Video" label:@"Coin"];
    int VideoCoin = [MyUserAnalyst getIntFlag:@"VideoCoin" defaultValue:100];
    [self add_puls_money:VideoCoin];
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







@end
