//
//  ScoreViewController.m
//  MeyCapstone
//
//  Created by Ellen Mey on 7/27/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

#import "ScoreViewController.h"
#import "AppDelegate.h"
#import "ImagePickerViewController.h"
#import "ConnectionsViewController.h"


@interface ScoreViewController ()

@property (strong, nonatomic) AppDelegate *appDelegate;


@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveScoreFromPeersNotification:) name:@"DidReceiveDataNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peersDidReceiveDataWithNotification:) name:@"PeerReceivedScoreNotification" object:nil];

    [self votingFor:_nameOfVotee votedBy:_appDelegate.mcHandler.session.myPeerID.displayName];
    [_game declareWinner];
    [_tableView reloadData];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundPattern"]]];
    
        
}

- (void)viewWillAppear:(BOOL)animated{
    _game.moveOnToNextRound = false;
    [_tableView reloadData];
}

- (void)didReceiveScoreFromPeersNotification:(NSNotification *)notification {
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *voterName = peerID.displayName;
    NSDictionary *userInfo = [notification userInfo];
    
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    NSString *nameOfPersonWhoWasVotedFor = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"\n\n!!!!!!!! didReceiveScoreFromPeers");
    
    // check if the sender voted, if so log it. if not count the vote and mark the sender as voted
    [self votingFor:nameOfPersonWhoWasVotedFor votedBy:voterName];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PeerReceivedScoreNotification" object:nil userInfo:userInfo];
        NSLog(@"\nScore View -- Notification was sent via dispath async\n");
    });
    [_game declareWinner];
    [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)votingFor:(NSString *)voteReceiver votedBy:(NSString *)voter {
    if ([_game checkIfPlayerVoted:voter]) {
        NSLog(@"%@ already voted - no votes added, current vote total: %i", voter, _game.totalVoteCount);
    } else {
        [_game addVotesToPlayer:voteReceiver];
        [_game oneVotePerPlayer:voter];
    }
}

- (void)peersDidReceiveDataWithNotification:(NSNotification *)notification{
    // reloadData for sender and declare winner if needed
    NSLog(@"SCORE VIEW -- peersDidReceiveDataWithNotification called \n\n");
    [_game declareWinner];
    [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
}



#pragma mark - Table View Setup

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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", [[_game.playersArray objectAtIndex:indexPath.row] score]];
    
    
    return cell;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    _game.turnCount ++;
    
    [_game clearAllVotes];
    
    // if the turn count is less than the number of prompts available the person clicks next round, then take them to the image picker
    if (_game.turnCount < _game.promptsArray.count && [[segue identifier] isEqualToString:@"toImagePicker"]){
        ImagePickerViewController *vc = [segue destinationViewController];
        vc.game = _game;
        vc.game.turnCount = _game.turnCount;
        vc.game.totalVoteCount = _game.totalVoteCount;
    } else if ([[segue identifier] isEqualToString:@"toImagePicker"]){
        // end game alert, display winner and then restart the game alert self perform segue with identifier toConnectionsView
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Game Over"
                                    message: [NSString stringWithFormat: @"The winner is: %@", [_game nameOfGameWinner]]
                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *playAgain = [UIAlertAction
                                    actionWithTitle:@"Play Again"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action) {
                                        [self performSegueWithIdentifier:@"toConnectionsView" sender:self];
                                    }];
        [alert addAction:playAgain];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        // restart the game, return to connection view
    }
    
}


@end
