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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveScoreFromPeersNotification:) name:@"DidReceiveDataNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peersDidReceiveDataWithNotification:) name:@"PeerReceivedScoreNotification" object:nil];

    [self addVotesToPlayer];
    [_tableView reloadData];
    
}

- (void)didReceiveScoreFromPeersNotification:(NSNotification *)notification {
//    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
//    NSString *voterName = peerID.displayName;
    NSDictionary *userInfo = [notification userInfo];
    
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    NSString *nameOfPersonWhoWasVotedFor = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"\n\n!!!!!!!! didReceiveScoreFromPeers");
    if (_game.totalVoteCount < _game.playersArray.count) {
        for (int i = 0; i < _game.playersArray.count; i++) {
            if ([nameOfPersonWhoWasVotedFor isEqualToString:[[_game.playersArray objectAtIndex:i] name]]){
                [_game addVotesReceived:[_game.playersArray objectAtIndex:i]];
                _game.totalVoteCount ++;
                NSLog(@"A vote was added, vote count is now: %i", _game.totalVoteCount);
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PeerReceivedScoreNotification" object:nil userInfo:userInfo];
        NSLog(@"\nScore View -- Notification was sent via dispath async\n");
    });
    [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    // add vote to the person.vote and trigger that the person voted
}

- (void)peersDidReceiveDataWithNotification:(NSNotification *)notification{
    // reloadData for sender and declare winner if needed
    NSLog(@"SCORE VIEW -- peersDidReceiveDataWithNotification called \n\n");
    [self declareWinner];
    [_tableView reloadData];
    
}

- (void)addVotesToPlayer{
    // check to see who won, compare sender of pick to current players if equal add 1 to score
    if (_game.totalVoteCount < _game.playersArray.count) {
        for (int i = 0; i < _game.playersArray.count; i++) {
            if ([_nameOfWinner isEqualToString:[[_game.playersArray objectAtIndex:i] name]]){
                [_game addVotesReceived:[_game.playersArray objectAtIndex:i]];
                _game.totalVoteCount ++;
                NSLog(@"A vote was added, vote count is now: %i", _game.totalVoteCount);
            }
        }
    }
    [self declareWinner];
    
    [_tableView reloadData];
}

// sorts plays from highest score to lowest

- (NSArray *)sortPlayersByVotes{
    NSLog(@"Players array before sort: %@", _game.playersArray);
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"votesReceived" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *playersSortedByVotesReceived = [_game.playersArray sortedArrayUsingDescriptors:sortDescriptors];
    NSLog(@"Sorted Players Array by Vote: %@", playersSortedByVotesReceived);
    return playersSortedByVotesReceived;
}

// looks at the sorted array, if the first person has the highest score then award them a point, else it's a tie
- (void)awardPointToWinner:(NSArray *)sortedArray{
    if ([sortedArray[0] votesReceived] > [sortedArray[1] votesReceived]){
        NSLog(@"Player %@ is the winner!", [sortedArray[0] name]);
        [_game awardPointToWinner:[sortedArray objectAtIndex:0]];
    } else {
        NSLog(@"It's a tie!");
    }
}

// if we have all the votes in, tally them, sort them and award a point to the winner
- (void)declareWinner{
    if (_game.totalVoteCount >= _game.playersArray.count) {
        NSLog(@"THE GAME IS OVER WE HAVE A WEINER!");
        [self awardPointToWinner:[self sortPlayersByVotes]];
        [_tableView reloadData];
    } else {
        NSLog(@"No winner yet");
    }
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
