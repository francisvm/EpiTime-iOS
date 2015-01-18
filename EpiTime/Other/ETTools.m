//
//  ETTools.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 11/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import "ETTools.h"
#import "ETConstants.h"

#import "UIImageView+Animation.h"

@implementation ETTools

+(void)setupAppearance {
    [[UINavigationBar appearance] setBarTintColor:GREEN];
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

+ (void)clearData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:RECIEVED_DATA];
    NSDictionary *data = [NSDictionary dictionary];
    [userDefaults setObject:data forKey:RECIEVED_DATA];
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

+ (void)startLoadingActivity:(UIViewController *)vc {
    UIBarButtonItem *refreshing = [[UIBarButtonItem alloc] initWithCustomView:[UIImageView imageViewWithPath:@"loading_" count:10 duration:1.3 frame:CGRectMake(0, 0, 22, 22)]];
    vc.parentViewController.navigationItem.rightBarButtonItems = @[refreshing];
}

+ (void)stopLoadingActivity:(UIViewController *)vc error:(BOOL)error {
    vc.parentViewController.navigationItem.rightBarButtonItems = @[];
}

+ (NSString *)currentGroup {
    return [[NSUserDefaults standardUserDefaults] valueForKey:CURRENT_GROUP];
}

+ (void)changeGroupWithCurrentViewController:(UIViewController *)vc {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    [vc presentViewController:[storyboard instantiateViewControllerWithIdentifier:GROUP_TABLE_VIEW_CONTROLLER] animated:YES completion:nil];
}

@end
