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
#import "ETGroupItem.h"

#import "XMLDictionary.h"
#import "XMLDictionaryParser+Escape.h"

@implementation ETAPI

// Fetch a specific week from a group
+ (void)fetchWeek:(NSInteger)week
          ofGroup:(NSString *)group
       completion:(void (^)(NSDictionary *recievedData, ETWeekItem *week))onCompletion
  errorCompletion:(void (^)(NSError *error))onErrorCompletion
{
    NSString *urlString = [NSString stringWithFormat:kBaseUrlWeeks, 1, week, [group stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy]];
    NSURL *url = [NSURL URLWithString:urlString];

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
                             [ETAPI removeCurrentTask]; // Remove the task after finishing
                         }];

    [currentTask resume]; // Start the task
}

#pragma mark Current Task methods

// Current task holder
NSURLSessionDataTask *currentTask = nil;

// Get the current task going on
+ (NSURLSessionDataTask *)currentTask {
    return currentTask;
}

// Remove the current task
+ (void)removeCurrentTask {
    currentTask = nil;
}

// Cancel and remove the current task
+ (void)cancelCurrentTask {
    NSLog(@"canceling");
    [currentTask cancel];
    [self removeCurrentTask];
}

#pragma mark Groups

// Fill the array with the recieved school names
+ (void)fillArrayFromRequestData:(id)recievedData array:(NSMutableArray *)array {
    NSArray *nodes = recievedData[@"node"];
    for (NSDictionary *node in nodes) {
        ETGroupItem *school = [[ETGroupItem alloc] initWithName:node[@"name"]];
        [school fillWithDictionary:node];
        [array addObject:school];
    }
}

// Fill the array with the instructors (special case, no sections)
+ (void)fillArrayFromInstructorsRequestData:(id)recievedData array:(NSMutableArray *)array {
    NSArray *nodes = recievedData[@"node"];
    [array addObject:[[ETGroupItem alloc] initWithName:NSLocalizedString(@"Professors", nil)]];
    ETGroupItem *professors = array[0];
    for (NSDictionary *node in nodes) {
        [professors.groups addObject:node[@"name"]];
    }
}

// Fetch the group list
+ (void)fetchGroupList:(void (^)(NSDictionary *recievedData, NSMutableArray *groups))onCompletion {
    NSString *urlString = [NSString stringWithFormat:kBaseUrlGroups, kGroupsTrainnees];
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

// Fetch the rooms list
+ (void)fetchRoomsList:(void (^)(NSDictionary *recievedData, NSMutableArray *groups))onCompletion {
    NSString *urlString = [NSString stringWithFormat:kBaseUrlGroups, kGroupsRooms];
    NSURL *url = [NSURL URLWithString:urlString];

    NSURLSession *session = [NSURLSession sharedSession];
    currentTask = [session dataTaskWithURL:url
                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                             NSDictionary *recievedData = [NSDictionary dictionaryWithXMLData:data];
                             NSMutableArray *groupsArray = [NSMutableArray array];
                             [self fillArrayFromRequestData:recievedData array:groupsArray];

                             if (onCompletion && recievedData) {
                                 // NSURSession runs on the background, so we need to update the UI on the main thread
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     onCompletion(recievedData, groupsArray);
                                 });
                             }

                             [ETAPI removeCurrentTask];
                         }];
    [currentTask resume];
}

// Fetch the professors list
+ (void)fetchInstructorsList:(void (^)(NSDictionary *recievedData, NSMutableArray *groups))onCompletion {
    NSString *urlString = [NSString stringWithFormat:kBaseUrlGroups, kGroupsInstructors];
    NSURL *url = [NSURL URLWithString:urlString];

    NSURLSession *session = [NSURLSession sharedSession];
    currentTask = [session dataTaskWithURL:url
                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                             NSDictionary *recievedData = [NSDictionary dictionaryWithXMLData:data];
                             NSMutableArray *groupsArray = [NSMutableArray array];
                             [self fillArrayFromInstructorsRequestData:recievedData array:groupsArray];

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