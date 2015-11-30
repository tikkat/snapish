//
//  FriendsViewController.h
//  Watchit
//
//  Created by Tobias Tikka on 09/11/15.
//  Copyright © 2015 Tobias Tikka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FriendsViewController : UITableViewController

@property (nonatomic, strong) PFRelation *friendsRelation;
@property (nonatomic, strong) NSArray *friends;

@end
