//
//  DRPTableViewController.m
//  Drippp_v2
//
//  Created by Amman on 20/08/2012.
//  Copyright (c) 2012 Amman. All rights reserved.
//


/*
 This code is annotated in most places, if any clarification is needed
 contact me (Amman Vedi) via:
 
 email  : amman.vedi@gmail.com
 twitter: @ammanvedi
 
*/


#import "DRPTableViewController.h"
#import "DRPCell_main.h"
#import "UIImageView+AFNetworking.h"
#import "DRPShotViewController.h"
#import "DRPColorPickerController.h"
#import <MobileCoreServices/MobileCoreServices.h> 

@interface DRPTableViewController ()

@end

@implementation DRPTableViewController

@synthesize Refresh_Button;
@synthesize nav_item;
@synthesize urlsarray;
@synthesize images;
@synthesize page;
@synthesize passData;
@synthesize PRGView;
@synthesize api_category;



bool threaddone = false;
int arraycount = 0;
const int perpage = 5;
int lower = perpage;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    api_category = @"popular";
    
    //the variable "page" will increment each time a new page of the api data is loaded
    //the value is used to pass the "page" parameter in the HTTP url request
    //incremented after page data has been gathered so its initial value must be 2
    self.page = 2;
    UIImage *leftbuttonimage = [UIImage imageNamed:@"camera.png"];
    CGRect frameleftimage = CGRectMake(0, 0, leftbuttonimage.size.width, leftbuttonimage.size.width);
    UIButton *leftbutton = [[UIButton alloc] initWithFrame:frameleftimage];
    [leftbutton setBackgroundImage:leftbuttonimage forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(display_color_picker) forControlEvents:UIControlEventTouchUpInside];
    [leftbutton setShowsTouchWhenHighlighted:YES];
    
    
    UIBarButtonItem *cameraBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];

    
    [[self navigationItem] setLeftBarButtonItem:cameraBarButtonItem];
    
    UIImage *rightbuttonimage = [UIImage imageNamed:@"refresh.png"];
    CGRect framerightimage = CGRectMake(0, 0, rightbuttonimage.size.width, rightbuttonimage.size.width);
    UIButton *rightbutton = [[UIButton alloc] initWithFrame:framerightimage];
    [rightbutton setBackgroundImage:rightbuttonimage forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(Clicked_More:) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton setShowsTouchWhenHighlighted:YES];
    
    [Refresh_Button setCustomView:rightbutton];
    
    //init arrays
    //images: holds the images from Teaser_Url from api Json Data
    //Urlsarray: holds all the obects that are parsed from the JSON api response
    images = [[NSMutableArray alloc] init];
    urlsarray = [[NSMutableArray alloc] init];
    
    
    //TO-DO thread this process, so it doesnt hang the UI
    
    NSError *jsonerror;
    //get data for first page
    NSString *apistring = [[NSString alloc] initWithFormat:@"http://api.dribbble.com/shots/%@?per_page=%i", api_category ,perpage];
    NSData *jsondataset = [NSData dataWithContentsOfURL:[NSURL URLWithString:apistring]];
    //load a dictionary with response data
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsondataset options:kNilOptions error:&jsonerror];
    //the actual objects containing shot data and player data are stored in an array within
    //the "shots" JSON bject here i am putting this data in an array
    NSArray *shotsarray = [json objectForKey:@"shots"];
    
    //for Debug
    
    /*
    for (int n = 1; n <= perpahe; n = n + 1) {
        NSLog(@"%@", [[[shotsarray objectAtIndex: n] objectForKey:@"player"] objectForKey:@"twitter_screen_name"]);
        NSLog(@"%@", [[shotsarray objectAtIndex: n] objectForKey:@"image_url"] );
        NSLog(@"%@", [[shotsarray objectAtIndex:n] objectForKey:@"image_teaser_url"]);
        NSLog(@"%@", @"<------------------------ end data dump -------------------------->");
       

    }
     
     */
    
    //pass the array shotsarry to the global property urlsarray
    self.urlsarray = [[NSMutableArray alloc] initWithArray:shotsarray];
    //create a thread and download the images
    //asyncloadimages is the method that is called to get the initial page/JSON data set
    [NSThread detachNewThreadSelector:@selector(asyncloadimages) toTarget:self withObject:nil];

}



- (void)viewDidUnload
{
    //TO-DO determine when called setnil accordingly
    
    [self setRefresh_Button:nil];
    [self setNav_item:nil];
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //keep the interface portrait
    //plans to handle any landscape orientation will come in later versions
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //when further pages are fetched the array will become larger (mutable)
    //so the number of rows needs to be returned asa new (larger) value
    //this method is invoked on the call of [self.tableview reload]
    return [self.urlsarray count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //set up the dynamic tableview
    
    static NSString *CellIdentifier = @"drippp_cell_main";
    DRPCell_main *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell.AIView startAnimating];
    
    if (threaddone == true) {
        
        [cell.makeLabel setHidden:NO];

        if (cell.AIView.isAnimating) {
            [cell.AIView stopAnimating];
        }
        
        if (cell.AIView.hidden == NO) {
            [cell.AIView setHidden:YES];
        }
        
        if (cell == nil) {
            cell = [[DRPCell_main alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier];
        }
        
        //care must be taken with what is placed in this method because
        //1: this is on the main thread any heavy input will prevent the ui updating leading to unresponsive UI
        //2. this method is invoked ALOT, almost everytime a cell is drawn
        
        //set the label to the name of the artist / player / creator
        cell.makeLabel.text =  [[[self.urlsarray objectAtIndex: [indexPath row]] objectForKey:@"player"] objectForKey:@"name"];
        //set image of the cell from the array.
        //the array essentially acts as a cache,
        //with the advantage that it doesnt get purged when the app enters background ect.
        [cell.image_holder_main setImage:[images objectAtIndex:[indexPath row]]];
    }else{
        
        [cell.makeLabel setHidden:YES];
        
    }
    


    
    return cell;
}





#pragma mark - Table view delegate



-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //all cells need to be 240px high so return 240px to be sure of this
    //could just set in code but this allows me to be sure of the value being set 100%
    return 240.0f;
}

-(void) get_next_page{
    

    //for debug
    NSLog(@"%@", @"Getting next page");
    NSError *jsongetnextpageerror;
    NSString *urlstring;
    
    //url for json request with html param "page" from the variable "page"
    urlstring = [NSString stringWithFormat:@"http://api.dribbble.com/shots/%@?per_page=%i&page=%d", api_category ,perpage, page];
    //data object for json data
    NSData *jsondatasetfornextpage = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlstring]];
    //dictionary for data
    NSDictionary *jsonfromnextpage = [NSJSONSerialization JSONObjectWithData:jsondatasetfornextpage options:kNilOptions error:&jsongetnextpageerror];
    //array for new data from page
    NSArray *nextpagearray = [jsonfromnextpage objectForKey:@"shots"];
    //add the data from the new page to the end of the main daat holding array "urlsarray"
    [self.urlsarray addObjectsFromArray: nextpagearray];
    //For Debug
    NSLog(@"%@", [NSString stringWithFormat:@"%d", [self.urlsarray count]]);
    
    //this loop will download the image data for the next page of images
    //add it to the end of the image array
    //call an update to the progressview
    for (int x=lower; x<=lower+(perpage - 1); x++) {
        
        
        NSData *imagedata = [NSData dataWithContentsOfURL: [NSURL URLWithString:[[self.urlsarray objectAtIndex:x] objectForKey:@"image_teaser_url"]]];
        
        UIImage *imagefromasync = [UIImage imageWithData:imagedata];
        
        [images insertObject:imagefromasync atIndex:x];
        //For Debug
        NSLog(@"%u", [images count]);
        //this next line calls the methid to update the progrssview, however due to the fact that
        //currently it is called from a "parralel" thread, so this will call it in the main thread
        //solving the problem of UI updates not being allwed to happen anywhere except in the main thread 
        [self performSelectorOnMainThread:@selector(updateprgview) withObject:nil waitUntilDone:NO];
        //For Debug
        NSLog(@"%f", (PRGView.progress + (1/perpage)));
        
    }
    
    //setnil and reassign the title when the progressview has finished
    //which by this point it will have as the loop has ended
    nav_item.titleView = nil;

    
    //re enable the button
    [Refresh_Button setEnabled:true];
    
    //incerement the lower value
    lower += perpage;
    
    //call a reload of the tableview 
    [self.tableView reloadData];
    
    //increment the value of "page"
    page++;
    //For Debug
    NSLog(@"%d", page);
    NSLog(@"%@", urlstring);
}

- (IBAction)Clicked_More:(id)sender {
    
    //ibaction methid called on the button click of the refresh button
    [Refresh_Button setEnabled:false];
    //create a progressview for display in the navigationbar
    PRGView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    //initialize the progressview to 0 progress
    [PRGView setProgress:0.0f];
    //set the progressview to display
    nav_item.titleView = PRGView;
    //create and begin a thread to get the next page 
    [NSThread detachNewThreadSelector:@selector(get_next_page) toTarget:self withObject:nil];
    

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //create a obect to enable referral to the destinationviewcontroller (DVC)
    DRPShotViewController *DRPSVC = [segue destinationViewController];
    //determine which segue has been called
    if ([segue.identifier isEqualToString: @"MainTableSegue"]) {
        //assign property of DVC to nsdata object
        //allows all data about a shot to be passed in one package at one time
        DRPSVC.passedData = passData;
        NSLog(@"prep segue");
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //when a user clicks a cell the object of data that corresponds to that cell is passed
    passData = [urlsarray objectAtIndex:[indexPath row]];
    //For Debug
    NSLog(@"select row");
    return indexPath;
}

-(void) asyncloadimages{
    //method that is called to download the initial data
    
    for (int x=0; x<= (perpage - 1); x++) {
        //create data object
        NSData *imagedata = [NSData dataWithContentsOfURL: [NSURL URLWithString:[[self.urlsarray objectAtIndex:x] objectForKey:@"image_teaser_url"]]];
        //create image
        UIImage *imagefromasync = [UIImage imageWithData:imagedata];
        //add image to image array
        [images insertObject:imagefromasync atIndex:x];
        //For Debug
        NSLog(@"%u", [images count]);
    }
    
    //indicate that the thread has terminated/finished
    [self.tableView reloadData];
    
    threaddone = true;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_bg.png"]];
}

-(void)updateprgview{
    //Method to update the ProgressView
    //set it to increase by 1/30
    //i.e. one thirt-eth increase for each of 30 images to download
    
    float incr = PRGView.progress + (1.0f/(float)perpage);
    NSLog(@"incr: %f", incr);
    [PRGView setProgress:incr animated:YES];
}

-(void) display_color_picker{

    [self performSegueWithIdentifier:@"Color_picker_Segue" sender:nil];
    
}

@end
