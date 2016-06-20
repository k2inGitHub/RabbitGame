//
//  MenuScaleImage.h
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

@interface MenuScaleImage : CCMenuItemImage {
    //记录默认的缩放大小
    float originalScale_;
}

-(void)setHight:(BOOL)b;

@end
