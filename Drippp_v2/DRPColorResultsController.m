//
//  DRPColorResultsController.m
//  Drippp_v2
//
//  Created by Amman on 08/09/2012.
//  Copyright (c) 2012 Amman. All rights reserved.
//

#import "DRPColorResultsController.h"
#import "DRPColorResultsCell.h"
#import "DRPShotViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DRPColorResultsController ()

@end

@implementation DRPColorResultsController
@synthesize main_table_view;
@synthesize passed_ids;
@synthesize passed_url;
@synthesize results_images;
@synthesize colorshotsarray;
@synthesize colorimagesarray;
@synthesize colorpassData;

bool have_images = false;
bool have_ids = false;

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
    [main_table_view setDelegate:self];
    [main_table_view setDataSource:self];
    passed_ids = [[NSMutableArray alloc] init];
    //test case
    //passed_url =@"http://dribbble.com/colors/C417D0?percent=35&variance=50";
    [NSThread detachNewThreadSelector:@selector(getidsforcolor:) toTarget:self withObject:passed_url];
    colorshotsarray = [[NSMutableArray alloc] init];
    colorimagesarray = [[NSMutableArray alloc] init];
    
	// Do any additional setup after loading the view.
    //[main_table_view setFrame:CGRectMake(0, 240, 320, 240)];
}

-(void) viewWillDisappear:(BOOL)animated{
    
   // [self setColorimagesarray:nil];
   // [self setColorshotsarray:nil];
    NSLog(@"%@", @"will dissapear tbview");
    //have_images = false;
    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        have_images = false;
    }

}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.main_table_view reloadData];
    NSLog(@"%i", have_images);
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (have_images == true) {
       return [colorimagesarray count];
    }else{
        return 1;
    } 
    
    

}



-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //all cells need to be 240px high so return 240px to be sure of this
    //could just set in code but this allows me to be sure of the value being set 100%
    return 240.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Color_result_cell";
    DRPColorResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    

    if (have_images == true) {
        [cell.result_imageview setImage:[colorimagesarray objectAtIndex:[indexPath row]]];
    }

    

    

    
    return cell;
}

- (void)viewDidUnload
{
    [self setMain_table_view:nil];
    [super viewDidUnload];
    NSLog(@"%@", @"did unload tbview");
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)getidsforcolor:(NSString *)apiurl{
    

    
    NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiurl] encoding:NSStringEncodingConversionAllowLossy error:nil];
    
    NSLog(@"%@",apiurl);
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:html];
    
    
    NSString *buffer;
    NSString *idofshot;
    
    for (int parsecount = 0; parsecount <=10; parsecount++) {
        

        
        @try {
            [scanner scanUpToString:@"<li id=\"screenshot-" intoString:&buffer];
            [scanner setScanLocation:scanner.scanLocation + 19];
            [scanner scanUpToString:@"\"" intoString:&idofshot];
            [passed_ids addObject:idofshot];
            NSLog(@"ID: %@", idofshot);
        }
        @catch (NSException *exception) {
            break;
        }

    }

    
    
    [self getresultsimages];
    
}

-(void) getresultsimages{
    
     NSError *jsonerror;
    NSLog(@"count initial: %i", [colorshotsarray count]);
    for (int x =0; x <= [passed_ids count]-1; x++) {
        NSString *apistring = [[NSString alloc] initWithFormat:@"http://api.dribbble.com/shots/%@", [passed_ids objectAtIndex:x]];
        NSData *jsondataset = [NSData dataWithContentsOfURL:[NSURL URLWithString:apistring]];
        //load a dictionary with response data
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsondataset options:kNilOptions error:&jsonerror];
        [colorshotsarray addObject:json];
         NSLog(@"count: %i", [colorshotsarray count]);
    }
    
    for (int x =0; x <= [passed_ids count]-1; x++){
        NSData *imagedata = [NSData dataWithContentsOfURL: [NSURL URLWithString:[[self.colorshotsarray objectAtIndex:x] objectForKey:@"image_teaser_url"]]];
        
        UIImage *colorsearchimage = [UIImage imageWithData:imagedata];
        
        [colorimagesarray addObject:colorsearchimage];
        NSLog(@"count: %i", [colorimagesarray count]);
    }
    
    have_images = true;
    
    [self.main_table_view reloadData];
    //have json data now can download images
   
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //create a obect to enable referral to the destinationviewcontroller (DVC)
    DRPShotViewController *DRPSVC = [segue destinationViewController];
    //determine which segue has been called
    if ([segue.identifier isEqualToString: @"color result to view shot"]) {
        //assign property of DVC to nsdata object
        //allows all data about a shot to be passed in one package at one time
        DRPSVC.passedData = colorpassData;
        NSLog(@"prep segue");
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //when a user clicks a cell the object of data that corresponds to that cell is passed
    colorpassData = [colorshotsarray objectAtIndex:[indexPath row]];
    //For Debug
    
    NSLog(@"indexpath %i", [indexPath row]);
    return indexPath;
}


@end
