//
//  XMLDictionaryParser+Escape.m
//  EpiTime
//
//  Created by Francis Visoiu Mistrih on 14/03/2015.
//  Copyright (c) 2015 EpiTime. All rights reserved.
//

#import "XMLDictionaryParser+Escape.h"

@implementation NSDictionary (XMLDictionaryEscape)

+ (NSDictionary *)dictionaryWithEscapedXMLData:(NSData *)data
{
    // Chronos is sending us a bad XML. Some titles are not marked as CDATA
    // so the XML parser sometimes finds special characters that are not escaped.
    // The only fix I found so far is to get the XML and escape all the special characters
    // which would add garbage to actual characters that should not be scaped.
    // Since our main concern here is the '&' character, I am going to fix this ugly API
    // by renaming all the '&'s into '|' pipes.
    // THANK YOU CHRONOS.
    NSString *badData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; // Get a NSString from the data
    badData = [badData stringByReplacingOccurrencesOfString:@"&" withString:@"|"]; // Replace the special & inside the string
    data = [badData dataUsingEncoding:NSUTF8StringEncoding]; // Convert it back to a data

	return [[[XMLDictionaryParser sharedInstance] copy] dictionaryWithData:data];
}

@end
