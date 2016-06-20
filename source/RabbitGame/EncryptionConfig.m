//
//  EncryptionConfig.m
//  DaRenXiu
//
//  Created by pai hong on 12-4-24.
//  Copyright (c) 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//


/*
    配置文件 加密类
 */
#import "EncryptionConfig.h"
#import "HLService.h"

#define password @"123123123123123g#"

@implementation EncryptionConfig


+(EncryptionConfig *)shareInstance{
    static EncryptionConfig *instance = nil;
    @synchronized(self){
        if (!instance) {
            instance = [[EncryptionConfig alloc] init];
        }
    }   
    return instance;
}

-(BOOL)fileIsExist{
    NSFileManager *filemanage = [NSFileManager defaultManager];
    BOOL b = [filemanage fileExistsAtPath:configZipPath];
    if (b) {
        NSLog(@"文件存在");
    }else {
        NSLog(@"文件不存在");
    }
    return b;
}

-(void)delFile{
    NSFileManager *filemanage = [NSFileManager defaultManager];
    BOOL b = [filemanage fileExistsAtPath:plistpath];
    if (b) {
        [filemanage removeItemAtPath:plistpath error:nil];
        NSLog(@"临时plist文件存在  已经删除");
    }
}

-(id)init{
    if (self = [super init]) {
        NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docmentPath = [NSString stringWithFormat:@"%@",[array objectAtIndex:0]];
        trace(@"%@",docmentPath);
        configZipPath = [[docmentPath stringByAppendingPathComponent:@"gameconfig.achive"] retain];
        
        plistpath = [[docmentPath stringByAppendingPathComponent:@"allData.plist"] retain];
        
        if (![self fileIsExist]) {
            ZipArchive *zip = [[ZipArchive alloc] init];
            BOOL b = [zip CreateZipFile2:configZipPath Password:password];
            if (b) {
                trace(@"创建文件成功");
            }   
            
            [zip CloseZipFile2];
            [zip release];
        }    
    }
    return self;
}



//得到配置信息
-(NSMutableDictionary *)getConfig{
    ZipArchive *zip = [[ZipArchive alloc] init];
    
    BOOL b = [zip UnzipOpenFile:configZipPath Password:password];
    if (b) {
        [zip UnzipFileTo:docmentPath overWrite:YES];
    }
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:plistpath];
    
    trace(@"%@",dictionary);
    [zip release];

    //删除文件
    [self delFile];
    
    if(dictionary==nil){
        return [self getInitGameConfig];//为空的话，则初始化，游戏数据
    }else {
        return dictionary;   
    }
}

//保存配置信息
-(NSMutableDictionary *)saveConfig:(NSMutableDictionary *)data{
    
    BOOL result = [data writeToFile:plistpath atomically:YES];
    if (result) {
        trace(@"1");
    }
    
    ZipArchive *zip = [[ZipArchive alloc] init];
    BOOL b = [zip CreateZipFile2:configZipPath Password:password];
    
    [zip addFileToZip:plistpath newname:@"allData.plist"];
    
    if (b) {
        trace(@"保存数据成功");
    }
    [zip CloseZipFile2];
    [zip release];
    //删除文件
    [self delFile];
    return nil;
}









/**********因为这个类是从 天才达人秀 中拿过来的，以下的方法，在这个工程中没有用到*********/


#pragma  mark ---如果得到配置信息为空的话，就初始化 配置信息---
-(NSMutableDictionary *)getInitGameConfig{
    trace(@"--------------------初始化配置信息----------------");
    //性别
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:@"1170" forKey:@"userstep"];
    [dictionary setValue:@"300" forKey:@"usermoney"];
    [dictionary setValue:@"0" forKey:@"historyhighestscore"];
    
    [dictionary setValue:@"" forKey:@"lastPrizeData"];
    
    [dictionary setValue:[NSNumber numberWithBool:YES] forKey:@"firstEnterApp"];
    //8个关卡是否通过、分数、存档    
    
    for (int a = 0; a<8; a++) {
        NSMutableDictionary *level = [NSMutableDictionary dictionary];
        if (a==0) {
            [level setValue:[NSNumber numberWithBool:YES] forKey:@"isopen"];
        }else {
            [level setValue:[NSNumber numberWithBool:NO] forKey:@"isopen"];
        }
        [level setValue:@"0" forKey:@"currentscore"];
        [level setValue:[NSArray array] forKey:@"archive"];
        [level setValue:[NSArray array] forKey:@"nextseat"];//物种队列
        [level setValue:@"0" forKey:@"highestscore"];
        [level setValue:[NSNumber numberWithBool:NO] forKey:@"isgameover"];

        
        /* 
         <dict>
         <key>xiaocao</key>
         <integer>12</integer>
         <key>luobo</key>
         <integer>12</integer>
         <key>dashu</key>
         <integer>12</integer>
         <key>bom</key>
         <integer>8</integer>
         <key>colorball</key>
         <integer>8</integer>
         </dict>
         */
        
        
        //库存
        NSMutableDictionary *storeLeft = [NSMutableDictionary dictionary];
        //if ((a+1) == 3) {
        //    [storeLeft setValue:@"12" forKey:@"caowu"];
        //}else {
            [storeLeft setValue:@"12" forKey:@"xiaocao"];
       // }
        
        [storeLeft setValue:@"12" forKey:@"luobo"];
        [storeLeft setValue:@"12" forKey:@"dashu"];
        [storeLeft setValue:@"8" forKey:@"bom"];
        [storeLeft setValue:@"8" forKey:@"colorball"];
        
        [level setValue:storeLeft forKey:@"store"];
        

        
        [dictionary setValue:level forKey:([NSString stringWithFormat:@"level_%d",(a+1)])];
        
    }
    
    //设置里面的声音初始化
    [dictionary setValue:@"YES" forKey:@"sound_bg"];
    [dictionary setValue:@"YES" forKey:@"sound_action"];
    [dictionary setValue:@"YES" forKey:@"sound_human"];
    [dictionary setValue:@"" forKey:@"stepremembertime"];//2012-01-02 06:23:34
    //kt
    [dictionary setValue:[NSNumber numberWithInt:[HLAnalyst intValue:@"default_step" defaultValue:500]] forKey:@"step"];
    [dictionary setValue:@"0" forKey:@"stepremembersecond"];
    
    return dictionary;
}



#pragma mark ---道具---
//加 减 道具
-(void)add_plus_ToolsNumByKey:(NSString *)key num:(NSInteger)n{
     
    //得到保存的value
    NSString *str_value = [NSString stringWithString:[[[Globel shareGlobel].allDataConfig objectForKey:@"card"] objectForKey:key]] ;
    NSInteger numvalue = [str_value intValue];
    //
    NSInteger resultvalue = numvalue + n;
    if (resultvalue<=0) {
        resultvalue = 0;
    }
    [[[Globel shareGlobel].allDataConfig objectForKey:@"card"] setValue:[NSString stringWithFormat:@"%d",resultvalue] forKey:key];
    
    //保存进磁盘
    [self saveConfig:[Globel shareGlobel].allDataConfig];
    
    trace(@"保存道具数量完后的 数据%@",[Globel shareGlobel].allDataConfig);
    
}

//得到达人币
-(NSInteger)getToolsByKey:(NSString *)key{
    NSString *str_value = [NSString stringWithString:[[[Globel shareGlobel].allDataConfig objectForKey:@"card"] objectForKey:key]] ;
    return [str_value intValue];
}

#pragma mark ---达人币---
//加 减 道具 （不好意思，这个方法的名字貌似不是很好 ，我是想写add_reduce_Money这个的意思，写错了，就不改了。）
-(void)add_plus_Money:(NSInteger)n{
    
    if (n>0) {        
        //如果有财神卡，则有30%的几率 金钱 翻翻
        if ([[[[Globel shareGlobel].allDataConfig objectForKey:@"card"] objectForKey:@"card_caishengka"] intValue] != 0) {
            int a = arc4random() %10;
            if (a<3) {
                n = n *2;
                trace(@"得到财神的庇佑，金钱翻翻");
            }
        }
   
    }
    //得到保存的value
    NSString *str_value = [NSString stringWithString:[[Globel shareGlobel].allDataConfig objectForKey:@"usermoney"]];
    NSInteger numvalue = [str_value intValue];
    //
    NSInteger resultvalue = numvalue + n;
    if (resultvalue<=0) {
        resultvalue = 0;
    }
    [[Globel shareGlobel].allDataConfig setValue:[NSString stringWithFormat:@"%d",resultvalue] forKey:@"usermoney"];
    
    //保存进磁盘
    [self saveConfig:[Globel shareGlobel].allDataConfig];
    
    trace(@"保存达人币完后的 数据%@",[Globel shareGlobel].allDataConfig);
    
}

//得到达人币
-(NSInteger)getMoneyNum{
    NSString *str_value = [NSString stringWithString:[[Globel shareGlobel].allDataConfig objectForKey:@"usermoney"]];
    return [str_value intValue];
}



#pragma mark  -----clear history data----
-(void)clearHistoryData{
    NSFileManager *filemanage = [NSFileManager defaultManager];
    BOOL b = [filemanage fileExistsAtPath:configZipPath];
    if (b) {
        [filemanage removeItemAtPath:configZipPath error:nil];
        NSLog(@"文件存在,即将清除");
    }
}













@end
