//
//  Globel.h
//  SheepGame
//
//  Created by pai hong on 12-3-3.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. All rights reserved.
//

#define DEBUG_TRack true
//#define DEBUG_TRack1 true

#ifdef DEBUG_TRack
#define track() NSLog(@"%s",__FUNCTION__)

#else
#define track()
#endif


#define DEBUG_TRACE true 
//#define DEBUG_TRACE1 true 

#ifdef DEBUG_TRACE    
#define trace(format,...) NSLog(format,##__VA_ARGS__)
#else
#define trace(format,...)
#endif

#define SSSW  320  //屏幕的宽度
#define SSSH 480  //设备的高度


#define UseSysFont @"Georgia"

#define UseSysFontzheng @"Helvetica"

#import <Foundation/Foundation.h>

@class GameScene;
@class WorldMapScene;


@interface Globel : NSObject{
    
    NSMutableDictionary *notesDictionary;//储存经常用到的controller，
    
    NSMutableDictionary *someThingDictionary;//用来存储一些零散的，不是很必要的临时数据（当前类别的名称currentCategoryName ）
    
    NSMutableDictionary * allDataConfig; //程序的固态配置文件数据  会写入加密压缩包的
    
    NSMutableDictionary * levelFeature; //程序的固态配置文件数据  会写入加密压缩包的
    
    WorldMapScene *worldMapScene;
    
    int curLevel;

    UIViewController *rootController;
    
    int tempSecond;
    
    BOOL tempBool;
    //第一关的分数：model1Score\
    
    //是否在教程状态下面
    BOOL isInCourse;
    
    /*
    MainModel1Ctr *model1Ctr;
    MainModel2Ctr *model2Ctr;
    MainModel3Ctr *model3Ctr;
    
    
    NSMutableArray * model1_10categoryIndexArray;//10轮的顺序数组
    NSMutableArray * model1_10categoryNameArray;//10轮的名称顺序数组，在Globel.m中初始化，完成
    NSInteger model1_loopNum;//当前在第几轮  （共10轮）
    NSInteger model1_levelNum;//当前在第几关（共8关）  
    //NSArray *model1_levelNameArray;
    
    //NSMutableDictionary * model3_config;
    QuestionCtr *questionCtr;
     */
    int rabbitTag;
}

@property(nonatomic,assign) int tempSecond;

@property(nonatomic,assign) int rabbitTag;

@property(nonatomic,assign) NSMutableDictionary *notesDictionary;
@property(nonatomic,assign) NSMutableDictionary *someThingDictionary;
@property(nonatomic,assign) NSMutableDictionary *allDataConfig;

@property(nonatomic,assign) NSMutableDictionary *levelFeature;

@property(nonatomic,assign) WorldMapScene *worldMapScene;

@property(nonatomic,assign) BOOL tempBool;
@property(nonatomic,assign) BOOL isInCourse;


@property(nonatomic,assign) int curLevel;
@property(nonatomic,assign) UIViewController *rootController;
/*
@property(nonatomic,assign) MainModel1Ctr *model1Ctr;
@property(nonatomic,assign) MainModel2Ctr *model2Ctr;
@property(nonatomic,assign) MainModel3Ctr *model3Ctr;

@property(nonatomic,assign) QuestionCtr *questionCtr;

@property(nonatomic,assign) NSMutableDictionary *someThingDictionary;

@property(nonatomic,assign) NSMutableDictionary *sysDiction;

@property(nonatomic,assign) NSMutableDictionary *allDataConfig;


@property(nonatomic,assign) NSMutableArray *model1_10categoryIndexArray;
@property(nonatomic,assign) NSMutableArray *model1_10categoryNameArray;
//@property(nonatomic,assign) NSArray * model1_levelNameArray;
@property(nonatomic,assign) NSInteger model1_loopNum;
@property(nonatomic,assign) NSInteger model1_levelNum;

//@property(nonatomic,assign) NSMutableDictionary *model3_config;

 */


+(Globel *)shareGlobel;



@end
