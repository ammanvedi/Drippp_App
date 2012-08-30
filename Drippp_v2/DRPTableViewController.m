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

@synthesize urlsarray;
@synthesize images;
@synthesize page;
@synthesize passData;

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
    

    
  //  [self.tableView setContentOffset:CGPointMake(0.0f, 300.0f) animated:YES];

    

     
}

- (void)viewDidUnload
{
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
    
    [cell.image_holder_main setImageWithURL:[NSURL URLWithString:[[self.urlsarray objectAtIndex:[indexPath row]] objectForKey:@"image_teaser_url"]]];

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

    NSLog(@"%@", @"-------NPA------");
    
    NSLog(@"%@", nextpagearray);
    
    NSLog(@"%@", @"-------ENDNPA------");
    
    NSLog(@"%@", @"-------URLSARRAYB4------");
    
    NSLog(@"%@", nextpagearray);
    
    NSLog(@"%@", @"-------ENDURLSARRAYB4------");
    

    
    [self.urlsarray addObjectsFromArray: nextpagearray];
    
    NSLog(@"%@", @"-------URLSARRAYAFTER------");
    
    NSLog(@"%@", nextpagearray);
    
    NSLog(@"%@", @"-------ENDURLSARRAYAFTER------");
    

    NSLog(@"%@", [NSString stringWithFormat:@"%d", [self.urlsarray count]]);
    
    [self.tableView reloadData];
    
    page++;
    NSLog(@"%d", page);
    NSLog(@"%@", urlstring);
}

- (IBAction)Clicked_More:(id)sender {
    
    [NSThread detachNewThreadSelector:@selector(get_next_page) toTarget:self withObject:nil];
    
    
    //[self get_next_page];
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




@end
