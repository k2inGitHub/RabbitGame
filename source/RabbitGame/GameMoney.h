//
//  GameMoney.h
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
#import "EESpriteScaleBtn.h"

@interface GameMoney : EESpriteScaleBtn {
    CCLabelAtlas *moneyLabel;
    int money;
}

-(void)add_cut_money:(int)m;
-(int)getMoney;
-(void)refresh;

@end
