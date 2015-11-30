//
//  EditFriendsViewController.h
//  Watchit
//
//  Created by Tobias Tikka on 08/11/15.
//  Copyright © 2015 Tobias Tikka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditFriendsViewController : UITableViewController

@property (nonatomic, strong) NSArray *allUsers;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSMutableArray *friends;

-(BOOL)isFriend:(PFUser *)user;

@end
