//
//  LoadingScene.m
//  RabbitGame
//
//  Created by pai hong on 12-6-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoadingScene.h"
#import "WorldMapScene.h"
#import "GameScene.h"

@interface LoadingScene(private)
-(id) initWithTargetScene:(TargetScenes)targetScene;
@end

@implementation LoadingScene

+(CCScene *)scene{
    CCScene *s = [CCScene node];
    
    LoadingScene *m = [LoadingScene node];
    [s addChild:m];
    
    
    return s;
}

+(id) sceneWithTargetScene:(TargetScenes)targetScene
{
    // 以下代码生成了一个当前类的自动释放对象 (self == LoadingScene) 
    return [[[self alloc] initWithTargetScene:targetScene] autorelease];
}

-(id) initWithTargetScene:(TargetScenes)targetScene
{
    {
        if ((self = [super init]))
            targetScene_ = targetScene;
        
        CCSprite *bgsprite = [CCSprite spriteWithFile:@"loading.png"];
        bgsprite.position = ccp(SSSW*0.5,SSSH*0.5);
        [self addChild:bgsprite];
        
        
        CCSprite *rabbit = [CCSprite spriteWithFile:@"loading_rabbit.png"];
        rabbit.position = ccp(SSSW*0.5,SSSH*0.5);
        [self addChild:rabbit];
        
        int random = (arc4random()%360);
        //float r = random* 0.01f;
        [rabbit setRotation: random];
        
        
        
        
        CCRotateBy *rotate = [CCRotateBy actionWithDuration:1.5 angle:180];
//        CCRepeatForever *repeat = [CCRepeatForever actionWithAction:rotate];
//        
        CCScaleTo *scalto = [CCScaleTo actionWithDuration:1.5 scale:0];
        
        CCSpawn *allaction = [CCSpawn actions:rotate,scalto, nil];
        
        [rabbit runAction:allaction];

        // 必须在下一帧才加载目标场景! [self scheduleUpdate];
        [self schedule:@selector(start) interval:1];
    }
    return self;
}

//-(void)update:(ccTime)delta{
-(void)start{
    [self unscheduleAllSelectors];
    
    // 通过TargetScenes这个枚举类型来决定加载哪个场景 
    switch (targetScene_)
    {
    case TargetScene_worldmap:
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[WorldMapScene scene]]];
        break;
    case TargetScenes_gamescen:
        [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
        break;
            
    case TargetScenes_course:
        //[[CCDirector sharedDirector] replaceScene:[GameScene_Course scene]];
        [Globel shareGlobel].isInCourse = YES;
        [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
        break;
    default:
        // 如果使用了没有指定的枚举类型,发出警告信息 
            NSAssert2(nil, @"%@: unsupported TargetScene %i", NSStringFromSelector(_cmd), targetScene_);
        break;
    }
}


@end
