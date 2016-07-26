//
//  GameCollectionViewController.h
//  MeyCapstone
//
//  Created by Ellen Mey on 7/22/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface GameCollectionViewController : UICollectionViewController

@property (nonatomic, strong) Game *game;
@property (nonatomic, strong) NSMutableArray *arrayOfSubmittedAnswers;

@end
