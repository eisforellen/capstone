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
    NSLog(@"Player's add score ++++++++++++++++++++++++++++++\n");
    player.score ++;
    
}

- (void)addVotesReceived:(Player *)player{
    player.votesReceived ++;
}


- (NSArray *)sortPlayersBy:(NSString *)key{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *playersSorted = [_playersArray sortedArrayUsingDescriptors:sortDescriptors];
    return playersSorted;
}

- (void)clearAllVotes{
    for (Player *player in _playersArray){
        player.votesReceived = 0;
        player.voted = NO;
    }
    _moveOnToNextRound = NO;
    _totalVoteCount = 0;
    
}

- (BOOL)readyToAwardPoints{
    if (_totalVoteCount >= _playersArray.count) {
        NSLog(@"ready to award points");
        return true;
    } else {
        NSLog(@"Womp womp ----------------------");
        return false;
    }
}


- (void)addVotesToPlayer:(NSString *)nameOfWinner{
    // check to see who won, compare sender of pick to current players if equal add 1 to score
// if game is not ready to award points
    [self declareWinner];
    if (![self readyToAwardPoints]) {
            for (int i = 0; i < _playersArray.count; i++) {
                if ([nameOfWinner isEqualToString:[[_playersArray objectAtIndex:i] name]]){
                    [self addVotesReceived:[_playersArray objectAtIndex:i]];
                    _totalVoteCount ++;
                    NSLog(@"A vote was added, vote count is now: %i", _totalVoteCount);
                }
            }
        }
    
}

- (BOOL)checkIfPlayerVoted:(NSString *)voter{
    BOOL voted = NO;
    for (int i = 0; i < _playersArray.count; i++) {
        if ([voter isEqualToString:[[_playersArray objectAtIndex:i] name]]) {
            if ([[_playersArray objectAtIndex:i] voted]) {
                voted = YES;
            } else {
                voted = NO;
            }
        }
    }
    return voted;
}

- (void)oneVotePerPlayer:(NSString *)voter{
    for (int i = 0; i < _playersArray.count; i++) {
        if ([voter isEqualToString:[[_playersArray objectAtIndex:i] name]]) {
            [[_playersArray objectAtIndex:i] playerVoted:YES];
        }
    }
}


// looks at the sorted array, if the first person has the highest score then award them a point, else it's a tie
- (void)awardPointToWinner:(NSArray *)sortedArray{
        if (_playersArray.count > 1) {
            if ([sortedArray[0] votesReceived] > [sortedArray[1] votesReceived]){
                // add alert that says this
                NSLog(@"Player %@ is the winner!", [sortedArray[0] name]);
                [self awardPoint:[sortedArray objectAtIndex:0]];
                // add alert for who won the round
            } else {
                NSLog(@"It's a tie!");
                // Add alert for tie
            }
        } else {
            NSLog(@"there is only one player");
        }
    }

// if we have all the votes in, tally them, sort them and award a point to the winner
- (void)declareWinner{
    if (!_moveOnToNextRound){
        if ([self readyToAwardPoints]) {
            NSLog(@"THE GAME IS OVER WE HAVE A WEINER!");
            [self awardPointToWinner:[self sortPlayersBy:@"votesReceived"]];
            _moveOnToNextRound = YES;
        } else {
            NSLog(@"No winner yet");
        }
    } else {
        NSLog(@"declareWinner called but round is over\n");
    }
}

- (void)displayAlertWithTitle:(NSString *)title message:(NSString *)message{

}

- (NSString *)nameOfGameWinner{
    NSArray *sortedPlayersByScore = [self sortPlayersBy:@"score"];
    NSString *winner = [sortedPlayersByScore[0] name];
    if ([sortedPlayersByScore[0] score] > [sortedPlayersByScore[1] score]) {
        return winner;
    } else {
        NSString *winners;
        for (Player *player in sortedPlayersByScore) {
            if (player.score == [sortedPlayersByScore[0] score]) {
                winners = [winner stringByAppendingString:[NSString stringWithFormat:@" & %@", player.name]];
            }
        }
        return winners;
    }
    
}

@end
