//
//  ESViewController.m
//  Camera
//
//  Created by Eduardo Sierra on 11/5/13.
//  Copyright (c) 2013 Sierra. All rights reserved.
//

#import "ESViewController.h"
#import "UIImageView+Circle.h"

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
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    
    _theImage = [UIImageView circleImageView:CGRectMake(10.f, 50.f, 300.f, 300.f)];
    
    [self.view addSubview:_theImage];
    [_theImage setImage:chosenImage];
    
    [_theImage setContentMode:UIViewContentModeScaleAspectFit];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
    UIImageWriteToSavedPhotosAlbum(chosenImage, self, @selector(image:didFinishedSavingWithError:contextInfo:), nil);
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
