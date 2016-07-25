//
//  Game.h
//  MeyCapstone
//
//  Created by Ellen Mey on 7/25/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject

@property (nonatomic, strong) NSArray *playersArray;
@property (nonatomic, strong) NSArray *promptsArray;
@property (nonatomic) int turnCount;

- (void)setupGame:(NSArray *)connectedPeers;


@end
