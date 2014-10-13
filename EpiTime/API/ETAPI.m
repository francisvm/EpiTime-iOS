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
                               if (onCompletion)
                                   onCompletion(recievedData, week);
                           }];
}

+ (void)fetchCurrentWeek:(NSString *)group
       completion:(void (^)(NSDictionary *recievedData, ETWeekItem *week))onCompletion
{
    return [self fetchWeek:-1 ofGroup:group completion:onCompletion];
}


+ (void)setRecievedData:(NSDictionary *)recievedData {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:recievedData forKey:RECIEVED_DATA];
    NSUserDefaults *sharedUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.TodayExtensionSharingDefaults"];
    [sharedUserDefaults setObject:recievedData forKey:RECIEVED_DATA];
    [sharedUserDefaults synchronize];
}
@end
