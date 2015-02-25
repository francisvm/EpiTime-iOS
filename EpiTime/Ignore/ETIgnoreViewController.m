//
//  ETIgnoreViewController.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 25/02/2015.
//  Copyright (c) 2015 EpiTime. All rights reserved.
//

#import "ETIgnoreViewController.h"

#import "ETTools.h"
#import "ETConstants.h"
#import "ETIgnoreTableViewCell.h"

@interface ETIgnoreViewController ()

@property (strong, nonatomic) NSMutableSet *ignored;

@end

@implementation ETIgnoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ignored = [ETTools ignoredData];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:editing];
}


#pragma mark UITableView delegate & dataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = !(indexPath.row % 2) ? kCellIgnoreIdentifierEven : kCellIgnoreIdentifierOdd;
    ETIgnoreTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];

    cell.label.text = [self.ignored allObjects][indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ignored.count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.ignored removeObject:self.ignored.allObjects[indexPath.row]];
        [ETTools removeIgnoredData:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
