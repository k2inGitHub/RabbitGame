
#import <Foundation/Foundation.h>
#import "cocos2d.h"


typedef enum{
    Operate_Type_Place = 1, //放置
    Operate_Type_Join = 2,    //合成
    Operate_Type_Use = 3    //使用
}Operate_Type;

@interface Task : NSObject {
    
@public
    
    // 任务批次ID
    int taskBatchID;
    // 任务ID
    int taskID;
    
    // 合成目标属性
    int targetLinkType;
    int targetLinkLevel;
    
    // 合成目标的数量
    int targetCount;
    
    // 1. 种植或放置 2. 合成 3. 其它
    int operationType;
    
    int bonusCoin;
    
    // 任务内容
    NSString *content;
    
    // 实际完成
    int finishCount;
    
    bool isNewTask;
    
}

/**
 * 完成了一个目标
 */
-(Task*)stepUp;

- (void)remember;

/**
 * 得到初始化任务
 */
+(Task*)getInitTask:(int)batchId;

+(void)setOldTaskToArchive:(int)batchId Id:(int)Id round:(int)round;
+(int)getRoundFromArchive:(int)batchId;


/**
 * 得到下一个任务
 */
-(Task*)getNextTask;
@end
