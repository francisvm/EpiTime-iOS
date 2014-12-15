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
#import "ETTools.h"
#import "ETAPI.h"

#import "XMLDictionary.h"

@interface ETDayTableViewController ()

@property (strong, nonatomic) NSURLSessionDataTask *currentTask;

@end

@implementation ETDayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    self.currentTask = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    NSArray *cachedWeekDays = [ETAPI cachedWeek:self.weekIndex].days;
    if (cachedWeekDays.count)
        self.day = cachedWeekDays[self.index];
    self.dateLabel.text = [ETTools humanDateFromDate:self.day.date];
    if (!self.dateLabel.text)
        self.dateLabel.text = @"Loading";
    self.dayLabel.text = [ETTools weekDayFromDate:self.day.date];
    if (!self.dayLabel.text)
        self.dayLabel.text = @"...";

    self.currentTask = [ETAPI fetchWeek:self.weekIndex ofGroup:@"ING1/GRA2" viewController:self completion:^(NSDictionary *recievedData, ETWeekItem *week) {
        self.day = week.days[self.index];
        self.dateLabel.text = [ETTools humanDateFromDate:self.day.date];
        self.dayLabel.text = [ETTools weekDayFromDate:self.day.date];

        [self.tableView reloadData];
        self.currentTask = nil;
     }];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.currentTask)
    {
        NSLog(@"canceling");
        [self.currentTask cancel];
        self.currentTask = nil;
    }

    [super viewWillDisappear:animated];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    if (self.currentTask)
    {
        [refreshControl endRefreshing];
        return;
    }

    self.currentTask = [ETAPI fetchWeek:self.weekIndex ofGroup:@"ING1/GRA2" viewController:self completion:^(NSDictionary *recievedData, ETWeekItem *week) {
        self.day = week.days[self.index];
        self.dateLabel.text = [ETTools humanDateFromDate:self.day.date];
        self.dayLabel.text = [ETTools weekDayFromDate:self.day.date];

        [self.tableView reloadData];
        [refreshControl endRefreshing];
        self.currentTask = nil;
     }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.day.courses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = !(indexPath.row % 2) ? @"CourseIdentifierEven" : @"CourseIdentifierOdd";
    ETCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];

    ETCourseItem *course = self.day.courses[indexPath.row];
    cell.nameLabel.text = course.title;
    cell.roomLabel.text = course.rooms[0];
    cell.startingLabel.text = [ETTools timeStringFromMinutes:course.hour * 15];
    cell.endingLabel.text = [ETTools timeStringFromMinutes:(course.hour + course.duration) * 15];

    return cell;
}

@end
