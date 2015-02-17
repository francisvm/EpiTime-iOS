//
//  ETCourseDetailView.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 11/02/2015.
//  Copyright (c) 2015 EpiTime. All rights reserved.
//

#import "ETCourseDetailView.h"

@implementation ETCourseDetailView


- (instancetype)init {
    NSArray *bundles = [[NSBundle mainBundle] loadNibNamed:@"ETCourseDetailView"
                                                     owner:self
                                                   options:nil];
    ETCourseDetailView *view = bundles[0];
    if ((self = view))
    {

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
