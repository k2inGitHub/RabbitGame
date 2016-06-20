//
//  GameSetting.m
//  RabbitGame
//
//  Created by pai hong on 12-7-1.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "GameSetting.h"
#import "EESpriteScaleBtn.h"
#import "WorldMapScene.h"
#import "SoundManagerR.h"
#import "GameKitHelper.h"


@implementation GameSetting


//创建影片剪辑
-(void)creatSpriteByFramename:(NSString *)framename px:(float)x py:(float)y{
    track();
    CCSprite *sprite = [CCSprite spriteWithFile:framename];
    sprite.anchorPoint = ccp(0,1);
    sprite.position = ccp(x,y);
    [self addChild:sprite];
}

//创建功能按钮代理函数
-(void)creatBtnByFramename:(NSString *)framename px:(float)x py:(float)y sel:(SEL)callback tag:(int)t{
    track();
    EESpriteScaleBtn *sprite = [EESpriteScaleBtn spriteWithFile:framename];
    sprite.tag = t;
//    sprite.anchorPoint = ccp(0,1);
    sprite.position = ccp(x,y);
    [sprite addEETarget:self selector:callback];
    [self addChild:sprite];
}

- (id)init
{
    self = [super init];
    if (self) {
        //背景
        CCSprite *sprite = [CCSprite spriteWithFile:@"set_dg_bg.png"];
        sprite.anchorPoint = ccp(0,1);
        sprite.position = ccp(15,467);
        [self addChild:sprite];
        

        
        //排行榜
        [self creatBtnByFramename:@"set_btn_leader.png" px:156 py:170 sel:@selector(clickGameKit) tag:15];
        
          
        //关闭
        [self creatBtnByFramename:@"set_btn_close.png" px:156 py:70 sel:@selector(clickreturn:) tag:17];

        
        
        //音乐  音效  语音
        isbgmusice = [[[Globel shareGlobel].allDataConfig objectForKey:@"sound_bg"] boolValue];
        isAction = [[[Globel shareGlobel].allDataConfig objectForKey:@"sound_action"] boolValue];
        isHumen = [[[Globel shareGlobel].allDataConfig objectForKey:@"sound_human"] boolValue];
        

        if (isbgmusice) {
            [self creatBtnByFramename:@"set_music_on.png" px:156 py:323 sel:@selector(clickBgMusice) tag:11];
        }else {
            [self creatBtnByFramename:@"set_music_off.png" px:156 py:323 sel:@selector(clickBgMusice) tag:11];
        }
        
        if (isAction) {
            [self creatBtnByFramename:@"set_audio_on.png" px:156 py:250 sel:@selector(clickAction) tag:12];
        }else {
            [self creatBtnByFramename:@"set_audio_off.png" px:156 py:250 sel:@selector(clickAction) tag:12];
        }

        
        //关于我们
//        [self creatBtnByFramename:@"关于我们按钮.png" px:160 py:117 sel:@selector(clickAboutUs) tag:14];
        
    }
    return self;
}

#pragma mark ---点击了返回---
-(void)clickreturn:(id)sender{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    
    [self removeFromParentAndCleanup:YES];
}

//排名
-(void)clickGameKit{
    
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];

    [[GameKitHelper sharedHelper] showLeaderboard];



}


//背景音乐
-(void)clickBgMusice{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    

    isbgmusice = !isbgmusice;

    [[Globel shareGlobel].allDataConfig setValue:(isbgmusice?@"YES":@"NO")  forKey:@"sound_bg"];
    
    trace(@"%@",[Globel shareGlobel].allDataConfig);
    
    EESpriteScaleBtn *sprite = (EESpriteScaleBtn *)[self getChildByTag:11];
    if (isbgmusice) {
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage: @"set_music_on.png"];
        [sprite setTexture:texture];

    }else {
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage: @"set_music_off.png"];
        [sprite setTexture:texture];

    }
}

//效果声音
-(void)clickAction{
    
    

    isAction = !isAction;
    
    [[Globel shareGlobel].allDataConfig setValue:(isAction?@"YES":@"NO")  forKey:@"sound_action"];
    
    EESpriteScaleBtn *sprite = (EESpriteScaleBtn *)[self getChildByTag:12];
    if (isAction) {
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage: @"set_audio_on.png"];
        [sprite setTexture:texture];

    }else {
//        [sprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"set_audio_off.png"]];
        
        CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage: @"set_audio_off.png"];
        [sprite setTexture:texture];

    }
    
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
}



//关于我们
-(void)clickAboutUs{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    
    EESpriteScaleBtn *ee = [EESpriteScaleBtn node];
    ee.tag = 67;
    [(WorldMapScene *)self.parent clickFuncBtns:ee];
}































@end
