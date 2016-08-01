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

//remove this once bool is abstracted to the class
//@property (nonatomic) BOOL roundIsOver;

@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveScoreFromPeersNotification:) name:@"DidReceiveDataNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peersDidReceiveDataWithNotification:) name:@"PeerReceivedScoreNotification" object:nil];

    //[_game addVotesToPlayer];
    [_tableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    _game.moveOnToNextRound = false;
}

- (void)didReceiveScoreFromPeersNotification:(NSNotification *)notification {
//    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
//    NSString *voterName = peerID.displayName;
    NSDictionary *userInfo = [notification userInfo];
    
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    NSString *nameOfPersonWhoWasVotedFor = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"\n\n!!!!!!!! didReceiveScoreFromPeers");
    [_game addVotesToPlayer:nameOfPersonWhoWasVotedFor];
//    if (_game.totalVoteCount < _game.playersArray.count) {
//        for (int i = 0; i < _game.playersArray.count; i++) {
//            if ([nameOfPersonWhoWasVotedFor isEqualToString:[[_game.playersArray objectAtIndex:i] name]]){
//                [_game addVotesReceived:[_game.playersArray objectAtIndex:i]];
//                _game.totalVoteCount ++;
//                NSLog(@"A vote was added, vote count is now: %i", _game.totalVoteCount);
//            }
//        }
//    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PeerReceivedScoreNotification" object:nil userInfo:userInfo];
        NSLog(@"\nScore View -- Notification was sent via dispath async\n");
    });
    [_game declareWinner];
    [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    // add vote to the person.vote and trigger that the person voted
}

- (void)peersDidReceiveDataWithNotification:(NSNotification *)notification{
    // reloadData for sender and declare winner if needed
    NSLog(@"SCORE VIEW -- peersDidReceiveDataWithNotification called \n\n");
    [_game declareWinner];
    [_tableView performSelector:@selector(reloadData) withObject:nil afterDelay:2.0];
    
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
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Game Over" message:@"The winner is:" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *playAgain = [UIAlertAction actionWithTitle:@"Play Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self performSegueWithIdentifier:@"toConnectionsView" sender:self];
        }];
        [alert addAction:playAgain];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        // restart the game, return to connection view
    }
    
}


@end
