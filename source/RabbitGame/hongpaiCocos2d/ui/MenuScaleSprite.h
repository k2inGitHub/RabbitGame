//
//  MenuScaleSprite.h
//  DaRenXiuTianCai
//
//  Created by pai hong on 12-5-8.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MenuScaleSprite : CCMenuItemSprite {
    float originalScale_;
    BOOL isHightLight;
    BOOL isDisable;
}
-(void)setHightLight:(BOOL)b;
-(void)setDisabel:(BOOL)b;

-(BOOL)getIsHightLight;
@end
