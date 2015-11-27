//
//  InterfaceController.m
//  EpiTime WatchKit Extension
//
//  Created by Francis Visoiu Mistrih on 08/03/2015.
//  Copyright (c) 2015 EpiTime. All rights reserved.
//

#import "InterfaceController.h"
#import "ClassRow.h"
#import "ETAPI.h"
#import "ETDayItem.h"
#import "ETCourseItem.h"
#import "ETTools.h"

@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user

    // FIXME : Use some cache
    [self fetch]; // Fetch data of the week

    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)fetch {
    [ETAPI fetchWeek:[ETTools weekIndex:[NSDate date]] ofGroup:@"ING1/GRA2"
        completion:^(NSDictionary *recievedData, ETWeekItem *week) {
            ETDayItem *day = week.days[[ETTools weekDayIndexFromDate:[NSDate date]]];
            [self.tableView setNumberOfRows:day.courses.count withRowType:@"ClassRow"];
            for (NSInteger i = 0; i < self.tableView.numberOfRows; ++i) {
                ClassRow *row = [self.tableView rowControllerAtIndex:i];
                ETCourseItem *course = day.courses[i];
                [row.titleLabel setText:course.title];
                [row.roomLabel setText:course.rooms[0]]; // Display only the first room
                [row.timeLabel setText:[NSString stringWithFormat:@"%@ - %@", [ETTools timeStringFromDate:course.startingDate], [ETTools timeStringFromDate:course.endingDate]]];
            }
        }
        errorCompletion:^(NSError *error) {

        }
     ];
}

@end



