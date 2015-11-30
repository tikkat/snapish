//
//  ImageViewController.m
//  Watchit
//
//  Created by Tobias Tikka on 10/11/15.
//  Copyright © 2015 Tobias Tikka. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    PFFile *imageFile = [self.message objectForKey:@"file"];
    NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
    self.imageView.image = [UIImage imageWithData:imageData];
    
    NSString *senderName = [self.message objectForKey:@"senderName"];
    NSString *title = [NSString stringWithFormat:@"Sent from %@", senderName];
    self.navigationItem.title = title;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self respondsToSelector:@selector(timeout)]) {
        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    }
    else {
        NSLog(@"Error: Selector missing!");
    }
}

#pragma mark - Helper methods

-(void)timeout {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
