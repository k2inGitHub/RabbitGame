//
//  AWScreenshot.h
//  RabbitGame
//
//  Created by pai hong on 12-7-5.
//  Copyright (c) 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "cocos2d.h"

@interface AWScreenshot :NSObject
{
}

+(CGImageRef) takeAsCGImage;

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
+(UIImage*) takeAsImage;
#else
+(CGImageRef) takeAsImage;
#endif

+(CCTexture2D*) takeAsTexture;

@end