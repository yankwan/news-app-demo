//
//  FrontTableViewCell.h
//  JnuNews
//
//  Created by liuyanjun on 6/25/15.
//  Copyright (c) 2015 JiNan University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrontTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
