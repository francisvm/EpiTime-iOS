//
//  ETTools.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 11/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import "ETTools.h"

@implementation ETTools

+(void)setupAppearance {
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.110 green:0.502 blue:0.275 alpha:1.000]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UINavigationBar appearance] setTranslucent:YES];
}

+ (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy hh:mm:ss"];
    return [formatter dateFromString:string];
}

+ (NSString *)timeStringFromMinutes:(NSUInteger)minutes {
    NSUInteger hrs = minutes / 60;
    NSUInteger mins = minutes % 60;

    return [NSString stringWithFormat:@"%2.2dh%2.2d", hrs, mins];
}

@end
