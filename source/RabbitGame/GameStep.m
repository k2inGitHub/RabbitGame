//
//  GameStep.m
//  RabbitGame
//
//  Created by pai hong on 12-6-22.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "GameStep.h"


#define maxAutoScore 150


@implementation GameStep



@synthesize isToRight;

static GameStep *instance;

+(GameStep *)shareInstance{
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        instance = self;
        isToRight = true;
        [self scheduleUpdate];
    }
    return self;
}

-(void)update:(ccTime)delta{
    [self unscheduleAllSelectors];
    
    //进度条
    process = [CCSprite node];
    CCSprite *processBg = [CCSprite spriteWithFile:@"process-bg.png"];
    processBg.position = ccp(49, 14);
    [self addChild:processBg z:-2];
    
    if (isToRight) {
        process.anchorPoint = ccp(0,0);
        maxLen = 96;
        process.position = ccp(2,-9);
    }else {
        process.anchorPoint = ccp(1,0);
        process.position = ccp(96,-9);
        maxLen = 96;
    }
    
    
    [[CCTextureCache sharedTextureCache] addImage:@"proccess.png"];
    [self addChild:process z:-1];
    
    //步骤 数字
    stepLabel = [CCLabelAtlas labelWithString:@"" charMapFile:@"number-ui.png" itemWidth:9 itemHeight:15 startCharMap:'0'];
    stepLabel.anchorPoint = ccp(1,0.5);
    CGSize size = self.contentSize;
    trace(@"%f %f",size.width,size.height);
    [self addChild:stepLabel];
    
    stepLabel.position = ccp(size.width-15,size.height*0.5);
        
    //剩余
    step = [[[Globel shareGlobel].allDataConfig objectForKey:@"step"] intValue];
    
    //增加离线的分数
    [self addRemenberTimeStep];
    
    //刷新分数
    [self refreshStepCount];
    
    //在2个gamestep切换的时候记住的秒数
    if ([Globel shareGlobel].tempSecond!=0) {
        secNum = [Globel shareGlobel].tempSecond;
    }
    
    [self schedule:@selector(roll) interval:1];
    
}   
    
#pragma mark ---记住时间---
-(void)rememberLevelTime{
    //当期的秒数
    historySecond = secNum;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSDate *lasetdate = [NSDate date];

    NSString *str = [df stringFromDate:lasetdate];

    [[Globel shareGlobel].allDataConfig setValue:str forKey:@"stepremembertime"];
    [[Globel shareGlobel].allDataConfig setValue:[NSString stringWithFormat:@"%d",historySecond] forKey:@"stepremembersecond"];
}   
    
#pragma mark ---增加  离线后的分数----
-(void)addRemenberTimeStep{
    //得到上次的时间  离开程序记录的时间
    NSString *lastdatestr = [[Globel shareGlobel].allDataConfig objectForKey:@"stepremembertime"];
    int lastSecond =  -[[[Globel shareGlobel].allDataConfig objectForKey:@"stepremembersecond"] intValue];
    if (![lastdatestr isEqualToString:@""] && step<maxAutoScore) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //[df setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
        
        NSDate *lasetdate = [df dateFromString:lastdatestr];
        
        //NSDate *cur = [NSDate date];
        
        NSTimeInterval spacetime = [lasetdate timeIntervalSinceNow];
        
        [df release];
        
        //加上之前的秒数
        spacetime += lastSecond;
        
        //得到分钟数量
        int minits = - (int) spacetime /60;
        int second = - (int) spacetime %60;
                
        
        step += minits;
        secNum = second;
        
        if (step >= maxAutoScore) {
            step = maxAutoScore;
        }
        
        //奖励后则吧stepremembertime设置成空,要不然会无限增加分数的
        [[Globel shareGlobel].allDataConfig setValue:@"" forKey:@"stepremembertime"];
        
    } 
    
    //刷新分数
    [self refreshStepCount];
}   
    
-(void)roll{
    if (step>=maxAutoScore) {
        secNum = 0;
        process.visible = NO;
        return;
    }
    
    process.visible = YES;
    
    secNum++;
    if (secNum>=60) {
        step++;
        secNum = 0;
        [self refreshStepCount];
    }
    float bili = secNum*1.0f / 60;
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] textureForKey:@"proccess.png"];
    float len = bili * maxLen;
    CCSpriteFrame *spframe = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(0, 0, len, 36)];
    [process setDisplayFrame:spframe];
}

#pragma mark ---得到设置 step---
-(void)refreshStepCount{
    stepLabel.string = [NSString stringWithFormat:@"%d",step];
    //stepLabel.string = [NSString stringWithFormat:@"%d",99999];
    [[Globel shareGlobel].allDataConfig setValue:[NSString stringWithFormat:@"%d",step] forKey:@"step"];
}
-(void)refresh{
    //剩余
    step = [[[Globel shareGlobel].allDataConfig objectForKey:@"step"] intValue];
    stepLabel.string = [NSString stringWithFormat:@"%d",step];
}

//剩余的步数
-(int)getLeftStep{
    return step;
}

-(void)setStep:(int)s{
    step = s;
    [self refreshStepCount];
}

-(void)add_cut_step:(int)num{
    step = step + num;
    [self refreshStepCount];
}






#pragma mark ---回收---
-(void)onExit{
    //在2个gamestep切换的时候记住的秒数
    [Globel shareGlobel].tempSecond = secNum;
    
    [self unscheduleAllSelectors];
    instance = nil;
    [super onExit];
}









@end
