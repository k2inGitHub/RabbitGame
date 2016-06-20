//
//  Grid.m
//  RabbitGame
//
//  Created by pai hong on 12-6-24.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "Grid.h"
#import "GameScene.h"
#import "Link.h"

@implementation Grid

@synthesize link;
@synthesize x,y,isFinded;


- (id)init
{
    self = [super init];
    if (self) {
        int level = [Globel shareGlobel].curLevel;
        
        if (level == 1 || level == 2 || level == 3 || level == 4) {
            batchNode = [CCSpriteBatchNode batchNodeWithFile:@"lawngreen_caodi.png"];
        }else if(level == 5 || level == 6){
            batchNode = [CCSpriteBatchNode batchNodeWithFile:@"lawngreen_xuedi.png"];
        }else if(level ==7 || level ==8){
            batchNode = [CCSpriteBatchNode batchNodeWithFile:@"lawngreen_tudi.png"];
        }
        [self addChild:batchNode];
    }
    return self;
}

/** 计算精灵的尺寸位置 */  
-(CGRect) rect   
{   
    return CGRectMake( position_.x - contentSize_.width*anchorPoint_.x,   
                      position_.y - contentSize_.height*anchorPoint_.y,   
                      contentSize_.width, contentSize_.height);    
}   


/** 判断touch点的位置是否在精灵上 */  
- (BOOL)containsTouchLocation:(UITouch *)touch   
{   
    trace(@"%d %d",x,y);
    //CCLOG(@"精灵触摸事件...........");   
    CGPoint touchLocation = [touch locationInView: [touch view]];   
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];   
    CGPoint local = [self convertToNodeSpace:touchLocation];   
    CGRect r = [self rect];   
    r.origin = CGPointZero;   
    BOOL isinself = CGRectContainsPoint( r, local );   
    return isinself;   
}  
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event   
{     
    BOOL isintoucharea = [self containsTouchLocation:touch];   
    return isintoucharea;//    
}   


-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if ([self containsTouchLocation:touch]) {
        //通知GameScene  
        [[GameScene shareInstance] touchOneGrid:self];
    }
}

//吧link赋值给grid的引用
-(void)setLinkRelation:(Link *)linkrelation{
    link = linkrelation;
    link.x = self.x;
    link.y = self.y;
}

#pragma mark ----设置wall---

-(void)insertWall{
    Link *linkwall = [Link node];
    linkwall.type = Link_Type_Wall;
    linkwall.level = 100;
    [self addChild:linkwall];
    linkwall.pgrid = self;
    self.link = linkwall;
}


#pragma mark ----刷新草坪---

-(void)addToBatchNode:(NSString *)spriteName{
    CCSprite *lawn = [CCSprite spriteWithSpriteFrameName:spriteName];
    //lawn.scale = 52/50.0f; //（是为了不让图片之间有1个像素的间隙），所以这里偏差一个像素,放大到52像素
    [lawn.texture setAliasTexParameters];
    lawn.position = ccp(25,25);
    lawn.scale = 1.02f;
    [batchNode addChild:lawn];
}

-(BOOL)isGridNil:(Grid *)grid{
    if(grid.link==nil || grid.link.type == Link_Type_Rabbit){
        return YES;
    }
    return NO;
}

-(void)refreshLawnByTop:(Grid *)top :(Grid *)right :(Grid *)down :(Grid *)left :(Grid *)lefttop :(Grid *)righttop :(Grid *)rightdown :(Grid *)leftdown{

    
    NSString *tagtop;
    NSString *tagright;
    NSString *tagdown;
    NSString *tagleft;
    
    //trace(@"%d %d",x,y);
    
    if ((top!=nil && top.link==nil) || (top!=nil && top.link.type==Link_Type_Rabbit)) {
        tagtop = @"0";
    }else {
        tagtop = @"1";
    }
    
    if ((right!=nil && right.link==nil) || (right!=nil && right.link.type==Link_Type_Rabbit)) {
        tagright = @"0";
    }else {
        tagright = @"1";
    }
    
    if ((down!=nil && down.link==nil) || (down!=nil && down.link.type==Link_Type_Rabbit)) {
        tagdown = @"0";
    }else {
        tagdown = @"1";
    }
    
    if ((left!=nil && left.link==nil) || (left!=nil && left.link.type==Link_Type_Rabbit)) {
        tagleft = @"0";
    }else {
        tagleft = @"1";
    }
    
    
    
    /*
    if (left == nil){
        tagleft = @"1";
    }else {
        if (left.link != nil) {
            tagleft = @"1";
        }else {
            tagleft = @"0";
        }
    }*/
    NSString *result = [NSString stringWithFormat:@"%@%@%@%@",tagtop,tagright,tagdown,tagleft];
    //trace(@"result :%@",result);

    //if(lawnTag!=nil && [result isEqualToString:lawnTag] && ((link!=nil) == isLinkExsit)){//说明四周情况没有变动，则返回
    //    return;
    //}
    //改变link是否存在的状态
    isLinkExsit = link!=nil?YES:NO;
    
    if (lawnTag!=nil) {
        [lawnTag release];
    }
    
    lawnTag = [[NSString stringWithString:result] retain];
    
    //trace(@"%@",lawnTag);
    //删除之前的所有的子节点
    [batchNode removeAllChildrenWithCleanup:YES];
    
    //有变动的话，则刷新草坪
    
    if (self.link!=nil && self.link.type != Link_Type_Rabbit) {
        //if (self.link.type != Link_Type_Rabbit) {
            [self addToBatchNode:@"lawn_0000.png"];
       // }else {
       //     trace(@"fad");
            
       // }
    }else if(self.link==nil || self.link.type ==Link_Type_Rabbit){
        if (self.link.type == Link_Type_Rabbit) {
                 trace(@"fad");
         }
        
        
        
        if ([lawnTag  isEqualToString:@"0000"]) {
            
        }else if([lawnTag  isEqualToString:@"1111"]){
            [self addToBatchNode:@"lawn_1111.png"];
        }else if([lawnTag  isEqualToString:@"1110"]){
            [self addToBatchNode:@"lawn_1110.png"];
        }else if([lawnTag  isEqualToString:@"1101"]){
            [self addToBatchNode:@"lawn_1101.png"];
        }else if([lawnTag  isEqualToString:@"1100"]){
            [self addToBatchNode:@"lawn_1100.png"];
        }else if([lawnTag  isEqualToString:@"1011"]){
            [self addToBatchNode:@"lawn_1011.png"];
        }else if([lawnTag  isEqualToString:@"1010"]){
            [self addToBatchNode:@"lawn_1010.png"];
        }else if([lawnTag  isEqualToString:@"1001"]){
            [self addToBatchNode:@"lawn_1001.png"];
        }else if([lawnTag  isEqualToString:@"0111"]){
            [self addToBatchNode:@"lawn_0111.png"];
        }else if([lawnTag  isEqualToString:@"0110"]){
            [self addToBatchNode:@"lawn_0110.png"];
        }else if([lawnTag  isEqualToString:@"0101"]){
            [self addToBatchNode:@"lawn_0101.png"];
        }else if([lawnTag  isEqualToString:@"0011"]){
            [self addToBatchNode:@"lawn_0011.png"];
        }else if([lawnTag  isEqualToString:@"1000"]){
            CCSprite *lawn = [CCSprite spriteWithSpriteFrameName:@"lawn_top.png"];
            lawn.anchorPoint = ccp(0,1);
            lawn.position = ccp(0,51);
            lawn.scale = 1.02f;
            [lawn.texture setAliasTexParameters];
            [batchNode addChild:lawn];
        }else if([lawnTag  isEqualToString:@"0100"]){
            CCSprite *lawn = [CCSprite spriteWithSpriteFrameName:@"lawn_right.png"];
            lawn.anchorPoint = ccp(1,1);
            lawn.position = ccp(51,50);
            lawn.scale = 1.02f;
            [lawn.texture setAliasTexParameters];
            [batchNode addChild:lawn];
        }else if([lawnTag  isEqualToString:@"0010"]){
            CCSprite *lawn = [CCSprite spriteWithSpriteFrameName:@"lawn_down.png"];
            lawn.anchorPoint = ccp(0,0);
            lawn.position = ccp(0,-1);
            lawn.scale = 1.02f;
            [lawn.texture setAliasTexParameters];
            [batchNode addChild:lawn];
        }else if([lawnTag  isEqualToString:@"0001"]){
            CCSprite *lawn = [CCSprite spriteWithSpriteFrameName:@"lawn_left.png"];
            lawn.anchorPoint = ccp(0,1);
            lawn.position = ccp(-1,50);
            lawn.scale = 1.02f;
            [lawn.texture setAliasTexParameters];
            [batchNode addChild:lawn];
        }
        
        //trace(@"%@ %@ %@ %@ %@ %@ %@ %@ ",top.link,right.link,down.link,left.link,lefttop.link,righttop.link,rightdown.link,leftdown.link);
        
        //判断角落[self isGridNil:]
        if ([self isGridNil:left] && [self isGridNil:top]  && ![self isGridNil:lefttop] ) {
            //左上角
            //lawn_down_right
            CCSprite *lawn_left_top = [CCSprite spriteWithSpriteFrameName:@"lawn_down_right.png"];
            lawn_left_top.anchorPoint = ccp(0,1);
            //lawn_left_top.rotation = 180;
            lawn_left_top.position = ccp(-1,51);
            lawn_left_top.scale = 1.02f;
            [lawn_left_top.texture setAliasTexParameters];
            [batchNode addChild:lawn_left_top];
        }
        if([self isGridNil:right] && [self isGridNil:top] &&  ![self isGridNil:righttop]){
            //右上角!!!!!!!!!!!!!!!!BBBBB
            CCSprite *lawn_right_down = [CCSprite spriteWithSpriteFrameName:@"lawn_down_right.png"];
            lawn_right_down.anchorPoint = ccp(0,1);
            lawn_right_down.rotation = 90;
            lawn_right_down.position = ccp(51,51);
            lawn_right_down.scale = 1.02f;
            [lawn_right_down.texture setAliasTexParameters];
            [batchNode addChild:lawn_right_down];
        }
        if([self isGridNil:right] && [self isGridNil:down] && ![self isGridNil:rightdown]){
            //右下角
            CCSprite *lawn_right_down = [CCSprite spriteWithSpriteFrameName:@"lawn_down_right.png"];
            lawn_right_down.anchorPoint = ccp(0,1);
            lawn_right_down.rotation = 180;
            lawn_right_down.position = ccp(51,-1);
            lawn_right_down.scale = 1.02f;
            //lawn_right_down.position = ccp(25,25);
            [lawn_right_down.texture setAliasTexParameters];
            [batchNode addChild:lawn_right_down];
        }
        if([self isGridNil:left] && [self isGridNil:down] && ![self isGridNil:leftdown] ){
            //左下角!!!!!!!!!!!!!!!!!!BBBBB
            CCSprite *lawn_right_down = [CCSprite spriteWithSpriteFrameName:@"lawn_down_right.png"];
            lawn_right_down.anchorPoint = ccp(0,1);
            lawn_right_down.rotation = -90;
            lawn_right_down.position = ccp(-1,-1);
            lawn_right_down.scale = 1.02f;
            [lawn_right_down.texture setAliasTexParameters];
            [batchNode addChild:lawn_right_down];
        }
    }
    
    
}

#pragma mark ----生命周期----
-(void)onEnter{
    [[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];   
    //[[CCTouchDispatcher sharedDispatcher] addStandardDelegate:self priority:0];
    
    /*timesttf = [CCLabelTTF labelWithString:@"0" fontName:@"ArialMT" fontSize:12];
    timesttf.position = ccp(10,5);
    timesttf.color = ccRED;
    [self addChild:timesttf z:2];*/
    [super onEnter];
}

-(void)onExit{
    if (lawnTag!=nil) {
        [lawnTag release];
    }
    
    //[[CCTouchDispatcher sharedDispatcher]removeDelegate:self]; 
    [super onExit];
}

#pragma mark ---判断---
-(void)findOneTime{
    /*
    int a = [timesttf.string intValue];
    a++;
    [timesttf setString:[NSString stringWithFormat:@"%d",a]];*/
}

#pragma mark ---清除link---
-(void)clearLink{
    if (link!=nil) {
        link.pgrid = nil;
        [link removeFromParentAndCleanup:YES];
    }
    link = nil;
}
@end
