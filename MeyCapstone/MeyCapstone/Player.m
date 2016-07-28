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
    _isDealer = NO;
    _score = 0;
}


@end
