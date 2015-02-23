//
//  ETDayTableViewController.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 12/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import "ETDayTableViewController.h"
#import "ETCourseTableViewCell.h"
#import "ETCourseItem.h"
#import "ETCourseDetailView.h"
#import "ETTools.h"
#import "ETAPI.h"
#import "ETConstants.h"

#import "XMLDictionary.h"
#import "FVCustomAlertView.h"

@interface ETDayTableViewController ()

@end

@implementation ETDayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    NSArray *cachedWeekDays = [ETTools cachedWeek:self.weekIndex].days;
    if (cachedWeekDays.count)
        self.day = cachedWeekDays[self.index];
    self.dateLabel.text = [ETTools humanDateFromDate:self.day.date];
    if (!self.dateLabel.text)
        self.dateLabel.text = NSLocalizedString(@"loading", nil);
    self.dayLabel.text = [ETTools weekDayFromDate:self.day.date];
    if (!self.dayLabel.text)
        self.dayLabel.text = @"...";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self fetch:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([ETAPI currentTask])
    {
        [ETAPI cancelCurrentTask];
        [ETTools stopLoadingActivity:self error:YES]; // stop the loading activity here, don't wait for the error block to be called
    }

    [super viewWillDisappear:animated];
}

- (void)fetch:(UIRefreshControl *)refreshControl {
    [ETAPI fetchWeek:self.weekIndex ofGroup:[[ETTools currentGroup] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] viewController:self
        completion:^(NSDictionary *recievedData, ETWeekItem *week) {
            self.day = week.days[self.index];
            self.dateLabel.text = [ETTools humanDateFromDate:self.day.date];
            self.dayLabel.text = [ETTools weekDayFromDate:self.day.date];

            [self.tableView reloadData];
            if (refreshControl)
                [refreshControl endRefreshing];
        }
        errorCompletion:^(NSError *error) {
            if ([self.dateLabel.text isEqualToString:NSLocalizedString(@"loading", nil)])
                self.dateLabel.text = NSLocalizedString(@"connection_error", nil);
            if (refreshControl)
                [refreshControl endRefreshing];
        }
     ];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    if ([ETAPI currentTask])
        [refreshControl endRefreshing];
    else
        [self fetch:refreshControl];
}

- (BOOL)shouldShowHeader {
    return self.day && !self.day.courses.count;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.day.courses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = !(indexPath.row % 2) ? kCellCourseIdentifierEven : kCellCourseIdentifierOdd;
    ETCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];

    ETCourseItem *course = self.day.courses[indexPath.row];
    cell.nameLabel.text = course.title;
    cell.roomLabel.text = course.rooms[0];
    cell.startingLabel.text = [ETTools timeStringFromMinutes:course.hour * 15];
    cell.endingLabel.text = [ETTools timeStringFromMinutes:(course.hour + course.duration) * 15];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ETCourseItem *course = self.day.courses[indexPath.row];
    NSString *title = course.title;

    ETCourseDetailView *detailView = [[ETCourseDetailView alloc] init];
    detailView.titleLabel.text = title;
    detailView.frame = [[UIScreen mainScreen] bounds];
    [self.navigationController.view addSubview:detailView];
    detailView.roomsLabel.text = [course.rooms componentsJoinedByString:@"\n"];
    detailView.groupsLabel.text = [course.trainees componentsJoinedByString:@"\n"];
    detailView.instructorsLabel.text = [course.instructors componentsJoinedByString:@"\n"];
    detailView.timeLabel.text = [NSString stringWithFormat:@"%@ - %@", [ETTools timeStringFromMinutes:course.hour * 15], [ETTools timeStringFromMinutes:(course.hour + course.duration) * 15]];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self shouldShowHeader] ? 100 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self shouldShowHeader]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.alpha = 0.5;
        label.text = NSLocalizedString(@"no_class", nil);

        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_class"]];
        logo.frame = CGRectMake(self.view.frame.size.width / 2 - logo.frame.size.width / 2, label.frame.size.height, logo.frame.size.width, logo.frame.size.height);
        UIView *wrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [self tableView:tableView heightForHeaderInSection:section])];
        [wrapper addSubview:label];
        [wrapper addSubview:logo];
        return wrapper;
    }
    return nil;
}

@end
