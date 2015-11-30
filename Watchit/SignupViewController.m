//
//  SignupViewController.m
//  Watchit
//
//  Created by Tobias Tikka on 08/11/15.
//  Copyright © 2015 Tobias Tikka. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        self.backgroundImageView.image = [UIImage imageNamed:@"loginBackground-568h@2x"];
    }
    
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    self.usernameField.delegate = self;
    
}

#pragma mark - IBActions

- (IBAction)signup:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email    = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //Make sure that the username, password and email have been filled in, notify the user otherwise
    if ([username length] == 0 || [password length] == 0 || [email length] == 0) {
        
        UIAlertController * alert = [self createAlert:@"Oops" withMessage:@"Make sure you enter a username, password and email address!"];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else {
        
        //Use the data from the text fields and save it to Parse
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.password = password;
        newUser.email = email;
        
        //Create new user
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
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

//Dismiss the signup screen if the user press the X button in the top right corner.
- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

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
