//
//  DRPShotViewController.h
//  Drippp_v2
//
//  Created by Amman on 25/08/2012.
//  Copyright (c) 2012 Amman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRPShotViewController : UIViewController <UIScrollViewDelegate ,UITableViewDataSource, UITableViewDelegate>{
    NSObject *passedData;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Loading_Image;
@property (nonatomic, strong) NSObject *passedData;

@property (weak, nonatomic) IBOutlet UIImageView *shot_imageview;

@property (strong) UIImage *main_shot;

@property (strong)NSData *shot_data;

@property (strong)NSMutableArray *Commentsarray;

@property (strong)NSMutableArray *AvatarCommentsArray;

@property (weak, nonatomic) IBOutlet UIScrollView *Image_scrollview;

@property (weak, nonatomic) IBOutlet UITableView *comments_table_view;

@property (weak, nonatomic) IBOutlet UIScrollView *enclosing_scrollview;

-(void) get_shot;

@end
