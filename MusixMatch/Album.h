//
//  Album.h
//  MusixMatch
//
//  Created by intruder on 19/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Album : NSObject
{
    NSString *mAlbumId;
    NSString *mArtistId;
    NSString *mArtistName;
    NSString *mAlbumName;
    NSString *mAlbumType;
    NSDictionary *mAlbumCoverURLS;
    int       mAlbumTrackCount;
}

@property (nonatomic,retain) NSDictionary *albumCoverURLS;
@property (nonatomic,retain) NSString *albumId;
@property (nonatomic,retain) NSString *artistId;
@property (nonatomic,retain) NSString *artistName;
@property (nonatomic,retain) NSString *albumName;
@property (nonatomic,retain) NSString *albumType;
@property (nonatomic)        int       albumTrackCount;

- (id) initWithDictionary:(NSDictionary *)dict;


@end
