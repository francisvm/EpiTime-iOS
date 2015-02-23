//
//  ETConstants.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 12/10/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import "ETConstants.h"

NSString *const kAppName = @"EpiTime";
NSString *const kAppGroup = @"group.epitime.SharedDefaults";
NSString *const kMainStoryboard = @"Main";

NSString *const kDayTableViewController = @"DayTableViewController";
NSString *const kGroupTableViewController = @"GroupTableViewController";

NSString *const kBaseUrlWeeks = @"http://webservices.chronos.epita.net/GetWeeks.aspx?num=%d&week=%d&group=%@&auth=3piko";
NSString *const kBaseUrlGroups = @"http://webservices.chronos.epita.net/GetWeeks.aspx?auth=3piko&getMenu=%@";
NSString *const kGroupsInstructors = @"instructors";
NSString *const kGroupsRooms = @"rooms";
NSString *const kGroupsTrainnees = @"trainnees";

NSString *const kRecievedData = @"kRecievedData";
NSString *const kCurrentGroup = @"kCurrentGroup";
NSString *const kRecievedGroups = @"kRecievedGroups";

NSUInteger const kWeeksPerYear = 52;

NSString *const kCellCourseIdentifierEven = @"CourseIdentifierEven";
NSString *const kCellCourseIdentifierOdd = @"CourseIdentifierOdd";
NSString *const kTodayCellCourseIdentifierEven = @"TodayCourseIdentifierEven";
NSString *const kTodayCellCourseIdentifierOdd = @"TodayCourseIdentifierOdd";
NSString *const kCellGroupIdentifierEven = @"GroupIdentifierEven";
NSString *const kCellGroupIdentifierOdd = @"GroupIdentifierOdd";

float const kFadeDuration = 0.2f;