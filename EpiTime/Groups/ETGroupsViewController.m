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
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation ETGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Hide statusbar
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];

    self.groups = [NSMutableArray array];
    self.filteredGroups = [NSMutableArray array];

    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];

    // Setup appearance
    self.searchController.searchBar.barStyle = UIBarStyleBlack;
    self.searchController.searchBar.barTintColor = BLUE;
    self.searchController.searchBar.tintColor = RED;
    self.searchController.searchBar.keyboardAppearance = UIKeyboardAppearanceDark;

    // Setup logic
    self.searchController.searchBar.scopeButtonTitles = @[ NSLocalizedString(@"students", nil), NSLocalizedString(@"professors", nil), NSLocalizedString(@"rooms", nil) ];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.definesPresentationContext = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:NSLocalizedString(@"loading", nil) withBlur:NO];
    [ETAPI fetchGroupList:^(NSDictionary *recievedData, NSMutableArray *groups)
     {
         [FVCustomAlertView hideAlertFromView:self.view fading:YES];
         self.groups = groups;
         self.filteredGroups = [self.groups mutableCopy];
         [self.tableView reloadData];
     }];
}

#pragma mark UITableView delegate & dataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = !(indexPath.row % 2) ? kCellGroupIdentifierEven : kCellGroupIdentifierOdd;
    ETGroupTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    ETSchoolItem *school = self.searchController.active
                           ? self.filteredGroups[indexPath.section]
                           : self.groups[indexPath.section];
    cell.label.text = school.groups[indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ETSchoolItem *school = self.searchController.active
                           ? self.filteredGroups[section]
                           : self.groups[section];
    return school.name;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self tableView:tableView numberOfRowsInSection:section] ? 30 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ETSchoolItem *school = self.searchController.active
                           ? self.filteredGroups[section]
                           : self.groups[section];
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
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ETSchoolItem *school = self.searchController.active
                           ? self.filteredGroups[section]
                           : self.groups[section];
    return school.groups.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ETSchoolItem *school = self.searchController.active
                           ? self.filteredGroups[indexPath.section]
                           : self.groups[indexPath.section];
    // save the group on the extension
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:school.groups[indexPath.row] forKey:kCurrentGroup];
    [userDefaults synchronize];   // (!!) This is crucial.

    [ETTools clearData];

    // Don't forget to show the status bar again
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = self.searchController.searchBar.text;
    NSInteger selectedScope = self.searchController.searchBar.selectedScopeButtonIndex;

    [self filterContentBy:searchString andScope:selectedScope];

    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate

// Workaround for bug: -updateSearchResultsForSearchController: is not called when scope buttons change
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

#pragma mark - Filtering

- (void)filterContentBy:(NSString *)search andScope:(NSInteger)selectedScope {
    if (!search || !search.length) {
        self.filteredGroups = [self.groups mutableCopy];
        return;
    }
    [self.filteredGroups removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", search];
    for (ETSchoolItem *school in self.groups) {
        ETSchoolItem *filteredSchool = [[ETSchoolItem alloc] initWithName:school.name];
        filteredSchool.groups = [NSMutableArray arrayWithArray:[school.groups filteredArrayUsingPredicate:predicate]];
        [self.filteredGroups addObject:filteredSchool];
    }
}

@end
