//
//  ETCourseDetailView.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 11/02/2015.
//  Copyright (c) 2015 EpiTime. All rights reserved.
//

#import "ETCourseDetailView.h"

#import "ETTools.h"
#import "ETUIKitTools.h"
#import "ETConstants.h"

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
        [ETUIKitTools fadeInView:self completion:nil];
    }
    return self;
}

- (void)exitFading {
    [ETUIKitTools fadeOutView:self completion:^(BOOL finished) {
        if (finished) {
            if ([self.delegate respondsToSelector:@selector(courseDetailView:didExitViewWithTitle:)])
                [self.delegate courseDetailView:self didExitViewWithTitle:self.titleLabel.text];
            [self removeFromSuperview];
        }
    }];
}

- (IBAction)didTapScreen:(id)sender {
    [self exitFading];
}

- (IBAction)didPressIgnore:(id)sender {
    if ([self.delegate respondsToSelector:@selector(courseDetailView:didPressIgnoreWithTitle:andIndexPath:)])
        [self.delegate courseDetailView:self didPressIgnoreWithTitle:self.titleLabel.text andIndexPath:self.indexPath];
    [self exitFading];
}

@end
