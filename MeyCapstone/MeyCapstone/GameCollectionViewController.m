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


@interface GameCollectionViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation GameCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //_game = [[Game alloc] init];
    NSLog(@"GAME COLLECTION VIEW DID LOAD PLAYERS ARRAY %@\n\n", _game.playersArray);
   
   // _arrayOfSubmittedAnswers = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleReceivingDataWithNotification:) name:@"DidReceiveDataNotification" object:nil];

}

- (void)viewDidAppear:(BOOL)animated{
    [self.collectionView reloadData];
}

- (void)handleReceivingDataWithNotification:(NSNotification *)notification {
    // Handles received notification. Gets the submittedAnswer from the ImagePickerVC and then adds it to an array of submitted answers
    NSDictionary *userInfo = [notification userInfo];
    
    NSData *receivedData = [userInfo objectForKey:@"data"];
    SubmittedAnswer *submittedAnswer = [NSKeyedUnarchiver unarchiveObjectWithData:receivedData];
    NSLog(@"Submitted Answer: %@", submittedAnswer);
    
    if (submittedAnswer != nil) {
        [_arrayOfSubmittedAnswers addObject:submittedAnswer];
    }
    NSLog(@"Array of Submitted Answers: %@", _arrayOfSubmittedAnswers);
    [self.collectionView reloadData];
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
- (IBAction)pickWinnerButtonClicked:(id)sender {
    // Add functionality for what happens when a winner is selected
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return _game.playersArray.count;
    return _arrayOfSubmittedAnswers.count - 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    cell.label.text = [[_arrayOfSubmittedAnswers objectAtIndex:indexPath.row] sender];
    cell.image.image = [[_arrayOfSubmittedAnswers objectAtIndex:indexPath.row] submittedImage];
    
    return cell;
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
