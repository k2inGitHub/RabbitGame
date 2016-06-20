//
//  LocalScoreLoader.h
//  BookReader
//
//  Created by terababy on 10-8-26.
//  Copyright 2010 terababy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAnalyst.h"


@interface MyUserAnalyst : UserAnalyst {
}

+ (void)playLevel:(int)mode theme:(int)theme level:(int)level;
@end
