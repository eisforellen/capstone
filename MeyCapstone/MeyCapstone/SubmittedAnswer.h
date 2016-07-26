//
//  SubmittedAnswer.h
//  MeyCapstone
//
//  Created by Ellen Mey on 7/25/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SubmittedAnswer : NSObject <NSCoding>

@property (nonatomic, strong) NSString *sender;
@property (nonatomic, strong) UIImage *submittedImage;

@end
