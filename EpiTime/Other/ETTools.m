//
//  ETTools.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 11/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import "ETTools.h"
#import "ETConstants.h"

@implementation ETTools

+(void)setupAppearance {
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.110 green:0.502 blue:0.275 alpha:1.000]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UINavigationBar appearance] setTranslucent:YES];
}

+ (void)setupData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *recieved = [userDefaults objectForKey:RECIEVED_DATA];
    if (!recieved.count)
    {
        NSDictionary *data = [NSDictionary dictionary];
        [userDefaults setObject:data forKey:RECIEVED_DATA];
    }
}

+ (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy hh:mm:ss"];
    return [formatter dateFromString:string];
}

+ (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy hh:mm:ss"];
    return [formatter stringFromDate:date];
}

+ (NSString *)timeStringFromMinutes:(NSUInteger)minutes {
    NSUInteger hrs = minutes / 60;
    NSUInteger mins = minutes % 60;

    return [NSString stringWithFormat:@"%2.2luh%2.2lu", (unsigned long)hrs, (unsigned long)mins];
}

+ (NSString *)humanDateFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterLongStyle;
    return [formatter stringFromDate:date];
}

+ (NSString *)weekDayFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterFullStyle;
    return [[formatter stringFromDate:date] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"' "]][0];
}

+ (NSUInteger)weekDayIndexFromDate:(NSDate *)date {
    // https://stackoverflow.com/questions/11019761/nsdatecomponents-weekday-doesnt-show-correct-weekday
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2]; // Sunday == 1, Saturday == 7
    NSUInteger adjustedWeekdayOrdinal = [gregorian ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:date];
    return adjustedWeekdayOrdinal - 1;
}

@end
