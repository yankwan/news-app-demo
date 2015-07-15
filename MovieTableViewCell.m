//
//  MovieTableViewCell.m
//  JnuNews
//
//  Created by liuyanjun on 7/13/15.
//  Copyright (c) 2015 JiNan University. All rights reserved.
//

#import "MovieTableViewCell.h"
#import <BmobSDK/Bmob.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation MovieTableViewCell

- (void)awakeFromNib {
    // Initialization code
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectZero];
    selectedView.backgroundColor = [UIColor colorWithRed:20/255.0f green:160/255.0f blue:160/255.0f alpha:0.25f];
    self.selectedBackgroundView = selectedView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.movieStyleLabel.layer.backgroundColor = [UIColor colorWithRed:81/255.0f green:227/255.0f blue:255/255.0f alpha:1.0f].CGColor;
    }
   
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.movieImageView cancelImageRequestOperation];
    self.movieNameLabel.text = nil;
    self.movieDateLabel.text = nil;
    self.movieSubLabel.text = nil;
    self.moviePriceLabel.text = nil;
    self.movieStyleLabel.text = nil;
}



- (void)configureForMovieCell:(BmobObject *)newsItem {

    self.movieNameLabel.text = [newsItem objectForKey:@"title"];
    self.movieSubLabel.text = [newsItem objectForKey:@"subTitle"];
    self.movieDateLabel.text = [newsItem objectForKey:@"date"];
    self.moviePriceLabel.text = [newsItem objectForKey:@"price"];
}

@end
