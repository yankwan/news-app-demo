//
//  FrontTableViewCell.m
//  JnuNews
//
//  Created by liuyanjun on 6/25/15.
//  Copyright (c) 2015 JiNan University. All rights reserved.
//

#import "FrontTableViewCell.h"

@implementation FrontTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectZero];
    selectedView.backgroundColor = [UIColor colorWithRed:20/255.0f green:160/255.0f blue:160/255.0f alpha:0.25f];
    self.selectedBackgroundView = selectedView;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
