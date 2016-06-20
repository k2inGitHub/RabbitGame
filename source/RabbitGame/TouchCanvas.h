//
//  TouchCanvas.h
//  RabbitGame
//
//  Created by pai hong on 12-6-25.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Link;

@interface TouchCanvas : CCNode {
    
}

+(id)createByLink:(Link *)link;

@end
