//
//  ETGroupsViewController.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 19/12/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import "ETGroupsViewController.h"
#import "ETGroupTableViewCell.h"
#import "ETAPI.h"
#import "ETSchoolItem.h"
#import "ETConstants.h"

@interface ETGroupsViewController ()

@property (nonatomic, strong) NSMutableArray *groups;

@end

@implementation ETGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.groups = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [ETAPI fetchGroupList:^(NSDictionary *recievedData, NSMutableArray *groups)
     {
         self.groups = groups;
         [self.tableView reloadData];
     }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = !(indexPath.row % 2) ? @"GroupIdentifierEven" : @"GroupIdentifierOdd";
    ETGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    ETSchoolItem *school = self.groups[indexPath.section];
    cell.label.text = school.groups[indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ETSchoolItem *school = self.groups[section];
    return school.name;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ETSchoolItem *school = self.groups[section];
    UIView *v = [[UIView alloc] init];
    float height = [self.tableView sectionHeaderHeight];
    UILabel *schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    schoolLabel.textAlignment = NSTextAlignmentCenter;
    schoolLabel.text = school.name;
    schoolLabel.textColor = [UIColor whiteColor];
    [v addSubview:schoolLabel];
    v.backgroundColor = section % 2 ? RED : GREEN;
    return v;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ETSchoolItem *school = self.groups[section];
    return school.groups.count;
}


@end
