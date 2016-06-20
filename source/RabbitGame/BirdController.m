//
//  BirdController.m
//  RabbitGame
//
//  Created by pai hong on 12-7-25.
//  Copyright (c) 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "BirdController.h"
#import "Grid.h"
#import "Link.h"
#import "CCAnimationHelper.h"
#import "SoundManagerR.h"

@implementation BirdController

@synthesize delegate;

- (id)initWithDelegate:(id)d;
{
    self = [super init];
    if (self) {
        delegate = d;
    }
    return self;
}

//从Link里面调用，
-(void)flyAbirdFrom:(Grid *)grid{
    NSMutableArray *alllinks =  [NSMutableArray array];
    
    NSMutableArray *grids = [delegate getGrids];
    int len = [grids count];
    for (int i=(len-1); i>=0; i--) {
        NSMutableArray *lines = [grids objectAtIndex:i];
        int count = [lines count];
        for (int a=0; a<count; a++) {
            Grid *curgrid = [lines objectAtIndex:a];
            Link *curlink = curgrid.link;
            
            BOOL issame = CGPointEqualToPoint(curlink.position, grid.link.position);
            if (!issame && curlink.type == Link_Type_House &&(curlink.level==1 ||curlink.level==3 || curlink.level==4)) {
                [alllinks addObject:curgrid];
            }
        }
    }
    
    int findlen = [alllinks count];
    
    if (findlen<=0) { 
        return;
    }
    
    int index =  arc4random() %findlen;
    Grid *togrid = [alllinks objectAtIndex:index];
    
    [self createOneBirdFromGrid:grid toGrid:togrid];
}

//确定了 小鸟从哪里飞到哪里
-(void)createOneBirdFromGrid:(Grid *)fromgrid toGrid:(Grid *)togrid{
    
    //[[SoundManagerR shareInstance] playSound:@"BG3.wav" type:Sound_Type_Action];
    
    CCSprite *bird = [CCSprite spriteWithSpriteFrameName:@"bird01.png"];
    bird.position = fromgrid.position;
            
    CCAnimation *birdanimation = [CCAnimation animationWithFrame:@"bird" frameCount:3 delay:0.2];
    CCAnimate *birdanimat = [CCAnimate actionWithAnimation:birdanimation];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:birdanimat];
    
    [bird runAction:repeat];
    
    float distance = ccpDistance(fromgrid.position, togrid.position);
    float time = distance / 40;
    CCMoveTo *moveto = [CCMoveTo actionWithDuration:time position:togrid.position];
    
    CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(flyover:)];
    
    CCSequence *seq = [CCSequence actions:moveto,callback, nil];
    
    [bird runAction:seq];
    
    //鸟的方向
    if (bird.position.x <= togrid.position.x) {
        bird.scaleX = 1;
    }else {
        bird.scaleX = -1;
    }
    
    [delegate addChild:bird z:80];
    
}

//飞行完毕后  淡出
-(void)flyover:(CCSprite *)sp{
    CCFadeOut *fadeout =[CCFadeOut actionWithDuration:1];
    CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(fadeOutOver:)];
    CCSequence *seq = [CCSequence actions:fadeout,callback, nil];
    [sp runAction:seq];
}

-(void)fadeOutOver:(CCSprite *)sp{
    [sp removeFromParentAndCleanup:YES];
}


-(void)disponse{
    delegate = nil;
}








@end
