//
//  GameScore.m
//  RabbitGame
//
//  Created by pai hong on 12-6-22.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "GameScore.h"
#import "GameScene.h"
#import "OpenLevel.h"


@implementation GameScore


-(void)onEnter{
    track();
    

//    scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:UseSysFont fontSize:18];
    scoreLabel = [CCLabelAtlas labelWithString:@"0" charMapFile:@"number-ui.png" itemWidth:9 itemHeight:15 startCharMap:'0'];
    scoreLabel.anchorPoint = ccp(1,0.5);
    CGSize size = self.contentSize;
    trace(@"%f %f",size.width,size.height);
    [self addChild:scoreLabel];
    scoreLabel.position = ccp(size.width-20,size.height*0.5);
    
    if ([Globel shareGlobel].isInCourse) {
        //设置分数
        score = 0;
        scoreLabel.string  = @"0";
    }else {
        //设置分数
        //读取存档数据
        NSMutableArray *historygrids = [[GameScene shareInstance] getLevelConfigDate:@"archive"];
        if (historygrids!=nil && [historygrids count] != 0) {//说明是第一次玩
            NSString *configscore = [[GameScene shareInstance] getLevelConfigDate:@"currentscore"];
            score = [configscore intValue];
            scoreLabel.string  = configscore;
            // 测试最高值时位置是否可以
            //scoreLabel.string  = @"10000000";
        }
    }
    
    [super onEnter];
}

-(int)getScore{
    return score;
}

-(void)refreshScore{
    trace(@"%@",scoreLabel);
    scoreLabel.string = [NSString stringWithFormat:@"%d",score];
    
    
    //打开第4关
    if (score>=300000) {
        [[OpenLevel shareInstance] openLevel4];
    }
    if(score>=600000){//打开第6关
        
        [[OpenLevel shareInstance] openLevel6];
    }
    if(score>=1000000){//打开第7关
        
        [[OpenLevel shareInstance] openLevel7];
    }
    if(score>=1500000){//打开第8关
        
        [[OpenLevel shareInstance] openLevel8];
    }
}

-(void)add_cut_score:(int)s{
    score = score + s;
    if (score<0) {
        score = 0;
    }
    [self refreshScore];
}

-(void)set_score:(int)sc{
    score = sc;
    
    [[GameScene shareInstance] setLevelConfigDate:[NSString stringWithFormat:@"%d",score] key:@"currentscore"];
    
    [self refreshScore];
}


@end
