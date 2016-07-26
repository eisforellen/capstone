//
//  SubmittedAnswer.m
//  MeyCapstone
//
//  Created by Ellen Mey on 7/25/16.
//  Copyright © 2016 Ellen Mey. All rights reserved.
//

#import "SubmittedAnswer.h"

@implementation SubmittedAnswer

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_sender forKey:@"sender"];
    [aCoder encodeObject:_submittedImage forKey:@"submittedImage"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [self init];
    _sender = [aDecoder decodeObjectForKey:@"sender"];
    _submittedImage = [aDecoder decodeObjectForKey:@"submittedImage"];
    return self;
}

@end
