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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.ignored.count ? 0 : 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!self.ignored.count) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.alpha = 0.5;
        label.text = NSLocalizedString(@"no_ignored", nil);

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
