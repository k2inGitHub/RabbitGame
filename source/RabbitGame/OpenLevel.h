//
//  OpenLevel.h
//  RabbitGame
//
//  Created by pai hong on 12-7-10.
//  Copyright (c) 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenLevel : NSObject

+(OpenLevel *)shareInstance;

//第2关开启 10只兔子
-(void)openLevel2;
//第3关开启 买光所有的草 树 屋
-(void)openLevel3;
//第4关开启 无仓村  30W分
-(void)openLevel4;
//第5关开启 北极村  不到2000
-(void)openLevel5;
//第6关开启 月光村  60w
-(void)openLevel6;
//第7关开启 滨海村  100w
-(void)openLevel7;
//第8关开启 冒险岛  150w
-(void)openLevel8;
@end
