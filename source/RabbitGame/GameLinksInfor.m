//
//  GameLinksInfor.m
//  RabbitGame
//
//  Created by pai hong on 12-7-16.
//  Copyright 2012年 
//-------洪湃--------------
//---qq:  454077256-------
//---tel: 186 2159 2830---
//------------------------. . All rights reserved.
//

#import "GameLinksInfor.h"
#import "Link.h"


#define startx 0

@implementation GameLinksInfor

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


/*

//得到数组中所有的分数
-(int)getAllScoreFrameArray:(NSMutableArray *)array{
    track();
    int all = 0;
    for (int i=0; i< [array count]; i++) {
        NSMutableArray *oneitemarray = [array objectAtIndex:i];
        for (int a=0; a<[oneitemarray count]; a++) {
            Link *link = [oneitemarray objectAtIndex:a];
            all +=link.score;
        }
    }
    
    return all;
}

//得到数组中的最小的link
-(Link *)getLowestLink{
    track();
    if (tempFindLinks==nil || [tempFindLinks count]==0) {
        return  nil;
    }
    Link *link = [[tempFindLinks objectAtIndex:0] objectAtIndex:0];
    return [link copyOne];
}

//得到合并完成的物种
-(Link *)getAllTogetherLink{
    track();
    int len = [tempFindLinks count];
    NSArray *lastarray = [tempFindLinks objectAtIndex:(len-1)];
    //数组里面最高级的物种
    Link *topestLink = [lastarray objectAtIndex:0];
    
    
    //得到比这个更高一级的物种
    Link *result;
    if ([lastarray count]>=3) {//最后物种大于3的话，则分数加倍，并且图标不一样
        if (topestLink.type == Link_Type_House && topestLink.level == 8) {//House最高等级的，还是要返回普通的
            result = [self getSuperLink:topestLink];
        }else if (topestLink.type == Link_Type_Stone && topestLink.level == 2) {
            result = [self getSuperLink:topestLink];
        }
        else {
            result = [self getSuperLink:topestLink issuper:YES];
        }
    }else {
        result = [self getSuperLink:topestLink];
    }
    
    return result;
}
*/

//得到高一等级的Link
-(Link *)getSuperLinkSuperType:(Link *)link{
    Link *superlink;
    if (link.type ==Link_Type_Stone && link.level == 2) {//大石头可以合成大宝箱
        superlink = [Link createByType:Link_Type_Park andLelve:5];
    }else if(link.type == Link_Type_House && link.level == 8){
        superlink = [Link createByType:link.type andLelve:(link.level+1)];
    }else {
        superlink = [Link createByType:link.type andLelve:(link.level+1) issuper:YES];
    }
    return superlink;
}

//得到高一等级的Link
-(Link *)getSuperLink:(Link *)link{
    Link *superlink;
    if (link.type ==Link_Type_Stone && link.level == 2) {//大石头可以合成大宝箱
        superlink = [Link createByType:Link_Type_Park andLelve:5];
    }else {
        superlink = [Link createByType:link.type andLelve:(link.level+1)];
    }
    return superlink;
}

-(void)clear{
    [self removeAllChildrenWithCleanup:YES];
}

-(void)setTextColor:(CCLabelTTF *)label{
    int levelNum = [Globel shareGlobel].curLevel;
    if (levelNum==5 || levelNum==6 ) {
        label.color = ccBLACK;
    }else {
        label.color = ccWHITE;
    }
    //){
}

//显示单个物体的合成信息
-(void)showInfor:(Link *)link{
    [self clear];    
    
    if (link.type==Link_Type_Tool || link.type == Link_Type_Rabbit || link.type == Link_Type_Wall) {
        return;
    }
    //最高级的话，也return
    if ((link.type == Link_Type_House && link.level == 9) || (link.type == Link_Type_Park && link.level ==5 )) {
        return;
    }
    
    int curX = startx;
    
    int count = 3;
    
    //如果是水晶塔，则需要4个
    if (link.type == Link_Type_House && link.level == 8) {
        count = 4;
    }
    NSString *str = [NSString stringWithFormat:@"%d",count];
    CCLabelTTF *labelcount = [CCLabelTTF labelWithString:str fontName:UseSysFontzheng fontSize:16];
    [self setTextColor:labelcount];
    labelcount.anchorPoint = ccp(0.5,0.5);
    labelcount.position = ccp(curX,0);
    [self addChild:labelcount];
    
    curX +=20;
    
    Link *clink = [link copyOne];
    clink.scale = 0.5;
    clink.position = ccp(curX,0);
    [self addChild:clink];
    
    curX +=20;
    
    CCLabelTTF *labelequal = [CCLabelTTF labelWithString:@"=" fontName:UseSysFontzheng fontSize:16];
    [self setTextColor:labelequal];
    labelequal.anchorPoint = ccp(0.5,0.5);
    labelequal.position = ccp(curX,0);
    [self addChild:labelequal];
    
    curX +=20;

    
    Link *resultLink = [self getSuperLink:link];
    resultLink.scale = 0.5;
    resultLink.position = ccp(curX,0);
    [self addChild:resultLink];

}

//显示提示信息
-(void)showFindLinks:(NSMutableArray *)tempFindLinks{
    
    int len = [tempFindLinks count];
        
    if (len == 0) {
        return;
    }
    
    [self clear];
    
    
    
    int curX = startx;
    for (int i=0; i<len; i++) {
        NSArray *oneitems = [tempFindLinks objectAtIndex:i];
        int count = [oneitems count];
        
        if (i==0) {
            count = count+1;
        }
        
        NSString *str = [NSString stringWithFormat:@"%d",count];
        CCLabelTTF *labelcount = [CCLabelTTF labelWithString:str fontName:UseSysFontzheng fontSize:16];
        [self setTextColor:labelcount];
        labelcount.anchorPoint = ccp(0.5,0.5);
        labelcount.position = ccp(curX,0);
        [self addChild:labelcount];
        
        curX +=20;
        
        Link *link = [(Link *)[oneitems objectAtIndex:0] copyOne];
        link.scale = 0.5;
        link.position = ccp(curX,0);
        [self addChild:link];
        
        curX +=20;
        
        if (i!=(len-1)) {
            
            CCLabelTTF *labeljia = [CCLabelTTF labelWithString:@"+" fontName:UseSysFontzheng fontSize:16];
            [self setTextColor:labeljia];
            labeljia.anchorPoint = ccp(0.5,0.5);
            labeljia.position = ccp(curX,0);
            [self addChild:labeljia];
            
            curX +=10;
        }
        
    }
    
    CCLabelTTF *labelcount = [CCLabelTTF labelWithString:@"=" fontName:UseSysFontzheng fontSize:16];
    [self setTextColor:labelcount];
    labelcount.anchorPoint = ccp(0.5,0.5);
    labelcount.position = ccp(curX,0);
    [self addChild:labelcount];
    
    curX +=20;
    
    
    NSArray *lastarray = [tempFindLinks objectAtIndex:(len-1)];
    int lastlen = [lastarray count];
    trace(@"%d",lastlen);
    
    Link *link = [lastarray objectAtIndex:0];
    Link *resultLink;
    if (lastlen>3 ||(lastlen==3 && len==1)) {
        resultLink = [self getSuperLinkSuperType:link];
    }else {
        resultLink = [self getSuperLink:link];
    }
    
    resultLink.scale = 0.5;
    resultLink.position = ccp(curX,0);
    [self addChild:resultLink];
    
    //结果
}

@end
