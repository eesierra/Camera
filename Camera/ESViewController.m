//
//  ESViewController.m
//  Camera
//
//  Created by Eduardo Sierra on 11/5/13.
//  Copyright (c) 2013 Sierra. All rights reserved.
//

#import "ESViewController.h"
#import "UIImageView+Circle.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ESViewController ()

@end

@implementation ESViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}



- (IBAction)picButton:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What Do You Want To Do?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Use Your Camera", @"Use Your Photo Library", @"Add Filter: Sepia Tone", @"Add Filter: Posterize", @"Add Filter: Instant", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:[self.view window]];
    
}



- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        if (buttonIndex == 0) {
            [self camera];
        }
        if (buttonIndex == 1) {
            [self photoLibrary];
        }
        if (buttonIndex == 2) {
            [self filterOne];
        }
        if (buttonIndex == 3) {
            [self filterTwo];
        }
        if (buttonIndex == 4) {
            [self filterThree];
        }
    }

}


- (void)camera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
        photoPicker.delegate = self;
        photoPicker.allowsEditing = YES;
        photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        UIView *overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
        overlayView.layer.borderColor = [[UIColor redColor] CGColor];
        overlayView.layer.borderWidth = 5.0f;
        
        UIButton *overlayButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
        overlayButton.center = overlayView.center;
        overlayButton.backgroundColor = [UIColor yellowColor];
        overlayButton.titleLabel.text = @"Close Picker";
        [overlayButton addTarget:self
                          action:@selector(overlayButtonTapped)
                forControlEvents:UIControlEventTouchUpInside];
        [overlayView addSubview:overlayButton];
        
        photoPicker.cameraOverlayView = overlayView;
        
        
        [self presentViewController:photoPicker animated:YES completion:^{
            NSLog(@"Camera");
        }];

    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"Your device does not have a camera!" delegate:nil cancelButtonTitle:@"Return" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)overlayButtonTapped
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
    
}


- (void)photoLibrary
{
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.delegate = self;
    photoPicker.allowsEditing = YES;
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:photoPicker animated:YES completion:NULL];
    
}

- (void)filterOne
{
    CIImage *imageOriginal;
    imageOriginal = [[CIImage alloc] initWithImage:self.theImage.image];
    
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
    [filter setDefaults];
    
    [filter setValue:imageOriginal forKey:kCIInputImageKey];
    
    
    
    CIImage *imageFilter = [filter valueForKey:kCIOutputImageKey];
    UIImage *filterImage = [UIImage imageWithCIImage:imageFilter];
    self.theImage.image = filterImage;
}

- (void)filterTwo
{
    CIImage *imageOriginal;
    imageOriginal = [[CIImage alloc] initWithImage:self.theImage.image];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorPosterize"];
    [filter setDefaults];
    
    [filter setValue:imageOriginal forKey:kCIInputImageKey];
    
    
    
    CIImage *imageFilter = [filter valueForKey:kCIOutputImageKey];
    UIImage *filterImage = [UIImage imageWithCIImage:imageFilter];
    self.theImage.image = filterImage;
}

- (void)filterThree
{
    CIImage *imageOriginal;
    imageOriginal = [[CIImage alloc] initWithImage:self.theImage.image];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectInstant"];
    [filter setDefaults];
    
    [filter setValue:imageOriginal forKey:kCIInputImageKey];
    
    
    
    CIImage *imageFilter = [filter valueForKey:kCIOutputImageKey];
    UIImage *filterImage = [UIImage imageWithCIImage:imageFilter];
    self.theImage.image = filterImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _chosenImage = info[UIImagePickerControllerEditedImage];
    
    
    _theImage = [UIImageView circleImageView:CGRectMake(10.f, 50.f, 300.f, 300.f)];
    
    [self.view addSubview:_theImage];
    [_theImage setImage:_chosenImage];
    
    [_theImage setContentMode:UIViewContentModeScaleAspectFit];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
    UIImageWriteToSavedPhotosAlbum(_chosenImage, self, @selector(image:didFinishedSavingWithError:contextInfo:), nil);
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)image:(UIImage *)image didFinishedSavingWithError: (NSError *) error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoa!" message:@"Can't Save Your Photo!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    
}

- (IBAction)shareTwitter:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twitter setInitialText:@"Look at my pic! :)"];
        [twitter addImage:self.chosenImage];
        
        NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
        [twitter addURL:url];
        [twitter setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Cancelled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Successful");
                    break;
            }
        
                }];
            
            [self presentViewController:twitter animated:YES completion:nil];
            
    } else {
        NSString *message1 = @"Unfortunately, you can't post at this time. This might be because Twitter is not available or you don't have an account associated with this device.";
        UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:@"We're Sorry!" message:message1 delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alertView1 show];}

    
}

- (IBAction)shareFacebook:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebook setInitialText:@"Look at my pic! :)"];
        [facebook addImage:self.chosenImage];
        
        NSURL *url = [NSURL URLWithString:@"http://www.facebook.com"];
        [facebook addURL:url];
        [facebook setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Cancelled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Successful");
                    break;
            }
            
        }];
        
        [self presentViewController:facebook animated:YES completion:nil];
        
    } else {
        NSString *message1 = @"Unfortunately, you can't post at this time. This might be because Facebook is not available or you don't have an account associated with this device.";
        UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:@"We're Sorry!" message:message1 delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alertView1 show];}
    
    
}

- (IBAction)shareEmail:(id)sender
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if ([mailClass canSendMail]) {
        MFMailComposeViewController *email = [[MFMailComposeViewController alloc] init];
        email.mailComposeDelegate = self;
        
        [email setSubject:@"I want to share this pic with you"];
        
        NSData *imageInfo = UIImageJPEGRepresentation(self.chosenImage, 0.0);
        [email addAttachmentData:imageInfo mimeType:@"image/jpeg" fileName:@"Image"];
        
        NSString *body = @"Here's the image! <p>Check out the website <a href= http://www.google.com> Google</a> for more info!</p>";
        
        [email setMessageBody:body isHTML:YES];
        
        [self presentViewController:email animated:YES completion:NULL];
        
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Send" message:@"Please configure your device to send e-mails." delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
        [alert show];
    }
    
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Send Failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    
}

- (IBAction)loginFB:(id)sender
{
    [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"]
                                       defaultAudience:FBSessionDefaultAudienceEveryone
                                          allowLoginUI:YES
                                     completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                         [self sessionStateChanged:session state:status error:error];
                                     }];

    
    
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    switch (state)
    {
        case FBSessionStateOpen:
            [FBRequestConnection startForPostStatusUpdate:@"Hello! How are you guys doing?!" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSLog(@"Success!");
                } else {
                    NSLog(@"Whoa! Error: %@", [error localizedDescription]);
                }
            }];
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
