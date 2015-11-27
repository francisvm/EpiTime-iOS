//
//  ETUIKitTools.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 27/11/2015.
//  Copyright © 2015 EpiTime. All rights reserved.
//

#import "ETUIKitTools.h"
#import "ETConstants.h"

#import "UIImageView+Animation.h"

@implementation ETUIKitTools

// Setup the global appearance
+(void)setupAppearance {
    [[UINavigationBar appearance] setBarTintColor:GREEN];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor] }];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:YES];
}

#pragma mark Loading activity

// Display the custom loading activity as a right bar button
+ (void)startLoadingActivity:(UIViewController *)vc {
    /*
     // While being in a transition, showing the loading activity on the title view
     // of the navigationItem will cause a weird delay of apparition.
     // WARNING: THIS IS AN UGLY TRICK.
     // Wait for 0.5 seconds before showing the animation.
     // FIXME : ASAP
     double delayInSeconds = 0.5;
     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
     dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
     vc.parentViewController.navigationItem.titleView = [UIImageView imageViewWithPath:@"loading_" count:10 duration:1.3 frame:CGRectMake(0, 0, 22, 22)];
     });

     This fails when the stopLoadingActivity method is called under 5 seconds. (like, when the week is empty)
     Until a better fix is found, we're back to the ugly UI.*/
    vc.parentViewController.navigationItem.titleView = [UIImageView imageViewWithPath:@"loading_" count:10 duration:1.3 frame:CGRectMake(0, 0, 22, 22)];
}

// Remove the custom loading activity from the riht bar button
+ (void)stopLoadingActivity:(UIViewController *)vc error:(BOOL)error {
    vc.parentViewController.navigationItem.titleView = nil;
}

// Fade in view
+ (void)fadeInView:(UIView *)view completion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:kFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [view setAlpha:1.0];
                     }
                     completion:completion];
}

// Fade out view
+ (void)fadeOutView:(UIView *)view completion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:kFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [view setAlpha:0.0];
                     }
                     completion:completion];
}

@end
