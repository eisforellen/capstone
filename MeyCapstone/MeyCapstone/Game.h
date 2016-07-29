//
//  Game.h
//  MeyCapstone
//
//  Created by Ellen Mey on 7/25/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface Game : NSObject

@property (nonatomic, strong) NSMutableArray *playersArray;
@property (nonatomic, strong) NSArray *promptsArray;
@property (nonatomic) int turnCount;
@property (nonatomic) int totalVoteCount;

- (void)setupGame:(NSArray *)connectedPeers;
- (void)awardPointToWinner:(Player *)player;
- (void)addVotesReceived:(Player *)player;


@end
