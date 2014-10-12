//
//  ETClassTableViewCell.h
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 12/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETClassTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *startingLabel;

@property (strong, nonatomic) IBOutlet UILabel *endingLabel;

@property (strong, nonatomic) IBOutlet UILabel *roomLabel;

@end
