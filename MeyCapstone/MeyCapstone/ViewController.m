//
//  ViewController.m
//  MeyCapstone
//
//  Created by Ellen Mey on 7/21/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextView *instructionTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_instructionTextView setText:@"Connect with friends\nPick your best photo\nVote for your favorite pic\nMost votes wins the round"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundPattern"]]];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:21.0/255 green:165.0/255 blue:180.0/255 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)connectButtonClicked:(id)sender {
}

@end
