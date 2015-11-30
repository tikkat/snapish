//
//  LoginViewController.h
//  Watchit
//
//  Created by Tobias Tikka on 08/11/15.
//  Copyright © 2015 Tobias Tikka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (IBAction)login:(id)sender;

@end
