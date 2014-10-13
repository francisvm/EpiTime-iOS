//
//  ETWeekItem.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 12/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import "ETWeekItem.h"
#import "ETDayItem.h"

@implementation ETWeekItem

- (instancetype)initWithid:(NSUInteger)id daysArray:(NSArray *)days {
    if ((self = [super init])) {
        self.id = id;
        self.days = [ETDayItem dumpDaysFromArray:days];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    ETWeekItem *week = [[ETWeekItem alloc] initWithid:[dict[@"id"] integerValue]
                                            daysArray:dict[@"day"]];
    return week;
}

@end
