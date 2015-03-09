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

#pragma mark Setup

// Setup the global appearance
+(void)setupAppearance {
    [[UINavigationBar appearance] setBarTintColor:GREEN];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor] }];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:YES];
}

// Create an empty dictionary if there is no data
+ (void)setupData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *recieved = [userDefaults objectForKey:kRecievedData];
    if (!recieved.count) {
        NSDictionary *data = [NSDictionary dictionary];
        [userDefaults setObject:data forKey:kRecievedData];
    }
}

// Clear the dictionary
+ (void)clearData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kRecievedData];
    // create a new dictionary to hold the data
    NSDictionary *data = [NSDictionary dictionary];
    [userDefaults setObject:data forKey:kRecievedData];
}

#pragma mark Convert

// NSDate from Chronos representation of minutes
+ (NSDate *)dateFromMinutes:(NSInteger)minutes {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = minutes / 60;
    components.minute = minutes % 60;
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSDateComponents *timeComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];

    return [[NSCalendar currentCalendar] dateFromComponents:timeComponents];
}

// NSString to NSDate using dd/MM/yyyy hh:mm:ss format
+ (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy hh:mm:ss"];
    return [formatter dateFromString:string];
}

// NSDate to NSString using dd/MM/yyyy hh:mm:ss format
+ (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy hh:mm:ss"];
    return [formatter stringFromDate:date];
}

// NSString with format like "14h30" from NSDate
+ (NSString *)timeStringFromDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];

    return [NSString stringWithFormat:@"%2.2luh%2.2lu", (unsigned long)components.hour, (unsigned long)components.minute];
}

// Minutes to HHhMM format
+ (NSString *)timeStringFromMinutes:(NSUInteger)minutes {
    NSUInteger hrs = minutes / 60;
    NSUInteger mins = minutes % 60;

    return [NSString stringWithFormat:@"%2.2luh%2.2lu", (unsigned long)hrs, (unsigned long)mins];
}

// Get only the minutes and hours from NSDate
+ (NSDate *)filterTimeFromDate:(NSDate *)date {
    NSDateComponents *timeComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    return [[NSCalendar currentCalendar] dateFromComponents:timeComponents];
}

// NSDate to NSString using long style format
+ (NSString *)humanDateFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterLongStyle;
    return [formatter stringFromDate:date];
}

// NSDate to week day NSString (Monday, Tuesday, etc.)
+ (NSString *)weekDayFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterFullStyle;
    return [[formatter stringFromDate:date] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"' "]][0];
}

// NSDate to week day NSUInteger (index)
+ (NSUInteger)weekDayIndexFromDate:(NSDate *)date {
    // https://stackoverflow.com/questions/11019761/nsdatecomponents-weekday-doesnt-show-correct-weekday
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2]; // Sunday == 1, Saturday == 7
    NSUInteger adjustedWeekdayOrdinal = [gregorian ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:date];
    return adjustedWeekdayOrdinal - 1;
}

#pragma mark Loading activity

// Display the custom loading activity as a right bar button
+ (void)startLoadingActivity:(UIViewController *)vc {
    // While being in a transition, showing the loading activity on the title view
    // of the navigationItem will cause a weird delay of apparition.
    // WARNING: THIS IS AN UGLY TRICK.
    // Wait for 0.5 seconds before showing the animation.
    // FIXME : ASAP
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        vc.parentViewController.navigationItem.titleView = [UIImageView imageViewWithPath:@"loading_" count:10 duration:1.3 frame:CGRectMake(0, 0, 22, 22)];
    });
}

// Remove the custom loading activity from the riht bar button
+ (void)stopLoadingActivity:(UIViewController *)vc error:(BOOL)error {
    vc.parentViewController.navigationItem.titleView = nil;
}

#pragma mark Group functions

// Get current group NSString
+ (NSString *)currentGroup {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:kCurrentGroup];
}

// Get NSArray of cached groups
+ (NSArray *)cachedGroups {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *groups = [userDefaults objectForKey:kRecievedGroups];
    return groups;
}

#pragma mark Week functions

// Get week index from NSDate
+ (NSInteger)weekIndex:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
    NSDateComponents *firstComponents = [[NSDateComponents alloc] init];
    firstComponents.year = 2014;
    firstComponents.month = 9;
    firstComponents.day = 1;
    NSDate *firstDate = [calendar dateFromComponents:firstComponents];
    firstComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear fromDate:firstDate];

    NSDateComponents *currentDateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear fromDate:date];

    return currentDateComponents.weekOfYear + (currentDateComponents.year - firstComponents.year) * kWeeksPerYear - firstComponents.weekOfYear + 1;
}

// Get current week NSInteger
+ (NSInteger)currentWeek {
    return [self weekIndex:[NSDate date]];
}

// Get an ETWeekItem object from cached dictionary
+ (ETWeekItem *)cachedWeek:(NSInteger)weekNumber {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *weeks = [userDefaults objectForKey:kRecievedData];
    ETWeekItem *week = [[ETWeekItem alloc] initWithDictionary:weeks[[NSString stringWithFormat:@"%ld", (long)weekNumber]]];
    return week;
}

// Get cached ignored data
+ (NSMutableSet *)ignoredData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:kIgnoredData];
    if (!data)
        return [NSMutableSet set];

    NSMutableSet *dataSet = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return dataSet;
}

// Add ignored data to the cache
+ (void)addIgnoredData:(NSString *)title {
    NSMutableSet *dataSet = [ETTools ignoredData];
    [dataSet addObject:title];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dataSet];
    [userDefaults setObject:data forKey:kIgnoredData];
}

// Remove ignored data from the cache
+ (void)removeIgnoredData:(NSUInteger)index {
    NSMutableSet *dataSet = [ETTools ignoredData];
    [dataSet removeObject:dataSet.allObjects[index]];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dataSet];
    [userDefaults setObject:data forKey:kIgnoredData];
}

// Fade in view
+ (void)fadeInView:(UIView *)view completion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:kFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [view setAlpha:1.0];
                     }
                     completion:completion];
}

// Fade out view
+ (void)fadeOutView:(UIView *)view completion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:kFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [view setAlpha:0.0];
                     }
                     completion:completion];
}

@end
