//
//  Artist.h
//  MusixMatch
//
//  Created by intruder on 19/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Artist : NSObject
{
    NSString *mArtist_id;
    NSString *mArtist_mbid;
    NSString *mArtist_name;
    NSString *mArtist_country;
    NSString *mArtist_url;
    int mArtist_rating;
}

@property (nonatomic,retain) NSString *artist_id;
@property (nonatomic,retain) NSString *artist_mbid;
@property (nonatomic,retain) NSString *artist_name;
@property (nonatomic,retain) NSString *artist_country;
@property (nonatomic,retain) NSString *artist_url;
@property (nonatomic)        int       artist_rating;

- (id) initWithDictionary:(NSDictionary *)dict;


@end
