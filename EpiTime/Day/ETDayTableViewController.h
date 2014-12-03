//
//  ETDayTableViewController.h
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 12/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETDayItem.h"

@interface ETDayTableViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UILabel *dayLabel;

@property (strong, nonatomic) ETDayItem *day;

@property NSUInteger index;

@property NSUInteger weekIndex;

@end
