//
//  AdUnlockListener.h
//  CityMaster
//
//  Created by 宋扬 on 16/6/7.
//  Copyright © 2016年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AdUnlockListener : NSObject
typedef void (^AdUnlockListenerBlock) (AdUnlockListener * __nonnull listener);
@property (nonatomic, copy, nullable) AdUnlockListenerBlock onFinish;

- (void)show;



@end
