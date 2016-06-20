//
//  EESpriteBtn.h
//  RabbitGame
//
//  Created by pai hong on 12-6-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EESpriteBtn : CCSprite <CCTargetedTouchDelegate>{
    id delegate;   
    SEL callback;
    
    BOOL isTouched;//是否触发事件
}

@property(nonatomic,assign)BOOL isTouched;

-(void)doTheCallBack;

-(void)addEETarget:(id)sender selector:(SEL)sel;

-(void)touchDown;

-(void)touchUp;

@end
