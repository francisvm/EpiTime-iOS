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

    [super viewDidLoad];

    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    self.weekIndex = [ETAPI currentWeek];
}

- (void)viewWillAppear:(BOOL)animated {
    ETDayTableViewController *initialViewController = [self.storyboard instantiateViewControllerWithIdentifier:DAY_TABLE_VIEW_CONTROLLER];
    
    initialViewController.index = [ETTools weekDayIndexFromDate:[NSDate date]];
    initialViewController.weekIndex = self.weekIndex;


    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
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
    if (current.index == 6)
        self.weekIndex++;
    NSUInteger index = current.index == 6 ? 0 : current.index + 1;

    ETDayTableViewController *new = [self.storyboard instantiateViewControllerWithIdentifier:DAY_TABLE_VIEW_CONTROLLER];
    new.index = index;
    new.weekIndex = current.weekIndex + (current.index == 6 ? 1 : 0);
    return new;
}

@end
