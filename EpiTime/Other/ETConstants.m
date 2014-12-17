//
//  ETConstants.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 12/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import "ETConstants.h"

NSString *const APP_NAME = @"EpiTime";

NSString *const DAY_TABLE_VIEW_CONTROLLER = @"DayTableViewController";

NSString *const BASE_URL_WEEKS = @"http://webservices.chronos.epita.net/GetWeeks.aspx?num=%d&week=%d&group=%@&auth=3piko";

NSString *const BASE_URL_GROUPS = @"http://webservices.chronos.epita.net/GetWeeks.aspx?auth=3piko&getMenu=trainnees";

NSString *const RECIEVED_DATA = @"RECIEVED_DATA";
NSString *const CURRENT_GROUP = @"CURRENT_GROUP";
NSString *const RECIEVED_GROUPS = @"RECIEVED_GROUPS";

NSUInteger const WEEKS_IN_A_YEAR = 53;