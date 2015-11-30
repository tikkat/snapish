//
//  CameraViewController.m
//  Watchit
//
//  Created by Tobias Tikka on 09/11/15.
//  Copyright © 2015 Tobias Tikka. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    self.recipients = [[NSMutableArray alloc] init];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //Query the friends relations to make sure that the latest relations is displayed
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error %@ %@", error, error.userInfo);
        }
        else {
            self.friends = objects;
            [self.tableView reloadData];
        }
    }];
    
    
    if (self.image == nil && [self.videoFilePath length] == 0) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = NO;
        self.imagePicker.videoMaximumDuration = 10;
        
        //Runs if we're on a device
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        //For testing purposes on simulator
        else {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.friends count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if ([self.recipients containsObject:user.objectId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
    
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.recipients addObject:user.objectId];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.recipients removeObject:user.objectId];
    }
}

#pragma mark - Image Picker Controller delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        // A photo was taken/selected
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            // Save the image
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
    }
    else {
        // A video was taken/selected
        self.videoFilePath = (NSString *) [[info objectForKey:UIImagePickerControllerMediaURL] path];
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            // Save the video
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
            }
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBActions

- (IBAction)cancel:(id)sender {
    [self reset];
    
    [self.tabBarController setSelectedIndex:0];
    
}

- (IBAction)send:(id)sender {
    
    if (self.image == nil && [self.videoFilePath length] == 0) {
        UIAlertController *alert = [self createAlert:@"Try again!" withMessage:@"Plase capture or select a photo or video to share!"];
        [self presentViewController:alert animated:YES completion:nil];

        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
    else {
        [self uploadMessage];
        [self.tabBarController setSelectedIndex:0];
    }
    
}

#pragma mark - Helper methods

- (void)reset {
    self.image = nil;
    self.videoFilePath = nil;
    [self.recipients removeAllObjects];
}

-(void)uploadMessage {
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    if (self.image != nil) {
        UIImage *newImage = [self resizeImage:self.image toWidth:320.0f andHeight:480.0f];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
    }
    else {
        fileData = [NSData dataWithContentsOfFile:self.videoFilePath];
        fileName = @"video.mov";
        fileType = @"video";
    }
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        if (error) {
            UIAlertController *alert = [self createAlert:@"An error eccured!" withMessage:@"Plase try sending your message again."];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            PFObject *message = [PFObject objectWithClassName:@"Messages"];
            [message setObject:file forKey:@"file"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:self.recipients forKey:@"recipientIds"];
            [message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
            [message setObject:[[PFUser currentUser] username] forKey:@"senderName"];
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error) {
                    UIAlertController *alert = [self createAlert:@"An error eccured!" withMessage:@"Plase try sending your message again."];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else {
                    //Everything was successful!
                    //We can now reset everything in this view
                    [self reset];
                }
            }];
        }
    }];
}

-(UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height {
    
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:newRectangle];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
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
