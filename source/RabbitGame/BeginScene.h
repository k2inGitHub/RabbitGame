//
//  BeginScene.h
//  RabbitGame
//
//  Created by pai hong on 12-6-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BeginScene : CCLayer {
    
    //每日奖励
    int nDaily;
    CCSprite *dialog;
}

+(CCScene *)scene;

-(int)getHightestScore;

@end
