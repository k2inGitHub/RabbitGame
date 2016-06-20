//
//  GameAppDelegate.m
//  SuperCoaster
//
//  Created by terababy on 10-10-29.
//  Copyright terababy 2010. All rights reserved.
//

#import "MyGameKitHelperDelegate.h"



@implementation MyGameKitHelperDelegate


#pragma mark GameKitHelper delegate methods

-(void) onScoresSubmitted:(bool)success
{
	CCLOG(@"onScoresSubmitted: %@", success ? @"YES" : @"NO");
    
//    if (success) {
//        [GameHelper retrieveGCScores];
//    }
}

-(void) onScoresReceived:(GKLeaderboard*) leaderBoard scores:(NSArray*)scores error: (NSError*) error
{
	if(error == NULL)
	{
//		int64_t personalBestRank= leaderBoard.localPlayerScore.rank;
//        [GameHelper setPlayerRank:personalBestRank category:leaderBoard.category];
//        
//        CCLOG(@"onScoresReceived: %@", [scores description]);
//        for (GKScore *score in scores) {
//            CCLOG(@"%d", score.rank);
//            CCLOG(@"%@", score.playerID);
//            CCLOG(@"%d", (int)score.value);
//            CCLOG(@"%@", score.category);
//            
//            if (score.rank == 1) {
//                [GameHelper setGCTopScore:score.value category:score.category];
//            }
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"RECEIVEDGC" object:nil];
        
    }
}


@end
