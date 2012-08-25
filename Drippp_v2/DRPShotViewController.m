//
//  DRPShotViewController.m
//  Drippp_v2
//
//  Created by Amman on 25/08/2012.
//  Copyright (c) 2012 Amman. All rights reserved.
//

#import "DRPShotViewController.h"

@interface DRPShotViewController ()

@end

@implementation DRPShotViewController

@synthesize passedData;

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
    
    NSLog(@"%@", [passedData valueForKeyPath:@"player.username"] );
    
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
