//
//  IconLevel.m
//  RabbitGame
//
//  Created by pai hong on 12-6-22.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "IconLevel.h"
#import "Link.h"


@implementation IconLevel

@synthesize levelNum;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


//得到最高级的建筑物
-(int)getHighestHouse{    
    NSString *levelstr = [NSString stringWithFormat:@"level_%d",levelNum];
    NSMutableArray *historygrids = [[[Globel shareGlobel].allDataConfig objectForKey:levelstr] objectForKey:@"archive"];
    
    if (historygrids==nil || [historygrids count]<=0) {
        return -1;
    }
    
    int hightlevel = 0;
    int len = [historygrids count];
    for (int i=0; i<len; i++) {
        NSMutableArray *recordLine = [historygrids objectAtIndex:i];
        
        int count = [recordLine count];
        for (int a=0; a<count; a++) {
            NSMutableDictionary *recodGrid = [recordLine objectAtIndex:a];
            
            Link_Type type = [[recodGrid objectForKey:@"type"] intValue];
            int level = [[recodGrid objectForKey:@"level"] intValue];
            
            if (type == Link_Type_House) {
                if (level>hightlevel) {
                    hightlevel = level;
                }
            }
        }
    }
    return hightlevel;
}



//创建影片剪辑
-(void)creatSpriteByFramenameNoScal:(NSString *)framename px:(float)x py:(float)y{
    track();
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:framename];
    sprite.anchorPoint = ccp(0,1);
//    sprite.scale = 0.8;
    sprite.position = ccp(x,y);
    [self addChild:sprite];
}
-(void)creatSpriteByFramename:(NSString *)framename px:(float)x py:(float)y{
    track();
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:framename];
    sprite.anchorPoint = ccp(0,1);
    sprite.scale = 0.8;
    sprite.position = ccp(x,y);
    [self addChild:sprite];
}
-(void)creatSpriteByFramenameCenter:(NSString *)framename px:(float)x py:(float)y{
    track();
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:framename];
    sprite.position = ccp(x,y);
    //sprite.scale = 0.8;
    [self addChild:sprite];
}




-(void)addCommonBuilders :(int)level{
    
    [self creatSpriteByFramename:@"w3_up.png" px:13 py:76];
    [self creatSpriteByFramename:@"w3.png" px:-5 py:58];
    [self creatSpriteByFramename:@"w3.png" px:43 py:66];
    
    if(level<=4){
        [self creatSpriteByFramenameCenter:@"w4.png" px:45 py:41];
    }else {
        NSString *name = [NSString stringWithFormat:@"w%d.png",level];
        [self creatSpriteByFramenameCenter:name px:45 py:41];
    }
    
    [self creatSpriteByFramename:@"w3.png" px:51 py:43];
    [self creatSpriteByFramename:@"w3_up.png" px:30 py:38];
    
    //名字
    NSString *levelname = [NSString stringWithFormat:@"levelname_%d.png",levelNum];
    [self creatSpriteByFramenameNoScal:levelname px:20 py:29];    
}

-(id)initWithSpriteByLevelNum:(NSInteger)num{   
    track();
    
    levelNum = num;
    
    //得到此关卡的配置信息
    NSString *keyvalue = [NSString stringWithFormat:@"level_%d",num];
    
    //是否通过了此关，此关是否开放
    NSDictionary *diction = [[Globel shareGlobel].allDataConfig objectForKey:keyvalue];
    isopen = [[diction objectForKey:@"isopen"] boolValue];
    score  = [[diction objectForKey:@"currentscore"] intValue];
    [self scheduleUpdate];
    
    //isopen = YES;
        
    NSString *frameICOname;
    if (isopen) {
        int highLevel = [self getHighestHouse];
        if (levelNum==1) {
            self = [super initWithFile:@"cunbg.png"];
            //self = [super initWithSpriteFrameName:@"w3_up.png"];
            [self addCommonBuilders:highLevel];
        }else {
            if (highLevel==-1) {
                NSString *framename = [NSString stringWithFormat:@"bigprohibit_%d.png",num];
                self = [super initWithSpriteFrameName:framename];
            }else {
                self = [super initWithFile:@"cunbg.png"];
                //self = [super initWithSpriteFrameName:@"w3_up.png"];
                [self addCommonBuilders:highLevel];
            }
        }
        
    }else {
        
        frameICOname = [NSString stringWithFormat:@"bigprohibit_%d.png",num];
        self = [super initWithSpriteFrameName:frameICOname];
    }
    
    //当前未完成的关卡，运动动画。
    NSString *levelstr = [NSString stringWithFormat:@"level_%d",levelNum];
    NSArray  *archive = [[[Globel shareGlobel].allDataConfig objectForKey:levelstr] objectForKey:@"archive"];
    BOOL  isgameover = [[[[Globel shareGlobel].allDataConfig objectForKey:levelstr] objectForKey:@"isgameover"] boolValue];
    
    if ((archive!=nil&&[archive count]>0) && !isgameover) {
        [self showScaleAnimation];
    }else {
        //第一关游戏启动的话，要闪动的
        if (levelNum == 1 && (archive==nil || [archive count]<=0)) {
            [self showScaleAnimation];
        }
    }
        
    return self;
}

-(void)showScaleAnimation{
    
    CCScaleTo *scale1 = [CCScaleTo actionWithDuration:0.5 scale:0.9];
    CCScaleTo *scale2 = [CCScaleTo actionWithDuration:0.5 scale:1.1];
    
    CCSequence *sequence = [CCSequence actions:scale1,scale2, nil];
    
    CCRepeatForever *forever = [CCRepeatForever actionWithAction:sequence];
    
    [self runAction:forever];
}

//
-(void)update:(ccTime)delta{
    track();
    [self unscheduleAllSelectors];
    
    //如果开放的话，则吧此关的分数也显示出来
    if (isopen) {
        //level_1 highestscore
        
        NSString *cur_score = [NSString stringWithFormat:@"%d",score];
        if (score==0) {//为0的话，则不显示
            return;
        }
        
        CCLabelAtlas *scorelabel = [CCLabelAtlas labelWithString:cur_score charMapFile:@"text1.png" itemWidth:16 itemHeight:25 startCharMap:'0'];
        scorelabel.anchorPoint = ccp(0,0.5);
//        CGSize size = self.contentSize;
        scorelabel.position = ccp(20,2);
        [self addChild:scorelabel];
        scorelabel.scale = 0.7;
    }
}

+(id)createSpriteIconByLevelName:(NSInteger)levnum{
    return [[[self alloc] initWithSpriteByLevelNum:levnum] autorelease];
}









@end
