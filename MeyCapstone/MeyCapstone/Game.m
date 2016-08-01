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
    _promptsArray = @[@"The Oscar for best impression of Marlon Brando underwater goes to...", @"Voted most likely to visit the moon in high school", @"If I could live anywhere, I'd choose", @"Did you know My Sharona was really about"];
    _turnCount = 0;
    _totalVoteCount = 0;
}

- (void)awardPoint:(Player *)player{
    player.score ++;
}

- (void)addVotesReceived:(Player *)player{
    player.votesReceived ++;
}

@end
