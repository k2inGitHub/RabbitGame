//
//  SoundManagerR.h
//  RabbitGame
//
//  Created by pai hong on 12-7-10.
//  Copyright (c) 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum{
    Sound_Type_Music = 1,
    Sound_Type_Action,
    Sound_Type_Humen,
}Sound_Type;


@interface SoundManagerR : NSObject

+(SoundManagerR *)shareInstance;

-(void)playSound:(NSString *)name type:(Sound_Type)type;

@end
