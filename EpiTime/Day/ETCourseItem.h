//
//  ETCourseItem.h
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 12/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETCourseItem : NSObject

@property (assign, nonatomic) NSUInteger id;

@property (strong, nonatomic) NSString *title;

@property (assign, nonatomic) NSUInteger hour;

@property (assign, nonatomic) NSUInteger duration;

@property (strong, nonatomic) NSArray *instructors;

@property (strong, nonatomic) NSArray *rooms;

@property (strong, nonatomic) NSArray *trainees;

@property (strong, nonatomic) NSDate *startingDate;

@property (strong, nonatomic) NSDate *endingDate;

@property (assign, atomic) BOOL isIgnored;

- (instancetype)initWithid:(NSUInteger)id
                     title:(NSString *)title
                      hour:(NSUInteger)hour
                  duration:(NSUInteger)duration
                instructors:(NSArray *)instructors
                     rooms:(NSArray *)rooms
                  trainees:(NSArray *)trainees
                    onDate:(NSDate *)date;

- (instancetype)initWithDictionary:(NSDictionary *)dicCourse onDate:(NSDate *)date;

+ (NSArray *)dumpCoursesFromArray:(NSArray *)courses onDate:(NSDate *)date;

- (NSDictionary *)toDictionary;

- (BOOL)isEqualToCourseItem:(ETCourseItem *)course;

@end
