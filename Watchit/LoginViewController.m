//
//  LoginViewController.m
//
// This class controlls the login behaviour of the app. 
//
//  Created by Tobias Tikka on 08/11/15.
//  Copyright © 2015 Tobias Tikka. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        self.backgroundImageView.image = [UIImage imageNamed:@"loginBackground-568h@2x"];
    }
    
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
}

#pragma mark - IBActions

- (IBAction)login:(id)sender {
    
    //save username and password to variables
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //Check if the username and password fields have been filled in. If not, notify the user.
    if ([username length] == 0 || [password length] == 0) {
        UIAlertController *alert = [self createAlert:@"Oops!" withMessage:@"Make sure you enter a username and password address!"];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        
        //Log in to the app using Parse
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
            if (error) {
                UIAlertController *alert = [self createAlert:@"Sorry!" withMessage:[error.userInfo objectForKey:@"error"]];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

//Create an alert
-(UIAlertController *)createAlert:(NSString *)title withMessage:(NSString *)message {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* dismissButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handel your yes please button action here
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
    
    [alert addAction:dismissButton];
    
    return alert;
}


@end
