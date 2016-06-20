

#import "GameTasks2.h"
#import "EESpriteScaleBtn.h"
#import "WorldMapScene.h"
#import "SoundManagerR.h"
#import "GameKitHelper.h"
#import "Business.h"
#import "Task.h"
#import "Link.h"


@implementation GameTasks2


//创建影片剪辑
-(void)creatSpriteByFramename:(NSString *)framename px:(float)x py:(float)y{
    track();
    CCSprite *sprite = [CCSprite spriteWithFile:framename];
    sprite.anchorPoint = ccp(0,1);
    sprite.position = ccp(x,y);
    [self addChild:sprite];
}

//创建功能按钮代理函数
-(void)creatBtnByFramename:(NSString *)framename px:(float)x py:(float)y sel:(SEL)callback tag:(int)t{
    track();
    EESpriteScaleBtn *sprite = [EESpriteScaleBtn spriteWithFile:framename];
    sprite.tag = t;
//    sprite.anchorPoint = ccp(0,1);
    sprite.position = ccp(x,y);
    [sprite addEETarget:self selector:callback];
    [self addChild:sprite];
}



- (void)initTasks
{
    float delta = 80;
    for (int i = 1; i <= 3; i++) {
        Task *task = [Task getInitTask:i];
        
        // 图标
        Link *link = [Link createByType:task->targetLinkType andLelve:task->targetLinkLevel];
        link.position = ccp(60, 270 - (i - 1) * delta);
        [self addChild:link];
        
        // 文字
        CCLabelTTF *quote = [CCLabelTTF labelWithString:task->content fontName:@"Helvetica" fontSize:18];
        quote.color = ccBLACK;
        quote.anchorPoint = ccp(0.5,0.5);
        quote.position = ccp(160, 280 - (i - 1) * delta);
        [self addChild:quote];
        
        // 钱
        CCSprite *moneyIco = [CCSprite spriteWithSpriteFrameName:@"ico_money.png"];
        moneyIco.position = ccp(135, 250 - (i - 1) * delta);
        [self addChild:moneyIco];
        
        CCLabelAtlas *coinLabel = [CCLabelAtlas labelWithString:@"0" charMapFile:@"number-ui.png" itemWidth:9 itemHeight:15 startCharMap:'0'];
        coinLabel.anchorPoint = ccp(1,0.5);
        coinLabel.scale = 0.8f;
        coinLabel.position = ccp(190, 250 - (i - 1) * delta);
        [coinLabel setString:[NSString stringWithFormat:@"%d", task->bonusCoin]];
        [self addChild:coinLabel];
        
        CCLabelTTF *plus = [CCLabelTTF labelWithString:@"+" fontName:@"Helvetica" fontSize:16];
        plus.color = ccWHITE;
        plus.anchorPoint = ccp(0,0.5);
        plus.position = ccp(155, 250 - (i - 1) * delta);
        [self addChild:plus];
        
        bool isNewTask = task->isNewTask;
        if (isNewTask) {
            CCSprite *moneyIco = [CCSprite spriteWithFile:@"new.png"];
            moneyIco.position = ccp(262, 257 - (i - 1) * delta);
            [self addChild:moneyIco];
        }
        int round = [Task getRoundFromArchive:i];
        [Task setOldTaskToArchive:i Id:task->taskID round:round];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        
        CCLayerColor *color = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 100) width:640 height:960];
        [self addChild:color];
        
        //背景
        CCSprite *sprite = [CCSprite spriteWithFile:@"tasks_dg_bg2.png"];
        sprite.position = ccp(160,200);
        [self addChild:sprite];
        
        EESpriteScaleBtn *btn_close = [EESpriteScaleBtn spriteWithSpriteFrameName:@"dg_close.png"];
        btn_close.position = ccp(278,349);
        [btn_close addEETarget:self selector:@selector(clickreturn:)];
        [self addChild:btn_close];
        //任务列表
        [self initTasks];
        
    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
//    self.position = ccp(0,-500);
//    CCMoveTo *a1 = [CCMoveTo actionWithDuration:0.2f position:ccp(0,0)];
//    [self runAction:a1];
}

-(void)clickreturn:(id)sender{
    [[SoundManagerR shareInstance] playSound:@"按钮点击.wav" type:Sound_Type_Action];
    [self removeFromParentAndCleanup:true];
//    CCMoveTo *a1 = [CCMoveTo actionWithDuration:0.2f position:ccp(0,-500)];
//    CCCallFuncND *a2 = [CCCallFuncND actionWithTarget:self selector:@selector(removeFromParentAndCleanup:) data:(void *)true];
//    CCSequence *b1 = [CCSequence actions:a1, a2, nil];
//    [self runAction:b1];
}







@end
