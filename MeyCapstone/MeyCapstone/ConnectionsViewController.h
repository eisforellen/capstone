//
//  ConnectionsViewController.h
//  MeyCapstone
//
//  Created by Ellen Mey on 7/21/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

#import "ViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "Game.h"

@interface ConnectionsViewController : ViewController <MCBrowserViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) Game *game;

@end
