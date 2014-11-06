//
//  ETCourseItem.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 12/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import "ETCourseItem.h"

@implementation ETCourseItem

- (instancetype)initWithid:(NSUInteger)id
                     title:(NSString *)title
                      hour:(NSUInteger)hour
                  duration:(NSUInteger)duration
                instructor:(NSString *)instructor
                     rooms:(NSArray *)rooms
                  trainees:(NSArray *)trainees
{
    if ((self = [super init])) {
        self.id = id;
        self.title = title;
        self.hour = hour;
        self.duration = duration;
        self.instructor = instructor;
        if ([rooms isKindOfClass:[NSString class]])
            rooms = [NSArray arrayWithObject:rooms];
        self.rooms = rooms;
        self.trainees = trainees;
    }

    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dicCourse {
    ETCourseItem *course = [[ETCourseItem alloc] initWithid:[dicCourse[@"id"] integerValue]
                                                      title:dicCourse[@"title"]
                                                       hour:[dicCourse[@"hour"] integerValue]
                                                   duration:[dicCourse[@"duration"] integerValue]
                                                 instructor:dicCourse[@"instructor"]
                                                      rooms:dicCourse[@"room"]
                                                   trainees:dicCourse[@"trainee"]];

    return course;
}

+ (NSArray *)dumpCoursesFromArray:(NSArray *)courses {
    NSMutableArray *dumpedCourses = [NSMutableArray array];

    for (NSDictionary *dicCourse in courses) {
        [dumpedCourses addObject:[[ETCourseItem alloc] initWithDictionary:dicCourse]];
    }

    return dumpedCourses;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInteger:self.id] forKey:@"id"];
    [dict setObject:self.title forKey:@"title"];
    [dict setObject:[NSNumber numberWithInteger:self.hour] forKey:@"hour"];
    [dict setObject:[NSNumber numberWithInteger:self.duration] forKey:@"duration"];
    if (self.instructor)
        [dict setObject:self.instructor forKey:@"instructor"];
    [dict setObject:self.rooms forKey:@"room"];
    [dict setObject:self.trainees forKey:@"trainee"];

    return dict;
}

@end
