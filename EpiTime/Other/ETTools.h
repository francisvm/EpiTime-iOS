//
//  ETTools.h
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 11/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ETWeekItem.h"

@interface ETTools : NSObject

#pragma mark Setup

// Setup the global appearance
+ (void)setupAppearance;

// Create an empty dictionary if there is no data
+ (void)setupData;

// Clear the dictionary
+ (void)clearData;

#pragma mark Convert

// NSDate from Chronos representation of minutes
+ (NSDate *)dateFromMinutes:(NSInteger)minutes onDate:(NSDate *)date;

// NSString to NSDate using dd/MM/yyyy hh:mm:ss format
+ (NSDate *)dateFromString:(NSString *)string;

// NSDate to NSString using dd/MM/yyyy hh:mm:ss format
+ (NSString *)stringFromDate:(NSDate *)date;

// NSString with format like "14h30" from NSDate
+ (NSString *)timeStringFromDate:(NSDate *)date;

// Minutes to HHhMM format
+ (NSString *)timeStringFromMinutes:(NSUInteger)minutes;

// Get only the minutes and hours from NSDate
+ (NSDate *)filterTimeFromDate:(NSDate *)date;

// NSDate to NSString using long style format
+ (NSString *)humanDateFromDate:(NSDate *)date;

// NSDate to week day (Monday, Tuesday, etc.)
+ (NSString *)weekDayFromDate:(NSDate *)date;

// NSDate to week day NSUInteger (index)
+ (NSUInteger)weekDayIndexFromDate:(NSDate *)date;

#pragma mark Loading activity

// Display the custom loading activity as a right bar button
+ (void)startLoadingActivity:(UIViewController *)vc;

// Remove the custom loading activity from the riht bar button
+ (void)stopLoadingActivity:(UIViewController *)vc error:(BOOL)error;

#pragma mark Group functions

// Get current group NSString
+ (NSString *)currentGroup;

// Get NSArray of cached groups
+ (NSArray *)cachedGroups;

#pragma mark Week functions

// Get week index from NSDate
+ (NSInteger)weekIndex:(NSDate *)date;

// Get current week NSInteger
+ (NSInteger)currentWeek;

// Get an ETWeekItem object from cached dictionary
+ (ETWeekItem *)cachedWeek:(NSInteger)weekNumber;

#pragma mark Ignored functions

// Get ignored data
+ (NSMutableSet *)ignoredData;

// Add ignored data to the cache
+ (void)addIgnoredData:(NSString *)title;

// Remove ignored data from the cache
+ (void)removeIgnoredData:(NSUInteger)index;

#pragma mark View functions

// Fade in a view
+ (void)fadeInView:(UIView *)view completion:(void (^)(BOOL finished))completion;

// Fade out a view
+ (void)fadeOutView:(UIView *)view completion:(void (^)(BOOL finished))completion;

@end
