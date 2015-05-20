//
//  GlanceController.m
//  EpiTime WatchKit Extension
//
//  Created by Francis Visoiu Mistrih on 01/05/2015.
//  Copyright (c) 2015 EpiTime. All rights reserved.
//

#import "GlanceController.h"
#import "ClassRow.h"
#import "ETAPI.h"
#import "ETTools.h"
#import "ETDayItem.h"
#import "ETCourseItem.h"

@interface GlanceController()

@end


@implementation GlanceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    [self.titleLabel setText:@"Loading..."];
    [self.timeLabel setText:@" "];
    [self.roomLabel setText:@" "];
    [self.instructorLabel setText:@" "];
    [self.traineesLabel setText:@" "];
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];

    [self fetch];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)fetch {
    [ETAPI fetchWeek:[ETTools weekIndex:[NSDate date]] ofGroup:@"ING1/GRA2" viewController:nil
        completion:^(NSDictionary *recievedData, ETWeekItem *week) {
            ETDayItem *day = week.days[[ETTools weekDayIndexFromDate:[NSDate date]]];
            ETCourseItem *finalCourse = day.courses[0];
            for (ETCourseItem *course in day.courses) {
                NSTimeInterval startInterval = [course.startingDate timeIntervalSinceNow];
                if (startInterval > 0) {
                    finalCourse = course;
                    break;
                }
            }

            [self.titleLabel setText:finalCourse.title];
            [self.roomLabel setText:finalCourse.rooms[0]];
            [self.instructorLabel setText:[finalCourse.instructors componentsJoinedByString:@" "]];
            [self.timeLabel setText:[NSString stringWithFormat:@"%@ - %@", [ETTools timeStringFromDate:finalCourse.startingDate], [ETTools timeStringFromDate:finalCourse.endingDate]]];
            [self.traineesLabel setText:[finalCourse.trainees componentsJoinedByString:@" "]];
        }
        errorCompletion:^(NSError *error) {

        }
     ];
}

@end
