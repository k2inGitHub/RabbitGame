//
//  EEAnimateLabel.m
//  RabbitGame
//
//  Created by pai hong on 12-8-6.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "EEAnimateLabel.h"


@implementation EEAnimateLabel

-(void)setString:(NSString *)label{
    curValue = 0;
    target = [label intValue];
    float jumpSpace = 0.1;
    float during = 3;
    
    spaceValue = target / (during/jumpSpace);
    
    if (target<=3) {
        [super setString:label];        
    }else {
        [self schedule:@selector(rollLabel) interval:jumpSpace];
        [super setString:@""];
    }
    
}

-(void)rollLabel{
    curValue += spaceValue;
    if (curValue>=target) {
        curValue = target;
        [self unschedule:@selector(rollLabel)];
    }
    
    int t = (int)curValue;
    NSString *text = [NSString stringWithFormat:@"%d",t];
    [super setString:text];
}

-(void)onExit{
    [self unscheduleAllSelectors];
    [super onExit];
}


@end
