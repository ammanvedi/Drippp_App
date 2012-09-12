//
//  DRPCommentsCell.m
//  Drippp_v2
//
//  Created by Amman on 10/09/2012.
//  Copyright (c) 2012 Amman. All rights reserved.
//

#import "DRPCommentsCell.h"

@implementation DRPCommentsCell
@synthesize Comment_Body_Textview;
@synthesize avatarimageview;
@synthesize name_label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
