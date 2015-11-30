//
//  InboxViewController.h
//  Watchit
//
//  Created by Tobias Tikka on 06/11/15.
//  Copyright © 2015 Tobias Tikka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>

@interface InboxViewController : UITableViewController

@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) PFObject *selectedMessage;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

- (IBAction)logout:(id)sender;

@end
