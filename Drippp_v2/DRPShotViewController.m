//
//  DRPShotViewController.m
//  Drippp_v2
//
//  Created by Amman on 25/08/2012.
//  Copyright (c) 2012 Amman. All rights reserved.
//

#import "DRPShotViewController.h"
#import "DRPColorResultsTableView.h"

@interface DRPShotViewController ()

@end

@implementation DRPShotViewController

@synthesize Loading_Image;
@synthesize passedData;
@synthesize shot_imageview;
@synthesize  main_shot;
@synthesize shot_data;
@synthesize Image_scrollview;

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
    
    [Image_scrollview setDelegate:self];
    main_shot = [[UIImage alloc] init];
    shot_data = [[NSData alloc] init];
    
    NSLog(@"%@", @"from vC");
    NSLog(@"%@", [passedData valueForKeyPath:@"player.name"] );
    NSLog(@"%@", @"from vC");
    
    [Loading_Image startAnimating];
    [Loading_Image setHidesWhenStopped:YES];
    [Loading_Image setHidden:NO];
    
    [NSThread detachNewThreadSelector:@selector(get_shot) toTarget:self withObject:nil];
    
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setShot_imageview:nil];
    [self setLoading_Image:nil];
    [self setImage_scrollview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) get_shot{
    
    shot_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[passedData valueForKeyPath:@"image_url"]]];
    main_shot = [UIImage imageWithData:shot_data];
    
    [shot_imageview setImage:main_shot];
    
    [Loading_Image stopAnimating];
    
    
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return shot_imageview;
}

@end
