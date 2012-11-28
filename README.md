This is a simple API for MusixMatch webservice done using blocks

HOW TO USE:


All calls are made using shared instance of [MusixMatchService sharedInstance]
All the functions and corresponding parameters are mentioned in the MusixMatch.h file in the project


Example:

Get All tracks which contains the lyrics with words:
	
	"there is love hoping to find you will you wait for me"

NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
@"there is love hoping to find you will you wait for me",@"q_lyrics",@"0.75",@"quorum_factor",@"5",@"page_size", nil];


[[MusixMatchService sharedInstance]searchTrackWithParameters:params withCompletionBlock:^(NSArray *tracks) {
        [tracks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Track *track = (Track *)obj;
            NSLog(@"%@ - %@",track.trackName,track.artistName);
        }];
    }];
