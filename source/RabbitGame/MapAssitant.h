//
//  MapAssitant.h
//  RabbitGame
//
//  Created by pai hong on 12-7-24.
//  Copyright (c) 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>

@class WorldMapScene;

@interface MapAssitant : NSObject{
    NSArray *animalPosition;
    
    WorldMapScene *delegate;
}

-(id)initWithMap:(WorldMapScene *)worldmap;

@end
