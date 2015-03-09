//
//  ETWeekItem.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 12/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import "ETWeekItem.h"
#import "ETDayItem.h"
#import "ETConstants.h"

@implementation ETWeekItem

- (instancetype)initWithid:(NSUInteger)id daysArray:(NSArray *)days {
    if ((self = [super init])) {
        self.id = id;
        if ([days isKindOfClass:[NSDictionary class]])
            days = @[days];
        self.days = [ETDayItem dumpDaysFromArray:days];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (!dict)
        return nil;
    ETWeekItem *week = [[ETWeekItem alloc] initWithid:[dict[@"id"] integerValue]
                                            daysArray:dict[@"day"]];
    return week;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInteger:self.id] forKey:@"id"];
    NSMutableArray *days = [NSMutableArray array];
    for (ETDayItem *day in self.days) {
        [days addObject:[day toDictionary]];
    }
    [dict setObject:days forKey:@"day"];
    return dict;
}

- (void)save {
    NSDictionary *weekDict = [self toDictionary];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *weeks = [[userDefaults objectForKey:kRecievedData] mutableCopy];
    [weeks setObject:weekDict forKey:[NSString stringWithFormat:@"%lu", (unsigned long)self.id]];
    [userDefaults setObject:weeks forKey:kRecievedData];
    [userDefaults synchronize];
}

@end
