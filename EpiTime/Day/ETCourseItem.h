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

@property (strong, nonatomic) NSString *instructor;

@property (strong, nonatomic) NSArray *rooms;

@property (strong, nonatomic) NSArray *trainees;

- (instancetype)initWithid:(NSUInteger)id
                    title:(NSString *)title
                     hour:(NSUInteger)hour
                 duration:(NSUInteger)duration
               instructor:(NSString *)instructor
                    rooms:(NSArray *)rooms
                 trainees:(NSArray *)trainees;

- (instancetype)initWithDictionary:(NSDictionary *)dicCourse;

+ (NSArray *)dumpCoursesFromArray:(NSArray *)courses;

@end
