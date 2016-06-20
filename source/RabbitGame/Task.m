
#import "Task.h"
#import "Link.h"
#import "GameScene.h"

@implementation Task

// 撤销算是工具的第3种吧
static int IDs[3][10] = {{1, 2, 3, 4, 5, 6, 7, 8, 9, 0},
    {1, 2, 3, 4, 5, 6, 7, 8, 9, 0},
    {1, 2, 3, 0, 0, 0, 0, 0, 0, 0}};
static int types[3][10] = {{1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {2, 3, 3, 3, 4, 4, 3, 3, 2, 0},
    {5, 5, 5, 0, 0, 0, 0, 0, 0, 0}};
static int levels[3][10] = {{1, 2, 3, 4, 5, 6, 7, 8, 9, 0},
    {1, 1, 2, 3, 1, 2, 4, 5, 2, 0},
    {1, 2, 3, 0, 0, 0, 0, 0, 0, 0}};
static int counts[3][10] = {{50, 40, 30, 20, 10, 5, 3, 2, 1, 0},
    {10, 10, 5, 3, 10, 5, 3, 1, 1, 0},
    {5, 5, 5, 0, 0, 0, 0, 0, 0, 0}};
//static int counts[3][10] = {{1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
//    {1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
//    {1, 1, 1, 0, 0, 0, 0, 0, 0, 0}};
static int otypes[3][10] = {{1, 2, 2, 2, 2, 2, 2, 2, 2, 0},
    {1, 2, 2, 2, 1, 2, 2, 2, 1, 0},
    {3, 3, 3, 0, 0, 0, 0, 0, 0, 0}};
static int coins[3][10] = {{10, 20, 30, 40, 50, 60, 70, 80, 100, 0},
    {30, 40, 80, 100, 30, 50, 70, 100, 50, 0},
    {50, 50, 50, 0, 0, 0, 0, 0, 0, 0}};
static NSString *contentPreix[3] = {@"放置", @"合成", @"使用"};
static NSString *contentAppix[6][10] = {{@"萝卜苗", @"胡萝卜", @"萝卜树", @"树墩小屋", @"风车小屋", @"蘑菇小屋", @"黄金蘑菇堡", @"兔兔庄园", @"兔兔神殿", NULL},
    {@"小白兔", @"兔兔超人", NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
    {@"兔纸墓碑", @"兔纸大墓碑", @"黄金萝卜像", @"宝箱", @"海盗宝藏", NULL, NULL, NULL, NULL, NULL},
    {@"岩石", @"巨岩", NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
    {@"万能胶囊", @"炸弹", @"撤销", NULL, NULL, NULL, NULL, NULL, NULL, NULL}};


+(int)getTaskIdFromArchive:(int)batchId
{
    NSString *key = [NSString stringWithFormat:@"Task_%d",batchId];
    NSObject *obj =  [[Globel shareGlobel].allDataConfig objectForKey:key];
    if (obj == NULL) {
        if (batchId == 3) {
            return 1;
        } else {
            return 1;
        }
    } else {
        return [((NSString*)obj) intValue];
    }
}

+(void)setTaskIdToArchive:(int)batchId taskid:(int)taskid
{
    NSString *key = [NSString stringWithFormat:@"Task_%d",batchId];
    NSString *h = [NSString stringWithFormat:@"%d",taskid];
    [[Globel shareGlobel].allDataConfig setValue:h forKey:key];
}

+(int)getRoundFromArchive:(int)batchId
{
    NSString *key = [NSString stringWithFormat:@"Task_%dRound",batchId];
    NSObject *obj =  [[Globel shareGlobel].allDataConfig objectForKey:key];
    if (obj == NULL) {
        return 1;
    } else {
        return [((NSString*)obj) intValue];
    }
}

+(void)setRoundToArchive:(int)batchId round:(int)round
{
    NSString *key = [NSString stringWithFormat:@"Task_%dRound",batchId];
    NSString *h = [NSString stringWithFormat:@"%d",round];
    [[Globel shareGlobel].allDataConfig setValue:h forKey:key];
}

+(int)getFinishCountFromArchive:(int)batchId Id:(int)Id round:(int)round
{
    NSString *key = [NSString stringWithFormat:@"TaskCount%d-%d-%d",batchId,Id,round];
    NSObject *obj =  [[Globel shareGlobel].allDataConfig objectForKey:key];
    if (obj == NULL) {
        return 0;
    } else {
        return [((NSString*)obj) intValue];
    }
}

+(void)setOldTaskToArchive:(int)batchId Id:(int)Id round:(int)round
{
    NSString *key = [NSString stringWithFormat:@"TaskOld%d-%d-%d",batchId,Id,round];
    NSString *h = [NSString stringWithFormat:@"%d",true];
    [[Globel shareGlobel].allDataConfig setValue:h forKey:key];
}

+(bool)isNewTaskFromArchive:(int)batchId Id:(int)Id round:(int)round
{
    NSString *key = [NSString stringWithFormat:@"TaskOld%d-%d-%d",batchId,Id,round];
    NSObject *obj =  [[Globel shareGlobel].allDataConfig objectForKey:key];
    if (obj == NULL) {
        return true;
    } else {
        return false;
    }
}

+(void)setFinishToArchive:(int)batchId Id:(int)Id round:(int)round count:(int)count
{
    NSString *key = [NSString stringWithFormat:@"TaskCount%d-%d-%d",batchId,Id,round];
    NSString *h = [NSString stringWithFormat:@"%d",count];
    [[Globel shareGlobel].allDataConfig setValue:h forKey:key];
}

- (void)remember
{
    int round = [Task getRoundFromArchive:taskBatchID];
    [Task setFinishToArchive:taskBatchID Id:taskID round:round count:finishCount];
}

- (Task*)stepUp
{
    finishCount ++;
    [self remember];
    if (finishCount >= targetCount) {
        //完成了预定目标
        [[GameScene shareInstance] addTaskFinishDialog:content coin:bonusCoin];
        
        Task *next = [self getNextTask];
        return next;
    }
    return NULL;
}

- (id)init:(int)batchId ID:(int)ID type:(int)type level:(int)level count:(int)count oType:(int)otype coin:(int)coin
{
    self = [super init];
    if (self) {
        taskBatchID = batchId;
        taskID = ID;
        targetLinkType = type;
        targetLinkLevel = level;
        targetCount = count;
        operationType = otype;
        bonusCoin = coin;
        
        int round = [Task getRoundFromArchive:batchId];
        finishCount = [Task getFinishCountFromArchive:taskBatchID Id:taskID round:round];
        isNewTask = [Task isNewTaskFromArchive:taskBatchID Id:taskID round:round];
        
        NSString *tmp = @"个";
        if (taskBatchID == 3) {
            tmp = @"次";
        }
        
        content = [NSString stringWithFormat:@"%@%d%@%@", contentPreix[operationType - 1], targetCount, tmp, contentAppix[targetLinkType-1][targetLinkLevel-1]];
        [content retain];
    }
    return self;
}

+(Task*)getTask:(int)batchId ID:(int)ID type:(int)type level:(int)level count:(int)count oType:(int)otype coin:(int)coin
{
    Task *task = [[Task alloc] init:batchId ID:ID type:type level:level count:count oType:otype coin:coin];
    [task autorelease];
    return task;
}

+(Task*)getTask:(int)batchId ID:(int)taskid
{
    int round = [Task getRoundFromArchive:batchId];
    
    int type = types[batchId - 1][taskid - 1];
    int level = levels[batchId - 1][taskid - 1];
    int count = counts[batchId - 1][taskid - 1] * round;
    int oType = otypes[batchId - 1][taskid - 1];
    int coin = coins[batchId - 1][taskid - 1] * round;
    
    return [Task getTask:batchId ID:taskid type:type level:level count:count oType:oType coin:coin];
}

/**
 * 得到初始化任务
 */
+(Task*)getInitTask:(int)batchId
{
    int taskid = [Task getTaskIdFromArchive:batchId];
    return [Task getTask:batchId ID:taskid];
}

-(Task*)getNextTask
{
    int ID = IDs[taskBatchID - 1][taskID];
    if (ID == 0) {
        // 任务列表全部完成，重新开始
        ID = IDs[taskBatchID - 1][0];
        int round = [Task getRoundFromArchive:taskBatchID];
        round ++;
        [Task setRoundToArchive:taskBatchID round:round];
    }
    [Task setTaskIdToArchive:taskBatchID taskid:ID];
    return [Task getTask:taskBatchID ID:ID];
}

@end
