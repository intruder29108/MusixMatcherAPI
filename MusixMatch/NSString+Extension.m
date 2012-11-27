//
//  NSString+Extension.m
//  MusixMatch
//
//  Created by intruder on 19/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

// Encode URLs
- (NSString *)URLEncoded
{
	NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":#[]@!$’()*+,;="), kCFStringEncodingUTF8);
	return [result autorelease];
}

@end
