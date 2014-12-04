//
//  UIImageView+Animation.h
//  Mobeye
//
//  Created by Francis Visoiu Mistrih on 25/08/2014.
//  Copyright (c) 2014 MobEye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Animation)

/**
 * Generate UIImageView based animations from path and frame count
 * @param path path of the animation images. Should be images with name like : x_1.png, x_2.png...x_n.png
 * @param count Number of frames of the animation
 */

+ (instancetype)imageViewWithPath:(NSString *)path count:(NSUInteger)count;

+ (instancetype)imageViewWithPath:(NSString *)path count:(NSUInteger)count duration:(NSTimeInterval)duration;

+ (instancetype)imageViewWithPath:(NSString *)path count:(NSUInteger)count duration:(NSTimeInterval)duration frame:(CGRect)frame;

+ (NSArray *)animationImagesFromPath:(NSString *)path andCount:(NSUInteger)count;

@end
