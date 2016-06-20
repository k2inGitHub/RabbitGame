//
//  GameDayPrize.m
//  RabbitGame
//
//  Created by pai hong on 12-7-11.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "GameDayPrize.h"
#import "EESpriteScaleBtn.h"
#import "WorldMapScene.h"
#import "SoundManagerR.h"


@implementation GameDayPrize



//创建影片剪辑
-(void)creatSpriteByFramename:(NSString *)framename px:(float)x py:(float)y{
    track();
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:framename];
    sprite.anchorPoint = ccp(0,1);
    sprite.position = ccp(x,y);
    [self addChild:sprite];
}

//创建影片剪辑
-(void)creatSpriteByFramename:(NSString *)framename px:(float)x py:(float)y alpha:(float)op{
    track();
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:framename];
    sprite.anchorPoint = ccp(0,1);
    sprite.position = ccp(x,y);
    sprite.opacity = op;
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
    CCLabelAtlas *label = [CCLabelAtlas labelWithString:@"234" charMapFile:@"text1.png" itemWidth:16 itemHeight:25 startCharMap:'0'];
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
        
    }
    return self;
}

-(void)insertNeed{
    
    //背景
    CCSprite *sprite = [CCSprite spriteWithFile:@"funcbg.png"];
    sprite.anchorPoint = ccp(0,1);
    sprite.position = ccp(3,475);
    [self addChild:sprite];
    
    //文字  物资商店
    [self creatSpriteByFramename:@"每日奖励.png" px:18 py:462];
    
    //金钱背景框
    [self creatSpriteByFramename:@"topbg_money.png" px:154 py:459];
    
    //金钱
    label_money = [self createLabel:225 :444];
    label_money.string = [NSString stringWithFormat:@"%d",[self getmoney]];
    
    //领取 返回
    [self creatBtnByFramename:@"领取.png" px:160 py:31 sel:@selector(clickGetMoney:) tag:14];
    
    //物资
    //撤销
    [self creatSpriteByFramename:@"第一天.png" px:16 py:420];
    [self creatSpriteByFramename:@"第二天.png" px:16 py:369];
    [self creatSpriteByFramename:@"第三天.png" px:16 py:317];
    [self creatSpriteByFramename:@"第四天.png" px:16 py:266];
    [self creatSpriteByFramename:@"第五天.png" px:16 py:214];
    [self creatSpriteByFramename:@"第六天.png" px:16 py:162];
    [self creatSpriteByFramename:@"第七天.png" px:16 py:123];
    
    int b[] = {410,359,308,256,207,152,102};
    
    for (int a=0; a<dayNum; a++) {
        [self creatSpriteByFramename:@"彩虹球.png" px:34 py:b[a]];
    }
    if (dayNum<7) {
        [self creatSpriteByFramename:@"彩虹球.png" px:34 py:b[dayNum] alpha:100];
    }
    
    /*
    [self creatSpriteByFramename:@"彩虹球.png" px:34 py:410];
    [self creatSpriteByFramename:@"彩虹球.png" px:34 py:359];
    [self creatSpriteByFramename:@"彩虹球.png" px:34 py:308];
    [self creatSpriteByFramename:@"彩虹球.png" px:34 py:256];
    [self creatSpriteByFramename:@"彩虹球.png" px:34 py:207];
    [self creatSpriteByFramename:@"彩虹球.png" px:34 py:152];
    [self creatSpriteByFramename:@"彩虹球.png" px:34 py:102];*/
    
}

#pragma mark ---点击了返回---
-(void)clickGetMoney:(id)sender{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    
    //得到金钱
    int money[] = {25,30,40,50,60,80,100};
    int num = money[dayNum-1];
    
    [(WorldMapScene *)self.parent addDayPrizeMoney:num];
    
    //返回
    [self removeFromParentAndCleanup:YES];
}

-(void)updateNewDayRecommend{
    dayNum = 0;
    NSString *firstPrizeData = [[Globel shareGlobel].allDataConfig objectForKey:@"firstPrizeDataZ"];
    NSString *lastPrizeData = [[Globel shareGlobel].allDataConfig objectForKey:@"lastPrizeDataZ"];
    if (lastPrizeData==nil || [lastPrizeData isEqualToString:@""]) {
        dayNum = 1;
        NSDate *nowdate = [NSDate date];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        //[df setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
        
        NSString *newdatestr = [df stringFromDate:nowdate];
        //NSString *newdatestr = @"2012-07-09";
        
        
        [[Globel shareGlobel].allDataConfig setValue:newdatestr forKey:@"firstPrizeDataZ"];
        [[Globel shareGlobel].allDataConfig setValue:newdatestr forKey:@"lastPrizeDataZ"];
        
        [df release];
        
    }else {
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSString *curStr = [df stringFromDate:[NSDate date]];
        
        NSDate *firstdate  = [df dateFromString: firstPrizeData];
        NSDate *lastdate = [df dateFromString:lastPrizeData];
        NSDate *curdate  = [df dateFromString: curStr];
        
        NSDate *firstdate_local = [lastdate initWithTimeInterval:8*60*60 sinceDate:firstdate];
        NSDate *lastdate_local = [lastdate initWithTimeInterval:8*60*60 sinceDate:lastdate];
        NSDate *curdate_local = [lastdate initWithTimeInterval:8*60*60 sinceDate:curdate];
        
        //        /2012-07-11 00:00:00 +0000 ---- 2012-07-11 00:00:00 +0000
        trace(@"%@ ---- %@",lastdate_local,curdate_local);
        
        [df release];
        
        if ([curdate compare:lastdate] == NSOrderedDescending) {
            //储存
            [[Globel shareGlobel].allDataConfig setValue:curStr forKey:@"lastPrizeDataZ"];
            
            int all = [curdate_local timeIntervalSinceDate:firstdate_local];
            float daynum = all/(24*60*60);
            trace(@"daynum:%f",daynum);
            
            dayNum = (int)daynum%7 + 1;
            
        }else {
        }
    }
}

-(BOOL)isNewDayRecommend{
    dayNum = 0;
    NSString *firstPrizeData = [[Globel shareGlobel].allDataConfig objectForKey:@"firstPrizeDataZ"];
    NSString *lastPrizeData = [[Globel shareGlobel].allDataConfig objectForKey:@"lastPrizeDataZ"];
    if (lastPrizeData==nil || [lastPrizeData isEqualToString:@""]) {
        dayNum = 1;
        NSDate *nowdate = [NSDate date];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        //[df setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
        
        NSString *newdatestr = [df stringFromDate:nowdate];
        //NSString *newdatestr = @"2012-07-09";
        
        
        [df release];
        
        return YES;
    }else {
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSString *curStr = [df stringFromDate:[NSDate date]];
        
        NSDate *firstdate  = [df dateFromString: firstPrizeData];
        NSDate *lastdate = [df dateFromString:lastPrizeData];
        NSDate *curdate  = [df dateFromString: curStr];
        
        NSDate *firstdate_local = [lastdate initWithTimeInterval:8*60*60 sinceDate:firstdate];
        NSDate *lastdate_local = [lastdate initWithTimeInterval:8*60*60 sinceDate:lastdate];
        NSDate *curdate_local = [lastdate initWithTimeInterval:8*60*60 sinceDate:curdate];
        
        //        /2012-07-11 00:00:00 +0000 ---- 2012-07-11 00:00:00 +0000
        trace(@"%@ ---- %@",lastdate_local,curdate_local);
        
        [df release];
        
        if ([curdate compare:lastdate] == NSOrderedDescending) {
            
            int all = [curdate_local timeIntervalSinceDate:firstdate_local];
            float daynum = all/(24*60*60);
            trace(@"daynum:%f",daynum);
            
            dayNum = (int)daynum%7 + 1;
            
            return YES;
        }else {
            return NO;
        }
        
        
        
    }
    return YES;
}


-(BOOL)isNewDay{
    dayNum = 0;
    NSString *firstPrizeData = [[Globel shareGlobel].allDataConfig objectForKey:@"firstPrizeData"];
    NSString *lastPrizeData = [[Globel shareGlobel].allDataConfig objectForKey:@"lastPrizeData"];
    if (lastPrizeData==nil || [lastPrizeData isEqualToString:@""]) {
        dayNum = 1;
        NSDate *nowdate = [NSDate date];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        //[df setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
        
        NSString *newdatestr = [df stringFromDate:nowdate];
        //NSString *newdatestr = @"2012-07-09";
        
        
        [[Globel shareGlobel].allDataConfig setValue:newdatestr forKey:@"firstPrizeData"];
        [[Globel shareGlobel].allDataConfig setValue:newdatestr forKey:@"lastPrizeData"];
        
        [df release];
        
        return YES;
    }else {

        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSString *curStr = [df stringFromDate:[NSDate date]];
        
        NSDate *firstdate  = [df dateFromString: firstPrizeData];
        NSDate *lastdate = [df dateFromString:lastPrizeData];
        NSDate *curdate  = [df dateFromString: curStr];
        
        NSDate *firstdate_local = [lastdate initWithTimeInterval:8*60*60 sinceDate:firstdate];
        NSDate *lastdate_local = [lastdate initWithTimeInterval:8*60*60 sinceDate:lastdate];
        NSDate *curdate_local = [lastdate initWithTimeInterval:8*60*60 sinceDate:curdate];
        
//        /2012-07-11 00:00:00 +0000 ---- 2012-07-11 00:00:00 +0000
        trace(@"%@ ---- %@",lastdate_local,curdate_local);
        
         [df release];
        
        if ([curdate compare:lastdate] == NSOrderedDescending) {    
            //储存
            [[Globel shareGlobel].allDataConfig setValue:curStr forKey:@"lastPrizeData"];
            
            int all = [curdate_local timeIntervalSinceDate:firstdate_local];
            float daynum = all/(24*60*60);
            trace(@"daynum:%f",daynum);
            
            dayNum = (int)daynum%7 + 1;
                        
            return YES;
        }else {
            return NO;
        }
        
        
        
    }
    return YES;
}





@end
