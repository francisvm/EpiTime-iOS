//
//  ETUIKitAPI.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 27/11/2015.
//  Copyright © 2015 EpiTime. All rights reserved.
//

#import "ETConstants.h"
#import "ETUIKitTools.h"
#import "ETUIKitAPI.h"
#import "ETAPI.h"
#import "XMLDictionaryParser+Escape.h"

@implementation ETUIKitAPI

#pragma mark Weeks

// Fetch a specific week from a group
+ (void)fetchWeek:(NSInteger)week
          ofGroup:(NSString *)group
   viewController:(UIViewController *)viewController
       completion:(void (^)(NSDictionary *recievedData, ETWeekItem *week))onCompletion
  errorCompletion:(void (^)(NSError *error))onErrorCompletion
{
    NSString *urlString = [NSString stringWithFormat:kBaseUrlWeeks, 1, week, [group stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy]];
    NSURL *url = [NSURL URLWithString:urlString];

    if (viewController) // Start the loading activity
        [ETUIKitTools startLoadingActivity:viewController];

    NSURLSession *session = [NSURLSession sharedSession];
    currentTask = [session dataTaskWithURL:url
                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                             if (!data || error) {
                                 if (onErrorCompletion)
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         onErrorCompletion(error);
                                     });
                             } else {
                                 NSDictionary *recievedData = [NSDictionary dictionaryWithEscapedXMLData:data];
                                 ETWeekItem *week = [[ETWeekItem alloc] initWithDictionary:recievedData[@"week"]];
                                 [week save]; // Save to cache
                                 if (onCompletion && recievedData) {
                                     // NSURSession runs on the background, so we need to update the UI on the main thread
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         onCompletion(recievedData, week);
                                     });
                                 }
                             }
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 // if cancelled, let the cancel trigger stop the activity loader
                                 if (viewController && ![error.localizedDescription isEqualToString:@"cancelled"])
                                     [ETUIKitTools stopLoadingActivity:viewController error:YES];
                             });
                             [ETAPI removeCurrentTask]; // Remove the task after finishing
                         }];

    [currentTask resume]; // Start the task
}

// Fetch the current week from a group
+ (void)fetchCurrentWeek:(NSString *)group
          viewController:(UIViewController *)viewController
              completion:(void (^)(NSDictionary *recievedData, ETWeekItem *week))onCompletion
         errorCompletion:(void (^)(NSError *error))onErrorCompletion
{
    // -1 is the current week for Chronos
    [self fetchWeek:-1 ofGroup:group viewController:viewController completion:onCompletion errorCompletion:onErrorCompletion];
}

@end
