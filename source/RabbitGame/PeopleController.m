//
//  PeopleController.m
//  RabbitGame
//
//  Created by pai hong on 12-7-25.
//  Copyright (c) 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "PeopleController.h"
#import "People.h"
#import "Grid.h"
#import "Link.h"
#import "SoundManagerR.h"

#define timeMother 20

@implementation PeopleController

@synthesize delegate;

-(id)initWithXNum:(int)x YNum:(int)y dele:(id)d{
    track();
    self = [super init];
    if (self) {
        delegate = d;
        
        numx = x;
        numy = y;
        
        Grid *grid = [[[delegate getGrids] objectAtIndex:0] objectAtIndex:0];
        startx = grid.position.x - 25;
        starty = grid.position.y - 25;
        
        //[self registGoToOnePositionListener];
        
        [self registTalkingListener];
    }
    return self;
}

-(void)registGoToOnePositionListener{
    int random = arc4random() % 200;
    int time = 30 +random;
    //time = 40;
    [self performSelector:@selector(allPeopleGoHome) withObject:nil afterDelay:time];
    
    trace(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!去哪个位置：%d",time);
}

-(void)createOnePeople:(Grid *)grid{
    track();
    Link *link = grid.link;
    if (link.isCreatedPeople) {
        return;
    }
    
    People *peop = [People create];
    peop.anchorPoint = ccp(0.5,0);
    peop.pgrid = grid;
    peop.link = link;
    //peop.opacity = 0;
    peop.position = ccp(grid.position.x,grid.position.y-10);
    //[peop.texture setAliasTexParameters];
    
    link.isCreatedPeople = YES;
    
    [delegate addChild:peop z:79];
    
    [self runAction_goOutHome:peop];
}


#pragma mark ----抬头看条动作----
-(void)doTaitoukantianAction:(People *)peop{
    track();
    [peop act_kantian];
}


#pragma mark ----小人的动画阶段  出门----
//创建-->出门
-(void)runAction_goOutHome:(People *)peop{
    track();
    if (peop.link==nil || peop.link.parent==nil) {    
        //移出场景
        [peop removeFromParentAndCleanup:YES];
        return;
    }
    
    peop.opacity = 255;
    float oldy = peop.position.y;
    CCMoveTo *moveto3 = [CCMoveTo actionWithDuration:0.8 position:ccp(peop.position.x,peop.pgrid.position.y-25)];
    CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(goouthomeover:)];
    
    CCSequence *seq = [CCSequence actions:moveto3, callback,nil];
    
    [peop act_worlk];
    [peop runAction:seq];
    
}


-(void)goouthomeover:(People *)peop{
    track();
    [peop stopAllActions];
    
    int a = arc4random() % 10;
    a = 1;
    if (a<3) {//3分之1的
        [self performSelector:@selector(doTaitoukantianAction:) withObject:peop afterDelay:0.5];
        [self performSelector:@selector(runAction_goOnePosition:) withObject:peop afterDelay:3];        
        //搔首弄姿
    }else {
        [self runAction_goOnePosition:peop];
    }
    
}

#pragma mark ----小人的动画阶段  移动到某点----

//随机运动到某点
-(void)runAction_goOnePosition:(People *)peop{
    track();
    
    if (peop.link==nil || peop.link.parent==nil) {
        
        //移出场景
        [self worlkDisapplearFromScene:peop];
        
        return;
    }
    
    int randomx = arc4random() % (numx+1);
    int randomy = arc4random() % (numy+1);
    
    float targetX = startx+randomx*50;
    float targetY = starty+randomy*50;
    
    CGPoint point = peop.position;
    
    CGPoint toPoint1 ;
    
    //int a = arc4random() % 10;
    //if (a<=4) {
    //    toPoint1 = ccp(point.x,targetY);
    //}else {
        toPoint1 = ccp(targetX,point.y);
    //}
    
    trace(@"%f %f %f %f",peop.position.x,peop.position.y,targetX,point.y);
    
    float distance1 = ccpDistance(point, toPoint1);
    float time1 = distance1 / timeMother;
    
    float distance2 = ccpDistance(toPoint1, ccp(targetX, targetY));
    float time2 = distance2 / timeMother;    
    
    CCMoveTo *moveto1 = [CCMoveTo actionWithDuration:time1 position:toPoint1];
    CCMoveTo *moveto2 = [CCMoveTo actionWithDuration:time2 position:ccp(targetX,targetY)];
    
    CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(twoStepMoveOver:)];
    
    CCSequence *seq = [CCSequence actions:moveto1,moveto2,callback, nil];
    
    [peop act_worlk];
    [peop runAction:seq];
}

-(void)twoStepMoveOver:(People *)peop{
    track();
    [peop stopAllActions];
    [peop resetDisplay];
    
    if (peop.isGoingToTalk) {
        
        [self gotoTalkPosition:peop];
        return;
    }
    
    int a = arc4random() % 10;
    a = 1;
    if (a<5) {//3分之1的
        [self performSelector:@selector(doTaitoukantianAction:) withObject:peop afterDelay:0.5];
        [self performSelector:@selector(runAction_goOnePosition:) withObject:peop afterDelay:3];        
        //搔首弄姿
    }else {
        [self runAction_goOnePosition:peop];
    }
    

}



#pragma mark ---移出场景  走出----
-(void)worlkDisapplearFromScene:(People *)peop{
    track();
    //淡出场景
    [peop resetDisplay];
    
    CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:0.4];
    CCCallFuncN *callback1 = [CCCallFuncN actionWithTarget:self selector:@selector(worlkDisapplearOver:)];
    CCSequence *seq1 = [CCSequence actions:fadeOut,callback1, nil];
    [peop runAction:seq1];
    
    return;
    
    //移出场景
    CGPoint point = peop.position;
    
    int a = arc4random()%100;
    if (a<=50) {
        point.x = -20;
    }else {
        point.x = 340;
    }
    
    float distance2 = ccpDistance(peop.position, point);
    float time2 = distance2 / timeMother;    
    
    CCMoveTo *moveto2 = [CCMoveTo actionWithDuration:time2 position:point];
    
    CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(worlkDisapplearOver:)];
    
    CCSequence *seq = [CCSequence actions:moveto2,callback, nil];
    
    [peop act_worlk];
    [peop runAction:seq];
}

-(void)worlkDisapplearOver:(People *)peop{
    
    track();
    [peop stopAllActions];
    [peop removeFromParentAndCleanup:YES];
}

#pragma mark ---移出场景  跑出----
-(void)runDisapplearFromScene:(People *)peop{
    track();
    
    CGPoint point = peop.position;
    
    int a = arc4random()%100;
    if (a<=50) {
        point.x = -20;
    }else {
        point.x = 340;
    }
    
    float distance2 = ccpDistance(peop.position, point);
    float time2 = distance2 / timeMother * 2;    
    
    CCMoveTo *moveto2 = [CCMoveTo actionWithDuration:time2 position:point];
    
    CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(rundisapplearOver:)];
    
    CCSequence *seq = [CCSequence actions:moveto2,callback, nil];
    
    [peop act_worlk];
    [peop runAction:seq];
}

-(void)rundisapplearOver:(People *)peop{
    track();
    [peop stopAllActions];
    [peop removeFromParentAndCleanup:YES];
}




#pragma mark ----所有的小人，回家! ----
-(void)onePeopleGoHome:(People *)peop{
    track();
    if (peop.link==nil || peop.link.parent==nil) {
        //移出场景
        peop.isUnValid = YES;
        [self runDisapplearFromScene:peop];
        return;
    }
    
    int tx = peop.pgrid.x;
    int ty = peop.pgrid.y;
    
    float targetX = startx+tx*50 + 25;
    float targetY = starty+ty*50;
    
    CGPoint lastpoint = ccp(peop.pgrid.position.x,peop.pgrid.position.y-10);
    
    
    CGPoint point = peop.position;
    
    CGPoint toPoint1 ;
    
    //int a = arc4random() % 10;
    //if (a<=4) {
    //    toPoint1 = ccp(point.x,targetY);
    //}else {
    toPoint1 = ccp(point.x,targetY);
    //}
    
    trace(@"%f %f %f %f",peop.position.x,peop.position.y,targetX,point.y);
    
    float distance1 = ccpDistance(point, toPoint1);
    float time1 = distance1 / timeMother*0.3;
    
    float distance2 = ccpDistance(toPoint1, ccp(targetX, targetY));
    float time2 = distance2 / timeMother*0.3;  
    
    float distnce3 = 25;
    float time3 = distnce3 / timeMother*0.3;
    
    CCMoveTo *moveto1 = [CCMoveTo actionWithDuration:time1 position:toPoint1];
    CCMoveTo *moveto2 = [CCMoveTo actionWithDuration:time2 position:ccp(targetX,targetY)];
    CCMoveTo *moveto3 = [CCMoveTo actionWithDuration:time3 position:lastpoint];
    
    CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(goHomeStepRunOver:)];
    
    CCSequence *seq = [CCSequence actions:moveto1,moveto2,moveto3,callback, nil];
    
    [peop act_run];
    [peop runAction:seq];

}


//回家结束
-(void)goHomeStepRunOver:(People *)peop{
    track();
    [peop stopAllActions];    
    peop.opacity = 0;
    
    [peop resetBoolsState];
    
    //一定时间后，再次出门
    int time = 3+arc4random() % 4;
    [self performSelector:@selector(runAction_goOutHome:) withObject:peop afterDelay:time];
}
 
//全部回家
-(void)allPeopleGoHome{
    track();
    trace(@"%@",delegate);
    
    
    int index =  arc4random() %2 + 1;
    NSString *sound = [NSString stringWithFormat:@"se_charascream%d.wav", index];
    [[SoundManagerR shareInstance] playSound:sound type:Sound_Type_Action];
    
    //不在散步状态
    isInAllWarlkState = NO;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    CCArray *array = [delegate children];
    for (int i=0; i<[array count]; i++) {
        id ob = [array objectAtIndex:i];
        if ([ob isKindOfClass:[People class]]) {
            People *peop = (People *)ob;
            [peop stopAllActions];
            [self onePeopleGoHome:peop];
        }
    }
    
    //[self registGoToOnePositionListener];
    //
    [self registTalkingListener];
}


#pragma mark ----交谈-----
-(CCArray *)randomArray:(CCArray *)array{
    track();
    
    for (int x = 0; x < [array count]; x++) {
        int randInt = (arc4random() % ([array count] - x)) + x;
        
        [array exchangeObjectAtIndex:x withObjectAtIndex:randInt];
    }
    return array;
}
-(void)registTalkingListener{
    track();
    int random = arc4random() % 30;
    int time = 30 +random;
    //time = 10;
    [self performSelector:@selector(selectPeopleToTalk) withObject:nil afterDelay:time];
}

-(void)selectPeopleToTalk{
    track();
    CCArray *array = [delegate children];
    CCArray *peoparray = [CCArray array];
    for (int i=0; i<[array count]; i++) {
        id ob = [array objectAtIndex:i];
        if ([ob isKindOfClass:[People class]]) {
            People *peop = (People *)ob;
            if ( (peop.link!=nil && peop.link.parent!=nil) && !peop.isUnValid &&peop.opacity != 0 && !peop.isGoingToTalk) {
                
                [peoparray addObject:peop];
            }
        }
    }
    
    if ([peoparray count]<=1) {
        return;
    }
    peoparray = [self randomArray:peoparray];
    
    //得到前2个people
    peop1 = [peoparray objectAtIndex:0];
    peop2 = [peoparray objectAtIndex:1];
    
    peop1.isGoingToTalk = YES;
    peop2.isGoingToTalk = YES;
    
    
    //生成2个随机的点
    int randomx = arc4random() % (numx);
    int randomy = arc4random() % (numy+1);
    
    float targetX = startx+randomx*50;
    float targetY = starty+randomy*50;
    
    CGPoint point1 = ccp(targetX,targetY);
    CGPoint point2 = ccp(targetX+20,targetY);
    
    peop1.talkPosition = point1;
    peop2.talkPosition = point2;
    
    
    trace(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!找到2个小人！%d %d %d %d",peop1.pgrid.x,peop1.pgrid.y,peop2.pgrid.x,peop2.pgrid.y);
    /*

     */
}


//到交谈的坐标
-(void)gotoTalkPosition:(People *)peop{
    track();
    
    
    float targetX = peop.talkPosition.x;
    float targetY = peop.talkPosition.y;
    
    CGPoint point = peop.position;
    
    CGPoint toPoint1 ;
    
    //int a = arc4random() % 10;
    //if (a<=4) {
    //    toPoint1 = ccp(point.x,targetY);
    //}else {
    //toPoint1 = ccp(targetX,point.y);
    toPoint1 = ccp(point.x,targetY);
    //}
    
    trace(@"%f %f %f %f",peop.position.x,peop.position.y,targetX,point.y);
    
    float distance1 = ccpDistance(point, toPoint1);
    float time1 = distance1 / timeMother;
    
    float distance2 = ccpDistance(toPoint1, ccp(targetX, targetY));
    float time2 = distance2 / timeMother;    
    
    CCMoveTo *moveto1 = [CCMoveTo actionWithDuration:time1 position:toPoint1];
    CCMoveTo *moveto2 = [CCMoveTo actionWithDuration:time2 position:ccp(targetX,targetY)];
    
    CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(talkToMoveOver:)];
    
    CCSequence *seq = [CCSequence actions:moveto1,moveto2,callback, nil];
    
    [peop act_worlk];
    [peop runAction:seq];
}

//移动到了交谈的位置
-(void)talkToMoveOver:(People *)peop{
    track();
    [peop stopAllActions];
    [peop resetDisplay];
    
    peop.isReachTalkingPlace = YES;
    
    if (peop1.isReachTalkingPlace && peop2.isReachTalkingPlace) {
        [self startTalking];
    }
}


//开始交谈
-(void)startTalking{
    track();
    trace(@"开始交谈");
    [self performSelector:@selector(people1Talk) withObject:nil afterDelay:0];
    [self performSelector:@selector(people2Talk) withObject:nil afterDelay:3];
    
    [self performSelector:@selector(people1Talk) withObject:nil afterDelay:7];
    [self performSelector:@selector(people2Talk) withObject:nil afterDelay:10];
    
    [self performSelector:@selector(people1Talk) withObject:nil afterDelay:13];
    [self performSelector:@selector(talkOver) withObject:nil afterDelay:16];
    
    
    //[self performSelector:@selector(people1Talk) withObject:nil afterDelay:6.0];
    //[self performSelector:@selector(talkOver) withObject:nil afterDelay:7.6];
    
}

-(void)people1Talk{
    trace(@"people1 说话！！！！！！！！！！！！！！！！！！！");
    [peop1 act_talk];
    [peop2 stopAllActions];
    [peop2 resetDisplay];
}
-(void)people2Talk{
    trace(@"people2 说话！！！！！！！！！！！！！！！！！！！");
    [peop2 act_talk];
    [peop1 stopAllActions];
    [peop1 resetDisplay];
}
-(void)talkOver{
    [self people2Talk];
    [self performSelector:@selector(peopleStartMove) withObject:nil afterDelay:3];
}

-(void)peopleStartMove{
    trace(@"完成说话了   ！！！！！！！！！！！！！！！！！！");
    [self runAction_goOnePosition:peop1];
    [self runAction_goOnePosition:peop2];
    
    [peop1 resetBoolsState];
    [peop2 resetBoolsState];
    
    peop1 = nil;
    peop2 = nil;
    //
    [self registTalkingListener];
}

-(void)disponse{
    track();
    
    CCArray *array = [delegate children];
    for (int i=0; i<[array count]; i++) {
        id ob = [array objectAtIndex:i];
        if ([ob isKindOfClass:[People class]]) {
            People *peop = (People *)ob;
            [peop stopAllActions];
            [peop removeFromParentAndCleanup:YES];
        }
    }
    delegate = nil;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

-(void)dealloc{
    track();
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [super dealloc];
}







     
          




@end
