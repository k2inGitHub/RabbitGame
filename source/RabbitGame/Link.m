//
//  Link.m
//  RabbitGame
//
//  Created by pai hong on 12-6-24.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "Link.h"
#import "CCAnimationHelper.h"
#import "BirdController.h"
#import "PeopleController.h"
#import "GameScene.h"
#import "Grid.h"
#import "SoundManagerR.h"


@implementation Link

@synthesize level,type,x,y,score,issuper,pgrid,isCreatedPeople,order;

+(id)createByType:(Link_Type)t andLelve:(int)l{
    
    return  [[[self alloc] initWithSpriteFrameBytype:t level:l issuper:false] autorelease];
    
}

+(id)createByType:(Link_Type)t andLelve:(int)l issuper:(BOOL)isSuper{
    
    return  [[[self alloc] initWithSpriteFrameBytype:t level:l issuper:isSuper] autorelease];
    
}

-(void)setPosition:(CGPoint)position {
    [super setPosition:position];
}

-(id)initWithSpriteFrameBytype:(Link_Type )t level:(int)l issuper:(BOOL)isSuper{
    /*  
     Link_Type_House = 1, //草  胡萝卜 果树  村屋  农舍 公寓 四方金字塔 水晶塔  神殿
     Link_Type_Rabbit,     //兔子 飞兔  笼子 收容所 宝箱  大宝箱
     Link_Type_Stone,     //小石头 大石头 
     Link_Type_Tool      //彩虹球 炸弹
    */  
    track();
        
    issuper = isSuper;
        
    type = t;
    level = l;
        
    x = 1000;//默认
    y = 1000;
        
    NSString *framename;
    if (type==Link_Type_House) {
        //贴图
        if (isSuper) {
            framename = [NSString stringWithFormat:@"w%d_up.png",level];
        }else {
            framename = [NSString stringWithFormat:@"w%d.png",level];
        }
        
        //分数
        NSArray *scorearray = [NSArray arrayWithObjects:@"5",@"25",@"100",@"500",@"1500",@"5000",@"10000",@"120000",@"500000", nil];
        score = [[scorearray objectAtIndex:(level-1)] intValue];
    }else if(type == Link_Type_Rabbit){
        if (l==1) {
            framename = [NSString stringWithFormat:@"rabbit1.png"];   
        }else{
            framename = [NSString stringWithFormat:@"rabbit2.png"];   
        }
        //tag标记
        order = [Globel shareGlobel].rabbitTag;
        trace(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%d",order);
        [Globel shareGlobel].rabbitTag ++;
        //赋值分数
        NSArray *scorearray = [NSArray arrayWithObjects:@"0",@"0",@"0",@"0",@"50000", nil];
        score = [[scorearray objectAtIndex:(level-1)] intValue];
        
    }else if(type == Link_Type_Park){
        framename = [NSString stringWithFormat:@"p%d.png",level];   
        
        //赋值分数
        NSArray *scorearray = [NSArray arrayWithObjects:@"0",@"1200",@"6000",@"15000",@"50000", nil];
        score = [[scorearray objectAtIndex:(level-1)] intValue];
        //tag标记
        if (level==1) {
            //tag标记
            order = [Globel shareGlobel].rabbitTag;
            trace(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%d",order);
            [Globel shareGlobel].rabbitTag ++;
        }
    }else if(type ==Link_Type_Stone){
        framename = [NSString stringWithFormat:@"s%d.png",level];
        
        //赋值分数
        NSArray *scorearray = [NSArray arrayWithObjects:@"0",@"1200",@"0",@"0",@"0", nil];
        score = [[scorearray objectAtIndex:(level-1)] intValue];
    }else if(type == Link_Type_Tool){
        if (level == 3) {
            framename = @"chexiao.png";
        } else {
            framename = [NSString stringWithFormat:@"tool%d.png",level];
        }
    }
    trace(@"创建  %d %d %@",t,l,framename);
    
    if(type == Link_Type_Tool){
        if (level == 3) {
            self = [super initWithFile:framename];
        } else {
            self = [super initWithSpriteFrameName:framename];
        }
    } else {
        self = [super initWithSpriteFrameName:framename];
    }
    
    
    //草 树 房子  会飞出小鸟
    if (type == Link_Type_House && (level == 1 || level == 3 || level ==4)) {
        //会刷出小鸟
        int t = arc4random() %5 + 4;
        [self schedule:@selector(rollBird) interval:t];
    }
    
    [self regeistRabbitActinos];
    
    [self regeistCreatePeopleHandle];
    
    //如果是最高级建筑，则显示动画
    if (type == Link_Type_House && level ==9) {
        [self runTopestAction];
    }
    
    return self;
}

-(void)regeistRabbitActinos{
    if (type == Link_Type_Rabbit) {
        [self unschedule:@selector(rabbitRoll)];
        [self schedule:@selector(rabbitRoll) interval:4];
    }
}

-(void)regeistCreatePeopleHandle{
    //创建小人
    if (type == Link_Type_House && (level == 4 || level == 5 || level == 6)) {
        int a = arc4random()%5 + 2;
        [self schedule:@selector(createPeople) interval:a];
    }
}

-(void)setLinkPgrid:(Grid *)g{
    pgrid = g;
}

//最高级建筑动画
-(void)runTopestAction{
    NSArray *array = [NSArray arrayWithObjects:@"w9.png", nil];
    CCAnimation *animation = [CCAnimation animationWithNames:array delay:0.2];
    CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
    
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:animate];
    [self runAction:repeat];
}

//出现小鸟动画
-(void)rollBird{
    int a = arc4random()%10;
    if (a<1) {
        Grid *grid = self.pgrid;
        if (grid!=nil) {
            //[[GameScene shareInstance].birdController flyAbirdFrom:grid];
        }
    }
}

//出现小人
-(void)createPeople{
    
    trace(@"是否创建小人 %f %f",self.position.x,self.position.y);

    if (self.pgrid == nil) {//还没有放置在场景中。
        return;
    }
    
    //如果大于5个人，则不创建.------------------------
    int num = 0;
    num = [[GameScene shareInstance] getPeopleCount];
    if (num>=5) {
        return;
    }
    //------------------------------------------------
    
    //创建小人
    [[GameScene shareInstance].peopleController createOnePeople:self.pgrid];
    
    //取消循环
    [self unschedule:@selector(createPeople)];
}

-(void)stopPreMove{
    [self stopAllActions];
    self.position = rememberPosition;
}

//刚刚开始的运动
-(void)preMovePointTo:(CGPoint)p{
    //记住原来的位置
    rememberPosition = self.position;
    
    float num = 8;
    CGPoint newPoint;
    
    CGPoint s = self.position;
    
    float chax;
    float chay;
    
    if (p.x>s.x && p.y>s.y) {//右上
        chax = num;
        chay = num;
    }else if(p.x== s.x && p.y>s.y){//上
        chax = 0;
        chay = num;
        
    }else if (p.x>s.x && p.y<s.y) {//右下
        chax = num;
        chay = -num;
        
    }else if (p.x>s.x && p.y==s.y){//右
        chax = num;
        chay = 0;
        
    }else if (p.x==s.x && p.y<s.y) {//下
        chax = 0;
        chay = -num;
        
    }else if (p.x<s.x && p.y>s.y) {//左上
        chax = -num;
        chay = num;
        
    }else if (p.x<s.x && p.y==s.y){//左
        chax = -num;
        chay = 0;
        
    }else if (p.x<s.x && p.y<s.y ){//左下
        chax = -num;
        chay = -num;
        
    }
    newPoint = ccp(s.x+chax,s.y+chay);
    
    CCMoveTo *moveto1 = [CCMoveTo actionWithDuration:0.5 position:newPoint];
    CCMoveTo *moveto2 = [CCMoveTo actionWithDuration:0.5 position:s];
    CCSequence *seq = [CCSequence actions:moveto1,moveto2, nil];
    
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:seq];
    [self runAction:repeat];
    
}

//开始合并运动
-(void)startMovePointTo:(CGPoint)p{
    CCMoveTo *moveto1 = [CCMoveTo actionWithDuration:0.5 position:p];
    CCFadeOut *fadeout = [CCFadeOut actionWithDuration:0.5];
    CCSpawn *act = [CCSpawn actions:moveto1,fadeout, nil];
    
    CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(overToRemove)];
    
    CCSequence *sequence = [CCSequence actions:act,callback, nil];
    
    [self runAction:sequence];
}

-(void)overToRemove{
    [self removeFromParentAndCleanup:YES];
}

-(void)unschedule:(SEL)s{
    [super unschedule:s];
}

-(void)unscheduleAllSelectors{
    [super unscheduleAllSelectors];
}


#pragma mark ---拷贝---
-(Link *)copyOne{
    Link *link = [Link createByType:type andLelve:level];
    return link;
}




#pragma mark ----兔子动画操作----

-(void)doAction:(NSArray *)names delay:(float)f loop:(int)lop{
    if (self.level == 1) {
        track();
        //return;
        isActioning = YES;
        
        //准备动画
        CCRepeat *repeatprevani;
        int prevtimes = arc4random()%2 +2;
        
        
        // 坏笑
        NSArray *names1 = [NSArray arrayWithObjects:@"hx01.png",@"hx02.png",@"hx01.png",@"hx02.png",@"hx01.png",@"hx02.png",@"hx01.png", nil];
        CCAnimation *prevanimation = [CCAnimation animationWithNames:names1 delay:0.1];
        CCAnimate *prevanimat = [CCAnimate actionWithAnimation:prevanimation];
        repeatprevani = [CCRepeat actionWithAction:prevanimat times:prevtimes];
        
        
        CCAnimation *animation = [CCAnimation animationWithNames:names delay:f];
        CCAnimate *amimate = [CCAnimate actionWithAnimation:animation];
        
        CCRepeat *repeat = [CCRepeat actionWithAction:amimate times:lop];
        
        CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(rabbitMoveOver)];
        
        CCSequence *sequence = [CCSequence actions:repeatprevani,repeat,callback, nil];
        
        [self runAction:sequence];
    }else {
//        //黑兔坏笑
//        NSArray *names2 = [NSArray arrayWithObjects:@"ht_hx01.png",@"ht_hx02.png",@"ht_hx03.png",@"ht_hx03.png",@"ht_hx04.png",@"ht_hx05.png",@"ht_hx05.png", nil];
//        CCAnimation *prevanimation = [CCAnimation animationWithNames:names2 delay:0.1];
//        CCAnimate *prevanimat = [CCAnimate actionWithAnimation:prevanimation];
//        repeatprevani = [CCRepeat actionWithAction:prevanimat times:prevtimes];
//        
    }
    
}

-(void)doAction:(NSString *)frame count:(int)c delay:(float)f loop:(int)lop{
    if (self.level == 1) {
        track();
        isActioning = YES;
        
        //准备动画
        CCRepeat *repeatprevani;
        int prevtimes = arc4random()%2 +2;
        
        
        NSArray *names1 = [NSArray arrayWithObjects:@"hx01.png",@"hx02.png",@"hx01.png",@"hx02.png",@"hx01.png",@"hx02.png",@"hx01.png", nil];
        CCAnimation *prevanimation = [CCAnimation animationWithNames:names1 delay:0.1];
        CCAnimate *prevanimat = [CCAnimate actionWithAnimation:prevanimation];
        repeatprevani = [CCRepeat actionWithAction:prevanimat times:prevtimes];
        
        CCAnimation *animation = [CCAnimation animationWithFrame:frame frameCount:c delay:f];
        CCAnimate *amimate = [CCAnimate actionWithAnimation:animation];
        
        CCRepeat *repeat = [CCRepeat actionWithAction:amimate times:lop];
        
        CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(rabbitMoveOver)];
        
        CCSequence *sequence = [CCSequence actions:repeatprevani,repeat,callback, nil];
        
        [self runAction:sequence];
        
        
    }else {
//        //黑兔坏笑
//        NSArray *names2 = [NSArray arrayWithObjects:@"ht_hx01.png",@"ht_hx02.png",@"ht_hx03.png",@"ht_hx03.png",@"ht_hx04.png",@"ht_hx05.png",@"ht_hx05.png", nil];
//        
//        CCAnimation *prevanimation = [CCAnimation animationWithNames:names2 delay:0.1];
//
//        CCAnimate *prevanimat = [CCAnimate actionWithAnimation:prevanimation];
//        repeatprevani = [CCRepeat actionWithAction:prevanimat times:prevtimes];
        
    }
    
}

-(void)addFrame:(NSString*)file to:(NSMutableArray*)frames
{
    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    CCSpriteFrame* frame = [frameCache spriteFrameByName:file];
    [frames addObject:frame];
}

//兔子移动动画
-(void)moveRabbitToTarget:(CGPoint)point{
    track();
    [self stopAllActions];
    
    isActioning = YES;
    if (level == 1) {
        
        NSMutableArray* frames = [NSMutableArray arrayWithCapacity:10];
        [self addFrame:@"tz01.png" to:frames];
        for (int i = 0; i < 1; i++) {
            [self addFrame:@"tz02.png" to:frames];
            [self addFrame:@"tz03.png" to:frames];
            [self addFrame:@"tz04.png" to:frames];
            [self addFrame:@"tz05.png" to:frames];
            [self addFrame:@"tz02.png" to:frames];
            [self addFrame:@"tz03.png" to:frames];
            [self addFrame:@"tz04.png" to:frames];
            [self addFrame:@"tz05.png" to:frames];
        }
        [self addFrame:@"tz01.png" to:frames];
        
        CCAnimation *animation = [CCAnimation animationWithFrames:frames delay:0.1f];
        
        CCAnimate *amimate = [CCAnimate actionWithAnimation:animation];
        
        CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.8 position:point];
        
        CCSpawn *spawn = [CCSpawn actions:amimate,moveTo, nil];
        
        CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(rabbitMoveOver)];
        
        CCSequence *sequence = [CCSequence actions:spawn,callback, nil];    
        
        [self runAction:sequence];
    }else {
        //self.position = lastHeiTuPosition;//防止点击的太快，会导致黑兔子会一直原地的问题
        
        targetPosition = point;
        
//        // 黑兔消失
//        CCAnimation *animation = [CCAnimation animationWithFrame:@"cs01-" frameCount:11 delay:0.06];
//        CCAnimate *amimate = [CCAnimate actionWithAnimation:animation];
//        
//        //CCRepeat *repeat = [CCRepeat actionWithAction:amimate times:1];
//        
//        //CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.8 position:point];
//        
//        //CCSpawn *spawn = [CCSpawn actions:amimate,moveTo, nil];
        
        CCJumpTo *jump = [CCJumpTo actionWithDuration:0.8 position:point height:100 jumps:1];
                          
        
        CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(rabbit2MoveOver)];
        
        CCSequence *sequence = [CCSequence actions:jump,callback, nil];    
        
        [self runAction:sequence];
    }
}

-(void)rabbitRoll{
    if (isActioning) {
        return;
    }
    track();
    //眨眼
    //[self doAction:@"hx" count:5 delay:0.12 loop:2];
    
    //淫笑
    //[self doAction:@"kx" count:5 delay:0.12 loop:2];
    
    //挠头
    //[self doAction:@"nt" count:4 delay:0.22 loop:2];
    
    int random = arc4random()%100;
    
    if (random<50) {//60%的几率触发动画
        int goRandom = arc4random()%100;
        if (level == 1) {//白兔
            if(goRandom >= 60){//开心、傻笑
                NSArray *array = [NSArray arrayWithObjects:@"kx01.png",@"kx02.png",@"kx03.png",@"kx04.png",@"kx05.png",@"kx06.png",@"kx07.png",@"kx06.png",@"kx05.png",@"kx04.png",@"kx03.png",@"kx02.png",@"kx01.png", nil];
                
                isActioning = YES;
                
                //准备动画
                
                CCAnimation *animation = [CCAnimation animationWithNames:array delay:0.2f];
                CCAnimate *amimate = [CCAnimate actionWithAnimation:animation];
                
                CCRepeat *repeat = [CCRepeat actionWithAction:amimate times:2];
                
                CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(rabbitMoveOver)];
                
                CCSequence *sequence = [CCSequence actions:repeat,callback, nil];
                
                [self runAction:sequence];
                
                
                //[self doAction:array delay:0.1 loop:2];
            }else if(goRandom >=30){//挥手
                NSArray *array = [NSArray arrayWithObjects:@"nt01.png",@"nt02.png",@"nt03.png",@"nt04.png",@"nt05.png",@"nt02.png",@"nt03.png",@"nt04.png",@"nt05.png",@"nt06.png", nil];
                
                
                isActioning = YES;
                
                //准备动画
                
                CCAnimation *animation = [CCAnimation animationWithNames:array delay:0.2f];
                CCAnimate *amimate = [CCAnimate actionWithAnimation:animation];
                
                CCRepeat *repeat = [CCRepeat actionWithAction:amimate times:2];
                
                CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(rabbitMoveOver)];
                
                CCSequence *sequence = [CCSequence actions:repeat,callback, nil];
                
                [self runAction:sequence];
            }else if(goRandom >=15){//坏笑
                
                [[SoundManagerR shareInstance] playSound:@"城管笑.wav" type:Sound_Type_Action];
                
                NSArray *array = [NSArray arrayWithObjects:@"hx01.png",@"hx02.png",@"hx01.png",@"hx02.png",@"hx01.png",@"hx02.png",@"hx01.png", nil];
                
                isActioning = YES;
                
                //准备动画
                
                CCAnimation *animation = [CCAnimation animationWithNames:array delay:0.2f];
                CCAnimate *amimate = [CCAnimate actionWithAnimation:animation];
                
                CCRepeat *repeat = [CCRepeat actionWithAction:amimate times:2];
                
                CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(rabbitMoveOver)];
                
                CCSequence *sequence = [CCSequence actions:repeat,callback, nil];
                
                [self runAction:sequence];
                
            }else {//大跳
                
                [[SoundManagerR shareInstance] playSound:@"城管呲牙.caf" type:Sound_Type_Action];
                
                NSArray *array = [NSArray arrayWithObjects:@"dt01.png",@"dt02.png",@"dt03.png",@"dt04.png",@"dt05.png",@"dt06.png",@"dt07.png",nil];
                
                isActioning = YES;
                
                //准备动画
                
                CCAnimation *animation = [CCAnimation animationWithNames:array delay:0.2f];
                CCAnimate *amimate = [CCAnimate actionWithAnimation:animation];
                
                CCRepeat *repeat = [CCRepeat actionWithAction:amimate times:2];
                
                CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(rabbitMoveOver)];
                
                CCSequence *sequence = [CCSequence actions:repeat,callback, nil];
                
                [self runAction:sequence];
                
                // 所有屁民回家
                [[GameScene shareInstance].peopleController allPeopleGoHome];
            
            }
        }else {//黑兔
//            if(goRandom >= 50){
//                NSArray *array = [NSArray arrayWithObjects:@"xx01.png",@"xx02.png",@"xx03.png",@"xx04.png",@"xx03.png",@"xx04.png",@"xx03.png",@"xx04.png",@"xx03.png",nil];
//                [self doAction:array delay:0.1 loop:2];
//            }else {
//                NSArray *array = [NSArray arrayWithObjects:@"ys01.png",@"ys02.png",@"ys03.png",@"ys04.png",@"ys05.png",@"ys04.png",@"ys05.png",@"ys04.png",@"ys05.png",nil];
//                [self doAction:array delay:0.1 loop:2];
//            }
            
        }
    }
}

-(void)rabbitMoveOver{
    track();
    isActioning = NO;
    
    CCSpriteFrame *frame ;
    if (level==1) {
        frame = [[CCSpriteFrameCache  sharedSpriteFrameCache] spriteFrameByName:@"rabbit1.png"];
    }else {
        frame = [[CCSpriteFrameCache  sharedSpriteFrameCache] spriteFrameByName:@"rabbit2.png"];
    }

    [self setDisplayFrame:frame];
    
    [self stopAllActions];
}

-(void)rabbit2MoveOver{
    track();
    isActioning = NO;
    self.position = targetPosition;
    
    lastHeiTuPosition = targetPosition;//记住
    
    CCSpriteFrame *frame ;
    frame = [[CCSpriteFrameCache  sharedSpriteFrameCache] spriteFrameByName:@"rabbit2.png"];
    [self setDisplayFrame:frame];
    
    [self stopAllActions];
}

-(void)onExit{
    [self stopAllActions];
    [self unscheduleAllSelectors];
    
    [super onExit];
}

@end
