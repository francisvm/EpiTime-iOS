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
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = self.tableView.contentSize;
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([ETAPI currentTask])
        [ETAPI cancelCurrentTask];

    [super viewWillDisappear:animated];
}

- (void)fetchWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    NSLog(@"I just fetched my ass");
    [ETAPI fetchWeek:[ETAPI currentWeek] ofGroup:@"ING1/GRA2" viewController:nil
        completion:^(NSDictionary *recievedData, ETWeekItem *week) {
            self.day = week.days[[ETTools weekDayIndexFromDate:[NSDate date]] - 4];
            if (self.day)
                [self.tableView reloadData];
            completionHandler(NCUpdateResultNewData);
        }
        errorCompletion:^(NSError *error) {
            // FIXME: To show some error on the widget
        }
     ];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.day.courses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = !(indexPath.row % 2) ? @"TodayCourseIdentifierEven" : @"TodayCourseIdentifierOdd";
    ETCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    ETCourseItem *course = self.day.courses[indexPath.row];
    cell.nameLabel.text = course.title;
    cell.roomLabel.text = course.rooms[0];
    cell.startingLabel.text = [ETTools timeStringFromMinutes:course.hour * 15];
    cell.endingLabel.text = [ETTools timeStringFromMinutes:(course.hour + course.duration) * 15];

    return cell;
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    [self fetchWithCompletionHandler:completionHandler];
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
}

@end
