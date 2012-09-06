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
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Picker.h"
#import <CoreImage/CoreImage.h>
#import <dispatch/dispatch.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Accelerate/Accelerate.h>


@interface DRPColorPickerController ()

@end

@implementation DRPColorPickerController

@synthesize Image_Picker;
@synthesize capImage;
@synthesize subimgview;
@synthesize Camera_Button;
@synthesize idsarray;
@synthesize Camera_Image_View;
@synthesize timer;



int variance = 50;
int minimum = 35;

int count = 0;

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


}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"%@", @"will appear");
    
    
}

- (void)viewDidUnload
{
    [self setCamera_Button:nil];
    [self setCamera_Image_View:nil];
    [self setSubimgview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setCapImage:nil];
    NSLog(@"%@", @"didunload");

}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"%@", @"didunload");
    
    [super viewDidUnload];
    [self setCamera_Button:nil];
    [self setCamera_Image_View:nil];
    [self setSubimgview:nil];
    [self setCapImage:nil];
    [self.captureSession stopRunning];
    [self setCaptureSession:nil];
    [self setIdsarray:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)Take_Pic:(id)sender {
    
    
    img = [[UIImage alloc] init];
    
    // Create the capture session
    captureSession = [AVCaptureSession new];
    [captureSession setSessionPreset:AVCaptureSessionPresetLow];
    
    // Capture device
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Device input
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    if ( [captureSession canAddInput:deviceInput] ){
        [captureSession addInput:deviceInput];
    }
    
    
    
    AVCaptureVideoDataOutput *dataOutput = [AVCaptureVideoDataOutput new];
    dataOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA] forKey:(NSString *)kCVPixelBufferPixelFormatTypeKey];
    [dataOutput setAlwaysDiscardsLateVideoFrames:YES];
    
    [[dataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
    
    if ( [captureSession canAddOutput:dataOutput]){
        [captureSession addOutput:dataOutput];
    }
    
    customPreviewLayer = [CALayer layer];
    customPreviewLayer.bounds = CGRectMake(0, 0, self.Camera_Image_View.frame.size.height, self.Camera_Image_View.frame.size.width);
    customPreviewLayer.position = CGPointMake(self.view.frame.size.width/2., self.view.frame.size.height/2.);
    customPreviewLayer.affineTransform = CGAffineTransformMakeRotation(M_PI/2);
    
    AVCPL = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    AVCPL.frame = self.Camera_Image_View.bounds;
    [self.Camera_Image_View.layer addSublayer:AVCPL];
    
    
    dispatch_queue_t queue = dispatch_queue_create("VideoQueue", DISPATCH_QUEUE_SERIAL);
    
    [dataOutput setSampleBufferDelegate:self queue:queue];
    
    [captureSession startRunning];
    
    img = [UIImage imageWithCGImage:(__bridge CGImageRef)(customPreviewLayer.contents)];
    
    NSLog(@"%@", @"did load");

}
 



-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{

    
    CGImageRef dstImage = [self imageFromSampleBuffer:sampleBuffer];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        customPreviewLayer.contents = (__bridge id)dstImage;
        [self.Camera_Image_View setBackgroundColor:[[self getRGBAsFromImage:dstImage atX:50 andY:50 count:1] objectAtIndex:0]];
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
        
        NSLog(@"R: %f G: %f B: %f A: %f", red, green, blue, alpha);
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


@end
