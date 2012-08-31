//
//  DRPTableViewController.m
//  Drippp_v2
//
//  Created by Amman on 20/08/2012.
//  Copyright (c) 2012 Amman. All rights reserved.
//

#import "DRPTableViewController.h"
#import "DRPCell_main.h"
#import "UIImageView+AFNetworking.h"
#import "DRPShotViewController.h"

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


bool threaddone = false;
int arraycount = 0;
int lower = 30;


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
    
    

    self.page = 2;
    
    images = [[NSMutableArray alloc] init];
    urlsarray = [[NSMutableArray alloc] init];
    
    NSError *jsonerror;
     NSData *jsondataset = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://api.dribbble.com/shots/popular?per_page=30"]];
    
    //NSData *jsondataset = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dribble_response" ofType:@"json"]];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsondataset options:kNilOptions error:&jsonerror];
    
    NSArray *shotsarray = [json objectForKey:@"shots"];
    
    for (int n = 1; n <= 29; n = n + 1) {
        NSLog(@"%@", [[[shotsarray objectAtIndex: n] objectForKey:@"player"] objectForKey:@"twitter_screen_name"]);
        NSLog(@"%@", [[shotsarray objectAtIndex: n] objectForKey:@"image_url"] );
        NSLog(@"%@", [[shotsarray objectAtIndex:n] objectForKey:@"image_teaser_url"]);
        NSLog(@"%@", @"<------------------------ end data dump -------------------------->");
       

    }

    self.urlsarray = [[NSMutableArray alloc]
                      initWithArray:shotsarray];
    
    [NSThread detachNewThreadSelector:@selector(asyncloadimages) toTarget:self withObject:nil];

    while (threaddone ==false) {
        
    }
}



- (void)viewDidUnload
{
    
    [self setRefresh_Button:nil];
    [self setNav_item:nil];
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
    return [self.urlsarray count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    
    static NSString *CellIdentifier = @"drippp_cell_main";
    DRPCell_main *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[DRPCell_main alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }

    
    cell.makeLabel.text =  [[[self.urlsarray objectAtIndex: [indexPath row]] objectForKey:@"player"] objectForKey:@"name"];
    
   // [cell.image_holder_main setImageWithURL:[NSURL URLWithString:[[self.urlsarray objectAtIndex:[indexPath row]] objectForKey:@"image_teaser_url"]] placeholderImage:[UIImage imageNamed:@"ph.png"]];
    
    [cell.image_holder_main setImage:[images objectAtIndex:[indexPath row]]];

    
    return cell;
}





#pragma mark - Table view delegate



-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240.0f;
}

-(void) get_next_page{
    


    NSLog(@"%@", @"Getting next page");
    
    
    NSError *jsongetnextpageerror;
    
   
    
    NSString *urlstring;
    
    urlstring = [NSString stringWithFormat:@"http://api.dribbble.com/shots/popular?per_page=30&page=%d", page];
    
    
    
    NSData *jsondatasetfornextpage = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlstring]];
    
    
    NSDictionary *jsonfromnextpage = [NSJSONSerialization JSONObjectWithData:jsondatasetfornextpage options:kNilOptions error:&jsongetnextpageerror];
    
    NSArray *nextpagearray = [jsonfromnextpage objectForKey:@"shots"];

    [self.urlsarray addObjectsFromArray: nextpagearray];

    

    NSLog(@"%@", [NSString stringWithFormat:@"%d", [self.urlsarray count]]);
    
    
    for (int x=lower; x<=lower+29; x++) {
        
        
        NSData *imagedata = [NSData dataWithContentsOfURL: [NSURL URLWithString:[[self.urlsarray objectAtIndex:x] objectForKey:@"image_teaser_url"]]];
        
        UIImage *imagefromasync = [UIImage imageWithData:imagedata];
        
        [images insertObject:imagefromasync atIndex:x];
        
        NSLog(@"%u", [images count]);
                
        [self performSelectorOnMainThread:@selector(updateprgview) withObject:nil waitUntilDone:NO];
        
        //[self updateprgview];
        
         NSLog(@"%f", (PRGView.progress +0.03));
        
    }
    
    
    nav_item.titleView = nil;
    nav_item.title =@"drippp";
    
    [Refresh_Button setEnabled:true];
    
    lower += 30;
    
    [self.tableView reloadData];
    
    page++;
    NSLog(@"%d", page);
    NSLog(@"%@", urlstring);
}

- (IBAction)Clicked_More:(id)sender {
    
    [Refresh_Button setEnabled:false];
    
    PRGView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    
    [PRGView setProgress:0.0f];
    
    nav_item.titleView = PRGView;
    
    
    [NSThread detachNewThreadSelector:@selector(get_next_page) toTarget:self withObject:nil];
    

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    DRPShotViewController *DRPSVC = [segue destinationViewController];

    
    if ([segue.identifier isEqualToString: @"MainTableSegue"]) {
        DRPSVC.passedData = passData;
        NSLog(@"prep segue");
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    passData = [urlsarray objectAtIndex:[indexPath row]];
    NSLog(@"select row");
    return indexPath;
}

-(void) asyncloadimages{

    
    for (int x=0; x<=29; x++) {
        
        NSData *imagedata = [NSData dataWithContentsOfURL: [NSURL URLWithString:[[self.urlsarray objectAtIndex:x] objectForKey:@"image_teaser_url"]]];
        
        UIImage *imagefromasync = [UIImage imageWithData:imagedata];
        
        [images insertObject:imagefromasync atIndex:x];
        
        NSLog(@"%u", [images count]);
    }
    
    threaddone = true;
    
}

-(void)updateprgview{
    [PRGView setProgress: (PRGView.progress + 0.03f) animated:YES];
}

@end
