//
//  LoadingScene.h
//  RabbitGame
//
//  Created by pai hong on 12-6-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum{
    TargetScene_worldmap = 0,
    TargetScenes_gamescen,
    TargetScenes_course
}TargetScenes;

@interface LoadingScene : CCLayer {
    TargetScenes targetScene_;
}

+(id) sceneWithTargetScene:(TargetScenes)targetScene;

+(CCScene *)scene;

@end
