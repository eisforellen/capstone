//
//  ConnectionsViewController.m
//  MeyCapstone
//
//  Created by Ellen Mey on 7/21/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

#import "ConnectionsViewController.h"
#import "AppDelegate.h"

@interface ConnectionsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textPlayerName;
@property (weak, nonatomic) IBOutlet UISwitch *switchVisible;
@property (weak, nonatomic) IBOutlet UITextView *textViewPlayerList;

@property (strong, nonatomic) AppDelegate *appDelegate;

@end

@implementation ConnectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [_appDelegate.mcHandler setupPeerWithDisplayName:[UIDevice currentDevice].name];
    [_appDelegate.mcHandler setupSession];
    [_appDelegate.mcHandler advertiseSelf:_switchVisible.isOn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peerChangedStateWithNotification:) name:@"DidChangeStateNotification" object:nil];
}

- (void)peerChangedStateWithNotification:(NSNotification *)notification {
    // Get state of the peer
    int state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    //Ignoring connecting state, if connected display the names of the peer
    if (state != MCSessionStateConnecting) {
        NSString *allPlayers = @"";
        for (int i = 0; i < _appDelegate.mcHandler.session.connectedPeers.count; i++) {
            NSString *displayName = [[_appDelegate.mcHandler.session.connectedPeers objectAtIndex:i] displayName];
            allPlayers = [allPlayers stringByAppendingString:@"\n"];
            allPlayers = [allPlayers stringByAppendingString:displayName];
        }
        
        [_textViewPlayerList setText:allPlayers];
    }
    
}


- (IBAction)savePlayerNameButton:(id)sender {
}

- (IBAction)toggleVisibility:(id)sender {
}

- (IBAction)disconnectButtonClicked:(id)sender {
}

- (IBAction)searchForPlayers:(id)sender {
    NSLog(@"Browse was clicked!");
    if (_appDelegate.mcHandler.session != nil) {
        [[_appDelegate mcHandler] setupBrowser];
        [[[_appDelegate mcHandler] browser] setDelegate:self];
        
        [self presentViewController:_appDelegate.mcHandler.browser animated:YES completion:nil];
    }
}

- (IBAction)startGameButtonClicked:(id)sender {
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [_appDelegate.mcHandler.browser dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [_appDelegate.mcHandler.browser dismissViewControllerAnimated:YES completion:nil];
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
