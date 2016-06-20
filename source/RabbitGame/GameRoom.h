//
//  GameRoom.h
//  RabbitGame
//
//  Created by pai hong on 12-7-2.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "EESpriteBtn.h"

#import "Link.h"

@interface GameRoom : EESpriteBtn {
    Link *storeLink;
    
    //v1.2
    CCSprite *dishes;
    bool locked;
    int roomId;
}
@property(nonatomic, assign)bool locked;
@property(nonatomic, assign)int roomId;

-(BOOL)isEmpty;

-(void)pushLinkToStore:(Link *)link;

-(Link *)deleteLinkFromStore;

-(Link *)getStoreLink;

- (void)unlock:(bool)unlock;
@end
