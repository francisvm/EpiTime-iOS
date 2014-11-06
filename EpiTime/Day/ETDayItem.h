//
//  ETDayItem.h
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 12/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETDayItem : NSObject

@property (assign, nonatomic) NSUInteger id;

@property (strong, nonatomic) NSDate *date;

@property (strong, nonatomic) NSArray *courses;

- (instancetype)initWithid:(NSUInteger)id stringDate:(NSString *)date xmlCourses:(NSArray *)xmlCourses;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (NSArray *)dumpDaysFromArray:(NSArray *)days;

- (NSDictionary *)toDictionary;

@end
