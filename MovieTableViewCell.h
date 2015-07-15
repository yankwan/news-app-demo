//
//  MovieTableViewCell.h
//  JnuNews
//
//  Created by liuyanjun on 7/13/15.
//  Copyright (c) 2015 JiNan University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieSubLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moviePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieStyleLabel;



- (void)configureForMovieCell:(NSArray *)newsItem;

@end
