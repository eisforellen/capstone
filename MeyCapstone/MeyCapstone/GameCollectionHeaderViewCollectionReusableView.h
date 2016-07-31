//
//  GameCollectionHeaderViewCollectionReusableView.h
//  MeyCapstone
//
//  Created by Ellen Mey on 7/31/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameCollectionHeaderViewCollectionReusableView : UICollectionReusableView
@property (strong, nonatomic) IBOutlet UILabel *promptInHeaderLabel;

- (void)setPromptLabel:(NSString *)prompt;

@end
