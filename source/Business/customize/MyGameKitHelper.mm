//
//  GameAppDelegate.m
//  SuperCoaster
//
//  Created by terababy on 10-10-29.
//  Copyright terababy 2010. All rights reserved.
//

#import "MyGameKitHelper.h"
#import "CCLocalDataLoader.h"



@implementation MyGameKitHelper

-(void)addScoreLimitPairs {
    [self addScoreLimitPair:100 forKey:@"com.adultdream.smartapple.likeaboss"];
}


// 获得成就后显示界面
-(void) showAchievement:(GKAchievement*)achievement
{
    // 是否已获得
    NSString *achiText = achievement.identifier;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *tmp = [defaults objectForKey:achiText];
    BOOL submited = FALSE;
    if (tmp) {
        submited = [tmp boolValue];
    }
    
    if (submited) {
        return;
    }
    
    [defaults setObject:[NSNumber numberWithBool:TRUE] forKey:achiText]; 
    
    
    // 取文字图片
    NSString *achiTitleFile = @"";
    
    if ([achiText isEqualToString:@"com.adultdream.smartapple.likeaboss"]) {
        achiTitleFile = @"achievement-tx1.png";
    }
    else if ([achiText isEqualToString:@"com.adultdream.smartapple.orangekiller"]) {
        achiTitleFile = @"achievement-tx2.png";
    }
    else if ([achiText isEqualToString:@"com.adultdream.smartapple.orangehunter"]) {
        achiTitleFile = @"achievement-tx3.png";
    }
    else if ([achiText isEqualToString:@"com.adultdream.smartapple.coolkiller"]) {
        achiTitleFile = @"achievement-tx4.png";
    }
    else if ([achiText isEqualToString:@"com.adultdream.smartapple.orangenightmare"]) {
        achiTitleFile = @"achievement-tx5.png";
    }
    else if ([achiText isEqualToString:@"com.adultdream.smartapple.breakyourdreams"]) {
        achiTitleFile = @"achievement-tx6.png";
    }
    else if ([achiText isEqualToString:@"com.adultdream.smartapple.brotherhood"]) {
        achiTitleFile = @"achievement-tx7.png";
    }
    else if ([achiText isEqualToString:@"com.adultdream.smartapple.missionimpossible"]) {
        achiTitleFile = @"achievement-tx8.png";
    }
    else if ([achiText isEqualToString:@"com.adultdream.smartapple.killthecat"]) {
        achiTitleFile = @"achievement-tx9.png";
    }
    else if ([achiText isEqualToString:@"com.adultdream.smartapple.timegold"]) {
        achiTitleFile = @"achievement-tx10.png";
    }
    else if ([achiText isEqualToString:@"com.adultdream.smartapple.keepcoming"]) {
        achiTitleFile = @"achievement-tx11.png";
    }
    else if ([achiText isEqualToString:@"com.adultdream.smartapple.bigspender"]) {
        achiTitleFile = @"achievement-tx12.png";
    }
    else if ([achiText isEqualToString:@"com.adultdream.smartapple.holeinone"]) {
        achiTitleFile = @"achievement-tx13.png";
    }
    else if ([achiText isEqualToString:@"com.adultdream.smartapple.potatolover"]) {
        achiTitleFile = @"achievement-tx14.png";
    }    
    else if ([achiText isEqualToString:@"com.adultdream.smartapple.goldenfragger"]) {
        achiTitleFile = @"achievement-tx15.png";
    }
    else if ([achiText isEqualToString:@"com.adultdream.smartapple.appleninja"]) {
        achiTitleFile = @"achievement-tx16.png";
    }
    else if ([achiText isEqualToString:@"com.adultdream.smartapple.superscore"]) {
        achiTitleFile = @"achievement-tx17.png";
    }
    else if ([achiText isEqualToString:@"com.adultdream.smartapple.thinkdifferent"]) {
        achiTitleFile = @"achievement-tx18.png";
    }
    else if ([achiText isEqualToString:@"com.adultdream.smartapple.stepbystep"]) {
        achiTitleFile = @"achievement-tx19.png";
    }
    else if ([achiText isEqualToString:@"com.adultdream.smartapple.loveiphone"]) {
        achiTitleFile = @"achievement-tx20.png";
    }
    else if ([achiText isEqualToString:@"com.adultdream.smartapple.juicefeast"]) {
        achiTitleFile = @"achievement-tx21.png";
    }
    
    UIImage *backImage = [UIImage imageNamed:@"achievement-lan.png"];
    UIView *achiView = [[UIImageView alloc] initWithImage:backImage];
    achiView.frame = CGRectMake((480 - backImage.size.width)/2.0f, -46, backImage.size.width, backImage.size.height);
    
    UIImage *titleImage = [UIImage imageNamed:achiTitleFile];
    UIImageView *title = [[UIImageView alloc] initWithImage:titleImage];
    title.frame = CGRectMake((backImage.size.width - titleImage.size.width)/2.0f, 
                             (backImage.size.height - titleImage.size.height)/2.0f, titleImage.size.width, titleImage.size.height);
    [achiView addSubview:title];
    [title release];
    
    [[[CCDirector sharedDirector] openGLView] addSubview:achiView];
    [achiView release];
    
    
	[UIView beginAnimations:@"downstop" context:achiView];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];  
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(achieveDownAnimationStopped:finished:context:)];
    achiView.frame = CGRectMake(achiView.frame.origin.x, 0, achiView.frame.size.width, achiView.frame.size.height);
	[UIView commitAnimations];
}

-(void)achieveDownAnimationStopped:(NSString *)animationID  finished:(BOOL)finished context:(void *)context
{
    [self performSelector:@selector(achieveUpAnimation:) withObject:(id)context afterDelay:3.0f];
}

-(void)achieveUpAnimation:(UIView*)achiView
{
    if (achiView) {
        [UIView beginAnimations:@"upstop" context:achiView];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];  
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(achieveUpAnimationStopped:finished:context:)];
        achiView.frame = CGRectMake(achiView.frame.origin.x, -46, achiView.frame.size.width, achiView.frame.size.height);
        [UIView commitAnimations];
    }
    
}

-(void)achieveUpAnimationStopped:(NSString *)animationID  finished:(BOOL)finished context:(void *)context
{
    UIView *achiView = (UIView*)context;
    if (achiView) {
        [achiView removeFromSuperview];
        achiView = nil;
    }
}

static MyGameKitHelper *instanceOfMyGameKitHelper;

#pragma mark Singleton stuff
+(id) alloc
{
	@synchronized(self)	
	{
		NSAssert(instanceOfMyGameKitHelper == nil, @"Attempted to allocate a second instance of the singleton: MyGameKitHelper");
		instanceOfMyGameKitHelper = [[super alloc] retain];
		return instanceOfMyGameKitHelper;
	}
	
	// to avoid compiler warning
	return nil;
}

+(GameKitHelper*) sharedHelper
{
	@synchronized(self)
	{
		if (instanceOfMyGameKitHelper == nil)
		{
			[[MyGameKitHelper alloc] init];
		}
		
		return instanceOfMyGameKitHelper;
	}
	
	// to avoid compiler warning
	return nil;
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	
    if (instanceOfMyGameKitHelper) {
        [instanceOfMyGameKitHelper release];
        instanceOfMyGameKitHelper = nil;
    }
    
	[super dealloc];
}

@end
