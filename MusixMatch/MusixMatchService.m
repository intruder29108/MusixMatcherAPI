//
//  MusixMatchService.m
//  MusixMatch
//
//  Created by intruder on 19/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MusixMatchService.h"
#import "NSString+Extension.h"
#import "Track.h"
#import "Artist.h"
#import "Album.h"



static MusixMatchService  *sharedInstance = nil;

@implementation MusixMatchService

+ (MusixMatchService*)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedInstance == nil)
			sharedInstance = [[MusixMatchService alloc] init];
    });
    return sharedInstance;

}


// Helper to form the request URL
- (NSString*)baseUrl:(NSString*)method 
{
	return [NSString stringWithFormat:@"%@%@?apikey=%@&format=%@", APIBASEURL, method, APIKEY, APIFORMAT];
}

// Common method to perform request to the server (Use Synchronous Blocking Connection)
- (NSDictionary *)performQuery:(NSString *)urlStr
{
    NSURL *url = [[NSURL alloc]initWithString:urlStr];
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [url release];
    
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	[request release];
	if (error)
    {
		NSLog(@"Error fetching %@: %@", url, [error localizedDescription]);
		return nil;
	}
	if ([response statusCode] != 200) 
    {
		NSString *body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"Cannot fetch %@: %@", url, body);
		[body release];
		return nil;
	}

    NSDictionary* dict = [NSJSONSerialization 
                          JSONObjectWithData:data 
                          options:kNilOptions 
                          error:&error];	
    
    // Check for errors in parsing JSON
    if (error) 
    {
		NSLog(@"Error fetching %@: %@", url, [error localizedDescription]);
		return nil;
	}
	id body = [[dict objectForKey:@"message"] objectForKey:@"body"];
	if (![body isKindOfClass:[NSDictionary class]])
    {
		NSLog(@"Invalid body, statusCode: %@", [[[dict objectForKey:@"message"] objectForKey:@"header"] objectForKey:@"status_code"]);
		return nil;
	}
	return body;
}

/* Search Section */
- (void) searchAlbumsByArtistWithId:(NSString *)artist_id numResults:(NSUInteger)numResults withCompletionBlock:(void (^)(NSArray *))completionBlock
{
    
    /* Perform URL Encoding for the spaces and other characters. 
     This query groups albums and sorts the according to their release date in descending order*/
    NSString *requestURL = [NSString stringWithFormat:@"%@&artist_id=%@&page_size=%d&s_release_date=desc&g_album_name=1",[self baseUrl:GET_ALUBMS_BY_ARTIST],[artist_id URLEncoded],numResults] ;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *body = [self performQuery:requestURL];
        NSArray *results = [body objectForKey:@"album_list"];
        if (!results)
        {
            completionBlock(nil);
        }
        else
        {
            NSMutableArray *albums = [NSMutableArray array];
            for (NSDictionary *dict in results) 
            {
                Album *album = [[Album alloc]initWithDictionary:[dict objectForKey:@"album"]];
                [albums addObject:album];
                [album release];
            }
            
            // Call the completion handler
            completionBlock(albums);
        }
    });
    return;
}

- (void)getArtistsWithName:(NSString *)artist_name numResults:(NSUInteger)numResults withCompletionBlock:(void (^)(NSArray *artists))completionBlock
{
    /* Perform URL Encoding for the spaces and other characters. 
     Seach the database with the query string*/
    NSString *requestURL = [NSString stringWithFormat:@"%@&q_artist=%@&page_size=%d",[self baseUrl:SEARCH_ARTIST],[artist_name URLEncoded],numResults];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *body = [self performQuery:requestURL];
        NSArray *results = [body objectForKey:@"artist_list"];
        if(!results)
        {
            completionBlock(nil);
        }
        else
        {
            NSMutableArray *artists = [NSMutableArray array];
            for(NSDictionary *dict in results)
            {
                Artist *artist = [[Artist alloc]initWithDictionary:[dict objectForKey:@"artist"]];
                [artists addObject:artist];
                [artist release];
            }
            // Call the completion handler
            completionBlock(artists);
        }
    });
    return;
}

- (void)getArtistWithId:(NSString *)artist_id withCompletionBlock:(void (^)(Artist *artist))completionBlock
{
    /* 
      Peform URL Encoding for the spaces a other characters 
      Search the database for artist info with the give search string and parameters
    */
    NSString *requestURL = [NSString stringWithFormat:@"%@&artist_id=%@",[self baseUrl:GET_ARTIST],artist_id];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *body = [self performQuery:requestURL];
        NSDictionary *result = [body objectForKey:@"artist"];
        if(!result)
        {
            completionBlock(nil);
        }
        else
        {
            Artist *artist = [[Artist alloc]initWithDictionary:result];
            completionBlock(artist);
            
        }
    });
    
    return;
}


// Track related functions
- (void) searchTrackWithName:(NSString *)query numResults:(NSUInteger)numResults accuracy:(CGFloat)factor withCompletionBlock:(void (^)(NSArray *))completionBlock
{
    /* 
       Peform URL Encoding for the spaces a other characters 
       Search the database for artist info with the give search string and parameters
    */
    NSString *requestURL = [NSString stringWithFormat:@"%@&q_track=%@&page_size=%d&quorum_factor=%f",[self baseUrl:TRACK_SEARCH],[query URLEncoded],numResults,factor];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *body = [self performQuery:requestURL];
        NSArray *results = [body objectForKey:@"track_list"];
        if(!results)
        {
            completionBlock(nil);
        }
        else
        {
            NSMutableArray *tracks = [NSMutableArray array];
            for(NSDictionary *dict in results)
            {
                Track *track = [[Track alloc]initWithDictionary:[dict objectForKey:@"track"]];
                [tracks addObject:track];
                [track release];
            }
            // Call the completion handler
            completionBlock(tracks);
        }
    });
    return;
    
}

- (void)getTrackWithId:(NSString *)track_id withCompletionBlock:(void (^)(Track *track))completionBlock
{
    /* 
     Peform URL Encoding for the spaces a other characters 
     Search the database for artist info with the give search string and parameters
     */
    NSString *requestURL = [NSString stringWithFormat:@"%@&track_id=%@",[self baseUrl:TRACK_GET],track_id];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *body = [self performQuery:requestURL];
        NSDictionary *result = [body objectForKey:@"track"];
        if(!result)
        {
            completionBlock(nil);
        }
        else
        {
            Track *track = [[Track alloc]initWithDictionary:result];
            completionBlock(track);
        }
    });
    
    return;
}


// Lyrics and Subtitle Functions
- (void)getLyricsForTrackWithId:(NSString *)track_id withCompletionBlock:(void (^)(NSString *))completionBlock
{
    /* Perform URL Encoding for the spaces and other characters. 
     Seach the database with the query string*/
    NSString *requestURL = [NSString stringWithFormat:@"%@&track_id=%@",[self baseUrl:GET_LYRICS],[track_id URLEncoded]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *body = [self performQuery:requestURL];
        NSDictionary *result = [body objectForKey:@"lyrics"];
        if(!result)
        {
            completionBlock(nil);
        }
        else
        {
            // Call the completion handler
            completionBlock([result objectForKey:@"lyrics_body"]);
        }
    });
    return;
}

- (void)getLyricsSnippetWithId:(NSString *)track_id withCompletionBlock:(void (^)(NSString *lyric_snippets))completionBlock
{
    /* Perform URL Encoding for the spaces and other characters. 
     Seach the database with the query string*/
    NSString *requestURL = [NSString stringWithFormat:@"%@&track_id=%@",[self baseUrl:GET_LYRICS_SNIPPET],[track_id URLEncoded]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *body = [self performQuery:requestURL];
        NSDictionary *result = [body objectForKey:@"snippet"];
        if(!result)
        {
            completionBlock(nil);
        }
        else
        {
            // Call the completion handler
            completionBlock([result objectForKey:@"snippet_body"]);
        }
    });
    return;
}

- (void) getSubtitleForTrackWithId:(NSString *)track_id withCompletionBlock:(void (^)(NSString *))completionBlock
{
    /* Perform URL Encoding for the spaces and other characters. 
     Seach the database with the query string*/
    NSString *requestURL = [NSString stringWithFormat:@"%@&track_id=%@",[self baseUrl:GET_LYRICS_SNIPPET],[track_id URLEncoded]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *body = [self performQuery:requestURL];
        NSDictionary *result = [body objectForKey:@"lyrics"];
        if(!result)
        {
            completionBlock(nil);
        }
        else
        {
            // Call the completion handler
            completionBlock([result objectForKey:@"lyrics_body"]);
        }
    });
    return;
}


/* Trending Searches section */
- (void) getTrendingArtistsWithNumberOfResults:(NSUInteger)numResults andCompletionBlock:(void (^)(NSArray *))completionBlock
{
    /* Perform URL Encoding for the spaces and other characters.*/
    NSString *requestURL = [NSString stringWithFormat:@"%@&page_size=%d&country=in",[self baseUrl:TRENDING_ARTIST],numResults];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *body = [self performQuery:requestURL];
        NSArray *results = [body objectForKey:@"artist_list"];
        if(!results)
        {
            completionBlock(nil);
        }
        else
        {
            NSMutableArray *artists = [NSMutableArray array];
            for(NSDictionary *dict in results)
            {
                Artist *artist = [[Artist alloc]initWithDictionary:[dict objectForKey:@"artist"]];
                [artists addObject:artist];
                [artist release];
            }
            // Call the completion block
            completionBlock(artists);
        }
    });
    return;
}

- (void) getTrendingTracksWithNumberOfResults:(NSUInteger)numResults andCompletionBlock:(void (^)(NSArray *))completionBlock
{
    /* Perform URL Encoding for the spaces and other characters */
    NSString *requestURL = [NSString stringWithFormat:@"%@&page_size=%d&country=in",[self baseUrl:TRENDING_TRACKS],numResults];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *body = [self performQuery:requestURL];
        NSArray *results = [body objectForKey:@"track_list"];
        if(!results)
        {
            completionBlock(nil);
        }
        else
        {
            NSMutableArray *tracks = [NSMutableArray array];
            for(NSDictionary *dict in results)
            {
                Track *track = [[Track alloc]initWithDictionary:[dict objectForKey:@"track"]];
                [tracks addObject:track];
                [track release];
            }
            // Call the completion handler
            completionBlock(tracks);
        }
    });
    return;
}

- (void) getTrendingTracksWithParameters:(NSDictionary *)params withCompletionBlock:(void (^)(NSArray *tracks))completionBlock
{
    NSMutableString *paramString = [[NSMutableString alloc]initWithString:@""];
    for(NSString *key in params.allKeys)
    {
        [paramString appendFormat:@"&%@=%@",key,[[params objectForKey:key] URLEncoded]];
    }
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",[self baseUrl:TRENDING_TRACKS],paramString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *body = [self performQuery:requestURL];
        NSArray *results = [body objectForKey:@"track_list"];
        if(!results)
        {
            completionBlock(nil);
        }
        else
        {
            NSMutableArray *tracks = [NSMutableArray array];
            for(NSDictionary *dict in results)
            {
                Track *track = [[Track alloc]initWithDictionary:[dict objectForKey:@"track"]];
                [tracks addObject:track];
                [track release];
            }
            // Call the completion handler
            completionBlock(tracks);
        }
    });
    
    // Do clean up 
    [paramString release];
    return;
}

- (void) getTrendingArtistsWithParameters:(NSDictionary *)params withCompletionBlock:(void (^)(NSArray *artists))completionBlock
{
    NSMutableString *paramString = [[NSMutableString alloc]initWithString:@""];
    for(NSString *key in params.allKeys)
    {
        [paramString appendFormat:@"&%@=%@",key,[[params objectForKey:key] URLEncoded]];
    }
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",[self baseUrl:TRENDING_ARTIST],paramString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *body = [self performQuery:requestURL];
        NSArray *results = [body objectForKey:@"artist_list"];
        if(!results)
        {
            completionBlock(nil);
        }
        else
        {
            NSMutableArray *artists = [NSMutableArray array];
            for(NSDictionary *dict in results)
            {
                Artist *artist = [[Artist alloc]initWithDictionary:[dict objectForKey:@"artist"]];
                [artists addObject:artist];
                [artist release];
            }
            // Call the completion handler
            completionBlock(artists);
        }
    });
    
    // Do clean up 
    [paramString release];
    return;
}



// Matcher function
- (void) getLyricsForTrackWithParameters:(NSDictionary *)params withCompletionBlock:(void (^)(NSString *lyrics))completionBlock
{
    NSMutableString *paramString = [[NSMutableString alloc]initWithString:@""];
    for(NSString *key in params.allKeys)
    {
        [paramString appendFormat:@"&%@=%@",key,[[params objectForKey:key]URLEncoded]];
    }
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",[self baseUrl:MATCHER_GET_LYRICS],paramString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *body = [self performQuery:requestURL];
        NSDictionary *result = [body objectForKey:@"lyrics"];
        if(!result)
        {
            completionBlock(nil);
        }
        else
        {
            // Call the completion handler
            completionBlock([result objectForKey:@"lyrics_body"]);
        }
    });
    
    // Do clean up
    [paramString release];
    return;
}



// Advanced search functions
- (void) searchTrackWithParameters:(NSDictionary *)params withCompletionBlock:(void (^)(NSArray *))completionBlock
{
    NSMutableString *paramString = [[NSMutableString alloc]initWithString:@""];
    
    for(NSString *key in params.allKeys)
    {
        [paramString appendFormat:@"&%@=%@",key,[[params objectForKey:key] URLEncoded]];
    }
    
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",[self baseUrl:TRACK_SEARCH],paramString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *body = [self performQuery:requestURL];
        NSArray *results = [body objectForKey:@"track_list"];
        if(!results)
        {
            completionBlock(nil);
        }
        else
        {
            NSMutableArray *tracks = [NSMutableArray array];
            for(NSDictionary *dict in results)
            {
                Track *track = [[Track alloc]initWithDictionary:[dict objectForKey:@"track"]];
                [tracks addObject:track];
                [track release];
            }
            // Call the completion handler
            completionBlock(tracks);
        }
    });
    
    // Do clean up 
    [paramString release];
    return;
}

- (void) searchTrackUsingMatcherFunctionWithParameters:(NSDictionary *)params withCompletionBlock:(void (^)(Track *track))completionBlock
{
    NSMutableString *parmaString = [[NSMutableString alloc]initWithString:@""];
    
    for(NSString *key in params.allKeys)
    {
        [parmaString appendFormat:@"&%@=%@",key,[[params objectForKey:key] URLEncoded]];
    }
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",[self baseUrl:MATCHER_GET_TRACK],parmaString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *body = [self performQuery:requestURL];
        NSDictionary *result = [body objectForKey:@"track"];
        if(!result)
        {
            completionBlock(nil);
        }
        else
        {
            Track *track = [[Track alloc]initWithDictionary:result];
            completionBlock(track);
        }
    });
    
    // Do clean up 
    [parmaString release];
    return;
}


// Album related functions
- (void)getAlbumWithId:(NSString *)album_id withCompletionBlock:(void (^)(Album *album))completionBlock
{
    /*
     Perform URL Encoding for the spaces and other characters. 
     Seach the database with the query string
    */
    NSString *requestURL = [NSString stringWithFormat:@"%@&album_id=%@",[self baseUrl:GET_ALBUM],[album_id URLEncoded]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *body = [self performQuery:requestURL];
        NSDictionary *result = [body objectForKey:@"album"];
        if(!result)
        {
            completionBlock(nil);
        }
        else
        {
            Album *album = [[Album alloc]initWithDictionary:result];
            // Call the completion handler
            completionBlock(album);
        }
    });
    return;
}


- (void)getTracksFromAlbumWithId:(NSString *)album_id withCompletionBlock:(void (^)(NSArray *))completionBlock
{
    /*
     Perform URL Encoding for the spaces and other characters. 
     Seach the database with the query string
     */
    
    NSString *requestURL = [NSString stringWithFormat:@"%@&album_id=%@",[self baseUrl:GET_ALBUM_TRACKS],[album_id URLEncoded]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *body = [self performQuery:requestURL];
        NSDictionary *results = [body objectForKey:@"track_list"];
        if(!results)
        {
            completionBlock(nil);
        }
        else
        {
            NSMutableArray *tracks = [NSMutableArray array];
            for(NSDictionary *dict in results)
            {
                Track *track = [[Track alloc]initWithDictionary:[dict objectForKey:@"track"]];
                [tracks addObject:track];
                [track release];
            }
            completionBlock(tracks);
        }
    });
}


@end
