//
//  SoundManagerR.m
//  RabbitGame
//
//  Created by pai hong on 12-7-10.
//  Copyright (c) 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "SoundManagerR.h"
#import "SimpleAudioEngine.h"


@implementation SoundManagerR

+(SoundManagerR *)shareInstance{
    static SoundManagerR *instance = nil;
    @synchronized(self){
        if (!instance) {
            instance = [[SoundManagerR alloc] init];
        }
    }   
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        //[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@""];
        /*
         
         [[SimpleAudioEngine sharedEngine] playEffect:@"button.mp3"];    
         [[Globel shareGlobel].allDataConfig setValue:[NSNumber numberWithBool:NO] forKey:@"bgsound"];
         [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0];
         [[EncryptionConfig shareInstance] saveConfig:[Globel shareGlobel].allDataConfig];
         
         [musicOn setHight:YES];
         [musicOff setHight:NO];
         */
    }
    return self;
}

//声音是否开启
-(BOOL)isOpen:(Sound_Type)type{
    if (type == Sound_Type_Music) {
        return [[[Globel shareGlobel].allDataConfig objectForKey:@"sound_bg"] boolValue];
    }else if(type == Sound_Type_Humen){
        return [[[Globel shareGlobel].allDataConfig objectForKey:@"sound_human"] boolValue];
    }else if (type == Sound_Type_Action) {
        return [[[Globel shareGlobel].allDataConfig objectForKey:@"sound_action"] boolValue];
    }
    return YES;
}

//播放声音
-(void)playSound:(NSString *)name type:(Sound_Type)type{
    BOOL isopen = [self isOpen:type];
    
    if (type == Sound_Type_Music) {
        if (isopen) {
            [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1];
        }else {
            [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0];
        }
        [[SimpleAudioEngine sharedEngine] playEffect:name];
//        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:name loop:YES];
    }else if(type == Sound_Type_Humen){
        if (isopen) {
            [[SimpleAudioEngine sharedEngine] playEffect:name];
        }
    }else if(type == Sound_Type_Action){
        if (isopen) {
            [[SimpleAudioEngine sharedEngine] playEffect:name];
        }else {
            
        }
    }
}










@end
