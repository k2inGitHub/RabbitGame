//
//  GameMoney.m
//  RabbitGame
//
//  Created by pai hong on 12-6-22.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "GameMoney.h"


@implementation GameMoney

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void)onEnter{
    track();
    NSString * usermoney = [[Globel shareGlobel].allDataConfig objectForKey:@"usermoney"];
    // 测试最高值时位置是否可以
    //NSString * usermoney = @"300000";
    
//    moneyLabel = [CCLabelTTF labelWithString:usermoney fontName:UseSysFont fontSize:18];
    moneyLabel = [CCLabelAtlas labelWithString:usermoney charMapFile:@"number-ui.png" itemWidth:9 itemHeight:15 startCharMap:'0'];
    moneyLabel.anchorPoint = ccp(0,0.5);
    CGSize size = self.contentSize;
    [self addChild:moneyLabel];
    
    
    moneyLabel.position = ccp(38,size.height*0.5);
    
    [super onEnter];
}


-(void)refreshMoney{
    moneyLabel.string = [NSString stringWithFormat:@"%d",money];
}
-(void)refresh{
    NSString * usermoney = [[Globel shareGlobel].allDataConfig objectForKey:@"usermoney"];
    moneyLabel.string = usermoney;
    
}

-(int)getMoney{
    int usermoney = [[[Globel shareGlobel].allDataConfig objectForKey:@"usermoney"] intValue];
    return usermoney;   
}

-(void)add_cut_money:(int)m{
    money = [[[Globel shareGlobel].allDataConfig objectForKey:@"usermoney"] intValue];
    money += m;
    
    [[Globel shareGlobel].allDataConfig setValue:[NSString stringWithFormat:@"%d",money] forKey:@"usermoney"];
    [self refreshMoney];
}























@end
