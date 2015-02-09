//
//  TodayViewController.h
//  EpiTime-Widget
//
//  Created by Francis Visoiu Mistrih on 06/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETDayItem.h"

@interface TodayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) ETDayItem *day;

@end
