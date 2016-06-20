//
//  VisibleRect.h
//  CityMaster
//
//  Created by 宋扬 on 16/6/3.
//  Copyright © 2016年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface VisibleRect : NSObject

+ (CGRect)getVisibleRect;

+ (CGPoint)left;

+ (CGPoint)right;

+ (CGPoint)top;

+ (CGPoint)bottom;

+ (CGPoint)center;

+ (CGPoint)leftTop;

+ (CGPoint)rightTop;

+ (CGPoint)leftBottom;

+ (CGPoint)rightBottom;

@end
