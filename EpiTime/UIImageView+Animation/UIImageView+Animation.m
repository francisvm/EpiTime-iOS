//
//  UIImageView+Animation.m
//  Mobeye
//
//  Created by Francis Visoiu Mistrih on 25/08/2014.
//  Copyright (c) 2014 MobEye. All rights reserved.
//

#import "UIImageView+Animation.h"

const NSTimeInterval kDefaultTimeInterval = 1.1;
const float kDefaultWidth = 50.0;

@implementation UIImageView (Animation)

+ (instancetype)imageViewWithPath:(NSString *)path count:(NSUInteger)count {
    return [self imageViewWithPath:path count:count duration:kDefaultTimeInterval];
}

+ (instancetype)imageViewWithPath:(NSString *)path count:(NSUInteger)count duration:(NSTimeInterval)duration {
    return [self imageViewWithPath:path count:count duration:duration frame:CGRectMake(0, 0, kDefaultWidth, kDefaultWidth)];
}

+ (instancetype)imageViewWithPath:(NSString *)path count:(NSUInteger)count duration:(NSTimeInterval)duration frame:(CGRect)frame {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = frame;
    imageView.animationImages = [self animationImagesFromPath:path andCount:count];
    imageView.animationDuration = duration;
    [imageView startAnimating];

    return imageView;
}

+ (NSArray *)animationImagesFromPath:(NSString *)path andCount:(NSUInteger)count {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 1; i <= count; i++)
        [array addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d", path, i]]];

    return array;
}

@end
