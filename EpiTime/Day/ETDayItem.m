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
        self.courses = [ETCourseItem dumpCoursesFromArray:xmlCourses];
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


@end
