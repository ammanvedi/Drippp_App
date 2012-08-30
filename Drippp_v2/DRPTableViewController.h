//
//  DRPTableViewController.h
//  Drippp_v2
//
//  Created by Amman on 20/08/2012.
//  Copyright (c) 2012 Amman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface DRPTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *urlsarray;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic) int page;
@property (nonatomic, strong) NSObject *passData;


-(void) get_next_page;
- (IBAction)Clicked_More:(id)sender;

@end
