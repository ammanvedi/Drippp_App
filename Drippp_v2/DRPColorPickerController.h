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
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Camera_load_AI;
@property (strong) NSMutableArray *idsarray;
@property (strong, nonatomic) IBOutlet UIImageView *Camera_Image_View;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, retain) AVCaptureDeviceInput *deviceInput;
@property (nonatomic, retain) AVCaptureVideoDataOutput *dataOutput;
@property (nonatomic, retain) NSString *hex_string;
@property (nonatomic, retain) NSString *hex_only;
@property (weak, nonatomic) IBOutlet UIImageView *ColorView;
@property (weak, nonatomic) IBOutlet UIButton *pick_button;
@property (weak, nonatomic) IBOutlet UILabel *HexLabel;
@property (weak, nonatomic) IBOutlet UILabel *RGBLabel;


- (IBAction)Take_Pic:(id)sender;
- (NSArray*)getRGBAsFromImage:(CGImageRef)image atX:(int)xx andY:(int)yy count:(int)count;
- (NSString *) htmlFromUIColor:(UIColor *)_color;
-(void) getidsforcolor:(NSString *)apiurl;
- (IBAction)click_pick:(id)sender;


@end
