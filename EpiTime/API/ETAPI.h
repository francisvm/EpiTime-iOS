//
//  ETAPI.h
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 12/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ETWeekItem.h"

@interface ETAPI : NSObject

// Current task holder
extern NSURLSessionDataTask *currentTask;

// Fetch a specific week from a group
+ (void)fetchWeek:(NSInteger)week
          ofGroup:(NSString *)group
       completion:(void (^)(NSDictionary *recievedData, ETWeekItem *week))onCompletion
  errorCompletion:(void (^)(NSError *error))onErrorCompletion;

// Get the current task going on
+ (NSURLSessionDataTask *)currentTask;

// Remove the current task
+ (void)removeCurrentTask;

// Cancel and remove the current task
+ (void)cancelCurrentTask;

#pragma mark Groups

// Fetch the group list
+ (void)fetchGroupList:(void (^)(NSDictionary *recievedData, NSMutableArray *groups))onCompletion;

// Fetch the rooms list
+ (void)fetchRoomsList:(void (^)(NSDictionary *recievedData, NSMutableArray *groups))onCompletion;

// Fetch the professors list
+ (void)fetchInstructorsList:(void (^)(NSDictionary *recievedData, NSMutableArray *groups))onCompletion;

@end
