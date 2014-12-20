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

+ (void)setupData;

+ (void)clearData;

+ (NSDate *)dateFromString:(NSString *)string;

+ (NSString *)stringFromDate:(NSDate *)date;

+ (NSString *)timeStringFromMinutes:(NSUInteger)minutes;

+ (NSString *)humanDateFromDate:(NSDate *)date;

+ (NSString *)weekDayFromDate:(NSDate *)date;

+ (NSUInteger)weekDayIndexFromDate:(NSDate *)date;

+ (void)startLoadingActivity:(UIViewController *)vc;

+ (void)stopLoadingActivity:(UIViewController *)vc;

+ (NSString *)currentGroup;

+ (void)changeGroupWithCurrentViewController:(UIViewController *)vc;

@end
