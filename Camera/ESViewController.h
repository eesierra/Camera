//
//  ESViewController.h
//  Camera
//
//  Created by Eduardo Sierra on 11/5/13.
//  Copyright (c) 2013 Sierra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>

@interface ESViewController : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (nonatomic, strong) IBOutlet UIImageView *theImage;
@property (nonatomic, strong) UIImage *chosenImage;
@property (nonatomic, weak) IBOutlet UIButton *picture;

- (IBAction)picButton:(id)sender;
- (IBAction)shareTwitter:(id)sender;
- (IBAction)shareFacebook:(id)sender;
- (IBAction)shareEmail:(id)sender;
- (IBAction)loginFB:(id)sender;



@end
