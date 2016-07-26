//
//  ImagePickerViewController.m
//  MeyCapstone
//
//  Created by Ellen Mey on 7/25/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

#import "ImagePickerViewController.h"
#import "AppDelegate.h"
#import "GameCollectionViewController.h"

@interface ImagePickerViewController ()

@property (strong, nonatomic) AppDelegate *appDelegate;

@end

@implementation ImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)takePhoto:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Yikes!" message:@"There is no camera :(" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}
- (IBAction)selectPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    _imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitImage:(id)sender {
    // MOVED TO PREPARE FOR SEGUE SO IT HITS IN THE RIGHT ORDER
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // creates SubmittedAnswer object that will take the current image and username and send it as NSData via notification to the GameCVC
    NSLog(@"PLAYERS ARRAY ON IMAGE PICKER IS: %@", _game.playersArray);
    
    SubmittedAnswer *submission = [[SubmittedAnswer alloc] init];
    submission.submittedImage = _imageView.image;
    submission.sender = _appDelegate.mcHandler.session.myPeerID.displayName;
    
    NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject:submission];
    NSError *error;
    [_appDelegate.mcHandler.session sendData:dataToSend
                                     toPeers:_appDelegate.mcHandler.session.connectedPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];
    if (error != nil) {
        NSLog(@"Sending submission error: %@\n\n", [error localizedDescription]);
    }
    
    // add submission to array to pass own image to populate collection view
    NSMutableArray *arrayOfOwnSubmission = [[NSMutableArray alloc] initWithObjects:submission, nil];
    
    if ([[segue identifier] isEqualToString:@"toGameCollectionVC"]){
        GameCollectionViewController *vc = [segue destinationViewController];
        NSLog(@"\n\n PREPARE FOR SEGUE FROM IP, current players array: %@", _game.playersArray);
        vc.game = _game;
        vc.game.playersArray = _game.playersArray;
        vc.arrayOfSubmittedAnswers = arrayOfOwnSubmission;
    }
}


@end
