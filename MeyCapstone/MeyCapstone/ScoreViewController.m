//
//  ScoreViewController.m
//  MeyCapstone
//
//  Created by Ellen Mey on 7/27/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

#import "ScoreViewController.h"
#import "AppDelegate.h"


@interface ScoreViewController ()

@property (strong, nonatomic) AppDelegate *appDelegate;

@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveScoreUpdateNotificaton:) name:@"DidUpdateScoreNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(senderReceivedScoreUpdateNotification:) name:@"SenderReceivedScoreUpdate" object:nil];

    
}


- (void)senderReceivedScoreUpdateNotification:(NSNotification *)notification{
    NSLog(@"~~\nSenderReceivedScoreUpdate vote count is now %i", _game.totalVoteCount);
}

- (void)didRecieveScoreUpdateNotificaton:(NSNotification *)notification{
    // increment voteCount, if equal to playersCount then calculate winner and update score, if less
    NSDictionary *userInfo = [notification userInfo];
    [self addVotesToPlayer];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SenderReceivedScoreUpdate" object:nil userInfo:userInfo];
        NSLog(@"DidReceive and sent from didReceiveScoreUpdateNotification\n");
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_game.playersArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = [[_game.playersArray objectAtIndex:indexPath.row] name];
    //change to score once votes are debugged
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", [[_game.playersArray objectAtIndex:indexPath.row] votesReceived]];
    
    
    return cell;
}

- (void)addVotesToPlayer {
    // check to see who won, compare sender of pick to current players if equal add 1 to score
    if (_game.totalVoteCount < _game.playersArray.count) {
        for (int i = 0; i < _game.playersArray.count; i++) {
            if ([_nameOfWinner isEqualToString:[[_game.playersArray objectAtIndex:i] name]]){
                [_game addVotesReceived:[_game.playersArray objectAtIndex:i]];
                _game.totalVoteCount ++;
                NSLog(@"A vote was added, vote count is now: %i", _game.totalVoteCount);
            }
        }
    } else {
        NSLog(@"\n\n@@@@@@@@@@@@@@@@ Round is over, all votes received");
        
    }

    [_tableView reloadData];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
