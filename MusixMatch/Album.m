//
//  Album.m
//  MusixMatch
//
//  Created by intruder on 19/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Album.h"

@implementation Album

@synthesize albumCoverURLS = mAlbumCoverURLS;;
@synthesize albumId = mAlbumId;
@synthesize albumName = mAlbumName;
@synthesize artistId = mArtistId;
@synthesize artistName = mArtistName;
@synthesize albumTrackCount = mAlbumTrackCount;
@synthesize albumType = mAlbumType;


- (id) initWithDictionary:(NSDictionary *)dict
{
    if((self = [super init]))
    {
        self.albumId = [dict objectForKey:@"album_id"];
        self.albumName = [dict objectForKey:@"album_name"];
        self.artistId = [dict objectForKey:@"artist_id"];
        self.artistName = [dict objectForKey:@"artist_name"];
        self.albumTrackCount = [[dict objectForKey:@"album_track_count"]intValue];
        self.albumType = [dict objectForKey:@"album_release_type"]; 
        self.albumCoverURLS = [NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"album_coverart_100x100"],
                               @"small",[dict objectForKey:@"album_coverart_350x350"],@"medium",
                               [dict objectForKey:@"album_coverart_500x500"],@"large" ,nil];
        
    }
    return self;
}

- (void) dealloc
{
    [self.albumCoverURLS release];
    [self.albumId release];
    [self.albumName release];
    [self.artistId release];
    [self.artistName release];
    [self.albumType release];
    [super dealloc];
}

@end
