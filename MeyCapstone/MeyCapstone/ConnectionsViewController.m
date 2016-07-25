//
//  ConnectionsViewController.m
//  MeyCapstone
//
//  Created by Ellen Mey on 7/21/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

#import "ConnectionsViewController.h"
#import "AppDelegate.h"
#import "GameCollectionViewController.h"
#import "ImagePickerViewController.h"


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
    
    [_textPlayerName setDelegate:self];
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

// Set Player Name - need to add edge case of trying to create name after already in a session
- (void)setPlayerName{
    [_textPlayerName resignFirstResponder];
    
    if (_appDelegate.mcHandler.peerID != nil) {
        [_appDelegate.mcHandler.session disconnect];
        _appDelegate.mcHandler.peerID = nil;
        _appDelegate.mcHandler.session = nil;
    }
    
    [_appDelegate.mcHandler setupPeerWithDisplayName:_textPlayerName.text];
    [_appDelegate.mcHandler setupSession];
    [_appDelegate.mcHandler advertiseSelf:_switchVisible.isOn];
};

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self setPlayerName];
    return YES;
}

- (IBAction)savePlayerNameButton:(id)sender {
    [self setPlayerName];
}

// Turn off advertiser if switch is off
- (IBAction)toggleVisibility:(id)sender {
    [_appDelegate.mcHandler advertiseSelf:_switchVisible.isOn];
}

- (IBAction)disconnectButtonClicked:(id)sender {
    [_appDelegate.mcHandler.session disconnect];
}

- (IBAction)searchForPlayers:(id)sender {
    NSLog(@"Browse was clicked!");
    if (_appDelegate.mcHandler.session != nil) {
        [[_appDelegate mcHandler] setupBrowser];
        [[[_appDelegate mcHandler] browser] setDelegate:self];
        
        [self presentViewController:_appDelegate.mcHandler.browser animated:YES completion:nil];
    }
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

// Create instance of a game when you click start
// Populate an array of connectedPeers
- (IBAction)startGameButtonClicked:(id)sender {
    _game = [[Game alloc] init];
    
    [_game setupGame:[self createPlayersArray]];
    
}

// Adds user to 

- (NSArray *)createPlayersArray{
    NSArray *connectedPeers = _appDelegate.mcHandler.session.connectedPeers;
    connectedPeers = [connectedPeers arrayByAddingObject:_appDelegate.mcHandler.session.myPeerID];
    NSLog(@"CONNECTED PEERS ARRAY?@?@?@ \n\n %@", connectedPeers);
    
    return connectedPeers;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // if player is the dealer then toGameCollectionVC, else toImagePickerVC
    
    if ([[segue identifier] isEqualToString:@"toImagePickerVC"]) {
        NSLog(@"TO THE IMAGE PICKER\n");
        ImagePickerViewController *vc = [segue destinationViewController];
        vc.game = _game;
        
        
    } else {
        NSLog(@"$$$$To the Game Collection View$$$$\n");
        GameCollectionViewController *vc = [segue destinationViewController];
        vc.game = _game;
    }
    
}


@end
