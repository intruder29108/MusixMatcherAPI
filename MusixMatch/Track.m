//
//  Track.m
//  MusixMatch
//
//  Created by intruder on 19/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Track.h"

@implementation Track

@synthesize trackName = mTrackName;
@synthesize trackId = mTrackId;
@synthesize trackMbId = mTrackMbId;
@synthesize artistName = mArtistName;
@synthesize artistId = mArtistId;
@synthesize lyricsId = mLyricsId;
@synthesize subtitleId = mSubtitleId;
@synthesize albumCoverUrls = mAlbumCoverUrls;
@synthesize albumName  = mAlbumName;
@synthesize hasLyrics = mHasLyrics;
@synthesize hasSubtitle = mHasSubtitle;
@synthesize trackRating = mTrackRating;


- (id) initWithDictionary:(NSDictionary *)dict
{
    if((self = [super init]))
    {
        self.trackName = [dict objectForKey:@"track_name"];
        self.trackId = [dict objectForKey:@"track_id"];
        self.trackMbId = [dict objectForKey:@"track_mbid"];
        self.artistName = [dict objectForKey:@"artist_name"];
        self.artistId = [dict objectForKey:@"artist_id"];
        self.albumName = [dict objectForKey:@"album_name"];
        self.albumCoverUrls = [NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"album_coverart_100x100"],
                               @"small",[dict objectForKey:@"album_coverart_350x350"],@"medium",
                               [dict objectForKey:@"album_coverart_500x500"],@"large" ,nil];
        self.hasLyrics = [[dict objectForKey:@"has_lyrics"]boolValue];
        self.hasSubtitle = [[dict objectForKey:@"has_subtitles"]boolValue];
        self.trackRating = [[dict objectForKey:@"track_rating"]intValue];
        
        if(self.hasLyrics)
            self.lyricsId = [dict objectForKey:@"lyrics_id"];
        else
            self.lyricsId = nil;
        
        if(self.hasSubtitle)
            self.subtitleId = [dict objectForKey:@"subtitle_id"];
        else 
            self.subtitleId = nil;
    }
    return self;
}

- (void) dealloc
{
    [self.trackId release];
    [self.trackMbId release];
    [self.artistId release];
    [self.artistName release];
    [self.albumName release];
    [self.albumCoverUrls release];
    [self.lyricsId release];
    [self.subtitleId release];
    [super dealloc];
}

@end
