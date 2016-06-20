//
//  GameAboutUs.m
//  RabbitGame
//
//  Created by pai hong on 12-7-1.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "GameAboutUs.h"
#import "EESpriteScaleBtn.h"
#import "SoundManagerR.h"


@implementation GameAboutUs

//创建影片剪辑
-(void)creatSpriteByFramename:(NSString *)framename px:(float)x py:(float)y{
    track();
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:framename];
    sprite.anchorPoint = ccp(0,1);
    sprite.position = ccp(x,y);
    [self addChild:sprite];
}

//创建功能按钮代理函数
-(void)creatBtnByFramename:(NSString *)framename px:(float)x py:(float)y sel:(SEL)callback{
    track();
    EESpriteScaleBtn *sprite = [EESpriteScaleBtn spriteWithSpriteFrameName:framename];
    //    sprite.anchorPoint = ccp(0,1);
    sprite.position = ccp(x,y);
    [sprite addEETarget:self selector:callback];
    [self addChild:sprite];
}

- (id)init
{
    self = [super init];
    if (self) {
        //背景
        //背景
        CCSprite *sprite = [CCSprite spriteWithFile:@"funcbg.png"];
        sprite.anchorPoint = ccp(0,1);
        sprite.position = ccp(3,475);
        [self addChild:sprite];
        
        //文字  关于我们
        [self creatSpriteByFramename:@"关于我们.png" px:26 py:457];
        
        //制作人员
        [self creatSpriteByFramename:@"我们.png" px:67 py:420];
        
        
        //发送邮件
        [self creatBtnByFramename:@"发送邮件.png" px:160 py:117 sel:@selector(clickEmail)];
        
        //返回
        [self creatBtnByFramename:@"return_setting.png" px:160 py:31 sel:@selector(clickreturn:)];
        
    }
    return self;
}

#pragma mark ---点击了返回---
-(void)clickreturn:(id)sender{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    [self removeFromParentAndCleanup:YES];
}

-(void)clickEmail{
    
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    
    mailcontroller = [[MFMailComposeViewController alloc] init];
    
    if (mailcontroller==nil) {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"" message:@"请配置您的邮箱，否则无法继续！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertview show];
        [alertview release];
        return;
    }
    
    mailcontroller.mailComposeDelegate = self;
    //邮件接收者
    //NSArray *toRecipients = [NSArray arrayWithObjects:@"symhero@163.com", nil];
    //[mailcontroller setToRecipients:toRecipients];
    
    //邮件标题
    
    
    NSString *subject = [NSString stringWithFormat:@"兔子来了，问题反馈"];
    
    //subject = [subject substringToIndex:[subject length]-6];
    [mailcontroller setSubject:subject];
    
    //[mailcontroller setMessageBody:subject isHTML:NO];
    
    //[mailcontroller addAttachmentData:imgdata mimeType:@"image/png" fileName:@"picture.png"];
    
    //    [self presentModalViewController:mailcontroller animated:YES];
    
    [[Globel shareGlobel].rootController presentModalViewController:mailcontroller animated:YES];
    //[imgdata release];
    //[mailcontroller release];
}


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [mailcontroller dismissModalViewControllerAnimated:YES];
}


@end
