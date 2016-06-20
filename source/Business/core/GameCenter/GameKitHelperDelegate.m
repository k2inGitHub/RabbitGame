//
//  GameAppDelegate.m
//  SuperCoaster
//
//  Created by terababy on 10-10-29.
//  Copyright terababy 2010. All rights reserved.
//

#import "GameKitHelperDelegate.h"



@implementation GameKitHelperDelegate

- (id)init
{
	if (self = [super init])
	{
	}
	return self;
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	[super dealloc];
}

#pragma mark GameKitHelper delegate methods

-(void) onScoresSubmitted:(bool)success
{
	CCLOG(@"onScoresSubmitted: %@", success ? @"YES" : @"NO");
}

-(void) onScoresReceived:(GKLeaderboard*) leaderBoard scores:(NSArray*)scores error: (NSError*) error
{
	CCLOG(@"onScoresReceived: %@", [scores description]);
	GameKitHelper* gkHelper = [GameKitHelper sharedHelper];
	[gkHelper showAchievements];
}

-(void) onLocalPlayerAuthenticationChanged
{
	GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
	CCLOG(@"LocalPlayer isAuthenticated changed to: %@", localPlayer.authenticated ? @"YES" : @"NO");
	
	if (localPlayer.authenticated)
	{
		GameKitHelper* gkHelper = [GameKitHelper sharedHelper];
		[gkHelper getLocalPlayerFriends];
		//[gkHelper resetAchievements];
	}	
}

-(void) onFriendListReceived:(NSArray*)friends
{
	CCLOG(@"onFriendListReceived: %@", [friends description]);
	GameKitHelper* gkHelper = [GameKitHelper sharedHelper];
	[gkHelper getPlayerInfo:friends];
}

-(void) onPlayerInfoReceived:(NSArray*)players
{
	CCLOG(@"onPlayerInfoReceived: %@", [players description]);
    
    
    //TODO
	//GameKitHelper* gkHelper = [GameKitHelper sharedHelper];
	//[gkHelper submitScore:1234 category:@"Playtime"];
	
	//[gkHelper showLeaderboard];
	
	//GKMatchRequest* request = [[[GKMatchRequest alloc] init] autorelease];
	//request.minPlayers = 2;
	//request.maxPlayers = 4;
	
	//GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
	//[gkHelper showMatchmakerWithRequest:request];
	//[gkHelper queryMatchmakingActivity];
}

-(void) onAchievementReported:(GKAchievement*)achievement
{
	CCLOG(@"onAchievementReported: %@", achievement);
}

-(void) onAchievementsLoaded:(NSDictionary*)achievements
{
	CCLOG(@"onLocalPlayerAchievementsLoaded: %@", [achievements description]);
}

-(void) onResetAchievements:(bool)success
{
	CCLOG(@"onResetAchievements: %@", success ? @"YES" : @"NO");
}

-(void) onLeaderboardViewDismissed
{
	CCLOG(@"onLeaderboardViewDismissed");
	
    //TODO
	//GameKitHelper* gkHelper = [GameKitHelper sharedHelper];
	//[gkHelper retrieveTopTenAllTimeGlobalScores];
}

-(void) onAchievementsViewDismissed
{
	CCLOG(@"onAchievementsViewDismissed");
}

-(void) onReceivedMatchmakingActivity:(NSInteger)activity
{
	CCLOG(@"receivedMatchmakingActivity: %i", activity);
}

-(void) onMatchFound:(GKMatch*)match
{
	CCLOG(@"onMatchFound: %@", match);
}

-(void) onPlayersAddedToMatch:(bool)success
{
	CCLOG(@"onPlayersAddedToMatch: %@", success ? @"YES" : @"NO");
}

-(void) onMatchmakingViewDismissed
{
	CCLOG(@"onMatchmakingViewDismissed");
}
-(void) onMatchmakingViewError
{
	CCLOG(@"onMatchmakingViewError");
}

-(void) onPlayerConnected:(NSString*)playerID
{
	CCLOG(@"onPlayerConnected: %@", playerID);
}

-(void) onPlayerDisconnected:(NSString*)playerID
{
	CCLOG(@"onPlayerDisconnected: %@", playerID);
}

-(void) onStartMatch
{
	CCLOG(@"onStartMatch");
}

-(void) onReceivedData:(NSData*)data fromPlayer:(NSString*)playerID
{
	CCLOG(@"onReceivedData: %@ fromPlayer: %@", data, playerID);
}




@end
