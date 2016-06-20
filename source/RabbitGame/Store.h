//
//  Store.h
//  RabbitGame
//
//  Created by pai hong on 12-7-3.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "EEMaskSprite.h"
#import "AdUnlockListener.h"

@interface Store : EEMaskSprite {
    CCLabelAtlas *label_dashu;
    CCLabelAtlas *label_luobo;
    CCLabelAtlas *label_luobomiao;
    CCLabelAtlas *label_bom;
    CCLabelAtlas *label_colorball;
    
    CCLabelAtlas *label_fangwu;
    
    CCLabelAtlas *label_money;
    
    CCSprite *dialog;
}

@property (nonatomic, retain) AdUnlockListener *adUnlock;

-(void)refeshMoney;
-(NSString *)getStoreNum:(NSString *)type;

-(int)getLeftStore:(NSString *)type;

@end
