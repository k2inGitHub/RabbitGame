//
//  EncryptionConfig.h
//  DaRenXiu
//
//  Created by pai hong on 12-4-24.
//  Copyright (c) 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZipArchive.h"

#define DefaultStep @"1500"
//#define DefaultStep @"10"

@interface EncryptionConfig : NSObject{
    NSString *docmentPath;
    
    NSString *configZipPath;
    NSString *plistpath;
}

+(EncryptionConfig *)shareInstance;

-(id)init;

-(NSMutableDictionary *)getConfig;

-(NSMutableDictionary *)saveConfig:(NSMutableDictionary *)data;

-(void)clearHistoryData;


//加 减 道具
-(void)add_plus_ToolsNumByKey:(NSString *)key num:(NSInteger)n;
//得到达人币
-(NSInteger)getToolsByKey:(NSString *)key;
//加 减 道具
-(void)add_plus_Money:(NSInteger)n;
//得到达人币
-(NSInteger)getMoneyNum;





@end
