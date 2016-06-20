//
//  GameNextSeat.m
//  RabbitGame
//
//  Created by pai hong on 12-6-24.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "GameNextSeat.h"
#import "Link.h"
#import "GameScene.h"
#import "SoundManagerR.h"


@implementation GameNextSeat

@synthesize seatArray;

- (id)init
{
    self = [super init];
    if (self) {
        track();
        seatArray = [[CCArray alloc] init];
        //背景图片
        CCSprite *bgsp = [CCSprite spriteWithSpriteFrameName:@"框.png"];
        [self addChild:bgsp];
        selfSize = bgsp.contentSize;
        
        /*
         1、普通
         2、兔子1.5倍
         3、特殊商店
         4、无仓
         5、没有兔子
         6、月光村，受限
         7、双仓库
         8、冒险岛(无飞天猫)
         */
        
        //草 萝卜 果树 村屋 炸弹 彩虹 兔子 飞兔
        //70  6   5   4   2    2   5    
        
        int level = [Globel shareGlobel].curLevel;
        trace(@"GameNextSeat -------------------------第%d关------------------",level);
        
        if (level == 1 || level == 3|| level == 4|| level == 6|| level == 7) {//普通
            randomArray = [[NSMutableArray alloc] initWithObjects:
                           @"655",//草   
                           @"160", //萝卜 
                           @"50", //果树 
                           @"40", //村屋 
                           @"30", //彩虹 
                           @"10", //炸弹 
                           @"30", //兔子 
                           @"17", //飞兔 
                           @"8", //1级石头 
                           nil]; 
        }else if(level == 2 ){                          //2、兔子1.5倍
            randomArray = [[NSMutableArray alloc] initWithObjects:
                           @"585",//草   
                           @"160", //萝卜 
                           @"50", //果树 
                           @"40", //村屋 
                           @"20", //彩虹 
                           @"20", //炸弹 
                           @"80", //兔子 
                           @"37", //飞兔 
                           @"8", //1级石头 
                           nil]; 
        }else if(level == 5 ){
            randomArray = [[NSMutableArray alloc] initWithObjects:
                           @"645",//草   
                           @"200", //萝卜 
                           @"70", //果树 
                           @"40", //村屋 
                           @"20", //彩虹 
                           @"20", //炸弹 
                           @"0", //兔子 
                           @"17", //飞兔 
                           @"8", //1级石头 
                           nil]; 
        }else if(level == 8 ){
            randomArray = [[NSMutableArray alloc] initWithObjects:
                           @"645",//草   
                           @"170", //萝卜 
                           @"50", //果树 
                           @"40", //村屋 
                           @"20", //彩虹 
                           @"20", //炸弹 
                           @"47", //兔子 
                           @"0", //飞兔 
                           @"8", //1级石头 
                           nil]; 
        }
        
        //读取存档数据,如果有必要的话恢复
        NSMutableArray *historygrids = [[GameScene shareInstance] getLevelConfigDate:@"nextseat"];
        
        if (historygrids!=nil && [historygrids count] != 0) {//说明存在存档数据
            
            NSArray *seats = [[GameScene shareInstance] getLevelConfigDate:@"nextseat"];
            for (int a=0; a<[seats count]; a++) {
                NSDictionary *recodGrid = [seats objectAtIndex:a];
                
                Link_Type type = [[recodGrid objectForKey:@"type"] intValue];
                int level = [[recodGrid objectForKey:@"level"] intValue];
                BOOL issuper = [[recodGrid objectForKey:@"issuper"] boolValue];
                
                if (type==Link_Type_Wall) {//是墙壁的话，初始化的时候已经执行，这里了就不需要了
                    continue;
                }
                
                //创建对应的link，并且加入array
                Link *link = [Link createByType:type andLelve:level issuper:issuper];
                
                [seatArray addObject:link];                
                trace(@"%@,  %d",seatArray,[seatArray count]);
            }
        }
        trace(@"%@,  %d",seatArray,[seatArray count]);
        
        [self scheduleUpdate];
    }
    return self;
}
//得到一些数据
-(void)update:(ccTime)delta{
    [self unscheduleAllSelectors];
    
}

-(NSInteger)getWitch{
    int random = (arc4random() % 1000 +1);
    //random = 999;
    trace(@"得到的随机值： %d",random);
    int len = [randomArray count];
    for (int i=(len-1); i>=0; i--) {
        int all = 0;
        for (int a=0; a<=i ; a++) {
            all += [[randomArray objectAtIndex:a] intValue];
        }
        if (random==all) {
            return i;
        }
        if (random>all) {
            return (i+1);
        }
    }
    return 0;
}

-(Link *)generateLink:(int)target{    
    Link *link;
    if (target==0) {
        link = [Link createByType:Link_Type_House andLelve:1];
    }else if(target==1){
        link = [Link createByType:Link_Type_House andLelve:2];
    }else if(target==2){
        link = [Link createByType:Link_Type_House andLelve:3];
    }else if(target==3){
        link = [Link createByType:Link_Type_House andLelve:4];
    }else if(target==4){
        link = [Link createByType:Link_Type_Tool andLelve:1];
        [[SoundManagerR shareInstance] playSound:@"彩虹出现.wav" type:Sound_Type_Action];
    }else if(target==5){
        int s = [[GameScene shareInstance] getGameScore];
        if (s<20000) {//小于20000分，炸弹出现几率减少一倍
            int r = arc4random() % 10;
            if (r<5) {
                link = [Link createByType:Link_Type_Tool andLelve:2];
                [[SoundManagerR shareInstance] playSound:@"炸弹出现.wav" type:Sound_Type_Action];
            }else {
                link = [Link createByType:Link_Type_House andLelve:1];  
            }   
        }else {
            link = [Link createByType:Link_Type_Tool andLelve:2];
            [[SoundManagerR shareInstance] playSound:@"炸弹出现.wav" type:Sound_Type_Action];
        }
    }else if(target==6){
        link = [Link createByType:Link_Type_Rabbit andLelve:1];
        [[SoundManagerR shareInstance] playSound:@"白兔子出现.wav" type:Sound_Type_Action];
    }else if(target==7){//黑兔
        int s = [[GameScene shareInstance] getGameScore];
        if ( s <= 500000 ) {//如果没有到50w分，就不刷新黑兔,改成刷新小草
            link = [Link createByType:Link_Type_House andLelve:1];   
        }else {
            link = [Link createByType:Link_Type_Rabbit andLelve:2];
            [[SoundManagerR shareInstance] playSound:@"恶魔兔子出现.mp3" type:Sound_Type_Action];
        }
    }else if(target==8){
        link = [Link createByType:Link_Type_Stone andLelve:1];//石头
    }
    return link;
}


#pragma mark ---显示当前第一个物体---
-(void)showCurrent{
    Link *link = [seatArray objectAtIndex:0];
    CGSize linksize = link.contentSize;
    trace(@"%f %f",linksize.width,linksize.height);
    
    //变小点，要不然框子撑不下
    //link.scale = 0.8;
    link.scale = 0.1;
    [self addChild:link];
    
    //从小到大的动画
    CCScaleTo *scale = [CCScaleTo actionWithDuration:0.3 scale:1.0];
    CCEaseBackInOut *s = [CCEaseBackInOut actionWithAction:scale];
    [link runAction:s];
    
    
    //显示 3 +3 = ？
    [[GameScene shareInstance] showCurrentLinkInfor:link];

    
    //[gameassitant showCurrentLinkInfor:[gamenextseat getLink]];
}
-(void)removeCurrent{
    if ([seatArray count]==0) {
        return;
    }
    Link *link = [seatArray objectAtIndex:0];
    [seatArray removeObjectAtIndex:0];
    
    [link retain];
    [link removeFromParentAndCleanup:NO];
    
}

#pragma mark ----给主GameScene，供给物体---
-(Link *)getLink{
    if (seatArray==nil || [seatArray count]<=0) {
        return nil;
    }
    
    Link *link = [seatArray objectAtIndex:0];
    return link;
}

#pragma mark ---生成下一个物体---
//生成指定的物体
-(void)generateNext:(Link_Type )type :(int)level :(BOOL)issuper{
    //删除当前的
    [self removeCurrent];
    
    //如果预选择框存在的话，则清楚
    [[GameScene shareInstance] purgeTouchCanvas];

    //根据序号得到物体
    Link *link = [Link createByType:type andLelve:level issuper:issuper];

    //把生成的物体加入到物体队列中，第一位
    [seatArray insertObject:link atIndex:0];
    //显示
    [self showCurrent];
    
}

-(void)generateNext{
    //游戏结束的话，则不生成
    if ([GameScene shareInstance].isGameOver) {
        return;
    }
    track();
    //如果预选择框存在的话，则清楚
    [[GameScene shareInstance] purgeTouchCanvas];
    
    //删除当前的
    [self removeCurrent];
    //如果数组长度不为0，说明队列中还存在，这种情况一般是在商店里面购买了东西
    trace(@"%@,  %d",seatArray,[seatArray count]);
    if ([seatArray count] != 0) {//不用生成，直接显示
        //显示 
        [self showCurrent];
        return;
    }
    //得到随机的序号
    int target = [self getWitch];
    trace(@"随机物体序号： %d",target);
    //根据序号得到物体
    Link *link = [self generateLink:target];
    if (link==nil) {
        trace(@"_____________link____nil------------");
    }
    //把生成的物体加入到物体队列中，第一位
    [seatArray insertObject:link atIndex:0];
    //显示
    [self showCurrent];
}

#pragma mark ---插入新的物种---
-(void)insertNewLinkIn:(Link *)link{
    //从场景中移出当前的
    for (id l in [self children]) {
        if ([l isKindOfClass:[Link class]]) {
            [(Link *)l removeFromParentAndCleanup:YES];
        }
    }
    //插入
    [seatArray insertObject:link atIndex:0];
    [self showCurrent];
}

//替换link
-(void)replaceLink:(Link *)link{
    [self removeCurrent];
    //把生成的物体加入到物体队列中，第一位
    [seatArray insertObject:link atIndex:0];
    //显示
    link.position = ccp(0,0);
    //[self showCurrent];
    [self addChild:link];
    
    //显示 3 +3 = ？
    [[GameScene shareInstance] showCurrentLinkInfor:link];
}

-(void)onExit{
    [seatArray release];
    [randomArray release];
    
    [super onExit];
}


@end
