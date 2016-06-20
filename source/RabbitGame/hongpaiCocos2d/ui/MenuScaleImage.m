//
//  MenuScaleImage.m
//  DaRenXiuTianCai
//
//  Created by pai hong on 12-5-8.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "MenuScaleImage.h"


@implementation MenuScaleImage

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

-(void)setHight:(BOOL)b{
    if (b) {
        normalImage_.visible = NO;
        selectedImage_.visible = YES;
    }else {
        normalImage_.visible = YES;
        selectedImage_.visible = NO;
    }
}

-(void)onExit{
    [super onExit];
}

/*

-(void) unselected
{
	// subclass to change the default action
	if(isEnabled_) {
		[super unselected];
	}
}

*/



@end
