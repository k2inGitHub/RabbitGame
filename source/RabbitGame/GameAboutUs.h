//
//  GameAboutUs.h
//  RabbitGame
//
//  Created by pai hong on 12-7-1.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "EEMaskSprite.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class EESpriteScaleBtn;

@interface GameAboutUs : EEMaskSprite<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate> {
    
    MFMailComposeViewController *mailcontroller;
}

@end
