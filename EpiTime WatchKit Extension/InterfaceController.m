//
//  InterfaceController.m
//  EpiTime WatchKit Extension
//
//  Created by Francis Visoiu Mistrih on 08/03/2015.
//  Copyright (c) 2015 EpiTime. All rights reserved.
//

#import "InterfaceController.h"
#import "ClassRow.h"

@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    NSArray *data = @[
                      @"Mathématiques du signal",
                      @"Construction des compilateurs 1",
                      @"Responsabilité Sociétale des Entreprises",
                      @"Présentation TC3",
                      @"Présentation Projet BDD"
                      ];
    NSArray *room = @[
                      @"Amphi 3",
                      @"Amphi 4",
                      @"Amphi 1",
                      @"Amphi 1",
                      @"Amphi 4"
                      ];
    NSArray *time = @[
                      @"08h30 - 11h30",
                      @"14h00 - 16h00",
                      @"16h00 - 18h00",
                      @"19h00 - 22h00",
                      @"19h00 - 22h00"
                      ];

    [self.tableView setNumberOfRows:data.count withRowType:@"ClassRow"];
    for (NSInteger i = 0; i < self.tableView.numberOfRows; ++i) {
        ClassRow *row = [self.tableView rowControllerAtIndex:i];
        [row.titleLabel setText:data[i]];
        [row.roomLabel setText:room[i]];
        [row.timeLabel setText:time[i]];
    }
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



