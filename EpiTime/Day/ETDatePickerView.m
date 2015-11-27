//
//  ETDatePickerView.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 08/06/2015.
//  Copyright (c) 2015 EpiTime. All rights reserved.
//

#import "ETDatePickerView.h"
#import "ETUIKitTools.h"

@implementation ETDatePickerView

- (instancetype)init {
    NSArray *bundles = [[NSBundle mainBundle] loadNibNamed:@"ETDatePickerView"
                                                     owner:self
                                                   options:nil];
    ETDatePickerView *view = bundles[0];
    if ((self = view))
    {
        // Initialization is done in the XIB. Add more logic here. (Maybe the size?)
        self.alpha = 0.0f;
        [ETUIKitTools fadeInView:self completion:nil];
    }
    return self;
}

- (IBAction)didPressDone:(id)sender {
    [self.delegate datePickerView:self didPickDate:self.datePicker.date];
}
@end
