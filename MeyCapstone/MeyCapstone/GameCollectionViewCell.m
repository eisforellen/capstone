//
//  GameCollectionViewCell.m
//  MeyCapstone
//
//  Created by Ellen Mey on 7/22/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

#import "GameCollectionViewCell.h"

@implementation GameCollectionViewCell

- (void)awakeFromNib {
    // background color
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView = bgView;
    //self.backgroundView.backgroundColor = [UIColor whiteColor];
    
    
    // selected background
    UIView *selectedView = [[ UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView = selectedView;
    self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    
    
}

@end
