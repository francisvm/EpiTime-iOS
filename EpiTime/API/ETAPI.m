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

+ (void)fetchWeek:(NSInteger)week
          ofGroup:(NSString *)group
       completion:(void (^)(NSDictionary *recievedData, ETWeekItem *week))onCompletion
{
    NSString *urlString = [NSString stringWithFormat:BASE_URL_WEEKS, 1, week, group];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSDictionary *recievedData = [NSDictionary dictionaryWithXMLData:data];
                               ETWeekItem *week = [[ETWeekItem alloc] initWithDictionary:recievedData[@"week"]];
                               [week save]; // Save to cache
                               if (onCompletion && recievedData)
                                   onCompletion(recievedData, week);
                           }];
}

+ (void)fetchCurrentWeek:(NSString *)group
       completion:(void (^)(NSDictionary *recievedData, ETWeekItem *week))onCompletion
{
    return [self fetchWeek:-1 ofGroup:group completion:onCompletion];
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
