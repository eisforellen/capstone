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
    _playersArray = connectedPeers;
    // TODO randomize prompts array
    _promptsArray = @[@"This taco is ______", @"You may already be a ______", @"The worst thing I ever ate was _______", @"______, that's what he said!"];
    _turnCount = 0;
}

@end
