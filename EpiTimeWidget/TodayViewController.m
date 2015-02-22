//
//  TodayViewController.m
//  EpiTime-Widget
//
//  Created by Francis Visoiu Mistrih on 06/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import "TodayViewController.h"
#import "ETCourseTableViewCell.h"
#import "ETAPI.h"
#import "ETCourseItem.h"
#import "ETTools.h"
#import "ETConstants.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // FIXME: Share the cache
    NSArray *cachedWeekDays = [ETTools cachedWeek:[ETTools currentWeek]].days;
    if (cachedWeekDays.count)
        self.day = cachedWeekDays[[ETTools weekDayIndexFromDate:[NSDate date]]];
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([ETAPI currentTask])
        [ETAPI cancelCurrentTask];

    [super viewWillDisappear:animated];
}

- (void)fetchWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    [ETAPI fetchWeek:[ETTools currentWeek] ofGroup:@"ING1/GRA2" viewController:nil // FIXME : Current group
        completion:^(NSDictionary *recievedData, ETWeekItem *week) {

            // If an error is encountered, use NCUpdateResultFailed
            // If there's no update required, use NCUpdateResultNoData
            // If there's an update, use NCUpdateResultNewData

            ETDayItem *day = week.days[[ETTools weekDayIndexFromDate:[NSDate date]]];
            if (false && [self.day isEqualToDayItem:day]) { // FIXME: Wait for shared cache
                completionHandler(NCUpdateResultNoData);
            } else {
                self.day = day;
                [self.tableView reloadData];
                self.preferredContentSize = self.tableView.contentSize;
                completionHandler(NCUpdateResultNewData);
            }
        }
        errorCompletion:^(NSError *error) {
            if (self.day)
                completionHandler(NCUpdateResultNoData);
            else
                completionHandler(NCUpdateResultFailed);
        }
     ];
}

- (BOOL)shouldShowHeader {
    return self.day && !self.day.courses.count;
}
    
#pragma mark UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.day.courses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = !(indexPath.row % 2) ? kTodayCellCourseIdentifierEven : kTodayCellCourseIdentifierOdd;
    ETCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    ETCourseItem *course = self.day.courses[indexPath.row];
    cell.nameLabel.text = course.title;
    cell.roomLabel.text = course.rooms[0];
    cell.startingLabel.text = [ETTools timeStringFromMinutes:course.hour * 15];
    cell.endingLabel.text = [ETTools timeStringFromMinutes:(course.hour + course.duration) * 15];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self shouldShowHeader] ? 60 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self shouldShowHeader]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.alpha = 0.5;
        label.text = NSLocalizedString(@"no_class", nil);
        return label;
    }
    return nil;
}

#pragma mark Widget methods

-(UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsZero;
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    [self fetchWithCompletionHandler:completionHandler];
}

@end
