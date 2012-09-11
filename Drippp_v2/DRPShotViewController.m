//
//  DRPShotViewController.m
//  Drippp_v2
//
//  Created by Amman on 25/08/2012.
//  Copyright (c) 2012 Amman. All rights reserved.
//

#import "DRPShotViewController.h"
#import "DRPColorResultsTableView.h"
#import "DRPCommentsCell.h"

@interface DRPShotViewController ()

@end

@implementation DRPShotViewController

@synthesize Loading_Image;
@synthesize passedData;
@synthesize shot_imageview;
@synthesize  main_shot;
@synthesize shot_data;
@synthesize Image_scrollview;
@synthesize comments_table_view;
@synthesize enclosing_scrollview;
@synthesize Commentsarray;
@synthesize AvatarCommentsArray;

bool have_comments = false;
bool have_avatars = false;

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
    
    [self.enclosing_scrollview setContentSize:CGSizeMake(320, 600)];
    
    [self.comments_table_view setDelegate:self];
    [self.comments_table_view setDataSource:self];
    
    [Image_scrollview setDelegate:self];
    main_shot = [[UIImage alloc] init];
    shot_data = [[NSData alloc] init];
    
    Commentsarray = [[NSMutableArray alloc] init];
    AvatarCommentsArray = [[NSMutableArray alloc] init];
    
    NSLog(@"%@", @"from vC");
    NSLog(@"%@", [passedData valueForKeyPath:@"player.name"] );
    NSLog(@"%@", @"from vC");
    
    [Loading_Image startAnimating];
    [Loading_Image setHidesWhenStopped:YES];
    [Loading_Image setHidden:NO];
    
    [NSThread detachNewThreadSelector:@selector(get_shot) toTarget:self withObject:nil];
    
    NSLog(@"Comments count: %@", [passedData valueForKey:@"comments_count"]);
    
    if ([[passedData valueForKey:@"comments_count"] integerValue] == 0 ) {
        NSLog(@"did not parse comments");
    }else{
        [NSThread detachNewThreadSelector:@selector(get_and_parse_comments) toTarget:self withObject:nil];

    }

    

    
    
    
	// Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated{
    [self setAvatarCommentsArray:nil];
    [self setCommentsarray:nil];
    have_avatars = false;
    have_comments = false;
}

- (void)viewDidUnload
{
    [self setShot_imageview:nil];
    [self setLoading_Image:nil];
    [self setImage_scrollview:nil];
    [self setComments_table_view:nil];
    [self setEnclosing_scrollview:nil];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (have_comments) {
        return [Commentsarray count];
    }
    return 5;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //all cells need to be 240px high so return 240px to be sure of this
    //could just set in code but this allows me to be sure of the value being set 100%
    return 76.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Comment Cell";
    DRPCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (have_comments) {
        
        [cell.Comment_Body_Textview setText:[[Commentsarray objectAtIndex:[indexPath row]] objectForKey:@"body"]];
        
        if (have_avatars) {
            [cell.avatarimageview setImage:[AvatarCommentsArray objectAtIndex:[indexPath row]]];
        }
    }
    
    return cell;
}

-(void) get_and_parse_comments{
    
    NSError *jsonerror;
    
    NSString *apicommentstring = [[NSString alloc] initWithFormat:@"http://api.dribbble.com/shots/%@/comments?per_page=50", [passedData valueForKeyPath:@"id"]];
    NSData *jsondataset = [NSData dataWithContentsOfURL:[NSURL URLWithString:apicommentstring]];
    //load a dictionary with response data
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsondataset options:kNilOptions error:&jsonerror];
    [Commentsarray addObjectsFromArray:[json objectForKey:@"comments"]];
    NSLog(@"count: %i", [Commentsarray count]);
    
    
    for (int x = 0; x<=([Commentsarray count] - 1); x++) {
        NSLog(@"%@", [[Commentsarray objectAtIndex:x] objectForKey:@"body"]);
        NSLog(@"count: %i", x);
    }

    have_comments = true;
    
    [self performSelectorOnMainThread:@selector(update_tableview_on_main) withObject:nil waitUntilDone:NO];
    [NSThread detachNewThreadSelector:@selector(get_comment_avatars) toTarget:self withObject:nil];
    
}

-(void)get_comment_avatars{
    
    UIImage *phavatar = [UIImage imageNamed:@"ph.png"];
    
    for (int x = 0; x<=([Commentsarray count] - 1); x++) {
        NSLog(@"%@",[[Commentsarray objectAtIndex:x] valueForKeyPath:@"player.avatar_url"] );
        
        NSData *avatardata = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[Commentsarray objectAtIndex:x] valueForKeyPath:@"player.avatar_url"]]];
        
        UIImage *avatarimage = [UIImage imageWithData:avatardata];
        NSLog(@"count: %i", x);
        
        if (avatarimage != nil) {
            [AvatarCommentsArray addObject:avatarimage];
        }else{
            [AvatarCommentsArray addObject:phavatar];
        }
        
    }
    have_avatars = true;
        [self performSelectorOnMainThread:@selector(update_tableview_on_main) withObject:nil waitUntilDone:NO];
}

-(void)update_tableview_on_main{
        [self.comments_table_view reloadData];
}

@end
