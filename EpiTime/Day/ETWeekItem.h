//
//  ETWeekItem.h
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 12/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETWeekItem : NSObject

@property (assign, nonatomic) NSUInteger id;

@property (strong, nonatomic) NSArray *days;

- (instancetype)initWithid:(NSUInteger)id daysArray:(NSArray *)days;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)toDictionary;

- (void)save;

@end
