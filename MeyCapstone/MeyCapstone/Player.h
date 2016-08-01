//
//  Player.h
//  MeyCapstone
//
//  Created by Ellen Mey on 7/25/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) BOOL voted;
@property (nonatomic) int score;
@property (nonatomic) int votesReceived;

- (void)setupPlayerWith:(NSString *)name;



@end
