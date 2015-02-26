//
//  ETDayItem.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 12/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import "ETDayItem.h"
#import "ETTools.h"
#import "ETCourseItem.h"

@implementation ETDayItem

- (instancetype)initWithid:(NSUInteger)id stringDate:(NSString *)date xmlCourses:(NSArray *)xmlCourses
{
    if ((self = [super init]))
    {
        self.id = id;
        self.date = [ETTools dateFromString:date];
        self.courses = [[ETCourseItem dumpCoursesFromArray:xmlCourses] mutableCopy];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    NSArray *courses = dict[@"course"];
    if ([courses isKindOfClass:[NSDictionary class]])
        courses = [NSArray arrayWithObject:courses];

    ETDayItem *day = [[ETDayItem alloc] initWithid:[dict[@"id"] integerValue]
                                        stringDate:dict[@"date"]
                                        xmlCourses:courses];

    return day;
}

+ (NSArray *)dumpDaysFromArray:(NSArray *)days {
    NSMutableArray *dumpedDays = [NSMutableArray array];

    for (NSDictionary *dicDay in days) {
        [dumpedDays addObject:[[ETDayItem alloc] initWithDictionary:dicDay]];
    }

    return dumpedDays;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInteger:self.id] forKey:@"id"];
    [dict setObject:[ETTools stringFromDate:self.date] forKey:@"date"];
    NSMutableArray *courses = [NSMutableArray array];
    for (ETCourseItem *course in self.courses) {
        [courses addObject:[course toDictionary]];
    }
    [dict setObject:courses forKey:@"course"];
    return dict;
}

- (BOOL)isEqual:(id)object {
    if (self == object)
        return YES;

    if (![object isKindOfClass:[ETDayItem class]])
        return NO; // trust the superclass

    return [self isEqualToDayItem:object];
}

- (BOOL)isEqualToDayItem:(ETDayItem *)day {
    if (!day)
        return NO;

    if (self.courses.count != day.courses.count)
        return NO;

    // check for equality of every course
    for (NSUInteger i = 0; i < day.courses.count; ++i) {
        ETCourseItem *myCourse = self.courses[i];
        ETCourseItem *otherCourse = day.courses[i];
        if (![myCourse isEqualToCourseItem:otherCourse])
            return NO;
    }

    return self.id == day.id
           && [self.date isEqualToDate:day.date];
}

@end
