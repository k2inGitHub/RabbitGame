//
//  GameCourse.h
//  RabbitGame
//
//  Created by pai hong on 12-6-23.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "EEMaskSprite.h"

@class EESpriteScaleBtn;


@interface GameHelp : EEMaskSprite {
    int curIndex;
    EESpriteScaleBtn *btn_return;
    EESpriteScaleBtn *btn_nextpage;
    CCSprite *sp_content;
}

+ (void)autoscale:(CCSprite*)sprite;

@end
