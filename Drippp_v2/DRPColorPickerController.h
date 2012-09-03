//
//  DRPColorPickerController.h
//  Drippp_v2
//
//  Created by Amman on 03/09/2012.
//  Copyright (c) 2012 Amman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRPColorPickerController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *Image_Picker;
@property (nonatomic, strong) UIImage *capImage;


- (IBAction)Take_Pic:(id)sender;

@end
