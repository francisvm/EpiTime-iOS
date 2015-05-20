//
//  GlanceController.h
//  EpiTime WatchKit Extension
//
//  Created by Francis Visoiu Mistrih on 01/05/2015.
//  Copyright (c) 2015 EpiTime. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface GlanceController : WKInterfaceController

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *timeLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *roomLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *instructorLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *traineesLabel;

@end
