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
#import "ETSchoolItem.h"

#import "XMLDictionary.h"

@implementation ETAPI

static const NSUInteger kWeeksPerYear = 52;

#pragma mark Current Task methods

static NSURLSessionDataTask *currentTask = nil;

+ (NSURLSessionDataTask *)currentTask {
    return currentTask;
}

+ (void)removeCurrentTask {
    currentTask = nil;
}

+ (void)cancelCurrentTask {
    NSLog(@"canceling");
    [currentTask cancel];
    [self removeCurrentTask];
}

#pragma mark Weeks

+ (void)fetchWeek:(NSInteger)week
          ofGroup:(NSString *)group
   viewController:(UIViewController *)viewController
       completion:(void (^)(NSDictionary *recievedData, ETWeekItem *week))onCompletion
       errorCompletion:(void (^)(NSError *error))onErrorCompletion
{
    NSString *urlString = [NSString stringWithFormat:BASE_URL_WEEKS, 1, week, [group stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (viewController)
        [ETTools startLoadingActivity:viewController];
    NSURLSession *session = [NSURLSession sharedSession];
    currentTask = [session dataTaskWithURL:url
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            if (!data || error)
                                            {
                                                if (onErrorCompletion)
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        onErrorCompletion(error);
                                                    });
                                            } else {
                                                NSDictionary *recievedData = [NSDictionary dictionaryWithXMLData:data];
                                                ETWeekItem *week = [[ETWeekItem alloc] initWithDictionary:recievedData[@"week"]];
                                                [week save]; // Save to cache
                                                if (onCompletion && recievedData)
                                                {
                                                    // NSURSession runs on the background, so we need to update the UI on the main thread
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        onCompletion(recievedData, week);
                                                    });
                                                }
                                            }
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                // if cancelled, let the cancel trigger stop the activity loader
                                                if (viewController && ![error.localizedDescription isEqualToString:@"cancelled"])
                                                    [ETTools stopLoadingActivity:viewController error:YES];
                                            });
                                            [ETAPI removeCurrentTask];
                                        }];
    [currentTask resume];
}

+ (void)fetchCurrentWeek:(NSString *)group
          viewController:(UIViewController *)viewController
              completion:(void (^)(NSDictionary *recievedData, ETWeekItem *week))onCompletion
         errorCompletion:(void (^)(NSError *error))onErrorCompletion
{
    [self fetchWeek:-1 ofGroup:group viewController:viewController completion:onCompletion errorCompletion:onErrorCompletion];
}

+ (NSInteger)currentWeek {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
    NSDateComponents *firstComponents = [[NSDateComponents alloc] init];
    firstComponents.year = 2014;
    firstComponents.month = 9;
    firstComponents.day = 1;
    NSDate *firstDate = [calendar dateFromComponents:firstComponents];
    firstComponents = [calendar components:NSYearCalendarUnit | NSWeekOfYearCalendarUnit fromDate:firstDate];

    NSDateComponents *currentDateComponents = [calendar components:NSYearCalendarUnit | NSWeekOfYearCalendarUnit fromDate:[NSDate date]];

    return currentDateComponents.weekOfYear + (currentDateComponents.year - firstComponents.year) * kWeeksPerYear - firstComponents.weekOfYear + 1;
}

+ (ETWeekItem *)cachedWeek:(NSInteger)weekNumber {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *weeks = [userDefaults objectForKey:RECIEVED_DATA];
    ETWeekItem *week = [[ETWeekItem alloc] initWithDictionary:weeks[[NSString stringWithFormat:@"%ld", (long)weekNumber]]];
    return week;
}

+ (NSMutableArray *)cachedGroups {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *groups = [userDefaults objectForKey:RECIEVED_GROUPS];
    return groups;
}

#pragma mark Groups

+ (void)fillArrayFromRequestData:(id)recievedData array:(NSMutableArray *)array {
    NSArray *nodes = recievedData[@"node"];
    for (NSDictionary *node in nodes)
    {
        ETSchoolItem *school = [[ETSchoolItem alloc] initWithName:node[@"name"]];
        [school fillWithDictionary:node];
        [array addObject:school];
    }
}

+ (void)fetchGroupList:(void (^)(NSDictionary *recievedData, NSMutableArray *groups))onCompletion
{
    NSString *urlString = BASE_URL_GROUPS;
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    currentTask = [session dataTaskWithURL:url
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            NSDictionary *recievedData = [NSDictionary dictionaryWithXMLData:data];
                                            NSMutableArray *groupsArray = [NSMutableArray array];
                                            [self fillArrayFromRequestData:recievedData array:groupsArray];

                                            if (onCompletion && recievedData)
                                            {
                                                // NSURSession runs on the background, so we need to update the UI on the main thread
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    onCompletion(recievedData, groupsArray);
                                                });
                                            }
                                            [ETAPI removeCurrentTask];
                                        }];
    [currentTask resume];
}

@end