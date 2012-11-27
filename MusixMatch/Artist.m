//
//  Artist.m
//  MusixMatch
//
//  Created by intruder on 19/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Artist.h"

@implementation Artist

@synthesize artist_id = mArtist_id;
@synthesize artist_country = mArtist_country;
@synthesize artist_mbid = mArtist_mbid;
@synthesize artist_name = mArtist_name;
@synthesize artist_rating = mArtist_rating;
@synthesize artist_url = mArtist_url;


- (id) initWithDictionary:(NSDictionary *)dict
{
    if((self = [super init]))
    {
        self.artist_id = [dict objectForKey:@"artist_id"];
        self.artist_mbid = [dict objectForKey:@"artist_mbid"];
        self.artist_name = [dict objectForKey:@"artist_name"];
        self.artist_country = [dict objectForKey:@"artist_country"];
        self.artist_url = [dict objectForKey:@"artist_url"];
        self.artist_rating = [[dict objectForKey:@"artist_rating"]intValue];
    }
    return  self;
}

- (void) dealloc
{
    [self.artist_url release];
    [self.artist_country release];
    [self.artist_id release];
    [self.artist_mbid release];
    [self.artist_name release];
    [super dealloc];
}

@end
