//
//  CCLeafBy.h
//  CityMaster
//
//  Created by 宋扬 on 16/6/8.
//  Copyright © 2016年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "CCActionInterval.h"

@interface CCLeafTo : CCActionInterval
{
//    CGPoint delta_;
    float _a;
    CGPoint _startPosition;
    float _delta;
}

+(id) actionWithDuration: (ccTime) t andA:(float)a;
@end

