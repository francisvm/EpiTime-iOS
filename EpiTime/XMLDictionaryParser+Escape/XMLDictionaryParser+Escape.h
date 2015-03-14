//
//  XMLDictionaryParser+Escape.h
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 14/03/2015.
//  Copyright (c) 2015 EpiTime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMLDictionary.h>

@interface NSDictionary (XMLDictionaryEscape)

+ (NSDictionary *)dictionaryWithEscapedXMLData:(NSData *)data;

@end
