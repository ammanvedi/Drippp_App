//
//  UINavigationBar+JTDropShadow.m
//  Drippp_v2
//
//  Created by Amman on 06/09/2012.
//  Copyright (c) 2012 Amman. All rights reserved.
//

#import "UINavigationBar+JTDropShadow.h"
#import <QuartzCore/QuartzCore.h>

@implementation UINavigationBar (JTDropShadow)

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity {
    
    // Creating shadow path for better performance
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    
    CGRect shadowPath = CGRectMake(self.layer.bounds.origin.x-10,self.layer.bounds.size.height - 6, self.layer.bounds.size.width +20, 5);
    
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowPath].CGPath;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
    
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    self.clipsToBounds = NO;
    
}

@end
