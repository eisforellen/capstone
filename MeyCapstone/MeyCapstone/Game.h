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
@property (nonatomic) BOOL moveOnToNextRound;

- (void)setupGame:(NSArray *)connectedPeers;
- (void)awardPoint:(Player *)player;
- (void)addVotesReceived:(Player *)player;
- (NSArray *)sortPlayers:(NSString *)key;
- (void)clearAllVotes;
- (BOOL)readyToAwardPoints;
- (void)declareWinner;
- (void)addVotesToPlayer:(NSString *)nameOfWinner;
- (void)oneVotePerPlayer:(NSString *)voter;
- (BOOL)checkIfPlayerVoted:(NSString *)voter;
- (NSString *)nameOfGameWinner;


@end
