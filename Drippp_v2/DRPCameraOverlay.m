//
//  DRPCameraOverlay.m
//  Drippp_v2
//
//  Created by Amman on 03/09/2012.
//  Copyright (c) 2012 Amman. All rights reserved.
//

#import "DRPCameraOverlay.h"

@interface DRPCameraOverlay ()

@end

@implementation DRPCameraOverlay

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20.0f, 20.0f)];
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

@end
