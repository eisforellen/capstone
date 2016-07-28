//
//  Game.m
//  MeyCapstone
//
//  Created by Ellen Mey on 7/25/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

#import "Game.h"

@implementation Game


- (void)setupGame:(NSArray *)connectedPeers{
    _playersArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < connectedPeers.count; i ++) {
        
        Player *player = [[Player alloc] init];

        [player setupPlayerWith:[connectedPeers objectAtIndex:i]];
        [_playersArray addObject:player];
        
        NSLog(@"Created Player with name: %@", player.name);
    }
    // for each peer create a player object and add to array
    
    
    // TODO randomize prompts array
    _promptsArray = @[@"This taco is ______", @"You may already be a ______", @"The worst thing I ever ate was _______", @"______, that's what he said!"];
    _turnCount = 0;
    _totalVoteCount = 0;
}

- (void)awardPointToWinner:(Player *)player{
    player.score ++;
}

- (void)addVotesReceived:(Player *)player{
    player.votesReceived ++;
}

@end
