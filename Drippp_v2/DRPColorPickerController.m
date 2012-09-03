//
//  DRPColorPickerController.m
//  Drippp_v2
//
//  Created by Amman on 03/09/2012.
//  Copyright (c) 2012 Amman. All rights reserved.
//

#import "DRPColorPickerController.h"
#import <MobileCoreServices/MobileCoreServices.h> 
#import "DRPCameraOverlay.h"
#import "UIImage+Pixels.h"

@interface DRPColorPickerController ()

@end

@implementation DRPColorPickerController

@synthesize Image_Picker;
@synthesize capImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)Take_Pic:(id)sender {
    
    UIView *Overlay = [[UIView alloc] init];
    
    Image_Picker = [[UIImagePickerController alloc] init];
    
    Image_Picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    Image_Picker.delegate = self;
    
    Image_Picker.allowsEditing = NO;
    
    
    [Image_Picker setCameraOverlayView:Overlay];
    
    [self presentModalViewController:Image_Picker animated:YES];
    
    NSLog(@"%@", @"called");
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%@", @"taken");
    
    capImage = [[UIImage alloc] init];
    capImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.capImage rgbaPixels];

    [self.Image_Picker dismissModalViewControllerAnimated:YES];

}


@end
