//
//  ClassRow.h
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 09/03/2015.
//  Copyright (c) 2015 EpiTime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@interface ClassRow : NSObject

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *roomLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *timeLabel;

@end
