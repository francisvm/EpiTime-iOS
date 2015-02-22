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

// Get the current task going on
+ (NSURLSessionDataTask *)currentTask;

// Remove the current task
+ (void)removeCurrentTask;

// Cancel and remove the current task
+ (void)cancelCurrentTask;

#pragma mark Week Schedule

// Fetch a specific week from a group
+ (void)fetchWeek:(NSInteger)week
                  ofGroup:(NSString *)group
           viewController:(UIViewController *)viewController
               completion:(void (^)(NSDictionary *recievedData, ETWeekItem *week))onCompletion
          errorCompletion:(void (^)(NSError *error))onErrorCompletion;

// Fetch the current week from a group
+ (void)fetchCurrentWeek:(NSString *)group
          viewController:(UIViewController *)viewController
              completion:(void (^)(NSDictionary *recievedData, ETWeekItem *week))onCompletion
         errorCompletion:(void (^)(NSError *error))onErrorCompletion;

#pragma mark Groups

// Fetch the group list
+ (void)fetchGroupList:(void (^)(NSDictionary *recievedData, NSMutableArray *groups))onCompletion;

@end
