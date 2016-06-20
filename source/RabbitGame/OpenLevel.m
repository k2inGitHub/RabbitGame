//
//  OpenLevel.m
//  RabbitGame
//
//  Created by pai hong on 12-7-10.
//  Copyright (c) 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "OpenLevel.h"
#import "GameScene.h"

@implementation OpenLevel


+(OpenLevel *)shareInstance{
    static OpenLevel *instance = nil;
    @synchronized(self){
        if (!instance) {
            instance = [[OpenLevel alloc] init];
        }
    }   
    return instance;
}



-(void)open:(int)level{
    
    NSString *levelstr = [NSString stringWithFormat:@"level_%d",level];
    BOOL isopen = [[[[Globel shareGlobel].allDataConfig objectForKey:levelstr] objectForKey:@"isopen"] boolValue];
    
    if (isopen) {
        return;
    }
    [[[Globel shareGlobel].allDataConfig objectForKey:levelstr] setValue:[NSNumber numberWithBool:YES] forKey:@"isopen"];
    trace(@"%@",[Globel shareGlobel].allDataConfig);
}

//第2关开启 10只兔子
-(void)openLevel2{
    [self open:2];
}

//第3关开启 买光所有的草 树 屋
-(void)openLevel3{
    
    [self open:3];
}

//第4关开启 无仓村  30W分
-(void)openLevel4{
    
    [self open:4];
}

//第5关开启 北极村  不到2000
-(void)openLevel5{
    
    [self open:5];
}

//第6关开启 月光村  60w
-(void)openLevel6{
    
    [self open:6];
}

//第7关开启 滨海村  100w
-(void)openLevel7{
    
    [self open:7];
}

//第8关开启 冒险岛  150w
-(void)openLevel8{
    
    [self open:8];
}


@end
