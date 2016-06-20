//
//  PeopleController.h
//  RabbitGame
//
//  Created by pai hong on 12-7-25.
//  Copyright (c) 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>

@class Link;
@class Grid;
@class People;

@interface PeopleController : NSObject{
    int numx;
    int numy;
    
    float startx;
    float starty;
    
    id delegate;
    
    BOOL isInAllWarlkState;//是否所有小人处在散步状态
    People *peop1;
    People *peop2;
}

@property(nonatomic,assign)id delegate;

-(void)disponse;

-(id)initWithXNum:(int)x YNum:(int)y dele:(id)d;

-(void)createOnePeople:(Grid *)grid;

-(void)allPeopleGoHome;
@end
