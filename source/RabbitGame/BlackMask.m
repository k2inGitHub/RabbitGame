//
//  BlackMask.m
//  RabbitGame
//
//  Created by pai hong on 12-7-12.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "BlackMask.h"


@implementation BlackMask

- (id)init
{
    self = [super init];
    if (self) {        
        
        
        
        
        
    }
    return self;
}


-(void)refreshState:(CGPoint)point{
    [self removeAllChildrenWithCleanup:YES];
    
    CGSize size = [[CCDirector sharedDirector]winSize];
    float bb_width = 320;
    float bb_height = size.height;
    
    float lightwidth = 46;
    
    CCLOG(@"scale = %f", [[UIScreen mainScreen] scale]);
    
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 4 ) {
        float sc = [[UIScreen mainScreen] scale];
        bb_width = bb_width * sc;
        bb_height = bb_height * sc;
        lightwidth = lightwidth * sc;
    }else {
        
    }
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, bb_width, bb_height, 8, bb_width*4, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    CGContextSetRGBFillColor(context,  0, 0, 0, 0.5);
    

    
    CGContextSetBlendMode(context,kCGBlendModeNormal);
    CGContextFillRect(context, CGRectMake(0, 0, bb_width, bb_height));
    
    CGContextSetBlendMode(context, kCGBlendModeClear);
    
//    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 4 ) {
//        float sc = [[UIScreen mainScreen] scale];
//        sc = sc > 2 ? 2.5 : sc;
//        CGContextFillRect(context, CGRectMake(sc*point.x-lightwidth*0.5, sc*point.y-lightwidth*0.5, lightwidth, lightwidth));
//    }else {
//        CGContextFillRect(context, CGRectMake(point.x-lightwidth*0.5, point.y-lightwidth*0.5, lightwidth, lightwidth));
//
//    }
    
    
    
    CGImageRef imageref_down = CGBitmapContextCreateImage(context);
    
    
    CCSprite *sp = [CCSprite spriteWithCGImage:imageref_down key:nil];
    [self addChild:sp];
    
    CGImageRelease(imageref_down);
    CGContextRelease(context);
    

}

@end
