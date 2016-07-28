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
    // Do any additional setup after loading the view.
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
        for (int i = 0; i < _game.playersArray.count; i++ ) {
            NSLog(@"scoreVIEW DID LOAD PLAYERS ARRAY %@\n\n", [[_game.playersArray objectAtIndex:i]name]);
        }

    
}

- (void)viewDidAppear:(BOOL)animated{
    [self awardPointToWinner];
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", [[_game.playersArray objectAtIndex:indexPath.row] score]];
    
    
    return cell;
}

- (void)awardPointToWinner{
    // check to see who won, compare sender of pick to current players if equal add 1 to score
    for (int i = 0; i < _game.playersArray.count; i++) {
        if ([_nameOfWinner isEqualToString:[[_game.playersArray objectAtIndex:i] name]]){
            [_game awardPointToWinner:[_game.playersArray objectAtIndex:i]];
            NSLog(@"WINNER IS %@", [[_game.playersArray objectAtIndex:i] name]);
            
            // send notification to update table view for everyone with the new score
        }
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
