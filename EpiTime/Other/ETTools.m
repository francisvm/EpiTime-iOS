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

@end
