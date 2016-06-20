//
//  GameNextSeat.h
//  RabbitGame
//
//  Created by pai hong on 12-6-24.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Link.h"


@interface GameNextSeat : CCSprite {
    //概率数组
    NSMutableArray *randomArray;
    
    CCArray *seatArray; //队列
    
    CGSize selfSize;
}

@property(nonatomic,assign) CCArray *seatArray; //队列

-(Link *)generateLink:(int)target;

-(void)generateNext:(Link_Type )type :(int)level :(BOOL)issuper;
-(void)generateNext;
-(Link *)getLink;
-(void)replaceLink:(Link *)link;
-(void)insertNewLinkIn:(Link *)link;

@end
