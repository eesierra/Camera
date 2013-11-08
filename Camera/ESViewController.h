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

@interface ESViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (nonatomic, strong) IBOutlet UIImageView *theImage;
@property (nonatomic, weak) IBOutlet UIButton *picture;

- (IBAction)picButton:(id)sender;


@end
