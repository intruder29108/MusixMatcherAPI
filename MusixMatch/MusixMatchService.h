//
//  MusixMatchService.h
//  MusixMatch
//
//  Created by intruder on 19/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Important set you api key
#define APIKEY                  @""
#define APIBASEURL              @"http://api.musixmatch.com/ws/1.1/"
#define APIFORMAT               @"json"

// Method names
#define TRACK_GET               @"track.get"
#define TRACK_SEARCH            @"track.search"
#define TRENDING_ARTIST         @"chart.artists.get"
#define TRENDING_TRACKS         @"chart.tracks.get"
#define GET_LYRICS              @"track.lyrics.get"
#define GET_LYRICS_SNIPPET      @"track.snippet.get"
#define GET_SUBTITLE            @"track.subtitle.get"
#define GET_ARTIST              @"artist.get"
#define SEARCH_ARTIST           @"artist.search"
#define GET_ALUBMS_BY_ARTIST    @"artist.albums.get"
#define GET_ALBUM               @"album.get"
#define GET_ALBUM_TRACKS        @"album.tracks.get"
#define MATCHER_GET_LYRICS      @"matcher.lyrics.get"
#define MATCHER_GET_TRACK       @"matcher.track.get"


// Forwad reference the Track Album and Artist Classes
@class Album,Track,Artist;

@interface MusixMatchService : NSObject

// Get a singleton instance
+ (MusixMatchService*)sharedInstance;

/* Porting every function using GCD */

// Track search
- (void)searchTrackWithName:(NSString *)query numResults:(NSUInteger)numResults accuracy:(CGFloat)factor withCompletionBlock:(void (^)(NSArray *tracks))completionBlock;
- (void)getTrackWithId:(NSString *)track_id withCompletionBlock:(void (^)(Track *track))completionBlock;

// Lyrics and subtitle search
- (void)getSubtitleForTrackWithId:(NSString *)track_id withCompletionBlock:(void (^)(NSString *lyrics))completionBlock;
- (void)getLyricsForTrackWithId:(NSString *)track_id withCompletionBlock:(void (^)(NSString *subtitles))completionBlock;
- (void)getLyricsSnippetWithId:(NSString *)track_id withCompletionBlock:(void (^)(NSString *lyric_snippets))completionBlock;

// Trending Searchs
- (void)getTrendingArtistsWithNumberOfResults:(NSUInteger)numResults andCompletionBlock:(void (^)(NSArray *artists))completionBlock;
- (void)getTrendingTracksWithNumberOfResults:(NSUInteger)numResults andCompletionBlock:(void (^)(NSArray *albums))completionBlock;


// Artist Seach and info
- (void)getArtistWithId:(NSString *)artist_id withCompletionBlock:(void (^)(Artist *artist))completionBlock;
- (void)getArtistsWithName:(NSString *)artist_name numResults:(NSUInteger)numResults withCompletionBlock:(void (^)(NSArray *artists))completionBlock;
- (void)searchAlbumsByArtistWithId:(NSString *)artist_id numResults:(NSUInteger)numResults 
                    withCompletionBlock:(void (^)(NSArray *albums))completionBlock;

// Album related functions
- (void)getAlbumWithId:(NSString *)album_id withCompletionBlock:(void (^)(Album *album))completionBlock;
- (void)getTracksFromAlbumWithId:(NSString *)album_id withCompletionBlock:(void (^)(NSArray *tracks))completionBlock;


// Utility methods
- (NSDictionary *)performQuery:(NSString *)urlStr;
- (NSString*)baseUrl:(NSString*)method;


// Matcher calls to get lyrics based on artist and song titles

/*
    q_track             - Search for track with name
    q_artist            - Search for artist with name
 
*/
- (void) getLyricsForTrackWithParameters:(NSDictionary *)params withCompletionBlock:(void (^)(NSString *lyrics))completionBlock;




// Matcher calls to get tracks based on the artist and song title and other parameters
/*
    q_track             - The song title
    q_artist            - The song artist
    q_album             - The song album
    f_has_lyrics        - Take songs with lyics
    f_has_subtitle      - Take songs with subtitles
 
*/
- (void) searchTrackUsingMatcherFunctionWithParameters:(NSDictionary *)params withCompletionBlock:(void (^)(Track *track))completionBlock;






// Advanced Search With all parameters
/*
    q                   - Search within the track titles,artis,lyrics (intensive search)
    q_artist            - Search for artist
    q_title             - Search for titles
    q_album             - Search for albums
    q_lyrics            - Any word in the lyrics
    page                - Define the page number of paginated results
    page_size           - Define the page size for paginated results. Range is 1 to 100
    f_has_lyrics        - When set, filter only contents with lyrics
    f_artist_id         - When set, filter by the artist id
    f_artist_mbid       - When set, filter by the artist musicbrainz id
    f_lyrics_language   - Filter by the lyrics language (en,it)
    g_commontrack       - When set, group the result the commontrack_id
    s_track_rating      - Sort by our popularity index for tracks (as|desc)
    s_artist_rating     - Sort by our popularity index for artists (as|desc)
    quorum_factor       - Search only a part of the given query string. (0.0 -1.0)
 
 */
- (void) searchTrackWithParameters:(NSDictionary *)params withCompletionBlock:(void (^)(NSArray *tracks))completionBlock;



// Trending searches with parameters
/*
    country             - A valid country code like (US,IT or IN)
    page_size           - Define number of results per page
    page                - Define the page number of paginated results
    
 */
- (void) getTrendingTracksWithParameters:(NSDictionary *)params withCompletionBlock:(void (^)(NSArray *tracks))completionBlock;
- (void) getTrendingArtistsWithParameters:(NSDictionary *)params withCompletionBlock:(void (^)(NSArray *artists))completionBlock;




@end
