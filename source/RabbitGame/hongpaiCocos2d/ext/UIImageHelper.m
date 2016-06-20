//
//  UIImageHelper.m
//  RabbitGame
//
//  Created by pai hong on 12-7-12.
//  Copyright (c) 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "UIImageHelper.h"

@implementation UIImage (Extras) 
// UIImage+Extras.m  
- (id)initWithContentsOfResolutionIndependentFile:(NSString *)path {  
    
    if ( [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] >= 2.0 ) {
        NSString *path2x = [[path stringByDeletingLastPathComponent]   
                            stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-hd.%@",   
                                                            [[path lastPathComponent] stringByDeletingPathExtension],   
                                                            [path pathExtension]]];  
        
        if ( [[NSFileManager defaultManager] fileExistsAtPath:path2x] ) {  
            return [self initWithCGImage:[[UIImage imageWithData:[NSData dataWithContentsOfFile:path2x]] CGImage] scale:2.0 orientation:UIImageOrientationUp];  
        }  
    }  
    
    return [self initWithData:[NSData dataWithContentsOfFile:path]];  
}  

+ (UIImage*)imageWithContentsOfResolutionIndependentFile:(NSString *)path {  
    return [[[UIImage alloc] initWithContentsOfResolutionIndependentFile:path] autorelease];  
}  
@end
