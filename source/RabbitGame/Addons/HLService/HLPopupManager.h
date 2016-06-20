//
//  HLPopupManager.h
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/29.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLPopupManager : NSObject

+ (instancetype)sharedManager;

- (void)openRateUrl;

- (void)showRate:(void(^)())onSure andCancel:(void(^)())onCancel;

- (void)showUpdate:(void(^)())onSure andCancel:(void(^)())onCancel;

@end
