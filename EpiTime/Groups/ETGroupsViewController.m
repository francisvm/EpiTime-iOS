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
#import "ETGroupItem.h"
#import "ETConstants.h"
#import "ETTools.h"


#import "FVCustomAlertView.h"

@interface ETGroupsViewController ()

@property (nonatomic, strong) NSMutableArray *trainnees;
@property (nonatomic, strong) NSMutableArray *instructors;
@property (nonatomic, strong) NSMutableArray *rooms;
@property (nonatomic, strong) NSMutableArray *filteredGroups;
@property (nonatomic, strong) UISearchController *searchController;

typedef NS_ENUM(NSInteger, ETGroupType) {
    ETGroupTypeTrainnee,
    ETGroupTypeInstructor,
    ETGroupTypeRoom
};

@end

@implementation ETGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Hide statusbar
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
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.definesPresentationContext = YES;

    // Hack to replace the bounce background
    // http://stackoverflow.com/a/23385790/434809
    self.tableView.backgroundView = [[UIView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    // First load the students
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:NSLocalizedString(@"loading", nil) withBlur:NO allowTap:NO];
    [ETAPI fetchGroupList:^(NSDictionary *recievedData, NSMutableArray *groups) {
        [FVCustomAlertView hideAlertFromView:self.view fading:YES];
        self.trainnees = groups;
        self.filteredGroups = [self.trainnees mutableCopy];
        [self.tableView reloadData];
    }];


}

// Get the specific array of groups depending on the scope
- (NSMutableArray *)selectedGroup {
    switch (self.searchController.searchBar.selectedScopeButtonIndex) {
        case ETGroupTypeTrainnee:
            return self.trainnees;
        case ETGroupTypeInstructor:
            return self.instructors;
        case ETGroupTypeRoom:
            return self.rooms;
        default:
            return nil;
            break;
    }
}

#pragma mark UITableView delegate & dataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = !(indexPath.row % 2) ? kCellGroupIdentifierEven : kCellGroupIdentifierOdd;
    ETGroupTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];

    NSMutableArray *groups = [self selectedGroup];
    ETGroupItem *group = self.searchController.active
                           ? self.filteredGroups[indexPath.section]
                           : groups[indexPath.section];
    cell.label.text = group.groups[indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSMutableArray *groups = [self selectedGroup];
    ETGroupItem *group = self.searchController.active
                           ? self.filteredGroups[section]
                           : groups[section];
    return group.name;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self tableView:tableView numberOfRowsInSection:section] ? 30 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSMutableArray *groups = [self selectedGroup];
    ETGroupItem *group = self.searchController.active
                           ? self.filteredGroups[section]
                           : groups[section];
    UIView *v = [[UIView alloc] init];
    float height = [self tableView:self.tableView heightForHeaderInSection:section];
    UILabel *groupLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    groupLabel.textAlignment = NSTextAlignmentCenter;
    groupLabel.text = group.name;
    groupLabel.textColor = [UIColor whiteColor];
    [v addSubview:groupLabel];
    v.backgroundColor = RED;
    return v;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSMutableArray *groups = [self selectedGroup];
    return groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *groups = [self selectedGroup];
    ETGroupItem *group = self.searchController.active
                           ? self.filteredGroups[section]
                           : groups[section];
    return group.groups.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *groups = [self selectedGroup];
    ETGroupItem *group = self.searchController.active
                           ? self.filteredGroups[indexPath.section]
                           : groups[indexPath.section];
    // save the group on the extension
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:group.groups[indexPath.row] forKey:kCurrentGroup];
    [userDefaults synchronize];   // (!!) This is crucial.

    [ETTools clearData];
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
    // Lazily fetch rooms or instructors
    if (!self.rooms && selectedScope == ETGroupTypeRoom) {
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:NSLocalizedString(@"loading", nil) withBlur:NO allowTap:NO];
        [ETAPI fetchRoomsList:^(NSDictionary *recievedData, NSMutableArray *groups) {
             [FVCustomAlertView hideAlertFromView:self.view fading:YES];
             self.rooms = groups;
             [self updateSearchResultsForSearchController:self.searchController];
        }];
    } else if (!self.instructors && selectedScope == ETGroupTypeInstructor) {
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:NSLocalizedString(@"loading", nil) withBlur:NO allowTap:NO];
        [ETAPI fetchInstructorsList:^(NSDictionary *recievedData, NSMutableArray *groups) {
             [FVCustomAlertView hideAlertFromView:self.view fading:YES];
             self.instructors = groups;
             [self updateSearchResultsForSearchController:self.searchController];
        }];
    }
    [self updateSearchResultsForSearchController:self.searchController];
}

#pragma mark - Filtering

- (void)filterContentBy:(NSString *)search andScope:(NSInteger)selectedScope {
    NSMutableArray *groups = [self selectedGroup];
    if (!search || !search.length) {
        self.filteredGroups = [groups mutableCopy];
        return;
    }
    [self.filteredGroups removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", search];
    for (ETGroupItem *group in groups) {
        ETGroupItem *filteredGroup = [[ETGroupItem alloc] initWithName:group.name];
        filteredGroup.groups = [NSMutableArray arrayWithArray:[group.groups filteredArrayUsingPredicate:predicate]];
        [self.filteredGroups addObject:filteredGroup];
    }
}

@end
