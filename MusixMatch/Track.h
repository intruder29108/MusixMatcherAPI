//
//  Track.h
//  MusixMatch
//
//  Created by intruder on 19/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Track : NSObject
{
    NSString *mTrackName;
    NSString *mTrackId;
    NSString *mTrackMbId;
    NSString *mAlbumName;
    NSString *mArtistId;
    NSString *mArtistName;
    NSString *mLyricsId;
    NSString *mSubtitleId;
    NSDictionary *mAlbumCoverUrls;
    BOOL mHasLyrics;
    BOOL mHasSubtitle;
    int mTrackRating;
}

@property (nonatomic,retain) NSString * trackName;
@property (nonatomic,retain) NSString * trackId;
@property (nonatomic,retain) NSString * trackMbId;
@property (nonatomic,retain) NSString * albumName;
@property (nonatomic,retain) NSString * artistId;
@property (nonatomic,retain) NSString * artistName;
@property (nonatomic,retain) NSString * lyricsId;
@property (nonatomic,retain) NSString * subtitleId;
@property (nonatomic,retain) NSDictionary *albumCoverUrls;
@property (nonatomic)        BOOL       hasLyrics;
@property (nonatomic)        BOOL       hasSubtitle;
@property (nonatomic)        int        trackRating;

- (id) initWithDictionary:(NSDictionary *)dict;


@end
