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
#import "ETTools.h"


#import "FVCustomAlertView.h"

@interface ETGroupsViewController ()

@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NSMutableArray *filteredGroups;

@end

@implementation ETGroupsViewController {
    BOOL isSearching;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.groups = [NSMutableArray array];
    self.filteredGroups = [NSMutableArray array];
    isSearching = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"Loading..." withBlur:NO];
    [ETAPI fetchGroupList:^(NSDictionary *recievedData, NSMutableArray *groups)
     {
         [FVCustomAlertView hideAlertFromView:self.view fading:YES];
         self.groups = groups;
         [self.tableView reloadData];
     }];
}

#pragma mark UITableView delegate & dataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = !(indexPath.row % 2) ? @"GroupIdentifierEven" : @"GroupIdentifierOdd";
    ETGroupTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    ETSchoolItem *school = isSearching
                           ? self.filteredGroups[indexPath.section]
                           : self.groups[indexPath.section];
    cell.label.text = school.groups[indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ETSchoolItem *school = isSearching
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
    return isSearching ? self.filteredGroups.count : self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ETSchoolItem *school = isSearching
                           ? self.filteredGroups[section]
                           : self.groups[section];
    return school.groups.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ETSchoolItem *school = isSearching
                            ? self.filteredGroups[indexPath.section]
                            : self.groups[indexPath.section];
    [[NSUserDefaults standardUserDefaults] setValue:school.groups[indexPath.row] forKey:CURRENT_GROUP];
    [ETTools clearData];
}

#pragma mark UISearchBar delegate

- (void)filterContentBy:(NSString *)search {
    [self.filteredGroups removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", search];
    for (ETSchoolItem *school in self.groups) {
        ETSchoolItem *filteredSchool = [[ETSchoolItem alloc] initWithName:school.name];
        filteredSchool.groups = [NSMutableArray arrayWithArray:[school.groups filteredArrayUsingPredicate:predicate]];
        [self.filteredGroups addObject:filteredSchool];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    isSearching = [searchText length];
    if (isSearching)
        [self filterContentBy:searchText];
    [self.tableView reloadData];
}

@end
