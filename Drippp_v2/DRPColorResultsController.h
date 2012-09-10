//
//  DRPColorResultsController.h
//  Drippp_v2
//
//  Created by Amman on 08/09/2012.
//  Copyright (c) 2012 Amman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRPColorResultsTableView.h"

@interface DRPColorResultsController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *passed_ids;
    NSString *passed_url;
}

@property (weak, nonatomic) IBOutlet DRPColorResultsTableView *main_table_view;
@property (nonatomic, strong) NSMutableArray *passed_ids;
@property (nonatomic, strong) NSMutableArray *results_images;
@property (nonatomic, strong) NSString *passed_url;
@property (nonatomic, strong) NSMutableArray *colorshotsarray ;
@property (nonatomic, strong) NSMutableArray *colorimagesarray ;
@property (nonatomic, strong) NSObject *colorpassData;


@end
