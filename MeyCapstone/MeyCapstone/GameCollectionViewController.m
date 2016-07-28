//
//  GameCollectionViewController.m
//  MeyCapstone
//
//  Created by Ellen Mey on 7/22/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

#import "GameCollectionViewController.h"
#import "GameCollectionViewCell.h"
#import "AppDelegate.h"
#import "SubmittedAnswer.h"
#import "ScoreViewController.h"


@interface GameCollectionViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSString *selectedSubmissionName;

@end

@implementation GameCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleReceivingDataWithNotification:) name:@"DidReceiveDataNotification" object:nil];
    // AddObserver and Notification for when the above handle is triggered to send a notification back to the sender
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peersDidReceiveDataWithNotification:) name:@"PeerReceivedDataNotification" object:nil];
    
    // AddObserver and Notification for when a vote is received before you get to the ScoreViewController
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveScoreUpdateNotificaton:) name:@"DidUpdateScoreNotification" object:nil];

}
- (void)didRecieveScoreUpdateNotificaton:(NSNotification *)notification{
//    // increment voteCount, if equal to playersCount then calculate winner and update score
    NSDictionary *userInfo = [notification userInfo];
    
    NSString *nameOfWinner = [userInfo objectForKey:@"selectedSubmissionName"];
    NSString *me = [userInfo objectForKey:@"myPeerID"];
    NSLog(@"\nName Of Winner in GCView is: %@", nameOfWinner);
    if ([[_appDelegate.mcHandler.session.myPeerID displayName] isEqualToString:me]) {
        NSLog(@"JUST ME DONT VOTE");
    } else {
        if (_game.totalVoteCount < _game.playersArray.count) {
            for (int i = 0; i < _game.playersArray.count; i++) {
                if ([_selectedSubmissionName isEqualToString:[[_game.playersArray objectAtIndex:i] name]]){
                    [_game addVotesReceived:[_game.playersArray objectAtIndex:i]];
                    _game.totalVoteCount ++;
                    NSLog(@"IN GAMECVC A vote was added, vote count is now: %i", _game.totalVoteCount);
                }
            }
        }
    }
    NSLog(@"\n ....THIS didReceiveScoreUpdateNotification called in GameCollectionView \n");
}


- (void)handleReceivingDataWithNotification:(NSNotification *)notification {
    // Handles received notification. Gets the submittedAnswer from the ImagePickerVC and then adds it to an array of submitted answers
    NSDictionary *userInfo = [notification userInfo];
    
    NSData *receivedData = [userInfo objectForKey:@"data"];
    SubmittedAnswer *submittedAnswer = [NSKeyedUnarchiver unarchiveObjectWithData:receivedData];
    NSLog(@"Submitted Answer on handleReceivingData: %@", submittedAnswer);
    
    // check if the submission is already there and submission count matches player count
    if (submittedAnswer != nil && ![_arrayOfSubmittedAnswers containsObject:submittedAnswer] && _arrayOfSubmittedAnswers.count < _game.playersArray.count) {
        [_arrayOfSubmittedAnswers addObject:submittedAnswer];
    }
    NSLog(@"Array of Submitted Answers: %@", _arrayOfSubmittedAnswers);
    
    
    // Adding notification that gets sent back to sender in order to trigger reloadData
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PeerReceivedDataNotification" object:nil userInfo:userInfo];
        NSLog(@"Notification was sent via dispath async");
    });
    [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];

}

- (void)peersDidReceiveDataWithNotification:(NSNotification *)notification{
    // reloadData for sender
    NSLog(@"peersDidReceiveDataWithNotification called \n\n");
    [self.collectionView reloadData];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // send notification to peers that the score was updated
    NSDictionary *userInfo = @{@"selectedSubmissionName" : _selectedSubmissionName,
                               @"myPeerID" : [_appDelegate.mcHandler.session.myPeerID displayName]};
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidUpdateScoreNotification" object:nil userInfo:userInfo];
    });
    ScoreViewController *vc = [segue destinationViewController];
    vc.game = _game;
    vc.game.playersArray = _game.playersArray;
    vc.nameOfWinner = _selectedSubmissionName;
}

- (IBAction)pickWinnerButtonClicked:(id)sender {

}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrayOfSubmittedAnswers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    cell.label.text = [[_arrayOfSubmittedAnswers objectAtIndex:indexPath.row] sender];
    cell.image.image = [[_arrayOfSubmittedAnswers objectAtIndex:indexPath.row] submittedImage];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // capture the sender of the image that is selected and transfer that via segue to score vc
    _selectedSubmissionName = [[_arrayOfSubmittedAnswers objectAtIndex:indexPath.row] sender];
    NSLog(@"\n\nSelectedWinnerName from sender is %@", _selectedSubmissionName);
    
}

#pragma mark <UICollectionViewDelegate>
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
