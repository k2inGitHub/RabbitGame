//
//  GameOver.h
//  RabbitGame
//
//  Created by pai hong on 12-7-5.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "EEMaskSprite.h"
#import "EEAnimateLabel.h"
#import "EESpriteScaleBtn.h"


@interface GameOver : EEMaskSprite {
    EEAnimateLabel *allscore;
    
    EEAnimateLabel *houselevel;
    EEAnimateLabel *house6;
    EEAnimateLabel *house7;
    EEAnimateLabel *house8;
    EEAnimateLabel *house9;
    
    EEAnimateLabel *stepcount;
    EEAnimateLabel *stepscore;
    
    EEAnimateLabel *prizeMoney;
    
    EESpriteScaleBtn *spriteVideo;
    
    int prizeint;
}

@end
