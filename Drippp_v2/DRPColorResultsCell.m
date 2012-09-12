//
//  DRPColorResultsCell.m
//  Drippp_v2
//
//  Created by Amman on 09/09/2012.
//  Copyright (c) 2012 Amman. All rights reserved.
//

#import "DRPColorResultsCell.h"

@implementation DRPColorResultsCell
@synthesize result_imageview;

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
