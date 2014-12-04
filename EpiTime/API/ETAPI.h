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

+ (void)fetchWeek:(NSInteger)week
                  ofGroup:(NSString *)group
           viewController:(UIViewController *)viewController
               completion:(void (^)(NSDictionary *recievedData, ETWeekItem *week))onCompletion;

+ (void)fetchCurrentWeek:(NSString *)group
          viewController:(UIViewController *)viewController
              completion:(void (^)(NSDictionary *recievedData, ETWeekItem *week))onCompletion;

+ (NSInteger)currentWeek;

+ (ETWeekItem *)cachedWeek:(NSInteger)weekNumber;

@end
