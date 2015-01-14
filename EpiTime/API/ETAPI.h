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

+ (NSURLSessionDataTask *)currentTask;

+ (void)removeCurrentTask;

+ (void)cancelCurrentTask;

#pragma mark Week Schedule

+ (void)fetchWeek:(NSInteger)week
                  ofGroup:(NSString *)group
           viewController:(UIViewController *)viewController
               completion:(void (^)(NSDictionary *recievedData, ETWeekItem *week))onCompletion
          errorCompletion:(void (^)(NSError *error))onErrorCompletion;

+ (void)fetchCurrentWeek:(NSString *)group
          viewController:(UIViewController *)viewController
              completion:(void (^)(NSDictionary *recievedData, ETWeekItem *week))onCompletion
         errorCompletion:(void (^)(NSError *error))onErrorCompletion;

+ (NSInteger)currentWeek;

+ (ETWeekItem *)cachedWeek:(NSInteger)weekNumber;

#pragma mark Groups

+ (void)fetchGroupList:(void (^)(NSDictionary *recievedData, NSMutableArray *groups))onCompletion;

@end
