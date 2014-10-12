//
//  ETDayTableViewController.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 12/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import "ETDayTableViewController.h"
#import "ETCourseTableViewCell.h"
#import "ETDayItem.h"
#import "ETCourseItem.h"
#import "ETTools.h"

#import "XMLDictionary.h"

@interface ETDayTableViewController ()

@end

@implementation ETDayTableViewController {
    ETDayItem *day;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    NSURL *url = [NSURL URLWithString:@"http://webservices.chronos.epita.net/GetWeeks.aspx?num=1&week=-1&group=ING1/GRA2&auth=3piko"];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               // Do something with the `data` unless you have `error`.
                               NSDictionary *recievedData = [NSDictionary dictionaryWithXMLData:data];
                               day = [[ETDayItem alloc] initWithDictionary:recievedData[@"week"][@"day"][4]];
                               [self.tableView reloadData];
                           }];

}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return day.courses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     ETCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseIdentifier" forIndexPath:indexPath];

    ETCourseItem *course = day.courses[indexPath.row];
    cell.nameLabel.text = course.title;
    cell.roomLabel.text = course.room;
    cell.startingLabel.text = [ETTools timeStringFromMinutes:course.hour * 15];
    cell.endingLabel.text = [ETTools timeStringFromMinutes:(course.hour + course.duration) * 15];

    return cell;
}

@end
