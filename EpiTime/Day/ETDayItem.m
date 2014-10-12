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
    ETDayItem *day = [[ETDayItem alloc] initWithid:[dict[@"id"] integerValue]
                                        stringDate:dict[@"date"]
                                        xmlCourses:dict[@"course"]];

    return day;
}

@end
