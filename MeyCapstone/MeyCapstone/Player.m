//
//  Player.m
//  MeyCapstone
//
//  Created by Ellen Mey on 7/25/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

#import "Player.h"
#import "MCHandler.h"


@implementation Player

- (void)setupPlayerWith:(NSString *)name {
    _name = name;
    _voted = NO;
    _score = 0;
    _votesReceived = 0;
}

- (BOOL)playerVoted:(BOOL)voted{
    if (voted) {
        return YES;
    } else {
        return NO;
    }
}

//- (BOOL)checkIfPlayerVoted:(Player *)player{
//    if (player.voted) {
//        return YES;
//    } else {
//        return NO;
//    }
//}


@end
