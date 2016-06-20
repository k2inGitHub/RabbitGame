//
//  DelegateAssitant.m
//  RabbitGame
//
//  Created by pai hong on 12-7-2.
//  Copyright (c) 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "DelegateAssitant.h"
#import "GameStep.h"
#import "GameScene.h"
#import "EncryptionConfig.h"

@implementation DelegateAssitant

-(void)applicationEnterBack{
    //记录数据
    [[GameStep shareInstance] rememberLevelTime];
    [[GameScene shareInstance] rememberNecessaryWhenBack];
    trace(@"%@",[Globel shareGlobel].allDataConfig);
    
    
    //保存用户所有数据
    [[EncryptionConfig shareInstance] saveConfig:[Globel shareGlobel].allDataConfig];
}

-(void)applicationEnterFront{
    [[GameStep shareInstance] addRemenberTimeStep];
}

@end
