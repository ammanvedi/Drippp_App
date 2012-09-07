//
//  DRPColorPickerController.h
//  Drippp_v2
//
//  Created by Amman on 03/09/2012.
//  Copyright (c) 2012 Amman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DRPColorPickerController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>{
    
    NSString *url;
    NSTimer *timer;
    AVCaptureVideoPreviewLayer *AVCPL;
    UIImage *img;
    CALayer *customPreviewLayer;
    AVCaptureSession *captureSession;
}
@property (nonatomic, strong) UIImagePickerController *Image_Picker;
@property (nonatomic, strong) UIImage *capImage;
@property (weak, nonatomic) IBOutlet UIButton *Camera_Button;
@property (strong) NSMutableArray *idsarray;
@property (weak, nonatomic) IBOutlet UIImageView *Camera_Image_View;
@property (nonatomic, retain) NSTimer * timer;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (weak, nonatomic) IBOutlet UIImageView *ColorView;

- (IBAction)Take_Pic:(id)sender;
- (NSArray*)getRGBAsFromImage:(CGImageRef)image atX:(int)xx andY:(int)yy count:(int)count;


@end
