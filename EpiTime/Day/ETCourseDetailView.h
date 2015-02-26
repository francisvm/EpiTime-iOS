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

@optional

- (void)courseDetailView:(ETCourseDetailView *)courseDetailView didExitViewWithTitle:(NSString *)ignoredTitle;

@required

- (void)courseDetailView:(ETCourseDetailView *)courseDetailView didPressIgnoreWithTitle:(NSString *)ignoredTitle andIndexPath:(NSIndexPath *)indexPath;

@end

@interface ETCourseDetailView : UIView

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *roomsLabel;

@property (strong, nonatomic) IBOutlet UILabel *groupsLabel;

@property (strong, nonatomic) IBOutlet UILabel *instructorsLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) id<ETCourseDetailViewProtocol> delegate;

- (IBAction)didPressIgnore:(id)sender;

@end
