//
//  BirdController.h
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


@interface BirdController : NSObject{
    id delegate;
}

@property(nonatomic,assign)id delegate;

- (id)initWithDelegate:(id)d;

-(void)flyAbirdFrom:(Grid *)grid;
-(void)createOneBirdFromGrid:(Grid *)fromgrid toGrid:(Grid *)togrid;

-(void)disponse;

@end
