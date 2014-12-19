//
//  ETSchoolItem.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 19/12/2014.
//  Copyright (c) 2014 EpiTime. All rights reserved.
//

#import "ETSchoolItem.h"

@implementation ETSchoolItem

- (instancetype)initWithName:(NSString *)name {
    if ((self = [self init]))
    {
        self.name = name;
        self.groups = [NSMutableArray array];
    }

    return self;
}

- (void)fillArrayFromData:(id)recievedData {
    if ([recievedData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *node in recievedData)
            [self fillArrayFromData:node];
    }
    else {
        NSString *name = recievedData[@"name"];
        NSArray *nodes = recievedData[@"nodes"];
        NSArray *node = recievedData[@"node"];
        if (nodes || node) {
            if (nodes)
                [self fillArrayFromData:nodes];
            if (node)
                [self fillArrayFromData:node];
        }
        else if (name)
            [self.groups addObject:name];
    }
}

- (void)fillWithDictionary:(NSDictionary *)recievedData {
    [self fillArrayFromData:recievedData];
}

@end
