//
//  ETCourseDetailView.h
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 11/02/2015.
//  Copyright (c) 2015 EpiTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ETCourseDetailView;

@protocol ETCourseDetailViewProtocol <NSObject>

- (void)courseDetailView:(ETCourseDetailView *)courseDetailView didExitViewWithTitle:(NSString *)ignoredTitle;

- (void)courseDetailView:(ETCourseDetailView *)courseDetailView didPressIgnoreWithTitle:(NSString *)ignoredTitle;

- (void)didExitView;

@end

@interface ETCourseDetailView : UIView

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *roomsLabel;

@property (strong, nonatomic) IBOutlet UILabel *groupsLabel;

@property (strong, nonatomic) IBOutlet UILabel *instructorsLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) id<ETCourseDetailViewProtocol> delegate;

- (IBAction)didPressIgnore:(id)sender;

@end
