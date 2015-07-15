//
//  DetailViewController.h
//  JnuNews
//
//  Created by liuyanjun on 7/10/15.
//  Copyright (c) 2015 JiNan University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet UINavigationItem *newsTitle;
@property (weak, nonatomic) IBOutlet UIWebView *newsContent;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;


- (IBAction)saveNews:(id)sender;


@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, strong) NSString *publishTime;
@property (nonatomic, strong) NSString *moduleName;


@end
