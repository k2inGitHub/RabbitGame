//
//  CCLeafBy.m
//  CityMaster
//
//  Created by 宋扬 on 16/6/8.
//  Copyright © 2016年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "CCLeafTo.h"
#import "cocos2d.h"

@implementation CCLeafTo

+(id) actionWithDuration: (ccTime) t andA:(float)a
{
    return [[[self alloc] initWithDuration:t andA:a ] autorelease];
}

-(id) initWithDuration: (ccTime) t andA:(float)a
{
    if( (self=[super initWithDuration: t]) ){
        
//        CCMoveTo
        _a = a;
    }
    return self;
}

-(void) startWithTarget:(CCNode *)aTarget
{
    [super startWithTarget:aTarget];
    _startPosition = ccpAdd([aTarget position], ccp(0, -_a));// [aTarget position];
    
    _delta = 0;
}

-(void) update: (ccTime) t
{
    CCLOG(@"t = %f", t);
//    _delta += t;
    
//    float t2 = _delta /
    float t2 = t * M_PI * 2;
    float y = _a * (2 * cos(t2) - cos(2 * t2));
    float x = _a * (2 * sin(t2) - sin(2 * t2));
    [target_ setPosition: ccp( (_startPosition.x + x ), (_startPosition.y + y ) )];
    if (t == 1 || t == 0) {
        CCLOG(@"x = %f", x);
        CCLOG(@"y = %f", y);
    }
}

//-(CCActionInterval*) reverse
//{
//    return [[self class] actionWithDuration:duration_ position:ccp( -delta_.x, -delta_.y)];
//}

@end
