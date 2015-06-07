//
//  ETDatePickerView.h
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 08/06/2015.
//  Copyright (c) 2015 EpiTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ETDatePickerView;

@protocol ETDatePickerViewProtocol <NSObject>

@required

- (void)datePickerView:(ETDatePickerView *)datePicker didPickDate:(NSDate *)newDate;

@end

@interface ETDatePickerView : UIView

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) id<ETDatePickerViewProtocol> delegate;

- (IBAction)didPressDone:(id)sender;

@end
