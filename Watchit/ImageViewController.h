//
//  ImageViewController.h
//  Watchit
//
//  Created by Tobias Tikka on 10/11/15.
//  Copyright © 2015 Tobias Tikka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageViewController : UIViewController

@property (nonatomic, strong) PFObject *message;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
