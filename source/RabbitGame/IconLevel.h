//
//  IconLevel.h
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

@interface IconLevel : EESpriteScaleBtn {
    int levelNum;
    BOOL isopen;
    NSInteger score;
}

@property(nonatomic,assign) int levelNum;

+(id)createSpriteIconByLevelName:(NSInteger)levnum;
    
//-(id)initWithSpriteFrameName:(NSString *)framename andLevelNum:(NSInteger)num;

@end
