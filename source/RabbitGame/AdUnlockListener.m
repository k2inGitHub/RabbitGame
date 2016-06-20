//
//  AdUnlockListener.m
//  CityMaster
//
//  Created by 宋扬 on 16/6/7.
//  Copyright © 2016年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "AdUnlockListener.h"
#import "HLService.h"

@implementation AdUnlockListener

- (void)show{
    [[HLAdManager sharedInstance] showEncourageInterstitial];
}

- (void)onInterstitialFinish:(HLAdType *)adType {
    if (self.onFinish != nil) {
        self.onFinish(self);
    }
}

- (instancetype)init{
    self = [super init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInterstitialFinish:) name:HLInterstitialFinishNotification object:nil];
    
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
    
}

@end
