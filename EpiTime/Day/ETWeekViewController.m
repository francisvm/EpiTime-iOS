//
//  ETWeekViewController.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 12/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import "ETWeekViewController.h"
#import "ETDayTableViewController.h"
#import "ETConstants.h"
#import "ETAPI.h"
#import "ETTools.h"

@interface ETWeekViewController ();

@end

@implementation ETWeekViewController

- (void)viewDidLoad {
    self.dataSource = self;
    self.title = [ETTools currentGroup];

    self.view.backgroundColor = BLUE;
}

- (void)viewWillAppear:(BOOL)animated {
    ETDayTableViewController *initialViewController = [self.storyboard instantiateViewControllerWithIdentifier:DAY_TABLE_VIEW_CONTROLLER];
    initialViewController.index = [ETTools weekDayIndexFromDate:[NSDate date]];
    initialViewController.weekIndex = [ETAPI currentWeek];

    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    ETDayTableViewController *current = (ETDayTableViewController *)viewController;
    NSUInteger index = current.index == 0 ? 6 : current.index - 1;

    ETDayTableViewController *new = [self.storyboard instantiateViewControllerWithIdentifier:DAY_TABLE_VIEW_CONTROLLER];
    new.index = index;
    new.weekIndex = current.weekIndex - (current.index == 0 ? 1 : 0);
    return new;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    ETDayTableViewController *current = (ETDayTableViewController *)viewController;
    NSUInteger index = current.index == 6 ? 0 : current.index + 1;

    ETDayTableViewController *new = [self.storyboard instantiateViewControllerWithIdentifier:DAY_TABLE_VIEW_CONTROLLER];
    new.index = index;
    new.weekIndex = current.weekIndex + (current.index == 6 ? 1 : 0);
    return new;
}

- (IBAction)didPressBackToGroups:(id)sender {
    [ETTools changeGroupWithCurrentViewController:self];
}

@end
