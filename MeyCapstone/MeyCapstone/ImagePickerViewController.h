//
//  ImagePickerViewController.h
//  MeyCapstone
//
//  Created by Ellen Mey on 7/25/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface ImagePickerViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) Game *game;

@end
