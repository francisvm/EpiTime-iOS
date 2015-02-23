//
//  ETGroupItem.h
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 19/12/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETGroupItem : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSMutableArray *groups;

- (instancetype)initWithName:(NSString *)name;

- (void)fillWithDictionary:(NSDictionary *)recievedData;

@end
