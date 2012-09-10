//
//  DRPShotViewController.h
//  Drippp_v2
//
//  Created by Amman on 25/08/2012.
//  Copyright (c) 2012 Amman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRPShotViewController : UIViewController <UIScrollViewDelegate>{
    NSObject *passedData;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Loading_Image;
@property (nonatomic, strong) NSObject *passedData;

@property (weak, nonatomic) IBOutlet UIImageView *shot_imageview;

@property (strong) UIImage *main_shot;

@property (strong)NSData *shot_data;

@property (weak, nonatomic) IBOutlet UIScrollView *Image_scrollview;

-(void) get_shot;

@end
