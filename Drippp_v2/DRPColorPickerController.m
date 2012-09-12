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
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>
#import <dispatch/dispatch.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Accelerate/Accelerate.h>
#import "DRPColorResultsController.h"


@interface DRPColorPickerController ()

@end

@implementation DRPColorPickerController
@synthesize HexLabel;
@synthesize RGBLabel;
@synthesize ColorView;
@synthesize pick_button;
@synthesize Image_Picker;
@synthesize capImage;
@synthesize Camera_Button;
@synthesize Camera_load_AI;
@synthesize idsarray;
@synthesize Camera_Image_View;
@synthesize deviceInput;
@synthesize dataOutput;
@synthesize hex_string;
@synthesize hex_only;




int variance = 50;
int minimum = 35;

int count = 0;

bool back_from_pick = false;

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
    NSLog(@"%@", @"did load");
    idsarray = [[NSMutableArray alloc] init];
    [self.pick_button setEnabled:NO];
    [Camera_load_AI setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"%@", @"will appear");

    
    if (back_from_pick == false) {
         NSLog(@"%@", @"null atm");
        
        [super viewWillAppear:YES];
        idsarray = [[NSMutableArray alloc] init];
        [self.pick_button setEnabled:NO];
        [Camera_load_AI setHidden:YES];
        
    }else{
        NSLog(@"%@", @"is live");
        
        [self.pick_button setEnabled:YES];
        [self.Camera_Button setEnabled:NO];
        
        //[captureSession removeOutput:dataOutput];
        //[captureSession removeInput:deviceInput];
        //[self.captureSession stopRunning];
        
        [captureSession addInput:deviceInput];
        [captureSession addOutput:dataOutput];
        [self.captureSession startRunning];
        back_from_pick = false;
    }
    

}

- (void)viewDidUnload
{
    [self setCamera_Button:nil];
    [self setCamera_Image_View:nil];
    [self setColorView:nil];
    // Release any retained subviews of the main view.
    [self setCapImage:nil];
    [self setPick_button:nil];
    [self setHexLabel:nil];
    [self setRGBLabel:nil];
    [self setCamera_load_AI:nil];
    [super viewDidUnload];
    NSLog(@"%@", @"didunload");

}

-(void)viewWillDisappear:(BOOL)animated{
    
   // [self getidsforcolor:hex_string];
    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        
        NSLog(@"%@", @"back to main screen");
        
        [captureSession removeOutput:dataOutput];
        [captureSession removeInput:deviceInput];
        [self.captureSession stopRunning];
        [self setDataOutput:nil];
        [self setDeviceInput:nil];
        [self setCamera_Button:nil];
        [self setCamera_Image_View:nil];
        [self setCapImage:nil];
        [self setCaptureSession:nil];
        [super viewWillDisappear:YES];
    }


    NSLog(@"%@", @"will dissapear");

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)click_pick:(id)sender {
    
    [NSThread detachNewThreadSelector:@selector(getidsforcolor:) toTarget:self withObject:hex_string];
    [self.Camera_Button setEnabled:YES];
    
    [captureSession removeOutput:dataOutput];
    [captureSession removeInput:deviceInput];
    [self.captureSession stopRunning];
    
    back_from_pick = true;
    
}

- (IBAction)Take_Pic:(id)sender {
    
    [Camera_load_AI setHidden:NO];
    [Camera_load_AI startAnimating];
    
    [self.Camera_Button setEnabled:NO];
    
    img = [[UIImage alloc] init];
    
    // Create the capture session
    captureSession = [AVCaptureSession new];
    [captureSession setSessionPreset:AVCaptureSessionPresetLow];
    
    // Capture device
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Device input
    deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    if ( [captureSession canAddInput:deviceInput] ){
        [captureSession addInput:deviceInput];
    }else{
        NSLog(@"%@", @"cant add in");
    }
    
    
    
    dataOutput = [AVCaptureVideoDataOutput new];
    dataOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA] forKey:(NSString *)kCVPixelBufferPixelFormatTypeKey];
    [dataOutput setAlwaysDiscardsLateVideoFrames:YES];
    
    [[dataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
    
    if ( [captureSession canAddOutput:dataOutput]){
        [captureSession addOutput:dataOutput];
    }else{
        NSLog(@"%@", @"cant add in");
    }
    
    customPreviewLayer = [CALayer layer];
    customPreviewLayer.bounds = CGRectMake(0, 0, self.Camera_Image_View.frame.size.height, self.Camera_Image_View.frame.size.width);
    customPreviewLayer.position = CGPointMake(self.view.frame.size.width/2., self.view.frame.size.height/2.);
    customPreviewLayer.affineTransform = CGAffineTransformMakeRotation(M_PI/2);
    [customPreviewLayer setNeedsDisplay];
    
    AVCPL = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    AVCPL.frame = self.Camera_Image_View.bounds;
    AVCPL.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [AVCPL setNeedsDisplay];
    [self.Camera_Image_View.layer addSublayer:AVCPL];
    
    CALayer *TargetLayer = [[CALayer alloc] init];
    TargetLayer.frame = CGRectMake(self.Camera_Image_View.frame.size.width/2 - 30, self.Camera_Image_View.frame.size.height/2 - 30, 60, 60);
    TargetLayer.contents = (id) [UIImage imageNamed:@"target.png"].CGImage;
    [TargetLayer setOpacity:0.5];
    [self.Camera_Image_View.layer addSublayer:TargetLayer];
    
    
    
    dispatch_queue_t queue = dispatch_queue_create("VideoQueue", DISPATCH_QUEUE_SERIAL);
    
    [dataOutput setSampleBufferDelegate:self queue:queue];
    
    [captureSession startRunning];
    
    img = [UIImage imageWithCGImage:(__bridge CGImageRef)(customPreviewLayer.contents)];
    
    [self.pick_button setEnabled:YES];
    
    [Camera_load_AI stopAnimating];
    [Camera_load_AI setHidden:YES];


}
 



-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{

    
    CGImageRef dstImage = [self imageFromSampleBuffer:sampleBuffer];
    
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        customPreviewLayer.contents = (__bridge id)dstImage;
        [customPreviewLayer setNeedsDisplay];
        [self.ColorView setBackgroundColor:[[self getRGBAsFromImage:dstImage atX:96 andY:72 count:1] objectAtIndex:0]];
        
        CGFloat r;
        CGFloat g;
        CGFloat b;
        CGFloat a;
        
        [[[self getRGBAsFromImage:dstImage atX:96 andY:72 count:1] objectAtIndex:0] getRed:&r green:&g blue:&b alpha:&a];
        
       r =  r*255;
       g =  g*255;
       b =  b*255;
        
        NSString *hexr = [[NSString alloc] initWithFormat:@"%X", (int) r];
        NSString *hexg = [[NSString alloc] initWithFormat:@"%X", (int) g];
        NSString *hexb = [[NSString alloc] initWithFormat:@"%X", (int) b];
        
        if ([hexr length] <2) {
            hexr = [NSString stringWithFormat:@"%@0", hexr];

        }
        if ([hexg length] <2) {
            hexg = [NSString stringWithFormat:@"%@0", hexg];

        }
        if ([hexb length] <2) {
            hexb = [NSString stringWithFormat:@"%@0", hexb];

        }
        
        [self.RGBLabel setText:[NSString stringWithFormat:@"R: %i G: %i B: %i",(int) r, (int) g, (int) b]];
        
        [self.HexLabel setText:[NSString stringWithFormat:@"#%@%@%@",hexr, hexg, hexb]];
        
        self.hex_only = [NSString stringWithFormat:@"%@%@%@",hexr, hexg, hexb];
        

        
        self.hex_string = [NSString stringWithFormat:@"http://dribbble.com/colors/%@?percent=%i&variance=%i", hex_only, minimum, variance];
                
    });

    CGImageRelease(dstImage);

}




- (NSArray*)getRGBAsFromImage:(CGImageRef)image atX:(int)xx andY:(int)yy count:(int)count
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = image;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    for (int ii = 0 ; ii < count ; ++ii)
    {
        CGFloat red   = (rawData[byteIndex]     * 1.0) ;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) ;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) ;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) ;
        
        //NSLog(@"R: %f G: %f B: %f A: %f", red, green, blue, alpha);
        byteIndex += 4;
        
        UIColor *acolor = [UIColor colorWithRed:red /255.0f green:green /255.0f blue:blue /255.0f alpha:alpha];
        [result addObject:acolor];
    }
    
    free(rawData);
    
    return result;
}

- (CGImageRef) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer // Create a CGImageRef from sample buffer data
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);        // Lock the image buffer
    
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);   // Get information of the image
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    CGContextRelease(newContext);
    
    CGColorSpaceRelease(colorSpace);
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    return newImage;

}

- (NSString *) htmlFromUIColor:(UIColor *)_color {
    if (CGColorGetNumberOfComponents(_color.CGColor) == 4) {
        const CGFloat *components = CGColorGetComponents(_color.CGColor);
        _color = [UIColor colorWithRed:components[0] green:components[0] blue:components[0] alpha:components[1]];
    }
    if (CGColorSpaceGetModel(CGColorGetColorSpace(_color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    //http://dribbble.com/colors/A0D547?percent=35&variance=55
    
    
    return [NSString stringWithFormat:@"%02X%02X%02X", (int)((CGColorGetComponents(_color.CGColor))[0]*255.0), (int)((CGColorGetComponents(_color.CGColor))[1]*255.0), (int)((CGColorGetComponents(_color.CGColor))[2]*255.0)];
}

-(void)getidsforcolor:(NSString *)apiurl{
    
    [self.captureSession removeOutput:dataOutput];
    

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    DRPColorResultsController *CRC = [segue destinationViewController];

if ([segue.identifier isEqualToString: @"Picker to results"]) {
    
    CRC.passed_url = hex_string;
}

   
}


@end
