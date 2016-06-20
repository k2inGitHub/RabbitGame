//
//  TipAlert.m
//  CityMaster
//
//  Created by 宋扬 on 16/6/7.
//  Copyright © 2016年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "TipAlert.h"
#import "EESpriteScaleBtn.h"
#import "VisibleRect.h"

@interface TipAlert ()

@property (nonatomic, assign) CCLabelTTF *label;

@end

@implementation TipAlert

+ (TipAlert *)createWithTitle:(NSString *)title{

    TipAlert *tip = [[TipAlert alloc] init];
    tip.label.string = title;
    
    return [tip autorelease];
}

- (id)init{
    self = [super init];
    
    CCLayerColor *color = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 100) width:640 height:960];
    [self addChild:color];
    
    CCSprite *sp = [CCSprite spriteWithFile:@"course_canvas.png"];
    sp.position = self.label.position = [VisibleRect center];
    [self addChild:sp];
    
    
    self.label = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:24];
    self.label.position = [VisibleRect center];//ccp(145, 45);
    [self addChild:self.label];
    
    EESpriteScaleBtn *btn = [EESpriteScaleBtn spriteWithFile:@"知道了.png"];
    [self addChild:btn];
    btn.position = ccpAdd([VisibleRect center],ccp(0, -60));
    [btn addEETarget:self selector:@selector(onSureBtnClick)];
    
    return self;
}

- (void)onSureBtnClick{
    
    [self removeFromParentAndCleanup:YES];
}

@end
