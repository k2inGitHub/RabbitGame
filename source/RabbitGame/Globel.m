//
//  Globel.m
//  SheepGame
//
//  Created by pai hong on 12-3-3.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. All rights reserved.
//
#import "Globel.h"

@implementation Globel

@synthesize notesDictionary,someThingDictionary,allDataConfig,levelFeature;

@synthesize worldMapScene,curLevel,rootController,tempSecond,tempBool,isInCourse,rabbitTag;

/*
@synthesize sysDiction,model1_10categoryIndexArray,model1_loopNum,model1_levelNum,allDataConfig;
@synthesize model1Ctr,model2Ctr,model3Ctr,model1_10categoryNameArray,someThingDictionary,questionCtr;
*/
+(Globel *)shareGlobel{
    static Globel *instance = nil;
    @synchronized(self){
        if (!instance) {
            instance = [[Globel alloc] init];
        }
    }
    return instance;
}

-(id)init{
    if (self = [super init]) {
        /*
        sysDiction = [[NSMutableDictionary alloc] init];
        model1_10categoryNameArray = [[NSMutableArray alloc] initWithObjects: @"IT",@"法学",@"风俗",@"礼仪",@"美学",@"生活",@"体育",@"文化",@"音律",@"娱乐", nil];
        someThingDictionary = [[NSMutableDictionary alloc] init];
         */
    }
    return self;
}



@end
