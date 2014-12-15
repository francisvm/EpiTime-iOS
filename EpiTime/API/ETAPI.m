//
//  ETAPI.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 12/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import "ETAPI.h"
#import "ETTools.h"
#import "ETConstants.h"
#import "ETWeekItem.h"
#import "XMLDictionary.h"

@implementation ETAPI

+ (NSURLSessionDataTask *)fetchWeek:(NSInteger)week
          ofGroup:(NSString *)group
   viewController:(UIViewController *)viewController
       completion:(void (^)(NSDictionary *recievedData, ETWeekItem *week))onCompletion
{
    NSString *urlString = [NSString stringWithFormat:BASE_URL_WEEKS, 1, week, group];
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (viewController)
        [ETTools startLoadingActivity:viewController];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            NSDictionary *recievedData = [NSDictionary dictionaryWithXMLData:data];
                                            ETWeekItem *week = [[ETWeekItem alloc] initWithDictionary:recievedData[@"week"]];
                                            [week save]; // Save to cache
                                            if (onCompletion && recievedData)
                                            {
                                                // NSURSession runs on the background, so we need to update the UI on the main thread
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    onCompletion(recievedData, week);
                                                    if (viewController)
                                                        [ETTools stopLoadingActivity:viewController];
                                                });
                                            }
                                        }];
    [task resume];
    return task;
}

+ (NSURLSessionDataTask *)fetchCurrentWeek:(NSString *)group
          viewController:(UIViewController *)viewController
              completion:(void (^)(NSDictionary *recievedData, ETWeekItem *week))onCompletion
{
    return [self fetchWeek:-1 ofGroup:group viewController:viewController completion:onCompletion];
}

+ (NSInteger)currentWeek {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
    NSDateComponents *firstComponents = [[NSDateComponents alloc] init];
    firstComponents.year = 2014;
    firstComponents.month = 9;
    firstComponents.day = 1;
    NSDate *firstDate = [calendar dateFromComponents:firstComponents];
    firstComponents = [calendar components:NSWeekOfYearCalendarUnit fromDate:firstDate];

    NSInteger currentWeek = [calendar component:NSWeekOfYearCalendarUnit fromDate:[NSDate date]];

    return currentWeek - firstComponents.weekOfYear + 1;
}

+ (ETWeekItem *)cachedWeek:(NSInteger)weekNumber {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *weeks = [userDefaults objectForKey:RECIEVED_DATA];
    ETWeekItem *week = [[ETWeekItem alloc] initWithDictionary:weeks[[NSString stringWithFormat:@"%ld", (long)weekNumber]]];
    return week;
}

@end