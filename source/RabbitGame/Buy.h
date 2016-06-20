//
//  Buy.h
//  RabbitGame
//
//  Created by pai hong on 12-7-4.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "EEMaskSprite.h"
@class MBProgressHUD;

@interface Buy : EEMaskSprite {
    id delegate;
    MBProgressHUD *_hud;
    CCLabelAtlas *label_money;
    CCSprite *dialog;
}

@property (retain) MBProgressHUD *hud;
@property(nonatomic,assign) id delegate;
-(void)add_cut_money:(int)num;

@end
