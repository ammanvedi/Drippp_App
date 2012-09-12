//
//  UIImage+Uiimage_Picker.m
//  Drippp_v2
//
//  Created by Amman on 05/09/2012.
//  Copyright (c) 2012 Amman. All rights reserved.
//

#import "UIImage+Picker.h"


@implementation UIImage (Picker)

- (UIColor *)colorAtPosition:(CGPoint)position {
    
    CGRect sourceRect = CGRectMake(position.x, position.y, 1.f, 1.f);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, sourceRect);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *buffer = malloc(4);
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
    CGContextRef context = CGBitmapContextCreate(buffer, 1, 1, 8, 4, colorSpace, bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0.f, 0.f, 1.f, 1.f), imageRef);
    CGContextRelease(context);
    
    CGFloat r = buffer[0] / 255.f;
    CGFloat g = buffer[1] / 255.f;
    CGFloat b = buffer[2] / 255.f;
    CGFloat a = buffer[3] / 255.f;
    
    NSLog(@"Red: %f green: %f blue: %f alpha: %f", r, g, b, a);
    
    free(buffer);
    
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

@end
