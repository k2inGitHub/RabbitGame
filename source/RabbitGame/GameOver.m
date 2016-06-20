//
//  GameOver.m
//  RabbitGame
//
//  Created by pai hong on 12-7-5.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "GameOver.h"
#import "EESpriteScaleBtn.h"
#import "GameScene.h"
#import "Link.h"
#import "Grid.h"
#import "SoundManagerR.h"
#import "MyUserAnalyst.h"
#import "Business.h"
#import "MobClick.h"
#import "Configuration.h"

@implementation GameOver

//创建影片剪辑
-(void)creatSpriteByFramename:(NSString *)framename px:(float)x py:(float)y{
    track();
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:framename];
    sprite.anchorPoint = ccp(0,1);
    sprite.position = ccp(x,y);
    [self addChild:sprite];
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

-(EEAnimateLabel *)createLabel_L:(float)x :(float)y{
    EEAnimateLabel *label = [EEAnimateLabel labelWithString:@"234" charMapFile:@"over-number.png" itemWidth:10 itemHeight:15 startCharMap:'0'];
    label.anchorPoint = ccp(0,0.5);
    label.position = ccp(x,y);
    [self addChild:label];
    return  label;
}
-(EEAnimateLabel *)createLabel_C:(float)x :(float)y{
    EEAnimateLabel *label = [EEAnimateLabel labelWithString:@"234" charMapFile:@"over_number_big.png" itemWidth:20 itemHeight:30 startCharMap:'0'];
    label.anchorPoint = ccp(0.5,0.5);
    label.position = ccp(x,y);
    [self addChild:label];
    return  label;
}

//得到建筑物的个数
-(int)getHouseNum:(int)level{
    NSMutableArray *grids = [[GameScene shareInstance] getGrids];
    int len = [grids count];
    int num = 0;
    for (int i=(len-1); i>=0; i--) {
        NSMutableArray *lines = [grids objectAtIndex:i];
        int count = [lines count];
        for (int a=0; a<count; a++) {
            Grid *grid = [lines objectAtIndex:a];
            Link *link = grid.link;
            if (link!=nil && link.type == Link_Type_House && link.level == level) {
                num ++;
            }
        }
    }
    return num;
}

- (id)init
{
    self = [super init];
    if (self) {
        //背景
        //背景
//        CCSprite *sprite = [CCSprite spriteWithFile:@"funcbg.png"];
//        sprite.anchorPoint = ccp(0,1);
//        sprite.position = ccp(3,475);
//        [self addChild:sprite];
        [[HLAdManager sharedInstance] hideBanner];
        //背景
        CCSprite *sprite1 = [CCSprite spriteWithFile:@"gameoverbg.png"];
        sprite1.anchorPoint = ccp(0,1);
        sprite1.position = ccp(18,464);
        [self addChild:sprite1];
        
        //截图分享
//        [self creatBtnByFramename:@"js_share.png" px:94 py:31 sel:@selector(clickCamera)];
        //返回
        [self creatBtnByFramename:@"js_back.png" px:242 py:31 sel:@selector(clickreturn:)];
        
        [[SoundManagerR shareInstance] playSound:@"游戏结束.wav" type:Sound_Type_Action];
        /*
         CCLabelAtlas *allscore;
         
         CCLabelAtlas *house5;
         CCLabelAtlas *house6;
         CCLabelAtlas *house7;
         CCLabelAtlas *house8;
         CCLabelAtlas *house9;
         
         CCLabelAtlas *stepcount;
         CCLabelAtlas *stepscore;
         
         CCLabelAtlas *prizeMoney
         */
        //得分
        allscore = [self createLabel_L:192 :439];
        allscore.scale = 1.3f;
        allscore.string = [NSString stringWithFormat:@"%d", [[GameScene shareInstance] getGameScore]];
        
        
        //10 20 50 200
        int h4 = [self getHouseNum:4];
        int h5 = [self getHouseNum:5];
        int h6 = [self getHouseNum:6] *10;
        int h7 = [self getHouseNum:7] *20;
        int h8 = [self getHouseNum:8] *50;
        int h9 = [self getHouseNum:9] *100;
        
        
        house6 = [self createLabel_L:135 :202];
        house6.string = [NSString stringWithFormat:@"%d",h6];
        
        house7 = [self createLabel_L:267 :202];
        house7.string = [NSString stringWithFormat:@"%d",h7];
        
        house8 = [self createLabel_L:135 :145];
        house8.string = [NSString stringWithFormat:@"%d",h8];
        
        house9 = [self createLabel_L:267 :145];
        house9.string = [NSString stringWithFormat:@"%d",h9];
        
        
        //城镇等级
        int cityscore;
        if (h9!=0) {
            cityscore = 150;
        }else if (h8 != 0) {
            cityscore = 50;
        }else if (h7 != 0) {
            cityscore = 40;
        }else if (h6 != 0) {
            cityscore = 30;
        }else if (h5 != 0) {
            cityscore = 20;
        }else if (h4 != 0) {
            cityscore = 10;
        }else{
            cityscore = 1;
        }
        houselevel = [self createLabel_L:135 :258];
        houselevel.string = [NSString stringWithFormat:@"%d",cityscore];
        
        
        int costStep = [GameScene shareInstance].conststep;
//        stepcount = [self createLabel_L:267 :263];
//        stepcount.string = [NSString stringWithFormat:@"%d", costStep];
        
        stepscore = [self createLabel_L:267 :258];
        int sss = costStep*0.1;
        if (costStep%10!=0) {
            sss++;
        }
        stepscore.string = [NSString stringWithFormat:@"%d", sss];
        
        
        //最终得分
        prizeMoney = [self createLabel_C:150 :92];
        prizeint = h6 + h7 + h8 + h9 + cityscore + sss;
        prizeMoney.string = [NSString stringWithFormat:@"%d",prizeint];
        
        [[GameScene shareInstance] add_cut_money:prizeint];
        
        
        int scoreWall = [MyUserAnalyst getIntFlag:@"Video" defaultValue:0];
        if (scoreWall > 0 && GeneralOnOff) {
            spriteVideo = [EESpriteScaleBtn spriteWithFile:@"btn_dobule.png"];
            spriteVideo.position = ccp(242,95);
            [spriteVideo addEETarget:self selector:@selector(clickvideo:)];
            [self addChild:spriteVideo];
        } else {
            spriteVideo = nil;
        }
    }
    return self;
}


-(void)videoPlayed:(NSNotification *)notification
{
    [MobClick event:@"Video" label:@"DoubleWin"];
    [[GameScene shareInstance] add_cut_money:prizeint];
    prizeMoney.string = [NSString stringWithFormat:@"%d",2*prizeint];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (spriteVideo) {
        [spriteVideo removeFromParentAndCleanup:true];
    }
}

-(void)clickvideo:(id)sender{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayed:) name:@"VideoPlayed" object:nil];
    [[Business sharedInstance] showVideo];
}

-(void)clickreturn:(id)sender{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeFromParentAndCleanup:YES];
    [[HLAdManager sharedInstance] showBanner];
}


-(void)clickCamera{
    [[GameScene shareInstance] clickGameOverCameraShare];
}











@end
