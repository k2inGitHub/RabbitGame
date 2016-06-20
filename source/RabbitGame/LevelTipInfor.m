//
//  LevelTipInfor.m
//  RabbitGame
//
//  Created by pai hong on 12-6-23.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "LevelTipInfor.h"
#import "EESpriteScaleBtn.h"
#import "WorldMapScene.h"
#import "SoundManagerR.h"


@implementation LevelTipInfor

+(id)createLevelTipInforByLevelNum:(NSInteger)num{
    
    return  [[self alloc] initByLevelNum:num];
}

-(id)initByLevelNum:(NSInteger)num{
    track();
    self = [super initWithSpriteFrameName:@"wordtipbg.png"];
    if (self) {
        levelnum = num;
        [self scheduleUpdate];
    }
    return self;
}

-(void)update:(ccTime)delta{
    track();
    [self unscheduleAllSelectors];
    //设置位置
    self.position = ccp(SSSW*0.5,SSSH*0.5);
    
    
    //返回按钮
    EESpriteScaleBtn *btn_return = [EESpriteScaleBtn spriteWithSpriteFrameName:@"wordtipe_btnreturn.png"];
    [btn_return addEETarget:self selector:@selector(clickReturn:)];
    btn_return.position = ccp(116*0.5,54*0.5);
    [self addChild:btn_return];
    
    //判断此关是否通过  没有通过的话，就显示灰色
    NSString *keystr = [NSString stringWithFormat:@"level_%d",levelnum];
    NSDictionary *dictionary = [[Globel shareGlobel].allDataConfig objectForKey:keystr];
    
    EESpriteScaleBtn *btn_entermap;
    BOOL isopen = [[dictionary objectForKey:@"isopen"] boolValue];
    
    //isopen = YES;
    
    //143 156
    CCSprite *wenzi;
    NSString *wenzifilename;
    if (isopen) {
        btn_entermap = [EESpriteScaleBtn spriteWithSpriteFrameName:@"wordtipe_btnenter_hight.png"];
        
        wenzifilename = [NSString stringWithFormat:@"des_%d.png",levelnum];

    }else {
        btn_entermap = [EESpriteScaleBtn spriteWithSpriteFrameName:@"wordtipe_btnenter.png"]; 
        btn_entermap.isTouched = NO;
        
        wenzifilename = [NSString stringWithFormat:@"des_%dlock.png",levelnum];

    }
    [btn_entermap addEETarget:self selector:@selector(clickEnter:)];
    btn_entermap.position = ccp(420*0.5,54*0.5);
    [self addChild:btn_entermap];
    
    wenzi = [CCSprite spriteWithFile:wenzifilename];   
    wenzi.anchorPoint = ccp(0,1); 
    wenzi.position = ccp(8,256);
    [self addChild:wenzi];
    
    //描述文本
    /*NSDictionary *leveldictionary = [[Globel shareGlobel].levelFeature objectForKey:([NSString stringWithFormat:@"%d",levelnum])];
    NSString *des_str = [leveldictionary objectForKey:@"discription"];
    
    CCLabelTTF *decription = [CCLabelTTF labelWithString:des_str dimensions:CGSizeMake(550*0.5,240*0.5) alignment:UITextAlignmentLeft lineBreakMode:UILineBreakModeWordWrap|UILineBreakModeClip fontName:@"Helvetica" fontSize:18];
    decription.anchorPoint = ccp(0,1);
    decription.color = ccBLACK;
    decription.position = ccp(26*0.5,410*0.5);
    [self addChild:decription];
    
    //特点文本
    NSString *fea_str = [leveldictionary objectForKey:@"feature"];
    CCLabelTTF *feature = [CCLabelTTF labelWithString:fea_str dimensions:CGSizeMake(550*0.5,50*0.5) alignment:UITextAlignmentLeft lineBreakMode:UILineBreakModeWordWrap|UILineBreakModeClip fontName:@"Helvetica-Bold" fontSize:18];
    feature.anchorPoint = ccp(0,1);
    feature.color = ccBLACK;
    feature.position = ccp(34*0.5,164*0.5);
    [self addChild:feature];
    
    //名字
    NSString *lanme = [leveldictionary objectForKey:@"levelname"];
    CCLabelTTF *levelname = [CCLabelTTF labelWithString:lanme fontName:@"Helvetica-Bold" fontSize:18];
    levelname.anchorPoint = ccp(0,1);
    levelname.color = ccWHITE;
    levelname.position = ccp(30*0.5,496*0.5+4);
    [self addChild:levelname];
    
    //最高分
    CCLabelTTF *highestlabel = [CCLabelTTF labelWithString:@"最高分:" fontName:@"Helvetica" fontSize:14];
    highestlabel.color = ccWHITE;
    highestlabel.position = ccp(322*0.5,470*0.5+4);
    [self addChild:highestlabel];
     */
    
    //关卡的最高分
    NSString *highScoreKey = [NSString stringWithFormat:@"level_%d",levelnum];
    NSString *highteststr = [[[Globel shareGlobel].allDataConfig objectForKey:highScoreKey] objectForKey:@"highestscore"];
    CCLabelTTF *hightestscore = [CCLabelTTF labelWithString:highteststr fontName:@"Helvetica" fontSize:14];
    hightestscore.anchorPoint = ccp(0,1);
    hightestscore.color = ccWHITE;
    hightestscore.position = ccp(400*0.5,488*0.5+7);
    [self addChild:hightestscore];
    
    
}


#pragma mark ---点击返回---
-(void)clickReturn:(id)sender{
    [self removeFromParentAndCleanup:YES];
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    self = nil;
}

#pragma mark ---点击进入---


-(void)clickEnter:(id)sender{
    //检测是否有正在就行的游戏，如果有，并且不是本关，则提示
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    
    BOOL ishasgameunfinished = NO;
    int  whounfinished;
    for (int a=1; a<=8; a++) {
        NSString *levelstr = [NSString stringWithFormat:@"level_%d",a];
        NSArray  *archive = [[[Globel shareGlobel].allDataConfig objectForKey:levelstr] objectForKey:@"archive"];
        BOOL  isgameover = [[[[Globel shareGlobel].allDataConfig objectForKey:levelstr] objectForKey:@"isgameover"] boolValue];
        
        if ((archive!=nil&&[archive count]>0) && !isgameover) {
            ishasgameunfinished = YES;
            whounfinished = a;
            break;
        }
    }
    
    //自身的情况
    NSString *levelstr1 = [NSString stringWithFormat:@"level_%d",levelnum];
    NSArray  *selfarchive = [[[Globel shareGlobel].allDataConfig objectForKey:levelstr1] objectForKey:@"archive"];
    BOOL  selfsgameover = [[[[Globel shareGlobel].allDataConfig objectForKey:levelstr1] objectForKey:@"isgameover"] boolValue];
    NSArray *namearray  =  [NSArray arrayWithObjects:@"埃斯特旺村",@"兔子洞",@"地主村",@"无仓村",@"北极村",@"月光村",@"滨海村",@"冒险岛", nil];
    [Globel shareGlobel].tempBool = NO;
    if (ishasgameunfinished) {
        if (selfsgameover) {
            if (whounfinished!=levelnum) {
                //本关结束了，别的关还没结束，本关只能浏览，不能重新试玩
                [Globel shareGlobel].tempBool = YES;
            }
        }else if (!selfsgameover && (selfarchive==nil || [selfarchive count]<=0)){
            NSString *inforstrr = [NSString stringWithFormat:@"您%@还没有完成，无法继续！",[namearray objectAtIndex:whounfinished-1]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:inforstrr delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }else {
            
        }
    }
    
    //进入游戏 
    [[Globel shareGlobel].worldMapScene gameStart:levelnum];
    trace(@"%@",sender);
}

























@end
