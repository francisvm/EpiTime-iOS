//
//  ETTools.h
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 11/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETTools : NSObject

+ (void)setupAppearance;

+ (NSDate *)dateFromString:(NSString *)string;

+ (NSString *)timeStringFromMinutes:(NSUInteger)minutes;

+ (NSString *)humanDateFromDate:(NSDate *)date;

+ (NSString *)weekDayFromDate:(NSDate *)date;

@end
