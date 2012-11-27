//
//  AppDelegate.m
//  MusixMatch
//
//  Created by intruder on 19/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "MusixMatchService.h"
#import "Album.h"
#import "Artist.h"
#import "Track.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:@"Paint my love",@"q_track", nil];
    
    
//    [[MusixMatchService sharedInstance]searchTrackUsingMatcherFunctionWithParameters:params withCompletionBlock:^(Track *track) {
//
//            NSLog(@"%@ - %@",track.trackName,track.artistName);
//
//    }];

    
//    [[MusixMatchService sharedInstance]searchAlbumsByArtistWithId:@"64" numResults:50 withCompletionBlock:^(NSArray *albums)
//    {
//        if(!albums)
//            NSLog(@"Error!");
//        else
//        {
//           [albums enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//               Album *album = (Album *)obj;
//               NSLog(@"%@ - %@",album.albumName,album.artistName);
//               
//           }];
//        }
//    }];
    
//    [[MusixMatchService sharedInstance] getTrendingArtistsWithNumberOfResults:10 andCompletionBlock:^(NSArray *artists) {
//        [artists enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            Artist *artist = (Artist *)obj;
//            NSLog(@"%@ - %@",artist.artist_name,artist.artist_country);
//        }];
//    }];
    
//    [[MusixMatchService sharedInstance] getTrendingTracksWithNumberOfResults:10 andCompletionBlock:^(NSArray *tracks) {
//        [tracks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            Track *track = (Track *)obj;
//            NSLog(@"%@ - %@",track.trackName,track.trackId);
//        }];
//    }];
    
    
    
//    [[MusixMatchService sharedInstance]getArtistWithId:@"626" withCompletionBlock:^(Artist *artist) {
//        NSLog(@"%@ - %d",artist.artist_name,artist.artist_rating);
//    }];
    
    
//    [[MusixMatchService sharedInstance]getTrendingArtistsWithParameters:params withCompletionBlock:^(NSArray *artists) {
//        [artists enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            Artist *artist = (Artist *)obj;
//            NSLog(@"%@ - %@",artist.artist_name,artist.artist_id);
//        }];     
//    }];
    
    
//    [[MusixMatchService sharedInstance]getTrendingTracksWithParameters:params withCompletionBlock:^(NSArray *tracks) {
//        [tracks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            Track *track = (Track *)obj;
//            NSLog(@"%@ - %@",track.trackName,track.trackId);
//        }];
//    }];
    
    
//    [[MusixMatchService sharedInstance]getLyricsForTrackWithId:@"18694148" withCompletionBlock:^(NSString *subtitles) {
//        NSLog(@"%@",subtitles);
//    }];
    
    
//    [[MusixMatchService sharedInstance]getLyricsSnippetWithId:@"18694148" withCompletionBlock:^(NSString *lyric_snippets) {
//        NSLog(@"%@",lyric_snippets);
//    }];
    
    
//    [[MusixMatchService sharedInstance]searchTrackWithParameters:params withCompletionBlock:^(NSArray *tracks) {
//        [tracks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            Track *track = (Track *)obj;
//            NSLog(@"%@ - %@",track.trackName,track.artistName);
//        }];
//    }];
    
    
//    [[MusixMatchService sharedInstance] getArtistsWithName:@"Chris" numResults:10 withCompletionBlock:^(NSArray *artists) {
//        [artists enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            Artist *artist = (Artist *)obj;
//            NSLog(@"%@ - %@",artist.artist_name,artist.artist_country);
//        }];
//    }];
    
//    [[MusixMatchService sharedInstance]getLyricsForTrackWithId:@"18256178" withCompletionBlock:^(NSString *subtitles) {
//        NSLog(@"-----Lyrics-----\n%@",subtitles);
//    }];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
