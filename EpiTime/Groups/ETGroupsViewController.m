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
@property (nonatomic, strong) NSMutableArray *filteredGroups;

@end

@implementation ETGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.groups = [NSMutableArray array];
    self.filteredGroups = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [ETAPI fetchGroupList:^(NSDictionary *recievedData, NSMutableArray *groups)
     {
         self.groups = groups;
         [self.tableView reloadData];
     }];
}

#pragma mark UITableView delegate & dataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = !(indexPath.row % 2) ? @"GroupIdentifierEven" : @"GroupIdentifierOdd";
    ETGroupTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    ETSchoolItem *school = self.tableView == self.searchDisplayController.searchResultsTableView
                           ? self.filteredGroups[indexPath.section]
                           : self.groups[indexPath.section];
    cell.label.text = school.groups[indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ETSchoolItem *school = tableView == self.searchDisplayController.searchResultsTableView
                           ? self.filteredGroups[section]
                           : self.groups[section];
    return school.name;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self tableView:tableView numberOfRowsInSection:section] ? 30 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ETSchoolItem *school = self.groups[section];
    UIView *v = [[UIView alloc] init];
    float height = [self tableView:self.tableView heightForHeaderInSection:section];
    UILabel *schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    schoolLabel.textAlignment = NSTextAlignmentCenter;
    schoolLabel.text = school.name;
    schoolLabel.textColor = [UIColor whiteColor];
    [v addSubview:schoolLabel];
    v.backgroundColor = RED;
    return v;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return tableView == self.searchDisplayController.searchResultsTableView ? self.filteredGroups.count : self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ETSchoolItem *school = tableView == self.searchDisplayController.searchResultsTableView
                           ? self.filteredGroups[section]
                           : self.groups[section];
    return school.groups.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (void)filterContentBy:(NSString *)search {
    [self.filteredGroups removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", search];
    for (ETSchoolItem *school in self.groups) {
        ETSchoolItem *filteredSchool = [[ETSchoolItem alloc] initWithName:school.name];
        filteredSchool.groups = [NSMutableArray arrayWithArray:[school.groups filteredArrayUsingPredicate:predicate]];
        [self.filteredGroups addObject:filteredSchool];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentBy:searchString];
    return YES;
}

@end
