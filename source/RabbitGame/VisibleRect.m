//
//  VisibleRect.m
//  CityMaster
//
//  Created by 宋扬 on 16/6/3.
//  Copyright © 2016年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "VisibleRect.h"

static CGRect s_visibleRect;

@implementation VisibleRect

+ (CGRect)getVisibleRect{
    [self lazyInit];
    return s_visibleRect;
}

+ (CGPoint)left{
    [self lazyInit];
    return ccp(s_visibleRect.origin.x, s_visibleRect.origin.y+s_visibleRect.size.height/2);
}

+ (CGPoint)right{
    [self lazyInit];
    return ccp(s_visibleRect.origin.x+s_visibleRect.size.width, s_visibleRect.origin.y+s_visibleRect.size.height/2);
}

+ (CGPoint)top{
    [self lazyInit];
    

    return ccp(s_visibleRect.origin.x+s_visibleRect.size.width/2, s_visibleRect.origin.y+s_visibleRect.size.height);
}

+ (CGPoint)bottom{
    [self lazyInit];
    return ccp(s_visibleRect.origin.x+s_visibleRect.size.width/2, s_visibleRect.origin.y);
}

+ (CGPoint)center{
    [self lazyInit];
    return ccp(s_visibleRect.origin.x+s_visibleRect.size.width/2, s_visibleRect.origin.y+s_visibleRect.size.height/2);
}

+ (CGPoint)leftTop{
    [self lazyInit];
    
    return ccp(s_visibleRect.origin.x, s_visibleRect.origin.y+s_visibleRect.size.height);
}

+ (CGPoint)rightTop{
    [self lazyInit];
    return ccp(s_visibleRect.origin.x+s_visibleRect.size.width, s_visibleRect.origin.y+s_visibleRect.size.height);
    
}

+ (CGPoint)leftBottom{
    [self lazyInit];
    return s_visibleRect.origin;
}

+ (CGPoint)rightBottom{
    [self lazyInit];
    
    return ccp(s_visibleRect.origin.x+s_visibleRect.size.width, s_visibleRect.origin.y);
}

+ (void)lazyInit{
    s_visibleRect = [[[CCDirector sharedDirector] openGLView] frame];
}

@end
