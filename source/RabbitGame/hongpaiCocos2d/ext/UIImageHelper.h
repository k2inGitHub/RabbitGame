//
//  UIImageHelper.h
//  RabbitGame
//
//  Created by pai hong on 12-7-12.
//  Copyright (c) 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Extras)  

- (id)initWithContentsOfResolutionIndependentFile:(NSString *)path;  
+ (UIImage*)imageWithContentsOfResolutionIndependentFile:(NSString *)path;  

@end 