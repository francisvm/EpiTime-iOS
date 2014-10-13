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

@interface ETWeekViewController () {
    NSMutableArray *loadedControllers;
    NSUInteger *index;
}

@end

@implementation ETWeekViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];


}

- (void)viewWillAppear:(BOOL)animated {
    [ETAPI fetchCurrentWeek:@"ING1/GRA2" completion:^(NSDictionary *recievedData, ETWeekItem *week){
        ETDayTableViewController *initialViewController = [self.storyboard instantiateViewControllerWithIdentifier:DAY_TABLE_VIEW_CONTROLLER];
        initialViewController.index = 0;
        initialViewController.day = week.days[0];

        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];

        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

        [self addChildViewController:self.pageController];
        [[self view] addSubview:[self.pageController view]];
        [self.pageController didMoveToParentViewController:self];

        loadedControllers = [NSMutableArray arrayWithObject:initialViewController];
        for (NSUInteger i = 1; i < 5; ++i) {
            ETDayTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:DAY_TABLE_VIEW_CONTROLLER];
            vc.index = i;
            vc.day = week.days[i];
            [loadedControllers addObject:vc];
        }
    }];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    ETDayTableViewController *vc = (ETDayTableViewController *)viewController;
    NSUInteger newInteger = vc.index == 0 ? 4 : vc.index - 1;
    return loadedControllers[newInteger];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    ETDayTableViewController *vc = (ETDayTableViewController *)viewController;
    NSUInteger newInteger = vc.index == 4 ? 0 : vc.index + 1;
    return loadedControllers[newInteger];
}

@end
