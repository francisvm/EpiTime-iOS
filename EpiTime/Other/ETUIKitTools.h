//
//  ETUIKitTools.h
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 27/11/2015.
//  Copyright © 2015 EpiTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETUIKitTools : NSObject

// Setup the global appearance
+ (void)setupAppearance;

#pragma mark Loading activity

// Display the custom loading activity as a right bar button
+ (void)startLoadingActivity:(UIViewController *)vc;

// Remove the custom loading activity from the riht bar button
+ (void)stopLoadingActivity:(UIViewController *)vc error:(BOOL)error;

#pragma mark View functions

// Fade in a view
+ (void)fadeInView:(UIView *)view completion:(void (^)(BOOL finished))completion;

// Fade out a view
+ (void)fadeOutView:(UIView *)view completion:(void (^)(BOOL finished))completion;

@end
