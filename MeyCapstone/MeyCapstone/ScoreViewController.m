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
    [self declareWinner];
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
    [self declareWinner];
    [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)votingFor:(NSString *)voteReceiver votedBy:(NSString *)voter {
    if ([_game checkIfPlayerVoted:voter]) {
        NSLog(@"%@ already voted - no votes added, current vote total: %i", voter, _game.totalVoteCount);
    } else {
        [self addVotesToPlayer:voteReceiver];
        [_game oneVotePerPlayer:voter];
    }
}

- (void)peersDidReceiveDataWithNotification:(NSNotification *)notification{
    // reloadData for sender and declare winner if needed
    NSLog(@"SCORE VIEW -- peersDidReceiveDataWithNotification called \n\n");
    [self declareWinner];
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

// looks at the sorted array, if the first person has the highest score then award them a point, else it's a tie
- (void)awardPointToWinner:(NSArray *)sortedArray{
    if (_game.playersArray.count > 1) {
        if ([sortedArray[0] votesReceived] > [sortedArray[1] votesReceived]){
            [_game awardPoint:[sortedArray objectAtIndex:0]];
            // add alert for who won the round
            [self alertForEndOfRoundTitle:@"We have a winner!"
                                  message:[NSString stringWithFormat:@"%@ gets a point!", [[sortedArray objectAtIndex:0] name]]];
            NSLog(@"Player %@ is the winner!", [sortedArray[0] name]);
        } else {
            NSLog(@"It's a tie!");
            [self alertForEndOfRoundTitle:@"It's a tie!"
                                  message:@"Nobody gets a point"];
            
        }
    } else {
        NSLog(@"there is only one player");
    }
}

// if we have all the votes in, tally them, sort them and award a point to the winner
- (void)declareWinner{
    if (!_game.moveOnToNextRound){
        if ([_game readyToAwardPoints]) {
            NSLog(@"THE GAME IS OVER WE HAVE A WEINER!");
            [self awardPointToWinner:[_game sortPlayersBy:@"votesReceived"]];
            _game.moveOnToNextRound = YES;
        } else {
            NSLog(@"No winner yet");
        }
    } else {
        NSLog(@"declareWinner called but round is over\n");
    }
}

- (void)addVotesToPlayer:(NSString *)nameOfWinner{
    // check to see who won, compare sender of pick to current players if equal add 1 to score
    // if game is not ready to award points
    //[self declareWinner];
    if (![_game readyToAwardPoints]) {
        for (int i = 0; i < _game.playersArray.count; i++) {
            if ([nameOfWinner isEqualToString:[[_game.playersArray objectAtIndex:i] name]]){
                [_game addVotesReceived:[_game.playersArray objectAtIndex:i]];
                _game.totalVoteCount ++;
                NSLog(@"A vote was added, vote count is now: %i", _game.totalVoteCount);
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertForEndOfRoundTitle:(NSString *)title message:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action){
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
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
