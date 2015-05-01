//
//  InterfaceController.h
//  EpiTime WatchKit Extension
//
//  Created by Francis Visoiu Mistrih on 08/03/2015.
//  Copyright (c) 2015 EpiTime. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController

@property (strong, nonatomic) IBOutlet WKInterfaceTable *tableView;

@end
