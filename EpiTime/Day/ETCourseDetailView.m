//
//  ETCourseDetailView.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 11/02/2015.
//  Copyright (c) 2015 EpiTime. All rights reserved.
//

#import "ETCourseDetailView.h"

#import "ETTools.h"

@implementation ETCourseDetailView


- (instancetype)init {
    NSArray *bundles = [[NSBundle mainBundle] loadNibNamed:@"ETCourseDetailView"
                                                     owner:self
                                                   options:nil];
    ETCourseDetailView *view = bundles[0];
    if ((self = view))
    {
        // Initialization is done in the XIB. Add more logic here. (Maybe the size?)
        self.alpha = 0.0f;
        [ETTools fadeInView:self completion:nil];
    }
    return self;
}

- (IBAction)didTapScreen:(id)sender {
    [ETTools fadeOutView:self completion:^(BOOL finished) {
        if (finished)
            [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
