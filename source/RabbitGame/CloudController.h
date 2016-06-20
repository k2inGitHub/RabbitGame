//
//  CloudController.h
//  RabbitGame
//
//  Created by pai hong on 12-8-3.
//  Copyright (c) 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CloudController : NSObject{
    id delegate;
}

- (id)initWithDelegate:(id)d;
- (void)disponse;

@property(nonatomic,assign)id delegate;


@end
