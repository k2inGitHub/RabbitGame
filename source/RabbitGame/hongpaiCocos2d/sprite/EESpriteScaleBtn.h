//
//  EESpriteScaleBtn.h
//  RabbitGame
//
//  Created by pai hong on 12-6-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "EESpriteBtn.h"


@interface EESpriteScaleBtn : EESpriteBtn {
    BOOL isMoving;
    
    float originalScale_;
    
    BOOL isSendEventWhenActionOver;
    
    BOOL isClickValid;

    id link;
    
}
@property(nonatomic,assign) id link;

@property(nonatomic,assign)BOOL isSendEventWhenActionOver;

@property (nonatomic, assign) BOOL alwaysScale;

-(void)setHight:(BOOL)b;
@end
