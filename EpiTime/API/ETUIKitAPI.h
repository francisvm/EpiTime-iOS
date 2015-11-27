//
//  ETUIKitAPI.h
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 27/11/2015.
//  Copyright © 2015 EpiTime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ETWeekItem.h"

@interface ETUIKitAPI : NSObject

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

@end
