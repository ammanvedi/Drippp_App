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
#import "UIColor-Hex.h"

@interface DRPColorPickerController ()

@end

@implementation DRPColorPickerController

@synthesize Image_Picker;
@synthesize capImage;
@synthesize Camera_Button;

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
    [self setCamera_Button:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setCapImage:nil];

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
    
    unsigned char *pixelData = [self.capImage rgbaPixels];
    
    
    int x = capImage.size.width / 2;
    int y = capImage.size.height / 2;
    
    NSLog(@"%@", @"again");
    
    unsigned char pixelr = pixelData[(y*((int)self.capImage.size.width)*4)+(x*4)];
    unsigned char pixelg = pixelData[(y*((int)self.capImage.size.width)*4)+(x*4)+1];
    unsigned char pixelb = pixelData[(y*((int)self.capImage.size.width)*4)+(x*4)+2];
    
    NSString *hex_color = [[NSString alloc] init];
    hex_color = [NSString stringWithFormat:@"%X%X%X",pixelr,pixelg,pixelb];
    NSLog(@"%@", hex_color);
    
    NSScanner *scanner = [NSScanner scannerWithString:hex_color];
    unsigned hex;
    [scanner scanHexInt:&hex];
    
    
    UIColor *col = [[UIColor alloc] initWithHex:hex_color alpha:1.0f];
    
    [self.Camera_Button setBackgroundColor:col];
    [self.view setBackgroundColor:col];

    [self.Image_Picker dismissModalViewControllerAnimated:YES];

}


@end
