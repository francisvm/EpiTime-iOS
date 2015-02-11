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
               instructors:(NSArray *)instructors
                     rooms:(NSArray *)rooms
                  trainees:(NSArray *)trainees
{
    if ((self = [super init])) {
        self.id = id;
        self.title = title;
        self.hour = hour;
        self.duration = duration;

        if ([instructors isKindOfClass:[NSString class]]) // check for XMLDictionary fail
            instructors = [NSArray arrayWithObject:instructors];
        self.instructors = instructors;

        if ([rooms isKindOfClass:[NSString class]]) // check for XMLDictionary fail
            rooms = [NSArray arrayWithObject:rooms];
        self.rooms = rooms;

        if ([trainees isKindOfClass:[NSString class]]) // check for XMLDictionary fail
            trainees = [NSArray arrayWithObject:trainees];
        self.trainees = trainees;
    }

    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dicCourse {
    ETCourseItem *course = [[ETCourseItem alloc] initWithid:[dicCourse[@"id"] integerValue]
                                                      title:dicCourse[@"title"]
                                                       hour:[dicCourse[@"hour"] integerValue]
                                                   duration:[dicCourse[@"duration"] integerValue]
                                                instructors:dicCourse[@"instructor"]
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
    if (self.instructors)
        [dict setObject:self.instructors forKey:@"instructor"];
    if (self.rooms)
        [dict setObject:self.rooms forKey:@"room"];
    if (self.trainees)
        [dict setObject:self.trainees forKey:@"trainee"];

    return dict;
}

- (BOOL)isEqual:(id)object {
    if (self == object)
        return YES;

    if (![object isKindOfClass:[ETCourseItem class]])
        return NO; // trust the superclass

    return [self isEqualToCourseItem:object];
}

- (BOOL)isEqualToCourseItem:(ETCourseItem *)course {
    if (!course)
        return NO;

    if (self.rooms.count != course.rooms.count
        || self.trainees.count != course.trainees.count)
        return NO;

    // check for rooms equality
    for (NSInteger i = 0; i < self.rooms.count; ++i) {
        if (![self.rooms[i] isEqualToString:course.rooms[i]])
            return NO;
    }

    // check for trainees equality
    for (NSInteger i = 0; i < self.trainees.count; ++i) {
        if (![self.trainees[i] isEqualToString:course.trainees[i]])
            return NO;
    }

    for (NSInteger i = 0; i < self.instructors.count; ++i) {
        if (![self.instructors[i] isEqualToString:course.instructors[i]])
            return NO;
    }

    // check for instructors equality

    return self.id == course.id
           && [self.title isEqualToString:course.title]
           && self.hour == course.hour
           && self.duration == course.duration;
}

@end
