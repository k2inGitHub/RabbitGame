//
//  MenuScaleSprite.m
//  DaRenXiuTianCai
//
//  Created by pai hong on 12-5-8.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "MenuScaleSprite.h"


@implementation MenuScaleSprite

-(void)selected{
    [super selected];
    
    CCAction *action = [self getActionByTag:123];
    if( action )
        [self stopAction:action];
    else
        originalScale_ = self.scale;
    
    CCAction *zoomAction = [CCScaleTo actionWithDuration:0.1f scale:originalScale_ * 1.15f];
    zoomAction.tag = 123;
    [self runAction:zoomAction];
}

-(void)unselected{
    [super unselected];
    
    [self stopActionByTag:123];
    CCAction *zoomAction = [CCScaleTo actionWithDuration:0.1f scale:originalScale_];
    zoomAction.tag = 123;
    [self runAction:zoomAction];
}

//设置是否选中
-(void)setHightLight:(BOOL)b{
    isHightLight = b;
    if (b) {
        [normalImage_ setVisible:NO];
        [selectedImage_ setVisible:YES];
        [disabledImage_ setVisible:NO];
    }else {
        [normalImage_ setVisible:YES];
        [selectedImage_ setVisible:NO];
        [disabledImage_ setVisible:NO];
    }
}
-(void)setDisabel:(BOOL)b{
    isDisable = b;
    if (b) {
        [normalImage_ setVisible:NO];
        [selectedImage_ setVisible:NO];
        [disabledImage_ setVisible:YES];
    }else {
        [normalImage_ setVisible:YES];
        [selectedImage_ setVisible:NO];
        [disabledImage_ setVisible:NO];
    }
}

//是否是选中状态
-(BOOL)getIsHightLight{
    return isHightLight;
}

-(void)onExit{
    //self.scale = 1.0f;
    //[self stopAllActions];
    [super onExit];
}


@end
