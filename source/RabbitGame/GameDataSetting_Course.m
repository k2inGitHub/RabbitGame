
//
//  LevelDataSetting.m
//  RabbitGame
//
//  Created by pai hong on 12-6-24.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "GameDataSetting_Course.h"

#import "GameScene_Course.h"
#import "Grid.h"
#import "Link.h"
#import "CCAnimationHelper.h"
#import "GameRoom.h"
#import "GameLinksInfor.h"
#import "SoundManagerR.h"

@interface GameDataSetting_Course(private)


@end

@implementation GameDataSetting_Course

- (id)init
{
    self = [super init];
    if (self) {
        //tempFindLinks = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void)analyseData:(GameScene_Course *)delegate levelNum:(int)level{
    track();
    
    gameScene = delegate;
    
    float leftx;
    float lefty;
    /*
     1、普通
     2、兔子1.5倍
     3、特殊商店
     4、无仓
     5、没有兔子
     6、月光村，受限
     7、双仓库
     8、冒险岛(无飞天猫)
     */
    
    if (level==1 || level==2 || level==3  || level==4 || level==5 || level==6) {
        //起始点的坐标，左下角
        leftx = 10 + 25;   //25是半径，从而得到第一个的中心点
        lefty = 66 + 25;
        
        //格子的数量
        numx = 6;
        numy = 6;
    }else if(level==7){
        //起始点的坐标，左下角
        leftx = 10 + 25;   //25是半径，从而得到第一个的中心点
        lefty = 119 + 25;
        
        //格子的数量
        numx = 6;
        numy = 5;
        //
    }else if(level == 8){
        //起始点的坐标，左下角
        leftx = 60 + 25;   //25是半径，从而得到第一个的中心点
        lefty = 117 + 25;
        
        //格子的数量
        numx = 4;
        numy = 4;
    }
    
    //创建二维的Grid 数组
    NSMutableArray *grids = [NSMutableArray array];
    for (int i=0; i<numy; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (int j=0; j<numx; j++) {
            Grid *grid = [Grid spriteWithFile:@"gezibg.png"];
            grid.x = j;
            grid.y = i;
            grid.opacity = 0;
            grid.position = ccp(leftx+50*j*1.0f,lefty+50*i*1.0f);
            [delegate addChild:grid];
            
            [array addObject:grid];
        }
        [grids addObject:array];
    }
    /*
     1、普通
     2、兔子1.5倍
     3、特殊商店
     4、无仓
     5、没有兔子
     6、月光村，受限
     7、双仓库
     8、冒险岛(无飞天猫)
     */
    
    //初始化，处理二维
    if (level==1 || level==2 || level==3 || level==5) {
        //最左上角的不能点击
        Grid *grid = [[grids objectAtIndex:numy-1] objectAtIndex:0];
        [grid insertWall];
    }else if(level==4 || level == 7 || level==8){//无仓 冒险岛 不需要wall
        
    }else if(level == 6) {//月光村
        Grid *grid1 = [[grids objectAtIndex:2] objectAtIndex:2]; 
        Grid *grid2 = [[grids objectAtIndex:2] objectAtIndex:3]; 
        Grid *grid3 = [[grids objectAtIndex:3] objectAtIndex:2]; 
        Grid *grid4 = [[grids objectAtIndex:3] objectAtIndex:3]; 
        [grid1 insertWall];
        [grid2 insertWall];
        [grid3 insertWall];
        [grid4 insertWall];
    }
    
    
    //LinksInfor
    gamelinksinfor = [GameLinksInfor node];
    gamelinksinfor.position = ccp(20,380);
    [gameScene addChild:gamelinksinfor];
    /*
    //读取存档数据
    NSMutableArray *historygrids = [gameScene getLevelConfigDate:@"archive"];
    if (historygrids==nil || [historygrids count] == 0) {//说明是第一次玩
        //设置初始化随机物种
        [self setRandomLinkInMapWhenBegin:grids];
    }else {//说明存在存档数据
        [self recoverHistoryGridsData:grids :historygrids];
    }*/
        
    [self setLinkToGrids:grids X:1 Y:2 type:Link_Type_House level:1];
    [self setLinkToGrids:grids X:2 Y:4 type:Link_Type_House level:1];
    [self setLinkToGrids:grids X:3 Y:3 type:Link_Type_House level:1];
    [self setLinkToGrids:grids X:4 Y:3 type:Link_Type_House level:1];
    
    [self setLinkToGrids:grids X:2 Y:5 type:Link_Type_House level:2];
    [self setLinkToGrids:grids X:5 Y:5 type:Link_Type_House level:2];
    [self setLinkToGrids:grids X:5 Y:2 type:Link_Type_House level:2];
    
    [self setLinkToGrids:grids X:0 Y:4 type:Link_Type_House level:3];
    [self setLinkToGrids:grids X:3 Y:2 type:Link_Type_House level:3];
    
    [self setLinkToGrids:grids X:5 Y:1 type:Link_Type_House level:4];
    
    [self setLinkToGrids:grids X:1 Y:3 type:Link_Type_Stone level:1];
    
    [self setLinkToGrids:grids X:3 Y:4 type:Link_Type_Park level:1];
    [self setLinkToGrids:grids X:4 Y:4 type:Link_Type_Park level:1];


    //设置信息
    [delegate setBaseData:grids :numx :numy :leftx :lefty];
}

-(void)setLinkToGrids:(NSMutableArray *)grids X:(int)x Y:(int)y type:(Link_Type)t level:(int)l{
    Link *link = [Link createByType:t andLelve:l];
    Grid *grid = [[grids objectAtIndex:y] objectAtIndex:x];
    
    [grid setLinkRelation:link];
    [gameScene addChild:link];
    link.pgrid = grid;
    link.position = ccp(grid.position.x,grid.position.y);
}

-(void)setRandomLinkInMapWhenBegin:(NSMutableArray *)grids{
    track();
    int level = [Globel shareGlobel].curLevel;
    
    //第8关的话，没有默认的
    if (level == 8) {
        return;
    }
    
    //2块石头 2个草屋 4棵树 6-8个草 1-3个萝卜 1个兔子
    //石头
    NSMutableArray *defaultLinks = [NSMutableArray array];
    
    if (level != 5) {//第5关没有兔子
        //兔子
        [defaultLinks addObject:[Link createByType:Link_Type_Rabbit andLelve:1]];
        /*
         //兔笼
         for (int i=0; i<2; i++) {
         [defaultLinks addObject:[Link createByType:Link_Type_Park andLelve:1]];
         }
         */
    }
    
    /*
     for (int i=0; i<2; i++) {
     [defaultLinks addObject:[Link createByType:Link_Type_Stone andLelve:1]];
     } */
    
    //草
    int a1 = (2+arc4random()%3);
    for (int i=0; i<a1; i++) {
        [defaultLinks addObject:[Link createByType:Link_Type_House andLelve:1]];
    }
    //萝卜
    int a2 = (1+arc4random()%3);
    for (int i=0; i<a2; i++) {
        [defaultLinks addObject:[Link createByType:Link_Type_House andLelve:2]];
    }
    //树
    int a3 = (2+arc4random()%2);
    for (int i=0; i<a3; i++) {
        [defaultLinks addObject:[Link createByType:Link_Type_House andLelve:3]];
    }
    //房子
    for (int i=0; i<2; i++) {
        [defaultLinks addObject:[Link createByType:Link_Type_House andLelve:4]];
    }
    
    
    //吧数组里面的 塞入grids
    int len = [defaultLinks count];
    
    for(int i=0 ;i<len;i++){
        Link *link = [defaultLinks objectAtIndex:i];
        
        while (YES) {
            int rx = arc4random()%numx;
            int ry = arc4random()%numy;
            
            //trace(@"%d %d",rx,ry);
            
            Grid *grid = [[grids objectAtIndex:ry] objectAtIndex:rx];
            if (grid.link==nil) {
                
                [grid setLinkRelation:link];
                [gameScene addChild:link];
                link.pgrid = grid;
                link.position = ccp(grid.position.x,grid.position.y);
                break;
            }
        }
    }
    
    
    
}


-(void)traceGrid{
    trace(@"---------------------------------------------");
    NSMutableArray *grids = [gameScene getGrids];
    int len = [grids count];
    for (int i=(len-1); i>=0; i--) {
        NSMutableArray *lines = [grids objectAtIndex:i];
        int count = [lines count];
        NSString *str = @"";
        for (int a=0; a<count; a++) {
            Grid *grid = [lines objectAtIndex:a];
            str = [str stringByAppendingFormat:@",(%f,%f)",grid.position.x,grid.position.y];
        }
        trace(@"%@",str);
    }
    trace(@"---------------------------------------------");
}

-(void)trace1_0{
    trace(@"---------------------------------------------");
    NSMutableArray *grids = [gameScene getGrids];
    int len = [grids count];
    for (int i=(len-1); i>=0; i--) {
        NSMutableArray *lines = [grids objectAtIndex:i];
        int count = [lines count];
        NSString *str = @"";
        for (int a=0; a<count; a++) {
            Grid *grid = [lines objectAtIndex:a];
            CCSprite *link = grid.link;
            if (link==nil) {
                str = [str stringByAppendingFormat:@" 0 "];
            }else {
                str = [str stringByAppendingFormat:@" 1 "];
            }
        }
        trace(@"%@",str);
    }
    trace(@"---------------------------------------------");
}

#pragma mark ---grid操作---
-(Grid *)getGridByX:(int)x Y:(int)y{
    NSMutableArray *grids = [gameScene getGrids];
    
    Grid *grid = [[grids objectAtIndex:y] objectAtIndex:x];
    return grid;
}

//得到上下左右对于的grid
-(Grid *)gLeft:(Grid *)grid{
    //track();
    int x = grid.x;
    int y = grid.y;
    if (x<=0) {
        return nil;
    }
    return [self getGridByX:x-1 Y:y];
}
-(Grid *)gRight:(Grid *)grid{
    //track();
    int x = grid.x;
    int y = grid.y;
    if (x>=(numx-1)) {
        return nil;
    }
    return [self getGridByX:x+1 Y:y];
}
-(Grid *)gTop:(Grid *)grid{
    //track();
    int x = grid.x;
    int y = grid.y;
    if (y >=(numy-1)) {
        return nil;
    }
    return [self getGridByX:x Y:y+1];
}
-(Grid *)gDown:(Grid *)grid{
    //track();
    int x = grid.x;
    int y = grid.y;
    if (y<=0) {
        return nil;
    }
    return [self getGridByX:x Y:y-1];
}
-(Grid *)gLeftTop:(Grid *)grid{
    //track();
    int x = grid.x;
    int y = grid.y;
    if (x<=0 || y>=(numy-1)) {
        return nil;
    }
    return [self getGridByX:x-1 Y:y+1];
}
-(Grid *)gRightTop:(Grid *)grid{
    //track();
    int x = grid.x;
    int y = grid.y;
    if (x>=(numx-1) || y>=(numy-1)) {
        return nil;
    }
    return [self getGridByX:x+1 Y:y+1];
}

-(Grid *)gLeftDown:(Grid *)grid{
    //track();
    int x = grid.x;
    int y = grid.y;
    if (x<=0 || y <= 0) {
        return nil;
    }
    return [self getGridByX:x-1 Y:y-1];
}

-(Grid *)gRightDown:(Grid *)grid{
    //track();
    int x = grid.x;
    int y = grid.y;
    if (x>=(numx-1) || y <= 0) {
        return nil;
    }
    return [self getGridByX:x+1 Y:y-1];
}
//刷新草坪
-(void)refreshLawnTexture{
    track();
    //track();
    NSMutableArray *grids = [gameScene getGrids];
    int len = [grids count];
    for (int i= 0; i<len; i++) {
        //i=3;
        NSMutableArray *lines = [grids objectAtIndex:i];
        int count = [lines count];
        for (int a=0; a<count; a++) {
            //a = 3;
            Grid *grid = [lines objectAtIndex:a];
            //刷新草坪
            [grid refreshLawnByTop
             :[self gTop:grid] 
             :[self gRight:grid] 
             :[self gDown:grid] 
             :[self gLeft:grid]
             
             :[self gLeftTop:grid]
             :[self gRightTop:grid]
             :[self gRightDown:grid]
             :[self gLeftDown:grid]
             ];
            //return;
        }
    }
}

#pragma mark ---物体运动操作----
//停止 试运动
-(void)stopAllLinkPrevMove{
    track();
    int len = [tempFindLinks count];
    for (int i=0; i<len; i++) {
        NSMutableArray *lineArray = [tempFindLinks objectAtIndex:i];
        int lineLen = [lineArray count];
        for (int a = 0; a<lineLen; a++) {
            Link *link = [lineArray objectAtIndex:a];
            if (link.pgrid!=nil) {//加这个限制条件，解决了，合并的时候物体运动，如果快速点击的话，就触发了stopAllLinkPrevMove这个方法，导致物体停止运动，然后就一直停留场景中，删除不了
                [link stopPreMove];   
            }
        }
    }
}
//开始 试运动
-(void)perMovePointToTheTarget:(NSMutableArray *)targetArray :(CGPoint)p{
    track();
    int len = [targetArray count];
    for (int i=0; i<len; i++) {
        NSMutableArray *lineArray = [targetArray objectAtIndex:i];
        int lineLen = [lineArray count];
        for (int a = 0; a<lineLen; a++) {
            Link *link = [lineArray objectAtIndex:a];
            [link preMovePointTo:p];
        }
    }
}

//开始 合并运动
-(void)startMovePointToTheTarget:(CGPoint)p{
    track();
    int len = [tempFindLinks count];
    for (int i=0; i<len; i++) {
        NSMutableArray *lineArray = [tempFindLinks objectAtIndex:i];
        int lineLen = [lineArray count];
        for (int a = 0; a<lineLen; a++) {
            Link *link = [lineArray objectAtIndex:a];
            [link startMovePointTo:p];
        }
    }
}



#pragma mark ---合并操作---

//查询当前出入的link是否是最高物种
-(BOOL)isSuperest:(Link *)link{
    track();
    if (link.type==Link_Type_House) {
        if (link.level == 9) {
            return YES;
        }
    }
    if (link.type == Link_Type_Park) {
        if (link.level == 5) {
            return YES;
        }
    }/*
      if (link.type == Link_Type_Rabbit) {
      if (link.level == 5) {
      return YES;
      }
      }*/
    if (link.type == Link_Type_Stone) {
        if (link.level == 2) {
            //return YES;  大石头也能生成宝箱
        }
    }
    
    return NO;
}

//是否找到了可以合并的对象
-(BOOL)isFindsLinks{
    if (tempFindLinks==nil || [tempFindLinks count]==0) {
        return NO;
    }
    return YES;
}

//得到高一等级的Link
-(Link *)getSuperLink:(Link *)link{
    Link *superlink;
    if (link.type ==Link_Type_Stone && link.level == 2) {//大石头可以合成大宝箱
        superlink = [Link createByType:Link_Type_Park andLelve:5];
    }else {
        superlink = [Link createByType:link.type andLelve:(link.level+1)];
    }
    return superlink;
}
-(Link *)getSuperLink:(Link *)link issuper:(BOOL)b{
    Link *superlink = [Link createByType:link.type andLelve:(link.level+1) issuper:b];
    return superlink;
}

//分数是否加倍
-(BOOL)isGetDoubleScore{
    track();
    int len = [tempFindLinks count];
    NSArray *lastarray = [tempFindLinks objectAtIndex:(len-1)];
    
    //得到比这个更高一级的物种
    if ([lastarray count]>=3) {//最后物种大于3的话，则分数加倍，并且图标不一样
        return YES;
    }
    return NO;
}

-(NSMutableArray *)getFindsLinks{
    return tempFindLinks;
}

//得到数组中所有的分数
-(int)getAllScoreFrameArray:(NSMutableArray *)array{
    track();
    int all = 0;
    for (int i=0; i< [array count]; i++) {
        NSMutableArray *oneitemarray = [array objectAtIndex:i];
        for (int a=0; a<[oneitemarray count]; a++) {
            Link *link = [oneitemarray objectAtIndex:a];
            all +=link.score;
        }
    }
    
    return all;
}

//得到数组中的最小的link
-(Link *)getLowestLink{
    track();
    if (tempFindLinks==nil || [tempFindLinks count]==0) {
        return  nil;
    }
    Link *link = [[tempFindLinks objectAtIndex:0] objectAtIndex:0];
    return [link copyOne];
}

//得到合并完成的物种
-(Link *)getAllTogetherLink{
    track();
    int len = [tempFindLinks count];
    NSArray *lastarray = [tempFindLinks objectAtIndex:(len-1)];
    //数组里面最高级的物种
    Link *topestLink = [lastarray objectAtIndex:0];
    
    
    //得到比这个更高一级的物种
    Link *result;
    if ([lastarray count]>=3) {//最后物种大于3的话，则分数加倍，并且图标不一样
        if (topestLink.type == Link_Type_House && topestLink.level == 8) {//House最高等级的，还是要返回普通的
            result = [self getSuperLink:topestLink];
        }else if (topestLink.type == Link_Type_Stone && topestLink.level == 2) {
            result = [self getSuperLink:topestLink];
        }
        else {
            result = [self getSuperLink:topestLink issuper:YES];
        }
    }else {
        result = [self getSuperLink:topestLink];
    }
    
    if (result.type ==Link_Type_House ) {
        if (result.level<=3) {
            [[SoundManagerR shareInstance] playSound:@"level3-.wav" type:Sound_Type_Action];
        }else if(result.level == 4){
            [[SoundManagerR shareInstance] playSound:@"level4.wav"  type:Sound_Type_Action];
        }else if (result.level>=7) {
            [[SoundManagerR shareInstance] playSound:@"level7+.wav" type:Sound_Type_Action];
        }else {
            [[SoundManagerR shareInstance] playSound:@"level6-.wav" type:Sound_Type_Action];
        }
    }else if (result.type == Link_Type_Rabbit && (result.level == 4 || result.level == 5)) {
        [[SoundManagerR shareInstance] playSound:@"合成宝箱.wav" type:Sound_Type_Action];
    }
    
    
    return result;
}


//吧所有的Grid的查找状态设置成NO
-(void)resetAllGridsState:(BOOL)state{
    track();
    NSMutableArray *grids = [gameScene getGrids];
    int len = [grids count];
    for (int i=(len-1); i>=0; i--) {
        NSMutableArray *lines = [grids objectAtIndex:i];
        int count = [lines count];
        for (int a=0; a<count; a++) {
            Grid *grid = [lines objectAtIndex:a];
            grid.isFinded = state;
        }
    } 
}

//递归循环上下左右的格子，
-(void)find4Dirctions:(Grid *)grid :(Link *)firstLink :(NSMutableArray *)findArray{
    grid.isFinded = YES;
    //找上
    Grid *top       = [self gTop:grid];
    Grid *right     = [self gRight:grid];
    Grid *down      = [self gDown:grid];
    Grid *left      = [self gLeft:grid];
    
    /*
     top.isFinded = YES;
     right.isFinded = YES;
     down.isFinded = YES;
     left.isFinded = YES;
     */
    
    if (top!=nil && !top.isFinded) {
        if (top.link!=nil) {
            if (top.link.type == firstLink.type && top.link.level == firstLink.level) {
                trace(@"find %d %d",top.x,top.y);
                [self find4Dirctions:top :firstLink :findArray];
                [top findOneTime];
                [findArray addObject:top.link];
            }
        }
    }
    if (right!=nil && !right.isFinded) {
        if (right.link!=nil) {
            if (right.link.type == firstLink.type && right.link.level == firstLink.level) {
                trace(@"find %d %d",right.x,right.y);
                [self find4Dirctions:right :firstLink :findArray];
                [right findOneTime];
                [findArray addObject:right.link];
            }
        }
        
    }
    if (down != nil && !down.isFinded){
        if (down.link!=nil) {
            if (down.link.type == firstLink.type && down.link.level == firstLink.level) {
                trace(@"find %d %d",down.x,down.y);
                [self find4Dirctions:down :firstLink :findArray];
                [down findOneTime];
                [findArray addObject:down.link];
            }
        }
    }
    if (left != nil && !left.isFinded) {
        if (left.link!=nil) {
            if (left.link.type == firstLink.type && left.link.level == firstLink.level) {
                trace(@"find %d %d",left.x,left.y);
                [self find4Dirctions:left :firstLink :findArray];
                [left findOneTime];
                [findArray addObject:left.link];
            }
        }
    }
}

//查找可以合并的对象
-(void)findLinksToLink:(Grid *)grid :(Link *)firstLink{
    track();
    //是否是彩虹球
    if (firstLink.type==Link_Type_Tool && firstLink.level == 1) {//是彩虹球
        //-------------------------------------------彩虹球的情况-------------------------------------------------    
        //储存当前的Link
        curLink = firstLink;
        
        Grid *gtop = [self gTop:grid];
        Grid *gRight = [self gRight:grid];
        Grid *gDown = [self gDown:grid];
        Grid *gLeft = [self gLeft:grid];
        
        //是不是彩虹(判断上下左右的4个种类，分别替代这4个种类)
        NSMutableArray *pipeoarray = [NSMutableArray array];
        gtop!=nil?[pipeoarray addObject:gtop]:1;
        gRight!=nil?[pipeoarray addObject:gRight]:1;
        gDown!=nil?[pipeoarray addObject:gDown]:1;
        gLeft!=nil?[pipeoarray addObject:gLeft]:1;
        
        NSMutableArray *maxScoreArray = [NSMutableArray array];
        int maxScore = 0;
        
        for (int i=0;i<[pipeoarray count]; i++) {
            Grid *curGrid = [pipeoarray objectAtIndex:i];
            if (curGrid==nil || curGrid.link==nil || curGrid.link.type==Link_Type_Rabbit || curGrid.link.type == Link_Type_Wall) {//4种情况除外
                continue;
            }
            
            //开始查找
            
            Link *postLink = [curGrid.link copyOne];
            
            NSMutableArray *allfind = [NSMutableArray array];//会是二维数组  这个后期可能要做成Dictionary
            
            while (true) {    
                NSMutableArray *findArray = [NSMutableArray array];
                
                //得到周围所有的于此相同的 植物 Link_Type_House
                [self find4Dirctions:grid :postLink :findArray];
                
                //刷新所有的查找状态
                [self resetAllGridsState:NO];
                
                //小于2个的话，则不配对，终极物品需要3个水晶石才能合成
                if (postLink.type == Link_Type_House && postLink.level == 8  ) {
                    if ([findArray count]<3) {
                        break;
                    }
                }
                
                //小于2个的话，则不配对，
                if ([findArray count] < 2) {
                    break;
                }else {
                    //如果postLink已经是最高级的物种，则不进行判断
                    if ([self isSuperest:postLink]) {
                        break;
                    }
                    //吧搜索到的物体都放入allfind
                    [allfind addObject:findArray];
                    //升一级 然后再遍历
                    postLink = [self getSuperLink:postLink];
                }
                
            }
            
            //找最大的
            int allScore = [self getAllScoreFrameArray:allfind];
            trace(@"%@",allfind);
            if (allScore>=maxScore && [allfind count]>0) {//加一个[allfind count]>0的限制条件，要不然在某些情况下，石头和一级兔笼是合并不了的，因为1级石头、1级兔笼的分数是0
                maxScore = allScore;
                maxScoreArray = allfind;
            }
        }
        
        //处理tempFindLinks
        [self clearTempFindLinksArray];
        tempFindLinks = [maxScoreArray retain];//全局数组指向
        
        //让查找到的物体缓慢来回移动起来
        [self perMovePointToTheTarget:tempFindLinks :grid.position];
        trace(@"找到 :%@",tempFindLinks); 
        //----------
        /*
         Link *postLink = firstLink;
         
         NSMutableArray *allfind = [NSMutableArray array];//会是二维数组  这个后期可能要做成Dictionary
         
         //不是彩虹的话
         while (true) {    
         NSMutableArray *findArray = [NSMutableArray array];
         
         //得到周围所有的于此相同的 植物 Link_Type_House
         [self find4Dirctions:grid :postLink :findArray];
         
         //刷新所有的查找状态
         [self resetAllGridsState:NO];
         
         //小于2个的话，则不配对，
         if ([findArray count] < 2) {
         break;
         }else {
         //如果postLink已经是最高级的物种，则不进行判断
         if ([self isSuperest:postLink]) {
         break;
         }
         //吧搜索到的物体都放入allfind
         [allfind addObject:findArray];
         //升一级 然后再遍历
         postLink = [self getSuperLink:postLink];
         }
         }
         
         //处理tempFindLinks
         [self clearTempFindLinksArray];
         tempFindLinks = [allfind retain];//全局数组指向
         
         //让查找到的物体缓慢来回移动起来
         [self perMovePointToTheTarget:tempFindLinks :grid.position];
         trace(@"找到 :%@",tempFindLinks); */
    }else {
        //-------------------------------------------------非彩虹球的情况---------------------------------------------
        //储存当前的Link
        curLink = firstLink;
        
        //是不是彩虹(判断上下左右的4个种类，分别替代这4个种类)
        //TODO
        Link *postLink = firstLink;
        
        NSMutableArray *allfind = [NSMutableArray array];//会是二维数组  这个后期可能要做成Dictionary
        
        //不是彩虹的话
        while (true) {    
            NSMutableArray *findArray = [NSMutableArray array];
            
            //得到周围所有的于此相同的 植物 Link_Type_House
            [self find4Dirctions:grid :postLink :findArray];
            
            //刷新所有的查找状态
            [self resetAllGridsState:NO];
            
            //小于2个的话，则不配对，
            if (postLink.type == Link_Type_House && postLink.level == 8  ) {
                if ([findArray count]<3) {
                    break;
                }
            }
            
            if([findArray count] < 2){
                break;
            }else {
                //如果postLink已经是最高级的物种，则不进行判断
                if ([self isSuperest:postLink]) {
                    break;
                }
                //吧搜索到的物体都放入allfind
                [allfind addObject:findArray];
                //升一级 然后再遍历
                postLink = [self getSuperLink:postLink];
            }
        }
        
        //处理tempFindLinks
        [self clearTempFindLinksArray];
        tempFindLinks = [allfind retain];//全局数组指向
        
        //让查找到的物体缓慢来回移动起来
        [self perMovePointToTheTarget:tempFindLinks :grid.position];
        trace(@"找到 :%@",tempFindLinks); 
    }
    
}   


//开始合并
-(void)linkAllFindLinks:(Grid *)grid :(Link *)firstLink {
    track();
    [self startMovePointToTheTarget:grid.position];
}


//合并完后，删除数组里面的物种
-(void)removeAllOldLinksAfterLinking{
    track();
    
    int len = [tempFindLinks count];
    for (int i=(len-1); i>=0; i--) {
        NSMutableArray *lines = [tempFindLinks objectAtIndex:i];
        int count = [lines count];
        for (int a=0; a<count; a++) {
            Link *link = [lines objectAtIndex:a];
            link.pgrid.link = nil;
            link.pgrid = nil;
            //[link removeFromParentAndCleanup:YES];//暂时不删除，因为合并的时候，Link会移动到目的地，移动接触后删除，Link的startMovePointTo方法
        }
    } 
}



#pragma mark ----兔子操作----

//得到所有的空白grid
-(NSMutableArray *)getAllBlankGrids{
    track();
    NSMutableArray *blankGrid = [NSMutableArray array];
    
    NSMutableArray *grids = [gameScene getGrids];
    int len = [grids count];
    for (int i=(len-1); i>=0; i--) {
        NSMutableArray *lines = [grids objectAtIndex:i];
        int count = [lines count];
        for (int a=0; a<count; a++) {
            Grid *grid = [lines objectAtIndex:a];
            if (grid.link == nil) {
                [blankGrid addObject:grid];
            }
        }
    } 
    return blankGrid;
}


NSInteger sortObjectsByTag1(id obj1, id obj2, void *context)
{
    
    NSNumber * order1 = [NSNumber numberWithInt: ((Link *)obj1).order];
    NSNumber * order2 = [NSNumber numberWithInt: ((Link *)obj2).order];
    //sort by desc 
    return [order1 compare:order2];//（升序）
}

//得到地图上所有的普通兔子
-(NSMutableArray *)getAllRabbitLevel1Array{
    track();
    CCArray *array = gameScene.children;
    
    NSMutableArray *rabbitArray = [NSMutableArray array];
    
    for (int i = 0; i<[array count]; i++) {
        id link = [array objectAtIndex:i];
        if ([link isKindOfClass:[Link class]] && ((Link*)link).type == Link_Type_Rabbit && ((Link*)link).level == 1) {
            [rabbitArray addObject:link];
        }   
    }
    
    NSArray *newarr = [rabbitArray sortedArrayUsingFunction:sortObjectsByTag1 context:nil];
    
    NSMutableArray *mutablearray = [NSMutableArray arrayWithArray:newarr];
    
    return mutablearray;
}
//得到地图上所有的飞兔
-(NSMutableArray *)getAllRabbitLevel2Array{
    track();
    CCArray *array = gameScene.children;
    
    NSMutableArray *rabbitArray = [NSMutableArray array];
    
    for (int i = 0; i<[array count]; i++) {
        id link = [array objectAtIndex:i];
        if ([link isKindOfClass:[Link class]] && ((Link*)link).type == Link_Type_Rabbit && ((Link*)link).level == 2) {
            [rabbitArray addObject:link];
        }   
    }
    
    NSArray *newarr = [rabbitArray sortedArrayUsingFunction:sortObjectsByTag1 context:nil];
    
    NSMutableArray *mutablearray = [NSMutableArray arrayWithArray:newarr];
    
    return mutablearray;
}
//得到地图上所有的兔子
-(NSMutableArray *)getAllRabbit{
    track();
    CCArray *array = gameScene.children;
    
    NSMutableArray *rabbitArray = [NSMutableArray array];
    
    for (int i = 0; i<[array count]; i++) {
        id link = [array objectAtIndex:i];
        if ([link isKindOfClass:[Link class]] && ((Link*)link).type == Link_Type_Rabbit) {
            [rabbitArray addObject:link];
        }   
    }
    NSArray *newarr = [rabbitArray sortedArrayUsingFunction:sortObjectsByTag1 context:nil];
    
    NSMutableArray *mutablearray = [NSMutableArray arrayWithArray:newarr];
    return mutablearray;
}

//得到地图上所有的兔笼子
-(NSMutableArray *)getAllParkLevel1Array{
    track();
    CCArray *array = gameScene.children;
    
    NSMutableArray *parkleve1Array = [NSMutableArray array];
    
    for (int i = 0; i<[array count]; i++) {
        id link = [array objectAtIndex:i];
        if ([link isKindOfClass:[Link class]] && ((Link*)link).type == Link_Type_Park && ((Link*)link).level == 1) {
            [parkleve1Array addObject:link];
        }   
    }
    return parkleve1Array;
}
//递归循环上下左右的格子，
-(BOOL)checkRabbitDie4Dirctions:(Grid *)grid :(Link *)firstLink :(NSMutableArray *)findArray{
    grid.isFinded = YES;
    //找上
    Grid *top       = [self gTop:grid];
    Grid *right     = [self gRight:grid];
    Grid *down      = [self gDown:grid];
    Grid *left      = [self gLeft:grid];
    
    /*
     top.isFinded = YES;
     right.isFinded = YES;
     down.isFinded = YES;
     left.isFinded = YES;
     */
    
    if (top!=nil && !top.isFinded) {
        if (top.link!=nil) {
            if (top.link.type == Link_Type_Rabbit && top.link.level == 1) {
                //trace(@"find %d %d",top.x,top.y);
                BOOL isDie =  [self checkRabbitDie4Dirctions:top :firstLink :findArray];
                [top findOneTime];
                [findArray addObject:top.link];
                if (isDie) {
                    // return YES;
                }else {
                    return NO;
                }
            }else if(top.link.type == Link_Type_Rabbit && top.link.level == 2){
                return NO;
            }
        }else {
            return NO;
        }
        
    }
    if (right!=nil && !right.isFinded) {
        if (right.link!=nil) {
            if (right.link.type == Link_Type_Rabbit && right.link.level == 1) {
                //trace(@"find %d %d",right.x,right.y);
                BOOL isDie = [self checkRabbitDie4Dirctions:right :firstLink :findArray];
                [right findOneTime];
                [findArray addObject:right.link];
                if (isDie) {
                    //return YES;
                }else {
                    return NO;
                }
            }else if(right.link.type == Link_Type_Rabbit && right.link.level == 2){
                return NO;
            }
        }else {
            return NO;
        }
        
    }
    if (down != nil && !down.isFinded){
        if (down.link!=nil) {
            if (down.link.type == Link_Type_Rabbit && down.link.level == 1) {
                //trace(@"find %d %d",down.x,down.y);
                BOOL isDie = [self checkRabbitDie4Dirctions:down :firstLink :findArray];
                [down findOneTime];
                [findArray addObject:down.link];
                if (isDie) {
                    //return YES;
                }else {
                    return NO;
                }
            }else if(down.link.type == Link_Type_Rabbit && down.link.level == 2){
                return NO;
            }
        }else {
            return NO;
        }
    }
    if (left != nil && !left.isFinded) {
        if (left.link!=nil) {
            if (left.link.type == Link_Type_Rabbit && left.link.level == 1) {
                //trace(@"find %d %d",left.x,left.y);
                BOOL isDie = [self checkRabbitDie4Dirctions:left :firstLink :findArray];
                [left findOneTime];
                [findArray addObject:left.link];
                if (isDie) {
                    //return YES;
                }else {
                    return NO;
                }
            }else if(left.link.type == Link_Type_Rabbit && left.link.level == 2){
                return NO;
            }
        }else {
            return NO;
        }
    }
    return YES;
}
//是否需要变成石头
-(NSMutableArray *)checkAllRabiit{
    track();
    
    NSMutableArray *diesArray = [NSMutableArray array]; 
    NSMutableArray *rabbitArray = [self getAllRabbitLevel1Array];
    //NSMutableArray *rabbitArray = [self getAllRabbit];
    int len = [rabbitArray count];
    if (len<=0) {
        return diesArray;
    }
    for (int i=0; i<len; i++) {
        //储存当前的Link
        //curLink = [rabbitArray objectAtIndex:i];
        
        Link *postLink = [rabbitArray objectAtIndex:i];
        
        NSMutableArray *findArray = [NSMutableArray array];
        
        //得到周围所有的于此相同的 
        BOOL isdie = [self checkRabbitDie4Dirctions:postLink.pgrid :postLink :findArray];
        if (isdie) {
            //变成石头
            [diesArray addObject:postLink];
            trace(@"!!!!!!!!!!!!!!!!!!!!!!find die rabbit");
        }
        
        //刷新所有的查找状态
        [self resetAllGridsState:NO];
        
        /*
         
         //处理tempFindLinks
         [self clearTempFindLinksArray];
         tempFindLinks = [findArray retain];//全局数组指向
         trace(@"tempFindLinks : %d",[tempFindLinks retainCount]);*/
        
    }
    return diesArray;
}

//移动兔子
-(void)moveAllRabiit{
    //强盗兔，飞兔操作
    NSMutableArray *array2 =  [self getAllRabbitLevel2Array];
    int len2 = [array2 count];
    for (int i = 0; i<len2; i++) {
        Link *link = [array2 objectAtIndex:i];
        CGPoint oldPoint = link.position;
        
        NSMutableArray *blankgrids = [self getAllBlankGrids];
        int blanklength = [blankgrids count];
        if (blanklength<=0) {
            continue;
        }
        int random = arc4random()%blanklength;
        
        Grid *grid = [blankgrids objectAtIndex:random];
        //trace(@"random:%d",random);
        
        link.pgrid.link = nil;
        link.pgrid = grid;
        //link.position = grid.position;
        grid.link = link;
        
        CGPoint newPoint = grid.position;
        
        
        [link moveRabbitToTarget:newPoint];
        //更换显示层次
        [gameScene reorderChild:link z:(7 - link.pgrid.y + 70)];
        //[link runAction:seq];
        
        /*
         CCMoveTo *moveto1 = [CCMoveTo actionWithDuration:0.5 position:CGPointMake((oldPoint.x+newPoint.x)*0.5, 460)];
         CCEaseOut *easein = [CCEaseOut actionWithAction:moveto1 rate:2];
         
         CCMoveTo *moveto2 = [CCMoveTo actionWithDuration:0.5 position:newPoint];
         CCEaseIn *easeout = [CCEaseIn actionWithAction:moveto2 rate:2];
         
         CCSequence *seq = [CCSequence actions:easein,easeout, nil];
         [link runAction:seq];*/
    }
    
    //普通的兔子
    NSMutableArray *array1 =  [self getAllRabbitLevel1Array];
    //每次打乱数组，这样兔子的走动顺序就彻底随机了
    for (int x = 0; x < [array1 count]; x++) {
        int randInt = (arc4random() % ([array1 count] - x)) + x;
        [array1 exchangeObjectAtIndex:x withObjectAtIndex:randInt];
    }
    
    int len1 = [array1 count];
    for (int i = 0; i<len1; i++) {
        Link *link = [array1 objectAtIndex:i];
        Grid *grid = link.pgrid;
        
        Grid *gtop = [self gTop:grid];
        Grid *gRight = [self gRight:grid];
        Grid *gDown = [self gDown:grid];
        Grid *gLeft = [self gLeft:grid];
        
        NSMutableArray *pipeoarray = [NSMutableArray array];
        (gtop!=nil&&gtop.link==nil)?[pipeoarray addObject:gtop]:1;
        (gRight!=nil&&gRight.link==nil)?[pipeoarray addObject:gRight]:1;
        (gDown!=nil&&gDown.link==nil)?[pipeoarray addObject:gDown]:1;
        (gLeft!=nil&&gLeft.link==nil)?[pipeoarray addObject:gLeft]:1;
        
        int lenPipei = [pipeoarray count];
        if (lenPipei<=0) {
            continue;
        }
        
        int random = arc4random()%lenPipei;
        
        Grid *targetgrid = [pipeoarray objectAtIndex:random];
        
        link.pgrid.link = nil;
        link.pgrid = targetgrid;
        targetgrid.link = link;
        
        //移动兔子
        [link moveRabbitToTarget:targetgrid.position];
        //更换显示层次
        [gameScene reorderChild:link z:(7 - link.pgrid.y + 70)];
        
        //CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.8 position:targetgrid.position];
        //[link runAction:moveTo];
        
    }
}

//吧所有的飞天兔子变成石头
-(void)allLevel2RabbitToPark{
    NSMutableArray *diesArray = [self getAllRabbitLevel2Array];
    
    for (int i = 0; i<[diesArray count]; i++) {
        Link *dieRabbit = [diesArray objectAtIndex:i];
        Grid *grid = dieRabbit.pgrid;
        //创建宝箱，并渐变加入场景
        Link *park1 = [[Link createByType:Link_Type_Park andLelve:1] retain];//这里需要retain下，因为在putNewLinkInScene中release了下
        
        dieRabbit.pgrid = nil;
        [dieRabbit removeFromParentAndCleanup:YES];
        
        
        grid.link = park1;
        park1.pgrid = grid;
        [gameScene putNewLinkInScene:park1 :grid];
        
        CCFadeIn *fadein = [CCFadeIn actionWithDuration:0.2];
        [park1 runAction:fadein];
    }
    
}


//吧所有兔子变成石头
-(void)allRabbitToPark{
    NSMutableArray *diesArray = [self getAllRabbit];
    
    for (int i = 0; i<[diesArray count]; i++) {
        Link *dieRabbit = [diesArray objectAtIndex:i];
        Grid *grid = dieRabbit.pgrid;
        //创建宝箱，并渐变加入场景
        Link *park1 = [[Link createByType:Link_Type_Park andLelve:1] retain];//这里需要retain下，因为在putNewLinkInScene中release了下
        
        dieRabbit.pgrid = nil;
        [dieRabbit removeFromParentAndCleanup:YES];
        
        
        grid.link = park1;
        park1.pgrid = grid;
        [gameScene putNewLinkInScene:park1 :grid];
        
        CCFadeIn *fadein = [CCFadeIn actionWithDuration:0.2];
        [park1 runAction:fadein];
    }
    
}













#pragma mark ----得分显示----

-(void)showGetScoreEffect_ForFindLinks:(NSArray *)arr{
    Link *link = [arr objectAtIndex:0];
    CGPoint position = [[arr objectAtIndex:1] CGPointValue];
    BOOL isDouble = [[arr objectAtIndex:2] boolValue];
    
    [self showGetScoreEffect:link isdouble:isDouble position:position];
}
-(void)showGetScoreEffect:(Link *)link{
    CGPoint point = link.pgrid.position;
    [self showGetScoreEffect:link isdouble:NO position:point] ;
}

-(void)showGetScoreEffect:(Link *)link isdouble:(BOOL)twoDouble position:(CGPoint)pos{
    //复制1个
    Link *slink = [link copyOne];
    //分数
    int score = link.score;
    
    //分数为0的话，则不显示，特殊情况下，多个兔子，多块区域同时合并的情况，所以会出现显示很多的0分，所有吧0分给隐藏掉
    if (score==0) {
        return;
    }
    
    //加分 减分
    [gameScene add_cut_score:score];
    
    NSString *scorestr;
    if (twoDouble) { //双倍的话，分数翻倍
        scorestr = [NSString stringWithFormat:@"%d",score * 2];
    }else {
        scorestr = [NSString stringWithFormat:@"%d",score];
    }
    
    CCLabelAtlas *labelscore = [CCLabelAtlas labelWithString:scorestr charMapFile:@"text1.png" itemWidth:11 itemHeight:15 startCharMap:'0'];
    labelscore.anchorPoint = ccp(0.5,0.5);
    //容器
    CCSprite *container = [CCSprite node];
    slink.scale = 0.7;
    slink.position = ccp(0,20);
    
    labelscore.position = ccp(0,-5);
    
    [container addChild:slink];
    [container addChild:labelscore z:101];
    
    CGPoint posit = pos;
    container.position = ccp(posit.x,posit.y+30);
    
    //加入容器
    [gameScene addChild:container z:100];
    
    //运动
    CCMoveTo *moveto        = [CCMoveTo actionWithDuration:1 position:ccp(posit.x, posit.y+70)];
    CCEaseIn *easeMove = [CCEaseIn actionWithAction:moveto rate:3];
    
    CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(removeScore:)];
    
    CCSequence *sequen = [CCSequence actions:easeMove,callback, nil];
    
    [container runAction:sequen];
    
    CCFadeOut *fadetout     = [CCFadeOut actionWithDuration:1];
    CCEaseIn *easeMove1 = [CCEaseIn actionWithAction:fadetout rate:3];
    
    CCFadeOut *fadetout2     = [CCFadeOut actionWithDuration:1];
    CCEaseIn *easeMove2 = [CCEaseIn actionWithAction:fadetout2 rate:3];
    [slink runAction:easeMove1];
    [labelscore runAction:easeMove2];
}

-(void)removeScore:(CCSprite *)sp{
    [sp removeFromParentAndCleanup:YES];
}

//处理tempFindLinks  进行加分
-(void)showFindLinkScoreEffect:(Link *)link position:(CGPoint)pos{
    if (tempFindLinks==nil || [tempFindLinks count]<=0) {
        return;
    }
    //得到有几个数组
    int len = [tempFindLinks count];
    
    for (int i=0 ; i<len; i++) {
        NSMutableArray *array = [tempFindLinks objectAtIndex:i];
        int alen = [array count];
        Link *link = [self getSuperLink:(Link *)[array objectAtIndex:0]];
        
        float time = 0.8+i*(0.8);
        if (alen>=3) {  //双倍
            NSArray *param = [NSArray arrayWithObjects:
                              link,
                              [NSValue valueWithCGPoint:pos], 
                              [NSNumber numberWithBool:YES], nil];
            [self performSelector:@selector(showGetScoreEffect_ForFindLinks:) withObject:param afterDelay:time];
        }else {         //不双倍
            
            NSArray *param = [NSArray arrayWithObjects:
                              link,
                              [NSValue valueWithCGPoint:pos], 
                              [NSNumber numberWithBool:NO], nil];
            [self performSelector:@selector(showGetScoreEffect_ForFindLinks:) withObject:param afterDelay:time];
        }
    }
    
}


-(void) showLostScoreEffect:(Grid *)grid score:(int)num{
    
    if (num==0) {//为0的话，还显示什么动画呢
        return;
    }
    
    NSString *scorestr = [NSString stringWithFormat:@"%d",num];
    
    CCLabelTTF *labelscore = [CCLabelTTF labelWithString:scorestr fontName:@"Helvetica" fontSize:16];
    labelscore.color = ccRED;
    labelscore.anchorPoint = ccp(0.5,0.5);
    
    
    CGPoint posit = grid.position;
    
    labelscore.position = ccp(posit.x,posit.y+30);
    
    //加入容器
    [gameScene addChild:labelscore z:2];
    
    //运动
    CCMoveTo *moveto        = [CCMoveTo actionWithDuration:1 position:ccp(posit.x, posit.y+70)];
    CCEaseIn *easeMove = [CCEaseIn actionWithAction:moveto rate:3];
    
    CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(removeScore:)];
    
    CCSequence *sequen = [CCSequence actions:easeMove,callback, nil];
    
    [labelscore runAction:sequen];
    
    /*
     CCFadeOut *fadetout     = [CCFadeOut actionWithDuration:1];
     CCEaseIn *easeMove1 = [CCEaseIn actionWithAction:fadetout rate:3];
     
     CCFadeOut *fadetout2     = [CCFadeOut actionWithDuration:1];
     CCEaseIn *easeMove2 = [CCEaseIn actionWithAction:fadetout2 rate:3];
     [moneyIco runAction:easeMove1];
     [labelscore runAction:easeMove2];*/
}

#pragma mark ---得金币显示 动画----
-(void) showGetMoneyEffect:(Grid *)grid money:(int)num{
    
    NSString *moneystr = [NSString stringWithFormat:@"%d",num];
    
    //容器
    CCSprite *container = [CCSprite node];
    
    CCSprite *moneyIco = [CCSprite spriteWithSpriteFrameName:@"ico_money.png"];
    CCLabelAtlas *labelscore = [CCLabelAtlas labelWithString:moneystr charMapFile:@"text2.png" itemWidth:7 itemHeight:12 startCharMap:'0'];
    labelscore.anchorPoint = ccp(0.5,0.5);
    
    moneyIco.position = ccp(-10,0);
    labelscore.position = ccp(15,0);
    
    [container addChild:moneyIco];
    [container addChild:labelscore];
    
    CGPoint posit = grid.position;
    container.position = ccp(posit.x,posit.y+30);
    
    //加入容器
    [gameScene addChild:container z:100];
    
    //运动
    CCMoveTo *moveto        = [CCMoveTo actionWithDuration:1 position:ccp(posit.x, posit.y+70)];
    CCEaseIn *easeMove = [CCEaseIn actionWithAction:moveto rate:3];
    
    CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(removeScore:)];
    
    CCSequence *sequen = [CCSequence actions:easeMove,callback, nil];
    
    [container runAction:sequen];
    
    CCFadeOut *fadetout     = [CCFadeOut actionWithDuration:1];
    CCEaseIn *easeMove1 = [CCEaseIn actionWithAction:fadetout rate:3];
    
    CCFadeOut *fadetout2     = [CCFadeOut actionWithDuration:1];
    CCEaseIn *easeMove2 = [CCEaseIn actionWithAction:fadetout2 rate:3];
    [moneyIco runAction:easeMove1];
    [labelscore runAction:easeMove2];
}

#pragma mark ---炸弹显示动画---
-(void)showBomEffect:(Grid *)grid{
    CCAnimation *bom = [CCAnimation animationWithFrame:@"zd_" frameCount:12 delay:0.1];
    CCSprite *sp = [CCSprite spriteWithSpriteFrameName:@"zd_01.png"];
    
    
    //[grid addChild:sp];
    [gameScene addChild:sp z:100];
    sp.position = ccp(grid.position.x,grid.position.y + 35);
    CCAnimate *animate = [CCAnimate actionWithAnimation:bom];
    
    CCCallFuncN *callback = [CCCallFuncN actionWithTarget:self selector:@selector(bomover:)];
    CCSequence *seq = [CCSequence actions:animate,callback, nil];
    
    [sp runAction:seq];
}
-(void)bomover:(CCSprite *)sp{
    [sp removeFromParentAndCleanup:YES];
}

#pragma mark ---记录游戏物体数据 和 恢复游戏物体数据---
//记住游戏物体
-(NSMutableArray *)recordLinks{  
    NSMutableArray *record = [NSMutableArray array];
    
    NSMutableArray *grids = [gameScene getGrids];
    int len = [grids count];
    for (int i=0; i<len; i++) {
        NSMutableArray *lines = [grids objectAtIndex:i];
        NSMutableArray *recordLine = [NSMutableArray array];
        int count = [lines count];
        
        for (int a=0; a<count; a++) {
            Grid *grid = [lines objectAtIndex:a];
            
            NSMutableDictionary *recodGrid = [NSMutableDictionary dictionary];
            if (grid.link != nil) {
                [recodGrid setValue:[NSNumber numberWithInt:grid.link.type] forKey:@"type"];
                [recodGrid setValue:[NSNumber numberWithInt:grid.link.level] forKey:@"level"];
                [recodGrid setValue:[NSNumber numberWithBool:grid.link.issuper] forKey:@"issuper"];
            }
            
            [recordLine addObject:recodGrid];
            
        }
        [record addObject:recordLine];
    }
    return record;
}

//恢复
-(void)recoverHistoryGridsData:(NSMutableArray *)grids :(NSMutableArray *)historygrids{ 
    int len = [grids count];
    for (int i=0; i<len; i++) {
        NSMutableArray *lines = [grids objectAtIndex:i];
        NSMutableArray *recordLine = [historygrids objectAtIndex:i];
        
        int count = [lines count];
        for (int a=0; a<count; a++) {
            Grid *grid = [lines objectAtIndex:a];
            NSMutableDictionary *recodGrid = [recordLine objectAtIndex:a];
            
            NSArray *keys = [recodGrid allKeys];
            if (keys==nil || [keys count]==0) {//没有link
                
            }else {//存在link
                
                Link_Type type = [[recodGrid objectForKey:@"type"] intValue];
                int level = [[recodGrid objectForKey:@"level"] intValue];
                BOOL issuper = [[recodGrid objectForKey:@"issuper"] boolValue];
                
                if (type==Link_Type_Wall) {//是墙壁的话，初始化的时候已经执行，这里了就不需要了
                    continue;
                }
                
                //创建对应的link，并且加入场景
                Link *link = [Link createByType:type andLelve:level issuper:issuper];
                [grid setLinkRelation:link];
                [gameScene addChild:link];
                link.pgrid = grid;
                link.position = ccp(grid.position.x,grid.position.y);
                
            }
            
        }
        
    }
    
    
    /*
     NSMutableArray *record = [NSMutableArray array];
     
     int len = [grids count];
     for (int i=0; i<len; i++) {
     NSMutableArray *lines = [grids objectAtIndex:i];
     NSMutableArray *recordLine = [NSMutableArray array];
     int count = [lines count];
     
     for (int a=0; a<count; a++) {
     Grid *grid = [lines objectAtIndex:a];
     
     NSMutableDictionary *recodGrid = [NSMutableDictionary dictionary];
     if (grid.link != nil) {
     [recodGrid setValue:[NSNumber numberWithInt:grid.link.type] forKey:@"type"];
     [recodGrid setValue:[NSNumber numberWithInt:grid.link.level] forKey:@"level"];
     [recodGrid setValue:[NSNumber numberWithBool:grid.link.issuper] forKey:@"issuper"];
     }
     
     [recordLine addObject:recodGrid];
     
     }
     [record addObject:recordLine];
     }*/
}

//恢复上一步
-(void)recoverLastTempGridsData:(NSMutableArray *)grids :(NSMutableArray *)historygrids{ 
    int len = [grids count];
    for (int i=0; i<len; i++) {
        NSMutableArray *lines = [grids objectAtIndex:i];
        NSMutableArray *recordLine = [historygrids objectAtIndex:i];
        
        int count = [lines count];
        for (int a=0; a<count; a++) {
            Grid *grid = [lines objectAtIndex:a];
            NSMutableDictionary *recodGrid = [recordLine objectAtIndex:a];
            
            NSArray *keys = [recodGrid allKeys];
            if (keys==nil || [keys count]==0) {//没有link
                if (grid.link != nil) {
                    Link *link = grid.link;
                    grid.link = nil;
                    link.pgrid = nil;
                    [link removeFromParentAndCleanup:YES];
                }
                
            }else {//存在link
                
                Link_Type type = [[recodGrid objectForKey:@"type"] intValue];
                int level = [[recodGrid objectForKey:@"level"] intValue];
                BOOL issuper = [[recodGrid objectForKey:@"issuper"] boolValue];
                
                if (grid.link.type != type || grid.link.level != level) {
                    Link *link = grid.link;
                    grid.link = nil;
                    link.pgrid = nil;
                    [link removeFromParentAndCleanup:YES];
                    
                    //创建对应的link，并且加入场景
                    Link *new = [Link createByType:type andLelve:level issuper:issuper];
                    [grid setLinkRelation:new];
                    [gameScene addChild:new];
                    new.pgrid = grid;
                    new.position = ccp(grid.position.x,grid.position.y);
                }
                
                
            }
            
        }
        
    }
    
}

#pragma mark ---游戏结束控制----
//查看地图上面是否存在宝箱
-(BOOL)checkExistBaoXiang{
    NSMutableArray *grids = [gameScene getGrids];
    int len = [grids count];
    for (int i=(len-1); i>=0; i--) {
        NSMutableArray *lines = [grids objectAtIndex:i];
        int count = [lines count];
        for (int a=0; a<count; a++) {
            Grid *grid = [lines objectAtIndex:a];
            Link *link = grid.link;
            if (link != nil && link.type == Link_Type_Park && (link.level==4 || link.level==5)) {
                return YES;
            }
        }
    }
    return NO;
}

//查看仓库是否为空
-(BOOL)checkRoomIsEmpty{
    for (id sp in gameScene.children) {
        if ([sp isKindOfClass:[GameRoom class]]) {
            GameRoom *room = (GameRoom *)sp;
            if ([room isEmpty]) {
                return YES;
            }
        }
    }
    return NO;
}

//仓库是否有炸弹
-(BOOL)checkRoomHasBom{
    for (id sp in gameScene.children) {
        if ([sp isKindOfClass:[GameRoom class]]) {
            GameRoom *room = (GameRoom *)sp;
            Link *link = [room getStoreLink];
            if (link.type == Link_Type_Tool && link.level == 2) {
                return YES;
            }
        }
    }
    return NO;
}





//检测游戏是否结束
-(BOOL)checkGameOver{
    NSMutableArray *grids = [gameScene getGrids];
    int len = [grids count];
    for (int i=(len-1); i>=0; i--) {
        NSMutableArray *lines = [grids objectAtIndex:i];
        int count = [lines count];
        for (int a=0; a<count; a++) {
            Grid *grid = [lines objectAtIndex:a];
            if (grid.link == nil) {
                return NO;
            }
        }
    }
    return YES;
}


//显示links的合成信息
-(void)showCurrentLinkInfor:(Link *)link{
    [gamelinksinfor showInfor:link];
}

//显示links的合成信息
-(void)showFindLinksInfor{
    //tempFindLinks
    [gamelinksinfor showFindLinks:tempFindLinks];
    //放大
}








-(void)clearTempFindLinksArray{
    [tempFindLinks release];
    tempFindLinks = nil;
}

//停止所有的perform
-(void)cancelAllPerform{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

-(void)dealloc{
    [tempFindLinks release];
    [super dealloc];
}


@end
