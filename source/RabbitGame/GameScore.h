//
//  GameScore.h
//  RabbitGame
//
//  Created by pai hong on 12-6-22.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameScore : CCSprite {
    CCLabelAtlas *scoreLabel;

    int score;
}

-(void)add_cut_score:(int)s;
-(int)getScore;
-(void)set_score:(int)sc;
@end
