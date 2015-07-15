//
//  MovieDetailViewController.h
//  JnuNews
//
//  Created by liuyanjun on 7/14/15.
//  Copyright (c) 2015 JiNan University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleName;
@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UIWebView *movieContentView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@property (strong, nonatomic) NSString *movieName;
@end
