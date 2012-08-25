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
        
       // NSData *imagedata = [NSData dataWithContentsOfURL:[NSURL URLWithString:
                 //                                          [[shotsarray objectAtIndex:n] objectForKey:@"image_teaser_url"]]];
        
       // NSLog(@"%@", [[shotsarray objectAtIndex:n] objectForKey:@"image_teaser_url"]);
        
       // UIImage *addimage = [UIImage imageWithData:imagedata];

        
       // [images addObject:addimage];
      //  NSLog(@"%@", [NSString stringWithFormat:@"%d", [images count]]);
       // NSLog([images objectAtIndex:0]);
        
       

    }
    
    
    
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    

/*    self.urlsarray = [[NSArray alloc]
                     initWithObjects:@"one",
                     @"two",
                     @"three",
                     @"four",
                     @"five", nil];   */
    
    
    self.urlsarray = [[NSMutableArray alloc]
                      initWithArray:shotsarray];
    

    

     
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
        NSLog(@"%@", @"called num of rows");
    
    return [self.urlsarray count];
    //return 60;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%@", @"called cell for row at index path");
    static NSString *CellIdentifier = @"drippp_cell_main";
    

    
    DRPCell_main *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[DRPCell_main alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    cell.makeLabel.text =  [[[self.urlsarray objectAtIndex: [indexPath row]] objectForKey:@"player"] objectForKey:@"name"];

    
  //  NSData *imagedata = [NSData dataWithContentsOfURL:[NSURL URLWithString:
                                                     // [[self.urlsarray objectAtIndex: [indexPath row]] objectForKey:@"image_teaser_url"]]];
  //  NSLog(@"dohavedata");
    
    
    [cell.image_holder_main setImageWithURL:[NSURL URLWithString:[[self.urlsarray objectAtIndex:[indexPath row]] objectForKey:@"image_teaser_url"]]];
    
    
    
    
    
    //[cell.image_holder_main setImage:[images objectAtIndex:[indexPath row]-1]];
    
    
   // cell.image_holder_main
        
    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //passData = [urlsarray objectAtIndex:[indexPath row]];
    //NSLog(@"%@", [passData valueForKeyPath:@"player.username"] );
    //NSLog(@"select row");
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240.0f;
}

-(void) get_next_page{

    NSLog(@"%@", @"Getting next page");
    
    
    NSError *jsongetnextpageerror;
    
   
    
    NSString *urlstring;
    
    urlstring = [NSString stringWithFormat:@"http://api.dribbble.com/shots/popular?per_page=30&page=%d", page];
    
    
    
    NSData *jsondatasetfornextpage = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlstring]];
    
    //NSData *jsondataset = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dribble_response" ofType:@"json"]];
    
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
    
    [self get_next_page];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    DRPShotViewController *DRPSVC = [segue destinationViewController];
    
    if ([segue.identifier isEqualToString: @"MainTableSegue"]) {
        //TODO set/send variables or entire object
        //better to do whole object
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
